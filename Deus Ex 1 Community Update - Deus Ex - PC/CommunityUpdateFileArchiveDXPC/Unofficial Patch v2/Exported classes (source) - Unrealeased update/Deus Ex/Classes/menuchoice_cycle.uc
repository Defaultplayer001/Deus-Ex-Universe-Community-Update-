//=============================================================================
// MenuChoice_Cycle
//=============================================================================

class MenuChoice_Cycle extends MenuUIChoiceEnum;

var DXMapList MapList;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
     
   PopulateCycleTypes();

   SetInitialCycleType();

   SetActionButtonWidth(179);
}

// ----------------------------------------------------------------------
// PopulateCycleTypes()
// ----------------------------------------------------------------------

function PopulateCycleTypes()
{
	local int typeIndex;

   MapList = player.Spawn(class'DXMapList');

   if (MapList == None)
   {
      return;
   }

   for (typeIndex = 0; typeIndex < MapList.NumTypes; typeIndex++)
   {
      enumText[typeIndex] = MapList.CycleNames[typeIndex];
   }

   MapList.Destroy();
}

// ----------------------------------------------------------------------
// SetInitialCycleType()
// ----------------------------------------------------------------------

function SetInitialCycleType()
{
   local int CurrentType;

   CurrentType = int(player.ConsoleCommand("get" @ configsetting)); 

   SetValue(CurrentType);
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
   player.ConsoleCommand("set" @ configsetting @ currentvalue);
}

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
   local int CurrentType;
   
   CurrentType = int(player.ConsoleCommand("get" @ configsetting)); 

   SetValue(CurrentType);
}

// ----------------------------------------------------------------------
// ResetToDefault
// ----------------------------------------------------------------------

function ResetToDefault()
{   
   player.ConsoleCommand("set " $ configSetting $ " " $ defaultvalue);
   LoadSetting();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=243
     defaultInfoPosX=203
     HelpText="Determines how the server picks the next map when the current map is done"
     actionText="Map Cycling"
     configSetting="DXMapList CycleType"
}
