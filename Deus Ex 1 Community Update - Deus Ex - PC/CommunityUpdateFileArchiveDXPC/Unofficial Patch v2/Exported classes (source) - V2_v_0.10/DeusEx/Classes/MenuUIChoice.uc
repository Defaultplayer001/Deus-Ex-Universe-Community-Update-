//=============================================================================
// MenuUIChoice
//=============================================================================

class MenuUIChoice extends Window
	abstract;

var MenuUIChoiceButton btnAction;
var DeusExPlayer player;				// Used for saving/loading/default

// Defaults
var int choiceControlPosX;
var int buttonVerticalOffset;

// Localized Strings
var localized String helpText;
var localized String actionText;
var localized String configSetting;        
var localized String FalseTrue[2];

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	player = DeusExPlayer(DeusExRootWindow(GetRootWindow()).parentPawn);

	SetSize(540, 21);

	CreateActionButton();
}

// ----------------------------------------------------------------------
// ButtonActivated()
//
// If the action button was pressed, cycle to the next available
// choice (if any)
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	if (buttonPressed == btnAction)
	{
		CycleNextValue();
		return True;
	}
	else
	{
		return Super.ButtonActivated(buttonPressed);
	}
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Let the parent window handle [Return] so we can use it as "OK"
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bHandled;

	if (key == IK_Enter)
		return False;
	else
		return Super.VirtualKeyPressed(key, bRepeat);
}

// ----------------------------------------------------------------------
// ButtonActivatedRight()
//
// If the action button was pressed, cycle to the next available
// choice (if any)
// ----------------------------------------------------------------------

function bool ButtonActivatedRight( Window buttonPressed )
{
	if (buttonPressed == btnAction)
	{
		CyclePreviousValue();
		return True;
	}
	else
	{
		return Super.ButtonActivated(buttonPressed);
	}
}

// ----------------------------------------------------------------------
// CycleNextValue()
// ----------------------------------------------------------------------

function CycleNextValue()
{
}

// ----------------------------------------------------------------------
// CyclePreviousValue()
// ----------------------------------------------------------------------

function CyclePreviousValue()
{
}

// ----------------------------------------------------------------------
// CreateActionButton()
// ----------------------------------------------------------------------

function CreateActionButton()
{
	btnAction = MenuUIChoiceButton(NewChild(Class'MenuUIChoiceButton'));
	btnAction.SetButtonText(actionText);
	btnAction.SetVerticalOffset(buttonVerticalOffset);
	btnAction.EnableRightMouseClick();
}

// ----------------------------------------------------------------------
// SetActionButtonWidth()
// ----------------------------------------------------------------------

function SetActionButtonWidth(int newWidth)
{
	if (btnAction != None)
		btnAction.SetWidth(newWidth);
}

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
}

// ----------------------------------------------------------------------
// CancelSetting()
// ----------------------------------------------------------------------

function CancelSetting()
{
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
}

// ----------------------------------------------------------------------
// SaveMenuSettings()
// ----------------------------------------------------------------------

function SaveMenuSettings()
{
	local MenuUIScreenWindow menuScreen;

	menuScreen = MenuUIScreenWindow(GetParent().GetParent());

	if (menuScreen != None)
		menuScreen.SaveSettings();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     choiceControlPosX=270
     actionText="Choice"
     FalseTrue(0)="False"
     FalseTrue(1)="True"
}
