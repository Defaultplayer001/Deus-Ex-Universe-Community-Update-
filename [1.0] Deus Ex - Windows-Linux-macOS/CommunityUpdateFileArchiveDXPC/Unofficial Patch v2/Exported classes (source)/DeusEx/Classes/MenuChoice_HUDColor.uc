//=============================================================================
// MenuChoice_HUDColor
//=============================================================================

class MenuChoice_HUDColor extends MenuChoice_ThemeColor;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	// Populate the enums!
	PopulateThemes(1);

	currentTheme = player.ThemeManager.GetCurrentHUDColorTheme();
	SetValueFromString(currentTheme.GetThemeName());
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.HUDThemeName = enumText[GetValue()];
}

// ----------------------------------------------------------------------
// CancelSetting()
// ----------------------------------------------------------------------

function CancelSetting()
{
	player.ThemeManager.SetCurrentMenuColorTheme(currentTheme);
	ChangeStyle();
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
	local ColorTheme theme;

	player.HUDThemeName = defaultTheme;
	theme = player.ThemeManager.SetHUDThemeByName(defaultTheme);
	theme.ResetThemeToDefault();

	SetValueFromString(player.HUDThemeName);

	ChangeStyle();
}

// ----------------------------------------------------------------------
// CycleNextValue()
// ----------------------------------------------------------------------

function CycleNextValue()
{
	Super.CycleNextValue();
	player.ThemeManager.SetHUDThemeByName(enumText[GetValue()]);
	ChangeStyle();
}

// ----------------------------------------------------------------------
// CyclePreviousValue()
// ----------------------------------------------------------------------

function CyclePreviousValue()
{
	Super.CyclePreviousValue();
	player.ThemeManager.SetHUDThemeByName(enumText[GetValue()]);
	ChangeStyle();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultTheme="Grey"
     defaultInfoWidth=97
     HelpText="Color scheme used in all the in-game screens."
     actionText="|&HUD Color Scheme"
}
