require("version.nut");
require("cargo.nut");
require("industry.nut");
require("town.nut");
require("company.nut");
require("story.nut");
require("strings.nut");

// Import SuperLib for GameScript
import("util.superlib", "SuperLib", 40);
Log <- SuperLib.Log;
Helper <- SuperLib.Helper;

// Import ToyLib
import("Library.GSToyLib", "GSToyLib", 1);
import("Library.SCPLib", "SCPLib", 45);

enum Randomization {
    NONE = 1,
    INDUSTRY_DESC = 2,
    INDUSTRY_ASC = 3,
    FIXED_1 = 4,
    FIXED_2 = 5,
    FIXED_3 = 6,
    FIXED_5 = 7,
    FIXED_7 = 8,
    RANGE_1_2 = 9,
    RANGE_1_3 = 10,
    RANGE_2_3 = 11,
    RANGE_3_5 = 12,
    RANGE_3_7 = 13
};

class MainClass extends GSController
{
    companies = null;
    towns = null;
    current_date = null;
    current_week = null;
    current_month = null;
    current_year = null;
    gs_init_done = null;
    load_saved_data = null;
    current_save_version = null;
    actual_town_info_mode = null;
    toy_lib = null;

    constructor() {
        this.companies = [];
        this.towns = null;
        this.current_date = 0;
        this.current_week = 0;
        this.current_month = 0;
        this.current_year = 0;
        this.gs_init_done = false;
        this.current_save_version = SELF_MAJORVERSION;    // Ensures compatibility between revisions
        this.load_saved_data = false;
        this.actual_town_info_mode = 0;
        this.toy_lib = null;
        ::TownDataTable <- {};
        ::CompanyDataTable <- {};
        ::SettingsTable <- {};
    }
}

function MainClass::Start()
{
    // Wait random number of ticks (less than one day) based on system time to ensure random number seed
    local sysdate = GSDate.GetSystemTime() % 70 + 1;
    this.Sleep(sysdate);

    // Initializing the script
    local start_tick = GSController.GetTick();

    // Read the openttd.cfg Town Growth Rate setting first.
    // If the map is set to disallow town growth at all, this script
    // won't do anything further.
    if (GSGameSettings.IsValid("town_growth_rate")) {
        if (! GSGameSettings.GetValue("town_growth_rate") ) {
            GSLog.Warning("You must set town growth in advanced setting to something other than None. This script is now exiting.");
            return;
        }
    }

    GSGame.Pause();
    Log.Info("Script initialisation...", Log.LVL_INFO);
    this.Init();
    GSGame.Unpause();

    local setup_duration = GSController.GetTick() - start_tick;
    Log.Info("Game setup done.", Log.LVL_INFO);
    Log.Info("Setup took " + setup_duration + " ticks.", Log.LVL_DEBUG);
    Log.Info("Happy playing !", Log.LVL_INFO);

    // Wait for the game to start
    GSController.Sleep(1);

    // Create and fill StoryBook. This can't be done before OTTD is ready.
    local story_editor = StoryEditor();
    story_editor.CreateStoryBook(this.towns.len());

    if (!this.gs_init_done) {
        GSLog.Error("Game initialisation failed, stopping the game script!");
        while(true){
            GSController.Sleep(30681); // sleep for a year
        }
    }

    // Main loop
    local past_system_time = GSDate.GetSystemTime();
    while (true) {
        local town_info_mode = GSController.GetSetting("town_info_mode");
        if (this.actual_town_info_mode != town_info_mode) {
            this.actual_town_info_mode = town_info_mode;
            foreach (town in this.towns) {
                town.UpdateTownText(this.actual_town_info_mode);
            }
            continue;
        }

        local system_time = GSDate.GetSystemTime();
        if (1 == this.actual_town_info_mode && system_time - past_system_time > 3) {
            past_system_time = system_time;

            foreach (town in this.towns) {
                town.UpdateTownText(this.actual_town_info_mode);
            }
        }

        this.HandleEvents();
        this.ManageTowns();
    }
}

function MainClass::Init()
{
    this.toy_lib = GSToyLib(null); // Init ToyLib;

    // Check game settings
    GSGameSettings.SetValue("economy.town_growth_rate", 2);
    GSGameSettings.SetValue("economy.fund_buildings", 0);

    if (!this.load_saved_data) { // Disallow changing these in a running game
        ::SettingsTable.use_town_sign <- GSController.GetSetting("use_town_sign");
        ::SettingsTable.randomization <- GSController.GetSetting("cargo_randomization");
        ::SettingsTable.display_cargo <- GSController.GetSetting("display_cargo");
    }

    // Set current date
    this.current_date = this.current_week = GSDate.GetCurrentDate();
    this.current_month = GSDate.GetMonth(this.current_date);
    this.current_year = GSDate.GetYear(this.current_date);

    if (::SettingsTable.randomization == Randomization.INDUSTRY_DESC
     || ::SettingsTable.randomization == Randomization.INDUSTRY_ASC) {
        InitIndustryLists();
    }
    else {
        // Initialize cargo lists and variables
        if (!InitCargoLists())
            return;
    }

    /* Check whether saved data are in the current save
     * format.
     */
    if (!this.load_saved_data) {
        Helper.ClearAllSigns();
    }

    // Create company list
    Log.Info("Creating company list ...", Log.LVL_INFO);
    this.companies = this.CreateCompanyList();

    // Create the towns list
    Log.Info("Creating town list ... (can take a while on large maps)", Log.LVL_INFO);
    this.towns = this.CreateTownList();
    if (this.towns.len() > SELF_MAX_TOWNS)
        return;

    // Run industry stabilizer
    Log.Info("Prospecting raw industries ... (can take a while on large maps)", Log.LVL_INFO);
    ProspectRawIndustry();

    // Ending initialization
    this.gs_init_done = true;
}

function MainClass::HandleEvents()
{
    while (GSEventController.IsEventWaiting()) {
        local event = GSEventController.GetNextEvent();

        if (event == null)
            return;

        switch (event.GetEventType()) {
        // On town founding, add a new GoalTown instance
        case GSEvent.ET_TOWN_FOUNDED:
            event = GSEventTownFounded.Convert(event);
            local town_id = event.GetTownID();
            if (GSTown.IsValidTown(town_id)) this.UpdateTownList(town_id);
            break;

        case GSEvent.ET_COMPANY_NEW:
        case GSEvent.ET_COMPANY_BANKRUPT:
        case GSEvent.ET_COMPANY_MERGER:
            Log.Info("A company was created/bankrupt/merged => update company list", Log.LVL_INFO);
            this.UpdateCompanyList();
            break;

        default: break;
        }
    }
}

function MainClass::Save()
{
    Log.Info("Saving data...", Log.LVL_INFO);
    local save_table = {};

    /* If the script isn't yet initialized, we can't retrieve data
     * from GoalTown instances. Thus, simply use the original
     * loaded table. Otherwise we build the table with town data.
     */
    save_table.company_data_table <- {};
    save_table.town_data_table <- {};
    if (!this.gs_init_done) {
        save_table.town_data_table <- ::TownDataTable;
    } else {
        // Save permanent settings (allows changing them in scenario editor)
        save_table.use_town_sign <- ::SettingsTable.use_town_sign;
        save_table.randomization <- ::SettingsTable.randomization;
        save_table.display_cargo <- ::SettingsTable.display_cargo;

        foreach (company in this.companies)
        {
            save_table.company_data_table[company.id] <- company.SavingCompanyData();
        }

        local start_opcodes = GSController.GetOpsTillSuspend();
        foreach (i, town in this.towns)
        {
            save_table.town_data_table[town.id] <- town.SavingTownData();
        }
        Log.Info("Ocodes per saved town = " + ((start_opcodes - GSController.GetOpsTillSuspend()) / this.towns.len()), Log.LVL_DEBUG);
        // Also store a savegame version flag
        save_table.save_version <- this.current_save_version;
    }

    return save_table;
}

function MainClass::Load(version, saved_data)
{
    Log.Info("Loading data...", Log.LVL_INFO);
    // Loading town data. Only load data if the savegame version matches.
    if ((saved_data.rawin("save_version") && saved_data.save_version == this.current_save_version)) {
        this.load_saved_data = true;
        ::SettingsTable.use_town_sign <- saved_data.use_town_sign;
        ::SettingsTable.randomization <- saved_data.randomization;
        ::SettingsTable.display_cargo <- saved_data.display_cargo;

        foreach (companyid, company_data in saved_data.company_data_table) {
            ::CompanyDataTable[companyid] <- company_data;
        }

        foreach (townid, town_data in saved_data.town_data_table) {
            ::TownDataTable[townid] <- town_data;
        }
    }
    else {
        Log.Info("Data format doesn't match with current version. Resetting.", Log.LVL_INFO);
    }
}

function MainClass::UpdateCompanyList()
{
    for(local c = GSCompany.COMPANY_FIRST; c <= GSCompany.COMPANY_LAST; c++)
    {
        local existing = null;
        local existing_idx = 0;
        foreach(index, company in this.companies)
        {
            if(company.id == c)
            {
                existing = company;
                existing_idx = index;
                break;
            }
        }

        if(GSCompany.ResolveCompanyID(c) == GSCompany.COMPANY_INVALID)
        {
            if(existing != null) {
                existing.RemoveGUIGoals();
                this.companies.remove(existing_idx);
            }

            continue;
        }

        // If the company can be resolved and exists => do anything
        if(existing != null) continue;

        // Initialize new company
        this.companies.append(Company(c, false));
    }
}

function MainClass::CreateCompanyList()
{
    this.companies = [];

    if (this.load_saved_data && ::CompanyDataTable != null) {
        foreach (company_id, company_data in ::CompanyDataTable)
        {
            this.companies.append(Company(company_id, true));
        }
    }

    // Now we can free ::CompanyDataTable
    ::CompanyDataTable = null;

    // Update company list for created/bankrupted/merged
    this.UpdateCompanyList();

    return companies;
}

/* Make a squirrel array of GoalTown instances (towns_array). For each
 * town, an instance of GoalTown is created to store the data related
 * to that town.
 */
function MainClass::CreateTownList()
{
    local towns_list = GSTownList();
    local towns_array = [];

    local min_transport = GSController.GetSetting("limit_min_transport");
    foreach (t, _ in towns_list) {
        towns_array.append(GoalTown(t, this.load_saved_data, min_transport));
    }

    // Now we can free ::TownDataTable
    ::TownDataTable = null;

    return towns_array;
}

/* Function called on town creation. We need to add a now GoalTown
 * instance to the this.towns array. The array order doesn't matter,
 * since we never use the array index, only its values.
 */
function MainClass::UpdateTownList(town_id)
{
    local min_transport = GSController.GetSetting("limit_min_transport");
    this.towns.append(GoalTown(town_id, false, min_transport));
    Log.Info("New town founded: "+GSTown.GetName(town_id)+" (id: "+town_id+")", Log.LVL_DEBUG);
}

function MainClass::DailyManageTownPopulation()
{
    foreach (town in this.towns) {
        local new_population = GSTown.GetPopulation(town.id);
        if (new_population > town.max_population) {
            foreach (company in companies) {
                if (company.id == town.contributor) {
                    company.AddPoints(new_population - town.max_population);
                    Log.Info(GSTown.GetName(town.id)
                             + " increased population by " + (new_population - town.max_population)
                             + " which was added to " + GSCompany.GetName(company.id), Log.LVL_DEBUG);
                }
            }

            town.max_population = new_population;
        }
    }
}

/* Function called periodically (each 74 ticks) to manage
 * towns and other stuff.
 */
function MainClass::ManageTowns()
{
    // Run the daily functions
    local date = GSDate.GetCurrentDate();
    local diff_date = date - this.current_date;
    if (diff_date == 0) {
        return;
    } else {
        GSToyLib.Check();
        DailyManageTownPopulation();

        this.current_date = date;
    }

    // Run the monthly functions
    local month = GSDate.GetMonth(date);
    local diff_month = month - this.current_month;
    if (diff_month == 0) {
        return;
    } else {
        local month_tick = GSController.GetTick();
        Log.Info("Starting Monthly Updates...", Log.LVL_INFO);

        local eternal_love = GSController.GetSetting("eternal_love");
        local eternal_love_rating = 0;
        switch (eternal_love) {
            case(1): // Outstanding
                eternal_love_rating = 1000;
                break;
            case(2): // Good
                eternal_love_rating = 400;
                break;
            case(3): // Poor
                eternal_love_rating = 0;
                break;
        }

        local threshold_setting = GSController.GetSetting("town_size_threshold");
        local min_transport = GSController.GetSetting("limit_min_transport");
        foreach (town in this.towns) {
            town.ManageTownLimiting(threshold_setting, min_transport);
            town.MonthlyManageTown();
            if (this.actual_town_info_mode > 1) {
                town.UpdateTownText(this.actual_town_info_mode);
            }

            if (eternal_love > 0) {
                town.EternalLove(eternal_love_rating);
            }
        }

        foreach (company in this.companies) {
            company.MonthlyUpdateGUIGoals(this.towns);
        }

        this.current_month = month;
        local month_tick_duration = GSController.GetTick() - month_tick;
        Log.Info("Monthly Update took "+month_tick_duration+" ticks.", Log.LVL_DEBUG);
    }

    // Run the yearly functions - Nothing to do for now, so we leave it out
    local year = GSDate.GetYear(date);
    local diff_year = year - this.current_year;
    if ( diff_year == 0)
        return;
    else
    {
        Log.Info("Starting Yearly Updates...", Log.LVL_INFO);

        ProspectRawIndustry();

        this.current_year = year;
    }
}
