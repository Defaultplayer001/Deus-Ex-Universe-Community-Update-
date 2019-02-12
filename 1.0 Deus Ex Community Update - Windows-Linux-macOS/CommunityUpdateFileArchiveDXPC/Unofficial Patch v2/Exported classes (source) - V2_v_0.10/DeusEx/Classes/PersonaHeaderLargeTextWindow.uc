//=============================================================================
// PersonaHeaderLargeTextWindow
//=============================================================================

class PersonaHeaderLargeTextWindow extends TextWindow;

var DeusExPlayer player;
var Font         fontText;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetFont(fontText);
	SetTextMargins(0, 0);
	SetTextAlignments(HALIGN_Left, VALIGN_Center);

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
	local Color colText;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	// Title colors
	colText = theme.GetColorFromName('HUDColor_HeaderText');

	SetTextColor(colText);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     fontText=Font'DeusExUI.FontMenuHeaders'
}
