class Company
{
    id = null;              // company id
    points = null;          // achieved points from growing towns

    constructor(id, load_data)
    {
        this.id = id;

        if (!load_data)
        {
            this.points = 0;
        }
        else
        {
            this.points = ::CompanyDataTable[this.id].points;
        }
    }
}

function Company::SavingCompanyData()
{
    local company_data = {};
    company_data.points <- this.points;

    return company_data;
}

function Company::AddPoints(points)
{
    this.points += points > 0 ? points : 0;
}

