//=============================================================================
// HUDActiveItemBase
//=============================================================================

class HUDActiveItemBase extends HUDBaseWindow;

var Color colItemIcon;

var EDrawStyle iconDrawStyle;
var int	iconWidth;
var int iconHeight;

var Texture icon;
var Texture texBackground;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(iconWidth, iconHeight);
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	Super.DrawWindow(gc);

	if (icon != None)
	{
		// Now draw the icon
		gc.SetStyle(iconDrawStyle);
		gc.SetTileColor(colItemIcon);
		gc.DrawTexture(2, 2, 32, 32, 0, 0, icon);
	}

	DrawHotKey(gc);
}

// ----------------------------------------------------------------------
// DrawHotKey()
// ----------------------------------------------------------------------

function DrawHotKey(GC gc)
{
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
	gc.SetStyle(backgroundDrawStyle);
	gc.SetTileColor(colBackground);
	gc.DrawTexture(0, 0, width, height, 0, 0, texBackground);
}

// ----------------------------------------------------------------------
// SetIcon()
// ----------------------------------------------------------------------

function SetIcon(Texture newIcon)
{
	icon = newIcon;
}

// ----------------------------------------------------------------------
// SetIconMasked()
// ----------------------------------------------------------------------

function SetIconMasked(bool bNewMask)
{
	if (bNewMask)
		iconDrawStyle = DSTY_Masked;
	else
		iconDrawStyle = DSTY_Translucent;
}

// ----------------------------------------------------------------------
// SetObject()
//
// Had to write this because SetClientObject() is FINAL in Extension
// ----------------------------------------------------------------------

function SetObject(object newClientObject)
{
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colItemIcon=(R=255,G=255,B=255)
     iconDrawStyle=DSTY_Translucent
     IconWidth=34
     IconHeight=34
     texBackground=Texture'DeusExUI.UserInterface.HUDIconsBackground'
}
