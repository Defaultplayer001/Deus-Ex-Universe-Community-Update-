//=============================================================================
// MenuMPMain (multiplayer)
//=============================================================================

class MenuMPMain expands MenuUIMenuWindow;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	UpdateButtonStatus();
}

// ----------------------------------------------------------------------
// UpdateButtonStatus()
// ----------------------------------------------------------------------

function UpdateButtonStatus()
{   
   if (player.Level.Netmode != NM_Standalone)
   {
      winButtons[0].SetSensitivity(False);
      winButtons[1].SetSensitivity(False);
   }
   else
   {
      winButtons[4].SetSensitivity(False);
   }
}

// ----------------------------------------------------------------------
// ProcessCustomMenuButton()
// ----------------------------------------------------------------------

function ProcessCustomMenuButton(string key)
{
	switch(key)
	{
		case "DISCONNECT":
			Player.DisconnectPlayer();
			break;
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ButtonNames(0)="Internet Game"
     ButtonNames(1)="LAN Game"
     ButtonNames(2)="Player Setup"
     ButtonNames(3)="Augmentations"
     ButtonNames(4)="Disconnect"
     ButtonNames(5)="Previous Menu"
     buttonXPos=7
     buttonWidth=245
     buttonDefaults(0)=(Y=13,Action=MA_MenuScreen,Invoke=Class'DeusEx.menuscreenjoininternet')
     buttonDefaults(1)=(Y=49,Action=MA_MenuScreen,Invoke=Class'DeusEx.menuscreenjoinlan')
     buttonDefaults(2)=(Y=85,Action=MA_MenuScreen,Invoke=Class'DeusEx.menuscreenplayersetup')
     buttonDefaults(3)=(Y=121,Action=MA_MenuScreen,Invoke=Class'DeusEx.menuscreenaugsetup')
     buttonDefaults(4)=(Y=157,Action=MA_Custom,Key="DISCONNECT")
     buttonDefaults(5)=(Y=215,Action=MA_Previous)
     Title="Multiplayer Main Menu"
     ClientWidth=258
     ClientHeight=257
     verticalOffset=2
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuMultiplayerBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuMultiplayerBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuMultiplayerBackground_3'
     textureCols=2
}
