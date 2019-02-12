//=============================================================================
// ShowClassWindow
//=============================================================================
class ShowClassWindow expands ToolWindow;

// Class Name edit box
var ToolEditWindow editClassName;

// Checkboxes
var ToolCheckboxWindow	chkEyes;
var ToolCheckboxWindow	chkArea;
var ToolCheckboxWindow	chkCylinder;
var ToolCheckboxWindow	chkMesh;
var ToolCheckboxWindow	chkLOS;
var ToolCheckboxWindow	chkVisibility;
var ToolCheckboxWindow	chkState;
var ToolCheckboxWindow	chkLight;
var ToolCheckboxWindow	chkDist;
var ToolCheckboxWindow	chkPos;
var ToolCheckboxWindow	chkHealth;

// Buttons
var ToolButtonWindow btnCancel;  
var ToolButtonWindow btnOK;  

// Actor DisplayWindow
var ActorDisplayWindow actorDisplay;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	local String displayClass;

	Super.InitWindow();

	// Center this window	
	SetSize(215, 420);
	SetTitle("Show Class");

	// Get a pointer to the ActorDisplayWindow
	actorDisplay = root.actorDisplay;

	// Create the controls
	CreateControls();

	// Set focus to the edit control and highlight the text in it.
	if ( actorDisplay.GetViewClass() != None )
	{
		displayClass = String(actorDisplay.GetViewClass());
		editClassName.SetText(displayClass);
		editClassName.SetInsertionPoint(Len(displayClass) - 1);
		editClassName.SetSelectedArea(0, Len(displayClass));
	}
	SetFocusWindow(editClassName);
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	// Labels
	CreateToolLabel(18, 30, "Current View Class:");

	// Edit Control
	editClassName       = CreateToolEditWindow(15, 50, 185, 64);

	// Checkboxes
	chkEyes			= CreateToolCheckbox(15, 90,  "Show |&Eyes", actorDisplay.AreEyesVisible());
	chkArea			= CreateToolCheckbox(15, 115, "Show |&Area", actorDisplay.IsAreaVisible());
	chkCylinder		= CreateToolCheckbox(15, 140, "Show C|&ylinder", actorDisplay.IsCylinderVisible());
	chkMesh			= CreateToolCheckbox(15, 165, "Show |&Mesh", actorDisplay.IsMeshVisible());
	chkLOS          = CreateToolCheckbox(15, 190, "Show |&Line of Sight", actorDisplay.IsLOSVisible());
	chkVisibility   = CreateToolCheckbox(15, 215, "Show |&Visibility", actorDisplay.IsVisibilityVisible());
	chkState        = CreateToolCheckbox(15, 240, "Sho|&w State", actorDisplay.IsStateVisible());
	chkLight        = CreateToolCheckbox(15, 265, "Show Li|&ght Level", actorDisplay.IsLightVisible());
	chkDist         = CreateToolCheckbox(15, 290, "Show |&Distance", actorDisplay.IsDistVisible());
	chkPos          = CreateToolCheckbox(15, 315, "Show |&Position", actorDisplay.IsPosVisible());
	chkHealth       = CreateToolCheckbox(15, 340, "Show |&Health", actorDisplay.IsHealthVisible());
	
	// Buttons
	btnOK     = CreateToolButton(25,  373, "|&OK");
	btnCancel = CreateToolButton(118, 373, "|&Cancel");
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
		case btnOK:
			SaveSettings();
			root.PopWindow();
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
// EditActivated()
//
// Allow the user to press [Return] to accept the name
// ----------------------------------------------------------------------

event bool EditActivated(window edit, bool bModified)
{
	SaveSettings();
	root.PopWindow();
	return True;
}

// ----------------------------------------------------------------------
// SaveSettings()
// ----------------------------------------------------------------------

function SaveSettings()
{
	if ( editClassName.GetText() == "" )
		actorDisplay.SetViewClass(None);
	else
		// let UnrealScript parse the class name for us
		GetPlayerPawn().ConsoleCommand("ShowClass "$editClassName.GetText());

	actorDisplay.ShowEyes(chkEyes.GetToggle());
	actorDisplay.ShowArea(chkArea.GetToggle());
	actorDisplay.ShowCylinder(chkCylinder.GetToggle());
	actorDisplay.ShowMesh(chkMesh.GetToggle());
	actorDisplay.ShowLOS(chkLOS.GetToggle());
	actorDisplay.ShowVisibility(chkVisibility.GetToggle());
	actorDisplay.ShowState(chkState.GetToggle());
	actorDisplay.ShowLight(chkLight.GetToggle());
	actorDisplay.ShowDist(chkDist.GetToggle());
	actorDisplay.ShowPos(chkPos.GetToggle());
	actorDisplay.ShowHealth(chkHealth.GetToggle());
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
