enum CatLabels
{
	PAXMAIL = 0,
	G_FOOD = 1,
	G_GOODS = 2,
	RAW_IND = 3,
	TR_IND = 4,
	G_IND = 5
}

/* Cargolist of supported industry set's cargos. Used to check if
 * initial ingame cargo list matches the defined setting. Needs to be
 * updated if industry set cargos change.
 */
function FillCargoIDList(cargo_list) {
	switch (GSController.GetSetting("industry_NewGRF")) {
	/* Baseset */
	case(1): // Temperate
		::CargoIDList <- ["PASS","COAL","MAIL","OIL_","LVST","GOOD",
				  "GRAI","WOOD","IORE","STEL","VALU"];
		break;
	case(2): // Arctic
		::CargoIDList <- ["PASS","COAL","MAIL","OIL_","LVST","GOOD",
				  "WHEA","WOOD",null,"PAPR","GOLD","FOOD"];
		break;
	case(3): // Tropical
		::CargoIDList <- ["PASS","RUBR","MAIL","OIL_","FRUT","GOOD",
				  "MAIZ","WOOD","CORE","WATR","DIAM","FOOD"];
		break;
	case(4): // Toyland
		::CargoIDList <- ["PASS","SUGR","MAIL","TOYS","BATT","SWET",
				  "TOFF","COLA","CTCD","BUBL","PLST","FZDR"];
		break;
	/* FIRS version 1.3.0 */
	case(5): // Firs economy
		::CargoIDList <- ["PASS","COAL","MAIL","OIL_","LVST","GOOD","GRAI","WOOD","IORE","STEL",
				  "MILK","FOOD","SGBT","FRUT","FISH","WOOL","CLAY","SAND","MNSP","WDPR",
				  "SCMT","FMSP","FICR","RFPR","ENSP","PETR","GRVL","AORE","BDMT","BEER",
				  null,"RCYC"];
		break;
	case(6): // Temperate basic
		::CargoIDList <- ["PASS","COAL","MAIL",null,"LVST","GOOD",null,null,"IORE","STEL",
				  "MILK","FOOD",null,"FRUT",null,null,"CLAY","SAND","MNSP",null,
				  "SCMT","FMSP",null,"RFPR","ENSP",null,null,null,null,"BEER"];
		break;
	case(7): // Arctic basic
		::CargoIDList <- ["PASS",null,"MAIL","OIL_","LVST","GOOD","GRAI","WOOD",null,null,
				  null,"FOOD",null,null,"FISH",null,"CLAY",null,"MNSP",null,
				  null,"FMSP",null,"RFPR","ENSP","PETR",null,null,null,"BEER"];
		break;
	case(8): // Tropic basic
		::CargoIDList <- ["PASS",null,"MAIL","OIL_","LVST","GOOD",null,null,null,"STEL",
				  null,"FOOD","SGCN","FRUT","FISH","WOOL",null,null,"MNSP",null,
				  null,"FMSP",null,"RFPR","ENSP","PETR",null,"AORE"];
		break;
	case(9): // Hearth of Darkness
		::CargoIDList <- ["PASS","DIAM","MAIL","OIL_",null,"GOOD","GRAI","WOOD","CORE",null,
				  null,"FOOD","SGCN","FRUT","FISH","JAVA",null,null,"MNSP",null,
				  "SUGR","FMSP","FICR",null,"ENSP",null,null,"RUBR","BDMT","BEER"];
		break;
	/* ECS - Included vectors:
	 * ECS Town vector 1.2
	 * ECS Houses 1.2
	 * ECS Basic vector II 1.2
	 * ECS Chemicals vector II 1.2
	 * ECS Machinery Vector 1.2
	 * ECS Wood vector 1.2
	 * ECS Agricultural vector 1.2
	 */
	case(10):
		::CargoIDList <- this.ConstructECSVectorCargoList(cargo_list);
		// ::CargoIDList <- ["PASS","COAL","MAIL","OIL_","LVST","GOOD","CERE","WOOD","IORE","STEL",
				  // "GOLD","FOOD","PAPR","FRUT","FISH","WOOL",null,"SAND","GLAS","WDPR",
				  // "DYES","FERT","OLSD","RFPR","VEHI","PETR","AORE","WATR","CMNT","FICR",
				  // "LIME","TOUR"];
		break;
	/* YETI 0.1.6 */
	case(11):
		::CargoIDList <- ["PASS","GRVL","MAIL","WOOD","BDMT",null,"GRAI","FRUT","FOOD",null,
				  "OIL_",null,"STEL","PETR","BATT","VEHI","YETI","CLAY","LVST","URAN",
				  "IORE"];
		break;
	/* FIRS version 3.0.12 */
	case(12): // Temperate Basic
		::CargoIDList <- ["PASS","BEER","MAIL","RFPR","CLAY","GOOD","COAL","ENSP","FMSP","FISH",
				  "FRUT","FOOD","IORE","LVST","MILK","SAND","SCMT","STEL"];
		break;
	case(13): // Arctic Basic
		::CargoIDList <- ["PASS","KAOL","MAIL","ENSP","FMSP","GOOD","PAPR","PORE","BEER","WDPR",
				  "PHOS","FOOD","BOOM","ZINC","FISH","SULP","FERT","WOOD","PEAT"];
		break;
	case(14): // Tropic Basic
		::CargoIDList <- ["PASS","BEER","MAIL","BEAN","RFPR","GOOD","JAVA","COPR","CORE","ENSP",
				  "FMSP","FOOD","FISH","FRUT","GRAI","LVST","NITR","OIL_","WOOL"];
		break;
	case(15): // Steeltown
		::CargoIDList <- ["PASS","CMNT","MAIL","QLME","ENSP","VEHI","FMSP","STEL","SLAG","LIME",
				  "SAND","FOOD","MNO2","COAL","IORE","IRON","COKE","PETR","SULP","SCMT",
				  "SASH","ZINC","COPR","RUBR","PIPE","SALT","ACID","CHLO","POWR","VPTS","VBOD"];
		break;
	case(16): // In A Hot Country
		::CargoIDList <- ["PASS","BEER","MAIL","BDMT","CASS","GOOD","RFPR","CLAY","JAVA","COPR",
				  "CORE","FOOD","DIAM","EOIL","ENSP","FMSP","FRUT","LVST","WDPR","MAIZ",
				  "MNO2","NUTS","OIL_","PETR","PHOS","RUBR","SAND","GRVL","WOOD"];
		break;
	case(17): // Extreme
		::CargoIDList <- ["PASS","BEER","MAIL","AORE","BDMT","GOOD","RFPR","CLAY","COAL","ENSP",
				  "FMSP","FOOD","FISH","FRUT","GRAI","IORE","LVST","WDPR","MNSP","METL",
				  "MILK","OIL_","PETR","FICR","RCYC","SAND","SCMT","GRVL","SGBT","WOOD","WOOL"];
		break;
	/* NAIS version 1.0.6 */
	case(18): // North America
		::CargoIDList <- ["PASS","AORE","MAIL","BDMT","RFPR","GOOD","CLAY","COAL","CORE","FMSP",
				  "FICR","FOOD","FISH","PETR","GLAS","GRAI","IORE","LVST","WDPR","ENSP","METL",
				  "MILK","PORE","OIL_","PAPR","FRUT","SAND","SCMT","GRVL","URAN","VALU","WOOD"];
		break;
	default: break;
	}

	// This is used to add all null IDs after the end of active used cargos
	local missing_cargo = 32 - ::CargoIDList.len();
	for (local i = 0; i < missing_cargo; i++) {
		for (local i = 0; i < missing_cargo; i++) ::CargoIDList.append(null);
	}
}

/* Here are defined the cargo categories and other data for each
 * set. Follow explanations below to change category data.
 */
function DefineCargosBySettings()
{
	/* Setup global cargo variables, per cargo categories: (Cat 1:
	 * Passengers and mail, Cat 2: General food, Cat 3: General
	 * goods, Cat 4: Raw industrial materials, Cat 5: transformed
	 * indudstrial goods). For base sets, only 3 categories are
	 * defined (PaxMail, General goods (including food),
	 * industrial goods).
	 *
	 * For each industry set, we define:
	 * ::CargoCat: the base categories of cargo. For each
	 * category, an array of cargo types is created. For cargo Id
	 * references, enable debugging and watch at the AI/GameScript
	 * log.
	 * ::CargoCatList: a list of used cargo categories; see enum
	 * CargoCategories
	 * ::CargoMinPopDemand: minimal town population at which a
	 * cargo category is required
	 * ::CargoPermille: a factor defining the growth of cargo category
	 * requirements
	 * ::CargoDecay: defines the part of the stockpiled cargos
	 * which is lost each month
	 */
	local industry_setting = GSController.GetSetting("industry_NewGRF");
	switch (industry_setting) {
		case(1): // Base temperate
			::CargoCat <- [[0,2],
				       [5,10],
				       [1,3,4,6,7,8,9]];
			::CargoCatList <- [CatLabels.PAXMAIL,CatLabels.G_GOODS,CatLabels.G_IND];
			::CargoMinPopDemand <- [0,1000,4000];
			::CargoPermille <- [60,45,25];
			::CargoDecay <- [0.4,0.2,0.1];
			break;
		case(2): //Base arctic
			::CargoCat <- [[0,2],
				       [5,10,11],
				       [1,3,4,6,7,9]];
			::CargoCatList <- [CatLabels.PAXMAIL,CatLabels.G_GOODS,CatLabels.G_IND];
			::CargoMinPopDemand <- [0,1000,4000];
			::CargoPermille <- [60,45,25];
			::CargoDecay <- [0.4,0.2,0.1];
			break;
		case(3): //Base tropical
			::CargoCat <- [[0,2],
				       [5,9,10,11],
				       [1,3,4,6,7,8]];
			::CargoCatList <- [CatLabels.PAXMAIL,CatLabels.G_GOODS,CatLabels.G_IND];
			::CargoMinPopDemand <- [0,1000,4000];
			::CargoPermille <- [60,45,25];
			::CargoDecay <- [0.4,0.2,0.1];
			break;
		case(4): //Base toyland
			::CargoCat <- [[0,2],
				       [3,5,11],
				       [1,4,6,7,8,9,10]];
			::CargoCatList <- [CatLabels.PAXMAIL,CatLabels.G_GOODS,CatLabels.G_IND];
			::CargoMinPopDemand <- [0,1000,4000];
			::CargoPermille <- [60,45,25];
			::CargoDecay <- [0.4,0.2,0.1];
			break;
		case(5): // FIRS 1.3.0 - Firs Economy
			::CargoCat <- [[0,2],
				       [11,13,29],
				       [5,25,28],
				       [1,3,4,6,7,8,10,12,14,15,16,17,20,22,26,27],
				       [9,18,19,21,23,24,31]];
			::CargoCatList <- [CatLabels.PAXMAIL,CatLabels.G_FOOD,CatLabels.G_GOODS,
					   CatLabels.RAW_IND,CatLabels.TR_IND];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,20,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(6): // FIRS 1.3.0 - Temperate Basic
			::CargoCat <- [[0,2],
				       [11,29],
				       [5],
				       [1,4,8,10,13,16,17,20],
				       [9,18,21,23,24]];
			::CargoCatList <- [CatLabels.PAXMAIL,CatLabels.G_FOOD,CatLabels.G_GOODS,
					   CatLabels.RAW_IND,CatLabels.TR_IND];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,20,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(7): // FIRS 1.3.0 - Arctic Basic
			::CargoCat <- [[0,2],
				       [11,29],
				       [5,25],
				       [3,4,6,7,14],
				       [16,18,21,23,24]];
			::CargoCatList <- [CatLabels.PAXMAIL,CatLabels.G_FOOD,CatLabels.G_GOODS,
					   CatLabels.RAW_IND,CatLabels.TR_IND];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,20,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(8): // FIRS 1.3.0 - Tropic Basic
			::CargoCat <- [[0,2],
				       [11],
				       [5,25],
				       [3,4,12,13,14,15,27],
				       [9,18,21,23,24]];
			::CargoCatList <- [CatLabels.PAXMAIL,CatLabels.G_FOOD,CatLabels.G_GOODS,
					   CatLabels.RAW_IND,CatLabels.TR_IND];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,20,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(9): // FIRS 1.3.0 - Hearth of the Darkness
			::CargoCat <- [[0,2],
				       [11,29],
				       [5,28],
				       [1,3,7,8,12,13,14,15,22,27],
				       [6,18,20,21,24]];
			::CargoCatList <- [CatLabels.PAXMAIL,CatLabels.G_FOOD,CatLabels.G_GOODS,
					   CatLabels.RAW_IND,CatLabels.TR_IND];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,20,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(10): //ECS 1.2
			::CargoCat <- [[0,2,31],
				       [11,27],
				       [5,10,25],
				       [1,3,4,6,7,8,13,14,15,17,25,29,30],
				       [9,12,18,19,20,21,22,23,24,27]];
			::CargoCatList <- [CatLabels.PAXMAIL,CatLabels.G_FOOD,CatLabels.G_GOODS,
					   CatLabels.RAW_IND,CatLabels.TR_IND];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,20,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(11): //YETI 0.1.6
			::CargoCat <- [[0,2,16],
				       [8],
				       [4],
				       [1,3,6,7,10,17,18,19,20],
				       [12,13,14,15]];
			::CargoCatList <- [CatLabels.PAXMAIL,CatLabels.G_FOOD,CatLabels.G_GOODS,
					   CatLabels.RAW_IND,CatLabels.TR_IND];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,20,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(12): // FIRS 3.0.12 - Temperate Basic
			::CargoCat <- [[0,2],
				       [9,10,13,14],
				       [3,17,1],
				       [4,6,12,15,16],
				       [5,7,8,11]];
			::CargoCatList <- [CatLabels.PAXMAIL,CatLabels.G_FOOD,CatLabels.G_GOODS,
					   CatLabels.RAW_IND,CatLabels.TR_IND];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,20,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(13): // FIRS 3.0.12 - Arctic Basic
			::CargoCat <- [[0,2],
				       [8,11,14],
				       [1,6,9,13,15],
				       [7,10,17,18],
				       [3,4,5,12,16]];
			::CargoCatList <- [CatLabels.PAXMAIL,CatLabels.G_FOOD,CatLabels.G_GOODS,
					   CatLabels.RAW_IND,CatLabels.TR_IND];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,20,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(14): // FIRS 3.0.12 - Tropic Basic
			::CargoCat <- [[0,2],
				       [1,3,12,13,14,15,6],
				       [4,5,7],
				       [8,16,17,18],
				       [9,10,11]];
			::CargoCatList <- [CatLabels.PAXMAIL,CatLabels.G_FOOD,CatLabels.G_GOODS,
					   CatLabels.RAW_IND,CatLabels.TR_IND];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,20,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(15): // FIRS 3.0.12 - Steeltown
			::CargoCat <- [[0,2],
				       [11,16,20,21,23,25,27],
				       [1,3,7,8,15,18,26],
				       [9,10,12,13,14,17,19,22],
				       [4,5,6,24,28,29,30]];
			::CargoCatList <- [CatLabels.PAXMAIL,CatLabels.G_FOOD,CatLabels.G_GOODS,
					   CatLabels.RAW_IND,CatLabels.TR_IND];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,20,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(16): // FIRS 3.0.12 -In A Hot Coutry
			::CargoCat <- [[0,2],
				       [4,8,13,16,17,19,21,25],
				       [1,6,9,18,23],
				       [7,10,12,20,22,24,26,27,28],
				       [3,5,11,14,15]];
			::CargoCatList <- [CatLabels.PAXMAIL,CatLabels.G_FOOD,CatLabels.G_GOODS,
					   CatLabels.RAW_IND,CatLabels.TR_IND];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,20,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(17): // FIRS 3.0.12 - Extreme
			::CargoCat <- [[0,2],
				       [12,13,14,16,20,23,28],
				       [1,6,17,19,22,26],
				       [3,7,8,15,21,24,25,27,29,30],
				       [4,5,9,10,11,18]];
			::CargoCatList <- [CatLabels.PAXMAIL,CatLabels.G_FOOD,CatLabels.G_GOODS,
					   CatLabels.RAW_IND,CatLabels.TR_IND];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,20,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(18): // NAIS 1.0.6 - North America
			::CargoCat <- [[0,2],
				       [10,12,15,17,21,25],
				       [4,13,14,18,20,24],
				       [1,6,7,8,16,22,23,26,27,28,29,30,31],
				       [3,5,9,11,19]];
			::CargoCatList <- [CatLabels.PAXMAIL,CatLabels.G_FOOD,CatLabels.G_GOODS,
					   CatLabels.RAW_IND,CatLabels.TR_IND];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,20,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		default:
			break;
	}

	ConfigureCategories();
}

/* Merge categories if required by settings. */
function ConfigureCategories()
{
	local merge_2_3 = GSController.GetSetting("merge_cat_2_3");
	local merge_4_5 = GSController.GetSetting("merge_cat_4_5");
	local first_idx = null;

	if (merge_2_3) {
		first_idx = 1;
		::CargoCat[first_idx].extend(::CargoCat[first_idx+1]);
		::CargoCat[first_idx].sort();
		::CargoCat.remove(first_idx+1);
		::CargoCatList.remove(first_idx);
		::CargoPermille[first_idx] += ::CargoPermille[first_idx+1];
		::CargoPermille.remove(first_idx+1);
		::CargoMinPopDemand.remove(first_idx+1);
		::CargoDecay.remove(first_idx+1);
	}
	if (merge_4_5) {
		merge_2_3 ? first_idx = 2 : first_idx = 3;
		::CargoCat[first_idx].extend(::CargoCat[first_idx+1]);
		::CargoCat[first_idx].sort();
		::CargoCat.remove(first_idx+1);
		::CargoCatList.remove(first_idx);
		::CargoCatList[first_idx] = CatLabels.G_IND;
		::CargoPermille[first_idx] += ::CargoPermille[first_idx+1];
		::CargoPermille.remove(first_idx+1);
		::CargoMinPopDemand.remove(first_idx+1);
		::CargoDecay.remove(first_idx+1);
	}
}

/* This function compares the ingame initial cargo list to the
 * industry sets and cargoscheme supported by the script. Return false
 * if they don't match.
 */
function CheckInitialCargoList() {
	local cargo_list = [];
	for(local i = 0; i < 32; ++i) {
		cargo_list.append(GSCargo.GetCargoLabel(i));
	}
	FillCargoIDList(cargo_list);

	// Comparing actual list to original list
	for (local i = 0; i < 32; i++) {
		if (cargo_list[i] != ::CargoIDList[i]) {
			::CargoIDList = false;
			Log.Info("Warning: game's cargo list differ from settings.", Log.LVL_INFO);
			return;
		}
	}
}

function ConstructECSVectorCargoList(cargo_list) {
	local return_list = [];
	for (local i = 0; i < 32; ++i) {
		return_list.append(null);
	}
	
	// ECS Town
	local town = true;
	local town_list = ["PASS","MAIL","GOOD","GOLD","WATR","TOUR"];
	local town_idx = [0,2,5,10,27,31];
	foreach (index, id in town_idx) {
		if (cargo_list[id] != town_list[index]) {
			town = false;
			break;
		}
	}
	if (town) {
		Log.Info("ECS Town Vector 1.2 present.", Log.LVL_DEBUG);
		foreach (index, id in town_idx) {
			return_list[id] = town_list[index];
		}
	} else { // Add landscape specific cargos if town vector is not present
		local default_list = [];
		switch (GSGame.GetLandscape()) {
			case GSGame.LT_TEMPERATE:
				default_list = ["PASS","COAL","MAIL","OIL_","LVST","GOOD",
				  "GRAI","WOOD","IORE","STEL","VALU",null];
				break;
			case GSGame.LT_ARCTIC:
				default_list = ["PASS","COAL","MAIL","OIL_","LVST","GOOD",
				  "WHEA","WOOD",null,"PAPR","GOLD","FOOD"];
				break;
			case GSGame.LT_TROPIC:
				default_list = ["PASS","RUBR","MAIL","OIL_","FRUT","GOOD",
				  "MAIZ","WOOD","CORE","WATR","DIAM","FOOD"];
				break;
			case GSGame.LT_TOYLAND:
				default_list = ["PASS","SUGR","MAIL","TOYS","BATT","SWET",
				  "TOFF","COLA","CTCD","BUBL","PLST","FZDR"];
				break;
		}
		for (local i = 0; i < 12; ++i) {
			return_list[i] = default_list[i];
		}
	}
	
	// ECS Basic
	local basic = true;
	local basic_list = ["COAL","SAND","GLAS","BDMT"];
	local basic_idx = [1,17,18,28];
	foreach (index, id in basic_idx) {
		if (cargo_list[id] != basic_list[index]) {
			basic = false;
			break;
		}
	}
	if (basic) {
		Log.Info("ECS Basic Vector 1.2 present.", Log.LVL_DEBUG);
		foreach (index, id in basic_idx) {
			return_list[id] = basic_list[index];
		}
	}
	
	// ECS Chemical
	local chemical = true;
	local chemical_list = ["OIL_","DYES","RFPR","PETR"];
	local chemical_idx = [3,20,23,25];
	foreach (index, id in chemical_idx) {
		if (cargo_list[id] != chemical_list[index]) {
			chemical = false;
			break;
		}
	}
	if (chemical) {
		Log.Info("ECS Chemical Vector 1.2 present.", Log.LVL_DEBUG);
		foreach (index, id in chemical_idx) {
			return_list[id] = chemical_list[index];
		}
	}
	
	// ECS Machinery
	local machinery = true;
	local machinery_list = ["IORE","STEL","VEHI","AORE"];
	local machinery_idx = [8,9,24,26];
	foreach (index, id in machinery_idx) {
		if (cargo_list[id] != machinery_list[index]) {
			machinery = false;
			break;
		}
	}
	if (machinery) {
		Log.Info("ECS Machinery Vector 1.2 present.", Log.LVL_DEBUG);
		foreach (index, id in machinery_idx) {
			return_list[id] = machinery_list[index];
		}
	}
	
	// ECS Wood
	local wood = true;
	local wood_list = ["WOOD","PAPR","WDPR"];
	local wood_idx = [7,12,19];
	foreach (index, id in wood_idx) {
		if (cargo_list[id] != wood_list[index]) {
			wood = false;
			break;
		}
	}
	if (wood) {
		Log.Info("ECS Wood Vector 1.2 present.", Log.LVL_DEBUG);
		foreach (index, id in wood_idx) {
			return_list[id] = wood_list[index];
		}
	}
	
	// ECS Agricultural
	local agricultural = true;
	local agricultural_list = ["LVST","CERE","FOOD","FRUT","FISH","WOOL","FERT","OLSD","FICR"];
	local agricultural_idx = [4,6,11,13,14,15,21,22,29];
	foreach (index, id in agricultural_idx) {
		if (cargo_list[id] != agricultural_list[index]) {
			agricultural = false;
			break;
		}
	}
	if (agricultural) {
		Log.Info("ECS Agricultural Vector 1.2 present.", Log.LVL_DEBUG);
		foreach (index, id in agricultural_idx) {
			return_list[id] = agricultural_list[index];
		}
	}
	
	return return_list;
}

/* Initialization of cargo data. */
function InitCargoLists()
{
	DebugCargoLabels();       // Debug info: print cargo labels

	CheckInitialCargoList()   // Check if cargo list matches the settings

	DefineCargosBySettings(); // Define cargo data accordingly to industry set

	// Building a general list of all cargos, ordered by categories.
	::CargoList <- [];
	for (local i = 0; i < ::CargoCat.len(); i++) {
		for (local j = 0; j < ::CargoCat[i].len(); j++) {
			::CargoList.append(CargoCat[i][j]);
		}
	}

	// Initializing some useful and often used variables
	::CargoTypeNum <- ::CargoList.len();
	::CargoCatNum <- ::CargoCat.len();
}

/* Randomize cargo to one per category and return cargo table. */
function Randomize1()
{
	local cargo_cat = array(::CargoCat.len());
	foreach (index, cat in ::CargoCat)
	{
		if (index == 0) {
			cargo_cat[index] = cat;
		} else {
			cargo_cat[index] = [cat[GSBase.RandRange(cat.len())]];
		}
	}

	return cargo_cat;
}

/* Calculate cargo hash from cargo table */
function GetCargoHash(cargo_cat)
{
	local hash = 0;
	foreach (cat in cargo_cat)
	{
		foreach (cargo in cat)
		{
			hash += 1 << cargo;
		}
	}

	return hash;
}

/* Create cargo table from cargo hash */
function GetCargoTable(hash)
{
	local cargo_cat = array(::CargoCat.len());

	foreach (index, cat in ::CargoCat)
	{
		cargo_cat[index] = [];
		foreach (cargo in cat)
		{
			if (hash & (1 << cargo))
			{
				cargo_cat[index].append(cargo);
			}
		}
	}

	return cargo_cat;
}