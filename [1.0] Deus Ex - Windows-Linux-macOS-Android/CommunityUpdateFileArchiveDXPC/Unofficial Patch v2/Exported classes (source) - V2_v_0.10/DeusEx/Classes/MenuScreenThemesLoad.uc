//=============================================================================
// MenuScreenThemesLoad
//=============================================================================

class MenuScreenThemesLoad expands MenuUIScreenWindow;

Enum EColorThemeTypes
{
	CTT_Menu,
	CTT_HUD
};

var MenuUIListWindow			 lstThemes;
var MenuUIScrollAreaWindow		 winScroll;
var MenuScreenRGB				 winRGB;

// Would make this an EColorThemeType, but UnrealScript sucks

var int themeType;

var localized string LoadHelpText;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	CreateThemesList();
	ShowHelp(LoadHelpText);
	EnableButtons();
}

// ----------------------------------------------------------------------
// SetRGBWindow()
// ----------------------------------------------------------------------

function SetRGBWindow(MenuScreenRGB newRGBWindow)
{
	winRGB = newRGBWindow;
}

// ----------------------------------------------------------------------
// SetThemeType()
// ----------------------------------------------------------------------

function SetThemeType(int newThemeType)
{
	themeType = newThemeType;
	PopulateThemesList();
}

// ----------------------------------------------------------------------
// ListSelectionChanged() 
// ----------------------------------------------------------------------

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
	EnableButtons();
	return False;
}

// ----------------------------------------------------------------------
// ListRowActivated()
// ----------------------------------------------------------------------

event bool ListRowActivated(window list, int rowId)
{
	SaveSettings();
}

// ----------------------------------------------------------------------
// ProcessAction()
//
// Meant to be called in derived class
// ----------------------------------------------------------------------

function ProcessAction(String actionKey)
{
	if (actionKey == "LOAD")
	{
		SaveSettings();
	}
}

// ----------------------------------------------------------------------
// SaveSettings()
// ----------------------------------------------------------------------

function SaveSettings()
{
	local ColorTheme theme;
	local String themeName;

	if (lstThemes.GetNumSelectedRows() == 1)
	{
		themeName = lstThemes.GetField(lstThemes.GetSelectedRow(), 0);

		if (winRGB != None)
			winRGB.SetThemeByName(themeName);
	}

	root.PopWindow();
}

// ----------------------------------------------------------------------
// CreateThemesList()
// ----------------------------------------------------------------------

function CreateThemesList()
{
	winScroll = CreateScrollAreaWindow(winClient);

	winScroll.SetPos(11, 22);
	winScroll.SetSize(285, 210);

	lstThemes = MenuUIListWindow(winScroll.clipWindow.NewChild(Class'MenuUIListWindow'));
	lstThemes.EnableMultiSelect(False);
}

// ----------------------------------------------------------------------
// PopulateThemesList()
// ----------------------------------------------------------------------

function PopulateThemesList()
{
	local ColorTheme theme;
	
	// First erase the old list
	lstThemes.DeleteAllRows();

	theme = player.ThemeManager.GetFirstTheme(themeType);
	
	while(theme != None)
	{
		lstThemes.AddRow(theme.GetThemeName());
		theme = player.ThemeManager.GetNextTheme();
	}
}

// ----------------------------------------------------------------------
// EnableButtons()
//
// Checks the state of the list control and updates the pushbuttons
// appropriately
// ----------------------------------------------------------------------

function EnableButtons()
{
	EnableActionButton(AB_Other, (lstThemes.GetNumSelectedRows() > 0), "LOAD");
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     LoadHelpText="Choose the color theme to load"
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_Other,Text="|&Load Theme",Key="LOAD")
     Title="Load Theme"
     ClientWidth=299
     ClientHeight=306
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuThemesBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuThemesBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuThemesBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuThemesBackground_4'
     textureCols=2
     bLeftEdgeActive=False
     bHelpAlwaysOn=True
     helpPosY=252
}
