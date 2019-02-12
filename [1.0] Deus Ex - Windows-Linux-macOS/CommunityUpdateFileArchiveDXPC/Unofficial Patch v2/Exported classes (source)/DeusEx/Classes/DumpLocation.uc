//=============================================================================
// DumpLocation
//=============================================================================
class DumpLocation expands Object
	native
	noexport;


// Unreal-usable structure
struct DumpLocationStruct
{
	var bool    bDeleted;
	var int     LocationID;
	var String  MapName;
	var Vector  Location;
	var Rotator ViewRotation;
	var String  GameVersion;
	var String  Title;
	var String  Desc;
};

var native int currentDumpFileLocation;
var native DumpLocationstruct currentDumpLocation;		
var native array<String> dumpFileDirectory;				
var native int currentDumpFileIndex;
var native int currentDumpLocationIndex;
var native String currentUser;
var native int dumpFile;
var native int dumpLocationCount;
var native DeusExPlayer player;

native(3020) final function String GetFirstDumpFile();
native(3021) final function String GetNextDumpFile();
native(3022) final function Int GetDumpFileIndex();
native(3023) final function Int GetDumpFileCount();
native(3024) final function Bool OpenDumpFile(String filename);
native(3025) final function CloseDumpFile();
native(3026) final function DeleteDumpFile(String filename);
native(3027) final function Bool GetFirstDumpFileLocation();
native(3028) final function Bool GetNextDumpFileLocation();
native(3029) final function Int GetDumpLocationIndex();
native(3030) final function Bool SelectDumpFileLocation(Int dumpLocationID);
native(3031) final function GetDumpFileLocationInfo();
native(3032) final function DeleteDumpFileLocation(Int dumpLocationID);
native(3033) final function AddDumpFileLocation(String filename, String newTitle, String newDescription);
native(3034) final function Int GetNextDumpFileLocationID();
native(3035) final function String GetCurrentUser();
native(3036) final function SetPlayer(DeusExPlayer newPlayer);
native(3037) final function SaveLocation();
native(3038) final function LoadLocation();
native(3039) final function Bool HasLocationBeenSaved();
native(3040) final function Int GetDumpFileLocationCount(String filename);

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
