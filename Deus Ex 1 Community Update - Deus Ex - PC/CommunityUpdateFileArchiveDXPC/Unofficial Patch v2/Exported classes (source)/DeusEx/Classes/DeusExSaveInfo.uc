//=============================================================================
// DeusExSaveInfo
//=============================================================================

class DeusExSaveInfo expands Object
	native;

var int Year;				// Year.
var int Month;				// Month.
var int Day;				// Day of month.
var int Hour;				// Hour.
var int Minute;				// Minute.
var int Second;				// Second.

var int DirectoryIndex;		// File Index (if saved already, otherwise -1)
var String Description;		// User entered description
var String MissionLocation;	// Mission Location
var String MapName;			// Map Filename
var Texture Snapshot;		// Snapshot of game when saved
var int saveCount;			// Number of times saved
var int saveTime;			// Duration of play, in seconds
var bool bCheatsEnabled;    // Set to TRUE If Cheats were enabled!!

native(3075) final function UpdateTimeStamp();

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
