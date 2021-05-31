//=============================================================================
// PersonaImageWindow
//=============================================================================

class PersonaImageWindow expands PersonaBaseWindow;

// Input system states.
enum ENoteMode
{
	NM_Normal,		// Normal, not doing anything with notes
	NM_PreAdd,		// About to add a note
	NM_Adding		// Adding a note now
};

var DataVaultImage image;
var DeusExRootWindow root;
var Font fontNoImages;
var Color colTextNoImages;
var int imageSizeX;
var int imageSizeY;
var PersonaImageNoteWindow currentNoteWindow;
var ENoteMode noteMode;
var Bool bShowNotes;

var localized string strNoImages;
var localized string PressSpace;
var localized string EscapeToCancel;
var localized string NewNoteLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(imageSizeX, imageSizeY);

	// Get a pointer to the root window
	root = DeusExRootWindow(GetRootWindow());
}

// ----------------------------------------------------------------------
// DrawWindow()
//
// Draws all the image.  If no image available, then draws the text, 
// "No Images Available" instead.
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	if ( image == None )
	{
		gc.SetHorizontalAlignment(HALIGN_Center);
		gc.SetVerticalAlignment(VALIGN_Center);
		gc.SetFont(fontNoImages);
		gc.SetTextColor(colTextNoImages);
		gc.DrawText(0, 0, width, height, strNoImages);
	}
	else
	{
		gc.SetStyle(DSTY_Normal);

		gc.DrawTexture(  0,   0, 256, 256, 0, 0, image.imageTextures[0]);
		gc.DrawTexture(256,   0, 144, 256, 0, 0, image.imageTextures[1]);
		gc.DrawTexture(  0, 256, 256, 144, 0, 0, image.imageTextures[2]);
		gc.DrawTexture(256, 256, 144, 144, 0, 0, image.imageTextures[3]);
	}	
}

// ----------------------------------------------------------------------
// FocusEnteredDescendant()
// ----------------------------------------------------------------------

event FocusEnteredDescendant(Window enterWindow)
{
	// Ignore this even if we're deleting
	if ( PersonaImageNoteWindow(enterWindow) != None ) 
	{
		if ( currentNoteWindow != None )
			currentNoteWindow.SetNormalColors();

		currentNoteWindow = PersonaImageNoteWindow(enterWindow);
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
	local PersonaImageNoteWindow noteWindow;

	noteWindow = PersonaImageNoteWindow(leaveWindow);

	if ( noteWindow != None )
		SaveNote(noteWindow);
}

// ----------------------------------------------------------------------
// MouseButtonReleased()
//
// If the user clicks the mouse button and we're in "Add Note Mode", 
// then create a new note window where the user clicks with the mouse.
// ----------------------------------------------------------------------

event bool MouseButtonReleased(float pointX, float pointY, EInputKey button, int numClicks)
{
	local DataVaultImageNote imageNote;
	local PersonaImageNoteWindow editNote;
	local Bool bHandled;
	local int clipX, clipY;

	bHandled = False;

	// Get the hell out of here if there's no image
	if (image == None)
		return bHandled;

	switch( noteMode )
	{
		case NM_Normal:		
			break;

		case NM_PreAdd:
			// Create a new ImageNote, then add it to the list of notes
			// for this image.

			imageNote = player.CreateDataVaultImageNoteObject();
			imageNote.posX = pointX;
			imageNote.posY = pointY;
			imageNote.noteText = NewNoteLabel;
			image.AddNote(imageNote);	

			// Now create an edit control that will be the visual representation 
			// of this note.

			ClipWindow(GetParent()).GetChildPosition(clipX, clipY);
			editNote = PersonaImageNoteWindow(NewChild(Class'PersonaImageNoteWindow'));
			editNote.SetNote(imageNote);
			ClipWindow(GetParent()).SetChildPosition(clipX, clipY);

			currentNoteWindow = editNote;

			SetFocusWindow(editNote);
			editNote.SetSelectedArea(0, Len(NewNoteLabel));

			bHandled = True;
			noteMode = NM_Adding;
			break;

		case NM_Adding:
			break;
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// If the user presses Escape while editing a note, save it and 
// release the mouse.
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bHandled;
	bHandled = False;

	switch( key ) 
	{
		case IK_Escape:
			if ( noteMode == NM_PreAdd )
			{
				noteMode = NM_Normal;
				bHandled = True;
			}
			else if ( noteMode == NM_Adding )
			{
				// Check to see if the note has changed.  If the 
				// user didn't change the default text, then just
				// ABORT!
				if ((currentNoteWindow.GetText() != NewNoteLabel) && (currentNoteWindow.GetText() != ""))
					SaveNote(currentNoteWindow);
				else
					DeleteNote();

				noteMode = NM_Normal;
				bHandled = True;
			}
			break;
	}

	if ( !bHandled )
		return Super.VirtualKeyPressed(key, bRepeat);
	else
		return bHandled;
}

// ----------------------------------------------------------------------
// SetImage()
// 
// Sets the image associated with this window and resizes accordingly.
// Then goes through all the notes and adds them as appopriate
// ----------------------------------------------------------------------

function SetImage(DataVaultImage newImage)
{
	image = newImage;
	currentNoteWindow = None;

	// First nuke any existing note buttons
	DeleteNoteWindows();

	if ( image != None )
	{
		// Create all the notes
		CreateNotes();
	}
}

// ----------------------------------------------------------------------
// GetImage()
//
// Returns the image currently associated with this window
// ----------------------------------------------------------------------

function DataVaultImage GetImage()
{
	return image;
}

// ----------------------------------------------------------------------
// CreateNotes()
//
// Loops through all the notes for this image and creates an EditWindow
// for each of them.
// ----------------------------------------------------------------------

function CreateNotes()
{
	local DataVaultImageNote imageNote;
	local PersonaImageNoteWindow editNote;

	imageNote = image.firstNote;

	while( imageNote != None )
	{
		editNote = PersonaImageNoteWindow(NewChild(Class'PersonaImageNoteWindow'));
		
		editNote.SetNote(imageNote);
		editNote.Show(bShowNotes);

		imageNote = imageNote.nextNote;
	}
}

// ----------------------------------------------------------------------
// DeleteNoteWindows()
// 
// Deletes any note edit windows
// ----------------------------------------------------------------------

function DeleteNoteWindows()
{
	local Window window;
	local Window nextWindow;

	window = GetTopChild();
	while( window != None )
	{
		nextWindow = window.GetLowerSibling();

		if (PersonaImageNoteWindow(window) != None)
			window.Destroy();

		window = nextWindow;
	}
}

// ----------------------------------------------------------------------
// IsNoteSelected()
// ----------------------------------------------------------------------

function Bool IsNoteSelected()
{
	return currentNoteWindow != None;	
}

// ----------------------------------------------------------------------
// SaveNote()
// ----------------------------------------------------------------------

function SaveNote(PersonaImageNoteWindow noteWindow)
{
	local DataVaultImageNote imageNote;

	if ( noteWindow.HasTextChanged() )
	{	
		imageNote = DataVaultImageNote(noteWindow.GetClientObject());
		imageNote.noteText = noteWindow.GetText();
	}
}	

// ----------------------------------------------------------------------
// DeleteNote()
//
// Delete the currently selected note
// ----------------------------------------------------------------------

function DeleteNote()
{
	if ( currentNoteWindow != None )
	{
		image.DeleteNote(DataVaultImageNote(currentNoteWindow.GetClientObject()) );
		currentNoteWindow.Destroy();
		currentNoteWindow = None;
	}
}

// ----------------------------------------------------------------------
// ShowNotes()
//
// Hide or show all the notes
// ----------------------------------------------------------------------

function ShowNotes(bool bNewShowNotes)
{
	local Window window;
	local Window nextWindow;

	bShowNotes = bNewShowNotes;

	if (image != None)
	{
		window = GetTopChild(False);
		while( window != None )
		{
			nextWindow = window.GetLowerSibling(False);

			if (PersonaImageNoteWindow(window) != None)
				window.Show(bShowNotes);

			window = nextWindow;
		}
	}
}

// ----------------------------------------------------------------------
// SetAddNoteMode()
// ----------------------------------------------------------------------

function SetAddNoteMode(Bool bNewAddMode)
{
	noteMode = NM_PreAdd;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     fontNoImages=Font'DeusExUI.FontMenuHeaders'
     colTextNoImages=(R=255,G=255,B=255)
     imageSizeX=400
     imageSizeY=400
     bShowNotes=True
     strNoImages="No Images Available"
     PressSpace="Press [ESCAPE] when finished editing note"
     EscapeToCancel="Click on image to create note, press [ESCAPE] to cancel"
     NewNoteLabel="New Note"
}
