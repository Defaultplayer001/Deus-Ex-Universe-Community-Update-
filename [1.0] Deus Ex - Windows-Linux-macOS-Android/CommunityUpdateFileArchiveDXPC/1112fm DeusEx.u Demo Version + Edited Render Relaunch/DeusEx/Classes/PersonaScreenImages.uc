//=============================================================================
// PersonaScreenImages
//=============================================================================

class PersonaScreenImages extends PersonaScreenBaseWindow;

var PersonaActionButtonWindow btnAddNote;
var PersonaActionButtonWindow btnDeleteNote;

var PersonaCheckBoxWindow     chkShowNotes;
var PersonaListWindow         lstImages;
var PersonaScrollAreaWindow   winScroll;
var PersonaHeaderTextWindow   winImageTitle;
var PersonaImageWindow        winImage;

var localized String ImagesTitleText;
var localized String DeleteNoteButtonLabel;
var localized String AddNoteButtonLabel;
var localized String ShowNotesLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	PopulateImagesList();
	SetFocusWindow(lstImages);

	PersonaNavBarWindow(winNavBar).btnImages.SetSensitivity(False);

	EnableButtons();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	CreateTitleWindow(9, 5, ImagesTitleText);
	CreateImageWindow();
	CreateImagesList();
	CreateImageTitle();
	CreateButtons();
	CreateShowNotesCheckbox();
	CreateNewLegendLabel();
}

// ----------------------------------------------------------------------
// CreateImageWindow()
// ----------------------------------------------------------------------

function CreateImageWindow()
{
	winImage = PersonaImageWindow(winClient.NewChild(Class'PersonaImageWindow'));
	winImage.SetPos(15, 20);
}

// ----------------------------------------------------------------------
// CreateImageTitle()
// ----------------------------------------------------------------------

function CreateImageTitle()
{
	winImageTitle = PersonaHeaderTextWindow(winClient.NewChild(Class'PersonaHeaderTextWindow'));
	winImageTitle.SetPos(214, 6);
	winImageTitle.SetWidth(200);
	winImageTitle.SetTextAlignments(HALIGN_Right, VALIGN_Center);
}

// ----------------------------------------------------------------------
// CreateImagesList()
// ----------------------------------------------------------------------

function CreateImagesList()
{
	winScroll = CreateScrollAreaWindow(winClient);
	winScroll.SetPos(417, 21);
	winScroll.SetSize(184, 398);

	lstImages = PersonaListWindow(winScroll.clipWindow.NewChild(Class'PersonaListWindow'));
	lstImages.EnableMultiSelect(False);
	lstImages.EnableAutoExpandColumns(True);
	lstImages.SetNumColumns(3);
	lstImages.HideColumn(2, True);
	lstImages.SetSortColumn(0, True);
	lstImages.EnableAutoSort(False);
	lstImages.SetColumnWidth(0, 150);
	lstImages.SetColumnWidth(1, 34);
	lstImages.SetColumnType(2, COLTYPE_Float);
	lstImages.SetColumnFont(1, Font'FontHUDWingDings');
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	local PersonaButtonBarWindow winActionButtons;

	winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(10, 422);
	winActionButtons.SetWidth(259);
	winActionButtons.FillAllSpace(False);

	btnAddNote = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnAddNote.SetButtonText(AddNoteButtonLabel);

	btnDeleteNote = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnDeleteNote.SetButtonText(DeleteNoteButtonLabel);
}

// ----------------------------------------------------------------------
// CreateShowNotesCheckbox()
// ----------------------------------------------------------------------

function CreateShowNotesCheckbox()
{
	chkShowNotes = PersonaCheckBoxWindow(winClient.NewChild(Class'PersonaCheckBoxWindow'));

	chkShowNotes.SetWindowAlignments(HALIGN_Right, VALIGN_Top, 203, 424);
	chkShowNotes.SetText(ShowNotesLabel);
	chkShowNotes.SetToggle(True);
}

// ----------------------------------------------------------------------
// CreateNewLegendLabel()
// ----------------------------------------------------------------------

function CreateNewLegendLabel()
{	
	local PersonaImageNewLegendLabel newLabel;

	newLabel = PersonaImageNewLegendLabel(winClient.NewChild(Class'PersonaImageNewLegendLabel'));
	newLabel.SetWindowAlignments(HALIGN_Right, VALIGN_Top, 13, 424);
}

// ----------------------------------------------------------------------
// PopulateImagesList()
// ----------------------------------------------------------------------

function PopulateImagesList()
{
	local DataVaultImage image;
	local int rowId;

	// First clear the list
	lstImages.DeleteAllRows();

	// Loop through all the notes the player currently has in 
	// his possession

	image = Player.FirstImage;
	while(image != None)
	{
		rowId = lstImages.AddRow(image.imageDescription);

		// Check to see if we need to display *New* in the second column
		if (image.bPlayerViewedImage == False)
			lstImages.SetField(rowId, 1, "C");

		// Save the image away
		lstImages.SetRowClientObject(rowId, image);

		image = image.NextImage;
	}
}

// ----------------------------------------------------------------------
// ClearViewedImageFlags()
//
// Loops through all the images and clears the "bPlayerViewedImage" 
// flag for any the player happened to look at.
// ----------------------------------------------------------------------

function ClearViewedImageFlags()
{
	local DataVaultImage image;
	local int listIndex;
	local int rowId;

	for(listIndex=0; listIndex<lstImages.GetNumRows(); listIndex++)
	{
		rowId = lstImages.IndexToRowId(listIndex);

		if (lstImages.GetFieldValue(rowId, 2) > 0)
		{
			image = DataVaultImage(lstImages.GetRowClientObject(rowId));
			image.bPlayerViewedImage = True;
		}
	}
}

// ----------------------------------------------------------------------
// SetImage()
// ----------------------------------------------------------------------

function SetImage(DataVaultImage newImage)
{
	winImage.SetImage(newImage);

	if ( newImage == None )
		winImageTitle.SetText("");
	else
		winImageTitle.SetText(newImage.imageDescription);

	EnableButtons();
}

// ----------------------------------------------------------------------
// ListSelectionChanged() 
// ----------------------------------------------------------------------

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
	SetImage(DataVaultImage(lstImages.GetRowClientObject(focusRowId)));

	// Set a flag to later clear the "*New*" in the second column
	lstImages.SetFieldValue(focusRowId, 2, 1);

	return True;
}

// ----------------------------------------------------------------------
// FocusEnteredDescendant()
// ----------------------------------------------------------------------

event FocusEnteredDescendant(Window enterWindow)
{
	EnableButtons();
}

// ----------------------------------------------------------------------
// FocusLeftDescendant()
// ----------------------------------------------------------------------

event FocusLeftDescendant(Window leaveWindow)
{
	EnableButtons();
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	bHandled = True;

	switch(buttonPressed)
	{
		case btnAddNote:
			AddNote();
			break;

		case btnDeleteNote:
			DeleteNote();
			break;

		default:
			bHandled = False;
			break;
	}

	if ( !bHandled )
		bHandled = Super.ButtonActivated(buttonPressed);

	return bHandled;
}

// ----------------------------------------------------------------------
// ToggleChanged()
//
// Called when the user clicks on the checkbox
// ----------------------------------------------------------------------

event Bool ToggleChanged(window button, bool bToggleValue)
{
	if (button == chkShowNotes)
		ShowNotes(bToggleValue);
}

// ----------------------------------------------------------------------
// AddNote()
//
// Creates a new note where the user next clicks.
// ----------------------------------------------------------------------

function AddNote()
{
	// Set a variable so the next place the user clicks inside the 
	// imgae window a new note is added. 
	winImage.SetAddNoteMode(True);

	EnableButtons();
}

// ----------------------------------------------------------------------
// DeleteNote()
// ----------------------------------------------------------------------

function DeleteNote()
{
	winImage.DeleteNote();
	EnableButtons();
}

// ----------------------------------------------------------------------
// ShowNotes()
// ----------------------------------------------------------------------

function ShowNotes(bool bNewShowNotes)
{
	if (winImage != None)
		winImage.ShowNotes(bNewShowNotes);
}

// ----------------------------------------------------------------------
// EnableButtons()
//
// Sets the state of the Add, Delete, Up and Down buttons
// ----------------------------------------------------------------------

function EnableButtons()
{
	local DataVaultImage image;

	image = winImage.GetImage();

	btnAddNote.SetSensitivity(image != None);
	btnDeleteNote.SetSensitivity(winImage.IsNoteSelected());
	chkShowNotes.SetSensitivity(image != None);
}

// ----------------------------------------------------------------------
// SaveSettings()
// ----------------------------------------------------------------------

function SaveSettings()
{
	DestroyImages();
	ClearViewedImageFlags();
}

// ----------------------------------------------------------------------
// DestroyImages()
//
// Unload texture memory used by the images
// ----------------------------------------------------------------------

function DestroyImages()
{
	local DataVaultImage image;
	local int listIndex;
	local int rowId;

	for(listIndex=0; listIndex<lstImages.GetNumRows(); listIndex++)
	{
		rowId = lstImages.IndexToRowId(listIndex);

		if (lstImages.GetFieldValue(rowId, 2) > 0)
		{
			image = DataVaultImage(lstImages.GetRowClientObject(rowId));

			if (image != None)
				image.UnloadTextures(player);
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ImagesTitleText="Images"
     DeleteNoteButtonLabel="|&Delete Note"
     AddNoteButtonLabel="Add |&Note"
     ShowNotesLabel="Show N|&otes"
     clientBorderOffsetY=35
     ClientWidth=617
     ClientHeight=439
     clientOffsetX=11
     clientOffsetY=2
     clientTextures(0)=Texture'DeusExUI.UserInterface.ImagesBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.ImagesBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.ImagesBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.ImagesBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.ImagesBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.ImagesBackground_6'
     clientBorderTextures(0)=Texture'DeusExUI.UserInterface.ImagesBorder_1'
     clientBorderTextures(1)=Texture'DeusExUI.UserInterface.ImagesBorder_2'
     clientBorderTextures(2)=Texture'DeusExUI.UserInterface.ImagesBorder_3'
     clientBorderTextures(3)=Texture'DeusExUI.UserInterface.ImagesBorder_4'
     clientBorderTextures(4)=Texture'DeusExUI.UserInterface.ImagesBorder_5'
     clientBorderTextures(5)=Texture'DeusExUI.UserInterface.ImagesBorder_6'
     clientTextureRows=2
     clientTextureCols=3
     clientBorderTextureRows=2
     clientBorderTextureCols=3
}
