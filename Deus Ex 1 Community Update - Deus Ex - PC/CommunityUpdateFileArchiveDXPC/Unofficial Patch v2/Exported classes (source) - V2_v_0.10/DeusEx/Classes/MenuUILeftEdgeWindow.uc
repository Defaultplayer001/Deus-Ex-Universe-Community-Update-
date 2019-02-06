//=============================================================================
// MenuUILeftEdgeWindow
//=============================================================================

class MenuUILeftEdgeWindow extends Window;

var DeusExPlayer player;

var Texture texture_Top;
var Texture texture_Center;
var Texture texture_Bottom;

var int topHeight;
var int bottomHeight;
var int edgeWidth;

var Color colBackground;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetWidth(edgeWidth);

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	StyleChanged();
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	// Draw the textures
	gc.SetStyle(DSTY_Masked);

	gc.SetTileColor(colBackground);

	// Top
	gc.DrawTexture(0, 0, edgeWidth, topHeight, 0, 0, texture_Top);

	// Center
	gc.DrawPattern(
		0, topHeight, 
		edgeWidth, height - topHeight - bottomHeight, 
		0, 0,
		texture_Center);

	// Bottom
	gc.DrawTexture(0, height - bottomHeight, edgeWidth, bottomHeight, 0, 0, texture_Bottom);
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	// Title colors
	colBackground = theme.GetColorFromName('MenuColor_ButtonFace');
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texture_Top=Texture'DeusExUI.UserInterface.MenuLeftBorder_Top'
     texture_Center=Texture'DeusExUI.UserInterface.MenuLeftBorder_Center'
     texture_Bottom=Texture'DeusExUI.UserInterface.MenuLeftBorder_Bottom'
     topHeight=2
     bottomHeight=16
     edgeWidth=4
     colBackground=(R=255,G=255,B=255)
}
