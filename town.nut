/*
 * For each town in the game, an instance of this class is created.
 * It holds the data related to a specific town.
 */
class GoalTown
{
    id = null;                  // Town id
    sign_id = null;             // Id for extra text under town name
    contributor = null;         // company that contributed most to the growth of this town in the last month
    max_population = null;      // maximum achieved population of this town
    is_monitored = null;        // Whether the town is already under monitoring. True if town exchanges pax.
    last_delivery = null;       // Date of last delivery from or to the town for monitoring
    town_cargo_cat = null;      // List selected cargos per category
    cargo_hash = null;          // Hash created from town_cargo_cat
    town_goals_cat = null;      // Town goals per cargo category
    town_supplied_cat = null;   // Last monthly supply per cargo category (for categories: see InitCargoLists())
    town_stockpiled_cat = null; // Stockpiled cargos per cargo category
    tgr_array = null;           // Town growth rate array
    tgr_array_len = null;       // Town growth rate array lenght
    tgr_average = null;         // Town growth rate average, calculated from the array
    // Limit towns
    limit_transported = null;   // Mask of cargos that were under the limiting value
    limit_delay = null;         // Increments for each limiter false condition until "limiter_delay" setting
    allowGrowth = null;         // limits growth requirement fulfilled
    town_text_scroll = null;    // scroll town text when more than 3 categories are to be displayed
    initialized = null;         // Town is fully initialized

    constructor(town_id, load_town_data, min_transported, near_town, near_town_probability) {
        this.id = town_id;
        this.tgr_array_len = 8;
        this.tgr_average = null;
        this.town_text_scroll = 0;

        /* If there isn't saved data for the towns, we
         * initialize them. Otherwise, we load saved data.
         */
        if (!load_town_data) {
            this.sign_id = -1;
            this.contributor = -1;
            this.max_population = GSTown.GetPopulation(this.id);
            this.is_monitored = false;
            this.allowGrowth = false;
            this.last_delivery = null;
            this.town_goals_cat = array(::CargoCatNum, 0);
            this.town_supplied_cat = array(::CargoCatNum, 0);
            this.town_stockpiled_cat = array(::CargoCatNum, 0);
            this.tgr_array = array(tgr_array_len, 0);
            this.limit_transported = 0;
            this.limit_delay = 0;
            this.Randomization(near_town, near_town_probability);
            this.DisableOrigCargoGoal();

            // These commands require at least all non-construcion actions during pause allowed
            if (GSGameSettings.GetValue("construction.command_pause_level") >= 1) {
                GSTown.SetGrowthRate(this.id, GSTown.TOWN_GROWTH_NONE);
                GSTown.SetText(this.id, TownBoxText(false, 0));
                this.initialized = true;
            }
            else
                this.initialized = false;
        } else {
            this.sign_id = ::TownDataTable[this.id].sign_id;
            this.contributor = ::TownDataTable[this.id].contributor;
            this.max_population = ::TownDataTable[this.id].max_population;
            this.is_monitored = ::TownDataTable[this.id].is_monitored;
            this.allowGrowth = ::TownDataTable[this.id].allowGrowth;
            this.last_delivery = ::TownDataTable[this.id].last_delivery;
            this.town_goals_cat = ::TownDataTable[this.id].town_goals_cat;
            this.town_supplied_cat = ::TownDataTable[this.id].town_supplied_cat;
            this.town_stockpiled_cat = ::TownDataTable[this.id].town_stockpiled_cat;
            this.tgr_array = ::TownDataTable[this.id].tgr_array;
            this.limit_transported = ::TownDataTable[this.id].limit_transported;
            this.limit_delay = ::TownDataTable[this.id].limit_delay;
            this.cargo_hash = ::TownDataTable[this.id].cargo_hash;
            if (::SettingsTable.randomization == Randomization.INDUSTRY_DESC
             || ::SettingsTable.randomization == Randomization.INDUSTRY_ASC)
                this.town_cargo_cat = GetCargoCatFromIndustryCat(GetIndustryTable(this.cargo_hash));
            else
                this.town_cargo_cat = GetCargoTable(this.cargo_hash);
            this.DebugCargoTable(this.town_cargo_cat);

            this.UpdateTownText(GSController.GetSetting("town_info_mode"));
            this.initialized = true;
        }
    }
}

/* Arctic and Tropical climate have specific cargo requirements for
 * town growth. This function is called to disable them.
 */
function GoalTown::DisableOrigCargoGoal()
{
    switch (GSGameSettings.GetValue("game_creation.landscape")) {
        case (0): // Temperate
            break;
        case (1): // Arctic
            GSTown.SetCargoGoal(this.id, GSCargo.TE_FOOD, 0);
            break;
        case (2): // Tropical
            if (GSTown.GetCargoGoal(this.id, GSCargo.TE_WATER) != 0) {
                 GSTown.SetCargoGoal(this.id, GSCargo.TE_WATER, 0);
                GSTown.SetCargoGoal(this.id, GSCargo.TE_FOOD, 0);
            }
            break;
        case (3): // Toyland
            break;
        default:
            return;
    }
}

/* Function called when saving the game. */
function GoalTown::SavingTownData()
{
    /* IMPORTANT: if anything of the saved data changes here, we
     * need to update the MainClass.save_version flag in MainClass'
     * constructor.
     */
    local town_data = {};
    town_data.sign_id <- this.sign_id;
    town_data.contributor <- this.contributor;
    town_data.max_population <- this.max_population;
    town_data.is_monitored <- this.is_monitored;
    town_data.allowGrowth <- this.allowGrowth;
    town_data.last_delivery <- this.last_delivery;
    town_data.town_goals_cat <- this.town_goals_cat;
    town_data.town_supplied_cat <- this.town_supplied_cat;
    town_data.town_stockpiled_cat <- this.town_stockpiled_cat;
    town_data.tgr_array <- this.tgr_array;
    town_data.limit_transported <- this.limit_transported;
    town_data.limit_delay <- this.limit_delay;
    town_data.cargo_hash <- this.cargo_hash;
    return town_data;
}

/* Main town management function. Called each month. */
function GoalTown::MonthlyManageTown()
{
    // Finish initialization of the town
    if (!this.initialized)
    {
        GSTown.SetGrowthRate(this.id, GSTown.TOWN_GROWTH_NONE);
        GSTown.SetText(this.id, TownBoxText(false, 0));
        this.initialized = true;
        return;
    }

    local sum_goals = 0;
    local goal_diff = 0;
    local goal_diff_percent = 0.0;
    local cur_pop = GSTown.GetPopulation(this.id);
    local parsed_cat = 0;   // index of parsed category
    local new_town_growth_rate = null;
    // Defining difficulty and calculation factors
    local d_factor = GSController.GetSetting("goal_scale_factor") / 100.0;
    local g_factor = GSController.GetSetting("town_growth_factor");
    local e_factor = GSController.GetSetting("exponentiality_factor");
    local sup_imp_part = GSController.GetSetting("supply_impacting_part") / 100.0;
    local lowest_tgr = GSController.GetSetting("lowest_town_growth_rate");
    local allow_0_days_growth = GSController.GetSetting("allow_0_days_growth");
    // Clearing the arrays
    this.town_supplied_cat = array(::CargoCatNum, 0);
    this.town_goals_cat = array(::CargoCatNum, 0);

    // Allow small towns to grow
    if (GSTown.GetPopulation(this.id) < 100) {
        GSTown.SetGrowthRate(this.id, GSTown.TOWN_GROWTH_NORMAL);
        return;
    }

    // Check whether specific cargo goals have been enabled for tropical towns growing over 60
    if (GSGameSettings.GetValue("game_creation.landscape") == 2
        && GSTown.GetCargoGoal(this.id, GSCargo.TE_WATER) != 0) {
        GSTown.SetCargoGoal(this.id, GSCargo.TE_WATER, 0);
        GSTown.SetCargoGoal(this.id, GSCargo.TE_FOOD, 0);
    }

    // Checking whether we should enable or disable town monitoring
    if (!this.CheckMonitoring(this.is_monitored)) return;

    // Calculate supplied cargo
    local companies_supplied = {};
    foreach (index, category in this.town_cargo_cat) {
        for (local cid = GSCompany.COMPANY_FIRST; cid <= GSCompany.COMPANY_LAST; cid++) {
            if (GSCompany.ResolveCompanyID(cid) == GSCompany.COMPANY_INVALID)
                continue;

            if (!companies_supplied.rawin(cid))
                companies_supplied[cid] <- [];

            local category_supplied = 0;
            foreach (cargo in category) {
                local cargo_supplied = GSCargoMonitor.GetTownDeliveryAmount(cid, cargo, this.id, true);
                category_supplied += cargo_supplied < 0 ? 0 : cargo_supplied;
                if (cargo_supplied > 0)
                    this.DebugCargoSupplied(cargo, cargo_supplied);
            }

            if (category_supplied > 0)
                this.DebugCompanyCategorySupplied(cid, index, category_supplied);

            this.town_supplied_cat[index] += category_supplied;
            companies_supplied[cid].append(category_supplied);
        }
    }

    // Calculating goals
    for (local i = 0; i < CargoCatNum && cur_pop > ::CargoMinPopDemand[i]; i++) {
        this.town_goals_cat[i] = max((((cur_pop  - ::CargoMinPopDemand[i]).tofloat() / 1000)
                        * ::CargoPermille[i]
                        * d_factor).tointeger(),1);
    }

    // If town's population is too low to calculate a goal, it is set to 1
    if (this.town_goals_cat[0] < 1) this.town_goals_cat[0] = 1;

    // Get max category
    local max_cat = 1;
    while (max_cat < ::CargoCatNum) {
        if (this.town_goals_cat[max_cat] == 0) break;
        max_cat++;
    }

    // Calculating global goal and achievement
    for (local i = 0; i < CargoCatNum; ++i) {
        if (this.town_goals_cat[i] <= 0) {
            this.town_stockpiled_cat[i] = 0;
            continue;
        }

        this.town_supplied_cat[i] += this.town_stockpiled_cat[i];

        if (this.town_supplied_cat[i] < this.town_goals_cat[i]) {
            goal_diff_percent += (this.town_goals_cat[i] - this.town_supplied_cat[i]).tofloat() / (this.town_goals_cat[i] * max_cat).tofloat();
            this.town_stockpiled_cat[i] = 0;
        } else {
            // If stockpiled is bigger than required, we cut off the required part
            this.town_stockpiled_cat[i] = ((this.town_supplied_cat[i] - this.town_goals_cat[i])
                             * (1 - ::CargoDecay[i])).tointeger();
            // Don't stockpile more than: (cargo category) * 10;
            if (this.town_stockpiled_cat[i] > 300 &&
                this.town_stockpiled_cat[i] > this.town_goals_cat[i] * 10) {
                this.town_stockpiled_cat[i] = this.town_goals_cat[i] * 10;
            }
        }

        this.DebugCargoCatInfo(i) // Debug info: print stockpiled/supplied/goal per category
    }

    // Calculates new town growth rate based on missing cargo percentage
    // Firstly a maximum growth rate for the town is calculated with g_factor
    // being the growth rate at 0 population and exponentially increasing.
    // An exponential extra growth is calculated based on missing cargo requirements.
    // The max growth rate and difference between max growth rate and lowest growth rate
    // multiplied by extra growth factor are combined into the resulting growth rate.
    Log.Info("Goal diff: " + goal_diff_percent + "%", Log.LVL_DEBUG);
    if ((1.0 - goal_diff_percent) >= sup_imp_part) {
        local max_town_growth_rate = g_factor * exp(-cur_pop.tofloat()/10000);
        max_town_growth_rate = max_town_growth_rate < 1 ? 1 : max_town_growth_rate;
        local growth = 1 - (1 - exp(-e_factor * (1 - goal_diff_percent))) / (1 - exp(-e_factor));
        new_town_growth_rate = (max_town_growth_rate + (lowest_tgr - max_town_growth_rate) * growth).tointeger();
        Log.Info("max_growth_rate: " + max_town_growth_rate + ", growth: " + growth + ", new growth rate: " + new_town_growth_rate, Log.LVL_DEBUG);
    }
    else {
        new_town_growth_rate = lowest_tgr;
    }

    if (new_town_growth_rate > lowest_tgr)
        new_town_growth_rate = lowest_tgr;
    else if (new_town_growth_rate < 1 && !allow_0_days_growth)
        new_town_growth_rate = 1;

    // Defining the new town growth rate, calculated as the moving average of the TGR array, update only if town growth requirements are fulfilled
    local sum_array = 0.0;
    local i = 0;
    while (this.tgr_array[i] > 0) {
        sum_array += this.tgr_array[i];
        i++;
    }
    this.tgr_array[i] = new_town_growth_rate;
    sum_array += this.tgr_array[i];
    this.tgr_average = (sum_array/(i+1)).tointeger();

    // Shift the array by one element when full
    this.DebugTgrArray() // Debug info: print the array's content
    if (this.tgr_array[this.tgr_array_len-1] > 0) {
        this.tgr_array = this.tgr_array.slice(1); // efface element [0] de l'array
        this.tgr_array.push(0);                   // ajoute 0 en dernier element
    }

    if (this.allowGrowth) {
        GSTown.SetGrowthRate(this.id, this.tgr_average);
    } else {
        GSTown.SetGrowthRate(this.id, GSTown.TOWN_GROWTH_NONE);
    }

    // Find the biggest contributor
    local max_contrib = 0.0;
    local total_contrib = 0.0;
    local company_id = -1;
    foreach (id, category in companies_supplied) {
        local contribution = 0;
        foreach (index, supplied in category) {
            if (this.town_goals_cat[index] == 0)
                continue;

            // each category is normalized to 0.0-1.0 range and summed up to have equal weight
            contribution += supplied > this.town_goals_cat[index] ? 1.0 : supplied.tofloat() / this.town_goals_cat[index];
        }

        // when equal, decide based on total supplied
        if (contribution == max_contrib && company_id >=0) {
            local total = 0;
            foreach (supplied in category) {
                total += supplied;
            }
            if (total > total_contrib) {
                max_contrib = contribution;
                total_contrib = total;
                company_id = id;
            }
        }
        else if (contribution > max_contrib) {
            max_contrib = contribution;
            total_contrib = 0;
            foreach (supplied in category) {
                total_contrib += supplied;
            }
            company_id = id;
        }
    }
    this.contributor = company_id;

    this.UpdateSignText();
    GSTown.SetText(this.id, this.TownBoxText(true, GSController.GetSetting("town_info_mode"), true));
}

function GoalTown::ManageTownLimiting(threshold_setting, min_transported) {
    // if the town limiting is turned off or the size of the town is below the threshold, set requirements to zero
    local townPopulation = GSTown.GetPopulation(this.id);

    if (townPopulation <= threshold_setting || min_transported == 0) {
        this.limit_transported = 0;
        this.allowGrowth = true;
        this.limit_delay = 0;
        return;
    }

    local sum_transported = 0;
    this.limit_transported = 0;
    foreach (index, cargo in ::CargoLimiter) {
        local transported = GSTown.GetLastMonthTransportedPercentage(this.id, cargo);
        sum_transported += transported;
        if (transported < min_transported)
            this.limit_transported += 1 << cargo;
    }

    if (sum_transported / ::CargoLimiter.len() < min_transported) {
        ++this.limit_delay;
        if (this.limit_delay > GSController.GetSetting("limiter_delay")) {
            this.limit_delay = 0;
            this.allowGrowth = false;
        }
    } else {
        this.allowGrowth = true;
        this.limit_delay = 0;
    }
}

/* Function called either for unmonitored towns, either for monitored
 * towns which are not supplied with pax. Returns true if the town
 * must be monitored, false otherwise.
 */
function GoalTown::CheckMonitoring(monitored)
{
    /* To enable monitoring it is better to check the delivery
     * from the town and not to the town. This is necessary for
     * very little towns, which don't always receive passengers
     * due to cargodist algorithm. Note: using GSCargoMonitor
     * results in lighter load as using
     * GSTown.GetLastMonth[Supply/TransportedPercentage].
     */
    local delivery_check = 0;
    for (local cid = GSCompany.COMPANY_FIRST; cid <= GSCompany.COMPANY_LAST; cid++) {
        if (GSCompany.ResolveCompanyID(cid) != GSCompany.COMPANY_INVALID) {
            foreach (cargo in ::CargoLimiter) {
                delivery_check += GSCargoMonitor.GetTownPickupAmount(cid, cargo, this.id, true);
                if (delivery_check > 0) break;
            }
        }
    }

    if (!monitored) {
        /* For unmonitored towns: check whether they delivered
         * pax. If they did, monitoring is enabled.
         */
        if (delivery_check == 0) {
            return false;
        } else {
            this.is_monitored = true;
            this.last_delivery = GSDate.GetCurrentDate();
            Log.Info("City of "+GSTown.GetName(this.id)+" now monitored", Log.LVL_DEBUG);
            return true;
        }
    } else {
        /* For monitored towns: if there isn't passengers
         * delivery from the town since more than 1 year, we
         * stop the monitoring. This is necessary for very
         * little towns, which otherwise could never grow.
         */
        if (delivery_check > 0) {
            this.last_delivery = GSDate.GetCurrentDate();
            return true;
        }

        if ((GSDate.GetCurrentDate()-this.last_delivery) < 365) {
            return true;
        } else {
            GSTown.SetGrowthRate(this.id, GSTown.TOWN_GROWTH_NONE);
            this.is_monitored = false;
            this.town_stockpiled_cat = array(::CargoCatNum, 0);
            this.tgr_array = array(tgr_array_len, 0);
            this.tgr_average = null;
            this.StopMonitors();
            this.RemoveSignText();
            Log.Info("City of "+GSTown.GetName(this.id)+" is not monitored anymore", Log.LVL_DEBUG);
            return false;
        }
    }
}

function GoalTown::StopMonitors()
{
    for (local i = 0; i < ::CargoIDList.len(); i++) {
        if (::CargoIDList[i] == null)
            continue;
        for (local cid = GSCompany.COMPANY_FIRST; cid <= GSCompany.COMPANY_LAST; cid++) {
            if (GSCompany.ResolveCompanyID(cid) != GSCompany.COMPANY_INVALID) {
                GSCargoMonitor.GetTownDeliveryAmount(cid, i, this.id, false);
            }
        }
    }
}

function GoalTown::EternalLove(rating)
{
    for (local c = GSCompany.COMPANY_FIRST; c <= GSCompany.COMPANY_LAST; c++) {
        if (!GSTown.IsValidTown(this.id))
            break;
        if (GSCompany.ResolveCompanyID(c) != c)
            continue;
        local cur_rating_class = GSTown.GetRating(this.id, c);
        if (cur_rating_class == GSTown.TOWN_RATING_NONE
            || cur_rating_class == GSTown.TOWN_RATING_INVALID
            || cur_rating_class == GSTown.TOWN_RATING_OUTSTANDING)
            continue;
        local cur_rating = GSTown.GetDetailedRating(this.id, c);
        Log.Info("Current/required rating of " + GSTown.GetName(this.id) + ": " + cur_rating + " / " + rating, Log.LVL_DEBUG);
        if (cur_rating < rating)
            GSTown.ChangeRating(this.id, c, rating - cur_rating);
    }
}

function GoalTown::UpdateSignText()
{
    // Add a sign by the town to display the current growth
    if (::SettingsTable.use_town_sign) {
        local sign_text = TownSignText();
        if (GSSign.IsValidSign(this.sign_id)) {
            GSSign.SetName(this.sign_id, sign_text);
        } else {
            this.sign_id = GSSign.BuildSign(GSTown.GetLocation(this.id), sign_text);
        }
    }
}

function GoalTown::RemoveSignText()
{
    // Cleaning signs on the map
    if (::SettingsTable.use_town_sign && GSSign.IsValidSign(this.sign_id)) {
        GSSign.RemoveSign(this.sign_id);
        this.sign_id = -1;
    }

    GSTown.SetText(this.id, this.TownBoxText(false, 0));
}


function GoalTown::UpdateTownText(info_mode)
{
    if (this.is_monitored) {
        GSTown.SetText(this.id, this.TownBoxText(true, info_mode));
    }
}

function GoalTown::Randomization(near_town, near_town_probability)
{
    switch (::SettingsTable.randomization) {
        case Randomization.INDUSTRY_ASC:
        case Randomization.INDUSTRY_DESC:
        {
            local industry_cat = RandomizeIndustry(::SettingsTable.randomization == Randomization.INDUSTRY_ASC, near_town, near_town_probability);
            this.town_cargo_cat = GetCargoCatFromIndustryCat(industry_cat);
            this.cargo_hash = GetIndustryHash(industry_cat);
            break;
        }
        case Randomization.FIXED_1:
            this.town_cargo_cat = RandomizeFixed(1, near_town, near_town_probability);
            break;
        case Randomization.FIXED_2:
            this.town_cargo_cat = RandomizeFixed(2, near_town, near_town_probability);
            break;
        case Randomization.FIXED_3:
            this.town_cargo_cat = RandomizeFixed(3, near_town, near_town_probability);
            break;
        case Randomization.FIXED_5:
            this.town_cargo_cat = RandomizeFixed(5, near_town, near_town_probability);
            break;
        case Randomization.FIXED_7:
            this.town_cargo_cat = RandomizeFixed(7, near_town, near_town_probability);
            break;
        case Randomization.RANGE_1_2:
            this.town_cargo_cat = RandomizeRange(1, 2, near_town, near_town_probability);
            break;
        case Randomization.RANGE_1_3:
            this.town_cargo_cat = RandomizeRange(1, 3, near_town, near_town_probability);
            break;
        case Randomization.RANGE_2_3:
            this.town_cargo_cat = RandomizeRange(2, 3, near_town, near_town_probability);
            break;
        case Randomization.RANGE_3_5:
            this.town_cargo_cat = RandomizeRange(3, 5, near_town, near_town_probability);
            break;
        case Randomization.RANGE_3_7:
            this.town_cargo_cat = RandomizeRange(3, 7, near_town, near_town_probability);
            break;
        case Randomization.DESCENDING:
            this.town_cargo_cat = RandomizePyramid(false, near_town, near_town_probability);
            break;
        case Randomization.ASCENDING:
            this.town_cargo_cat = RandomizePyramid(true, near_town, near_town_probability);
            break;
        default:
            this.town_cargo_cat = ::CargoCat;
    }

    if (::SettingsTable.randomization != Randomization.INDUSTRY_ASC &&
        ::SettingsTable.randomization != Randomization.INDUSTRY_DESC) {
        this.cargo_hash = GetCargoHash(this.town_cargo_cat);
    }
}