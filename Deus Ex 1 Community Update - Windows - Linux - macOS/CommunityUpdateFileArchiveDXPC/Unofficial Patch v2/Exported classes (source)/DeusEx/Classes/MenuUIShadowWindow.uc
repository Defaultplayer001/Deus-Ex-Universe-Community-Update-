//=============================================================================
// MenuUIShadowWindow
//=============================================================================

class MenuUIShadowWindow extends Window;

var DeusExPlayer player;

var int shadowWidth;
var int shadowHeight;
var int shadowOffsetX;
var int shadowOffsetY;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
	SetSize(shadowWidth, shadowHeight);

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);
}

defaultproperties
{
}
