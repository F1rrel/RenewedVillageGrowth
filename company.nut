class Company
{
    id = null;              // company id
    points = null;          // achieved points from growing towns
    statistics = null;      // contains texts for statistics in goal gui
    global_goal = null;     // global goal showing achieved points in the goal gui

    constructor(id, load_data)
    {
        this.id = id;

        if (!load_data)
        {
            this.points = 0;
            this.InitGUIGoals();
        }
        else
        {
            this.points = ::CompanyDataTable[this.id].points;
            this.global_goal = ::CompanyDataTable[this.id].global_goal;
            this.statistics = ::CompanyDataTable[this.id].statistics;
        }
    }
}

function Company::SavingCompanyData()
{
    local company_data = {};
    company_data.points <- this.points;
    company_data.global_goal <- this.global_goal;
    company_data.statistics <- this.statistics;

    return company_data;
}

function Company::InitGUIGoals()
{
    // global goal
    this.global_goal = GSGoal.New(GSCompany.COMPANY_INVALID, GSText(GSText.STR_GOAL_GLOBAL, GetColorText(this.id), this.id), GSGoal.GT_NONE, 0);
    GSGoal.SetProgress(this.global_goal, GSText(GSText.STR_NUM, this.points));

    // statistics
    this.statistics = array(5, -1);

    this.statistics[2] = GSGoal.New(this.id, GSText(GSText.STR_STATISTICS_AVERAGE_CATEGORY), GSGoal.GT_NONE, 0);
    GSGoal.SetProgress(this.statistics[2], GSText(GSText.STR_COMMA, 0));

    this.statistics[3] = GSGoal.New(this.id, GSText(GSText.STR_STATISTICS_NUM_TOWNS), GSGoal.GT_NONE, 0);
    GSGoal.SetProgress(this.statistics[3], GSText(GSText.STR_NUM, 0));

    this.statistics[4] = GSGoal.New(this.id, GSText(GSText.STR_STATOSTOCS_NOT_GROWING), GSGoal.GT_NONE, 0);
    GSGoal.SetProgress(this.statistics[4], GSText(GSText.STR_NUM, 0));
}

function Company::AddPoints(points)
{
    this.points += points > 0 ? points : 0;
}

function Company::MonthlyUpdateGUIGoals(towns)
{
    local biggest_town = -1;
    local biggest_town_population = 0;
    local fastest_growth_town = -1;
    local fastest_growth = 1000;
    local average_category_total = 0;
    local num_towns = 0;
    local num_not_growing_towns = 0;

    foreach (town in towns) {
        if (town.contributor != this.id)
            continue;
        
        local population = GSTown.GetPopulation(town.id);
        if (population > biggest_town_population) {
            biggest_town_population = population;
            biggest_town = town.id;
        }

        if (town.tgr_average != null && town.tgr_average > 0 && town.tgr_average < fastest_growth && town.allowGrowth) {
            fastest_growth = town.tgr_average;
            fastest_growth_town = town.id;
        }

        local max_cat = 0;
	    while (max_cat < ::CargoCatNum-1) {
            if (town.town_goals_cat[max_cat + 1] == 0) break;
            max_cat++;
        }
        average_category_total += max_cat + 1;

        ++num_towns;
        if (!town.allowGrowth)
            ++num_not_growing_towns;
    }

    // Global
    GSGoal.SetText(this.global_goal, GSText(GSText.STR_GOAL_GLOBAL, GetColorText(this.id), this.id));
    GSGoal.SetProgress(this.global_goal, GSText(GSText.STR_NUM, this.points));

    // Statistics
    if (GSTown.IsValidTown(biggest_town)) {
        if (!GSGoal.IsValidGoal(this.statistics[0]))
            this.statistics[0] = GSGoal.New(this.id, GSText(GSText.STR_STATISTICS_BIGGEST_TOWN, biggest_town), GSGoal.GT_NONE, 0);
        else
            GSGoal.SetText(this.statistics[0], GSText(GSText.STR_STATISTICS_BIGGEST_TOWN, biggest_town));
        GSGoal.SetProgress(this.statistics[0], GSText(GSText.STR_NUM, biggest_town_population));
    }
    else if (GSGoal.IsValidGoal(this.statistics[0])) {
        GSGoal.Remove(this.statistics[0]);
        this.statistics[0] = -1;
    }

    if (GSTown.IsValidTown(fastest_growth_town)) {
        if (!GSGoal.IsValidGoal(this.statistics[1]))
            this.statistics[1] = GSGoal.New(this.id, GSText(GSText.STR_STATISTICS_GROWTH_TOWN, fastest_growth_town), GSGoal.GT_NONE, 0);
        else
            GSGoal.SetText(this.statistics[1], GSText(GSText.STR_STATISTICS_GROWTH_TOWN, fastest_growth_town));
        GSGoal.SetProgress(this.statistics[1], GSText(GSText.STR_NUM, fastest_growth));
    }
    else if (GSGoal.IsValidGoal(this.statistics[1])) {
        GSGoal.Remove(this.statistics[1]);
        this.statistics[1] = -1;
    }

    local average_category = num_towns > 0 ? (average_category_total.tofloat() / num_towns * 1000).tointeger() : 0;
    GSGoal.SetProgress(this.statistics[2], GSText(GSText.STR_COMMA, average_category));
    GSGoal.SetProgress(this.statistics[3], GSText(GSText.STR_NUM, num_towns));
    GSGoal.SetProgress(this.statistics[4], GSText(GSText.STR_NUM, num_not_growing_towns));
}

function GetColorText(company_id)
{
    if (GSCompany.ResolveCompanyID(company_id) == GSCompany.COMPANY_INVALID)
        return GSText(GSText.STR_SILVER);

    local dummy = GSCompanyMode(company_id);
    local color = GSCompany.GetPrimaryLiveryColour(GSCompany.LS_DEFAULT);
    switch (color)
    {
        case GSCompany.COLOUR_DARK_BLUE:
            return GSText(GSText.STR_DARK_BLUE);
        case GSCompany.COLOUR_PALE_GREEN:
            return GSText(GSText.STR_PALE_GREEN);
        case GSCompany.COLOUR_PINK:
            return GSText(GSText.STR_PINK);
        case GSCompany.COLOUR_YELLOW:
            return GSText(GSText.STR_YELLOW);
        case GSCompany.COLOUR_RED:
            return GSText(GSText.STR_RED);
        case GSCompany.COLOUR_LIGHT_BLUE:
            return GSText(GSText.STR_LIGHT_BLUE);
        case GSCompany.COLOUR_GREEN:
            return GSText(GSText.STR_GREEN);
        case GSCompany.COLOUR_DARK_GREEN:
            return GSText(GSText.STR_DARK_GREEN);
        case GSCompany.COLOUR_BLUE:
            return GSText(GSText.STR_BLUE);
        case GSCompany.COLOUR_CREAM:
            return GSText(GSText.STR_CREAM);
        case GSCompany.COLOUR_MAUVE:
            return GSText(GSText.STR_MAUVE);
        case GSCompany.COLOUR_PURPLE:
            return GSText(GSText.STR_PURPLE);
        case GSCompany.COLOUR_ORANGE:
            return GSText(GSText.STR_ORANGE);
        case GSCompany.COLOUR_BROWN:
            return GSText(GSText.STR_BROWN);
        case GSCompany.COLOUR_GREY:
            return GSText(GSText.STR_GREY);
        case GSCompany.COLOUR_WHITE:
            return GSText(GSText.STR_WHITE);
        default:
            return GSText(GSText.STR_SILVER);
    }
}