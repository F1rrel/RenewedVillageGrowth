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
	GSStoryPage.NewElement(sp_cargo, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_EXPLAIN_1));
	
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

/* Issue an initial warning if game's cargo list doesn't match with settings. */
function StoryEditor::CargoWarningPage()
{
	// Creating the page
	Log.Info("This is called", Log.LVL_DEBUG);
	local sp_warning = this.NewStoryPage(GSCompany.COMPANY_INVALID, GSText(GSText.STR_SB_WARNING_TITLE));
	GSStoryPage.NewElement(sp_warning, GSStoryPage.SPET_TEXT, 0, GSText(GSText.STR_SB_WARNING_1));
	GSStoryPage.Show(sp_warning);
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

	// Create basic cargo informations page
	this.CargoInfoPage();

	// Issue a warning if industry set doesn't match
	if (!::CargoIDList) {
		this.CargoWarningPage();
	}
}

/* Wrapper that creates a new StoryPage but disable date output. */
function StoryEditor::NewStoryPage(company, text)
{
	local value = GSStoryPage.New(company, text);
	if (value != GSStoryPage.STORY_PAGE_INVALID) GSStoryPage.SetDate(value, GSDate.DATE_INVALID);
	return value;
}
