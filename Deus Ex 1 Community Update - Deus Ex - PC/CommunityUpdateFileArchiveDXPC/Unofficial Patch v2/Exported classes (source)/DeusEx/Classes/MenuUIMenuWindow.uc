//=============================================================================
// MenuUIMenuWindow
//
// Base class for the Menu windows, which consist of a list of selections
// (load game, save game, new game, options, etc.)
//=============================================================================

class MenuUIMenuWindow extends MenuUIWindow;

struct S_MenuButton
{
	var int y;
	var EMenuActions action;
	var class invoke;
	var string key;
};

// Array of buttons
var MenuUIMenuButtonWindow winButtons[10];   // Up to ten buttons

// Array of button text
var localized string ButtonNames[10];

// Defaults
var int buttonXPos;
var int buttonWidth;
var S_MenuButton buttonDefaults[10];

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	CreateMenuButtons();
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;
	local int  buttonIndex;

	bHandled = False;

	Super.ButtonActivated(buttonPressed);

	// Figure out which button was pressed
	for (buttonIndex=0; buttonIndex<arrayCount(winButtons); buttonIndex++)
	{
		if (buttonPressed == winButtons[buttonIndex])
		{
			// Check to see if there's somewhere to go
			ProcessMenuAction(buttonDefaults[buttonIndex].action, buttonDefaults[buttonIndex].invoke, buttonDefaults[buttonIndex].key);

			bHandled = True;
			break;
		}
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// CreateMenuButtons()
//
// Loop through the buttonDefaults array and create any buttons
// that we need for the menu
// ----------------------------------------------------------------------

function CreateMenuButtons()
{
	local int buttonIndex;

	for(buttonIndex=0; buttonIndex<arrayCount(buttonDefaults); buttonIndex++)
	{
		if (ButtonNames[buttonIndex] != "")
		{
			winButtons[buttonIndex] = MenuUIMenuButtonWindow(winClient.NewChild(Class'MenuUIMenuButtonWindow'));

			winButtons[buttonIndex].SetButtonText(ButtonNames[buttonIndex]);
			winButtons[buttonIndex].SetPos(buttonXPos, buttonDefaults[buttonIndex].y);
			winButtons[buttonIndex].SetWidth(buttonWidth);
		}
		else
		{
			break;
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     textureRows=2
     textureCols=1
     bUsesHelpWindow=False
     ScreenType=ST_Menu
}
