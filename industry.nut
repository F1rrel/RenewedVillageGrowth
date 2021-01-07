function InitIndustryLists()
{
    local industry_type_list = GSIndustryTypeList();

    local list_raw = [];
    local list_1 = [];
    local list_2 = [];
    local list_3 = [];
    local list_4 = [];
    foreach (industry, _ in industry_type_list) {
        local cargo_list = GSIndustryType.GetAcceptedCargo(industry);
        cargo_list.RemoveItem(0); // exclude PASS
        cargo_list.RemoveItem(2); // exclude MAIL

        switch (cargo_list.Count()) 
        {
            case 0:
                break;
            case 1:
                if (GSIndustryType.IsRawIndustry(industry))
                    list_raw.append(industry);
                else
                    list_1.append(industry);
                break;
            case 2:
                if (GSIndustryType.IsRawIndustry(industry))
                    list_raw.append(industry);
                else
                    list_2.append(industry);
                break;
            case 3:
                list_3.append(industry);
                break;
            default:
                list_4.append(industry);
        }
    }

    ::industries_raw <- list_raw;
    ::industries_1 <- list_1;
    ::industries_2 <- list_2;
    ::industries_3 <- list_3;
    ::industries_4 <- list_4;

    DebugIndustryLists();

    // Initialized required global variables
    local cargo_list = [];
    for(local i = 0; i < 64; ++i) {
		cargo_list.append(GSCargo.GetCargoLabel(i));
	}
    ::CargoIDList <- cargo_list;
    ::CargoLimiter <- [0, 2];
    ::CargoCatNum <- (list_4.len() > 0 || (list_3.len() > 6 && (list_1.len() + list_raw.len()) > 9)) ? 5 : 4;

    if (::CargoCatNum == 4) {
        ::CargoMinPopDemand <- [0, 1000, 4000, 8000];
        ::CargoCatList <- [CatLabels.CATEGORY_I, CatLabels.CATEGORY_II, CatLabels.CATEGORY_III, CatLabels.CATEGORY_IV];
        ::CargoPermille <- [60, 10, 25, 40];
	    ::CargoDecay <- [0.4, 0.1, 0.1, 0.1, 0.1];
    }
    else {
        ::CargoMinPopDemand <- [0, 500, 1000, 4000, 8000];
        ::CargoCatList <- [CatLabels.CATEGORY_I, CatLabels.CATEGORY_II, CatLabels.CATEGORY_III, CatLabels.CATEGORY_IV, CatLabels.CATEGORY_V];
        ::CargoPermille <- [60, 10, 25, 40, 60];
	    ::CargoDecay <- [0.4, 0.1, 0.1, 0.1, 0.1];
    }
}

function RandomizeIndustry()
{
    local categories = [];

    local list_raw = clone ::industries_raw;
    local list_1 = clone ::industries_1;
    local list_2 = clone ::industries_2;
    local list_3 = clone ::industries_3;
    local list_4 = clone ::industries_4;

    // 1. Category (PASS, MAIL)

    // 2. Category
    {
        local rand = GSBase.RandRange(list_1.len());
        categories.append([list_1[rand]]);
        list_1.remove(rand);
    }

    // 3. Category
    if (list_2.len() > 2 || (list_1.len() < 2 && list_2.len() > 0)) {
        local rand = GSBase.RandRange(list_2.len());
        categories.append([list_2[rand]]);
        list_2.remove(rand);
    }
    else {
        local rand = GSBase.RandRange(3);
        if (rand < list_2.len()) {
            categories.append([list_2[rand]]);
            list_2.remove(rand);
        }
        else {
            if (list_raw.len() > 0) {
                local rand_1 = GSBase.RandRange(list_1.len());
                local rand_raw = GSBase.RandRange(list_raw.len());
                categories.append([list_1[rand_1], list_raw[rand_raw]]);
                list_1.remove(rand_1);
                list_raw.remove(rand_raw);
            }
            else {
                local rand_1 = GSBase.RandRange(list_1.len());
                local rand_2 = GSBase.RandRange(list_1.len() - 1);
                categories.append([list_1[rand_1], list_1[rand_2 >= rand_1 ? rand_2 + 1 : rand_2]]);
                list_1.remove(rand_1);
                list_1.remove(rand_2);
            }
        }
    }

    // 4. Category
    if (list_3.len() > 2 || ((list_2.len() == 0 || (list_1.len() + list_raw.len() == 0)) && list_3.len() > 0)) {
        local rand = GSBase.RandRange(list_3.len());
        categories.append([list_3[rand]]);
        list_3.remove(rand);
    }
    else {
        local rand = GSBase.RandRange(3);
        if (rand < list_3.len()) {
            categories.append([list_3[rand]]);
            list_3.remove(rand);
        }
        else {
            local list = clone list_1;
            list.extend(list_raw);

            local rand_1 = GSBase.RandRange(list.len());
            local rand_2 = GSBase.RandRange(list_2.len());

            categories.append([list[rand_1], list_2[rand_2]]);
            if (rand_1 < list_1.len())
                list_1.remove(rand_1);
            else
                list_raw.remove(rand_1 - list_1.len());
            list_2.remove(rand_2);
        }
    }

    // 5. Category
    if (list_4.len() > 2 || ((list_3.len() < 5 || (list_1.len() + list_raw.len() < 5)) && list_4.len() > 0)) {
        local rand = GSBase.RandRange(list_4.len());
        categories.append([list_4[rand]]);
        list_4.remove(rand);
    }
    else if (list_4.len() > 0) {
        local rand = GSBase.RandRange(3);
        if (rand < list_4.len()) {
            categories.append([list_4[rand]]);
            list_4.remove(rand);
        }
        else {
            local list = clone list_1;
            list.extend(list_raw);

            local rand_1 = GSBase.RandRange(list.len());
            local rand_3 = GSBase.RandRange(list_3.len());

            categories.append([list[rand_1], list_3[rand_3]]);
            if (rand_1 < list_1.len())
                list_1.remove(rand_1);
            else
                list_raw.remove(rand_1 - list_1.len());
            list_3.remove(rand_3);
        }
    }
    else if (list_3.len() > 4 && (list_1.len() + list_raw.len() > 4)) {
        local list = clone list_1;
        list.extend(list_raw);

        local rand_1 = GSBase.RandRange(list.len());
        local rand_3 = GSBase.RandRange(list_3.len());

        categories.append([list[rand_1], list_3[rand_3]]);
        if (rand_1 < list_1.len())
            list_1.remove(rand_1);
        else
            list_raw.remove(rand_1 - list_1.len());
        list_3.remove(rand_3);
    }

    return categories;
}

function GetCargoCatFromIndustryCat(industry_cat)
{
    local cargo_cat = [[0, 2]];
    foreach (cat_idx, cat in industry_cat) {
        cargo_cat.append([]);
        foreach (ind_idx, ind in cat) {
            local cargo_list = GSIndustryType.GetAcceptedCargo(ind);
            foreach (cargo, _ in cargo_list) {
                local found = false;
                foreach (c in cargo_cat.top()) {
                    if (cargo == c) {
                        found = true;
                        break;
                    }
                }
                if (!found)
                    cargo_cat[cat_idx+1].append(cargo);
            }
        }
    }

    return cargo_cat;
}

function GetIndustryHash(industry_cat)
{
    local hash = 0;
    local index = 0;
    foreach (cat_idx, cat in industry_cat)
	{
        local new_cat = 0x01;
		foreach (ind_idx, ind in cat)
		{
            local industry = (ind << 1 & 0xff) | new_cat; // | industry id 8 bit | new category flag 1 bit |
			hash = hash | (industry << index);
            index += 9;
            new_cat = 0x00;
		}
	}

	return hash;
}

function GetIndustryTable(hash)
{
    local industry_cat = [];
    local cat_idx = 0;

    while (hash > 0) {
        local industry = (hash & 0x01fe) >> 1;
        local new_cat = hash & 0x01;

        if (new_cat) {
            industry_cat.append([industry]);
            ++cat_idx;
        } 
        else {
            industry_cat[cat_idx-1].append(industry);
        }

        hash = hash >> 9;
    }

    return industry_cat;
}