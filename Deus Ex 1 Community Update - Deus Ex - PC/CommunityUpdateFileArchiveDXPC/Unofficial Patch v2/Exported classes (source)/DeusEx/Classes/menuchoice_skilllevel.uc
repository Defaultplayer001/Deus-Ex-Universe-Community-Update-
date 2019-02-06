//=============================================================================
// MenuChoice_SkillLevel
//=============================================================================

class MenuChoice_SkillLevel extends MenuUIChoiceEnum;

var int    SkillLevel; //const value for starting skill level
var localized String     LevelNames[3]; //Human readable skill level names

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	PopulateSkillLevels();

	Super.InitWindow();

   SetInitialSkillLevel();

   SetActionButtonWidth(179);
}

// ----------------------------------------------------------------------
// PopulateSkillLevels()
// ----------------------------------------------------------------------

function PopulateSkillLevels()
{
	local int LevelIndex;

   for (LevelIndex = 0; LevelIndex < arrayCount(LevelNames); LevelIndex++)
   {
      enumText[LevelIndex]=LevelNames[LevelIndex];
   }
}

// ----------------------------------------------------------------------
// SetInitialSkillLevel()
// ----------------------------------------------------------------------

function SetInitialSkillLevel()
{
   local int LevelSetting;

   LevelSetting = int(player.ConsoleCommand("get" @ configsetting));

   SetValue(LevelSetting);
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
   player.ConsoleCommand("set" @ configsetting @ (currentValue + 1));
}

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
   local int LevelSetting;

   LevelSetting = int(player.ConsoleCommand("get" @ configsetting));
   LevelSetting--;

   SetValue(LevelSetting);
}

// ----------------------------------------------------------------------
// ResetToDefault
// ----------------------------------------------------------------------

function ResetToDefault()
{   
   player.ConsoleCommand("set " $ configSetting $ " " $ (defaultValue + 1));
   LoadSetting();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     LevelNames(0)="Trained(1)"
     LevelNames(1)="Advanced(2)"
     LevelNames(2)="Master(3)"
     defaultInfoWidth=243
     defaultInfoPosX=203
     HelpText="Starting level for player skills, Trained, Advanced, or Master."
     actionText="Starting Skill Level"
     configSetting="DeusExMPGame MPSkillStartLevel"
}
