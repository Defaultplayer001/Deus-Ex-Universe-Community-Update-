//=============================================================================
// InvokeConWindow
//=============================================================================
class InvokeConWindow expands ToolWindow;

// Windows 
var ToolListWindow   lstActors;
var ToolListWindow   lstCons;
var ToolListWindow   lstFlags;

var ToolButtonWindow btnOK;
var ToolButtonWindow btnCancel;
var ToolButtonwindow btnSetFlags;
var ToolButtonwindow btnEditFlags;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
	
	// Center this window	
	SetSize(375, 364);

	// Create the controls
	SetTitle("Invoke Conversation");
	CreateControls(winContainer);
	PopulateActorsList();
	EnableButtons();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls(Window winParent)
{
	// List Box Headers
	CreateToolLabel(18, 30, "Actors");
	CreateToolLabel(195, 30, "Conversations");
	CreateToolLabel(18, 255, "Required Flags");

	// Create Listboxes
	lstActors = CreateToolList( 15,  45, 165, 200);
	lstCons   = CreateToolList(192,  45, 165, 200);
	lstFlags  = CreateToolList( 15, 268, 165, 80);
	
	// Buttons
	btnSetFlags  = CreateToolButton(195, 268, "|&Set Flags");
	btnEditFlags = CreateToolButton(195, 298, "|&Edit Flags");
	btnOK        = CreateToolButton(282, 268, "|&OK");
	btnCancel    = CreateToolButton(282, 298, "|&Cancel");
}

// ----------------------------------------------------------------------
// PopulateActorsList()
// ----------------------------------------------------------------------

function PopulateActorsList()
{
	local int rowIndex;
	local Conversation conObject;
	local Actor anActor;

	// For now, we're only interested in boolean flags
	lstActors.DeleteAllRows();

	// Loop through the conversations and add actors to 
	// the appropriate list window
	foreach player.AllActors(class'Actor', anActor)
	{
		// Check to see if there's any conversations
		if ( anActor.conListItems != None )
		{
			rowIndex = lstActors.AddRow(anActor.BindName);
			lstActors.SetRowClientObject(rowIndex, anActor);
		}
	}

	// Sort the flags by name
	lstActors.SetSortColumn(1);
	lstActors.Sort();
}

// ----------------------------------------------------------------------
// PopulateConsList()
// ----------------------------------------------------------------------

function PopulateConsList(Actor anActor)
{
	local int rowIndex;
	local ConListItem conListItem;

	// For now, we're only interested in boolean flags
	lstCons.DeleteAllRows();

	conListItem = ConListItem(anActor.conListItems);

	// List through conversations for this actor, adding 
	// them to the list
	while( conListItem != None )
	{
		rowIndex = lstCons.AddRow(conListItem.con.conName);
		lstActors.SetRowClientObject(rowIndex, conListItem.con);

		conListItem = conListItem.next;
	}

	// Sort the conversations by name
	lstActors.SetSortColumn(1);
	lstActors.Sort();
}

// ----------------------------------------------------------------------
// PopulateFlagsList()
// ----------------------------------------------------------------------

function PopulateFlagsList(Conversation con)
{
	local int rowIndex;
	local ConFlagRef flagRef;

	lstFlags.DeleteAllRows();

	if ( con != None )
	{
		flagRef = con.flagRefList;

		while ( flagRef != None )
		{
			rowIndex = lstFlags.AddRow( flagRef.flagName );	
			flagRef = flagRef.nextFlagRef;
		}
	}
	EnableButtons();
}

// ----------------------------------------------------------------------
// ListSelectedChanged()
//
// When the user clicks on the Actor list, populate the list of 
// conversations in the right listbox
// ----------------------------------------------------------------------

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
	local Object listObject;

	listObject = ListWindow(list).GetRowClientObject(focusRowId);

	if ( list == lstActors )
		PopulateConsList(Actor(listObject));
	else if ( list == lstCons )
		PopulateFlagsList(Conversation(listObject));
	
	EnableButtons();

	return True;
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	bHandled   = True;

	switch( buttonPressed )
	{
		case btnSetFlags:
			SetFlags();
			break;

		case btnEditFlags:
			root.PushWindow(Class'FlagEditWindow');
			break;

		case btnOK:
			root.PopWindow();
			break;

		case btnCancel:
			root.PopWindow();
			break;

		default:
			bHandled = False;
			break;
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// SetFlags()
//
// Loops through all the flags for the selected conversation and 
// sets them in the game, making it easier to run the selected
// conversation.
// ----------------------------------------------------------------------

function SetFlags()
{
	local Conversation con;
	local ConFlagRef flagRef;

	if (( lstCons.GetNumRows() == 0 ) || ( lstCons.GetSelectedRow() == 0 ) )
		return;

	con = Conversation(lstCons.GetRowClientObject(lstCons.GetSelectedRow()));

	// Now loop through the flags 
	flagRef = con.flagRefList;

	while ( flagRef != None )
	{
		player.flagBase.SetBool(flagRef.flagName, flagRef.value);
		flagRef = flagRef.nextFlagRef;
	}
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	btnSetFlags.SetSensitivity( lstFlags.GetNumRows() > 0 );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
