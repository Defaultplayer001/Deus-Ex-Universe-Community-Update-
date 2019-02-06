//=============================================================================
// MenuScreenControls
//=============================================================================

class MenuScreenControls expands MenuUIScreenWindow;

// ----------------------------------------------------------------------
// SaveSettings()
// ----------------------------------------------------------------------

function SaveSettings()
{
	Super.SaveSettings();
	player.SaveConfig();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     choices(0)=Class'DeusEx.MenuChoice_AlwaysRun'
     choices(1)=Class'DeusEx.MenuChoice_ToggleCrouch'
     choices(2)=Class'DeusEx.MenuChoice_InvertMouse'
     choices(3)=Class'DeusEx.MenuChoice_MouseSensitivity'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
     Title="Controls"
     ClientWidth=537
     ClientHeight=228
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuControlsBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuControlsBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuControlsBackground_3'
     textureRows=1
     helpPosY=174
}
