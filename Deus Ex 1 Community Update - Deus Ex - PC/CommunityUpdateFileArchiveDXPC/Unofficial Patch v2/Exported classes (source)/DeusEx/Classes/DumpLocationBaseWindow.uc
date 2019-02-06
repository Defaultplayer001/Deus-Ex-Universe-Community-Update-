//=============================================================================
// DumpLocationBaseWindow
//=============================================================================
class DumpLocationBaseWindow expands ToolWindow;

var DumpLocation dumpLoc;
var Bool bSaveDumpLocation;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	dumpLoc = CreateDumpLoc();

	// Create the controls
	CreateControls();

	EnableButtons();
}

// ----------------------------------------------------------------------
// DestroyWindow()
// ----------------------------------------------------------------------

event DestroyWindow()
{
	if (!bSaveDumpLocation)
		DestroyDumpLoc();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
}

// ----------------------------------------------------------------------
// EnableButtons()
//
// Checks the state of the list control and updates the pushbuttons
// appropriately
// ----------------------------------------------------------------------

function EnableButtons()
{
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
// DestroyDumpLoc()
// ----------------------------------------------------------------------

function DestroyDumpLoc()
{
	if (dumpLoc != None)
	{
		CriticalDelete(dumpLoc);
		dumpLoc = None;
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
