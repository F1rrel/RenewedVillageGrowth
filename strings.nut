
function GoalTown::TownBoxText(growth_enabled, text_mode, redraw=false)
{
    local text_townbox = null;

    // If the function is called with false, town is not growing. Give a help message.
    local display_cargo = ::SettingsTable.randomization == Randomization.NONE ? false : ::SettingsTable.display_cargo;
    if (!growth_enabled || 0 == text_mode) {
        if (display_cargo) {
            text_townbox = GSText(GSText["STR_TOWNBOX_CARGO_"+(::CargoCatNum-1)]);
            text_townbox = this.TownTextContributor(text_townbox);

            local cargo_mask = 0;
            foreach (cargo in ::CargoLimiter) {
                cargo_mask = cargo_mask | 1 << cargo;
            }
            text_townbox.AddParam(GSText(GSText.STR_TOWNBOX_NOGROWTH, cargo_mask));

            foreach (index, category in this.town_cargo_cat) {
                cargo_mask = 0;
                foreach (cargo in category) {
                    cargo_mask = cargo_mask | 1 << cargo;
                }
                text_townbox.AddParam(GSText(GSText["STR_CARGOCAT_LABEL_"+::CargoCatList[index]]));
                text_townbox.AddParam(cargo_mask);
            }
        } else {
            local cargo_mask = 0;
            foreach (cargo in ::CargoLimiter) {
                cargo_mask = cargo_mask | 1 << cargo;
            }
            text_townbox = GSText(GSText.STR_TOWNBOX_NOGROWTH, cargo_mask);
        }
        return text_townbox;
    }

    switch (text_mode) {
        case 1: // automatic
            if (::SettingsTable.randomization == Randomization.NONE) {
                text_townbox = this.TownTextCategories();
                break;
            } else if (::SettingsTable.randomization == Randomization.INDUSTRY_DESC
                    || ::SettingsTable.randomization == Randomization.INDUSTRY_ASC) {
                text_townbox = this.TownTextCategoriesCombined(display_cargo);
                break;
            }

            if (!redraw) {
                this.town_text_scroll = (this.town_text_scroll < 1) ? this.town_text_scroll + 1 : 0;
            }
            if (this.town_text_scroll > 0) {
                text_townbox = this.TownTextCargos(display_cargo);
            } else {
                text_townbox = this.TownTextCategories();
            }
            break;
        case 2: // categories
            text_townbox = this.TownTextCategories();
            break;
        case 3: // cargos
            text_townbox = this.TownTextCargos(display_cargo);
            break;
        case 4: // combined
            text_townbox = this.TownTextCategoriesCombined(display_cargo);
            break;
        case 5: // all cargos
            text_townbox = this.TownTextCargos(true);
            break;
    }

    return text_townbox;
}

function GoalTown::TownTextLimiter(text_townbox, category)
{
    local str = category ? "CATEGORY" : "CARGO";

    if (this.allowGrowth && this.limit_delay > 0 && this.limit_transported != 0) {
        text_townbox.AddParam(GSText(GSText["STR_TOWNBOX_" + str + "_DELAYED"], this.limit_transported));
    }
    else if (this.allowGrowth && this.limit_transported != 0) {
        text_townbox.AddParam(GSText(GSText["STR_TOWNBOX_" + str + "_LOW"], this.limit_transported));
    }
    else if (!this.allowGrowth) {
        text_townbox.AddParam(GSText(GSText["STR_TOWNBOX_" + str + "_STOP"], this.limit_transported));
    }
    else {
        text_townbox.AddParam(GSText(GSText["STR_TOWNBOX_" + str], GSText(GSText.STR_EMPTY)));
    }

    return text_townbox;
}

function GoalTown::TownTextContributor(text_townbox)
{
    if (this.contributor < 0) {
        text_townbox.AddParam(GSText(GSText.STR_TOWNBOX_NO_CONTRIBUTOR, this.max_population, GSText(GSText.STR_EMPTY)));
    }
    else {
        text_townbox.AddParam(GSText(GSText.STR_TOWNBOX_CONTRIBUTOR, this.max_population, this.contributor));
    }

    return text_townbox;
}


/* Function which builds town texts.
 * Town text will look like below:
 * Cargocat label: required/last supplied/stockpiled
 */
function GoalTown::TownTextCategories()
{
    local max_cat = 0;
    while (max_cat < ::CargoCatNum-1) {
        if (this.town_goals_cat[max_cat + 1] == 0) break;
        max_cat++;
    }

    local text_townbox = GSText(GSText["STR_TOWNBOX_CATEGORY_" + max_cat]);
    text_townbox = this.TownTextContributor(text_townbox);
    text_townbox = this.TownTextLimiter(text_townbox, true);

    for (local i = 0; i <= max_cat; i++) {
        text_townbox.AddParam(GSText(GSText["STR_CARGOCAT_LABEL_" + ::CargoCatList[i]]));
        text_townbox.AddParam(this.town_supplied_cat[i]);
        text_townbox.AddParam(this.town_goals_cat[i]);
    }

    return text_townbox;
}

function GoalTown::TownTextCategoriesCombined(display_all)
{
    local max_cat = 0;
    if (display_all) {
        max_cat = ::CargoCatNum-1;
    } else {
        while (max_cat < ::CargoCatNum-1) {
            if (this.town_goals_cat[max_cat + 1] == 0) break;
            max_cat++;
        }
    }

    local text_townbox = GSText(GSText["STR_TOWNBOX_COMBINED_" + max_cat]);
    text_townbox = this.TownTextContributor(text_townbox);
    text_townbox = this.TownTextLimiter(text_townbox, true);

    for (local index = 0; index <= max_cat; ++index) {
        local cargo_mask = 0;
        foreach (cargo in this.town_cargo_cat[index]) {
            cargo_mask += 1 << cargo;
        }
        text_townbox.AddParam(cargo_mask);
        text_townbox.AddParam(this.town_supplied_cat[index]);
        text_townbox.AddParam(this.town_goals_cat[index]);
    }

    return text_townbox;
}

function GoalTown::TownTextCargos(display_all)
{
    local max_cat = 0;
    if (display_all) {
        max_cat = ::CargoCatNum-1;
    } else {
        while (max_cat < ::CargoCatNum-1) {
            if (this.town_goals_cat[max_cat+1] == 0) break;
            max_cat++;
        }
    }

    local text_townbox = GSText(GSText["STR_TOWNBOX_CARGO_" + max_cat]);
    text_townbox = this.TownTextContributor(text_townbox);
    text_townbox = this.TownTextLimiter(text_townbox, false);

    for (local index = 0; index <= max_cat; ++index) {
        local cargo_mask = 0;
        foreach (cargo in this.town_cargo_cat[index]) {
            cargo_mask += 1 << cargo;
        }
        text_townbox.AddParam(GSText(GSText["STR_CARGOCAT_LABEL_" + ::CargoCatList[index]]));
        text_townbox.AddParam(cargo_mask);
    }

    return text_townbox;
}

/* Building the text for towns' signtexts. */
function GoalTown::TownSignText()
{
    local text_townsign = null;
    if (GSTown.GetGrowthRate(this.id) > 880) {
        text_townsign = GSText(GSText.STR_TOWNSIGN_NOTGROWING);
    } else {
        local growth_rate = GSTown.GetGrowthRate(this.id);
        if (::SettingsTable.wallclock_timekeeping == 1) { // Wallclock Timekeeping
            if (growth_rate > 300)
                text_townsign = GSText(GSText.STR_TOWNSIGN_GROWTHRATE, GSTown.GetGrowthRate(this.id) / 30, GSText(GSText.STR_TOWNSIGN_MINUTES));
            else
                text_townsign = GSText(GSText.STR_TOWNSIGN_GROWTHRATE, GSTown.GetGrowthRate(this.id) * 2, GSText(GSText.STR_TOWNSIGN_SECONDS));
        } else {
            if (growth_rate > 360)
                text_townsign = GSText(GSText.STR_TOWNSIGN_GROWTHRATE, GSTown.GetGrowthRate(this.id) / 30, GSText(GSText.STR_TOWNSIGN_MONTHS));
            else
                text_townsign = GSText(GSText.STR_TOWNSIGN_GROWTHRATE, GSTown.GetGrowthRate(this.id), GSText(GSText.STR_TOWNSIGN_DAYS));
        }
    }
    return text_townsign;
}

/* Helper function: get a list of currently used cargo labels/ID. */
function DebugCargoLabels()
{
    foreach (index, cargo_label in ::CargoIDList) {
        Log.Info("Cargo " + index + ": " + cargo_label, Log.LVL_SUB_DECISIONS);
    }
}

/* Debug function: print supplied cargo. */
function GoalTown::DebugCargoSupplied(i, supplied)
{
    Log.Info(GSTown.GetName(this.id)+": supplied "+GSCargo.GetCargoLabel(i)+"="
         +supplied, Log.LVL_DEBUG);
}

/* Debug function: print supplied cargo towards category for the company. */
function GoalTown::DebugCompanyCategorySupplied(cid, cat, supplied)
{
    Log.Info(GSCompany.GetName(cid) + " cat " + cat + ": supplied " + supplied, Log.LVL_DEBUG);
}

/* Debug function: print stockpiled/supplied/goal per cargo category. */
function GoalTown::DebugCargoCatInfo(i)
{
    Log.Info(GSTown.GetName(this.id)+": Cat. "+(i+1)
         +" - Goal="+this.town_goals_cat[i]
         +" Supplied="+this.town_supplied_cat[i]
         +" Stockpiled="+this.town_stockpiled_cat[i], Log.LVL_DEBUG);
}

/* Debug function: print the general goals achievement before calculating the new TGR. */
function GoalTown::DebugGoalsResult(sum_goals, goal_diff, goal_diff_percent)
{
    Log.Info(GSTown.GetName(this.id)+": sum_goals="+sum_goals+" goal_diff="+goal_diff+" goal_diff_percent="
         +goal_diff_percent, Log.LVL_DEBUG);
}

/* Debug function: print the content of the TGR array. */
function GoalTown::DebugTgrArray()
{
    local array_text = " ";
    foreach (i, val in this.tgr_array) {
        array_text = array_text+"i"+i+"="+val+" ";
    }
    Log.Info(GSTown.GetName(this.id)+": "+array_text+"Average="+this.tgr_average, Log.LVL_DEBUG);
}

function GoalTown::DebugCargoHash(hash)
{
    local cargo_text = "";
    for (local i = 0; i < 64; i++)
    {
        if (hash & (1 << i)) {
            cargo_text += GSCargo.GetCargoLabel(i) + ",";
        }
    }
    Log.Info(GSTown.GetName(this.id) + ": " + cargo_text, Log.LVL_DEBUG);
}

function GoalTown::DebugCargoTable(cargo_table)
{
    local cargo_text = "";
    foreach (index, cat in cargo_table) {
        cargo_text += "  " + (index + 1) + ": ";
        foreach (cargo in cat) {
            cargo_text += GSCargo.GetCargoLabel(cargo) + ",";
        }
    }
    Log.Info(GSTown.GetName(this.id) + ": " + cargo_text, Log.LVL_SUB_DECISIONS);
}

function DebugIndustryLists()
{
    local str = ::industries_raw.len() + " Raw industries: | ";
    foreach (industry in ::industries_raw) {
        str += industry + " " + GSIndustryType.GetName(industry) + " | ";
    }
    Log.Info(str, Log.LVL_DEBUG);

    str = ::industries_1.len() + " Accepting 1 cargos: | ";
    foreach (industry in ::industries_1) {
        str += industry + " " + GSIndustryType.GetName(industry) + " | ";
    }
    Log.Info(str, Log.LVL_DEBUG);

    str = ::industries_2.len() + " Accepting 2 cargos: | ";
    foreach (industry in ::industries_2) {
        str += industry + " " + GSIndustryType.GetName(industry) + " | ";
    }
    Log.Info(str, Log.LVL_DEBUG);

    str = ::industries_3.len() + " Accepting 3 cargos: | ";
    foreach (industry in ::industries_3) {
        str += industry + " " + GSIndustryType.GetName(industry) + " | ";
    }
    Log.Info(str, Log.LVL_DEBUG);

    str = ::industries_4.len() + " Accepting 4 and more cargos: | ";
    foreach (industry in ::industries_4) {
        str += industry + " " + GSIndustryType.GetName(industry) + " | ";
    }
    Log.Info(str, Log.LVL_DEBUG);
}

function GoalTown::DebugRandomizationIndustry(categories)
{
    local str = "";
    foreach (index, category in categories) {
        str += "  " + (index + 1) + ": ";
        foreach (industry in category) {
            str += GSIndustryType.GetName(industry) + ",";
        }
    }
    Log.Info(GSTown.GetName(this.id) + ": " + str, Log.LVL_SUB_DECISIONS);
}

function DebugTownIndustries(town_industries)
{
    foreach (town, industry_list in town_industries) {
        local industries_text = "";
        foreach (industry in industry_list) {
            industries_text += "    " + GSIndustry.GetName(industry) + ", ";
        }
        Log.Info(GSTown.GetName(town) + ": " + industries_text, Log.LVL_DEBUG);
    }
}

function DebugSortedTowns(sorted_towns, towns)
{
    Log.Info("Not monitored towns:", Log.LVL_SUB_DECISIONS);
    local text = "";
    foreach (town in sorted_towns.not_monitored) {
        text += " \"" + GSTown.GetName(town) + "\"";
    }
    Log.Info(text, Log.LVL_SUB_DECISIONS);

    Log.Info("Contributed towns:", Log.LVL_SUB_DECISIONS);
    foreach (company, town_list in sorted_towns.contributed) {
        text = GSCompany.GetName(company) + ":";
        foreach (town_index in town_list) {
            text += " \"" + GSTown.GetName(towns[town_index].id) + "\"";
        }
        Log.Info(text, Log.LVL_SUB_DECISIONS);
    }
}

function DebugSubsidies(subsidies)
{
    Log.Info("Subsidies:", Log.LVL_SUB_DECISIONS);
    foreach (company, subs in subsidies) {
        local text = GSCompany.GetName(company) + ": ";
        if (subs.town_subsidy != null)
            text += "[ Town subsidy: " + GSTown.GetName(subs.town_subsidy.town_1) + " -> " + GSTown.GetName(subs.town_subsidy.town_2) + " ]";
        if (subs.cargo_subsidy != null)
            text += " [ Cargo subsidy: \"" + GSCargo.GetName(subs.cargo_subsidy.cargo_id) + "\" " + GSIndustry.GetName(subs.cargo_subsidy.providing_industry_id) + " -> " + GSIndustry.GetName(subs.cargo_subsidy.accepting_industry_id) + " ]";
        Log.Info(text, Log.LVL_SUB_DECISIONS);
    }
}

function DebugNearTownCargos(near_town_cargos)
{
    foreach (town, categories in near_town_cargos) {
        local cargos_text = "";
        foreach (cat_idx, cargos in categories) {
            cargos_text += cat_idx + " [";
            foreach (cargo in cargos) {
                cargos_text += GSCargo.GetCargoLabel(cargo) + ", ";
            }
            cargos_text += "] ";
        }
        Log.Info(GSTown.GetName(town) + ": " + cargos_text, Log.LVL_DEBUG);
    }
}

function DebugNearTownIndustryTypes(near_town_industry_types)
{
    foreach (town, categories in near_town_industry_types) {
        local industry_text = "";
        foreach (cat_idx, industry_types in categories) {
            industry_text += cat_idx + " [";
            foreach (industry in industry_types) {
                industry_text += GSIndustryType.GetName(industry) + ", ";
            }
            industry_text += "] ";
        }
        Log.Info(GSTown.GetName(town) + ": " + industry_text, Log.LVL_DEBUG);
    }
}