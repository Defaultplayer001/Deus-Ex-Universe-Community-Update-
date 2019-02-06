//=============================================================================
// PersonaNavButtonWindow
//=============================================================================

class PersonaNavButtonWindow extends PersonaActionButtonWindow;

// ----------------------------------------------------------------------
// StyleChanged()
//
// Different colors for text, we want the DISABLED item to be a bright
// color since it represents the current screen.  
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	bTranslucent  = player.GetHUDBackgroundTranslucency();

	colButtonFace = theme.GetColorFromName('HUDColor_ButtonFace');

	// Normal button color
	colText[0]    = theme.GetColorFromName('HUDColor_ButtonTextNormal');
	
	// Focus, pressed
	colText[1]    = colText[0];
	colText[2]    = theme.GetColorFromName('HUDColor_ButtonTextFocus');

	// Disabled button
	colText[3]    = theme.GetColorFromName('HUDColor_ButtonTextFocus');
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bBaseWidthOnText=True
     bCenterText=True
}
