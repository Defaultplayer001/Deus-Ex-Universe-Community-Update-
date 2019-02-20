//=============================================================================
// MenuUIMenuButtonWindow
//=============================================================================

class MenuUIMenuButtonWindow extends MenuUIBorderButtonWindow;

var Texture buttonLights[4];
var int buttonLightWidth;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Load the menu font from the DXFonts package
	fontButtonText = Font(DynamicLoadObject("DXFonts.MainMenuTrueType", Class'Font'));
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	// Allow the parent to draw the bulk of the button and the text
	Super.DrawWindow(gc);

	// Now draw the pretty light to the left of the button
	gc.DrawTexture(0, 0, buttonLightWidth, buttonHeight, 0, 0, buttonLights[textColorIndex]);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     buttonLights(0)=Texture'DeusExUI.UserInterface.MenuMainLight_Normal'
     buttonLights(1)=Texture'DeusExUI.UserInterface.MenuMainLight_Focus'
     buttonLights(2)=Texture'DeusExUI.UserInterface.MenuMainLight_Focus'
     buttonLights(3)=Texture'DeusExUI.UserInterface.MenuMainLight_Normal'
     buttonLightWidth=7
     bTranslucentText=True
     Left_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.MenuMainButtonNormal_Left',Width=5)
     Left_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.MenuMainButtonPressed_Left',Width=5)
     Right_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.MenuMainButtonNormal_Right',Width=20)
     Right_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.MenuMainButtonPressed_Right',Width=20)
     Center_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.MenuMainButtonNormal_Center',Width=2)
     Center_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.MenuMainButtonPressed_Center',Width=2)
     leftOffset=9
     buttonHeight=27
     minimumButtonWidth=245
     textLeftMargin=-4
     bTranslucent=True
     bCenterText=True
}
