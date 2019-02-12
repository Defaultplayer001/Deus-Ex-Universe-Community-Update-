//=============================================================================
// MenuUIMessageBoxShadowWindow
//=============================================================================

class MenuUIMessageBoxShadowWindow extends MenuUIShadowWindow;

var Texture texShadows[4];
var int     textureIndex;

// ----------------------------------------------------------------------
// DestroyWindow()
//
// Unload texture memory used by background textures
// ----------------------------------------------------------------------

function DestroyWindow()
{
	local int unloadIndex;

	for(unloadIndex=0; unloadIndex<arrayCount(texShadows); unloadIndex++)
		player.UnloadTexture(texShadows[unloadIndex]);

	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	gc.SetStyle(DSTY_Modulated);
	gc.DrawTexture(0,   0, 256, shadowHeight, 0, 0, texShadows[0 + (textureIndex * 2)]);
	gc.DrawTexture(256, 0, shadowWidth - 256, shadowHeight, 0, 0, texShadows[1 + (textureIndex * 2)]);
}

// ----------------------------------------------------------------------
// SetButtonCount()
// ----------------------------------------------------------------------

function SetButtonCount(int newButtonCount)
{
	if ((newButtonCount >= 1) && (newButtonCount <= 2))
		textureIndex = newButtonCount - 1;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texShadows(0)=Texture'DeusExUI.UserInterface.MenuMessageBoxShadow1_1'
     texShadows(1)=Texture'DeusExUI.UserInterface.MenuMessageBoxShadow1_2'
     texShadows(2)=Texture'DeusExUI.UserInterface.MenuMessageBoxShadow2_1'
     texShadows(3)=Texture'DeusExUI.UserInterface.MenuMessageBoxShadow2_2'
     shadowWidth=316
     shadowHeight=154
     shadowOffsetX=13
     shadowOffsetY=13
}
