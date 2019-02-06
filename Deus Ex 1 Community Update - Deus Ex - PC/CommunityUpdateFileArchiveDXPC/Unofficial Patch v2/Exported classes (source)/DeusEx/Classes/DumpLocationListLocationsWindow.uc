//=============================================================================
// DumpLocationListLocationsWindow
//=============================================================================
class DumpLocationListLocationsWindow expands DumpLocationBaseWindow;

// Windows 
var ToolButtonWindow btnView;
var ToolButtonWindow btnDetails;
var ToolButtonWindow btnDelete;
var ToolButtonWindow btnFiles;
var ToolButtonWindow btnCancel; 
var ToolListWindow   lstLocs;

// Other stuff
var String dumpFile;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Center this window	
	SetSize(520, 430);
	SetTitle("Dump File Locations");
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	// Buttons
	btnView    = CreateToolButton(430, 287, "|&View");
	btnDetails = CreateToolButton(430, 312, "|&Details");
	btnDelete  = CreateToolButton(430, 337, "De|&lete");
	btnFiles   = CreateToolButton(430, 362, "|&Files");
	btnCancel  = CreateToolButton(430, 387, "|&Close");

	CreateLocationsList();
}

// ----------------------------------------------------------------------
// CreateLocationsList()
// ----------------------------------------------------------------------

function CreateLocationsList()
{
	// Now create the List Window
	lstLocs = CreateToolList(15, 38, 405, 372);
	lstLocs.SetColumns(4);
	lstLocs.EnableMultiSelect(False);
	lstLocs.EnableAutoExpandColumns(True);

	lstLocs.HideColumn(3);
}

// ----------------------------------------------------------------------
// PopulateLocationsList()
// ----------------------------------------------------------------------

function PopulateLocationsList()
{
	local int locIndex;
	local Bool locationFound;

	if (dumpFile == "")
		return;

	lstLocs.DeleteAllRows();

	if (dumpLoc.OpenDumpFile(dumpFile) == False)
	{
		DisplayOpenFileError();
		return;
	}

	// Loop through all the Locations in this file

	locationFound = dumpLoc.GetFirstDumpFileLocation();

	while(locationFound)
	{
		locIndex = dumpLoc.GetDumpLocationIndex();

		lstLocs.AddRow( 
			String(dumpLoc.currentDumpLocation.LocationID) $ ";" $ 
			dumpLoc.currentDumpLocation.MapName $ ";" $
			dumpLoc.currentDumpLocation.Title $ ";" $
			dumpLoc.currentDumpLocation.LocationID);

		locIndex++;
		locationFound = dumpLoc.GetNextDumpFileLocation();
	}

	// Sort the maps by name
	lstLocs.Sort();

	EnableButtons();
}

// ----------------------------------------------------------------------
// SetDumpFile()
// ----------------------------------------------------------------------

function SetDumpFile(String newDumpFile)
{
	dumpFile = newDumpFile;

	// Attempt to open the file

	PopulateLocationsList();
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
		case btnView:
			ViewDumpLocation();
			break;

		case btnDetails:
			ViewLocationDetails();
			break;

		case btnDelete:
			DeleteDumpLocation();
			break;

		case btnFiles:
			root.PopWindow();
			root.PushWindow(Class'DumpLocationListWindow', True);
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
// VirtualKeyPressed()
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bKeyHandled;
	bKeyHandled = True;

	if ( IsKeyDown( IK_Alt ) || IsKeyDown( IK_Shift ) || IsKeyDown( IK_Ctrl ))
		return False;

	switch( key ) 
	{	
		case IK_Delete:
			DeleteDumpLocation();
			break;

		default:
			bKeyHandled = False;
	}

	if ( !bKeyHandled )
		return Super.VirtualKeyPressed(key, bRepeat);
	else
		return bKeyHandled;
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
	ViewDumpLocation();
	return TRUE;
}

// ----------------------------------------------------------------------
// EnableButtons()
//
// Checks the state of the list control and updates the pushbuttons
// appropriately
// ----------------------------------------------------------------------

function EnableButtons()
{
	btnView.SetSensitivity(lstLocs.GetNumSelectedRows() > 0);
	btnDetails.SetSensitivity(lstLocs.GetNumSelectedRows() > 0);
	btnDelete.SetSensitivity(lstLocs.GetNumSelectedRows() > 0);
}

// ----------------------------------------------------------------------
// ViewDumpLocation()
// ----------------------------------------------------------------------

function ViewDumpLocation()
{
	local String mapName;
	local Int locationID;
	local DeusExPlayer localPlayer;
	local DeusExLevelInfo dxInfo;

	locationID = Int(lstLocs.GetField(lstLocs.GetSelectedRow(), 3));

	if (dumpLoc.SelectDumpFileLocation(locationID) == False)
		return;

	dumpLoc.SaveLocation();
	mapName	= dumpLoc.currentDumpLocation.MapName;
	localPlayer = player;

	foreach player.AllActors(class'DeusExLevelInfo', dxInfo)
		break;

	// Make sure the map isn't already loaded to save time
	if ((dxInfo != None) && (dxInfo.MapName == mapName))
	{
		dumpLoc.LoadLocation();
		player.Ghost();
		player.SetLocation(dumpLoc.currentDumpLocation.Location);
		player.SetRotation(dumpLoc.currentDumpLocation.ViewRotation);
		player.ViewRotation = dumpLoc.currentDumpLocation.ViewRotation;
		player.ClientSetRotation(dumpLoc.currentDumpLocation.ViewRotation);
		root.ClearWindowStack();
	}
	else
	{
		root.ClearWindowStack();
		player.ConsoleCommand("Open" @ mapName $ "?loadonly");	
	}
}

// ----------------------------------------------------------------------
// ViewLocationDetails()
// ----------------------------------------------------------------------

function ViewLocationDetails()
{
	local DumpLocationEditWindow winLocation;

	winLocation = DumpLocationEditWindow(root.PushWindow(Class'DumpLocationEditWindow', True));
	winLocation.SetEditMode(dumpFile, Int(lstLocs.GetField(lstLocs.GetSelectedRow(), 3)));
}

// ----------------------------------------------------------------------
// DeleteDumpLocation()
// ----------------------------------------------------------------------

function DeleteDumpLocation()
{
	local int rowID;
	local int rowIndex;

	rowID = lstLocs.GetSelectedRow();

	// Get the row index so we can highlight it after we delete this item
	rowIndex = lstLocs.RowIdToIndex(rowID);

	if (rowID > 0)
	{
		dumpLoc.DeleteDumpFileLocation(Int(lstLocs.GetField(rowID, 3)));

		// Remove the row and select the next item
		lstLocs.DeleteRow(rowID);
		  
		// Attempt to highlight the next row
		if ( lstLocs.GetNumRows() > 0 )
		{
			if ( rowIndex >= lstLocs.GetNumRows() )
				rowIndex = lstLocs.GetNumRows() - 1;
			
			rowID = lstLocs.IndexToRowId(rowIndex);

			lstLocs.SetRow(rowID);

			EnableButtons();
		}
		else
		{
			root.PopWindow();
		}
	}
}

// ----------------------------------------------------------------------
// DisplayOpenFileError()
// ----------------------------------------------------------------------

function DisplayOpenFileError()
{
	root.ToolMessageBox(
		"Error Opening File!", 
		"An error occured attempting to open the " $ dumpFile $ ".dmp file!", 
		1, False, Self);
}

// ----------------------------------------------------------------------
// BoxOptionSelected()
// ----------------------------------------------------------------------

event bool BoxOptionSelected(Window msgBoxWindow, int buttonNumber)
{
	// Nuke the msgbox
	root.PopWindow();
	root.PopWindow();
	return true;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
