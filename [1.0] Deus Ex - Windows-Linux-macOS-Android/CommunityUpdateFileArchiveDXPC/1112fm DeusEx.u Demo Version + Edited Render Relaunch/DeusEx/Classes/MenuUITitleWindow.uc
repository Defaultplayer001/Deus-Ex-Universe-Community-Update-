//=============================================================================
// MenuUITitleWindow
//=============================================================================

class MenuUITitleWindow extends Window;

var DeusExPlayer player;

var Window winIcon;

var int	titleHeight;
var int minTitleWidth;
var int titleLeftMargin;
var int titleRightMargin;
var int maxTextWidth;
var Texture textureAppIcon;
var Font fontTitle;
var String titleText;

var Color colTitle;
var Color colTitleText;
var Color colBubble;

var Texture titleTexture_Left;
var Texture titleTexture_Center;
var Texture titleTexture_Right;
var Texture titleTexture_LeftBottom;

var Texture titleBubble_Left;
var Texture titleBubble_Center;
var Texture titleBubble_Right;

var int leftWidth;
var int rightWidth;
var int centerWidth;
var int leftBottomWidth;
var int leftBottomHeight;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	CreateIconWindow();
	
	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	StyleChanged();
}

// ----------------------------------------------------------------------
// DrawWindow()
//
// The title is drawn as several pieces.
// 1.  Left piece
// 2.  Left bottom piece
// 3.  Middle (tiling)
// 4.  Right
// 5.  Icon (draws itself)
// 6.  Title text (draws itself)
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	// Draw the title Background textures
	gc.SetStyle(DSTY_Masked);
	gc.SetTileColor(colTitle);

	// Left
	gc.DrawTexture(0, 0, leftWidth, titleHeight, 0, 0, titleTexture_Left);

	// Left bottom
	gc.DrawTexture(0, titleHeight - 1, leftBottomWidth, leftBottomHeight, 0, 0, titleTexture_LeftBottom);

	// Center
	gc.DrawPattern(
		leftWidth, 0, 
		width - leftWidth - rightWidth, titleHeight,
		0, 0,
		titleTexture_Center);

	// Right
	gc.DrawTexture(width - rightWidth, 0, rightWidth, titleHeight, 0, 0, titleTexture_Right);

	// Now draw the Bubble textures
	gc.SetStyle(DSTY_Masked);
	gc.SetTileColor(colBubble);

	// Left
	gc.DrawTexture(0, 0, leftWidth, titleHeight, 0, 0, titleBubble_Left);

	// Center
	gc.DrawPattern(
		leftWidth, 0, 
		width - leftWidth - rightWidth, titleHeight,
		0, 0,
		titleBubble_Center);

	// Right
	gc.DrawTexture(width - rightWidth, 0, rightWidth, titleHeight, 0, 0, titleBubble_Right);

	// Draw the text!
	gc.SetFont(fontTitle);
	gc.SetTextColor(colTitleText);
	gc.SetHorizontalAlignment(HALIGN_Left);
	gc.SetVerticalAlignment(VALIGN_Center);

	gc.DrawText(titleLeftMargin, 0, width - titleLeftMargin, titleHeight, titleText);

	Super.DrawWindow(gc);
}

// ----------------------------------------------------------------------
// ParentRequestedPreferredSize()
// ----------------------------------------------------------------------

event ParentRequestedPreferredSize(bool bWidthSpecified, out float preferredWidth,
                                   bool bHeightSpecified, out float preferredHeight)
{
	local GC gc;
	local float textWidth, textHeight;

	gc = GetGC();

	gc.SetFont(fontTitle);
	gc.GetTextExtent(maxTextWidth, textWidth, textHeight, titleText);

	preferredWidth  = Max(minTitleWidth, titleLeftMargin + textWidth + titleRightMargin);
	preferredHeight = titleHeight + leftBottomHeight;

	ReleaseGC(gc);
}

// ----------------------------------------------------------------------
// CreateIconWindow()
// ----------------------------------------------------------------------

function CreateIconWindow()
{
	winIcon = NewChild(Class'Window');
	winIcon.SetPos(12, 3);
	winIcon.SetSize(16, 16);
	winIcon.SetBackground(textureAppIcon);
}

// ----------------------------------------------------------------------
// SetTitle()
// ----------------------------------------------------------------------

function SetTitle(string newTitle)
{
	titleText = newTitle;

	AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// GetOffsetWidths()
// ----------------------------------------------------------------------

function GetOffsetWidths(out int titleOffsetX, out int titleOffsetY)
{
	titleOffsetX = leftBottomWidth;
	titleOffsetY = titleHeight;
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	// Title colors
	colTitle     = theme.GetColorFromName('MenuColor_ButtonFace');
	colTitleText = theme.GetColorFromName('MenuColor_TitleText');
	colBubble    = theme.GetColorFromName('MenuColor_TitleBackground');
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     titleHeight=23
     minTitleWidth=200
     titleLeftMargin=31
     titleRightMargin=45
     maxTextWidth=400
     textureAppIcon=Texture'DeusExUI.UserInterface.MenuIcon_DeusEx'
     fontTitle=Font'DeusExUI.FontMenuTitle'
     colTitle=(R=255,G=255,B=255)
     colTitleText=(R=255,G=255,B=255)
     colBubble=(R=255,G=255,B=255)
     titleTexture_Left=Texture'DeusExUI.UserInterface.MenuTitleBar_Left'
     titleTexture_Center=Texture'DeusExUI.UserInterface.MenuTitleBar_Center'
     titleTexture_Right=Texture'DeusExUI.UserInterface.MenuTitleBar_Right'
     titleTexture_LeftBottom=Texture'DeusExUI.UserInterface.MenuTitleBar_LeftBottom'
     titleBubble_Left=Texture'DeusExUI.UserInterface.MenuTitleBubble_Left'
     titleBubble_Center=Texture'DeusExUI.UserInterface.MenuTitleBubble_Center'
     titleBubble_Right=Texture'DeusExUI.UserInterface.MenuTitleBubble_Right'
     leftWidth=87
     rightWidth=100
     CenterWidth=8
     leftBottomWidth=10
     leftBottomHeight=53
}
