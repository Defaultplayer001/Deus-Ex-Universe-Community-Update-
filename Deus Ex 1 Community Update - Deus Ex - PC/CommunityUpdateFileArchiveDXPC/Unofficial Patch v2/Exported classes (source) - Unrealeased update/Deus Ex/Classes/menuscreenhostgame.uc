//=============================================================================
// MenuScreenHostGame (multiplayer)
//=============================================================================

class MenuScreenHostGame expands MenuUIScreenWindow;

var() globalconfig string CurrentGameType; //gametype selected (for saving in ui)
var() globalconfig int ServerMode;
var() bool bLanOnly;

var MenuChoice_VictoryType VictoryTypeChoice;
var MenuChoice_VictoryValue VictoryValueChoice;
var MenuChoice_GameType GameTypeChoice;

const MODE_DEDICATED = 0;
const MODE_LISTEN = 1;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
   Super.InitWindow();

   SetChoiceInfo();
}

// ----------------------------------------------------------------------
// ProcessAction()
//
// Meant to be called in derived class
// ----------------------------------------------------------------------

function ProcessAction(String actionKey)
{
	if (actionKey == "BEGINHOST")
   {
      BeginHost();
	}
}

// ----------------------------------------------------------------------
// BeginHost()
// ----------------------------------------------------------------------

function BeginHost()
{
   local string mapname;
   local string gametype;
   local int configservermode;   

   //Save all settings so that they can be read.
   SaveSettings();

   mapname = GetGameType();
   configservermode = int(player.ConsoleCommand("get MenuScreenHostGame ServerMode"));
   gametype = player.ConsoleCommand("get MenuScreenHostGame CurrentGameType");

   if (configservermode == MODE_DEDICATED)   
      player.ConsoleCommand("Relaunch " $mapname$ "?game=" $gametype$ "?-server?log=server.log");
   else
      player.StartListenGame(mapname $ "?game=" $ gametype);
}

// ----------------------------------------------------------------------
// SaveSettings()
// ----------------------------------------------------------------------

function SaveSettings()
{
   local UdpServerUplink TempLink;
   Super.SaveSettings();

   TempLink = Player.Spawn(Class'UdpServerUplink');
   if (TempLink != None)
   {
      TempLink.DoUplink = !bLanOnly;
      TempLink.SaveConfig();
      TempLink.Destroy();
   }
}

// ----------------------------------------------------------------------
// GetGameType()
// ----------------------------------------------------------------------

function string GetGameType()
{
   local DXMapList MapList;
   local string mapname;

   MapList = player.Spawn(class'DXMapList');

   if (MapList == None)
      return "";

   mapname = MapList.Maps[MapList.MapNum];

   MapList.Destroy();

   return mapname;
}

// ----------------------------------------------------------------------
// SetChoiceInfo()
// ----------------------------------------------------------------------

function SetChoiceInfo()
{
   local Window btnChoice;

	btnChoice = winClient.GetTopChild();
	while(btnChoice != None)
	{
		if (btnChoice.IsA('MenuChoice_VictoryType'))
      {
         VictoryTypeChoice = MenuChoice_VictoryType(btnChoice);
         VictoryTypeChoice.hostParent = Self;
      }

		if (btnChoice.IsA('MenuChoice_VictoryValue'))
      {
         VictoryValueChoice = MenuChoice_VictoryValue(btnChoice);
         VictoryValueChoice.hostParent = Self;
      }
      
      if (btnChoice.IsA('MenuChoice_GameType'))
      {
         GameTypeChoice = MenuChoice_GameType(btnChoice);
         GameTypeChoice.hostParent = Self;
         GameTypeChoice.SetValue(GameTypeChoice.CurrentValue);
      }

      btnChoice = btnChoice.GetLowerSibling();
	}
}

// ----------------------------------------------------------------------
// SetCustomizable()
// ----------------------------------------------------------------------

function SetCustomizable(bool bCanCustomize)
{
   local Window btnChoice;
   local int iChoiceIndex;

   btnChoice = winClient.GetTopChild();
   while (btnChoice != None)
   {
      if (btnChoice.IsA('MenuUIChoice'))
      {
         iChoiceIndex = 0;
         for (iChoiceIndex = 4; iChoiceIndex<=8; iChoiceIndex++)
         {
            if (btnChoice.Class == choices[iChoiceIndex])
            {
               MenuUIChoice(btnChoice).btnAction.SetSensitivity(bCanCustomize);
               if (btnChoice.IsA('MenuUIChoiceSlider'))
                  MenuUIChoiceSlider(btnChoice).btnSlider.SetSensitivity(bCanCustomize);
               if (!bCanCustomize)
                  LockButtonSetting(MenuUIChoice(btnChoice));
            }
         }
      }
      btnChoice = btnChoice.GetLowerSibling();
   }
}

// ----------------------------------------------------------------------
// LockButtonSetting()
// ----------------------------------------------------------------------

function LockButtonSetting(MenuUIChoice SetButton)
{
   local String ChoiceConfigSetting;
   local String GameTypeName;
   local String PropertyName;
   local Class<GameInfo> TypeClass;
   local GameInfo CurrentType;
   local String PropertyValue;

   GameTypeName = GameTypeChoice.GameTypes[GameTypeChoice.CurrentValue];
   ChoiceConfigSetting = SetButton.ConfigSetting;
   PropertyName = "";

	if ( (GameTypeName != "") && (ChoiceConfigSetting != "") )
	{
		if ( Caps(Left(ChoiceConfigSetting,Len("DeusExMPGame "))) == Caps("DeusExMPGame ") )
         PropertyName = Right(ChoiceConfigSetting,Len(ChoiceConfigSetting) - Len("DeusExMPGame "));
	}

   if (PropertyName == "")
      return;

   TypeClass = class<GameInfo>( Player.DynamicLoadObject( GameTypeName, class'Class' ) );
   if (TypeClass != None)
      CurrentType = Player.Spawn(TypeClass);
   
   if (CurrentType == None)
      return;

   PropertyValue = CurrentType.GetPropertyText(PropertyName);

   player.ConsoleCommand("set" @ SetButton.ConfigSetting @ PropertyValue);
   SetButton.LoadSetting();

   if (CurrentType.IsA('DeusExMPGame'))
      DeusExMPGame(CurrentType).ResetNonCustomizableOptions();

   CurrentType.Destroy();
}
// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     CurrentGameType="DeusEx.DeathMatchGame"
     ServerMode=1
     choiceVerticalGap=28
     choiceStartY=17
     choices(0)=Class'DeusEx.menuchoice_gametype'
     choices(1)=Class'DeusEx.menuchoice_map'
     choices(2)=Class'DeusEx.menuchoice_maxplayers'
     choices(3)=Class'DeusEx.menuchoice_friendlyfire'
     choices(4)=Class'DeusEx.menuchoice_Startingaugs'
     choices(5)=Class'DeusEx.menuchoice_augbonus'
     choices(6)=Class'DeusEx.menuchoice_skilllevel'
     choices(7)=Class'DeusEx.menuchoice_startingskills'
     choices(8)=Class'DeusEx.menuchoice_skillbonus'
     choices(9)=Class'DeusEx.menuchoice_victorytype'
     choices(10)=Class'DeusEx.menuchoice_victoryvalue'
     choices(11)=Class'DeusEx.menuchoice_cycle'
     choices(12)=Class'DeusEx.menuchoice_servermode'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_Reset)
     actionButtons(2)=(Action=AB_Other,Text="Start Game",Key="BEGINHOST")
     Title="Host Multiplayer Game"
     ClientWidth=461
     ClientHeight=427
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuHostBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuHostBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuHostBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuHostBackground_4'
     textureCols=2
     helpPosY=377
}
