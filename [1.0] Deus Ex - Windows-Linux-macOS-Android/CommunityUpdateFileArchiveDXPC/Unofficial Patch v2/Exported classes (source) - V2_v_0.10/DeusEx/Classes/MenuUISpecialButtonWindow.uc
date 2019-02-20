//=============================================================================
// MenuUISpecialButtonWindow
//=============================================================================

class MenuUISpecialButtonWindow extends ButtonWindow;

var DeusExPlayer player;

var Texture texNormal;
var Texture texFocus;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
	
	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	SetSize(25, 19);

	StyleChanged();
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;
	local Color colButtonFace;

	theme         = player.ThemeManager.GetCurrentMenuColorTheme();
	colButtonFace = theme.GetColorFromName('MenuColor_ButtonFace');

	SetButtonColors(
		colButtonFace, colButtonFace, colButtonFace,
		colButtonFace, colButtonFace, colButtonFace);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
