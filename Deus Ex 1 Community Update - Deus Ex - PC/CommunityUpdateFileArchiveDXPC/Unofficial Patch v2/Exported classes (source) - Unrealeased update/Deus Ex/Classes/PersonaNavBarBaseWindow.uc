//=============================================================================
// PersonaNavBarBaseWindow
//=============================================================================
class PersonaNavBarBaseWindow expands PersonaBaseWindow;

// Keep a pointer to the root window handy
var DeusExRootWindow root;

var PersonaButtonBarWindow winNavButtons;
var PersonaButtonBarWindow winNavExit;

var PersonaNavButtonWindow btnExit;

var Texture texBackgrounds[3];
var Texture texBorders[3];

var int backgroundOffsetX;
var int backgroundOffsetY;

var localized String ExitButtonLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Get a pointer to the root window
	root = DeusExRootWindow(GetRootWindow());

	SetSize(640, 64);

	CreateButtonWindows();
	CreateButtons();
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
	gc.SetStyle(backgroundDrawStyle);
	gc.SetTileColor(colBackground);
	gc.DrawTexture(backgroundOffsetX,       backgroundOffsetY, 256, 21, 0, 0, texBackgrounds[0]);
	gc.DrawTexture(backgroundOffsetX + 256, backgroundOffsetY, 256, 21, 0, 0, texBackgrounds[1]);
	gc.DrawTexture(backgroundOffsetX + 512, backgroundOffsetY,  97, 21, 0, 0, texBackgrounds[2]);
}

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

function DrawBorder(GC gc)
{
	if (bDrawBorder)
	{
		gc.SetStyle(borderDrawStyle);
		gc.SetTileColor(colBorder);
		gc.DrawTexture(  0, 0, 256, height, 0, 0, texBorders[0]);
		gc.DrawTexture(256, 0, 256, height, 0, 0, texBorders[1]);
		gc.DrawTexture(512, 0, 175, height, 0, 0, texBorders[2]);
	}
}

// ----------------------------------------------------------------------
// CreateButtonWindow()
// ----------------------------------------------------------------------

function CreateButtonWindows()
{
	// Create the Inventory Items window
	winNavButtons = PersonaButtonBarWindow(NewChild(Class'PersonaButtonBarWindow'));

	winNavButtons.SetPos(23, 8);
	winNavButtons.SetSize(534, 16);
	winNavButtons.Lower();

	// Create the Inventory Items window
	winNavExit = PersonaButtonBarWindow(NewChild(Class'PersonaButtonBarWindow'));

	winNavExit.SetPos(573, 8);
	winNavExit.SetSize(48, 16);
	winNavExit.Lower();
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	btnExit = CreateNavButton(winNavExit, ExitButtonLabel);
}

// ----------------------------------------------------------------------
// CreateNavButton()
// ----------------------------------------------------------------------

function PersonaNavButtonWindow CreateNavButton(Window winParent, string buttonLabel)
{
	local PersonaNavButtonWindow newButton;

	newButton = PersonaNavButtonWindow(winParent.NewChild(Class'PersonaNavButtonWindow'));
	newButton.SetButtonText(buttonLabel);

	return newButton;
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
		case btnExit:
			PersonaScreenBaseWindow(GetParent()).SaveSettings();
			root.PopWindow();	
			break;

		default:
			bHandled = False;
			break;
	}

	if (bHandled)
		return bHandled;
	else
		return Super.ButtonActivated(buttonPressed);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texBackgrounds(0)=Texture'DeusExUI.UserInterface.PersonaNavBarBackground_1'
     texBackgrounds(1)=Texture'DeusExUI.UserInterface.PersonaNavBarBackground_2'
     texBackgrounds(2)=Texture'DeusExUI.UserInterface.PersonaNavBarBackground_3'
     texBorders(0)=Texture'DeusExUI.UserInterface.PersonaNavBarBorder_1'
     texBorders(1)=Texture'DeusExUI.UserInterface.PersonaNavBarBorder_2'
     texBorders(2)=Texture'DeusExUI.UserInterface.PersonaNavBarBorder_3'
     backgroundOffsetX=17
     backgroundOffsetY=6
     ExitButtonLabel="E|&xit"
}
