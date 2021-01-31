class Company
{
    id = null;              // company id
    points = null;          // achieved points from growing towns

    constructor(id, load_data)
    {
        Log.Info("Creating company " + id + ": " + GSCompany.GetName(id), Log.LVL_INFO);

        this.id = id;

        if (!load_data)
        {
            this.points = 0;
        }
        else
        {
            this.points = ::CompanyDataTable[this.id].points;
        }

        GSLog.Info("Points: " + this.points);
    }
}

function Company::SavingCompanyData()
{
    local company_data = {};
    company_data.points <- this.points;
}

