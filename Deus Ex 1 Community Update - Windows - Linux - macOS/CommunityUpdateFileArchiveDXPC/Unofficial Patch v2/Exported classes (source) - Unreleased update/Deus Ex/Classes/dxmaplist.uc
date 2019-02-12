//=============================================================================
// DXMapList.
//
// contains a list of maps to cycle through
//
//=============================================================================
class DXMapList extends Maplist;

var(Maps) globalconfig string Maps[32];
var globalconfig string MapSizes[32];
var globalconfig int MapNum;
var localized string CycleNames[10];

// NumTypes is the number of total cycle types
// Not using an enum because it is hard for other classes to access

var globalconfig int CycleType;
const MCT_STATIC = 0;
const MCT_RANDOM = 1;
const MCT_CYCLE = 2;

var int NumTypes;

function string GetNextMap()
{
	local string CurrentMap;
   local int NumMaps;
	local int i;

	CurrentMap = GetURLMap();
	if ( CurrentMap != "" )
	{
      //Strip off any .dx
		if ( Right(CurrentMap,3) ~= ".dx" )
			CurrentMap = Left(CurrentMap,Len(CurrentMap)-3);
		else
			CurrentMap = CurrentMap;

		for ( i=0; i<ArrayCount(Maps); i++ )
		{
			if ( CurrentMap ~= Maps[i] )
			{
				MapNum = i;
				break;
			}
		}
	}

   //Count number of maps
   for (i = 0; ( (i < ArrayCount(Maps)) && (Maps[i] != "") ); i++);
   NumMaps = i;

   if (CycleType == MCT_STATIC)
   {
      MapNum = MapNum;
   }
   else if (CycleType == MCT_RANDOM)
   {
      MapNum = FRand() * NumMaps;
      if (MapNum >= NumMaps)
         MapNum = 0;
   }
   else if (CycleType == MCT_CYCLE)
   {
      MapNum++;
      if (MapNum >= NumMaps)
         MapNum = 0;
   }

   //save out our current mapnum
   SaveConfig();

   return Maps[MapNum];
}

defaultproperties
{
     Maps(0)="DXMP_Silo"
     Maps(1)="DXMP_Area51Bunker"
     Maps(2)="DXMP_Cathedral"
     Maps(3)="DXMP_Cmd"
     Maps(4)="DXMP_Smuggler"
     MapSizes(0)="(6-10)"
     MapSizes(1)="(8-14)"
     MapSizes(2)="(8-14)"
     MapSizes(3)="(12-16)"
     MapSizes(4)="(2-6)"
     MapNum=4
     CycleNames(0)="Repeat map"
     CycleNames(1)="Random map"
     CycleNames(2)="Loop maps"
     NumTypes=3
}
