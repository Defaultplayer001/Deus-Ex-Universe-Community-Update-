//=============================================================================
// PersonaTitleTextWindow
//=============================================================================

class PersonaTitleTextWindow extends TextWindow;

var DeusExPlayer player;
var Font         fontTitle;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetFont(fontTitle);
	SetTextMargins(0, 0);

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	StyleChanged();
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;
	local Color colTitle;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	// Title colors
	colTitle = theme.GetColorFromName('HUDColor_TitleText');

	SetTextColor(colTitle);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     fontTitle=Font'DeusExUI.FontMenuHeaders'
}
