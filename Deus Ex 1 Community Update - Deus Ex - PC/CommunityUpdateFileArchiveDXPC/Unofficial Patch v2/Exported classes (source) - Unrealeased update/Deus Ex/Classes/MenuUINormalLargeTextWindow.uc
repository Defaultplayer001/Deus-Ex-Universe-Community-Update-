//=============================================================================
// MenuUINormalLargeTextWindow
//=============================================================================

class MenuUINormalLargeTextWindow extends LargeTextWindow;

var DeusExPlayer player;

var Color colLabel;
var Font  fontLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetFont(fontLabel);
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

	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	// Title colors
	colLabel = theme.GetColorFromName('MenuColor_ListText');

	SetTextColor(colLabel);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colLabel=(R=255,G=255,B=255)
     fontLabel=Font'DeusExUI.FontMenuSmall'
}
