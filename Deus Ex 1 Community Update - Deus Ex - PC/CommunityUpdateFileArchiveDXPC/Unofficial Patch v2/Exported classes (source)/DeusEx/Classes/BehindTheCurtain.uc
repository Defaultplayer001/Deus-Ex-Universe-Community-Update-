//=============================================================================
// BehindTheCurtain
//=============================================================================
class BehindTheCurtain expands ToolWindow;

var ToolButtonWindow btnLoadMap;
var ToolButtonWindow btnEditFlags;   
var ToolButtonWindow btnInvokeCon; 
var ToolButtonWindow btnShowClass;
var ToolButtonWindow btnQuotes;   
var ToolButtonWindow btnAddDump;
var ToolButtonWindow btnViewDumps; 
var ToolButtonWindow btnPlayMusic;
var ToolButtonWindow btnClose;  

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
	
	// Center this window	
	SetSize(300, 360);
	
	SetTitle("Behind The Curtain");

	// Create the controls
	CreateControls();

	// Hide the title bar
	SetTitleBarVisibility(False);
	SetWindowDragging(True);
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	// Draw the Deus Ex logo
	gc.SetStyle(DSTY_Normal);
	gc.DrawTexture( 10, 10, 256, 93, 0, 0, Texture'BehindTheCurtain1');
	gc.DrawTexture(266, 10,  21, 93, 0, 0, Texture'BehindTheCurtain2');
}

// ----------------------------------------------------------------------
// CreateControls()
// 
// Controls must be created in container window
// ----------------------------------------------------------------------

function CreateControls()
{
	// Buttons
	btnLoadMap   = CreateToolButton(20, 110, "|&Load Map");
	btnEditFlags = CreateToolButton(20, 135, "|&Edit Flags");
	btnAddDump   = CreateToolButton(20, 160, "|&Add Dump");
	btnViewDumps = CreateToolButton(20, 185, "|&View Dumps");
	btnInvokeCon = CreateToolButton(20, 210, "|&Invoke Con");
	btnShowClass = CreateToolButton(20, 235, "|&Show Class");
	btnQuotes    = CreateToolButton(20, 260, "View |&Quotes");
	btnPlayMusic = CreateToolButton(20, 285, "Play |&Music");
	btnClose     = CreateToolButton(20, 325, "|&Close");

	// Button Descriptions
	CreateToolLabel(110, 115, "Load a map from the MAPS directory");
	CreateToolLabel(110, 140, "Edit game flags");
	CreateToolLabel(110, 165, "Add New Dump Location");
	CreateToolLabel(110, 190, "View Dump Locations");
	CreateToolLabel(110, 215, "Invoke Conversation Dialog");
	CreateToolLabel(110, 240, "Display Actors In 3D Scene");
	CreateToolLabel(110, 265, "Quotes from your favorite personalities");
	CreateToolLabel(110, 290, "Music Jukebox");
	CreateToolLabel(110, 330, "Return to the world of Conspiracies");
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;
	local Window win;

	bHandled = True;

	switch( buttonPressed )
	{
		case btnLoadMap:
			root.PushWindow(Class'LoadMapWindow', True);
			break;

		case btnEditFlags:
			root.PushWindow(Class'FlagEditWindow', True);
			break;

		case btnAddDump:
			win = root.PushWindow(Class'DumpLocationEditWindow', True);
			DumpLocationEditWindow(win).SetAddMode();
			break;

		case btnViewDumps:
			ViewDumps();
			break;

		case btnInvokeCon:
			root.PushWindow(Class'InvokeConWindow', True);
			break;

		case btnShowClass:
			root.PushWindow(Class'ShowClassWindow', True);
			break;

		case btnQuotes:
			root.PushWindow(Class'QuotesWindow', True);
			break;

		case btnPlayMusic:
			root.PushWindow(Class'PlayMusicWindow', True);
			break;

		case btnClose:
			root.PopWindow();
			break;

		default:
			bHandled = False;
			break;
	}

	if ( !bHandled ) 
		bHandled = Super.ButtonActivated( buttonPressed );

	return bHandled;
}

// ----------------------------------------------------------------------
// ViewDumps()
//
// Decide which dialog to load based on how many dumpfiles ther eare
// ----------------------------------------------------------------------

function ViewDumps()
{
	local DumpLocation dumpLoc;
	local DumpLocationListLocationsWindow winLocations;
	local String dumpFileName;

	if (player != None)
	{
		// Create our DumpLocation object
		dumpLoc = player.CreateDumpLocationObject();

		if (dumpLoc.GetDumpFileCount() == 0)
		{
			DisplayNoDumpFilesError();
		}
		else if (dumpLoc.GetDumpFileCount() > 2)
		{
			root.PushWindow(Class'DumpLocationListWindow', True);
		}
		else
		{
			winLocations = DumpLocationListLocationsWindow(root.PushWindow(Class'DumpLocationListLocationsWindow', True));

			dumpFileName = dumpLoc.GetFirstDumpFile();
			dumpFileName = left(dumpFileName, len(dumpFileName) - 4);

			winLocations.SetDumpFile(dumpFileName);
		}

		CriticalDelete(dumpLoc);
		dumpLoc = None;
	}
}

// ----------------------------------------------------------------------
// CreateDumpLoc()
// ----------------------------------------------------------------------

function DumpLocation CreateDumpLoc()
{
	local DumpLocation newDumpLoc;

	if (player != None)
	{
		// Create our DumpLocation object
		newDumpLoc = player.CreateDumpLocationObject();
		newDumpLoc.SetPlayer(player);
	}

	return newDumpLoc;
}

// ----------------------------------------------------------------------
// DisplayNoDumpFilesError()
// ----------------------------------------------------------------------

function DisplayNoDumpFilesError()
{
	root.ToolMessageBox(
		"No Dump Files!", 
		"There are no Dump Location files to view!", 
		1, False, Self);
}

// ----------------------------------------------------------------------
// BoxOptionSelected()
// ----------------------------------------------------------------------

event bool BoxOptionSelected(Window msgBoxWindow, int buttonNumber)
{
	// Nuke the msgbox
	root.PopWindow();
	return true;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
