//=============================================================================
// MenuUIListHeaderButtonWindow
//=============================================================================

class MenuUIListHeaderButtonWindow extends MenuUIBorderButtonWindow;

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	Super.StyleChanged();

	// Override disabled color
	colText[3] = colText[2];
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     Left_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.MenuListHeaderButtonNormal_Left',Width=5)
     Left_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.MenuListHeaderButtonPressed_Left',Width=5)
     Right_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.MenuListHeaderButtonNormal_Right',Width=13)
     Right_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.MenuListHeaderButtonPressed_Right',Width=13)
     Center_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.MenuListHeaderButtonNormal_Center',Width=2)
     Center_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.MenuListHeaderButtonPressed_Center',Width=2)
     colText(0)=(R=197,G=225,B=247)
     colText(3)=(R=255,G=255,B=255)
     fontButtonText=Font'DeusExUI.FontMenuHeaders'
     buttonHeight=15
     minimumButtonWidth=83
     textLeftMargin=8
}
