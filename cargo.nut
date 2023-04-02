enum CatLabels
{
    PUBLIC_SERVICES = 0,
    RAW_FOOD = 1,
    RAW_MATERIALS = 2,
    PROCESSED_MATERIALS = 3,
    FINAL_PRODUCTS = 4,
    PRODUCTS = 5,
    LOCAL_PRODUCTION = 6,
    IMPORTED_GOODS = 7,
    CATEGORY_I = 8,
    CATEGORY_II = 9,
    CATEGORY_III = 10,
    CATEGORY_IV = 11,
    CATEGORY_V = 12
}

enum Economies
{
    NONE,
    BASESET__TEMPERATE,
    BASESET__ARCTIC,
    BASESET__TROPICAL,
    BASESET__TOYLAND,
    FIRS1__FIRS_ECONOMY, // 1.4
    FIRS1__TEMPERATE_BASIC, // 1.4
    FIRS1__ARCTIC_BASIC, // 1.4
    FIRS1__TROPIC_BASIC, // 1.4
    FIRS1__HEARTH_OF_DARKNESS, // 1.4
    ECS, // 1.2
    FIRS2__TEMPERATE_BASIC, // 2.1.5
    FIRS2__ARCTIC_BASIC, // 2.1.5
    FIRS2__TROPIC_BASIC, // 2.1.5
    FIRS2__IN_A_HOT_COUNTRY, // 2.1.5
    FIRS2__EXTREME, // 2.1.5
    YETI, // 0.1.6
    FIRS3__TEMPERATE_BASIC, // 3.0.12
    FIRS3__ARCTIC_BASIC, // 3.0.12
    FIRS3__TROPIC_BASIC, // 3.0.12
    FIRS3__STEELTOWN, // 3.0.12
    FIRS3__IN_A_HOT_COUNTRY, // 3.0.12 and 4.0.0 - 4.1.x
    FIRS3__EXTREME, // 3.0.12
    NAIS__NORTH_AMERICA, // 1.0.6
    ITI, // 1.6
    FIRS4__TEMPERATE_BASIC, // 4.3.0
    FIRS4__ARCTIC_BASIC, // 4.3.0
    FIRS4__TROPIC_BASIC, // 4.3.0
    FIRS4__STEELTOWN, // 4.3.0
    FIRS4__IN_A_HOT_COUNTRY, // 4.3.0
    XIS__THE_LOT, // 0.6
    OTIS, // 03
    IOTC, // 0.1.4
    LUMBERJACK, // 0.1.0
    WRBI, // 1200
    ITI2, // 2.0
    REAL, // Real Industries Beta
    END,
}

/* Cargolist of supported industry set's cargos. Used to check if
 * initial ingame cargo list matches the defined setting. Needs to be
 * updated if industry set cargos change.
 */
function GetEconomyCargoList(economy, cargo_list) {
    switch (economy) {
    /* Baseset */
    case(Economies.BASESET__TEMPERATE): // Temperate
        return ["PASS","COAL","MAIL","OIL_","LVST","GOOD",
                "GRAI","WOOD","IORE","STEL","VALU"];
    case(Economies.BASESET__ARCTIC): // Arctic
        return ["PASS","COAL","MAIL","OIL_","LVST","GOOD",
                "WHEA","WOOD",  null,"PAPR","GOLD","FOOD"];
    case(Economies.BASESET__TROPICAL): // Tropical
        return ["PASS","RUBR","MAIL","OIL_","FRUT","GOOD",
                "MAIZ","WOOD","CORE","WATR","DIAM","FOOD"];
    case(Economies.BASESET__TOYLAND): // Toyland
        return ["PASS","SUGR","MAIL","TOYS","BATT","SWET",
                "TOFF","COLA","CTCD","BUBL","PLST","FZDR"];
    /* FIRS version 1.4 */
    case(Economies.FIRS1__FIRS_ECONOMY): // Firs economy
        return ["PASS","COAL","MAIL","OIL_","LVST","GOOD","GRAI","WOOD","IORE","STEL",
                "MILK","FOOD","SGBT","FRUT","FISH","WOOL","CLAY","SAND","MNSP","WDPR",
                "SCMT","FMSP","FICR","RFPR","ENSP","PETR","GRVL","AORE","BDMT","BEER",
                  null,"RCYC"];
    case(Economies.FIRS1__TEMPERATE_BASIC): // Temperate basic
        return ["PASS","COAL","MAIL",  null,"LVST","GOOD",  null,  null,"IORE","STEL",
                  "MILK","FOOD",  null,"FRUT",  null,  null,"CLAY","SAND","MNSP",  null,
                  "SCMT","FMSP",  null,"RFPR","ENSP",  null,  null,  null,  null,"BEER"];
    case(Economies.FIRS1__ARCTIC_BASIC): // Arctic basic
        return ["PASS",  null,"MAIL","OIL_","LVST","GOOD","GRAI","WOOD","IORE",  null,
                  null,"FOOD",  null,"PAPR","FISH",  null,"CLAY",  null,"MNSP",  null,
                  null,"FMSP",  null,"RFPR","ENSP","PETR",  null,  null,  null,"BEER"];
    case(Economies.FIRS1__TROPIC_BASIC): // Tropic basic
        return ["PASS",  null,"MAIL","OIL_","LVST","GOOD","BEAN",  null,  null,  null,
                "JAVA","FOOD","SGBT","FRUT",  null,"WOOL",  null,"NITR","MNSP","VPTS",
                  null,"FMSP",  null,"RFPR","ENSP",  null,  null,"AORE"];
    case(Economies.FIRS1__HEARTH_OF_DARKNESS): // Hearth of Darkness
        return ["PASS","DIAM","MAIL","OIL_",  null,"GOOD","GRAI","WOOD","CORE",  null,
                "JAVA","FOOD","SGBT","FRUT","FISH",  null,  null,  null,"MNSP",  null,
                "SUGR","FMSP","FICR",  null,"ENSP",  null,  null,"RUBR","BDMT","BEER"];
    /* ECS - Included vectors:
     * ECS Town vector 1.2
     * ECS Houses 1.2
     * ECS Basic vector II 1.2
     * ECS Chemicals vector II 1.2
     * ECS Machinery Vector 1.2
     * ECS Wood vector 1.2
     * ECS Agricultural vector 1.2
     */
    case(Economies.ECS):
        return this.ConstructECSVectorCargoList(cargo_list);
    /*FIRS version 2.1.5 */
    case(Economies.FIRS2__TEMPERATE_BASIC): // Temperate Basic
        return ["PASS","BEER","MAIL","RFPR","CLAY","GOOD","COAL","ENSP","FMSP","FISH",
                "FRUT","FOOD","IORE","LVST","MNSP","STEL","MILK","SAND","SCMT"];
    case(Economies.FIRS2__ARCTIC_BASIC): // Arctic Basic
        return ["PASS","AORE","MAIL","RFPR","CLAY","GOOD","ENSP","FMSP","STEL","OIL_",
                "PAPR","FOOD","PETR","PORE","RUBR","SAND","SCMT","VPTS","VEHI","WOOD"];
    case(Economies.FIRS2__TROPIC_BASIC): // Tropic Basic
        return ["PASS","BEER","MAIL","BEAN","RFPR","GOOD","JAVA","COPR","CORE","ENSP",
                "FMSP","FOOD","FISH","FRUT","GRAI","LVST","MNSP","NITR","OIL_","WOOL"];
    case(Economies.FIRS2__IN_A_HOT_COUNTRY): // In a Hot Country
        return ["PASS","BEER","MAIL","BDMT","CASS","GOOD","RFPR","CLAY","JAVA","COPR",
                "CORE","FOOD","DIAM","EOIL","ENSP","FMSP","FRUT","LVST","WDPR","MAIZ",
                "MNO2","MNSP","NUTS","OIL_","PETR","PHOS","RUBR","SAND","GRVL","WOOD"];
    case(Economies.FIRS2__EXTREME): // Extreme
        return ["PASS","BEER","MAIL","AORE","BDMT","GOOD","RFPR","CLAY","COAL","ENSP",
                "FMSP","FOOD","FISH","FRUT","GRAI","IORE","LVST","WDPR","MNSP","STEL",
                "MILK","OIL_","PETR","FICR","RCYC","SAND","SCMT","GRVL","SGBT","WOOD","WOOL"];
    /* YETI 0.1.6 */
    case(Economies.YETI):
    {
        local list = ["PASS","GRVL","MAIL","WOOD","BDMT",  null,"GRAI","FRUT","FOOD",  null,
                      "OIL_",  null,"STEL","PETR","BATT","VEHI","YETI","CLAY","LVST","URAN",
                      "IORE"];
        if (21 < cargo_list.len() && cargo_list[21] == "YETY")
            list.append("YETY");
        return list;
    }
    /* FIRS version 3 */
    case(Economies.FIRS3__TEMPERATE_BASIC): // Temperate Basic
        return ["PASS","BEER","MAIL","RFPR","CLAY","GOOD","COAL","ENSP","FMSP","FISH",
                "FRUT","FOOD","IORE","LVST","MILK","SAND","SCMT","STEL"];
    case(Economies.FIRS3__ARCTIC_BASIC): // Arctic Basic
        return ["PASS","KAOL","MAIL","ENSP","FMSP","GOOD","PAPR","PORE","BEER","WDPR",
                "PHOS","FOOD","BOOM","ZINC","FISH","SULP","FERT","WOOD","PEAT"];
    case(Economies.FIRS3__TROPIC_BASIC): // Tropic Basic
        return ["PASS","BEER","MAIL","BEAN","RFPR","GOOD","JAVA","COPR","CORE","ENSP",
                "FMSP","FOOD","FISH","FRUT","GRAI","LVST","NITR","OIL_","WOOL"];
    case(Economies.FIRS3__STEELTOWN): // Steeltown
        return ["PASS","CMNT","MAIL","QLME","ENSP","VEHI","FMSP","STEL","SLAG","LIME",
                "SAND","FOOD","MNO2","COAL","IORE","IRON","COKE","PETR","SULP","SCMT",
                "SASH","ZINC","COPR","RUBR","PIPE","SALT","ACID","CHLO","POWR","VPTS","VBOD"];
    case(Economies.FIRS3__IN_A_HOT_COUNTRY): // In A Hot Country
        return ["PASS","BEER","MAIL","BDMT","CASS","GOOD","RFPR","CLAY","JAVA","COPR",
                "CORE","FOOD","DIAM","EOIL","ENSP","FMSP","FRUT","LVST","WDPR","MAIZ",
                "MNO2","NUTS","OIL_","PETR","PHOS","RUBR","SAND","GRVL","WOOD"];
    case(Economies.FIRS3__EXTREME): // Extreme
        return ["PASS","BEER","MAIL","AORE","BDMT","GOOD","RFPR","CLAY","COAL","ENSP",
                "FMSP","FOOD","FISH","FRUT","GRAI","IORE","LVST","WDPR","MNSP","METL",
                "MILK","OIL_","PETR","FICR","RCYC","SAND","SCMT","GRVL","SGBT","WOOD","WOOL"];
    /* NAIS version 1.0.6 */
    case(Economies.NAIS__NORTH_AMERICA): // North America
        return ["PASS","AORE","MAIL","BDMT","RFPR","GOOD","CLAY","COAL","CORE","FMSP",
                "FICR","FOOD","FISH","PETR","GLAS","GRAI","IORE","LVST","WDPR","ENSP","METL",
                "MILK","PORE","OIL_","PAPR","FRUT","SAND","SCMT","GRVL","URAN","VALU","WOOD"];
    /* Improved Town Industries 1.6 */
    case(Economies.ITI):
    {
        local list = ["PASS","COAL","MAIL","OIL_","WDPR","GOOD","RFPR","WOOD","IORE","STEL",
                        null,  null,"FOOD",  null,  null,  null];

        list[10] = ((10 < cargo_list.len() && cargo_list[10] == "RCYC") ? "RCYC" : null);
        list[11] = ((11 < cargo_list.len() && cargo_list[11] == "WSTE") ? "WSTE" : null);
        list[13] = ((13 < cargo_list.len() && cargo_list[13] == "URAN") ? "URAN" : null);
        list[14] = ((14 < cargo_list.len() && cargo_list[14] == "NUKF") ? "NUKF" : null);
        list[15] = ((15 < cargo_list.len() && cargo_list[15] == "NUKW") ? "NUKW" : null);

        // Remove null cargo types at the end of the list
        local index = 15;
        while (list[index] == null) {
            list.remove(index);
            --index;
        }

        return list;
    }
    /* FIRS version 4.3 */
    case(Economies.FIRS4__TEMPERATE_BASIC): // Temperate Basic
        return ["PASS","BEER","MAIL","RFPR","COAL","GOOD","ENSP","FMSP","FISH","FRUT",
                "IORE","FOOD","KAOL","LVST","MILK","SAND","SCMT","STEL"];
    case(Economies.FIRS4__ARCTIC_BASIC): // Arctic Basic
        return ["PASS","NH3_","MAIL","ENSP","BOOM","FMSP","FERT","FISH","KAOL","WOOD",
                "WDPR","FOOD","PAPR","PEAT","PHOS","POTA","PORE","SULP","ZINC"];
    case(Economies.FIRS4__TROPIC_BASIC): // Tropic Basic
        return ["PASS","BEER","MAIL","BEAN","RFPR","GOOD","JAVA","COPR","CORE","ENSP",
                "FMSP","FOOD","FISH","FRUT","GRAI","LVST","NITR","OIL_","WOOL"];
    case(Economies.FIRS4__STEELTOWN): // Steeltown
        return ["PASS","ACID","MAIL","STAL","ALUM","VEHI","CBLK","STCB","CSTI","CMNT",
                "CHLO","FOOD","SOAP","COAL","CTAR","COKE","POWR","ENSP","FMSP","FECR",
                "GLAS","IORE","LIME","LYE_","MNO2","O2__","COAT","IRON","PIPE","PLAS",
                "QLME","RUBR","SALT","SAND","SCMT","SLAG","SASH","STST","STSE","STSH",
                "STWR","SULP","TYRE","VBOD","VENG","VPTS","ZINC","POTA"];
    case(Economies.FIRS4__IN_A_HOT_COUNTRY): // In A Hot Country
        return ["PASS","BEER","MAIL","BDMT","CASS","GOOD","RFPR","CLAY","JAVA","COPR",
                "CORE","FOOD","DIAM","EOIL","ENSP","FMSP","FRUT","LVST","WOOD","WDPR",
                "MAIZ","MNO2","NUTS","OIL_","PETR","PHOS","RUBR","SAND","GRVL"];
    case(Economies.XIS__THE_LOT): // XIS 0.6: The Lot
        return ["PASS","ACID","MAIL","BEER","AORE","GOOD","BEAN","BDMT","CMNT","RFPR",
                "CHLO","FOOD","CLAY","COAL","COKE","COPR","CORE","EOIL","POWR","ENSP",
                "BOOM","FMSP","FERT","FISH","FRUT","GRAI","IORE","KAOL","LIME","LVST",
                "WDPR","MNO2","METL","MILK","NITR","OIL_","MNSP","PAPR","PEAT","PETR",
                "PHOS","IRON","PIPE","FICR","PORE","QLME","RCYC","RUBR","SALT","SAND",
                "SCMT","SLAG","SASH","STEL","SGBT","SULP","VBOD","VPTS","VEHI","WOOD",
                "WOOL","ZINC"];
    case(Economies.OTIS): // OTIS 03
        local list = ["PASS","COAL","MAIL","OIL_","LIME","GOOD","GRAI","WOOD","IORE","STEL",
                      "MILK","FOOD","PAPR","FISH","WOOL","CLAY","SAND","WDPR","PCL_","GRVL",
                      "FRUT","BDMT","BEER","MAIZ","CMNT","GLAS","LVST","PETR","FRVG","SASH",
                      "OTI1","CORE","SCMT","COPR","URAN","VALU","AORE","OTI2","NICK","SULP",
                      "RUBR","VEHI","BAKE","PIPE","OYST","MEAT","CHSE","FURN","TEXT","SEED",
                      "FERT","BOOM","ACID","CHLO","SLAG","TWOD","SESP","FUEL","ELTR","WATR",
                      "TATO","POWR","MPTS","RFPR"];
        if (60 < cargo_list.len() && cargo_list[60] == "POTA")
            list[60] = "POTA";
        return list;

    case(Economies.IOTC): // IOTC 0.1.4
        return ["PASS","TOUR","MAIL","JAVA","OILD","BEER","SGCN","SUGR","TBCO", null,
                "MOLS","CIGR","FOOD","OILI","FUEL","RFPR","PIPE","NKOR","NICK","COBL",
                "FERT","ENSP"];
    case(Economies.LUMBERJACK): // Lumberjack Industries
        return ["PASS","COAL","MAIL","OIL_","RFPR","GOOD","GRAI","WOOD","WDPR","PAPR",
                "MNSP","FERT","FOOD","KAOL","FUEL","COAT"]
    case(Economies.WRBI): // WRBI 1200
        local list = ["PASS","COAL","MAIL","OIL_","LVST","GOOD","GRAI","WOOD","IORE","STEL",
                      "VALU","FOOD",  null,  null,  null,  null,  null,  null,  null,  null,
                        null,"GRVL","BDMT",  null,  null,"PLST","WDPR","RFPR","BEER","PETR"];
        if (23 < cargo_list.len() && cargo_list[23] == "RCYC")
            list[23] = "RCYC";
        if (30 < cargo_list.len() && cargo_list[30] == "WSTE")
            list.append("WSTE");
        return list;
    case(Economies.ITI2): // Improved Town Industries 2
        return ["PASS","COAL","WSTE","OIL_","WDPR","GOOD","RFPR","WOOD","IORE","STEL","PAPR",
                "PLAS","FOOD","BDMT","VALU","LVST","WDCH","SCMT","SCPR","GRAI"];

    case(Economies.REAL): // Real Industries Beta
        return ["PASS","COAL","GOOD","GRAI","IORE","MAIL","LVST","OIL_","STEL","VALU",
                "WOOD","MAIZ","WDPR","WORK","STUD","OTI2","TRSH","VEHI","PRIS","FOOD",
                "PASS","PETR","RUBR","PLAS","TYRE","HVEH"];

    default:
        return [];
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
                default_list = GetEconomyCargoList(Economies.BASESET__TEMPERATE, cargo_list);
                break;
            case GSGame.LT_ARCTIC:
                default_list = GetEconomyCargoList(Economies.BASESET__ARCTIC, cargo_list);
                break;
            case GSGame.LT_TROPIC:
                default_list = GetEconomyCargoList(Economies.BASESET__TROPICAL, cargo_list);
                break;
            case GSGame.LT_TOYLAND:
                default_list = GetEconomyCargoList(Economies.BASESET__TOYLAND, cargo_list);
                break;
        }
        foreach (index, cargo in default_list) {
            return_list[index] = cargo;
        }
    }

    // ECS Basic
    local basic = true;
    local basic_list = ["COAL","SAND","GLAS","BDMT"];
    local basic_idx = [1,17,18,28];
    foreach (index, id in basic_idx) {
        if (basic_idx[index] >= cargo_list.len() || cargo_list[id] != basic_list[index]) {
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
        if (chemical_idx[index] >= cargo_list.len() || cargo_list[id] != chemical_list[index]) {
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
        if (machinery_idx[index] >= cargo_list.len() || cargo_list[id] != machinery_list[index]) {
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
        if (wood_idx[index] >= cargo_list.len() || cargo_list[id] != wood_list[index]) {
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
        if (agricultural_idx[index] >= cargo_list.len() || cargo_list[id] != agricultural_list[index]) {
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

    // Remove null cargo types at the end of the list
    local index = 63;
    while (return_list[index] == null) {
        return_list.remove(index);
        --index;
    }

    return return_list;
}

/* Here are defined the cargo categories and other data for each
 * set. Follow explanations below to change category data.
 */
function DefineCargosBySettings(economy)
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
    switch (economy) {
        case(Economies.BASESET__TEMPERATE): // Base temperate
            ::CargoLimiter <- [0,2];
            ::CargoCat <- [[0,2],
                       [1,3,4,6,7,8],
                       [5,9,10]];
            ::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_MATERIALS,CatLabels.PRODUCTS];
            ::CargoMinPopDemand <- [0,1000,4000];
            ::CargoPermille <- [60,45,25];
            ::CargoDecay <- [0.4,0.2,0.1];
            break;
        case(Economies.BASESET__ARCTIC): //Base arctic
            ::CargoLimiter <- [0,2];
            ::CargoCat <- [[0,2],
                       [1,3,4,6,7,10],
                       [5,9,11]];
            ::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_MATERIALS,CatLabels.PRODUCTS];
            ::CargoMinPopDemand <- [0,1000,4000];
            ::CargoPermille <- [60,45,25];
            ::CargoDecay <- [0.4,0.2,0.1];
            break;
        case(Economies.BASESET__TROPICAL): //Base tropical
            ::CargoLimiter <- [0,2];
            ::CargoCat <- [[0,2],
                       [1,3,4,6,7,8,9,10],
                       [5,11]];
            ::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_MATERIALS,CatLabels.PRODUCTS];
            ::CargoMinPopDemand <- [0,1000,4000];
            ::CargoPermille <- [60,45,25];
            ::CargoDecay <- [0.4,0.2,0.1];
            break;
        case(Economies.BASESET__TOYLAND): //Base toyland
            ::CargoLimiter <- [0,2];
            ::CargoCat <- [[0,2],
                       [1,4,6,7,8,9,10],
                       [3,5,11]];
            ::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_MATERIALS,CatLabels.PRODUCTS];
            ::CargoMinPopDemand <- [0,1000,4000];
            ::CargoPermille <- [60,45,25];
            ::CargoDecay <- [0.4,0.2,0.1];
            break;
        case(Economies.FIRS1__FIRS_ECONOMY): // FIRS 1.4 - Firs Economy
            ::CargoLimiter <- [0,2];
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
        case(Economies.FIRS1__TEMPERATE_BASIC): // FIRS 1.4 - Temperate Basic
            ::CargoLimiter <- [0,2];
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
        case(Economies.FIRS1__ARCTIC_BASIC): // FIRS 1.4 - Arctic Basic
            ::CargoLimiter <- [0,2];
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
        case(Economies.FIRS1__TROPIC_BASIC): // FIRS 1.4 - Tropic Basic
            ::CargoLimiter <- [0,2];
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
        case(Economies.FIRS1__HEARTH_OF_DARKNESS): // FIRS 1.4 - Hearth of the Darkness
            ::CargoLimiter <- [0,2];
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
        case(Economies.ECS): //ECS 1.2
            ::CargoLimiter <- [0,2];
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
        case(Economies.FIRS2__TEMPERATE_BASIC): // FIRS 2 - Temperate Basic
            ::CargoLimiter <- [0,2];
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
        case(Economies.FIRS2__ARCTIC_BASIC): // FIRS 2 - Arctic Basic
            ::CargoLimiter <- [0,2];
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
        case(Economies.FIRS2__TROPIC_BASIC): // FIRS 2 - Tropic Basic
            ::CargoLimiter <- [0,2];
            ::CargoCat <- [[0,2],
                          [1,3,6,12,13,14,15],
                          [8,17,18,19],
                          [4,9,10,16],
                          [5,7,11]];
            ::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
                       CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
            ::CargoMinPopDemand <- [0,500,1000,4000,8000];
            ::CargoPermille <- [60,25,25,15,10];
            ::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
            break;
        case(Economies.FIRS2__IN_A_HOT_COUNTRY): // FIRS 2 - In a Hot Country
            ::CargoLimiter <- [0,2];
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
        case(Economies.FIRS2__EXTREME): // FIRS 2 - Extreme
            ::CargoLimiter <- [0,2];
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
        case(Economies.YETI): //YETI 0.1.6
            ::CargoLimiter <- [0,2];
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
        case(Economies.FIRS3__TEMPERATE_BASIC): // FIRS 3 - Temperate Basic
            ::CargoLimiter <- [0,2];
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
        case(Economies.FIRS3__ARCTIC_BASIC): // FIRS 3 - Arctic Basic
            ::CargoLimiter <- [0,2];
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
        case(Economies.FIRS3__TROPIC_BASIC): // FIRS 3 - Tropic Basic
            ::CargoLimiter <- [0,2];
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
        case(Economies.FIRS3__STEELTOWN): // FIRS 3 - Steeltown
            ::CargoLimiter <- [0,2];
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
        case(Economies.FIRS3__IN_A_HOT_COUNTRY): // FIRS 3 and 4.0-4.1 - In A Hot Coutry
            ::CargoLimiter <- [0,2];
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
        case(Economies.FIRS3__EXTREME): // FIRS 3 - Extreme
            ::CargoLimiter <- [0,2];
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
        case(Economies.NAIS__NORTH_AMERICA): // NAIS 1.0.6 - North America
            ::CargoLimiter <- [0,2];
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
        case(Economies.ITI): // Improved Town Industries 1.6
            ::CargoLimiter <- [0,2,11];
            ::CargoCat <- [[0,2,11],
                       [1,3,7,8,12,13],
                       [4,5,6,9,10,14,15]];
            ::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_MATERIALS,CatLabels.PRODUCTS];
            ::CargoMinPopDemand <- [0,1000,4000];
            ::CargoPermille <- [60,45,25];
            ::CargoDecay <- [0.4,0.2,0.1];
            break;
        case(Economies.FIRS4__TEMPERATE_BASIC): // FIRS 4.3: Temperate Basic
            ::CargoLimiter <- [0,2];
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
        case(Economies.FIRS4__ARCTIC_BASIC): // FIRS 4.3: Arctic Basic
            ::CargoLimiter <- [0,2];
            ::CargoCat <- [[0,2],
                       [1,7,11,15],
                       [8,9,13,14,16],
                       [3,5,10,17],
                       [4,6,12,18]];
            ::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
                       CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
            ::CargoMinPopDemand <- [0,500,1000,4000,8000];
            ::CargoPermille <- [60,25,25,15,10];
            ::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
            break;
        case(Economies.FIRS4__TROPIC_BASIC): // FIRS 4.3: Tropic Basic
            ::CargoLimiter <- [0,2];
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
        case(Economies.FIRS4__STEELTOWN): // FIRS 4.3: Steeltown
            ::CargoLimiter <- [0,2];
            ::CargoCat <- [[0,2],
                       [11,13,21,22,25,32,33,34,36,47],
                       [4,12,16,19,24,26,29,31,46],
                       [1,3,6,7,8,10,14,15,17,18,20,23,27,30,35,37,39,40,41],
                       [5,9,28,38,42,43,44,45]];
            ::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.LOCAL_PRODUCTION,CatLabels.IMPORTED_GOODS,
                       CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
            ::CargoMinPopDemand <- [0,500,1000,4000,8000];
            ::CargoPermille <- [60,25,25,15,10];
            ::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
            break;
        case(Economies.FIRS4__IN_A_HOT_COUNTRY): // FIRS 4.3 -In A Hot Coutry
            ::CargoLimiter <- [0,2];
            ::CargoCat <- [[0,2],
                       [4,8,16,17,20,22],
                       [7,10,12,18,21,23,25,26,27,28],
                       [6,13,14,15,19,24],
                       [1,3,5,9,11]];
            ::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
                       CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
            ::CargoMinPopDemand <- [0,500,1000,4000,8000];
            ::CargoPermille <- [60,25,25,15,10];
            ::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
            break;
        case(Economies.XIS__THE_LOT): // XIS 0.6: The Lot
            ::CargoLimiter <- [0,2];
            ::CargoCat <- [[0,2],
                       [6,11,23,24,25,29,33,38,54],
                       [4,12,13,16,26,27,28,31,34,35,40,43,44,46,47,48,49,50,52,59,60],
                       [1,8,9,10,14,15,19,20,21,22,30,32,37,41,45,51,53,55,61],
                       [3,5,7,17,18,36,39,42,56,57,58]];
            ::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_FOOD,CatLabels.RAW_MATERIALS,
                       CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
            ::CargoMinPopDemand <- [0,500,1000,4000,8000];
            ::CargoPermille <- [60,25,25,15,10];
            ::CargoDecay <- [0.4,0.2,0.2,0.1,0.1];
            break;
        case(Economies.OTIS): // OTIS 03
            ::CargoLimiter <- [0,2];
            ::CargoCat <- [[0,2],
                       [1,4,6,7,8,9,10,11,13,14,15,16,17,19,20,23,26,28,29,30,31,32,40,44,49,51,55,59,60,63],
                       [3,5,12,22,24,25,27,33,36,38,39,42,43,45,46,48,50,52,53,54,56],
                       [18,21,34,35,37,41,47,57,58,61,62]];
            ::CargoCatList <- [CatLabels.CATEGORY_I,CatLabels.CATEGORY_II,CatLabels.CATEGORY_III,
                       CatLabels.CATEGORY_IV];
            ::CargoMinPopDemand <- [0,500,1000,4000];
            ::CargoPermille <- [60,25,25,15];
            ::CargoDecay <- [0.4,0.2,0.2,0.1];
            break;
        case(Economies.IOTC): // IOTC 0.1.2
            ::CargoLimiter <- [0,2];
            ::CargoCat <- [[0,2],
                       [6,8,12,13,15],
                       [10,14,16,17],
                       [4,5,20,21]];
            ::CargoCatList <- [CatLabels.CATEGORY_I,CatLabels.CATEGORY_II,CatLabels.CATEGORY_III,
                       CatLabels.CATEGORY_IV];
            ::CargoMinPopDemand <- [0,500,1500,4000];
            ::CargoPermille <- [60,35,25,15];
            ::CargoDecay <- [0.4,0.3,0.2,0.1];
            break;
        case(Economies.LUMBERJACK): // Lumberjack Industries 0.1.0
            ::CargoLimiter <- [2];
            ::CargoCat <- [[2],
                       [12],
                       [5],
                       [1]];
            ::CargoCatList <- [CatLabels.CATEGORY_I,CatLabels.CATEGORY_II,CatLabels.CATEGORY_III,
                       CatLabels.CATEGORY_IV];
            ::CargoMinPopDemand <- [500,1500,3000,6000];
            ::CargoPermille <- [25,25,25,25];
            ::CargoDecay <- [0.3,0.3,0.3,0.3];
            break;
        case(Economies.WRBI): // WRBI 1200
            ::CargoLimiter <- [0,2];
            ::CargoCat <- [[0,2],
                           [1,3,4,6,7,8,21,23],
                           [9,25,26,27,30],
                           [5,10,11,22,28,29]]
            ::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_MATERIALS,CatLabels.PROCESSED_MATERIALS,CatLabels.FINAL_PRODUCTS];
            ::CargoMinPopDemand <- [0,500,1500,4000];
            ::CargoPermille <- [60,35,25,15];
            ::CargoDecay <- [0.4,0.3,0.2,0.1];
            break;
        case(Economies.ITI2): // Improved Town Industries 2
            ::CargoLimiter <- [0,2];
            ::CargoCat <- [[0],
                       [12],
                       [13],
                       [5],
                       [14]];
            ::CargoCatList <- [CatLabels.CATEGORY_I,CatLabels.CATEGORY_II,CatLabels.CATEGORY_III,
                       CatLabels.CATEGORY_IV,CatLabels.CATEGORY_V];
            ::CargoMinPopDemand <- [0,1000,2000,3000,4000];
            ::CargoPermille <- [60,45,35,25,15];
            ::CargoDecay <- [0.5,0.4,0.3,0.2,0.1];
            break;
        case(Economies.REAL): // Real Industries Beta
            ::CargoLimiter <- [0,2,5];
            ::CargoCat <- [[0,2,5],
                       [1,3,4,6,7,9,10,11,16],
                       [8,12,22,23,24],
                       [13,14,15,18,20],
                       [17,19,21,25]];
            ::CargoCatList <- [CatLabels.PUBLIC_SERVICES,CatLabels.RAW_MATERIALS,CatLabels.PRODUCTS,
                       CatLabels.PUBLIC_SERVICES,CatLabels.FINAL_PRODUCTS];
            ::CargoMinPopDemand <- [0,1000,2000,3000,4000];
            ::CargoPermille <- [60,45,35,15,15];
            ::CargoDecay <- [0.5,0.4,0.3,0.1,0.1];
            break;
        default:
            if (!CreateDefaultCargoCat())
                return false;
            break;
    }

    // Remove unused cargo ids
    if (::CargoIDList) {
        foreach (cat in ::CargoCat) {
            for (local index = 0; index < cat.len(); ++index) {
                if (cat[index] >= ::CargoIDList.len() || ::CargoIDList[cat[index]] == null) {
                    cat.remove(index);
                    --index;
                }
            }
        }

        foreach (index, cargo in ::CargoLimiter) {
            if (cargo >= ::CargoIDList.len() || ::CargoIDList[cargo] == null) {
                ::CargoLimiter.remove(index);
                --index;
            }
        }
    }

    return true;
}

/* This function compares the ingame initial cargo list to the
 * industry sets and cargoscheme supported by the script.
 */
function DiscoverEconomyType() {
    local economy = Economies.NONE;
    for (local i = 1; i < Economies.END; ++i) {
        local economy_cargo_list = GetEconomyCargoList(i, ::CargoIDList);
        if (CompareCargoLists(economy_cargo_list, ::CargoIDList)) {
            return i;
        }
    }

    return economy;
}

function CompareCargoLists(list1, list2) {
    if (list1.len() != list2.len())
        return false;

    for (local i = 0; i < list1.len(); i++) {
        if (list1[i] != list2[i]) {
            return false;
        }
    }
    return true;
}

function SortCategoriesMinPopDemand()
{
    for (local i = 0; i < ::CargoCatNum; i++) {
        for (local j = 0; j < ::CargoCatNum - 1; j++) {
            if (::CargoMinPopDemand[j] > ::CargoMinPopDemand[j+1]) {
                local cargo_cat = ::CargoCat[j];
                ::CargoCat[j] = ::CargoCat[j+1];
                ::CargoCat[j+1] = cargo_cat;

                local cargo_cat_list = ::CargoCatList[j];
                ::CargoCatList[j] = ::CargoCatList[j+1];
                ::CargoCatList[j+1] = cargo_cat_list;

                local min_pop_demand = ::CargoMinPopDemand[j];
                ::CargoMinPopDemand[j] = ::CargoMinPopDemand[j+1];
                ::CargoMinPopDemand[j+1] = min_pop_demand;

                local cargo_permille = ::CargoPermille[j];
                ::CargoPermille[j] = ::CargoPermille[j+1];
                ::CargoPermille[j+1] = cargo_permille;

                local cargo_decay = ::CargoDecay[j];
                ::CargoDecay[j] = ::CargoDecay[j+1];
                ::CargoDecay[j+1] = cargo_decay;
            }
        }
    }
}

/* Initialization of cargo data. */
function InitCargoLists()
{
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

    DebugCargoLabels();         // Debug info: print cargo labels

    // Get economy type based on cargo list
    // Define cargo data accordingly to industry set
    local economy = DiscoverEconomyType();
    if (!DefineCargosBySettings(economy))
        return false;
    Log.Info("Economy: " + (economy == Economies.NONE ? "generated" : ("predefined " + economy)), Log.LVL_INFO);

    // Initializing some useful and often used variables
    ::CargoCatNum <- ::CargoCat.len();
    ::Economy <- economy;

    // Change cargo min pop demand if specified
    local changed_min_pop_demand = false;
    for (local i = 0; i < ::CargoCatNum; i++) {
        if (::SettingsTable.category_min_pop[i] >= 0) {
            ::CargoMinPopDemand[i] = ::SettingsTable.category_min_pop[i];
            changed_min_pop_demand = true;
        }
    }

    if (changed_min_pop_demand)
        SortCategoriesMinPopDemand();

    return true;
}

/* Randomize fixed number of cargos per category and return cargo table. */
function RandomizeFixed(number, near_cargos, near_cargo_probability)
{
    local cargo_cat_text = "";
    local cargo_cat = array(::CargoCat.len());
    foreach (cat_idx, cat in ::CargoCat)
    {
        cargo_cat_text += cat_idx + ": [";

        if (::CargoCatList[cat_idx] == CatLabels.PUBLIC_SERVICES || ::CargoCatList[cat_idx] == CatLabels.CATEGORY_I) {
            cargo_cat[cat_idx] = cat;

            foreach (cargo in cat) {
                cargo_cat_text += GSCargo.GetCargoLabel(cargo) + " ";
            }
        } else {
            local cargo_list = clone cat;
            local near_cargo_list = clone near_cargos[cat_idx];
            cargo_cat[cat_idx] = [];
            for (local i = 0; i < number && cargo_list.len() != 0; i++) {
                if (near_cargo_list.len() && GSBase.Chance(near_cargo_probability, 100)) { // Use near cargo
                    local index = GSBase.RandRange(near_cargo_list.len());
                    cargo_cat[cat_idx].append(near_cargo_list[index]);

                    // Find and remove cargo index from the other array
                    foreach (idx, cargo in cargo_list) {
                        if (cargo == near_cargo_list[index]) {
                            cargo_list.remove(idx);
                            break;
                        }
                    }

                    cargo_cat_text += GSCargo.GetCargoLabel(near_cargo_list[index]) + "(NEAR) ";
                    near_cargo_list.remove(index);
                }
                else { // Use any cargo
                    local index = GSBase.RandRange(cargo_list.len());
                    cargo_cat[cat_idx].append(cargo_list[index]);

                    // Find and remove cargo index from the other array
                    foreach (idx, cargo in near_cargo_list) {
                        if (cargo == cargo_list[index]) {
                            near_cargo_list.remove(idx);
                            break;
                        }
                    }

                    cargo_cat_text += GSCargo.GetCargoLabel(cargo_list[index]) + "(RAND) ";
                    cargo_list.remove(index);
                }
            }
        }

        cargo_cat_text += "] ";
    }

    Log.Info(GSTown.GetName(this.id) + ": " + cargo_cat_text, Log.LVL_SUB_DECISIONS);

    return cargo_cat;
}

/* Randomize number of cargos per category specified by range and return cargo table. */
function RandomizeRange(lower, upper, near_cargos, near_cargo_probability)
{
    local cargo_cat_text = "";
    local cargo_cat = array(::CargoCat.len());
    foreach (cat_idx, cat in ::CargoCat)
    {
        cargo_cat_text += cat_idx + ": [";

        if (::CargoCatList[cat_idx] == CatLabels.PUBLIC_SERVICES || ::CargoCatList[cat_idx] == CatLabels.CATEGORY_I) {
            cargo_cat[cat_idx] = cat;

            foreach (cargo in cat) {
                cargo_cat_text += GSCargo.GetCargoLabel(cargo) + " ";
            }
        } else {
            local cargo_list = clone cat;
            local near_cargo_list = clone near_cargos[cat_idx];
            cargo_cat[cat_idx] = [];
            for (local i = 0; i < upper && cargo_list.len() != 0; i++) {
                if (cargo_cat[cat_idx].len() >= lower && GSBase.Chance(1, 2)) // 50% chance to
                    break;

                if (near_cargo_list.len() && GSBase.Chance(near_cargo_probability, 100)) { // Use near cargo
                    local index = GSBase.RandRange(near_cargo_list.len());
                    cargo_cat[cat_idx].append(near_cargo_list[index]);

                    // Find and remove cargo index from the other array
                    foreach (idx, cargo in cargo_list) {
                        if (cargo == near_cargo_list[index]) {
                            cargo_list.remove(idx);
                            break;
                        }
                    }

                    cargo_cat_text += GSCargo.GetCargoLabel(near_cargo_list[index]) + "(NEAR) ";
                    near_cargo_list.remove(index);
                }
                else { // Use any cargo
                    local index = GSBase.RandRange(cargo_list.len());
                    cargo_cat[cat_idx].append(cargo_list[index]);

                    // Find and remove cargo index from the other array
                    foreach (idx, cargo in near_cargo_list) {
                        if (cargo == cargo_list[index]) {
                            near_cargo_list.remove(idx);
                            break;
                        }
                    }

                    cargo_cat_text += GSCargo.GetCargoLabel(cargo_list[index]) + "(RAND) ";
                    cargo_list.remove(index);
                }
            }
        }

        cargo_cat_text += "] ";
    }

    Log.Info(GSTown.GetName(this.id) + ": " + cargo_cat_text, Log.LVL_SUB_DECISIONS);

    return cargo_cat;
}

function RandomizePyramid(ascending, near_cargos, near_cargo_probability)
{
    local cargo_cat_text = "";
    local cargo_cat = array(::CargoCat.len());
    local number = ascending ? 1 : ::CargoCat.len();
    foreach (cat_idx, cat in ::CargoCat)
    {
        cargo_cat_text += cat_idx + ": [";

        if (::CargoCatList[cat_idx] == CatLabels.PUBLIC_SERVICES || ::CargoCatList[cat_idx] == CatLabels.CATEGORY_I) {
            cargo_cat[cat_idx] = cat;

            foreach (cargo in cat) {
                cargo_cat_text += GSCargo.GetCargoLabel(cargo) + " ";
            }
        } else {
            local cargo_list = clone cat;
            local near_cargo_list = clone near_cargos[cat_idx];
            cargo_cat[cat_idx] = [];
            for (local i = 0; i < number && cargo_list.len() != 0; i++) {
                if (near_cargo_list.len() && GSBase.Chance(near_cargo_probability, 100)) { // Use near cargo
                    local index = GSBase.RandRange(near_cargo_list.len());
                    cargo_cat[cat_idx].append(near_cargo_list[index]);

                    // Find and remove cargo index from the other array
                    foreach (idx, cargo in cargo_list) {
                        if (cargo == near_cargo_list[index]) {
                            cargo_list.remove(idx);
                            break;
                        }
                    }

                    cargo_cat_text += GSCargo.GetCargoLabel(near_cargo_list[index]) + "(NEAR) ";
                    near_cargo_list.remove(index);
                }
                else { // Use any cargo
                    local index = GSBase.RandRange(cargo_list.len());
                    cargo_cat[cat_idx].append(cargo_list[index]);

                    // Find and remove cargo index from the other array
                    foreach (idx, cargo in near_cargo_list) {
                        if (cargo == cargo_list[index]) {
                            near_cargo_list.remove(idx);
                            break;
                        }
                    }

                    cargo_cat_text += GSCargo.GetCargoLabel(cargo_list[index]) + "(RAND) ";
                    cargo_list.remove(index);
                }
            }
        }
        ascending ? number++ : number--;

        cargo_cat_text += "] ";
    }

    Log.Info(GSTown.GetName(this.id) + ": " + cargo_cat_text, Log.LVL_SUB_DECISIONS);

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
            hash = hash | (1 << cargo);
        }
    }

    return hash;
}

/* Create cargo table from cargo hash */
function GetCargoTable(hash)
{
    local cargo_cat = array(::CargoCatNum);

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

/* Checks if one of the industry types that produce this cargo is a raw industry */
function IsRawCargo(cargo)
{
    local industry_type_list= GSIndustryTypeList();
    industry_type_list.Valuate(GSIndustryType.IsRawIndustry);
    industry_type_list.KeepValue(1);

    foreach (industry_type, _ in industry_type_list) {
        local cargo_list = GSIndustryType.GetProducedCargo(industry_type);
        foreach (accepted, _ in cargo_list) {
            if (accepted == cargo)
                return 1;
        }
    }

    return 0;
}

function CreateDefaultCargoCat()
{
    ::CargoLimiter <- [0,2];
    ::CargoCat <- [[0,2]];
    ::CargoCatList <- [CatLabels.CATEGORY_I];
    ::CargoMinPopDemand <- [0];
    ::CargoPermille <- [60];
    ::CargoDecay <- [0.4];

    local cargo_list = GSCargoList();
    cargo_list.RemoveItem(0); // PASS
    cargo_list.RemoveItem(2); // MAIL
    cargo_list.Valuate(IsRawCargo);

    // RAW CARGOS
    local raw_list = GSList();
    raw_list.AddList(cargo_list);
    raw_list.KeepValue(1);

    Log.Info("Raw industries: " + raw_list.Count(), Log.LVL_INFO);
    if (raw_list.Count() > 10) {
        ::CargoCat.append([]);
        ::CargoCat.append([]);

        ::CargoCatList.append(CatLabels.CATEGORY_II);
        ::CargoCatList.append(CatLabels.CATEGORY_III);
        ::CargoMinPopDemand.append(500);
        ::CargoMinPopDemand.append(1000);
        ::CargoPermille.append(25);
        ::CargoPermille.append(25);
        ::CargoDecay.append(0.2);
        ::CargoDecay.append(0.2);

        local cargo = raw_list.Begin();
        local index = 0;
        while (!raw_list.IsEnd()) {
            ::CargoCat[1 + Modulo(index, 2)].append(cargo);
            cargo = raw_list.Next();
            ++index;
        }
    }
    else {
        ::CargoCat.append([]);
        ::CargoCatList.append(CatLabels.CATEGORY_II);
        ::CargoMinPopDemand.append(1000);
        ::CargoPermille.append(45);
        ::CargoDecay.append(0.2);

        foreach (cargo, _ in raw_list) {
            ::CargoCat[1].append(cargo);
        }
    }

    // PROCESSED CARGOS
    local processed_list = GSList();
    processed_list.AddList(cargo_list);
    processed_list.KeepValue(0);

    if (processed_list.Count() > 10) {
        ::CargoCat.append([]);
        ::CargoCat.append([]);
        if (::CargoCatList.top() == CatLabels.CATEGORY_III) {
            ::CargoCatList.append(CatLabels.CATEGORY_IV);
            ::CargoCatList.append(CatLabels.CATEGORY_V);
        }
        else {
            ::CargoCatList.append(CatLabels.CATEGORY_III);
            ::CargoCatList.append(CatLabels.CATEGORY_IV);
        }
        ::CargoMinPopDemand.append(4000);
        ::CargoMinPopDemand.append(8000);
        ::CargoPermille.append(15);
        ::CargoPermille.append(15);
        ::CargoDecay.append(0.1);
        ::CargoDecay.append(0.1);

        local cargo = processed_list.Begin();
        local index = 0;
        local shift = ::CargoCatList.top() == CatLabels.CATEGORY_V ? 3 : 2;
        while (!processed_list.IsEnd()) {
            ::CargoCat[shift + Modulo(index, 2)].append(cargo);
            cargo = processed_list.Next();
            ++index;
        }
    }
    else {
        ::CargoCat.append([]);
        if (::CargoCatList.top() == CatLabels.CATEGORY_III)
            ::CargoCatList.append(CatLabels.CATEGORY_IV);
        else
            ::CargoCatList.append(CatLabels.CATEGORY_III);
        ::CargoMinPopDemand.append(4000);
        ::CargoPermille.append(15);
        ::CargoDecay.append(0.1);

        local index = ::CargoCatList.top() == CatLabels.CATEGORY_IV ? 3 : 2;
        foreach (cargo, _ in processed_list) {
            ::CargoCat[index].append(cargo);
        }
    }

    local cargo_text = "";
    foreach (index, cat in ::CargoCat) {
        cargo_text += "  " + (index + 1) + ": ";
        foreach (cargo in cat) {
            cargo_text += GSCargo.GetCargoLabel(cargo) + ",";
        }
    }
    Log.Info(cargo_text, Log.LVL_SUB_DECISIONS);

    foreach (cat in ::CargoCat) {
        if (!cat.len())
            return false;
    }

    return true;
}

function GetTownsNearbyCargoPerCategory()
{
    local town_industries = GetNearbyIndustriesToTowns();

    local town_cargo_category = {};
    foreach (town, industry_list in town_industries) {
        // Combine all industry accepting cargos to a single mask value
        local near_cargo_list = 0;
        foreach (industry in industry_list) {
            local cargo_list = GSCargoList_IndustryAccepting(industry);
            foreach (cargo_id, _ in cargo_list) {
                near_cargo_list = near_cargo_list | (1 << cargo_id);
            }
        }

        // Add town cargos to the mask value using cargo acceptance of 10 tiles around center point of the town
        local town_location = GSTown.GetLocation(town);
        if (GSMap.IsValidTile(town_location)) {
            local cargo_list = GSCargoList();
            foreach (cargo_id, _ in cargo_list)
            {
                if (!GSCargo.IsValidCargo(cargo_id))
                    continue;

                if (GSTile.GetCargoAcceptance(town_location, cargo_id, 1, 1, 10) >= 8) { // Values below 8 mean no acceptance; the more the better.
                    near_cargo_list = near_cargo_list | (1 << cargo_id);
                }
            }
        }

        // Compare the mask with cargo categories
        town_cargo_category[town] <- [];
        foreach (cat_idx, cat in ::CargoCat)
        {
            town_cargo_category[town].append([]);
            foreach (cargo in cat)
            {
                if (near_cargo_list & (1 << cargo))
                    town_cargo_category[town][cat_idx].append(cargo)
            }
        }
    }

    // Print results
    DebugNearTownCargos(town_cargo_category);

    return town_cargo_category;
}