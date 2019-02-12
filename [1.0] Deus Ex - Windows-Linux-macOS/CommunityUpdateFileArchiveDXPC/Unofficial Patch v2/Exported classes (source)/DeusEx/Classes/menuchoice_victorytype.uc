//=============================================================================
// MenuChoice_VictoryType
//=============================================================================

class MenuChoice_VictoryType extends MenuUIChoiceEnum;

var String     VictoryTypes[2]; //Class names for victory types
var localized String     VictoryNames[2]; //Human readable VictoryType names.

var MenuScreenHostGame hostparent;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	PopulateVictoryTypes();

	Super.InitWindow();

   SetInitialVictoryType();

   SetActionButtonWidth(179);
}

// ----------------------------------------------------------------------
// PopulateVictoryTypes()
// ----------------------------------------------------------------------

function PopulateVictoryTypes()
{
	local int typeIndex;

   for (typeIndex = 0; typeIndex < arrayCount(VictoryNames); typeIndex++)
   {
      enumText[typeIndex]=VictoryNames[typeIndex];
   }
}

// ----------------------------------------------------------------------
// SetInitialVictoryType()
// ----------------------------------------------------------------------

function SetInitialVictoryType()
{
   local string TypeString;
   local int typeIndex;

   TypeString = player.ConsoleCommand("get" @ configsetting);

   for (typeIndex = 0; typeIndex < arrayCount(VictoryTypes); typeIndex++)
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

   for (typeIndex = 0; typeIndex < arrayCount(VictoryTypes); typeIndex++)
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
// SetValue()
// ----------------------------------------------------------------------

function SetValue(int newValue)
{
   Super.SetValue(newValue);

   if ( (hostParent != None) && (hostParent.VictoryValueChoice != None) )   
      hostParent.VictoryValueChoice.SetVictoryType(GetModuleName(newValue));
}

// ----------------------------------------------------------------------
// GetModuleName()
// For command line parsing
// ----------------------------------------------------------------------

function string GetModuleName(int GameIndex)
{
   return (VictoryTypes[GameIndex]);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     VictoryTypes(0)="Frags"
     VictoryTypes(1)="Time"
     VictoryNames(0)="Kill Limit"
     VictoryNames(1)="Time Limit"
     defaultInfoWidth=243
     defaultInfoPosX=203
     HelpText="Determines under what circumstances the game ends."
     actionText="Victory Condition"
     configSetting="DeusEXMPGame VictoryCondition"
}
