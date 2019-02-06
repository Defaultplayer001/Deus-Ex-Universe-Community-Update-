//=============================================================================
// MenuScreenOptions
//=============================================================================

class MenuScreenOptions expands MenuUIScreenWindow;

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
     choices(0)=Class'DeusEx.MenuChoice_ObjectNames'
     choices(1)=Class'DeusEx.MenuChoice_WeaponAutoReload'
     choices(2)=Class'DeusEx.MenuChoice_GoreLevel'
     choices(3)=Class'DeusEx.MenuChoice_Subtitles'
     choices(4)=Class'DeusEx.MenuChoice_Crosshairs'
     choices(5)=Class'DeusEx.MenuChoice_HUDAugDisplay'
     choices(6)=Class'DeusEx.MenuChoice_UIBackground'
     choices(7)=Class'DeusEx.MenuChoice_HeadBob'
     choices(8)=Class'DeusEx.MenuChoice_LogTimeoutValue'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
     Title="Options"
     ClientWidth=537
     ClientHeight=406
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuGameOptionsBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuGameOptionsBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuGameOptionsBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuGameOptionsBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.MenuGameOptionsBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.MenuGameOptionsBackground_6'
     helpPosY=354
}
