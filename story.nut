class StoryEditor
{
	constructor() {
	}
}

/* Create a page showing informations about cargo categories. */
function StoryEditor::CargoInfoPage()
{
	// Creation of the page
	local sp_cargo = this.NewStoryPage(GSCompany.COMPANY_INVALID, GSText(GSText.STR_SB_TITLE_1));
	local rand_type = 0; // 0 = NONE, 1 = FIXED, 2 = RANGE
	local rand_1, rand_2;

	switch (::SettingsTable.randomization) {
		case Randomization.FIXED_1:
		case Randomization.FIXED_2:
		case Randomization.FIXED_3:
			rand_1 = ::SettingsTable.randomization - Randomization.FIXED_1 + 1;
			rand_type = 1;
			break;
		case Randomization.FIXED_5:
			rand_1 = 5;
			rand_type = 1;
			break;
		case Randomization.FIXED_7:
			rand_1 = 7;
			rand_type = 1;
			break;

		case Randomization.RANGE_1_2:
			rand_1 = 1;
			rand_2 = 2;
			rand_type = 2;
			break;
		case Randomization.RANGE_1_3:
			rand_1 = 1;
			rand_2 = 3;
			rand_type = 2;
			break;
		case Randomization.RANGE_2_3:
			rand_1 = 2;
			rand_2 = 3;
			rand_type = 2;
			break;
		case Randomization.RANGE_3_5:
			rand_1 = 3;
			rand_2 = 5;
			rand_type = 2;
			break;
		case Randomization.RANGE_3_7:
			rand_1 = 3;
			rand_2 = 7;
			rand_type = 2;
			break;
	}

	switch (rand_type) {
		case 1: // FIXED
			GSStoryPage.NewElement(sp_cargo, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_EXPLAIN_2, GSText(GSText.STR_SB_EXPLAIN_RANDOM_0, rand_1, GSText(GSText.STR_EMPTY))));
			break;
		case 2: // RANGE
			GSStoryPage.NewElement(sp_cargo, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_EXPLAIN_2, GSText(GSText.STR_SB_EXPLAIN_RANDOM_2, rand_1, rand_2)));
			break;
		default:
			GSStoryPage.NewElement(sp_cargo, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_EXPLAIN_1));
	}
	
	// Adding elements per categories
	for (local i = 0; i < ::CargoCatNum; i++) {
		local bit_sum = 0;
		for (local j = 0; j < ::CargoCat[i].len(); j++) {
			bit_sum += 1 << ::CargoCat[i][j];
		}
		GSStoryPage.NewElement(sp_cargo, GSStoryPage.SPET_TEXT, 0,
				       GSText(GSText["STR_SB_CARGOCAT_"+i],
					     GSText(GSText.STR_SB_CARGOCAT_CAT), i+1,
					     GSText(GSText["STR_CARGOCAT_LABEL_"+::CargoCatList[i]]),
					     GSText(GSText.STR_SB_CARGOCAT_POP), ::CargoMinPopDemand[i],
					     GSText(GSText.STR_SB_CARGOCAT_DECAY), (::CargoDecay[i]*100).tointeger(),
					     GSText(GSText.STR_SB_CARGOCAT_CARGOT), bit_sum));
	}
}

/* Create the StoryBook if it still doesn't exist. This function is
 * called only when (re)initializing all data, because the existing
 * storybook is stored by OTTD.
 */
function StoryEditor::CreateStoryBook()
{
	// Remove any eventual previous existent storypage
	local sb_list = GSStoryPageList(0);
	foreach (page, _ in sb_list) GSStoryPage.Remove(page);

	// Issue a warning if industry set doesn't match
	if (!::CargoIDList) {
		this.CargoWarningPage();
	}
	// Create basic cargo informations page (randomization industry does not support cargo info page)
	else if (::SettingsTable.randomization != Randomization.INDUSTRY) {
		this.CargoInfoPage();
	}
}

/* Wrapper that creates a new StoryPage but disable date output. */
function StoryEditor::NewStoryPage(company, text)
{
	local value = GSStoryPage.New(company, text);
	if (value != GSStoryPage.STORY_PAGE_INVALID) GSStoryPage.SetDate(value, GSDate.DATE_INVALID);
	return value;
}
