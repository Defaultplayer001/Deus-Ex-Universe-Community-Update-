//=============================================================================
// MenuChoice_GameType
//=============================================================================

class MenuChoice_GameType extends MenuUIChoiceEnum
	config;

var MenuScreenHostGame hostparent;

var globalconfig int NumGameTypes; // Number of gametypes
var globalconfig String     gameTypes[24]; //Class names for game types
var localized String     gameNames[24]; //Human readable gametype names.

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	PopulateGameTypes();

	Super.InitWindow();

   SetInitialGameType();

   SetActionButtonWidth(179);
}

// ----------------------------------------------------------------------
// PopulateGameTypes()
// ----------------------------------------------------------------------

function PopulateGameTypes()
{
	local int typeIndex;

   for (typeIndex = 0; typeIndex < NumGameTypes; typeIndex++)
   {
      enumText[typeIndex]=gameNames[typeIndex];
   }
}

// ----------------------------------------------------------------------
// SetInitialGameType()
// ----------------------------------------------------------------------

function SetInitialGameType()
{
   local string TypeString;
   local int typeIndex;

   TypeString = player.ConsoleCommand("get" @ configsetting);

   for (typeIndex = 0; typeIndex < NumGameTypes; typeIndex++)
   {
      if (TypeString==GetModuleName(typeIndex))
         SetValue(typeIndex);
   }
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
   player.ConsoleCommand("set" @ configsetting @ GetModuleName(currentValue));
}

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
   local string TypeString;
   local int typeIndex;

   TypeString = player.ConsoleCommand("get" @ configsetting);

   for (typeIndex = 0; typeIndex < NumGameTypes; typeIndex++)
   {
      if (TypeString==GetModuleName(typeIndex))
         SetValue(typeIndex);
   }
}

// ----------------------------------------------------------------------
// ResetToDefault
// ----------------------------------------------------------------------

function ResetToDefault()
{   
   player.ConsoleCommand("set " $ configSetting $ " " $ GetModuleName(defaultValue));
   LoadSetting();
}

// ----------------------------------------------------------------------
// GetModuleName()
// For command line parsing
// ----------------------------------------------------------------------

function string GetModuleName(int GameIndex)
{
   return (gameTypes[GameIndex]);
}

// ----------------------------------------------------------------------
// SetValue()
// ----------------------------------------------------------------------

function SetValue(int newValue)
{
   local Class<GameInfo> TypeClass;
   local GameInfo CurrentType;
   local bool bCanCustomize;

   
   Super.SetValue(newValue);

   bCanCustomize = True;
   if ( (hostParent != None) && (GameTypes[NewValue] != "") )   
   {
	   TypeClass = class<GameInfo>( Player.DynamicLoadObject( GetModuleName(newValue), class'Class' ) );
      if (TypeClass != None)      
         CurrentType = Player.Spawn(TypeClass);
      if (DeusExMPGame(CurrentType) != None)
         bCanCustomize = DeusExMPGame(CurrentType).bCustomizable;

      hostParent.SetCustomizable(bCanCustomize);
      if (CurrentType != None)
         CurrentType.Destroy();
   }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     NumGameTypes=4
     gameTypes(0)="DeusEx.DeathMatchGame"
     gameTypes(1)="DeusEx.BasicTeamDMGame"
     gameTypes(2)="DeusEx.AdvTeamDMGame"
     gameTypes(3)="DeusEx.TeamDMGame"
     gameNames(0)="Deathmatch"
     gameNames(1)="Basic Team Deathmatch"
     gameNames(2)="Advanced Team Deathmatch"
     gameNames(3)="Custom Team Deathmatch"
     defaultInfoWidth=243
     defaultInfoPosX=203
     HelpText="Type of game to play"
     actionText="Game Type"
     configSetting="MenuScreenHostGame CurrentGameType"
}
