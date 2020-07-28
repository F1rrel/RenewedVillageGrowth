/*
 * For each town in the game, an instance of this class is created.
 * It holds the data related to a specific town.
 */
class GoalTown
{
	id = null;                  // Town id
	sign_id = null;             // Id for extra text under town name
	is_monitored = null;        // Whether the town is already under monitoring. True if town exchanges pax.
	last_pax_delivery = null;   // Date of last pax delivery from or to the town
	town_supplied = null;       // Last monthly supply per cargo type
	town_cargo_cat = null;
	town_goals_cat = null;      // Town goals per cargo category
	town_supplied_cat = null;   // Last monthly supply per cargo category (for categories: see InitCargoLists())
	town_stockpiled_cat = null; // Stockpiled cargos per cargo category
	tgr_array = null;           // Town growth rate array
	tgr_array_len = null;       // Town growth rate array lenght
	tgr_average = null;         // Town growth rate average, calculated from the array
	// Limit towns
	limit_growth = null;		// global limit growth flag
	text1 = null;
	text2 = null;
	text_number = null;
	allowGrowth = null;			// limits growth requirement fulfilled
	town_text_scroll = null;	// scroll town text when more than 3 categories are to be displayed
	cargo_hash = null;

	constructor(town_id, load_town_data, limit_growth) {
		this.id = town_id;
		this.tgr_array_len = 8;
		this.tgr_average = null;
		this.limit_growth = limit_growth;
		this.text_number = 0;
		this.allowGrowth = true;
		this.text1 = GSText(GSText.STR_TOWNS_NOT_LIMITED);
		this.town_text_scroll = 0;

		/* If there isn't saved data for the towns, we
		 * initialize them. Otherwise, we load saved data.
		 */
		if (!load_town_data) {
			this.sign_id = -1;
			this.is_monitored = false;
			this.last_pax_delivery = null;
			this.town_supplied = array(::CargoTypeNum, 0);
			this.town_goals_cat = array(::CargoCatNum, 0);
			this.town_supplied_cat = array(::CargoCatNum, 0);
			this.town_stockpiled_cat = array(::CargoCatNum, 0);
			this.tgr_array = array(tgr_array_len, 0);
			this.Randomization();
			this.DisableOrigCargoGoal();
			GSTown.SetGrowthRate(this.id, GSTown.TOWN_GROWTH_NONE);
			GSTown.SetText(this.id, TownBoxText(false, 0));
		} else {
			this.sign_id = ::TownDataTable[this.id].sign_id;
			this.is_monitored = ::TownDataTable[this.id].is_monitored;
			this.last_pax_delivery = ::TownDataTable[this.id].last_pax_delivery;
			this.town_supplied = ::TownDataTable[this.id].town_supplied;
			this.town_goals_cat = ::TownDataTable[this.id].town_goals_cat;
			this.town_supplied_cat = ::TownDataTable[this.id].town_supplied_cat;
			this.town_stockpiled_cat = ::TownDataTable[this.id].town_stockpiled_cat;
			this.tgr_array = ::TownDataTable[this.id].tgr_array;
			this.town_cargo_cat = GetCargoTable(::TownDataTable[this.id].cargo_hash);
			this.DebugCargoTable(this.town_cargo_cat);
			
			this.UpdateTownText(GSController.GetSetting("town_info_mode"));
		}
	}
}

/* Arctic and Tropical climate have specific cargo requirements for
 * town growth. This function is called to disable them.
 */
function GoalTown::DisableOrigCargoGoal()
{
	switch (GSGameSettings.GetValue("game_creation.landscape")) {
		case (0): // Temperate
			break;
		case (1): // Arctic
			GSTown.SetCargoGoal(this.id, GSCargo.TE_FOOD, 0);
			break;
		case (2): // Tropical
			if (GSTown.GetCargoGoal(this.id, GSCargo.TE_WATER) != 0) {
 				GSTown.SetCargoGoal(this.id, GSCargo.TE_WATER, 0);
				GSTown.SetCargoGoal(this.id, GSCargo.TE_FOOD, 0);
			}
			break;
		case (3): // Toyland
			break;
		default:
			return;
	}
}

/* Function called when saving the game. */
function GoalTown::SavingTownData()
{
	/* IMPORTANT: if anything of the saved data changes here, we
	 * need to update the MainClass.save_version flag in MainClass'
	 * constructor.
	 */
	local town_data = {};
	town_data.sign_id <- this.sign_id;
	town_data.is_monitored <- this.is_monitored;
	town_data.last_pax_delivery <- this.last_pax_delivery;
	town_data.town_supplied <- this.town_supplied;
	town_data.town_goals_cat <- this.town_goals_cat;
	town_data.town_supplied_cat <- this.town_supplied_cat;
	town_data.town_stockpiled_cat <- this.town_stockpiled_cat;
	town_data.tgr_array <- this.tgr_array;
	town_data.cargo_hash <- this.cargo_hash;
	return town_data;
}

/* Main town management function. Called each month. */
function GoalTown::MonthlyManageTown()
{
	local sum_goals = 0;
	local goal_diff = 0;
	local goal_diff_percent = 0.0;
	local cur_pop = GSTown.GetPopulation(this.id);
	local parsed_cat = 0;	// index of parsed category
	local new_town_growth_rate = null;
	// Defining difficulty and calculation factors
	local d_factor = GSController.GetSetting("goal_scale_factor") / 100.0;
	local g_factor = GSController.GetSetting("town_growth_factor") / 100.0;
	local e_factor = GSController.GetSetting("exponentiality_factor");
	local sup_imp_part = GSController.GetSetting("supply_impacting_part") / 100.0;
	local lowest_tgr = GSController.GetSetting("lowest_town_growth_rate");
	// Clearing the arrays
	this.town_supplied = array(::CargoTypeNum, 0);
	this.town_supplied_cat = array(::CargoCatNum, 0);
	this.town_goals_cat = array(::CargoCatNum, 0);
	
	// Allow small towns to grow
	if (GSTown.GetPopulation(this.id) < 100) {
		GSTown.SetGrowthRate(this.id, GSTown.TOWN_GROWTH_NORMAL);
		return;
	}

	// Check whether specific cargo goals have been enabled for tropical towns growing over 60
	if (GSGameSettings.GetValue("game_creation.landscape") == 2
	    && GSTown.GetCargoGoal(this.id, GSCargo.TE_WATER) != 0) {
		GSTown.SetCargoGoal(this.id, GSCargo.TE_WATER, 0);
		GSTown.SetCargoGoal(this.id, GSCargo.TE_FOOD, 0);
	}

	// Checking whether we should enable monitoring and perform calculations
	if (!this.is_monitored && !this.CheckMonitoring(false)) return;

	// Checking cargo delivery
	for (local i = 0; i < ::CargoTypeNum; i++) {
		for (local cid = GSCompany.COMPANY_FIRST; cid <= GSCompany.COMPANY_LAST; cid++) {
			if (GSCompany.ResolveCompanyID(cid) != GSCompany.COMPANY_INVALID) {
				town_supplied[i] += GSCargoMonitor.GetTownDeliveryAmount
					(cid, ::CargoList[i], this.id, true);
				if (town_supplied[i] > 0) this.DebugCargoSupplied(i); // Debug info: cargo supplied
			}
		}

		// On first iteration, if there isn't pax supply, check whether we stop monitoring
		if (i == 0) {
			if (town_supplied[i] == 0 && !this.CheckMonitoring(true)) {
				return;
			}
		}

		// Summing up cargo supply per each cargo categories.
		if (this.town_supplied[i] > 0) {
			local is_found = false;
			while (parsed_cat < ::CargoCatNum) {  // On parse les groupes un par un.
				for (local k = 0; k < ::CargoCat[parsed_cat].len(); k++) {
					if (::CargoList[i] == ::CargoCat[parsed_cat][k]) {
						this.town_supplied_cat[parsed_cat] += this.town_supplied[i];
						is_found = true;
						if ((k+1) == ::CargoCat[parsed_cat].len()) {
							parsed_cat++;
						}

						break;
					}
				}

				if (is_found == true) {
					break;
				}

				parsed_cat++;
			}
		}
	}

	// Calculating goals
	for (local i = 0; i < CargoCatNum && cur_pop > ::CargoMinPopDemand[i]; i++) {
		this.town_goals_cat[i] = max((((cur_pop  - ::CargoMinPopDemand[i]).tofloat() / 1000)
					    * ::CargoPermille[i]
					    * d_factor).tointeger(),1);
	}

	// If town's population is too low to calculate a goal, it is set to 1
	if (this.town_goals_cat[0] < 1) this.town_goals_cat[0] = 1;

	// Calculating global goal and achievement
	for (local i = 0; i < CargoCatNum; i++) {
		// Supplied stuff are summed with stockpiled stuff. sum_goals is incremented for each category.
		if (this.town_goals_cat[i] > 0) {
			sum_goals += this.town_goals_cat[i];
			this.town_stockpiled_cat[i] += this.town_supplied_cat[i];
		}

		// Stockpiles are updated. goal_diff measures how many stuff is missing for goal achievement.
		if (this.town_stockpiled_cat[i] < this.town_goals_cat[i]) {
			goal_diff += (this.town_goals_cat[i] - this.town_stockpiled_cat[i]);
			this.town_stockpiled_cat[i] = 0;
		} else {
			// If stockpiled is bigger than required, we cut off the required part
			this.town_stockpiled_cat[i] = ((this.town_stockpiled_cat[i]- this.town_goals_cat[i])
						     * (1 - ::CargoDecay[i])).tointeger();
			// Don't stockpile more than: (cargo category) * 10;
			if (this.town_stockpiled_cat[i] > 300 &&
			    this.town_stockpiled_cat[i] > this.town_goals_cat[i] * 10) {
				this.town_stockpiled_cat[i] = this.town_goals_cat[i] * 10;
			}
		}
		this.DebugCargoCatInfo(i) // Debug info: print stockpiled/supplied/goal per category
	}

	/* Here we calculate the number of days until the next
	 * growth. The important stuff happens here. Other possible
	 * formulas for calculating the new town growth rate are:
	 * new_town_growth_rate = (max_town_growth_rate * (1+(10/(1-goal_diff_percent)-10))).tointeger();
	 * new_town_growth_rate = (max_town_growth_rate/(1-goal_diff_percent*2)).tointeger();
	 */
	goal_diff_percent = (goal_diff.tofloat() / sum_goals.tofloat()); // Convert the difference to a percent
	this.DebugGoalsResult(sum_goals, goal_diff, goal_diff_percent);  // Debug info about general goal results
	if (goal_diff_percent <= sup_imp_part) {
		local max_town_growth_rate = g_factor * 50000 / (100 + cur_pop.tofloat());
		new_town_growth_rate = (max_town_growth_rate
					* (1 + (e_factor / (1 - goal_diff_percent * 2) - e_factor))).tointeger();
	} else if (goal_diff_percent > sup_imp_part || new_town_growth_rate > lowest_tgr) {
		new_town_growth_rate = lowest_tgr;
	}

	// Defining the new town growth rate, calculated as the moving average of the TGR array, update only if town growth requirements are fulfilled
	local sum_array = 0;
	local i = 0;
	while (this.tgr_array[i] > 0) {
		sum_array += this.tgr_array[i];
		i++;
	}
	this.tgr_array[i] = new_town_growth_rate;
	sum_array += this.tgr_array[i];
	this.tgr_average = (sum_array/(i+1)).tointeger();
	
	// Shift the array by one element when full
	this.DebugTgrArray() // Debug info: print the array's content
	if (this.tgr_array[this.tgr_array_len-1] > 0) {
		this.tgr_array = this.tgr_array.slice(1); // efface element [0] de l'array
		this.tgr_array.push(0);                   // ajoute 0 en dernier element
	}
		
	if (this.allowGrowth) {
		GSTown.SetGrowthRate(this.id, this.tgr_average);
	} else {
		GSTown.SetGrowthRate(this.id, GSTown.TOWN_GROWTH_NONE);
	}
	
	this.UpdateSignText();
}

function GoalTown::ManageTownLimiting() {
	if (!this.limit_growth) {
		return;
	}
	
	// if the size of the town is below the threshold, set the growth rate to normal
	local threashold_setting = GSController.GetSetting("town_size_threshold");
	local townPopulation = GSTown.GetPopulation(this.id);
	if (townPopulation <= threashold_setting) {
		this.allowGrowth = true;
		this.text_number = 0;
		this.text1 = GSText(GSText.STR_TOO_SMALL);
		return;
	}
	
	local paxRequired = GSController.GetSetting("min_transport_pax");
	local mailRequired = GSController.GetSetting("min_transport_mail");
	if (paxRequired && mailRequired) {
		local paxTransport = GSTown.GetLastMonthTransportedPercentage (this.id, Helper.GetPAXCargo());
		local mailTransport = GSTown.GetLastMonthTransportedPercentage (this.id, Helper.GetMailCargo());
		if (paxTransport < 0) paxTransport = 0;
		if (mailTransport < 0) mailTransport = 0;
		local PaxTooLow = paxTransport < paxRequired;
		local MailTooLow = mailTransport < mailRequired;

		if (PaxTooLow || MailTooLow) {
			this.allowGrowth = false;
		} else {
			this.allowGrowth = true;
		}
		
		this.text_number = 2;
		this.text1 = PaxTooLow ?
			GSText(GSText.STR_PAX_BAD, paxTransport, paxRequired) :
			GSText(GSText.STR_PAX_GOOD, paxTransport, paxRequired);
		this.text2 = MailTooLow ?
			GSText(GSText.STR_MAIL_BAD, mailTransport, mailRequired) :
			GSText(GSText.STR_MAIL_GOOD, mailTransport, mailRequired);
	}

	else if (paxRequired) {
		local paxTransport = GSTown.GetLastMonthTransportedPercentage (this.id, Helper.GetPAXCargo());
		if (paxTransport < 0) paxTransport = 0;
		local PaxTooLow = paxTransport < paxRequired;
		if (PaxTooLow) {
			this.text1 = GSText(GSText.STR_PAX_BAD, paxTransport, paxRequired);
			this.allowGrowth = false;
		} else {
			this.text1 = GSText(GSText.STR_PAX_GOOD, paxTransport, paxRequired);
			this.allowGrowth = true;
		}
		this.text_number = 1;
	}

	else if (mailRequired) {
		local mailTransport = GSTown.GetLastMonthTransportedPercentage (this.id, Helper.GetMailCargo());
		if (mailTransport < 0) mailTransport = 0;
		local MailTooLow = mailTransport < mailRequired;
		if (MailTooLow) {
			this.text1 = GSText(GSText.STR_MAIL_BAD, mailTransport, mailRequired);
			this.allowGrowth = false;
		} else {
			this.text1 = GSText(GSText.STR_MAIL_GOOD, mailTransport, mailRequired);
			this.allowGrowth = true;
		}
		this.text_number = 1;
	}
	
	else {
		this.text1 = GSText(GSText.STR_TOWNS_NOT_LIMITED);
		this.text_number = 0;
	}
}

/* Function called either for unmonitored towns, either for monitored
 * towns which are not supplied with pax. Returns true if the town
 * must be monitored, false otherwise.
 */
function GoalTown::CheckMonitoring(monitored)
{
	/* To enable monitoring it is better to check the delivery
	 * from the town and not to the town. This is necessary for
	 * very little towns, which don't always receive passengers
	 * due to cargodist algorithm. Note: using GSCargoMonitor
	 * results in lighter load as using
	 * GSTown.GetLastMonth[Supply/TransportedPercentage].
	 */
	local pax_check = 0;
	for (local cid = GSCompany.COMPANY_FIRST; cid <= GSCompany.COMPANY_LAST; cid++) {
		if (GSCompany.ResolveCompanyID(cid) != GSCompany.COMPANY_INVALID) {
			pax_check += GSCargoMonitor.GetTownPickupAmount(cid, ::CargoList[0], this.id, true);
			if (pax_check > 0) break;
		}
	}

	if (!monitored) {
		/* For unmonitored towns: check whether they delivered
		 * pax. If they did, monitoring is enabled.
		 */
		if (pax_check == 0) {
			return false;
		} else {
			this.is_monitored = true;
			this.last_pax_delivery = GSDate.GetCurrentDate();
			Log.Info("City of "+GSTown.GetName(this.id)+" now monitored", Log.LVL_DEBUG);
			return true;
		}
	} else {
		/* For monitored towns: if there isn't passengers
		 * delivery from the town since more than 1 year, we
		 * stop the monitoring. This is necessary for very
		 * little towns, which otherwise could never grow.
		 */
		if (pax_check > 0) {
			this.last_pax_delivery = GSDate.GetCurrentDate();
			return true;
		}

		if ((GSDate.GetCurrentDate()-this.last_pax_delivery) < 365) {
			return true;
		} else {
			GSTown.SetGrowthRate(this.id, GSTown.TOWN_GROWTH_NONE);
			this.is_monitored = false;
			this.town_supplied = array(::CargoTypeNum, 0);
			this.town_stockpiled_cat = array(::CargoCatNum, 0);
			this.tgr_array = array(tgr_array_len, 0);
			this.tgr_average = null;
			this.StopMonitors();
			this.RemoveSignText();
			Log.Info("City of "+GSTown.GetName(this.id)+" is not monitored anymore", Log.LVL_DEBUG);
			return false;
		}
	}
}

function GoalTown::StopMonitors()
{
	for (local i = 0; i< ::CargoTypeNum; i++) {
		for (local cid = GSCompany.COMPANY_FIRST; cid <= GSCompany.COMPANY_LAST; cid++) {
			if (GSCompany.ResolveCompanyID(cid) != GSCompany.COMPANY_INVALID) {
				GSCargoMonitor.GetTownDeliveryAmount(cid, ::CargoList[i],this.id,false);
			}
		}
	}
}

function GoalTown::EternalLove(rating)
{
	for (local c = GSCompany.COMPANY_FIRST; c <= GSCompany.COMPANY_LAST; c++) {
		if (!GSTown.IsValidTown(this.id)) 
			break;
		if (GSCompany.ResolveCompanyID(c) != c) 
			continue;
		local cur_rating_class = GSTown.GetRating(this.id, c);
		if (cur_rating_class == GSTown.TOWN_RATING_NONE 
			|| cur_rating_class == GSTown.TOWN_RATING_INVALID
			|| cur_rating_class == GSTown.TOWN_RATING_OUTSTANDING)
			continue;
		local cur_rating = GSTown.GetDetailedRating(this.id, c);
		Log.Info("Current/required rating of towns: " + cur_rating + " / " + rating, Log.LVL_DEBUG);
		if (cur_rating < rating)
			GSTown.ChangeRating(this.id, c, rating - cur_rating);
	}
}

function GoalTown::UpdateSignText()
{
	// Add a sign by the town to display the current growth
	if (GSController.GetSetting("use_town_sign")) {
		local sign_text = TownSignText();
		if (GSSign.IsValidSign(this.sign_id)) {
			GSSign.SetName(this.sign_id, sign_text);
		} else {
			this.sign_id = GSSign.BuildSign(GSTown.GetLocation(this.id), sign_text);
		}
	}
}

function GoalTown::RemoveSignText()
{
	// Cleaning signs on the map
	if (GSController.GetSetting("use_town_sign") && GSSign.IsValidSign(this.sign_id)) {
		GSSign.RemoveSign(this.sign_id);
		this.sign_id = -1;
	}
	
	GSTown.SetText(this.id, this.TownBoxText(false, 0));
}


function GoalTown::UpdateTownText(info_mode)
{
	if (this.is_monitored) {
		GSTown.SetText(this.id, this.TownBoxText(true, info_mode));
	}
}

function GoalTown::Randomization()
{
	switch (::SettingsTable.randomization) {
		case 1: // None
			this.town_cargo_cat = ::CargoCat;
			break;
		case 2: // 1 per category
			this.town_cargo_cat = Randomize1();
			this.DebugCargoTable(this.town_cargo_cat);
			break;
		default:
			this.town_cargo_cat = ::CargoCat;
	}

	this.cargo_hash = GetCargoHash(this.town_cargo_cat);
	this.DebugCargoHash(this.cargo_hash);
}