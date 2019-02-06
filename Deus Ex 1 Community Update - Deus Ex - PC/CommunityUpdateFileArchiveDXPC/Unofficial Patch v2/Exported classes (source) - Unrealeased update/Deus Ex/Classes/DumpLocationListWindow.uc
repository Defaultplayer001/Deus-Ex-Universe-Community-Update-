//=============================================================================
// DumpLocationListWindow
//=============================================================================
class DumpLocationListWindow expands DumpLocationBaseWindow;

// Windows 
var ToolButtonWindow btnOpen;
var ToolButtonWindow btnDelete;
var ToolButtonWindow btnCancel; 
var ToolListWindow   lstDumps;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Center this window	
	SetSize(370, 230);
	SetTitle("View Dump Files");

	PopulateDumpList();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	// Flags list box
	CreateDumpList();
	
	// Buttons
	btnOpen   = CreateToolButton(280, 137, "|&Open");
	btnDelete = CreateToolButton(280, 162, "|&Delete");
	btnCancel = CreateToolButton(280, 187, "|&Close");
}

// ----------------------------------------------------------------------
// CreateDumpList()
// ----------------------------------------------------------------------

function CreateDumpList()
{
	// Now create the List Window
	lstDumps = CreateToolList(15, 38, 255, 172);
	lstDumps.SetColumns(3);
	lstDumps.EnableMultiSelect(False);
	lstDumps.EnableAutoExpandColumns(True);
	lstDumps.SetColumnWidth(0, 100);

	lstDumps.SetColumnType(2, COLTYPE_Float);
	lstDumps.HideColumn(2);
}

// ----------------------------------------------------------------------
// PopulateDumpList()
// ----------------------------------------------------------------------

function PopulateDumpList()
{
	local int dumpIndex;
	local String dumpFileName;

	lstDumps.DeleteAllRows();

	// Loop through all the files

	dumpFileName = dumpLoc.GetFirstDumpFile();
	dumpFileName = left(dumpFileName, len(dumpFileName) - 4);

	while(dumpFileName != "")
	{
		dumpIndex = dumpLoc.GetDumpFileIndex();
		lstDumps.AddRow( dumpFileName $ ";" $ 
			String(dumpLoc.GetDumpFileLocationCount(dumpFileName)) $ ";" $ 
			String(dumpIndex));
		dumpFileName = dumpLoc.GetNextDumpFile();
		dumpIndex++;
	}

	// Sort the maps by name
	lstDumps.Sort();

	EnableButtons();
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	bHandled = True;

	switch( buttonPressed )
	{
		case btnOpen:
			OpenDumpFile();
			break;

		case btnDelete:
			DeleteDumpFile();
			break;

		case btnCancel:
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
// ListSelectionChanged() 
//
// When the user clicks on an item in the list, update the buttons
// appropriately
// ----------------------------------------------------------------------

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
	EnableButtons();
}

// ----------------------------------------------------------------------
// ListRowActivated()
// ----------------------------------------------------------------------

event bool ListRowActivated(window list, int rowId)
{
	OpenDumpFile();
}

// ----------------------------------------------------------------------
// EnableButtons()
//
// Checks the state of the list control and updates the pushbuttons
// appropriately
// ----------------------------------------------------------------------

function EnableButtons()
{
	btnOpen.SetSensitivity(lstDumps.GetNumSelectedRows() > 0);
	btnDelete.SetSensitivity(lstDumps.GetNumSelectedRows() > 0);
}

// ----------------------------------------------------------------------
// OpenDumpFile()
// ----------------------------------------------------------------------

function OpenDumpFile(optional String dumpFilename)
{
	local DumpLocationListLocationsWindow winLocations;

	if (dumpFilename == "")
		dumpFilename = lstDumps.GetField(lstDumps.GetSelectedRow(), 0);

	winLocations = DumpLocationListLocationsWindow(root.PushWindow(Class'DumpLocationListLocationsWindow', True));
	winLocations.SetDumpFile(dumpFilename);
}

// ----------------------------------------------------------------------
// DeleteDumpFile()
// ----------------------------------------------------------------------

function DeleteDumpFile()
{
	local int rowID;
	local int rowIndex;

	rowID = lstDumps.GetSelectedRow();

	// Get the row index so we can highlight it after we delete this item
	rowIndex = lstDumps.RowIdToIndex(rowID);

	if (rowID > 0)
	{
		dumpLoc.DeleteDumpFile(lstDumps.GetField(RowID, 0));

		// Remove the row and select the next item
		lstDumps.DeleteRow(rowID);
		  
		// Attempt to highlight the next row
		if ( lstDumps.GetNumRows() > 0 )
		{
			if ( rowIndex >= lstDumps.GetNumRows() )
				rowIndex = lstDumps.GetNumRows() - 1;
			
			rowID = lstDumps.IndexToRowId(rowIndex);

			lstDumps.SetRow(rowID);

			EnableButtons();
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
