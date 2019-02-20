//=============================================================================
// PersonaScreenGoals
//=============================================================================

class PersonaScreenGoals extends PersonaScreenBaseWindow;

// Goal Items
var TileWindow             winGoals;
var PersonaCheckBoxWindow  chkShowCompletedGoals;
var Bool                   bDisplayCompletedGoals;

var localized String       GoalsTitleText;
var localized String       PrimaryGoalsHeader;
var localized String       SecondaryGoalsHeader;
var localized String       DisplayCompletedGoals;
var localized String       NoGoalsLabel;
var localized String       GoalCompletedText;

// Note Items
var TileWindow                winNotes;
var PersonaCheckBoxWindow     chkConfirmNoteDeletion;
var Bool                      bConfirmNoteDeletes;
var localized String          NotesTitleText;
var PersonaActionButtonWindow btnAddNote;
var PersonaActionButtonWindow btnDeleteNote;
var PersonaNotesEditWindow    currentNoteWindow;
var PersonaNotesEditWindow    firstNoteWindow;

var localized string defaultNoteText;
var localized string ClickToEditNote;
var localized string DeleteNoteTitle;
var localized string DeleteNotePrompt;
var localized string AddButtonLabel;
var localized string DeleteButtonLabel;
var localized string ConfirmNoteDeletionLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	PopulateGoals();
	PopulateNotes();

	PersonaNavBarWindow(winNavBar).btnGoals.SetSensitivity(False);

	// Set focus to the AddNote button
	SetFocusWindow(btnAddNote);

	EnableButtons();
}

// ----------------------------------------------------------------------
// WindowReady() 
// ----------------------------------------------------------------------

event WindowReady()
{
	// Make sure the most recent note is scrolled to the top
	if (firstNoteWindow != None)
		firstNoteWindow.AskParentToShowArea();
}

// ----------------------------------------------------------------------
// DestroyWindow()
// ----------------------------------------------------------------------

event DestroyWindow()
{
	player.bDisplayCompletedGoals = bDisplayCompletedGoals;
	player.bConfirmNoteDeletes    = bConfirmNoteDeletes;
	player.SaveConfig();

	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	CreateTitleWindow(9,   5, GoalsTitleText);
	CreateTitleWindow(9, 209, NotesTitleText);

	winGoals = CreateScrollTileWindow(16,  21, 574, 154);

	winNotes = CreateScrollTileWindow(16, 226, 574, 182);
	winNotes.SetMinorSpacing(4);

	CreateShowCompletedGoalsCheckbox();
	CreateNotesButtons();
	CreateConfirmNoteDeletionCheckbox();
}

// ----------------------------------------------------------------------
// CreateShowCompletedGoalsCheckbox()
// ----------------------------------------------------------------------

function CreateShowCompletedGoalsCheckbox()
{
	chkShowCompletedGoals = PersonaCheckBoxWindow(winClient.NewChild(Class'PersonaCheckBoxWindow'));

	bDisplayCompletedGoals = player.bDisplayCompletedGoals;

	chkShowCompletedGoals.SetText(DisplayCompletedGoals);
	chkShowCompletedGoals.SetToggle(bDisplayCompletedGoals);
	chkShowCompletedGoals.SetWindowAlignments(HALIGN_Right, VALIGN_Top, 13, 180);
}

// ----------------------------------------------------------------------
// CreateNotesButtons()
// ----------------------------------------------------------------------

function CreateNotesButtons()
{
	local PersonaButtonBarWindow winActionButtons;

	winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(10, 411);
	winActionButtons.SetWidth(179);
	winActionButtons.FillAllSpace(False);

	btnAddNote = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnAddNote.SetButtonText(AddButtonLabel);

	btnDeleteNote = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnDeleteNote.SetButtonText(DeleteButtonLabel);
}


// ----------------------------------------------------------------------
// CreateConfirmNoteDeletionCheckbox()
// ----------------------------------------------------------------------

function CreateConfirmNoteDeletionCheckbox()
{
	chkConfirmNoteDeletion = PersonaCheckBoxWindow(winClient.NewChild(Class'PersonaCheckBoxWindow'));

	bConfirmNoteDeletes = player.bConfirmNoteDeletes;

	chkConfirmNoteDeletion.SetText(ConfirmNoteDeletionLabel);
	chkConfirmNoteDeletion.SetToggle(bConfirmNoteDeletes);
	chkConfirmNoteDeletion.SetWindowAlignments(HALIGN_Right, VALIGN_Top, 13, 412);
}

// ----------------------------------------------------------------------
// PopulateGoals()
// ----------------------------------------------------------------------

function PopulateGoals()
{
	// First clear out any existing goals in the two tile windows
	winGoals.DestroyAllChildren();

	PopulateGoalsByType(True,  PrimaryGoalsHeader);
	PopulateGoalsByType(False, SecondaryGoalsHeader);
}

// ----------------------------------------------------------------------
// PopulateGoalsByType()
// ----------------------------------------------------------------------

function PopulateGoalsByType(Bool bPrimaryGoals, String goalHeaderText)
{
	local DeusExGoal goal;
	local bool bGoalsFound;
	local PersonaGoalItemWindow goalWindow;
	local PersonaHeaderTextWindow goalHeader;

	// Create Goals Header
	goalHeader = PersonaHeaderTextWindow(winGoals.NewChild(Class'PersonaHeaderTextWindow'));
	goalHeader.SetTextAlignments(HALIGN_Left, VALIGN_Center);
	goalHeader.SetText(goalHeaderText);

	// Loop through all the Goals
	goal = player.FirstGoal;
	while( goal != None )
	{
		// Check if this is a primary or secondary goal as specified
		// in the bPrimaryGoals parameter above.

		if (bPrimaryGoals == goal.bPrimaryGoal)
		{
			// Check to see if this goal has already been marked as Completed,
			// and if so, only display if the chkShowCompletedGoals is true.

			if ((!goal.bCompleted) || ((goal.bCompleted) && (chkShowCompletedGoals.GetToggle())))
			{
				bGoalsFound = True;

				// Now create a window for the text
				goalWindow = PersonaGoalItemWindow(winGoals.NewChild(Class'PersonaGoalItemWindow'));

				// Set goal properties
				if (goal.bCompleted)
					goalWindow.SetGoalProperties(goal.bPrimaryGoal, goal.bCompleted, goal.text @ GoalCompletedText);
				else
					goalWindow.SetGoalProperties(goal.bPrimaryGoal, goal.bCompleted, goal.text);
			}
		}

		// Continue on to the next goal
		goal = goal.next;
	}

	// If there are no goals of this type, then print "None"
	if (!bGoalsFound)
	{
		// Now create a window for the text
		goalWindow = PersonaGoalItemWindow(winGoals.NewChild(Class'PersonaGoalItemWindow'));
		goalWindow.SetGoalProperties(bPrimaryGoals, True, NoGoalsLabel, True);
	}
}	

// ----------------------------------------------------------------------
// PopulateNotes()
//
// Loops through all the notes and displays them 
// ----------------------------------------------------------------------

function PopulateNotes()
{
	local PersonaNotesEditWindow noteWindow;
	local DeusExNote note;
	local bool   bWasVisible;

	// Hide the notes, so we don't flood the tile window with ConfigureChanged() events
	bWasVisible = winNotes.IsVisible(FALSE);
	winNotes.Hide();

	// First make sure there aren't already notes
	winNotes.DestroyAllChildren();

	// Loop through all the notes
	note = player.FirstNote;
	while(note != None)
	{
		noteWindow = CreateNoteEditWindow( note );

		if (firstNoteWindow == None)
			firstNoteWindow = noteWindow;

		// Continue on to the next note
		note = note.next;
	}

	// Show the notes again, if they were visible before
	winNotes.Show(bWasVisible);
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
		case btnAddNote:
			AddNote();
			break;

		case btnDeleteNote:
			if (bConfirmNoteDeletes)
			{
				root.MessageBox(DeleteNoteTitle, DeleteNotePrompt, 0, False, Self);
			}
			else
			{
				DeleteNote(currentNoteWindow);
				currentNoteWindow = None;
				EnableButtons();
			}				
			break;

		default:
			bHandled = False;
			break;
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// FocusEnteredDescendant()
// ----------------------------------------------------------------------

event FocusEnteredDescendant(Window enterWindow)
{
	// Ignore this even if we're deleting
	if (PersonaNotesEditWindow(enterWindow) != None) 
	{
		currentNoteWindow = PersonaNotesEditWindow(enterWindow);
		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// FocusLeftDescendant()
//
// Save the contents of the text window into the Notes window, 
// but only if the note has changed.
// ----------------------------------------------------------------------

event FocusLeftDescendant(Window leaveWindow)
{
	local PersonaNotesEditWindow noteWindow;

	noteWindow = PersonaNotesEditWindow(leaveWindow);

	if (noteWindow != None)
		SaveNote(noteWindow);
}

// ----------------------------------------------------------------------
// SaveNote()
// ----------------------------------------------------------------------

function SaveNote(PersonaNotesEditWindow noteWindow)
{
	local DeusExNote note;

	if ( noteWindow.HasTextChanged() )
	{
		note      = noteWindow.GetNote();
		note.text = noteWindow.GetText();
		noteWindow.ClearTextChangedFlag();
	}
}

// ----------------------------------------------------------------------
// BoxOptionSelected()
// ----------------------------------------------------------------------

event bool BoxOptionSelected(Window msgBoxWindow, int buttonNumber)
{
	// Nuke the msgbox
	root.PopWindow();

	if ( buttonNumber == 0 ) 
	{
		DeleteNote(currentNoteWindow);
		currentNoteWindow = None;
		EnableButtons();
	}

	return true;
}

// ----------------------------------------------------------------------
// AddNote()
//
// Creates a new edit window at the end of the tile window, allowing
// the user to enter a new note.  
// ----------------------------------------------------------------------

function AddNote()
{
	local DeusExNote newNote;
	local PersonaNotesEditWindow newNoteWindow;

	// Create a new note and then a window to display it in
	newNote = player.AddNote(defaultNoteText, True);

	newNoteWindow = CreateNoteEditWindow(newNote);
	newNoteWindow.Lower();
	newNoteWindow.SetSelectedArea(0, Len(defaultNoteText));
	SetFocusWindow(newNoteWindow);
}

// ----------------------------------------------------------------------
// DeleteNote()
//
// Deletes the specified note
// ----------------------------------------------------------------------

function DeleteNote(PersonaNotesEditWindow noteWindow)
{
	if (noteWindow == None)
		return;

	// Remove it from the collection
	player.DeleteNote(noteWindow.GetNote());

	// Now remove it from the list
	noteWindow.Destroy();

	// Set focus to the Delete button
	SetFocusWindow(btnAddNote);
}

// ----------------------------------------------------------------------
// ToggleChanged()
//
// Called when a note is clicked on
// ----------------------------------------------------------------------

event bool ToggleChanged(Window button, bool bNewToggle)
{
	if (button.IsA('PersonaNotesEditWindow'))
	{
		EnableButtons();
	}
	else if (button == chkShowCompletedGoals)
	{
		bDisplayCompletedGoals = bNewToggle;
		PopulateGoals();
	}
	else if (button == chkConfirmNoteDeletion)
	{
		bConfirmNoteDeletes = bNewToggle;
	}

	return True;
}

// ----------------------------------------------------------------------
// Creates a note edit window
// ----------------------------------------------------------------------

function PersonaNotesEditWindow CreateNoteEditWindow(DeusExNote note)
{
	local PersonaNotesEditWindow newNoteWindow;

	newNoteWindow = PersonaNotesEditWindow(winNotes.NewChild(Class'PersonaNotesEditWindow'));
	newNoteWindow.SetNote(note);
	
	return newNoteWindow;
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	btnDeleteNote.SetSensitivity(currentNoteWindow != None);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     GoalsTitleText="Goals"
     PrimaryGoalsHeader="Primary Goals"
     SecondaryGoalsHeader="Secondary Goals"
     DisplayCompletedGoals="Display C|&ompleted Goals"
     NoGoalsLabel="None"
     GoalCompletedText="[Completed]"
     NotesTitleText="Notes"
     defaultNoteText="New Note"
     ClickToEditNote="Click on a Note to edit it:"
     DeleteNoteTitle="Delete Note?"
     DeleteNotePrompt="Are you sure you wish to delete this note?"
     AddButtonLabel="Add |&Note"
     DeleteButtonLabel="|&Delete Note"
     ConfirmNoteDeletionLabel="Confirm Note Deletion"
     clientBorderOffsetY=29
     ClientWidth=604
     ClientHeight=433
     clientOffsetX=15
     clientOffsetY=10
     clientTextures(0)=Texture'DeusExUI.UserInterface.GoalsBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.GoalsBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.GoalsBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.GoalsBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.GoalsBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.GoalsBackground_6'
     clientBorderTextures(0)=Texture'DeusExUI.UserInterface.GoalsBorder_1'
     clientBorderTextures(1)=Texture'DeusExUI.UserInterface.GoalsBorder_2'
     clientBorderTextures(2)=Texture'DeusExUI.UserInterface.GoalsBorder_3'
     clientBorderTextures(3)=Texture'DeusExUI.UserInterface.GoalsBorder_4'
     clientBorderTextures(4)=Texture'DeusExUI.UserInterface.GoalsBorder_5'
     clientBorderTextures(5)=Texture'DeusExUI.UserInterface.GoalsBorder_6'
     clientTextureRows=2
     clientTextureCols=3
     clientBorderTextureRows=2
     clientBorderTextureCols=3
}
