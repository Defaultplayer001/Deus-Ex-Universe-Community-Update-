//=============================================================================
// PersonaScreenConversations
//=============================================================================

class PersonaScreenConversations extends PersonaScreenBaseWindow;

var localized String ConversationsTitleText;

var PersonaListWindow         lstCons;
var PersonaScrollAreaWindow   winScroll;
var TileWindow                conWindow;
var int                       sortColumn;
var Bool                      bSortReverse;

var PersonaActionButtonWindow btnActor;
var PersonaActionButtonWindow btnLocation;
var PersonaActionButtonWindow btnType;

var localized string ActorButtonLabel;
var localized string LocationButtonLabel;
var localized string TypeButtonLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	PersonaNavBarWindow(winNavBar).btnCons.SetSensitivity(False);

	PopulateConversations();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	CreateTitleWindow(9, 5, ConversationsTitleText);

	CreateConversationWindow();
	CreateHistoryListWindow();
	CreateButtons();
}

// ----------------------------------------------------------------------
// CreateHistoryListWindow()
//
// Creates the upper window with the conversations 
// ----------------------------------------------------------------------

function CreateHistoryListWindow()
{
	sortColumn   = 0;
	bSortReverse = False;

	winScroll = CreateScrollAreaWindow(winClient);
	winScroll.SetPos(16, 38);
	winScroll.SetSize(395, 133);

	lstCons = PersonaListWindow(winScroll.clipWindow.NewChild(Class'PersonaListWindow'));
	lstCons.EnableMultiSelect(False);
	lstCons.SetNumColumns(3);
	lstCons.SetSortColumn(sortColumn, bSortReverse);
	lstCons.EnableAutoSort(False);
	lstCons.SetColumnWidth(0, 161);
	lstCons.SetColumnWidth(1, 194);
	lstCons.SetColumnWidth(2, 40);
	lstCons.SetColumnFont(2, Font'FontHUDWingDings');
	lstCons.SetColumnAlignment(2, HALIGN_Center);
}

// ----------------------------------------------------------------------
// PopulateConversations()
// ----------------------------------------------------------------------

function PopulateConversations()
{
	local ConHistory history;
	local int rowIndex;

	// Now loop through all the conversations and add them to the list
	history = player.ConHistory;

	while( history != None )
	{
		rowIndex = lstCons.AddRow( history.conOwnerName $ ";" $ history.strLocation );

		if (history.bInfoLink)
			lstCons.SetField(rowIndex, 2, "B");
		else
			lstCons.SetField(rowIndex, 2, "A");

		lstCons.SetRowClientObject(rowIndex, history);

		history = history.next;
	}
}

// ----------------------------------------------------------------------
// CreateConversationWindow()
//
// Creates the lower window that displays an individual conversation
// ----------------------------------------------------------------------

function CreateConversationWindow()
{
	conWindow = CreateScrollTileWindow(16, 190, 394, 204);
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	local PersonaButtonBarWindow winButtonBar;

	winButtonBar = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	winButtonBar.SetPos(14, 19);
	winButtonBar.SetWidth(402);
	winButtonBar.FillAllSpace(False);

	btnType     = CreateBarButton(winButtonBar,  46, TypeButtonLabel);
	btnLocation = CreateBarButton(winButtonBar, 194, LocationButtonLabel);
	btnActor    = CreateBarButton(winButtonBar, 162, ActorButtonLabel);
}

// ----------------------------------------------------------------------
// CreateBarButton()
// ----------------------------------------------------------------------

function PersonaActionButtonWindow CreateBarButton(
	Window winParent, 
	int buttonWidth, 
	string buttonLabel)
{
	local PersonaButtonBarWindow winButtonBar;
	local PersonaActionButtonWindow newButton;

	newButton = PersonaActionButtonWindow(winParent.NewChild(Class'PersonaActionButtonWindow'));
	newButton.SetWidth(buttonWidth);
	newButton.SetButtonText(buttonLabel);

	return newButton;
}

// ----------------------------------------------------------------------
// ListSelectedChanged()
//
// When the user clicks on a conversation, display it in the bottom
// window
// ----------------------------------------------------------------------

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
	local ConHistory history;

	history = ConHistory(ListWindow(list).GetRowClientObject(focusRowId));
	DisplayHistory(history);

	return True;
}

// ----------------------------------------------------------------------
// DisplayHistory()
//
// Displays the history passed in in the Conversation History Window
// ----------------------------------------------------------------------

function DisplayHistory(ConHistory history)
{
	local ConHistoryEvent event;
	local PersonaHeaderTextWindow txtName;
	local PersonaNormalTextWindow txtSpeech;

	// First clear out any existing windows in the tile window
	conWindow.DestroyAllChildren();

	// Now loop through all the events, creating a TextWindow
	// for each.  

	event = history.firstEvent;
	while(event != None)
	{
		// First create a window for the name
		txtName = PersonaHeaderTextWindow(conWindow.NewChild(Class'PersonaHeaderTextWindow'));
		txtName.SetTextMargins(5, 2);
		txtName.SetText(event.conSpeaker);

		// Now create a window for the text
		txtSpeech = PersonaNormalTextWindow(conWindow.NewChild(Class'PersonaNormalTextWindow'));
		txtSpeech.SetTextMargins(10, 2);
		txtSpeech.SetText(event.speech);

		// If there's another event, create an empty window for spacing
		if (event.next != None)
		{
			txtSpeech = PersonaNormalTextWindow(conWindow.NewChild(Class'PersonaNormalTextWindow'));
			txtSpeech.SetSize(10, 5);
			txtSpeech.SetSensitivity(False);		// Can't be selected
		}

		// Continue on to the next event
		event = event.next;
	}
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	if (Super.ButtonActivated(buttonPressed))
		return True;

	bHandled   = True;

	switch(buttonPressed)
	{
		case btnActor:
			SetSortColumn(0);
			break;

		case btnLocation:
			SetSortColumn(1);
			break;

		case btnType:
			SetSortColumn(2);
			break;

		default:
			bHandled = False;
			break;
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// SetSortColumn()
// ----------------------------------------------------------------------

function SetSortColumn(int newSortColumn)
{
	if (newSortColumn == sortColumn)
		bSortReverse = !bSortReverse;
	else
		bSortReverse = False;

	sortColumn = newSortColumn;

	lstCons.ResetSortColumns(False);
	lstCons.SetSortColumn(newSortColumn, bSortReverse);

	// Update the button

	lstCons.Sort();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ConversationsTitleText="Conversations"
     ActorButtonLabel="Contact"
     LocationButtonLabel="Location"
     TypeButtonLabel="Type"
     ClientWidth=426
     ClientHeight=407
     clientOffsetX=105
     clientOffsetY=17
     clientTextures(0)=Texture'DeusExUI.UserInterface.ConversationsBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.ConversationsBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.ConversationsBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.ConversationsBackground_4'
     clientBorderTextures(0)=Texture'DeusExUI.UserInterface.ConversationsBorder_1'
     clientBorderTextures(1)=Texture'DeusExUI.UserInterface.ConversationsBorder_2'
     clientBorderTextures(2)=Texture'DeusExUI.UserInterface.ConversationsBorder_3'
     clientBorderTextures(3)=Texture'DeusExUI.UserInterface.ConversationsBorder_4'
     clientBorderTextures(4)=Texture'DeusExUI.UserInterface.ConversationsBorder_5'
     clientBorderTextures(5)=Texture'DeusExUI.UserInterface.ConversationsBorder_6'
     clientTextureRows=2
     clientTextureCols=2
     clientBorderTextureRows=2
     clientBorderTextureCols=3
}
