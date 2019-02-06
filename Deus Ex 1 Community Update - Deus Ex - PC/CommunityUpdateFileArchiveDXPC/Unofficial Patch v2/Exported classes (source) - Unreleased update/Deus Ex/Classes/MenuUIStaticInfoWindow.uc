//=============================================================================
// MenuUIStaticInfoWindow
//=============================================================================

class MenuUIStaticInfoWindow extends MenuUIInfoButtonWindow;

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	Super.StyleChanged();

	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	colButtonFace = theme.GetColorFromName('MenuColor_ButtonFace');
	colText[0]    = theme.GetColorFromName('MenuColor_ButtonTextNormal');
	colText[1]    = colText[0];
	colText[2]    = colText[0];
	colText[3]    = colText[0];
}

defaultproperties
{
}
