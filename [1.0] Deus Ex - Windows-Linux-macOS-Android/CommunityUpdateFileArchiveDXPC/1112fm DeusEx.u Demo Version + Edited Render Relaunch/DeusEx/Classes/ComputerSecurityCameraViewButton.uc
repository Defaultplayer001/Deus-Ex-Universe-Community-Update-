//=============================================================================
// ComputerSecurityCameraViewButton
//=============================================================================
class ComputerSecurityCameraViewButton extends ButtonWindow;

var DeusExPlayer player;
var Bool         bSelected;
var Texture      texBorders[9];
var StaticWindow winStatic;

// Default Colors
var Color colSelectionBorder;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(202, 152);

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	CreateStaticWindow();
}

// ----------------------------------------------------------------------
// CreateStaticWindow()
// ----------------------------------------------------------------------

function CreateStaticWindow()
{
	// Window used to display static
	winStatic = StaticWindow(NewChild(Class'StaticWindow', False));
	winStatic.SetSize(200, 150);
	winStatic.RandomizeStatic();
	winStatic.SetPos(1, 1);
	winStatic.SetBackgroundStyle(DSTY_Modulated);
	winStatic.Raise();
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	// Draw selection border
	if (bSelected)
	{
		gc.SetTileColor(colSelectionBorder);
		gc.SetStyle(DSTY_Masked);
		gc.DrawBorders(0, 0, width, height, 0, 0, 0, 0, texBorders);
	}
}

// ----------------------------------------------------------------------
// SetStatic()
// ----------------------------------------------------------------------

function SetStatic()
{
	winStatic.Raise();
	winStatic.Show();
}

// ----------------------------------------------------------------------
// SelectButton()
// ----------------------------------------------------------------------

function SelectButton(Bool bNewSelected)
{
	bSelected = bNewSelected;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texBorders(0)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_TL'
     texBorders(1)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_TR'
     texBorders(2)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_BL'
     texBorders(3)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_BR'
     texBorders(4)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Left'
     texBorders(5)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Right'
     texBorders(6)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Top'
     texBorders(7)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Bottom'
     texBorders(8)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Center'
     colSelectionBorder=(R=255,G=255,B=255)
}
