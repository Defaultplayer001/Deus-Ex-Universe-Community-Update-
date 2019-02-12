//=============================================================================
// MenuUIHelpWindow
//=============================================================================

class MenuUIHelpWindow extends TextWindow;

var DeusExPlayer player;

// Defaults
var int xMargin;
var int yMargin;

var Color colText;
var Font  fontText;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetFont(fontText);
	SetTextMargins(xMargin, yMargin);
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

	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	// Title colors
	colText = theme.GetColorFromName('MenuColor_HelpText');

	SetTextColor(colText);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     xMargin=10
     colText=(R=255,G=255,B=255)
     fontText=Font'DeusExUI.FontMenuSmall'
}
