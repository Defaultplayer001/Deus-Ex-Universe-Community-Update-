//=============================================================================
// FlagEditWindow
//=============================================================================
class FlagEditWindow expands ToolWindow;

Enum EFlagEditMode
{
    FE_Edit, 
	FE_Add
};

// Windows 
var ToolListWindow   lstFlags;
var ToolButtonWindow btnEdit;   
var ToolButtonWindow btnDelete; 
var ToolButtonWindow btnAdd;    
var ToolButtonWindow btnClose;  
var RadioBoxWindow   radSort;
var Window           winSort;
var ToolRadioButtonWindow	btnSortName;
var ToolRadioButtonWindow	btnSortType;

// Other stuff
var EFlagEditMode	 flagEditMode;
var String			 saveFlagName;
var EFlagType		 saveFlagType;
var int				 saveRowID;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Center this window	
	SetSize(565, 420);
	SetTitle("Edit Flags");

	// Create the controls
	CreateControls();
	PopulateFlagsList();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	CreateSortRadioWindow();

	// Flags list box
	CreateFlagsList();
	
	// Buttons
	btnAdd    = CreateToolButton(465,  60, "|&Add");
	btnEdit   = CreateToolButton(465,  85, "|&Edit");
	btnDelete = CreateToolButton(465, 110, "|&Delete");
	btnClose  = CreateToolButton(465, 368, "|&Close");
}

// ----------------------------------------------------------------------
// CreateSortRadioWindow()
// ----------------------------------------------------------------------

function CreateSortRadioWindow()
{
	CreateToolLabel(16, 33, "Sort By:");

	// Create a RadioBox window for the boolean radiobuttons
	radSort = RadioBoxWindow(NewChild(Class'RadioBoxWindow'));
	radSort.SetPos(65, 30);
	radSort.SetSize(180, 20);
	winSort = radSort.NewChild(Class'Window');

	// Create the two Radio Buttons
	btnSortName = ToolRadioButtonWindow(winSort.NewChild(Class'ToolRadioButtonWindow'));
	btnSortName.SetText("Name");
	btnSortName.SetPos(0, 5);

	btnSortType = ToolRadioButtonWindow(winSort.NewChild(Class'ToolRadioButtonWindow'));
	btnSortType.SetText("Type");
	btnSortType.SetPos(65, 5);

	btnSortName.SetToggle(True);
}

// ----------------------------------------------------------------------
// CreateFlagsList()
// ----------------------------------------------------------------------

function CreateFlagsList()
{
	// Now create the List Window
	lstFlags = CreateToolList(15, 60, 425, 332);

	lstFlags.EnableMultiSelect(False);
	lstFlags.SetColumns(5);

	lstFlags.SetColumnTitle(0, "Flag");
	lstFlags.SetColumnTitle(1, "Type");
	lstFlags.SetColumnTitle(2, "Value");
	lstFlags.SetColumnTitle(3, "Exp.");

	lstFlags.EnableAutoExpandColumns(True);
	lstFlags.SetColumnWidth(0, 210);
	lstFlags.SetColumnWidth(1, 75);
	lstFlags.SetColumnWidth(2, 100);

	lstFlags.SetSortColumn(0);
	lstFlags.AddSortColumn(1);

	lstFlags.HideColumn(4);
}

// ----------------------------------------------------------------------
// PopulateFlagsList()
// ----------------------------------------------------------------------

function PopulateFlagsList()
{
	local int rowIndex;
	local int flagIterator;
	local Name flagName;

	local EFlagType flagType;

	// For now, we're only interested in boolean flags
	lstFlags.DeleteAllRows();

	flagIterator = player.flagBase.CreateIterator();

	while( player.flagBase.GetNextFlag( flagIterator, flagName, flagType ) )
	{
		rowIndex = lstFlags.AddRow( BuildFlagString(flagName, flagType) );
	}

	player.flagBase.DestroyIterator(flagIterator);

	// Sort the flags by name
	lstFlags.Sort();

	EnableButtons();
}

// ----------------------------------------------------------------------
// BuildFlagString()
//
// Builds a string that can be set in a two-column listbox.
// The flag name followed by a human-readable flag value
// ----------------------------------------------------------------------

function String BuildFlagString( Name flagName, EFlagType flagType )
{
	local String flagString;

	flagString = flagName $ ";";

	switch( flagType )
	{
		case FLAG_Bool:
			flagString = flagString $ "Bool;";
			if ( player.flagBase.GetBool(flagName) )
				flagString = flagString $ "True";
			else
				flagString = flagString $ "False";
			break;

		case FLAG_Byte:
			flagString = flagString $ "Byte;";
			flagString = flagString $ String(player.flagBase.GetByte(flagName));
			break;

		case FLAG_Int:
			flagString = flagString $ "Int;";
			flagString = flagString $ String(player.flagBase.GetInt(flagName));
			break;

		case FLAG_Float:
			flagString = flagString $ "Float;";
			flagString = flagString $ String(player.flagBase.GetFloat(flagName));
			break;

		case FLAG_Name:
			flagString = flagString $ "Name;";
			flagString = flagString $ player.flagBase.GetName(flagName);
			break;

		case FLAG_Vector:
			flagString = flagString $ "Vector;";
			break;

		case FLAG_Rotator:
			flagString = flagString $ "Rotator;";
			break;
	}

	flagString = flagString $ ";" $ String(player.flagBase.GetExpiration(flagName, flagType));
	flagString = flagString $ ";" $ String(flagType);

	return flagString;
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
		case btnAdd:
			AddFlag();
			break;

		case btnEdit:
			EditFlag();
			break;

		case btnDelete:
			DeleteFlag();
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
// ToggleChanged()
//
// Change sort order
// ----------------------------------------------------------------------

event bool ToggleChanged(Window button, bool bNewToggle)
{
	if ((bNewToggle) && (lstFlags != None))
	{
		if (button == btnSortName)
		{
			lstFlags.SetSortColumn(0);
			lstFlags.AddSortColumn(1);
		}	
		else
		{
			lstFlags.SetSortColumn(1);
			lstFlags.AddSortColumn(0);
		}	

		lstFlags.Sort();

		return True;
	}
	else
	{
		return False;
	}
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
	EditFlag();
}

// ----------------------------------------------------------------------
// GetFlagTypeFromInt()
// ----------------------------------------------------------------------

function EFlagType GetFlagTypeFromInt(int intFlagType)
{
	local EFlagType flagType;

	switch(intFlagType)
	{
		case 0:
			flagType = FLAG_Bool;
			break;
		case 1:
			flagType = FLAG_Byte;
			break;
		case 2:
			flagType = FLAG_Int;
			break;
		case 3:
			flagType = FLAG_Float;
			break;
		case 4:
			flagType = FLAG_Name;
			break;
		case 5:
			flagType = FLAG_Vector;
			break;
		case 6:
			flagType = FLAG_Rotator;
			break;
	}

	return flagType;
}

// ----------------------------------------------------------------------
// EditFlag()
// ----------------------------------------------------------------------

function EditFlag()
{
	local FlagAddWindow winAdd;
	local Name flagName;

	winAdd = FlagAddWindow(root.PushWindow(Class'FlagAddWindow'));
	winAdd.SetFlagListWindow(Self);

	// Save the current rowID and name to make it easier to 
	// edit the flag once the dialog is complete

	saveRowID = lstFlags.GetSelectedRow();
	saveFlagName = lstFlags.GetField(saveRowID, 0);
	saveFlagType = GetFlagTypeFromInt(Int(lstFlags.GetField(saveRowID, 4)));

	flagName = StringToName(saveFlagName);
	winAdd.SetEditFlag(flagName, saveFlagType);

	flagEditMode = FE_Edit;
}

// ----------------------------------------------------------------------
// AddFlag()
// ----------------------------------------------------------------------

function AddFlag()
{
	local FlagAddWindow winAdd;

	winAdd = FlagAddWindow(root.PushWindow(Class'FlagAddWindow'));
	winAdd.SetFlagListWindow(Self);
	winAdd.SetAddMode();

	flagEditMode = FE_Add;
}

// ----------------------------------------------------------------------
// DeleteFlag()
// ----------------------------------------------------------------------

function DeleteFlag()
{
	local int rowID;
	local int rowIndex;
	local Name flagName;

	rowID = lstFlags.GetSelectedRow();

	// Get the row index so we can highlight it after we delete this item
	rowIndex = lstFlags.RowIdToIndex(rowID);

	// Delete the flag from the flagbase
	flagName = StringToName(lstFlags.GetField(rowID, 0));
	player.flagBase.DeleteFlag(flagName, FLAG_Bool);

	// Delete the row
	lstFlags.DeleteRow(rowID);

	// Attempt to highlight the next row
	if ( lstFlags.GetNumRows() > 0 )
	{
		if ( rowIndex >= lstFlags.GetNumRows() )
			rowIndex = lstFlags.GetNumRows() - 1;
		
		rowID = lstFlags.IndexToRowId(rowIndex);

		lstFlags.SetRow(rowID);
	}

	EnableButtons();
}


// ----------------------------------------------------------------------
// EnableButtons()
//
// Checks the state of the list control and updates the pushbuttons
// appropriately
// ----------------------------------------------------------------------

function EnableButtons()
{
	btnDelete.SetSensitivity( lstFlags.GetNumSelectedRows() > 0 );
	btnEdit.SetSensitivity( lstFlags.GetNumSelectedRows() > 0 );
}

// ----------------------------------------------------------------------
// ModalComplete()
//
// Called with the FlagAddWindow() is finished.
// ----------------------------------------------------------------------

function ModalComplete(Bool bResult, Window winCaller)
{
	local FlagAddWindow winAddFlag;
	local Name flagName;
	local EFlagType flagType;
	local int  rowID;

	if ( bResult )
	{
		winAddFlag = FlagAddWindow(winCaller);

		// If we're editing a flag and the name changed, then we need 
		// to delete the old flag

		if (flagEditMode == FE_Edit)
		{
			// Delete the existing row
			lstFlags.DeleteRow(saverowID);

			if (saveFlagName != winAddFlag.editName.GetText())
			{
				// Delete the old flag
				flagName = StringToName(saveFlagName);
				player.flagBase.Deleteflag(flagName, saveFlagType);
			}			
		}

		// Get the name from the dialog
		flagName = winAddFlag.GetFlagName();
		flagType = winAddFlag.GetFlagType();

		// Make sure the flag doesn't already exist.  If it does,
		// delete it and remove it from the listbox
		if (player.flagBase.DeleteFlag(flagName, flagType))
		{
			rowID = FindRowFromName(String(flagName), flagType);

			if (rowID != -1)
				lstFlags.DeleteRow(rowID);
		}

		switch(flagType)
		{
			case FLAG_Bool:
				player.flagBase.SetBool(flagName, winAddFlag.btnTrue.GetToggle());
				break;

			case FLAG_Byte:
				player.flagBase.SetByte(flagName, Byte(winAddFlag.GetValue()));
				break;

			case FLAG_Int:
				player.flagBase.SetInt(flagName, Int(winAddFlag.GetValue()));
				break;

			case FLAG_Float:
				player.flagBase.SetFloat(flagName, Float(winAddFlag.GetValue()));
				break;

			case FLAG_Name:
				player.flagBase.SetName(flagName, StringToName(winAddFlag.GetValue()));
				break;
		}

		player.flagBase.SetExpiration(flagName, flagType, winAddFlag.GetFlagExpiration());

		rowID = lstFlags.AddRow(BuildFlagString(flagName, flagType));

		lstFlags.Sort();

		// Select the changed item
		lstFlags.SetRow(rowID);
	}

	// Make the Add dialog go bye-bye
	root.PopWindow();

	EnableButtons();
}

// ----------------------------------------------------------------------
// FindRowFromName()
// ----------------------------------------------------------------------

function int FindRowFromName(String searchName, EFlagType searchFlagType)
{
	local int rowID;
	local int rowIndex;
	local bool bNameFound;

	for(rowIndex=0; rowIndex<lstFlags.GetNumRows(); rowIndex++)
	{
		rowID = lstFlags.IndexToRowId(rowIndex);
		if ((lstFlags.GetField(rowID, 0) == searchName) 
		&& (GetFlagTypeFromInt(Int(lstFlags.GetField(rowID, 4))) == searchFlagType))
		{
			bNameFound = True;	
			break;
		}
	}

	if (bNameFound)
		return rowID;
	else
		return -1;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
