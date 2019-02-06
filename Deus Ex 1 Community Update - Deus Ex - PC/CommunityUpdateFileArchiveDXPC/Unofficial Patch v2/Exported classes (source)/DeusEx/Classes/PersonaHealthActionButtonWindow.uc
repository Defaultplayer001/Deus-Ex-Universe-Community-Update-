//=============================================================================
// PersonaHealthActionButtonWindow
//=============================================================================

class PersonaHealthActionButtonWindow extends PersonaBorderButtonWindow;

var localized String HealButtonLabel;
var int partIndex;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(66, 13);
	SetButtonText(HealButtonLabel);	
}

// ----------------------------------------------------------------------
// SetPartIndex()
// ----------------------------------------------------------------------

function SetPartIndex(int newPartIndex)
{
	partIndex = newPartIndex;
}

// ----------------------------------------------------------------------
// GetPartIndex()
// ----------------------------------------------------------------------

function int GetPartIndex()
{
	return partIndex;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HealButtonLabel="Heal"
     Left_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.HealthButtonNormal_Left',Width=4)
     Left_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.HealthButtonPressed_Left',Width=4)
     Right_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.HealthButtonNormal_Right',Width=8)
     Right_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.HealthButtonPressed_Right',Width=8)
     Center_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.HealthButtonNormal_Center',Width=2)
     Center_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.HealthButtonPressed_Center',Width=2)
     buttonHeight=13
     minimumButtonWidth=66
}
