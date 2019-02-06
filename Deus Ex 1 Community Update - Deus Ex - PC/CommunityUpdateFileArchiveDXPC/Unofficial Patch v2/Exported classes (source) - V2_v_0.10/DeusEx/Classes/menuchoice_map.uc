//=============================================================================
// MenuChoice_Map
//=============================================================================

class MenuChoice_Map extends MenuUIChoiceEnum;

var DXMapList MapList;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
     
   PopulateMapFiles();

   SetInitialMap();

   SetActionButtonWidth(179);
}

// ----------------------------------------------------------------------
// PopulateMapFiles()
// ----------------------------------------------------------------------

function PopulateMapFiles()
{
	local int typeIndex;

   MapList = player.Spawn(class'DXMapList');

   if (MapList == None)
   {
      return;
   }

   for (typeIndex = 0; ((typeIndex < arrayCount(MapList.Maps)) && (MapList.Maps[typeIndex] != "")); typeIndex++)
   {
      enumText[typeIndex] = MapList.Maps[typeIndex] @ MapList.MapSizes[typeIndex];
   }

   MapList.Destroy();
}

// ----------------------------------------------------------------------
// SetInitialGameType()
// ----------------------------------------------------------------------

function SetInitialMap()
{
   local int CurrentMapNum;

   CurrentMapNum = int(player.ConsoleCommand("get" @ configsetting));  

   SetValue(CurrentMapNum);
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
   local int CurrentMapNum;
   
   CurrentMapNum = int(player.ConsoleCommand("get" @ configsetting));
   
   SetValue(CurrentMapNum);
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
     HelpText="Map on which to begin play(includes suggested number of players for that map)"
     actionText="Map"
     configSetting="DXMapList MapNum"
}
