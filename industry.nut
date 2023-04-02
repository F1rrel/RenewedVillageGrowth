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

    // Require at least one 1-cargo industry and at least two out of three [2-cargo, 3-cargo, 4+cargo] with 3 and more industry types
    if ((::industries_raw.len() + ::industries_1.len() == 0) || ((::industries_2.len() < 3).tointeger() + (::industries_3.len() < 3).tointeger() + (::industries_4.len() < 3).tointeger() > 1))
        return false;

    // Initialized required global variables
    ::CargoIDList <- [];
    for(local i = 0; i < 64; ++i) {
        if (GSCargo.GetCargoLabel(i) == "LVPT") // CZTR ZBARVENI
            ::CargoIDList.append(null);
        else if (GSCargo.GetCargoLabel(i) == null) {
            local j = i + 1;
            local list_end = true;
            while (j < 64) {
                if (GSCargo.GetCargoLabel(j) != null) {
                    list_end = false;
                    break;
                }
                j++;
            }

            if (list_end)
                break;
            else
                ::CargoIDList.append(GSCargo.GetCargoLabel(i));
        }
        else
            ::CargoIDList.append(GSCargo.GetCargoLabel(i));
    }

    ::CargoLimiter <- [0, 2];
    ::CargoCatNum <- (list_4.len() > 0 || (list_3.len() > 6 && (list_1.len() + list_raw.len()) > 9)) ? 5 : 4;
    ::Economy <- DiscoverEconomyType();

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

    // Change cargo min pop demand if specified
    for (local i = 0; i < ::CargoCatNum; i++) {
        if (::SettingsTable.category_min_pop[i] >= 0) {
            ::CargoMinPopDemand[i] = ::SettingsTable.category_min_pop[i];
        }
    }

    // Sort min pop demand, but not categories
    for (local i = 0; i < ::CargoCatNum; i++) {
        for (local j = 0; j < ::CargoCatNum - 1; j++) {
            if (::CargoMinPopDemand[j] > ::CargoMinPopDemand[j+1]) {
                local min_pop_demand = ::CargoMinPopDemand[j];
                ::CargoMinPopDemand[j] = ::CargoMinPopDemand[j+1];
                ::CargoMinPopDemand[j+1] = min_pop_demand;
            }
        }
    }

    return true;
}

function RandomizeIndustry(ascending, near_industries, near_industry_probability)
{
    local categories = [];

    local list_raw = clone ::industries_raw;
    local list_1 = clone ::industries_1;
    local list_2 = clone ::industries_2;
    local list_3 = clone ::industries_3;
    local list_4 = clone ::industries_4;

    local industry_cat_text = "";

    // 1. Category (PASS, MAIL)

    // 2. Category, pick 1 cargo
    if ((near_industries[0].len() != 0 || near_industries[1].len() != 0) &&
            GSBase.Chance(near_industry_probability, 100)) { // Use near industry

        if (near_industries[1].len() == 0) { // Use raw industry for Cat II
            local rand = GSBase.RandRange(near_industries[0].len());
            categories.append([near_industries[0][rand]]);

            // Find and remove industry id from the other array
            foreach (idx, industry in list_raw) {
                if (industry == near_industries[0][rand]) {
                    list_raw.remove(idx);
                    break;
                }
            }

            industry_cat_text += " Cat II: [" + GSIndustryType.GetName(near_industries[0][rand]) + "(NEAR)]";
            near_industries[0].remove(rand);
        }
        else { // Use 1 input industry for Cat II
            local rand = GSBase.RandRange(near_industries[1].len());
            categories.append([near_industries[1][rand]]);

            // Find and remove industry id from the other array
            foreach (idx, industry in list_1) {
                if (industry == near_industries[1][rand]) {
                    list_1.remove(idx);
                    break;
                }
            }

            industry_cat_text += " Cat II: [" + GSIndustryType.GetName(near_industries[1][rand]) + "(NEAR)]";
            near_industries[1].remove(rand);
        }
    }
    else { // Use random industry
        if (list_1.len() == 0) { // Use raw industry for Cat II
            local rand = GSBase.RandRange(list_raw.len());
            categories.append([list_raw[rand]]);

            // Find and remove industry id from the other array
            foreach (idx, industry in near_industries[0]) {
                if (industry == list_raw[rand]) {
                    near_industries[0].remove(idx);
                    break;
                }
            }

            industry_cat_text += " Cat II: [" + GSIndustryType.GetName(list_raw[rand]) + "(RAND)]";
            list_raw.remove(rand);
        }
        else { // Use 1 input industry for Cat II
            local rand = GSBase.RandRange(list_1.len());
            categories.append([list_1[rand]]);

            // Find and remove industry id from the other array
            foreach (idx, industry in near_industries[1]) {
                if (industry == list_1[rand]) {
                    near_industries[1].remove(idx);
                    break;
                }
            }

            industry_cat_text += " Cat II: [" + GSIndustryType.GetName(list_1[rand]) + "(RAND)]";
            list_1.remove(rand);
        }
    }

    // 3. Category, pick 2 cargos
    if (near_industries[2].len() != 0 && GSBase.Chance(near_industry_probability, 100)) { // Use near industry
        // Use 2 input industry for Cat III
        local rand = GSBase.RandRange(near_industries[2].len());
        categories.append([near_industries[2][rand]]);

        // Find and remove industry id from the other array
        foreach (idx, industry in list_2) {
            if (industry == near_industries[2][rand]) {
                list_2.remove(idx);
                break;
            }
        }

        industry_cat_text += " Cat III: [" + GSIndustryType.GetName(near_industries[2][rand]) + "(NEAR)]";
        near_industries[2].remove(rand);
    }
    else { // Use random industry
        if (list_2.len() > 2 || (list_1.len() < 2 && list_2.len() > 0)) { // Use 2 input industry for Cat II
            local rand = GSBase.RandRange(list_2.len());
            categories.append([list_2[rand]]);

            // Find and remove industry id from the other array
            foreach (idx, industry in near_industries[2]) {
                if (industry == list_2[rand]) {
                    near_industries[2].remove(idx);
                    break;
                }
            }

            industry_cat_text += " Cat III: [" + GSIndustryType.GetName(list_2[rand]) + "(RAND)]";
            list_2.remove(rand);
        }
        else {
            // Prevent using only max 2 industries by giving chance to use 1+1
            local rand = GSBase.RandRange(3);
            if (rand < list_2.len()) {
                categories.append([list_2[rand]]);

                // Find and remove industry id from the other array
                foreach (idx, industry in near_industries[2]) {
                    if (industry == list_2[rand]) {
                        near_industries[2].remove(idx);
                        break;
                    }
                }

                industry_cat_text += " Cat III: [" + GSIndustryType.GetName(list_2[rand]) + "(RAND)]";
                list_2.remove(rand);
            }
            else {
                if (list_raw.len() > 0) {
                    local rand_1 = GSBase.RandRange(list_1.len());
                    local rand_raw = GSBase.RandRange(list_raw.len());
                    categories.append([list_1[rand_1], list_raw[rand_raw]]);

                    // Find and remove industry id from the other array
                    foreach (idx, industry in near_industries[1]) {
                        if (industry == list_1[rand_1]) {
                            near_industries[1].remove(idx);
                            break;
                        }
                    }
                    foreach (idx, industry in near_industries[0]) {
                        if (industry == list_raw[rand_raw]) {
                            near_industries[0].remove(idx);
                            break;
                        }
                    }

                    industry_cat_text += " Cat III: [" + GSIndustryType.GetName(list_1[rand_1]) + ", " + GSIndustryType.GetName(list_raw[rand_raw]) + "(RAND)]";
                    list_1.remove(rand_1);
                    list_raw.remove(rand_raw);
                }
                else {
                    local rand_1 = GSBase.RandRange(list_1.len());
                    local rand_1_ind = list_1[rand_1];
                    list_1.remove(rand_1);
                    local rand_2 = GSBase.RandRange(list_1.len() - 1);
                    categories.append([rand_1_ind, list_1[rand_2]]);

                    // Find and remove industry id from the other array
                    foreach (idx, industry in near_industries[1]) {
                        if (industry == list_1[rand_2] || industry == rand_1_ind) {
                            near_industries[1].remove(idx);
                        }
                    }

                    industry_cat_text += " Cat III: [" + GSIndustryType.GetName(rand_1_ind) + ", " + GSIndustryType.GetName(list_1[rand_2]) + "(RAND)]";
                    list_1.remove(rand_2);
                }
            }
        }
    }

    // 4. Category, pick 3 cargos
    if (near_industries[3].len() != 0 && GSBase.Chance(near_industry_probability, 100)) { // Use near industry
        // Use 3 input industry for Cat IV
        local rand = GSBase.RandRange(near_industries[3].len());
        categories.append([near_industries[3][rand]]);

        // Find and remove industry id from the other array
        foreach (idx, industry in list_3) {
            if (industry == near_industries[3][rand]) {
                list_3.remove(idx);
                break;
            }
        }

        industry_cat_text += " Cat IV: [" + GSIndustryType.GetName(near_industries[3][rand]) + "(NEAR)]";
        near_industries[3].remove(rand);
    }
    else { // Use random industry
        if (list_3.len() > 2 || ((list_2.len() == 0 || (list_1.len() + list_raw.len() == 0)) && list_3.len() > 0)) {
            local rand = GSBase.RandRange(list_3.len());
            categories.append([list_3[rand]]);

            // Find and remove industry id from the other array
            foreach (idx, industry in near_industries[3]) {
                if (industry == list_3[rand]) {
                    near_industries[3].remove(idx);
                    break;
                }
            }

            industry_cat_text += " Cat IV: [" + GSIndustryType.GetName(list_3[rand]) + "(RAND)]";
            list_3.remove(rand);
        }
        else {
            // Prevent using only max 2 industries by giving chance to use 1+2
            local rand = GSBase.RandRange(3);
            if (rand < list_3.len()) {
                categories.append([list_3[rand]]);

                // Find and remove industry id from the other array
                foreach (idx, industry in near_industries[3]) {
                    if (industry == list_3[rand]) {
                        near_industries[3].remove(idx);
                        break;
                    }
                }

                industry_cat_text += " Cat IV: [" + GSIndustryType.GetName(list_3[rand]) + "(RAND)]";
                list_3.remove(rand);
            }
            else {
                local list = clone list_1;
                list.extend(list_raw);

                local rand_1 = GSBase.RandRange(list.len());
                local rand_2 = GSBase.RandRange(list_2.len());

                categories.append([list[rand_1], list_2[rand_2]]);
                industry_cat_text += " Cat III: [" + GSIndustryType.GetName(list[rand_1]) + ", " + GSIndustryType.GetName(list_2[rand_2]) + "(RAND)]";
                if (rand_1 < list_1.len()) {
                    // Find and remove industry id from the other array
                    foreach (idx, industry in near_industries[1]) {
                        if (industry == list[rand_1]) {
                            near_industries[1].remove(idx);
                            break;
                        }
                    }

                    list_1.remove(rand_1);
                }
                else {
                    // Find and remove industry id from the other array
                    foreach (idx, industry in near_industries[0]) {
                        if (industry == list[rand_1]) {
                            near_industries[0].remove(idx);
                            break;
                        }
                    }

                    list_raw.remove(rand_1 - list_1.len());
                }

                // Find and remove industry id from the other array
                foreach (idx, industry in near_industries[2]) {
                    if (industry == list[rand_2]) {
                        near_industries[2].remove(idx);
                        break;
                    }
                }

                list_2.remove(rand_2);
            }
        }
    }

    // 5. Category, pick 4 or more cargos
    // Dont need to remove used ids in the last category
    if (near_industries[4].len() != 0 && GSBase.Chance(near_industry_probability, 100)) { // Use near industry
        // Use 4+ input industry for Cat V
        local rand = GSBase.RandRange(near_industries[4].len());
        categories.append([near_industries[4][rand]]);

        industry_cat_text += " Cat V: [" + GSIndustryType.GetName(near_industries[4][rand]) + "(NEAR)]";
    }
    else { // Use random industry
        if (list_4.len() > 2 || ((list_3.len() < 5 || (list_1.len() + list_raw.len() < 5)) && list_4.len() > 0)) {
            local rand = GSBase.RandRange(list_4.len());
            categories.append([list_4[rand]]);
            industry_cat_text += " Cat V: [" + GSIndustryType.GetName(list_4[rand]) + "(RAND)]";
        }
        else if (list_4.len() > 0 && (list_1.len() + list_raw.len() > 0) && list_3.len() > 0) {
            local rand = GSBase.RandRange(3);
            if (rand < list_4.len()) {
                categories.append([list_4[rand]]);
                industry_cat_text += " Cat V: [" + GSIndustryType.GetName(list_4[rand]) + "(RAND)]";
            }
            else {
                local list = clone list_1;
                list.extend(list_raw);

                local rand_1 = GSBase.RandRange(list.len());
                local rand_3 = GSBase.RandRange(list_3.len());

                categories.append([list[rand_1], list_3[rand_3]]);
                industry_cat_text += " Cat V: [" + GSIndustryType.GetName(list[rand_1]) + ", " + GSIndustryType.GetName(list_3[rand_3]) + "(RAND)]";
            }
        }
        else if (list_3.len() > 4 && (list_1.len() + list_raw.len() > 4)) {
            local list = clone list_1;
            list.extend(list_raw);

            local rand_1 = GSBase.RandRange(list.len());
            local rand_3 = GSBase.RandRange(list_3.len());

            categories.append([list[rand_1], list_3[rand_3]]);
            industry_cat_text += " Cat V: [" + GSIndustryType.GetName(list[rand_1]) + ", " + GSIndustryType.GetName(list_3[rand_3]) + "(RAND)]";
        }
    }

    Log.Info(GSTown.GetName(this.id) + ":" + industry_cat_text, Log.LVL_SUB_DECISIONS);

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
                // Ignore PASS and MAIL
                if (cargo == 0 || cargo == 2)
                    continue;

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
    // In multiplayer, pause level cannot be changed, so skip funding industries
    local pause_level = GSGameSettings.GetValue("construction.command_pause_level");
    if (GSGame.IsPaused() && GSGame.IsMultiplayer() && pause_level < 3)
        return;

    local target_count = GetRawIndustryTargetCount();
    if (target_count == 0)
        return;

    local industry_list = GSIndustryList();
    local industry_count = industry_list.Count();
    industry_list.Valuate(IsRawIndustry);
    industry_list.KeepValue(1);
    if (target_count <= industry_list.Count())
        return;

    // If it is not set, temporarily set prospecting industry construction type
    local construction_type = GSGameSettings.GetValue("construction.raw_industry_construction");
    if (construction_type != 2)
        GSGameSettings.SetValue("construction.raw_industry_construction", 2);

    // If it is not set, temporarily allow all actions during pause (for prospecting)
    if (pause_level < 3)
        GSGameSettings.SetValue("construction.command_pause_level", 3);

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
        if (industry_type == null)
            break;

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

    // Reset to previous settings
    GSGameSettings.SetValue("construction.raw_industry_construction", construction_type);
    GSGameSettings.SetValue("construction.command_pause_level", pause_level);
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

    return industry_type_list.Count() ? industry_type_list.Begin() : null;
}

/**
 * @brief Find closest town to each industry on the map.
 * @return table containing {town_id, [industry_ids]}
 */
function GetNearbyIndustriesToTowns()
{
    local industry_list = GSIndustryList();
    local town_list = GSTownList();

    // Initialize town industries table
    local town_industries = {};
    foreach (town_id, _ in town_list) {
        town_industries[town_id] <- [];
    }

    // Find closest town to each industry
    foreach (industry_id, _ in industry_list) {
        local town_list_clone = GSList();
        town_list_clone.AddList(town_list);
        local industry_location = GSIndustry.GetLocation(industry_id);

        town_list_clone.Valuate(GSTown.GetDistanceManhattanToTile, industry_location);
        town_list_clone.Sort(GSList.SORT_BY_VALUE, true);

        town_industries[town_list_clone.Begin()].append(industry_id);
    }

    // Print town_industries
    DebugTownIndustries(town_industries);

    return town_industries;
}

function GetTownsNearbyIndustryPerCategory()
{
    local town_industries = GetNearbyIndustriesToTowns();
    local town_industry_category = {};

    foreach (town_id, industry_ids in town_industries) {
        town_industry_category[town_id] <- [];

        for (local i = 0; i < 5; ++i) {
            town_industry_category[town_id].append([]);
        }

        foreach (industry_id in industry_ids) {
            local industry_type_id = GSIndustry.GetIndustryType(industry_id);

            // Determine the category of this industry type
            local cargo_list = GSIndustryType.GetAcceptedCargo(industry_type_id);
            cargo_list.RemoveItem(0); // exclude PASS
            cargo_list.RemoveItem(2); // exclude MAIL
            local category = -1;
            switch (cargo_list.Count())
            {
                case 0:
                    break;
                case 1:
                    if (GSIndustryType.IsRawIndustry(industry_type_id))
                        category = 0;
                    else
                        category = 1;
                    break;
                case 2:
                    if (GSIndustryType.IsRawIndustry(industry_type_id))
                        category = 0;
                    else
                        category = 2;
                    break;
                case 3:
                    category = 3;
                    break;
                default:
                    category = 4;
            }

            // No accepting cargo
            if (category < 0)
                continue;

            // Check if it already exists in the list, if not, add it there
            local found = false;
            foreach (saved_industry_type in town_industry_category[town_id][category]) {
                if (saved_industry_type == industry_type_id) {
                    found = true;
                    break;
                }
            }

            if (!found) {
                town_industry_category[town_id][category].append(industry_type_id);
            }
        }
    }

    // Print results
    DebugNearTownIndustryTypes(town_industry_category);

    return town_industry_category;
}