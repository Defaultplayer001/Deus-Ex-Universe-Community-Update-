//=============================================================================
// MenuChoice_Team
//=============================================================================

Class MenuChoice_Team extends MenuUIChoiceEnum
	config;

var globalconfig string  TeamNumber[24]; //Team numbers (matches teamdmgame.uc)
var localized String     TeamNames[24]; //Human readable Team names.

//Portrait variables
var ButtonWindow btnPortrait;
var globalconfig Texture texPortraits[24];
var int PortraitIndex;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	PopulateTeamChoices();
   CreatePortraitButton();

	Super.InitWindow();

   SetInitialTeam();

   SetActionButtonWidth(153);

   btnAction.SetHelpText(HelpText);
   btnInfo.SetPos(0,195);
}

// ----------------------------------------------------------------------
// PopulateTeamChoices()
// ----------------------------------------------------------------------

function PopulateTeamChoices()
{
	local int typeIndex;

   for (typeIndex = 0; typeIndex < arrayCount(TeamNames); typeIndex++)
   {
      enumText[typeIndex]=TeamNames[typeIndex];
   }
}

// ----------------------------------------------------------------------
// SetInitialTeam()
// ----------------------------------------------------------------------

function SetInitialTeam()
{
   local string TypeString;
   local int typeIndex;
   
   TypeString = player.GetDefaultURL("Team");

   SetValue(defaultValue);

   if (TypeString == "")
	   return;
  
   for (typeIndex = 0; typeIndex < arrayCount(TeamNames); typeIndex++)
   {
      if (TypeString==GetModuleName(typeIndex))
         SetValue(typeIndex);
   }
}

// ----------------------------------------------------------------------
// SetValue()
// ----------------------------------------------------------------------

function SetValue(int newValue)
{
   Super.SetValue(newValue);
   UpdatePortrait();
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
   player.UpdateURL("Team", GetModuleName(currentValue), true);
   player.ChangeTeam(int(TeamNumber[currentValue]));
   player.SaveConfig();
}

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
   local string TypeString;
   local int typeIndex;
   
   TypeString = player.GetDefaultURL("Team");

   SetValue(DefaultValue);

   if (TypeString == "")
	   return;

   for (typeIndex = 0; typeIndex < arrayCount(TeamNames); typeIndex++)
   {
      if (TypeString==GetModuleName(typeIndex))
         SetValue(typeIndex);
   }

   //Make sure it has a valid number.
   SaveSetting();
}

// ----------------------------------------------------------------------
// ResetToDefault
// ----------------------------------------------------------------------

function ResetToDefault()
{   
   player.UpdateURL("Team", GetModuleName(defaultValue), true);
   player.SaveConfig();
   LoadSetting();
}

// ----------------------------------------------------------------------
// GetModuleName()
// For command line parsing
// ----------------------------------------------------------------------

function string GetModuleName(int TeamIndex)
{
   return (TeamNumber[TeamIndex]);
}

// ----------------------------------------------------------------------
// CreatePortraitButton()
// ----------------------------------------------------------------------

function CreatePortraitButton()
{
	btnPortrait = ButtonWindow(NewChild(Class'ButtonWindow'));

	btnPortrait.SetSize(116, 163);
	btnPortrait.SetPos(19, 27);

	btnPortrait.SetBackgroundStyle(DSTY_Masked);
}

// ----------------------------------------------------------------------
// UpdatePortrait()
// ----------------------------------------------------------------------

function UpdatePortrait()
{
   btnPortrait.SetBackground(texPortraits[CurrentValue]);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     TeamNumber(0)="0"
     TeamNumber(1)="1"
     TeamNumber(2)="128"
     TeamNames(0)="UNATCO"
     TeamNames(1)="NSF"
     TeamNames(2)="AUTO"
     texPortraits(0)=Texture'DeusExUI.UserInterface.menuplayersetupunatco'
     texPortraits(1)=Texture'DeusExUI.UserInterface.menuplayersetupnsf'
     texPortraits(2)=Texture'DeusExUI.UserInterface.menuplayersetupautoteam'
     defaultValue=2
     defaultInfoWidth=153
     defaultInfoPosX=170
     HelpText="Choice of team on which to play."
     actionText="Team Model"
}
