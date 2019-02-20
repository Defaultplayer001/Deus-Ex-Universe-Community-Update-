//=============================================================================
// MenuUILabelWindow
//=============================================================================

class MenuUILabelWindow extends TextWindow;

var DeusExPlayer player;

var Color colLabel;
var Font  fontLabel;
var int fontBaseLine;
var int fontAcceleratorLineHeight;

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
	SetTextAlignments(HALIGN_Left, VALIGN_Top);
	SetBaselineData(fontBaseLine, fontAcceleratorLineHeight);

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
     fontLabel=Font'DeusExUI.FontMenuTitle'
     fontBaseLine=1
     fontAcceleratorLineHeight=1
}
