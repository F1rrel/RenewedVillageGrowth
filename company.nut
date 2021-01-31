class Company
{
    id = null;              // company id
    points = null;          // achieved points from growing towns
    goal = null;
    global_goal = null;

    constructor(id, load_data)
    {
        this.id = id;

        if (!load_data)
        {
            this.points = 0;
            this.global_goal = GSGoal.New(GSCompany.COMPANY_INVALID, GSText(GSText.STR_GOAL_GLOBAL, GetColorText(this.id), this.id), GSGoal.GT_NONE, 0);
            GSGoal.SetProgress(this.global_goal, GSText(GSText.STR_GOAL_POINTS, this.points));
        }
        else
        {
            this.points = ::CompanyDataTable[this.id].points;
            this.global_goal = ::CompanyDataTable[this.id].global_goal;
        }
    }
}

function Company::SavingCompanyData()
{
    local company_data = {};
    company_data.points <- this.points;
    company_data.global_goal <- this.global_goal;

    return company_data;
}

function Company::AddPoints(points)
{
    this.points += points > 0 ? points : 0;
}

function Company::MonthlyUpdateGUIGoals()
{
    GSGoal.SetProgress(this.global_goal, GSText(GSText.STR_GOAL_POINTS, this.points));
}

function GetColorText(company_id)
{
    if (GSCompany.ResolveCompanyID(company_id) == GSCompany.COMPANY_INVALID)
        return GSText(GSText.STR_SILVER);

    local dummy = GSCompanyMode(company_id);
    local color = GSCompany.GetPrimaryLiveryColour(GSCompany.LS_DEFAULT);
    GSLog.Info(color);
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