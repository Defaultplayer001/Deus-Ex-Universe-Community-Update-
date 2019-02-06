//=============================================================================
// ShadowWindow
//=============================================================================

class ShadowWindow extends Window;

var Texture texShadows[9];

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	gc.SetStyle(DSTY_Modulated);
	gc.DrawBorders(0, 0, width, height, 0, 0, 0, 0, texShadows);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texShadows(0)=Texture'DeusExUI.UserInterface.WindowShadow_TL'
     texShadows(1)=Texture'DeusExUI.UserInterface.WindowShadow_TR'
     texShadows(2)=Texture'DeusExUI.UserInterface.WindowShadow_BL'
     texShadows(3)=Texture'DeusExUI.UserInterface.WindowShadow_BR'
     texShadows(4)=Texture'DeusExUI.UserInterface.WindowShadow_Left'
     texShadows(5)=Texture'DeusExUI.UserInterface.WindowShadow_Right'
     texShadows(6)=Texture'DeusExUI.UserInterface.WindowShadow_Top'
     texShadows(7)=Texture'DeusExUI.UserInterface.WindowShadow_Bottom'
     texShadows(8)=Texture'DeusExUI.UserInterface.WindowShadow_Center'
}
