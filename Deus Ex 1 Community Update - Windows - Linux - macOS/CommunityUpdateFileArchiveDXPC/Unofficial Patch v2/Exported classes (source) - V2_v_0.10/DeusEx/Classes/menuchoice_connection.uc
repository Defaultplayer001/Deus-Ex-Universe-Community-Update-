//=============================================================================
// MenuChoice_Connection
//=============================================================================

class MenuChoice_Connection extends MenuUIChoiceEnum;

var int     ConnectionSpeeds[2]; //Speeds (bytes per second) for connections
var localized String     ConnectionNames[2]; //Human readable connection speed names.

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	PopulateConnectionSpeeds();

	Super.InitWindow();

   SetInitialConnection();

   SetActionButtonWidth(153);

   btnAction.SetHelpText(HelpText);
}

// ----------------------------------------------------------------------
// PopulateConnectionSpeeds()
// ----------------------------------------------------------------------

function PopulateConnectionSpeeds()
{
	local int typeIndex;

   for (typeIndex = 0; typeIndex < arrayCount(ConnectionNames); typeIndex++)
   {
      enumText[typeIndex]=ConnectionNames[typeIndex];
   }
}

// ----------------------------------------------------------------------
// SetInitialConnection()
// ----------------------------------------------------------------------

function SetInitialConnection()
{
   local string TypeString;
   local int typeIndex;

   
   TypeString = player.ConsoleCommand("get" @ configsetting);
  
   for (typeIndex = 0; typeIndex < arrayCount(ConnectionNames); typeIndex++)
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

   for (typeIndex = 0; typeIndex < arrayCount(ConnectionNames); typeIndex++)
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

function string GetModuleName(int ConnectionIndex)
{
   return (string(ConnectionSpeeds[ConnectionIndex]));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ConnectionSpeeds(0)=2600
     ConnectionSpeeds(1)=20000
     ConnectionNames(0)="Modem"
     ConnectionNames(1)="DSL or better"
     defaultInfoWidth=153
     defaultInfoPosX=170
     HelpText="Type of Internet Connection"
     actionText="Connection Type"
     configSetting="Player ConfiguredInternetSpeed"
}
