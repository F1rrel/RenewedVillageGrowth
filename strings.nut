
function GoalTown::TownBoxText(growth_enabled, text_mode)
{
	local text_townbox = null;

	// If the function is called with false, town is not growing. Give a help message.
	if (!growth_enabled || 0 == text_mode) {
		local display_cargo = GSController.GetSetting("display_cargo");
		if (display_cargo) {
			text_townbox = GSText(GSText["STR_TOWNBOX_IND_"+::CargoCatNum+"_NOGROWTH"]);
			foreach (index, category in this.town_cargo_cat) {
				local cargo_mask = 0;
				foreach (cargo in category) {
					cargo_mask += 1 << cargo;
				}
				if (index == 0)
					text_townbox.AddParam(cargo_mask);
				text_townbox.AddParam(cargo_mask);
			}
		} else {
			local cargo_mask = 0;
			foreach (cargo in this.town_cargo_cat[0]) {
				cargo_mask += 1 << cargo;
			}
			text_townbox = GSText(GSText.STR_TOWNBOX_NOGROWTH, cargo_mask);
		}
		return text_townbox;
	}

	switch (text_mode) {
		case 1: // automatic
			if (::SettingsTable.randomization == 1) {
				text_townbox = this.TownTextCategories();
			}
			else if (!this.limit_growth) {
				text_townbox = this.TownTextCategoriesCombined();
			}
			else if (this.town_text_scroll > 0) {
				text_townbox = this.TownTextCargos();
				this.town_text_scroll = 0;
			} else {
				text_townbox = this.TownTextCategories();
				++this.town_text_scroll;
			}
			break;
		case 2: // categories
			text_townbox = this.TownTextCategories();
			break;
		case 3: // cargos
			text_townbox = this.TownTextCargos(GSController.GetSetting("display_cargo"));
			break;
		case 4: // all cargos
			text_townbox = this.TownTextCargos(true);
			break;
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
		if (this.town_goals_cat[max_cat+1] == 0) break;
		max_cat++;
	}

	local text_townbox = GSText(GSText["STR_TOWNBOX_IND_"+::CargoCatNum+"_CAT_"+max_cat]);
	text_townbox.AddParam(this.limit_passangers[0]);
	text_townbox.AddParam(this.limit_passangers[1]);
	text_townbox.AddParam(this.limit_mails[0]);
	text_townbox.AddParam(this.limit_mails[1]);
	for (local i = 0; i <= max_cat; i++) {
		text_townbox.AddParam(this.town_goals_cat[i]);
		text_townbox.AddParam(this.town_supplied_cat[i]);
		text_townbox.AddParam(this.town_stockpiled_cat[i]);
	}
	
	return text_townbox;
}

function GoalTown::TownTextCategoriesCombined()
{
	local max_cat = 0;
	while (max_cat < ::CargoCatNum-1) {
		if (this.town_goals_cat[max_cat+1] == 0) break;
		max_cat++;
	}

	local text_townbox = GSText(GSText["STR_TOWNBOX_IND_"+::CargoCatNum+"_COMB_"+max_cat]);
	foreach (index, category in this.town_cargo_cat) {
		if (index != 0) {
			local cargo_mask = 0;
			foreach (cargo in category) {
				cargo_mask += 1 << cargo;
			}
			text_townbox.AddParam(cargo_mask);
		}
		text_townbox.AddParam(this.town_goals_cat[index]);
		text_townbox.AddParam(this.town_supplied_cat[index]);
		text_townbox.AddParam(this.town_stockpiled_cat[index]);
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

	local text_townbox = GSText(GSText["STR_TOWNBOX_IND_"+::CargoCatNum+"_CARGO_"+max_cat]);
	text_townbox.AddParam(this.limit_passangers[0]);
	text_townbox.AddParam(this.limit_passangers[1]);
	text_townbox.AddParam(this.limit_mails[0]);
	text_townbox.AddParam(this.limit_mails[1]);
	foreach (index, category in this.town_cargo_cat) {
		local cargo_mask = 0;
		foreach (cargo in category) {
			cargo_mask += 1 << cargo;
		}
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
		text_townsign = GSText(GSText.STR_TOWNSIGN_GROWTHRATE, GSTown.GetGrowthRate(this.id));
	}
	return text_townsign;
}

/* Helper function: get a list of currently used cargo labels/ID. */
function DebugCargoLabels()
{
	local list = GSCargoList();
	for(local i = 0; i < 64; ++i) {
		Log.Info("Cargo " + i + ": " + GSCargo.GetCargoLabel(i), Log.LVL_SUB_DECISIONS);
	}
}

/* Debug function: print supplied cargo. */
function GoalTown::DebugCargoSupplied(i, supplied)
{
	Log.Info(GSTown.GetName(this.id)+": supplied "+GSCargo.GetCargoLabel(i)+"="
		 +supplied, Log.LVL_DEBUG);
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
		cargo_text += "  " + index + ": ";
		foreach (cargo in cat) {
			cargo_text += GSCargo.GetCargoLabel(cargo) + ",";
		}
	}
	Log.Info(GSTown.GetName(this.id) + ": " + cargo_text, Log.LVL_SUB_DECISIONS);
}