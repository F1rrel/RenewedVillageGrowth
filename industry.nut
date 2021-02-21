// As defined number of industries on a 256x256 map [funding, minimal, very low, low, normal, high]
::NumIndustries <- [0, 0, 10, 25, 55, 80];

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
        ::CargoDecay <- [0.4, 0.1, 0.1, 0.1];
    }
    else {
        ::CargoMinPopDemand <- [0, 500, 1000, 4000, 8000];
        ::CargoCatList <- [CatLabels.CATEGORY_I, CatLabels.CATEGORY_II, CatLabels.CATEGORY_III, CatLabels.CATEGORY_IV, CatLabels.CATEGORY_V];
        ::CargoPermille <- [60, 10, 25, 40, 60];
        ::CargoDecay <- [0.4, 0.1, 0.1, 0.1, 0.1];
    }
}

function RandomizeIndustry(ascending)
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
        if (list_1.len() == 0) {
            local rand = GSBase.RandRange(list_raw.len());
            categories.append([list_raw[rand]]);
            list_raw.remove(rand);
        }
        else {
            local rand = GSBase.RandRange(list_1.len());
            categories.append([list_1[rand]]);
            list_1.remove(rand);
        }
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

    if (!ascending) {
        local category_reverse = [];
        for (local i = categories.len() - 1; i >= 0; --i) {
            category_reverse.append(categories[i]);
        }
        return category_reverse;
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

function ProspectRawIndustry()
{
    local target_count = GetRawIndustryTargetCount();
    if (target_count == 0)
        return;

    local industry_list = GSIndustryList();
    local industry_count = industry_list.Count();
    industry_list.Valuate(IsRawIndustry);
    industry_list.KeepValue(1);
    if (target_count <= industry_list.Count())
        return;

    // If it is not set, set prospecting industry construction type
    local construction_type = GSGameSettings.GetValue("construction.raw_industry_construction");
    if (construction_type != 2)
        GSGameSettings.SetValue("construction.raw_industry_construction", 2);

    local built_count = 0;
    local ignore_list = GSList();
    local raw_count = industry_list.Count();
    local try_count = 0;
    while (raw_count < target_count) {
        if (try_count > 3) {
            Log.Warning("Industry funding failed: " + GSError.GetLastErrorString(), Log.LVL_INFO);
            break;
        }

        local industry_type = GetRawIndustryToProspect(ignore_list);
        Log.Info("Funding industry " + GSIndustryType.GetName(industry_type), Log.LVL_DEBUG);
        if (GSIndustryType.ProspectIndustry(industry_type)) {
            if (GSIndustryList().Count() == (industry_count + built_count + 1)) {
                raw_count++;
                try_count = 0;
                built_count++;
            }
            else {
                try_count++;
            }

            // If newGRF refuses to build the industry type, prospecting returns true,
            // so the industry type must be removed from chosing
            if (try_count > 3) {
                Log.Warning("Cannot prospect " + GSIndustryType.GetName(industry_type) + ", will be skipped.", Log.LVL_INFO);
                ignore_list.AddItem(industry_type, 0);
                try_count = 0;
            }
        }
        else
            try_count++;
    }

    Log.Info("Prospected " + (raw_count - industry_list.Count()) + " raw industries up to total number of " + raw_count, Log.LVL_INFO);

    // Reset to previous construction type
    if (construction_type != 2)
        GSGameSettings.SetValue("construction.raw_industry_construction", construction_type);
}

function IsProcessingIndustry(industry)
{
    return GSIndustryType.IsProcessingIndustry(GSIndustry.GetIndustryType(industry))
}

function IsRawIndustry(industry)
{
    return GSIndustryType.IsRawIndustry(GSIndustry.GetIndustryType(industry))
}

function CanProspectIndustry(industry)
{
    return GSIndustryType.CanProspectIndustry(GSIndustry.GetIndustryType(industry))
}

function GetRawIndustryTypeRatio()
{
    local industry_type_list = GSIndustryTypeList();
    local count = industry_type_list.Count().tofloat();

    industry_type_list.Valuate(GSIndustryType.IsRawIndustry);
    industry_type_list.KeepValue(1);

    return industry_type_list.Count().tofloat() / count;
}

function GetRawIndustryTypeCount()
{
    local industry_type_list = GSIndustryTypeList();
    industry_type_list.Valuate(GSIndustryType.IsRawIndustry);
    industry_type_list.KeepValue(1);

    return industry_type_list.Count();
}

function GetRawIndustryTargetCount()
{
    local industry_density = GSController.GetSetting("raw_industry_density");
    if (industry_density == 0) // funding only
        return 0;
    else if (industry_density == 1) // minimal (one of each)
        return GetRawIndustryTypeCount();

    local ratio = GetRawIndustryTypeRatio();

    return (::NumIndustries[industry_density] * ((GSMap.GetMapSizeX() / 256.0) * (GSMap.GetMapSizeY() / 256.0)) * ratio).tointeger();
}

function GetIndustryTypeCount(industry_type)
{
    local industry_list = GSIndustryList();
    industry_list.Valuate(GSIndustry.GetIndustryType);
    industry_list.KeepValue(industry_type);
    return industry_list.Count();
}

function GetRawIndustryToProspect(ignore_list)
{
    local industry_type_list = GSIndustryTypeList();

    industry_type_list.RemoveList(ignore_list);

    industry_type_list.Valuate(GSIndustryType.IsRawIndustry);
    industry_type_list.KeepValue(1);

    industry_type_list.Valuate(GSIndustryType.CanProspectIndustry);
    industry_type_list.KeepValue(1);

    industry_type_list.Valuate(GetIndustryTypeCount);
    industry_type_list.Sort(GSList.SORT_BY_VALUE, GSList.SORT_ASCENDING);

    return industry_type_list.Begin();
}