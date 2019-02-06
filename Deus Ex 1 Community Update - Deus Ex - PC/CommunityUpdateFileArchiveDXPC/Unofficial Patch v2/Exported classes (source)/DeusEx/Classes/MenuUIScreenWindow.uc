//=============================================================================
// MenuUIScreenWindow
//
// Base class for menu Screens (the end results of actually walking around
// and selecting stuff from the MenuUIMenuWindows).
//=============================================================================

class MenuUIScreenWindow extends MenuUIWindow;

var int choiceVerticalGap;
var int choiceCount;
var int choiceStartX;
var int choiceStartY;

var Class<MenuUIChoice> choices[13];
var MenuUIChoice currentChoice;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	CreateChoices();
	LoadSettings();
}

// ----------------------------------------------------------------------
// CreateChoices()
// ----------------------------------------------------------------------

function CreateChoices()
{
	local int choiceIndex;
	local MenuUIChoice newChoice;

	// Loop through the Menu Choices and create the appropriate buttons
	for(choiceIndex=0; choiceIndex<arrayCount(choices); choiceIndex++)
	{
		if (choices[choiceIndex] != None)
		{
			newChoice = MenuUIChoice(winClient.NewChild(choices[choiceIndex]));
			newChoice.SetPos(choiceStartX, choiceStartY + (choiceCount * choiceVerticalGap) - newChoice.buttonVerticalOffset);
			choiceCount++;
		}
	}
}

// ----------------------------------------------------------------------
// FocusEnteredDescendant() : Called when a descendant window gets focus
// ----------------------------------------------------------------------

event FocusEnteredDescendant(Window enterWindow)
{
	local MenuUIChoice choice;

	if (enterWindow.IsA('MenuUIActionButtonWindow'))
	{
		// Check to see if the parent is our MenuUIChoice window
		choice = MenuUIChoice(enterWindow.GetParent());

		if (choice != None)
		{
			currentChoice = choice;

			if ((winHelp != None) && (currentChoice.helpText != ""))
			{
				winHelp.Show();
				winHelp.SetText(currentChoice.helpText);
			}
		}
	}
}


// ----------------------------------------------------------------------
// FocusLeftDescendant() : Called when a descendant window loses focus
// ----------------------------------------------------------------------

event FocusLeftDescendant(Window leaveWindow)
{
	if ((winHelp != None) && (!bHelpAlwaysOn))
		winHelp.Hide();

	currentChoice = None;
}

// ----------------------------------------------------------------------
// LoadSettings()
// ----------------------------------------------------------------------

function LoadSettings()
{
	local Window btnChoice;

	btnChoice = winClient.GetTopChild();
	while(btnChoice != None)
	{
		if (btnChoice.IsA('MenuUIChoice'))
			MenuUIChoice(btnChoice).LoadSetting();

		btnChoice = btnChoice.GetLowerSibling();
	}
}

// ----------------------------------------------------------------------
// SaveSettings()
// ----------------------------------------------------------------------

function SaveSettings()
{
	local Window btnChoice;

	btnChoice = winClient.GetTopChild();
	while(btnChoice != None)
	{
		if (btnChoice.IsA('MenuUIChoice'))
			MenuUIChoice(btnChoice).SaveSetting();

		btnChoice = btnChoice.GetLowerSibling();
	}

	Super.SaveSettings();
}

// ----------------------------------------------------------------------
// CancelScreen()
// ----------------------------------------------------------------------

function CancelScreen()
{
	local Window btnChoice;

	btnChoice = winClient.GetTopChild();
	while(btnChoice != None)
	{
		if (btnChoice.IsA('MenuUIChoice'))
			MenuUIChoice(btnChoice).CancelSetting();

		btnChoice = btnChoice.GetLowerSibling();
	}

	Super.CancelScreen();
}

// ----------------------------------------------------------------------
// ResetToDefaults()
// ----------------------------------------------------------------------

function ResetToDefaults()
{
	local Window btnChoice;

	btnChoice = winClient.GetTopChild();
	while(btnChoice != None)
	{
		if (btnChoice.IsA('MenuUIChoice'))
			MenuUIChoice(btnChoice).ResetToDefault();

		btnChoice = btnChoice.GetLowerSibling();
	}
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bHandled;
	bHandled = True;

	if ( IsKeyDown( IK_Alt ) || IsKeyDown( IK_Shift ) || IsKeyDown( IK_Ctrl ))
		return False;

	switch( key ) 
	{	
		// If a MenuUIChoice has focus, cycle to previous choice
		case IK_Left:
			if (currentChoice != None)
			{
				bHandled = True;
				PlaySound(Sound'Menu_Press', 0.25); 
				currentChoice.CyclePreviousValue();
			}
			break;

		// If a MenuEnumButton has focus, cycle to next choice
		case IK_Right:
			if (currentChoice != None)
			{
				bHandled = True;
				PlaySound(Sound'Menu_Press', 0.25); 
				currentChoice.CycleNextValue();
			}
			break;

		default:
			bHandled = False;
	}

	if (!bHandled)
		return Super.VirtualKeyPressed(key, bRepeat);
	else
		return bHandled;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     choiceVerticalGap=36
     choiceStartX=7
     choiceStartY=27
     textureRows=2
     textureCols=3
     bActionButtonBarActive=True
     bLeftEdgeActive=True
     bRightEdgeActive=True
     ScreenType=ST_MenuScreen
}
