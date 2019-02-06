//=============================================================================
// MenuScreenRGB
//=============================================================================

class MenuScreenRGB expands MenuUIScreenWindow;

Enum EColorThemeTypes
{
	CTT_Menu,
	CTT_HUD
};

var ColorTheme currentTheme;
var Name       currentColorName;
var Bool       bInitializing;

var EColorThemeTypes themeMode;

var MenuUITabButtonWindow    btnTabHUD;
var MenuUITabButtonWindow    btnTabMenus;

var MenuUIActionButtonWindow btnActionRed;
var MenuUIActionButtonWindow btnActionGreen;
var MenuUIActionButtonWindow btnActionBlue;

var MenuUIRGBSliderButtonWindow btnSliderRed;
var MenuUIRGBSliderButtonWindow btnSliderGreen;
var MenuUIRGBSliderButtonWindow btnSliderBlue;
var MenuUIListWindow		    lstColors;
var MenuUILabelWindow           txtTheme;

var MenuUICheckboxWindow chkMenuTranslucent;
var MenuUICheckboxWindow chkHUDBackgroundTranslucent;
var MenuUICheckboxWindow chkHUDBordersTranslucent;

// Example windows
var MenuScreenRGB_MenuExample winMenuExample;
var MenuScreenRGB_HUDExample  winHUDExample;

var localized string HUDBackgroundTranslucentLabel;
var localized string HUDBordersTranclucentLabel;
var localized string MenusBackgroundTranslucentLabel;
var localized string RedLabel;
var localized string GreenLabel;
var localized string BlueLabel;
var localized string TabHUDLabel;
var localized string TabMenusLabel;
var localized string ThemeLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	bInitializing = True;

	Super.InitWindow();

	SetThemeMode(CTT_Menu);
	SetMouseFocusMode(MFOCUS_Click);

	bInitializing = False;
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	CreateTabs();
	CreateCheckboxes();
	CreateColorsList();

	// Create Action Buttons
	btnActionRed   = CreateColorActionButton(41, RedLabel);
	btnActionGreen = CreateColorActionButton(68, GreenLabel);
	btnActionBlue  = CreateColorActionButton(95, BlueLabel);

	// Create Sliders
	btnSliderRed   = CreateColorSlider(41);
	btnSliderGreen = CreateColorSlider(68);
	btnSliderBlue  = CreateColorSlider(95);

	// Theme Label
	txtTheme       = CreateMenuLabel(336, 12, ThemeLabel, winClient);

	// Create Examples
	CreateHUDExample();
	CreateMenuExample();
}

// ----------------------------------------------------------------------
// CreateTabs()
// ----------------------------------------------------------------------

function CreateTabs()
{
	btnTabHUD   = CreateMenuUITab(19, 10, TabHUDLabel);
	btnTabMenus = CreateMenuUITab(90, 10, TabMenusLabel);
}

// ----------------------------------------------------------------------
// CreateColorActionButton()
// ----------------------------------------------------------------------

function MenuUIActionButtonwindow CreateColorActionButton(int posY, string textLabel)
{
	local MenuUIActionButtonwindow btnAction;

	btnAction = MenuUIActionButtonWindow(winClient.NewChild(Class'MenuUIActionButtonWindow'));
	btnAction.SetPos(19, posY + 1);
	btnAction.SetSize(54, 19);
	btnAction.SetText(textLabel);
	btnAction.EnableRightMouseClick();
	btnAction.SetCenterText(True);

	return btnAction;
}

// ----------------------------------------------------------------------
// CreateColorSlider()
// ----------------------------------------------------------------------

function MenuUIRGBSliderButtonWindow CreateColorSlider(int posY)
{
	local MenuUIRGBSliderButtonWindow btnSlider;

	btnSlider = MenuUIRGBSliderButtonWindow(winClient.NewChild(Class'MenuUIRGBSliderButtonWindow'));
	btnSlider.SetPos(77, posY);
	btnSlider.SetTicks(256, 0, 255);

	SetEnumerators(btnSlider);

	return btnSlider;
}

// ----------------------------------------------------------------------
// CreateHUDExample()
// ----------------------------------------------------------------------

function CreateHUDExample()
{
	winHUDExample = MenuScreenRGB_HUDExample(winClient.NewChild(Class'MenuScreenRGB_HUDExample'));
	winHUDExample.SetPos(131, 240);
}

// ----------------------------------------------------------------------
// CreateMenuExample()
// ----------------------------------------------------------------------

function CreateMenuExample()
{
	winMenuExample = MenuScreenRGB_MenuExample(winClient.NewChild(Class'MenuScreenRGB_MenuExample', False));
	winMenuExample.SetPos(85, 226);
}

// ----------------------------------------------------------------------
// SetThemeMode()
// ----------------------------------------------------------------------

function SetThemeMode(EColorThemeTypes newThemeMode)
{
	themeMode = newThemeMode;
	
	if (themeMode == CTT_Menu)
	{
		SetTheme(player.ThemeManager.GetCurrentMenuColorTheme());
	}
	else
	{
		SetTheme(player.ThemeManager.GetCurrentHUDColorTheme());
	}

	// Update tabs appopriately
	btnTabHUD.EnableWindow(themeMode  == CTT_Menu);
	btnTabMenus.EnableWindow(themeMode == CTT_HUD);

	// Show and Hide the appropriate example
	winMenuExample.Show(themeMode == CTT_Menu);
	winHUDExample.Show(themeMode == CTT_HUD);
}

// ----------------------------------------------------------------------
// SetTheme()
// ----------------------------------------------------------------------

function SetTheme(ColorTheme newTheme)
{
	currentTheme = newTheme;

	if (currentTheme != None)
	{
		UpdateThemeText();
		PopulateColorsList();
		UpdateCheckBoxes();
		ChangeStyle();
	}
}

// ----------------------------------------------------------------------
// SetThemeByName()
// ----------------------------------------------------------------------

function SetThemeByName(String themeStringName)
{
	local ColorTheme theme;

	if (themeMode == CTT_Menu)
		theme = player.ThemeManager.SetMenuThemeByName(themeStringName);
	else
		theme = player.ThemeManager.SetHUDThemeByName(themeStringName);
	
	SetTheme(theme);
}

// ----------------------------------------------------------------------
// UpdateThemeText()
// ----------------------------------------------------------------------

function UpdateThemeText()
{
	if (currentTheme != None)
		txtTheme.SetText(ThemeLabel @ currentTheme.GetThemeName());
	else
		txtTheme.SetText("");
}

// ----------------------------------------------------------------------
// SetEnumerators()
// ----------------------------------------------------------------------

function SetEnumerators(MenuUIRGBSliderButtonWindow btnSlider)
{
	local int enumIndex;

	for(enumIndex=0;enumIndex<256;enumIndex++)
		btnSlider.winSlider.SetEnumeration(enumIndex, enumIndex);
}

// ----------------------------------------------------------------------
// CreateColorsList()
// ----------------------------------------------------------------------

function CreateColorsList()
{
	local MenuUIScrollAreaWindow winScroll;

	winScroll = CreateScrollAreaWindow(winClient);
	winScroll.SetSize(248, 171);
	winScroll.SetPos(335, 37);	

	lstColors = MenuUIListWindow(winScroll.clipWindow.NewChild(Class'MenuUIListWindow'));

	lstColors.SetNumColumns(2);
	lstColors.SetColumnWidth(0, 181);
	lstColors.SetColumnType(0, COLTYPE_String);
	lstColors.SetColumnWidth(1, 67);
	lstColors.SetColumnType(1, COLTYPE_String);
}

// ----------------------------------------------------------------------
// CreateCheckboxes()
// ----------------------------------------------------------------------

function CreateCheckboxes()
{
	chkMenuTranslucent = MenuUICheckboxWindow(winClient.NewChild(Class'MenuUICheckboxWindow'));

	chkMenuTranslucent.SetPos(77, 136);
	chkMenuTranslucent.SetText(MenusBackgroundTranslucentLabel);

	chkHUDBackgroundTranslucent = MenuUICheckboxWindow(winClient.NewChild(Class'MenuUICheckboxWindow'));

	chkHUDBackgroundTranslucent.SetPos(77, 136);
	chkHUDBackgroundTranslucent.SetText(HUDBackgroundTranslucentLabel);

	chkHUDBordersTranslucent = MenuUICheckboxWindow(winClient.NewChild(Class'MenuUICheckboxWindow'));

	chkHUDBordersTranslucent.SetPos(77, 157);
	chkHUDBordersTranslucent.SetText(HUDBordersTranclucentLabel);
}

// ----------------------------------------------------------------------
// UpdateCheckBoxes()
// ----------------------------------------------------------------------

function UpdateCheckBoxes()
{
	chkHUDBackgroundTranslucent.Show(themeMode == CTT_HUD);
	chkHUDBordersTranslucent.Show(themeMode == CTT_HUD);
	chkMenuTranslucent.Show(themeMode == CTT_Menu);

	if (themeMode == CTT_HUD)
	{
		chkHUDBackgroundTranslucent.SetToggle(player.GetHUDBackgroundTranslucency());
		chkHUDBordersTranslucent.SetToggle(player.GetHUDBorderTranslucency());
	}
	else
	{
		chkMenuTranslucent.SetToggle(player.GetMenuTranslucency());
	}
}

// ----------------------------------------------------------------------
// SaveSettings()
// ----------------------------------------------------------------------

function SaveSettings()
{
}

// ----------------------------------------------------------------------
// CancelScreen()
// ----------------------------------------------------------------------

function CancelScreen()
{
	Super.CancelScreen();
}

// ----------------------------------------------------------------------
// PopulateColorsList()
// ----------------------------------------------------------------------

function PopulateColorsList()
{
	local Name colorName;
	local Color color;
	local int colorIndex;
	
	lstColors.DeleteAllRows();

	if (currentTheme != None)
	{	
		for(colorIndex=0; colorIndex<currentTheme.GetColorCount(); colorIndex++)
		{
			lstColors.AddRow(currentTheme.GetColorName(colorIndex) $ ";" $ 
				   BuildRGBString(currentTheme.GetColor(colorIndex)));
		}

		// Select the first item in the list
		if (lstColors.GetNumRows() > 0)
			lstColors.SelectRow(lstColors.IndexToRowId(0));
	}
}

// ----------------------------------------------------------------------
// BuildRGBString()
// ----------------------------------------------------------------------

function String BuildRGBString(Color color)
{
	return color.r $ "," $ color.g $ "," $ color.b;
}

// ----------------------------------------------------------------------
// ProcessAction()
//
// Meant to be called in derived class
// ----------------------------------------------------------------------

function ProcessAction(String actionKey)
{
	local MenuScreenThemesLoad menuLoad;

	if (actionKey == "SAVE")
	{
		menuLoad = MenuScreenThemesLoad(root.PushWindow(Class'MenuScreenThemesSave', True));
		menuLoad.SetRGBWindow(Self);
		if (themeMode == CTT_Menu)
			menuLoad.SetThemeType(0);
		else
			menuLoad.SetThemeType(1);
	}
	else if (actionKey == "LOAD")
	{
		menuLoad = MenuScreenThemesLoad(root.PushWindow(Class'MenuScreenThemesLoad', True));
		menuLoad.SetRGBWindow(Self);
		if (themeMode == CTT_Menu)
			menuLoad.SetThemeType(0);
		else
			menuLoad.SetThemeType(1);
	}
	else if (actionKey == "CLOSE")
	{
		root.PopWindow();
	}
	else
	{
		Super.ProcessAction(actionKey);
	}
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	bHandled = True;

	Super.ButtonActivated(buttonPressed);

	switch( buttonPressed )
	{
		case btnTabHUD:
			SetThemeMode(CTT_HUD);
			break;

		case btnTabMenus:
			SetThemeMode(CTT_Menu);
			break;

		case btnActionRed:
			CycleNextColor(btnSliderRed);
			break;

		case btnActionGreen:
			CycleNextColor(btnSliderGreen);
			break;

		case btnActionBlue:
			CycleNextColor(btnSliderBlue);
			break;

		default:
			bHandled = False;
			break;
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivatedRight( Window buttonPressed )
{
	local bool bHandled;

	bHandled = True;

	Super.ButtonActivated(buttonPressed);

	switch( buttonPressed )
	{
		case btnActionRed:
			CyclePreviousColor(btnSliderRed);
			break;

		case btnActionGreen:
			CyclePreviousColor(btnSliderGreen);
			break;

		case btnActionBlue:
			CyclePreviousColor(btnSliderBlue);
			break;

		default:
			bHandled = False;
			break;
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// ToggleChanged()
//
// Called when the user clicks on the checkbox
// ----------------------------------------------------------------------

event Bool ToggleChanged(window button, bool bToggleValue)
{
	if (button == chkMenuTranslucent)
	{
		player.SetMenuTranslucency(bToggleValue);
	}
	else if (button == chkHUDBackgroundTranslucent)
	{
		player.SetHUDBackgroundTranslucency(bToggleValue);
	}
	else if (button == chkHUDBordersTranslucent)
	{
		player.SetHUDBorderTranslucency(bToggleValue);
	}

	ChangeStyle();
}

// ----------------------------------------------------------------------
// CycleNextColor()
// ----------------------------------------------------------------------

function CycleNextColor(MenuUIRGBSliderButtonWindow btnSlider)
{
	local int newValue;

	if (btnSlider != None)
	{
		// Get the current slider value and attempt to increment.
		// If at the max go back to the beginning

		newValue = btnSlider.winSlider.GetTickPosition() + 1;

		if (newValue == btnSlider.winSlider.GetNumTicks())
			newValue = 0;

		btnSlider.winSlider.SetTickPosition(newValue);
	}
}

// ----------------------------------------------------------------------
// CyclePreviousColor()
// ----------------------------------------------------------------------

function CyclePreviousColor(MenuUIRGBSliderButtonWindow btnSlider)
{
	local int newValue;

	if (btnSlider != None)
	{
		// Get the current slider value and attempt to increment.
		// If at the max go back to the beginning

		newValue = btnSlider.winSlider.GetTickPosition() - 1;

		if (newValue < 0)
			newValue = btnSlider.winSlider.GetNumTicks() - 1;

		btnSlider.winSlider.SetTickPosition(newValue);
	}
}

// ----------------------------------------------------------------------
// ScalePositionChanged() 
// ----------------------------------------------------------------------

event bool ScalePositionChanged(Window scale, int newTickPosition,
                                float newValue, bool bFinal)
{
	local Color newColor;
	local int   rowIndex;
	local Name  colorName;
	local String colorStringName;
	local int   rowId;

	// Ignore if we're initializing
	if (bInitializing)
		return True;

	if (currentTheme != None)
	{
		// Get the current value
		newColor.r = btnSliderRed.winSlider.GetTickPosition();
		newColor.g = btnSliderGreen.winSlider.GetTickPosition();
		newColor.b = btnSliderBlue.winSlider.GetTickPosition();

		// If more than one row is selected, apply changes to all
		// selected rows (woo hoo!)
		if (lstColors.GetNumSelectedRows() == 1)
		{
			if (currentColorName != '')
			{
				// Set it in the theme
				currentTheme.SetColorFromName(currentColorName, newColor);

				// Update Listbox
				lstColors.SetField(lstColors.GetSelectedRow(), 1, BuildRGBString(newColor));

				// Apply it globally!
				ChangeStyle();
			}
		}
		else if (lstColors.GetNumSelectedRows() > 1)
		{
			for (rowIndex=0; rowIndex<lstColors.GetNumRows(); rowIndex++)
			{
				rowId = lstColors.IndexToRowId(rowIndex);
				if (lstColors.IsRowSelected(rowId))
				{
					// Find the color!
					colorStringName = lstColors.GetField(rowId, 0);

					// Update Listbox
					lstColors.SetField(rowId, 1, BuildRGBString(newColor));

					// Convert into a name
					colorName = StringToName(colorStringName);

					// Set it in the theme
					currentTheme.SetColorFromName(colorName, newColor);
				}
			}

			// Apply it globally!
			ChangeStyle();
		}
	}
}

// ----------------------------------------------------------------------
// TextChanged() 
// ----------------------------------------------------------------------

event bool TextChanged(window edit, bool bModified)
{
	local int value;

	value = Clamp(int(TextWindow(edit).GetText()), 0, 255);

	if (edit.GetParent() == btnSliderRed)
		btnSliderRed.winSlider.SetTickPosition(value);
	else if (edit.GetParent() == btnSliderGreen)
		btnSliderGreen.winSlider.SetTickPosition(value);
	else if (edit.GetParent() == btnSliderBlue)
		btnSliderBlue.winSlider.SetTickPosition(value);
		
	return false;
}

// ----------------------------------------------------------------------
// ListSelectionChanged() 
// ----------------------------------------------------------------------

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
	local String colorStringName;
	local Name   colorName;
	local Color  color;

	// Do this only if a single row is selected
	if (lstColors.GetNumSelectedRows() == 1)
	{
		// Find the color!
		colorStringName = lstColors.GetField(lstColors.GetSelectedRow(), 0);

		// Store the name away
		currentColorName = StringToName(colorStringName);

		// Get the color
		color = currentTheme.GetColorFromName(currentColorName);

		// Apply to sliders
		btnSliderRed.winSlider.SetTickPosition(color.r);
		btnSliderGreen.winSlider.SetTickPosition(color.g);
		btnSliderBlue.winSlider.SetTickPosition(color.b);
	}
	return True;
}

// ----------------------------------------------------------------------
// ResetToDefaults()
//
// Meant to be called in derived class
// ----------------------------------------------------------------------

function ResetToDefaults()
{
	local ColorTheme theme;

	if (currentTheme != None)
	{
		currentTheme.ResetThemeToDefault();
		PopulateColorsList();
		ChangeStyle();
		lstColors.SelectRow(lstColors.IndexToRowId(0));
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HUDBackgroundTranslucentLabel="HUD Back|&grounds Translucent"
     HUDBordersTranclucentLabel="HUD Bor|&ders Translucent"
     MenusBackgroundTranslucentLabel="Menu Back|&grounds Translucent"
     RedLabel="R|&ed"
     GreenLabel="|&Green"
     BlueLabel="|&Blue"
     TabHUDLabel="|&HUD"
     TabMenusLabel="|&Menus"
     ThemeLabel="Theme:"
     choiceVerticalGap=27
     choiceStartX=19
     choiceStartY=20
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Other,Text="|&Close",Key="CLOSE")
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_Other,Text="|&Load",Key="LOAD")
     actionButtons(2)=(Align=HALIGN_Right,Action=AB_Other,Text="|&Save",Key="SAVE")
     actionButtons(3)=(Action=AB_Reset)
     Title="Color Selection"
     ClientWidth=603
     ClientHeight=425
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuRGBBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuRGBBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuRGBBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuRGBBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.MenuRGBBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.MenuRGBBackground_6'
}
