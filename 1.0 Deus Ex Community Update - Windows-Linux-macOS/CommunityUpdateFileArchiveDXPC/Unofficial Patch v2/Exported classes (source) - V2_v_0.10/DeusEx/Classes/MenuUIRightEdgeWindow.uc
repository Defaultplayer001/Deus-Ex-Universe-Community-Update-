//=============================================================================
// MenuUIRightEdgeWindow
//=============================================================================

class MenuUIRightEdgeWindow extends Window;

var DeusExPlayer player;

var Texture	texture_Top;
var Texture	texture_TopLeft;
var Texture	texture_TopRight;
var Texture	texture_Right;
var Texture	texture_Bottom;

var int rightWidth;
var int topLeftWidth;
var int topHeight;
var int bottomRightHeight;
var int topRightHeight;
var int topRightWidth;

var Color colBackground;

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

	// Top left
	gc.DrawTexture(0, 0, topLeftWidth, topHeight, 0, 0, texture_TopLeft);

	// Top Edge 
	gc.DrawPattern(
		topLeftwidth, 0, 
		width - topLeftwidth - topRightWidth, topHeight, 
		0, 0,
		texture_Top);

	// Top Right Corner
	gc.DrawTexture(width - topRightWidth, 0, topRightWidth, topRightHeight, 0, 0, texture_TopRight);

	// Right Edge
	gc.DrawPattern(
		width - rightWidth, topRightHeight, 
		rightWidth, height - topRightHeight - bottomRightHeight,
		0, 0,
		texture_Right);

	// Bottom Right
	gc.DrawTexture(
		width - rightWidth, height - bottomRightHeight, 
		rightWidth, bottomRightHeight,
		0, 0, texture_Bottom);
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
     texture_Top=Texture'DeusExUI.UserInterface.MenuRightBorder_Top'
     texture_TopLeft=Texture'DeusExUI.UserInterface.MenuRightBorder_TopLeft'
     texture_TopRight=Texture'DeusExUI.UserInterface.MenuRightBorder_TopRight'
     texture_Right=Texture'DeusExUI.UserInterface.MenuRightBorder_Right'
     texture_Bottom=Texture'DeusExUI.UserInterface.MenuRightBorder_BottomRight'
     rightWidth=4
     topLeftWidth=2
     topHeight=4
     bottomRightHeight=13
     topRightHeight=6
     topRightWidth=5
     colBackground=(R=255,G=255,B=255)
}
