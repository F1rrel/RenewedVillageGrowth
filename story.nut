class StoryEditor
{
    supply_impacting_part = null;
    eternal_love = null;
    limit_min_transport = null;
    limiter_delay = null;

    sp_cargo = null;
    sp_custom = null;
    sp_warning = null;

    constructor() {
        this.supply_impacting_part = GSController.GetSetting("supply_impacting_part");
        this.eternal_love = GSController.GetSetting("eternal_love");
        this.limit_min_transport = GSController.GetSetting("limit_min_transport");
        this.limiter_delay = GSController.GetSetting("limiter_delay");
    }
}

/* Checks if any parameters were changed and modifies the story page to reflect the change */
function StoryEditor::CheckParameters(companies)
{
    local supply_impacting_part = GSController.GetSetting("supply_impacting_part");
    local eternal_love = GSController.GetSetting("eternal_love");
    local limit_min_transport = GSController.GetSetting("limit_min_transport");
    local limiter_delay = GSController.GetSetting("limiter_delay");

    if (this.supply_impacting_part != supply_impacting_part
            || this.eternal_love != eternal_love
            || this.limit_min_transport != limit_min_transport
            || this.limiter_delay != limiter_delay) {

        foreach (company in companies) {
            local sp_welcome_elements = GSStoryPageElementList(company.sp_welcome);
            foreach (element, _ in sp_welcome_elements) {
                GSStoryPage.RemoveElement(element);
            }

            this.supply_impacting_part = supply_impacting_part;
            this.eternal_love = eternal_love;
            this.limit_min_transport = limit_min_transport;
            this.limiter_delay = limiter_delay;

            this.WelcomePage(company.sp_welcome);
        }
    }
}

/* Create a page showing information about this GS */
function StoryEditor::WelcomePage(sp_welcome)
{    
    GSStoryPage.NewElement(sp_welcome, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_WELCOME_DESC));
    
    if (GSText.STR_SB_CUSTOM_END - GSText.STR_SB_CUSTOM_TITLE > 1) {
        GSStoryPage.NewElement(sp_welcome, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_CUSTOM_WELCOME, GSText(GSText.STR_SB_CUSTOM_TITLE)));
    }
    
    GSStoryPage.NewElement(sp_welcome, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_WELCOME_CARGO, GSText(GSText.STR_ECONOMY_NONE + ::Economy), ::CargoCatNum, this.supply_impacting_part));
    GSStoryPage.NewElement(sp_welcome, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_WELCOME_STATISTICS));

    if (this.limit_min_transport > 0) {
        local limiter_cargos = 0;
        foreach (cargo in ::CargoLimiter) {
            limiter_cargos = limiter_cargos | 1 << cargo;
        }

        local limiter_delay_text = this.limiter_delay > 0 ? GSText(GSText.STR_SB_WELCOME_LIMIT_GROWTH_DELAY, this.limiter_delay) : GSText(GSText.STR_STRING, GSText(GSText.STR_EMPTY));
        GSStoryPage.NewElement(sp_welcome, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_WELCOME_LIMIT_GROWTH, limiter_cargos, this.limit_min_transport, limiter_delay_text));
    }

    if (this.eternal_love > 0) {
        GSStoryPage.NewElement(sp_welcome, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_WELCOME_ETERNAL_LOVE, GSText(GSText.STR_ETERNAL_LOVE_OUTSTANDING + this.eternal_love - 1)));
    }

    GSStoryPage.NewElement(sp_welcome, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_WELCOME_END));
}

/* Create a page showing informations about cargo categories. */
function StoryEditor::CargoInfoPage(sp_cargo)
{
    // Creation of the page
    local rand_type = 0; // 0 = NONE, 1 = FIXED, 2 = RANGE
    local rand_1, rand_2;

    switch (::SettingsTable.randomization) {
        case Randomization.FIXED_1:
        case Randomization.FIXED_2:
        case Randomization.FIXED_3:
            rand_1 = ::SettingsTable.randomization - Randomization.FIXED_1 + 1;
            rand_type = 1;
            break;
        case Randomization.FIXED_5:
            rand_1 = 5;
            rand_type = 1;
            break;
        case Randomization.FIXED_7:
            rand_1 = 7;
            rand_type = 1;
            break;

        case Randomization.RANGE_1_2:
            rand_1 = 1;
            rand_2 = 2;
            rand_type = 2;
            break;
        case Randomization.RANGE_1_3:
            rand_1 = 1;
            rand_2 = 3;
            rand_type = 2;
            break;
        case Randomization.RANGE_2_3:
            rand_1 = 2;
            rand_2 = 3;
            rand_type = 2;
            break;
        case Randomization.RANGE_3_5:
            rand_1 = 3;
            rand_2 = 5;
            rand_type = 2;
            break;
        case Randomization.RANGE_3_7:
            rand_1 = 3;
            rand_2 = 7;
            rand_type = 2;
            break;
    }

    switch (rand_type) {
        case 1: // FIXED
            GSStoryPage.NewElement(sp_cargo, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_EXPLAIN_2, GSText(GSText.STR_SB_EXPLAIN_RANDOM_0, rand_1, GSText(GSText.STR_EMPTY))));
            break;
        case 2: // RANGE
            GSStoryPage.NewElement(sp_cargo, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_EXPLAIN_2, GSText(GSText.STR_SB_EXPLAIN_RANDOM_2, rand_1, rand_2)));
            break;
        default:
            GSStoryPage.NewElement(sp_cargo, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_EXPLAIN_1));
    }

    // Adding elements per categories
    for (local i = 0; i < ::CargoCatNum; i++) {
        local bit_sum = 0;
        if (::SettingsTable.randomization != Randomization.INDUSTRY_DESC
         && ::SettingsTable.randomization != Randomization.INDUSTRY_ASC) {
            for (local j = 0; j < ::CargoCat[i].len(); j++) {
                bit_sum += 1 << ::CargoCat[i][j];
            }
        }

        GSStoryPage.NewElement(sp_cargo, GSStoryPage.SPET_TEXT, 0,
                       GSText(GSText["STR_SB_CARGOCAT_"+i],
                         GSText(GSText.STR_SB_CARGOCAT_CAT), i+1,
                         GSText(GSText["STR_CARGOCAT_LABEL_"+::CargoCatList[i]]),
                         GSText(GSText.STR_SB_CARGOCAT_POP), ::CargoMinPopDemand[i],
                         GSText(GSText.STR_SB_CARGOCAT_DECAY), (::CargoDecay[i]*100).tointeger(),
                         GSText(GSText.STR_SB_CARGOCAT_CARGOT), bit_sum));
    }
}

/* Create a page showing custom information like server rules. */
function StoryEditor::CustomPage(sp_custom)
{
    for (local i = GSText.STR_SB_CUSTOM_TITLE + 1; i < GSText.STR_SB_CUSTOM_END; i++) {
        GSStoryPage.NewElement(sp_custom, GSStoryPage.SPET_TEXT, 0, GSText(i));
    }
}

/* Create the StoryBook if it still doesn't exist. This function is
 * called only when (re)initializing all data, because the existing
 * storybook is stored by OTTD.
 */
function StoryEditor::CreateStoryBook(companies, num_towns, init_error)
{
    // Remove any eventual previous existent storypage
    local sb_list = GSStoryPageList(0);
    foreach (page, _ in sb_list) GSStoryPage.Remove(page);

    if (!init_error) {
        // Create basic cargo informations page
        this.sp_cargo = this.NewStoryPage(GSCompany.COMPANY_INVALID, GSText(GSText.STR_SB_TITLE_1));
        this.CargoInfoPage(this.sp_cargo);

        // Create custom page
        if (GSText.STR_SB_CUSTOM_END - GSText.STR_SB_CUSTOM_TITLE > 1) {
            this.sp_custom = this.NewStoryPage(GSCompany.COMPANY_INVALID, GSText(GSText.STR_SB_CUSTOM_TITLE));
            this.CustomPage(this.sp_custom);
        }

        foreach (company in companies) {
            // Create welcome page
            company.sp_welcome = this.NewStoryPage(company.id, GSText(GSText.STR_SB_WELCOME_TITLE, SELF_MAJORVERSION, SELF_MINORVERSION));
            this.WelcomePage(company.sp_welcome);
            GSStoryPage.Show(company.sp_welcome);
        }
    }

    switch (init_error) {
        // Issue a warning if there are more towns on the map than the GS can save
        case InitError.TOWN_NUMBER:
            this.sp_warning = this.NewStoryPage(GSCompany.COMPANY_INVALID, GSText(GSText.STR_SB_WARNING_TITLE));
            GSStoryPage.NewElement(this.sp_warning, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_WARNING_1, num_towns, SELF_MAX_TOWNS));
            GSStoryPage.Show(this.sp_warning);
            break;
        // Issue a warning that the cargo list initialization has failed
        case InitError.CARGO_LIST:
            this.sp_warning = this.NewStoryPage(GSCompany.COMPANY_INVALID, GSText(GSText.STR_SB_WARNING_TITLE));
            GSStoryPage.NewElement(this.sp_warning, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_WARNING_2));
            GSStoryPage.Show(this.sp_warning);
            break;
        // Issue a warning that the cargo list initialization has failed
        case InitError.INDUSTRY_LIST:
            this.sp_warning = this.NewStoryPage(GSCompany.COMPANY_INVALID, GSText(GSText.STR_SB_WARNING_TITLE));
            GSStoryPage.NewElement(this.sp_warning, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_WARNING_3));
            GSStoryPage.Show(this.sp_warning);
            break;
        case InitError.TOWN_GROWTH_RATE:
            this.sp_warning = this.NewStoryPage(GSCompany.COMPANY_INVALID, GSText(GSText.STR_SB_WARNING_TITLE));
            GSStoryPage.NewElement(this.sp_warning, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_WARNING_4));
            GSStoryPage.Show(this.sp_warning);
            break;
    }
}

function StoryEditor::CreateNewCompanyStoryBook(company)
{
    // Create welcome page
    company.sp_welcome = this.NewStoryPage(company.id, GSText(GSText.STR_SB_WELCOME_TITLE, SELF_MAJORVERSION, SELF_MINORVERSION));
    this.WelcomePage(company.sp_welcome);
    GSStoryPage.Show(company.sp_welcome);
}

/* Wrapper that creates a new StoryPage but disable date output. */
function StoryEditor::NewStoryPage(company, text)
{
    local value = GSStoryPage.New(company, text);
    if (value != GSStoryPage.STORY_PAGE_INVALID) GSStoryPage.SetDate(value, GSDate.DATE_INVALID);
    return value;
}
