enum SubsidiesType
{
    NONE = 0,
    ALL = 1,
    PASSENGER = 2,
    CARGO = 3
}

function SortTowns(towns, companies)
{
    // sorted_towns
    // - not_monitored
    //   - [town_id, ...]
    // - contributed
    //   - company_id
    //     - [town_index, ...] (index of town in towns class list)
    local sorted_towns = {
        not_monitored = [],
        contributed = {}
    };

    foreach (company in companies) {
        sorted_towns.contributed[company.id] <- [];
    }

    foreach (index, town in towns) {
        if (!town.is_monitored)
            sorted_towns.not_monitored.append(town.id);
        else if (town.contributor != -1)
            sorted_towns.contributed[town.contributor].append(index);
    }

    return sorted_towns;
}

function GetBiggestPopulationTown(town_list, towns)
{
    local biggest_town = null;
    local biggest_town_population = null;

    foreach (index in town_list) {
        local population = GSTown.GetPopulation(towns[index].id);
        if (biggest_town_population == null || population > biggest_town_population) {
            biggest_town_population = population;
            biggest_town = towns[index].id;
        }
    }

    return biggest_town;
}

function FindClosestTown(town_list, town_id)
{
    local closest_town = null;
    local closest_town_distance = null;
    local town_location = GSTown.GetLocation(town_id);

    // Create list of towns already subsidised to be ignored
    local subsidies_list = GSSubsidyList();
    subsidies_list.Valuate(GSSubsidy.GetSourceType);
    subsidies_list.KeepValue(1);
    subsidies_list.Valuate(GSSubsidy.GetSourceIndex);
    subsidies_list.KeepValue(town_id);
    subsidies_list.Valuate(GSSubsidy.GetDestinationIndex);
    local ignore_list = GSList();
    foreach (id, value in subsidies_list) {
        ignore_list.AddItem(value, id);
    }

    foreach (town in town_list) {
        local distance = GSTown.GetDistanceManhattanToTile(town, town_location);
        if (!ignore_list.HasItem(town) && (closest_town_distance == null || closest_town_distance > distance)) {
            closest_town_distance = distance;
            closest_town = town;
        }
    }

    return closest_town;
}

function GetNotProvidedCargo(town_list, towns)
{
    // not_provided_cargo
    // - [{}, ...]
    //   - cargo_id
    //   - accepting_industry_id
    //   - providing_industry_id
    local not_provided_cargo = [];
    local town_industries = GetNearbyIndustriesToTowns();

    foreach (i, index in town_list) {
        local near_industries = town_industries[towns[index].id];

        for (local i = 1; i < ::CargoCatNum; ++i) {
            // Dont consider not achieved cargo categories
            if (towns[index].town_goals_cat[i] == 0)
                break;

            // Get only categories that are not supplied or not sufficiently supplied
            if (towns[index].town_stockpiled_cat[i] == 0) {
                // Create pairs of cargo type and industry id
                // Cargo type must be accepted by nearby industry
                // Exists cargo providing industry without already transporting it
                foreach (cargo in towns[index].town_cargo_cat[i]) {
                    foreach (industry in near_industries) {
                        if (GSIndustry.IsCargoAccepted(industry, cargo)) {
                            local industry_list = GSIndustryList_CargoProducing(cargo);

                            // Find industries without already transporting that cargo type
                            industry_list.Valuate(GSIndustry.GetLastMonthTransported, cargo);
                            industry_list.KeepValue(0);

                            // Find industries that are not too far or not too close
                            industry_list.Valuate(GSIndustry.GetDistanceManhattanToTile, GSIndustry.GetLocation(industry));
                            industry_list.KeepBetweenValue(50, 500);

                            if (industry_list.Count()) {
                                // Choose randomly one of the industries
                                industry_list.Valuate(GSBase.RandItem);
                                not_provided_cargo.append({cargo_id = cargo, accepting_industry_id = industry, providing_industry_id = industry_list.Begin()});
                            }
                        }
                    }
                }
            }
        }

        // Limit searching for not provided cargos so that it does not take too much processing
        if (i > 5 && not_provided_cargo.len() > 20)
            break;
    }

    return not_provided_cargo;
}

function CreateSubsidies(towns, companies)
{
    if (GSGameSettings.GetValue("difficulty.subsidy_duration") == 0)
        return;

    local subsidies_type = GSController.GetSetting("subsidies_type");
    if (subsidies_type == SubsidiesType.NONE)
        return;

    local subsidies = {};

    // Sort industries per towns
    local sorted_towns = SortTowns(towns, companies);
    DebugSortedTowns(sorted_towns, towns);

    // Find town and cargo subsidies
    foreach (company, town_list in sorted_towns.contributed) {
        subsidies[company] <- {
            town_subsidy = null,
            cargo_subsidy = null
        };

        // Create town subsidy
        if (subsidies_type == SubsidiesType.ALL || subsidies_type == SubsidiesType.PASSENGER) {
            local biggest_town_id = GetBiggestPopulationTown(town_list, towns);
            if (biggest_town_id != null) {
                local closest_town_id = FindClosestTown(sorted_towns.not_monitored, biggest_town_id);
                if (closest_town_id != null) {
                    subsidies[company].town_subsidy = {
                        town_1 = biggest_town_id,
                        town_2 = closest_town_id
                    };
                }
            }
        }

        // Create cargo subsidy
        if (subsidies_type == SubsidiesType.ALL || subsidies_type == SubsidiesType.CARGO) {
            local not_provided_cargo = GetNotProvidedCargo(town_list, towns);
            if (not_provided_cargo.len()) {
                local random_index = GSBase.RandRange(not_provided_cargo.len());
                subsidies[company].cargo_subsidy = not_provided_cargo[random_index];
            }
        }
    }

    // Create subsidies
    foreach (company, subs in subsidies) {
        if (subs.town_subsidy != null) {
            local success = GSSubsidy.Create(
                Helper.GetPAXCargo(),
                GSSubsidy.SPT_TOWN, subs.town_subsidy.town_1,
                GSSubsidy.SPT_TOWN, subs.town_subsidy.town_2);
        }

        if (subs.cargo_subsidy != null) {
            local success = GSSubsidy.Create(
                subs.cargo_subsidy.cargo_id,
                GSSubsidy.SPT_INDUSTRY, subs.cargo_subsidy.providing_industry_id,
                GSSubsidy.SPT_INDUSTRY, subs.cargo_subsidy.accepting_industry_id);
        }
    }

    DebugSubsidies(subsidies);
}