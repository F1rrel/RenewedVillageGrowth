
function GoalTown::TownBoxText(growth_enabled, text_mode)
{
	// If the function is called with false, town is not growing. Give a help message.
	if (!growth_enabled || 0 == text_mode) {
		return GSText(GSText.STR_TOWNBOX_NOGROWTH, 1 << ::CargoCat[0][0]);
	}

	local text_townbox = null;
	switch (text_mode) {
		case 1: // automatic
			if (this.town_text_scroll > 0) {
				text_townbox = this.TownTextLimiting();
				this.town_text_scroll = 0;
			} else {
				text_townbox = this.TownTextCategories();
				++this.town_text_scroll;
			}
			break;
		case 2: // categories
			text_townbox = this.TownTextCategories();
			break;
		case 3: // limiting
			text_townbox = this.TownTextLimiting();
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
	
	// Building substrings. Labels depend on categories number.
	// Adding numeric parameters and building the final string
	local text_townbox = null;
	switch (::SettingsTable.randomization) {
		case 2: // 1 per category
			text_townbox = GSText(GSText["STR_RANDOM_"+max_cat]);
			for (local i = 0; i <= max_cat; i++) {
				if (i != 0)
					text_townbox.AddParam(1 << this.town_cargo_cat[i][0]);
				text_townbox.AddParam(this.town_goals_cat[i]);
				text_townbox.AddParam(this.town_supplied_cat[i]);
				text_townbox.AddParam(this.town_stockpiled_cat[i]);
			}
			break;
		default:
			text_townbox = GSText(GSText["STR_TOWNBOX_"+max_cat]);
			for (local i = 0; i <= max_cat; i++) {
				local text_townbox_cargocat = GSText(GSText["STR_TOWNBOX_CAT_"+::CargoCatList[i]]);
				text_townbox_cargocat.AddParam(this.town_goals_cat[i]);
				text_townbox_cargocat.AddParam(this.town_supplied_cat[i]);
				text_townbox_cargocat.AddParam(this.town_stockpiled_cat[i]);
				text_townbox.AddParam(text_townbox_cargocat);
			}
	}
	
	return text_townbox;
}

function GoalTown::TownTextLimiting()
{
	// Adding town limiting text
	local text_townbox = null;
	switch (this.text_number){
		case 0:
			text_townbox = GSText(GSText.STR_TOWNS_NOT_LIMITED);
			break;
		case 1:
			text_townbox = GSText(GSText.STR_LIMIT_1);
			text_townbox.AddParam(this.text1);
			break;
		case 2:
			text_townbox = GSText(GSText.STR_LIMIT_2);
			text_townbox.AddParam(this.text1);
			text_townbox.AddParam(this.text2);
			break;
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
	for(local i = 0; i < 32; ++i) {
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
	for (local i = 0; i < 32; i++)
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
	Log.Info(GSTown.GetName(this.id) + ": " + cargo_text, Log.LVL_DEBUG);
}