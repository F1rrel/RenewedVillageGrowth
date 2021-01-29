enum CatLabels
{
	PUBLIC_SERVICES = 0,
	RAW_FOOD = 1,
	RAW_MATERIALS = 2,
	PROCESSED_MATERIALS = 3,
	FINAL_PRODUCTS = 4,
	PRODUCTS = 5,
	LOCAL_PRODUCTION = 6,
	IMPORTED_GOODS = 7
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
	/* FIRS version 1.4 */
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
		::CargoIDList <- ["PASS",null,"MAIL","OIL_","LVST","GOOD","GRAI","WOOD","IORE",null,
				  null,"FOOD",null,"PAPR","FISH",null,"CLAY",null,"MNSP",null,
				  null,"FMSP",null,"RFPR","ENSP","PETR",null,null,null,"BEER"];
		break;
	case(8): // Tropic basic
		::CargoIDList <- ["PASS",null,"MAIL","OIL_","LVST","GOOD","BEAN",null,null,null,
				  "JAVA","FOOD","SGBT","FRUT",null,"WOOL",null,"NITR","MNSP","VPTS",
				  null,"FMSP",null,"RFPR","ENSP",null,null,"AORE"];
		break;
	case(9): // Hearth of Darkness
		::CargoIDList <- ["PASS","DIAM","MAIL","OIL_",null,"GOOD","GRAI","WOOD","CORE",null,
				  "JAVA","FOOD","SGBT","FRUT","FISH",null,null,null,"MNSP",null,
				  "SUGR","FMSP","FICR",null,"ENSP",null,null,"RUBR","BDMT","BEER"];
		break;
	/* FIRS version 2 */
	case(10): // Temperate Basic
		::CargoIDList <- ["PASS","BEER","MAIL","RFPR","CLAY","GOOD","COAL","ENSP","FMSP","FISH",
				  "FRUT","FOOD","IORE","LVST","MNSP","STEL","MILK","SAND","SCMT"];
		break;
	case(11): // Arctic Basic
		::CargoIDList <- ["PASS","AORE","MAIL","RFPR","CLAY","GOOD","ENSP","FMSP","STEL","OIL_",
				  "PAPR","FOOD","PETR","PORE","RUBR","SAND","SCMT","VPTS","VEHI","WOOD"];
		break;
	case(12): // Tropic Basic
		::CargoIDList <- ["PASS","BEER","MAIL","BEAN","RFPR","GOOD","JAVA","COPR","CORE","ENSP",
				  "FMSP","FOOD","FISH","FRUT","GRAI","LVST","MNSP","NITR","OIL_","WOOL"];
		break;
	case(13): // In A Hot Country
		::CargoIDList <- ["PASS","BEER","MAIL","BDMT","CASS","GOOD","RFPR","CLAY","JAVA","COPR",
				  "CORE","FOOD","DIAM","EOIL","ENSP","FMSP","FRUT","LVST","WDPR","MAIZ",
				  "MNO2","MNSP","NUTS","OIL_","PETR","PHOS","RUBR","SAND","GRVL","WOOD"];
		break;
	case(14): // Extreme
		::CargoIDList <- ["PASS","BEER","MAIL","AORE","BDMT","GOOD","RFPR","CLAY","COAL","ENSP",
				  "FMSP","FOOD","FISH","FRUT","GRAI","IORE","LVST","WDPR","MNSP","STEL",
				  "MILK","OIL_","PETR","FICR","RCYC","SAND","SCMT","GRVL","SGBT","WOOD","WOOL"];
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
	case(15):
		::CargoIDList <- this.ConstructECSVectorCargoList(cargo_list);
		break;
	/* YETI 0.1.6 */
	case(16):
		::CargoIDList <- ["PASS","GRVL","MAIL","WOOD","BDMT",null,"GRAI","FRUT","FOOD",null,
				"OIL_",null,"STEL","PETR","BATT","VEHI","YETI","CLAY","LVST","URAN",
				"IORE"];

		if (cargo_list[21] == "YETY") {
			::CargoIDList.append("YETY");
		}
		break;
	/* FIRS version 3 */
	case(17): // Temperate Basic
		::CargoIDList <- ["PASS","BEER","MAIL","RFPR","CLAY","GOOD","COAL","ENSP","FMSP","FISH",
				  "FRUT","FOOD","IORE","LVST","MILK","SAND","SCMT","STEL"];
		break;
	case(18): // Arctic Basic
		::CargoIDList <- ["PASS","KAOL","MAIL","ENSP","FMSP","GOOD","PAPR","PORE","BEER","WDPR",
				  "PHOS","FOOD","BOOM","ZINC","FISH","SULP","FERT","WOOD","PEAT"];
		break;
	case(19): // Tropic Basic
		::CargoIDList <- ["PASS","BEER","MAIL","BEAN","RFPR","GOOD","JAVA","COPR","CORE","ENSP",
				  "FMSP","FOOD","FISH","FRUT","GRAI","LVST","NITR","OIL_","WOOL"];
		break;
	case(20): // Steeltown
		::CargoIDList <- ["PASS","CMNT","MAIL","QLME","ENSP","VEHI","FMSP","STEL","SLAG","LIME",
				  "SAND","FOOD","MNO2","COAL","IORE","IRON","COKE","PETR","SULP","SCMT",
				  "SASH","ZINC","COPR","RUBR","PIPE","SALT","ACID","CHLO","POWR","VPTS","VBOD"];
		break;
	case(21): // In A Hot Country
		::CargoIDList <- ["PASS","BEER","MAIL","BDMT","CASS","GOOD","RFPR","CLAY","JAVA","COPR",
				  "CORE","FOOD","DIAM","EOIL","ENSP","FMSP","FRUT","LVST","WDPR","MAIZ",
				  "MNO2","NUTS","OIL_","PETR","PHOS","RUBR","SAND","GRVL","WOOD"];
		break;
	case(22): // Extreme
		::CargoIDList <- ["PASS","BEER","MAIL","AORE","BDMT","GOOD","RFPR","CLAY","COAL","ENSP",
				  "FMSP","FOOD","FISH","FRUT","GRAI","IORE","LVST","WDPR","MNSP","METL",
				  "MILK","OIL_","PETR","FICR","RCYC","SAND","SCMT","GRVL","SGBT","WOOD","WOOL"];
		break;
	/* NAIS version 1.0.6 */
	case(23): // North America
		::CargoIDList <- ["PASS","AORE","MAIL","BDMT","RFPR","GOOD","CLAY","COAL","CORE","FMSP",
				  "FICR","FOOD","FISH","PETR","GLAS","GRAI","IORE","LVST","WDPR","ENSP","METL",
				  "MILK","PORE","OIL_","PAPR","FRUT","SAND","SCMT","GRVL","URAN","VALU","WOOD"];
		break;
	/* Improved Town Industries 1.6 */
	case(24):
		::CargoIDList <- ["PASS","COAL","MAIL","OIL_","WDPR","GOOD","RFPR","WOOD","IORE","STEL",
				            null,  null,"FOOD",  null,  null,  null];
		::CargoIDList[10] = ((cargo_list[10] == "RCYC") ? "RCYC" : null);
		::CargoIDList[11] = ((cargo_list[11] == "WSTE") ? "WSTE" : null);
		::CargoIDList[13] = ((cargo_list[13] == "URAN") ? "URAN" : null);
		::CargoIDList[14] = ((cargo_list[14] == "NUKF") ? "NUKF" : null);
		::CargoIDList[15] = ((cargo_list[15] == "NUKW") ? "NUKW" : null);
		break;
	/* FIRS version 4 alpha */
	case(25): // Temperate Basic
		::CargoIDList <- ["PASS","BEER","MAIL","RFPR","COAL","GOOD","ENSP","FMSP","FISH","FRUT",
				  "IORE","FOOD","KAOL","LVST","MILK","SAND","SCMT","STEL"];
		break;
	case(26): // Arctic Basic
		::CargoIDList <- ["PASS","NH3_","MAIL","ENSP","BOOM","FMSP","FERT","FISH","KAOL","WDPR",
				  "PAPR","FOOD","PEAT","PHOS","POTA","PORE","SULP","WOOD","ZINC"];
		break;
	case(27): // Tropic Basic
		::CargoIDList <- ["PASS","BEER","MAIL","BEAN","RFPR","GOOD","JAVA","COPR","CORE","ENSP",
				  "FMSP","FOOD","FISH","FRUT","GRAI","LVST","NITR","OIL_","WOOL"];
		break;
	case(28): // Steeltown
		::CargoIDList <- ["PASS","ACID","MAIL","STAL","ALUM","VEHI","CBLK","STCB","CSTI","CMNT",
				  "CHLO","FOOD","SOAP","COAL","CTAR","COKE","POWR","ENSP","FMSP","FECR",
				  "GLAS","IORE","LIME","LYE_","MNO2","O2__","COAT","IRON","PIPE","PLAS",
				  "QLME","RUBR","SALT","SAND","SCMT","SLAG","SASH","STST","STSE","STSH",
				  "STWR","SULP","TYRE","VBOD","VENG","VPTS","ZINC","POTA"];
		break;
	case(29): // In A Hot Country
		::CargoIDList <- ["PASS","BEER","MAIL","BDMT","CASS","GOOD","RFPR","CLAY","JAVA","COPR",
				  "CORE","FOOD","DIAM","EOIL","ENSP","FMSP","FRUT","LVST","WDPR","MAIZ",
				  "MNO2","NUTS","OIL_","PETR","PHOS","RUBR","SAND","GRVL","WOOD"];
		break;
	case(30): // XIS 0.6: The Lot
		::CargoIDList <- ["PASS","ACID","MAIL","BEER","AORE","GOOD","BEAN","BDMT","CMNT","RFPR",
						  "CHLO","FOOD","CLAY","COAL","COKE","COPR","CORE","EOIL","POWR","ENSP",
						  "BOOM","FMSP","FERT","FISH","FRUT","GRAI","IORE","KAOL","LIME","LVST",
						  "WDPR","MNO2","METL","MILK","NITR","OIL_","MNSP","PAPR","PEAT","PETR",
						  "PHOS","IRON","PIPE","FICR","PORE","QLME","RCYC","RUBR","SALT","SAND",
						  "SCMT","SLAG","SASH","STEL","SGBT","SULP","VBOD","VPTS","VEHI","WOOD",
						  "WOOL","ZINC"];
		break;
	default: break;
	}

	// This is used to add all null IDs after the end of active used cargos
	local missing_cargo = 64 - ::CargoIDList.len();
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
	 * defined (PUBLIC_SERVICES, General goods (including food),
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
				       [1,3,4,6,7,8],
				       [5,9,10]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_MATERIALS,CatLabels.PRODUCTS];
			::CargoMinPopDemand <- [0,1000,4000];
			::CargoPermille <- [60,45,25];
			::CargoDecay <- [0.4,0.2,0.1];
			break;
		case(2): //Base arctic
			::CargoCat <- [[0,2],
				       [1,3,4,6,7,10],
				       [5,9,11]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_MATERIALS,CatLabels.PRODUCTS];
			::CargoMinPopDemand <- [0,1000,4000];
			::CargoPermille <- [60,45,25];
			::CargoDecay <- [0.4,0.2,0.1];
			break;
		case(3): //Base tropical
			::CargoCat <- [[0,2],
				       [1,3,4,6,7,8,9,10],
				       [5,11]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_MATERIALS,CatLabels.PRODUCTS];
			::CargoMinPopDemand <- [0,1000,4000];
			::CargoPermille <- [60,45,25];
			::CargoDecay <- [0.4,0.2,0.1];
			break;
		case(4): //Base toyland
			::CargoCat <- [[0,2],
				       [1,4,6,7,8,9,10],
				       [3,5,11]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_MATERIALS,CatLabels.PRODUCTS];
			::CargoMinPopDemand <- [0,1000,4000];
			::CargoPermille <- [60,45,25];
			::CargoDecay <- [0.4,0.2,0.1];
			break;
		case(5): // FIRS 1.4 - Firs Economy
			::CargoCat <- [[0,2],
				       [4,6,10,12,13,14],
				       [1,3,7,8,15,16,17,20,22,26,27,31],
				       [9,18,19,21,23,24],
				       [5,11,25,28,29]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(6): // FIRS 1.4 - Temperate Basic
			::CargoCat <- [[0,2],
				       [4,10,13],
				       [1,8,16,17,19],
				       [9,18,20,23,24],
				       [5,11,29]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(7): // FIRS 1.4 - Arctic Basic
			::CargoCat <- [[0,2],
				       [4,6,14],
				       [3,7,8,16],
				       [13,18,21,23,24],
				       [5,11,25,29]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(8): // FIRS 1.4 - Tropic Basic
			::CargoCat <- [[0,2],
				       [4,6,10,12,13],
				       [3,15,17,27],
				       [18,21,23,24],
				       [5,11,19]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(9): // FIRS 1.4 - Hearth of the Darkness
			::CargoCat <- [[0,2],
				       [6,10,12,13,14],
				       [1,3,7,8,22,27],
				       [18,20,21,24],
				       [5,11,28,29]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(10): //ECS 1.2
			::CargoCat <- [[0,2,31],
				       [4,6,13,14,22,27],
				       [1,3,7,8,10,15,17,26,29],
				       [9,12,18,19,20,21,23],
				       [5,11,24,25,28]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(11): //YETI 0.1.6
			::CargoCat <- [[0,2,16,21],
				       [6,7,18],
				       [1,3,10,17,19,20],
				       [12,13,14],
				       [4,8,15]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(12): // FIRS 2 - Temperate Basic
			::CargoCat <- [[0,2],
				       [9,10,13,16],
				       [4,6,12,17,18],
				       [3,7,8,14,15],
				       [1,5,11]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(13): // FIRS 2 - Arctic Basic
			::CargoCat <- [[0,2],
				       [11],
				       [1,4,9,13,14,15,16,19],
				       [3,6,7,8,10,12,17],
				       [5,18]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(14): // FIRS 2 - Tropic Basic
			::CargoCat <- [[0,2],
				       [3,6,12,13,14,15],
				       [8,17,18,19],
				       [4,9,10,16],
				       [1,5,7,11]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(16): // FIRS 2 -In A Hot Coutry
			::CargoCat <- [[0,2],
				       [4,8,16,17,19,22],
				       [7,10,12,20,23,25,26,27,28,29],
				       [6,13,14,15,18,21,24],
				       [1,3,5,9,11]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(17): // FIRS 2 - Extreme
			::CargoCat <- [[0,2],
				       [12,13,14,16,20,28],
				       [3,7,8,15,21,23,24,25,26,27,29,30],
				       [6,9,10,17,18,19],
				       [1,4,5,11,22]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(18): // FIRS 3 - Temperate Basic
			::CargoCat <- [[0,2],
				       [9,10,13,14],
				       [4,6,12,15,16],
				       [3,7,8,17],
				       [1,5,11]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(19): // FIRS 3 - Arctic Basic
			::CargoCat <- [[0,2],
				       [8,11,14],
				       [1,7,10,17,18],
				       [3,4,9,13,15,16],
				       [6,8,12,16]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(20): // FIRS 3 - Tropic Basic
			::CargoCat <- [[0,2],
				       [1,3,6,12,13,14,15],
				       [8,16,17,18],
				       [4,9,10],
				       [5,7,11]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(21): // FIRS 3 - Steeltown
			::CargoCat <- [[0,2],
				       [9,10,11,13,14,19,25],
				       [12,17,21,22,23],
				       [3,4,6,7,8,15,16,18,26],
				       [1,5,24,27,28,29,30]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.LOCAL_PRODUCTION,CatLabels.IMPORTED_GOODS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(22): // FIRS 3 -In A Hot Coutry
			::CargoCat <- [[0,2],
				       [4,8,16,17,19,21],
				       [7,10,12,20,22,24,25,26,27,28],
				       [6,13,14,15,18,23],
				       [1,3,5,9,11]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(23): // FIRS 3 - Extreme
			::CargoCat <- [[0,2],
				       [12,13,14,16,20,28],
				       [3,7,8,15,21,23,24,25,26,27,29,30],
				       [6,9,10,17,18,19],
				       [1,4,5,11,22]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(24): // NAIS 1.0.6 - North America
			::CargoCat <- [[0,2],
				       [10,12,15,17,21,25],
				       [1,6,7,8,16,22,23,26,27,28,29,30,31],
				       [4,9,13,14,18,20,24],
				       [3,5,11,19]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(25): // Improved Town Industries 1.6
			::CargoCat <- [[0,2,11],
				       [1,3,7,8,12,13],
				       [4,5,6,9,10,14,15]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_MATERIALS,CatLabels.PRODUCTS];
			::CargoMinPopDemand <- [0,1000,4000];
			::CargoPermille <- [60,45,25];
			::CargoDecay <- [0.4,0.2,0.1];
			break;
		case(26): // FIRS 4 alpha: Temperate Basic
			::CargoCat <- [[0,2],
					   [8,9,13,14],
					   [4,10,12,15,16],
				       [3,6,7,17],
				       [1,5,11]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(27): // FIRS 4 alpha: Arctic Basic
			::CargoCat <- [[0,2],
					   [1,7,11,14],
					   [8,12,13,15,17],
				       [3,5,9,16],
				       [4,6,10,18]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(28): // FIRS 4 alpha: Tropic Basic
			::CargoCat <- [[0,2],
				       [1,3,6,12,13,14,15],
				       [8,16,17,18],
				       [4,9,10],
				       [5,7,11]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(29): // FIRS 4 alpha: Steeltown
			::CargoCat <- [[0,2],
					   [11,13,21,22,25,32,33,34,36,47],
					   [4,12,16,19,24,26,29,31,46],
				       [1,3,6,7,8,10,14,15,17,18,20,23,27,30,35,37,29,40,41],
				       [5,9,28,28,42,43,44,45]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.LOCAL_PRODUCTION,CatLabels.IMPORTED_GOODS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(30): // FIRS 3 -In A Hot Coutry
			::CargoCat <- [[0,2],
				       [4,8,16,17,19,21],
				       [7,10,12,20,22,24,25,26,27,28],
				       [6,13,14,15,18,23],
				       [1,3,5,9,11]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		case(31): // XIS 0.6: The Lot
			::CargoCat <- [[0,2],
				       [6,23,24,25,29,33,38,43,48,54],
				       [12,13,16,26,27,28,31,34,35,40,44,46,47,49,50,59,60],
				       [1,4,8,9,10,14,15,19,21,30,32,37,41,45,51,52,53,55,61],
				       [3,5,7,11,17,18,20,22,36,39,42,56,57,58]];
			::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
					   CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
			::CargoMinPopDemand <- [0,500,1000,4000,8000];
			::CargoPermille <- [60,25,25,15,10];
			::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
			break;
		default:
			break;
	}

	// Remove unused cargo ids
	if (::CargoIDList) {
		foreach (cat in ::CargoCat) {
			for (local index = 0; index < cat.len(); ++index) {
				if (::CargoIDList[cat[index]] == null) {
					cat.remove(index);
					--index;
				}
			}
		}
	}
}

/* This function compares the ingame initial cargo list to the
 * industry sets and cargoscheme supported by the script. Return false
 * if they don't match.
 */
function CheckInitialCargoList() {
	local cargo_list = [];
	for(local i = 0; i < 64; ++i) {
		cargo_list.append(GSCargo.GetCargoLabel(i));
	}
	FillCargoIDList(cargo_list);

	// Comparing actual list to original list
	for (local i = 0; i < 64; i++) {
		if (cargo_list[i] != ::CargoIDList[i]) {
			::CargoIDList = false;
			Log.Info("Warning: game's cargo list differ from settings.", Log.LVL_INFO);
			return;
		}
	}
}

function ConstructECSVectorCargoList(cargo_list) {
	local return_list = [];
	for (local i = 0; i < 64; ++i) {
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

/* Randomize fixed number of cargos per category and return cargo table. */
function RandomizeFixed(number)
{
	local cargo_cat = array(::CargoCat.len());
	foreach (cat_idx, cat in ::CargoCat)
	{
		if (cat_idx == 0) {
			cargo_cat[cat_idx] = cat;
		} else {
			local cargo_list = clone cat;
			cargo_cat[cat_idx] = [];
			for (local i = 0; i < number && cargo_list.len() != 0; i++) {
				local index = GSBase.RandRange(cargo_list.len());
				cargo_cat[cat_idx].append(cargo_list[index]);
				cargo_list.remove(index);
			}
		}
	}

	return cargo_cat;
}

/* Randomize number of cargos per category specified by range and return cargo table. */
function RandomizeRange(lower, upper)
{
	local cargo_cat = array(::CargoCat.len());
	foreach (cat_idx, cat in ::CargoCat)
	{
		if (cat_idx == 0) {
			cargo_cat[cat_idx] = cat;
		} else {
			local cargo_list = clone cat;
			cargo_cat[cat_idx] = [];
			for (local i = 0; i < lower && cargo_list.len() != 0; i++) {
				local index = GSBase.RandRange(cargo_list.len());
				cargo_cat[cat_idx].append(cargo_list[index]);
				cargo_list.remove(index);
			}
			for (local i = 0; i < upper-lower && cargo_list.len() != 0; i++) {
				local index = GSBase.RandRange(cargo_list.len()*2); // 50% chance
				if (index > cargo_list.len() - 1)
					break;
				cargo_cat[cat_idx].append(cargo_list[index]);
				cargo_list.remove(index);
			}
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