//=============================================================================
// MenuSettings
//=============================================================================

class MenuSettings expands MenuUIMenuWindow;

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ButtonNames(0)="Keyboard/Mouse"
     ButtonNames(1)="Controls"
     ButtonNames(2)="Game Options"
     ButtonNames(3)="Display"
     ButtonNames(4)="Colors"
     ButtonNames(5)="Sound"
     ButtonNames(6)="Previous Menu"
     buttonXPos=7
     buttonWidth=282
     buttonDefaults(0)=(Y=13,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenCustomizeKeys')
     buttonDefaults(1)=(Y=49,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenControls')
     buttonDefaults(2)=(Y=85,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenOptions')
     buttonDefaults(3)=(Y=121,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenDisplay')
     buttonDefaults(4)=(Y=157,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenAdjustColors')
     buttonDefaults(5)=(Y=193,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenSound')
     buttonDefaults(6)=(Y=266,Action=MA_Previous)
     Title="Settings"
     ClientWidth=294
     ClientHeight=308
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuOptionsBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuOptionsBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuOptionsBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuOptionsBackground_4'
     textureCols=2
}
