//=============================================================================
// GameDirectory
//=============================================================================
class GameDirectory expands Object
	native
	noexport;

// ----------------------------------------------------------------------
// EGameDirectoryType - Game Directory Types

/*
// TEMP_224
struct DynamicArray
{
	var int foo1, foo2, foo3;
};
*/


enum EGameDirectoryTypes
{
	GD_Maps,
	GD_SaveGames
};

var const native EGameDirectoryTypes gameDirectoryType;		// Game Directory Type
var const native String currentFilter;
var const native array<String> directoryList;
var const native array<DeusExSaveInfo> loadedSaveInfoPointers;
var const native DeusExSaveInfo tempSaveInfo;

native(3080) final function GetGameDirectory();
native(3081) final function int GetNewSaveFileIndex();
native(3082) final function String GenerateSaveFilename(int saveIndex);
native(3083) final function String GenerateNewSaveFilename(optional int newIndex);
native(3084) final function int GetDirCount();
native(3085) final function String GetDirFilename(int fileIndex);
native(3086) final function SetDirType(EGameDirectoryTypes newDirType);
native(3087) final function SetDirFilter(String strFilter);
native(3088) final function DeusExSaveInfo GetSaveInfo(int fileIndex);
native(3089) final function DeusExSaveInfo GetSaveInfoFromDirectoryIndex(int DirectoryIndex);
native(3090) final function DeusExSaveInfo GetTempSaveInfo();
native(3091) final function DeleteSaveInfo(DeusExSaveInfo saveInfo);
native(3092) final function PurgeAllSaveInfo();
native(3093) final function int GetSaveFreeSpace();
native(3094) final function int GetSaveDirectorySize(int saveIndex);

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
