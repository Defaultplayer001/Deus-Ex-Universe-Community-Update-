//=============================================================================
// MenuUIWindow
//
// Base class for the Menu windows
//=============================================================================

class MenuUIWindow extends DeusExBaseWindow
	abstract;

enum EMenuActions
{
	MA_Menu, 
	MA_MenuScreen,
	MA_Previous, 
	MA_NewGame,
	MA_Training,
	MA_Intro,
	MA_Quit,
	MA_Custom
};

enum EActionButtonEvents
{
	AB_None,
	AB_OK,
	AB_Cancel,
	AB_Reset,
	AB_Previous,
	AB_Other
};

enum EMessageBoxModes
{
	MB_Exit,
	MB_AskToTrain,
	MB_Training,
	MB_Intro,
	MB_JoinGameWarning,
};

struct S_ActionButtonDefault
{
	var EHALIGN align;
	var EActionButtonEvents action;
	var localized String text;
	var String key;
	var MenuUIActionButtonWindow btn;
};

var localized S_ActionButtonDefault actionButtons[5];
var EMessageBoxModes      messageBoxMode;

var MenuUITitleWindow			winTitle;			// Title bar, outside client
var MenuUIClientWindow			winClient;			// Window that contains all controls
var MenuUIActionButtonBarWindow winButtonBar;		// Button Bar Window
var MenuUILeftEdgeWindow        winLeftEdge;
var MenuUIRightEdgeWindow       winRightEdge;
var MenuUIHelpWindow            winHelp;

// Dragging stuff
var Bool	bWindowBeingDragged;
var Bool	bAllowWindowDragging;
var float	windowStartDragX;
var float	windowStartDragY;

// Defaults
var localized String title;
var int clientWidth;
var int clientHeight;
var int verticalOffset;
var Texture clientTextures[6];
var int textureRows;
var int textureCols;
var bool bActionButtonBarActive;
var bool bLeftEdgeActive;
var bool bRightEdgeActive;
var bool bUsesHelpWindow;
var bool bHelpAlwaysOn;
var bool bEscapeSavesSettings;
var int  helpPosY;
var int  defaultHelpLeftOffset;
var int  defaultHelpHeight;
var int  defaultHelpClientDiffY;

// Shadow stuff
var Class<MenuUIShadowWindow>   winShadowClass;
var MenuUIShadowWindow          winShadow;
var int  shadowOffsetX;
var int  shadowOffsetY;
var int  shadowWidth;
var int  shadowHeight;

var localized string btnLabelOK;
var localized string btnLabelCancel;
var localized string btnLabelPrevious;
var localized string btnLabelResetToDefaults;
var localized string MessageBoxTitle;
var localized string ExitMessage;
var localized string TrainingWarningMessage;
var localized string IntroWarningMessage;
var localized string AskToTrainTitle;
var localized string AskToTrainMessage;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	bSizeParentToChildren = False;   // god damnit

	CreateControls();	
	StyleChanged();

	// Play Menu Activated Sound
	PlaySound(Sound'Menu_Activate', 0.25); 
}

// ----------------------------------------------------------------------
// DestroyWindow()
//
// Unload texture memory used by background textures
// ----------------------------------------------------------------------

function DestroyWindow()
{
	local int texIndex;

	for(texIndex=0; texIndex<arrayCount(clientTextures); texIndex++)
		player.UnloadTexture(clientTextures[texIndex]);

	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	CreateShadowWindow();
	CreateTitleWindow();
	CreateClientWindow();
	CreateActionButtonBar();
	CreateActionButtons();
	CreateLeftEdgeWindow();
	CreateRightEdgeWindow();
	CreateHelpWindow();
}

// ----------------------------------------------------------------------
// ParentRequestedPreferredSize()
// ----------------------------------------------------------------------

event ParentRequestedPreferredSize(bool bWidthSpecified, out float preferredWidth,
                                   bool bHeightSpecified, out float preferredHeight)
{
	local float clientWidth, clientHeight;
	local float titleWidth, titleHeight;
	local float buttonBarWidth, buttonBarHeight;
	local float rightEdgeWidth;

	if (winClient != None)
		winClient.QueryPreferredSize(clientWidth, clientHeight);

	if (winTitle != None)
	{
		titleWidth  = winTitle.leftBottomWidth;
		titleHeight = winTitle.titleHeight;
	}

	if (winRightEdge != None)
		rightEdgeWidth = winRightEdge.rightWidth;

	if (winButtonBar != None)
		winButtonBar.QueryPreferredSize(buttonBarWidth, buttonBarHeight);

	preferredWidth  = clientWidth  + titleWidth  + rightEdgeWidth;
	preferredHeight = clientHeight + titleHeight + buttonBarHeight + verticalOffset;

	// Take into account shadow crap
	if (preferredWidth < shadowWidth)
		preferredWidth = shadowWidth;
	if (preferredHeight < shadowHeight)
		preferredHeight = shadowHeight;
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	local float clientWidth, clientHeight;
	local float titleWidth, titleHeight, titleTopHeight, titleBarWidth;
	local float leftEdgeWidth, leftEdgeHeight;
	local float rightEdgeWidth, rightEdgeHeight;
	local float buttonBarWidth, buttonBarHeight;
	local float rightEdgeX, rightEdgeY;
	local float winLeftEdgeGap;
	local float rightEdgeGap;
	local int titleOffsetX, titleOffsetY;

	if (winTitle != None)
		winTitle.GetOffsetWidths(titleOffsetX, titleOffsetY);

	// Client Window
	if (winClient != None)
	{
		winClient.QueryPreferredSize(clientWidth, clientHeight);
		winClient.ConfigureChild(
			titleOffsetX + shadowOffsetX, titleOffsetY + shadowOffsetY,
			clientWidth, clientHeight);
	}

	// Title Bar
	if (winTitle != None)
	{
		winTitle.QueryPreferredSize(titleBarWidth, titleHeight);
		winTitle.ConfigureChild(
			shadowOffsetX, shadowOffsetY,
			titleBarWidth, titleHeight);

		titleWidth     = winTitle.leftBottomWidth;
		titleTopHeight = winTitle.titleHeight;
	}

	// Button Bar
	if (winButtonBar != None)
	{
		// If Right edge active, need to make button bar wider
		if (winRightEdge != None)
		{
			winRightEdge.QueryPreferredSize(rightEdgeWidth, rightEdgeHeight);
			rightEdgeWidth = winRightEdge.rightWidth;
			rightEdgeGap   = 2;
		}

		if (winLeftEdge != None)
			winLeftEdgeGap = 1;

		winButtonBar.QueryPreferredSize(buttonBarWidth, buttonBarHeight);
		winButtonBar.ConfigureChild(
			titleWidth + winLeftEdgeGap + shadowOffsetX, titleTopHeight + clientHeight + shadowOffsetY, 
			clientWidth - 1 - rightEdgeGap, buttonBarHeight);
	}

	// Left Edge
	if (winLeftEdge != None)
	{
		winLeftEdge.QueryPreferredSize(LeftEdgeWidth, LeftEdgeHeight);
		winLeftEdge.ConfigureChild(
			titleWidth - LeftEdgeWidth + shadowOffsetX, titleHeight + shadowOffsetY, 
			LeftEdgeWidth, clientHeight + buttonBarHeight - (titleHeight - titleTopHeight) - 1);
	}

	// Right Edge
	if (winRightEdge != None)
	{
		winRightEdge.ConfigureChild(
			titleBarWidth + 1 + shadowOffsetX, titleTopHeight - 4 + shadowOffsetY, 
			clientWidth - (titleBarWidth - titleWidth) - 1 + winRightEdge.rightWidth, 
			clientHeight + 4 + 14);
	}

	// Configure Help Window
	if (winHelp != None)
	{
		winHelp.ConfigureChild(
			titleWidth + defaultHelpLeftOffset + shadowOffsetX, titleTopHeight + helpPosY + shadowOffsetY,
			clientWidth - defaultHelpClientDiffY, defaultHelpHeight);
	}
}

// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

function bool ChildRequestedReconfiguration(window child)
{
	return False;
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bKeyHandled;
	bKeyHandled = True;

	Super.VirtualKeyPressed(key, bRepeat);

	if ( IsKeyDown( IK_Alt ) || IsKeyDown( IK_Shift ) || IsKeyDown( IK_Ctrl ))
		return False;

	switch( key ) 
	{	
		// Hide the screen if the Escape key is pressed
		// Temp: Also if the Return key is pressed
		case IK_Escape:
			if (bEscapeSavesSettings)
			{
				SaveSettings();
				root.PopWindow();
			}
			else
			{
				CancelScreen();
			}
			break;

		// Enter is the same as clicking OK
		case IK_Enter:
			SaveSettings();
			root.PopWindow();
			break;

		default:
			bKeyHandled = False;
	}

	return bKeyHandled;
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	bHandled = False;

	// Check to see if this was an action button!
	if (buttonPressed.IsA('MenuUIActionButtonWindow'))
	{
		bHandled = ProcessActionButton(MenuUIActionButtonWindow(buttonPressed));
	}

	if (bHandled)
		return bHandled;
	else
		return Super.ButtonActivated(buttonPressed);
}

// ----------------------------------------------------------------------
// MouseMoved()
//
// If we're dragging the window around, move
// ----------------------------------------------------------------------

event MouseMoved(float newX, float newY)
{
	if ( bWindowBeingDragged )
		SetPos( x + (newX - windowStartDragX), y + (newY - windowStartDragY) );
}

// ----------------------------------------------------------------------
// MouseButtonPressed() 
//
// If the user presses the mouse button while over the title bar,
// initiate window dragging.
// ----------------------------------------------------------------------

event bool MouseButtonPressed(float pointX, float pointY, EInputKey button,
                              int numClicks)
{
	local float relativeX;
	local float relativeY;

	if ( ( button == IK_LeftMouse ) && ( numClicks == 1 ) && 
		( ( FindWindow(pointX, pointY, relativeX, relativeY) == winTitle ) || ( bAllowWindowDragging )))
	{
		bWindowBeingDragged = True;
		windowStartDragX = pointX;
		windowStartDragY = pointY;

		GrabMouse();
	}
	else
	{
		bWindowBeingDragged = False;
	}

	return bWindowBeingDragged;  
}

// ----------------------------------------------------------------------
// MouseButtonReleased() 
//
// First check to see if we're dragging the window.  If so, then
// end the drag event.
// ----------------------------------------------------------------------

event bool MouseButtonReleased(float pointX, float pointY, EInputKey button,
                               int numClicks)
{
	local float relativeX;
	local float relativeY;

	if ((button == IK_LeftMouse ) && (bWindowBeingDragged))
		bWindowBeingDragged = False;			

	return False;
}

// ----------------------------------------------------------------------
// CreateShadowWindow()
// ----------------------------------------------------------------------

function CreateShadowWindow()
{
	if (winShadowClass != None)
	{
		winShadow = MenuUIShadowWindow(NewChild(winShadowClass));

		// Store these away so we can properly calculate window sizes/positions
		shadowOffsetX = winShadow.shadowOffsetX;
		shadowOffsetY = winShadow.shadowOffsetY;
		shadowWidth   = winShadow.shadowWidth;
		shadowHeight  = winShadow.shadowHeight;
	}
}

// ----------------------------------------------------------------------
// CreateTitleWindow()
// ----------------------------------------------------------------------

function CreateTitleWindow()
{
	winTitle = MenuUITitleWindow(NewChild(Class'MenuUITitleWindow'));
	SetTitle(title);
}

// ----------------------------------------------------------------------
// SetTitle()
// ----------------------------------------------------------------------

function SetTitle(String newTitle)
{
	winTitle.SetTitle(newTitle);
}

// ----------------------------------------------------------------------
// CreateClientWindow()
// ----------------------------------------------------------------------

function CreateClientWindow()
{
	local int clientIndex;
	local int titleOffsetX, titleOffsetY;

	winClient = MenuUIClientWindow(NewChild(class'MenuUIClientWindow'));

	winTitle.GetOffsetWidths(titleOffsetX, titleOffsetY);

	winClient.SetSize(clientWidth, clientHeight);
	winClient.SetTextureLayout(textureCols, textureRows);

	// Set background textures
	for(clientIndex=0; clientIndex<arrayCount(clientTextures); clientIndex++)
	{
		winClient.SetClientTexture(clientIndex, clientTextures[clientIndex]);
	}
}

// ----------------------------------------------------------------------
// CreateActionButtonBar()
// ----------------------------------------------------------------------

function MenuUIActionButtonBarWindow CreateActionButtonBar()
{
	// Only create if we're supposed to create it
	if (bActionButtonBarActive)
		winButtonBar = MenuUIActionButtonBarWindow(NewChild(Class'MenuUIActionButtonBarWindow'));
}

// ----------------------------------------------------------------------
// CreateActionButtons()
// ----------------------------------------------------------------------

function CreateActionButtons()
{
	local int    buttonIndex;
	local string buttonText;

	if (winButtonBar == None)
		return;

	for(buttonIndex=0; buttonIndex<arrayCount(actionButtons); buttonIndex++)
	{
		if (actionButtons[buttonIndex].action != AB_None)
		{
			// First get the string
			switch(actionButtons[buttonIndex].action)
			{
				case AB_OK:
					buttonText = btnLabelOK;
					break;

				case AB_Cancel:
					buttonText = btnLabelCancel;
					break;

				case AB_Reset:
					buttonText = btnLabelResetToDefaults;
					break;

				case AB_Previous:
					buttonText = btnLabelPrevious;
					break;

				case AB_Other:
					buttonText = actionButtons[buttonIndex].text;
					break;
			}

			actionButtons[buttonIndex].btn = 
				winButtonBar.AddButton(buttonText, actionButtons[buttonIndex].align);
		}
		else
		{
			break;
		}
	}
}

// ----------------------------------------------------------------------
// CreateLeftEdgeWindow()
// ----------------------------------------------------------------------

function CreateLeftEdgeWindow()
{
	if (bLeftEdgeActive)
		winLeftEdge = MenuUILeftEdgeWindow(NewChild(Class'MenuUILeftEdgeWindow'));
}

// ----------------------------------------------------------------------
// CreateRightEdgeWindow()
// ----------------------------------------------------------------------

function CreateRightEdgeWindow()
{
	if (bRightEdgeActive)
	{
		winRightEdge = MenuUIRightEdgeWindow(NewChild(Class'MenuUIRightEdgeWindow'));
		winRightEdge.Lower();
	}
}

// ----------------------------------------------------------------------
// CreateMenuUITab()
// ----------------------------------------------------------------------

function MenuUITabButtonWindow CreateMenuUITab(int posX, int posY, String buttonText)
{
	local MenuUITabButtonWindow newButton;

	newButton = MenuUITabButtonWindow(winClient.NewChild(Class'MenuUITabButtonWindow'));
	newButton.SetPos(posX, posY);
	newButton.SetButtonText(buttonText);

	return newButton;
}

// ----------------------------------------------------------------------
// CreateHelpWindow()
//
// Optionally creates the help window, which is displayed at the 
// bottom of the screen when various choice controls are given
// focus.  Can also be forced on/off programmatically
// ----------------------------------------------------------------------

function CreateHelpWindow()
{
	if (bUsesHelpWindow)
	{
		winHelp = MenuUIHelpWindow(NewChild(Class'MenuUIHelpWindow'));

		if (!bHelpAlwaysOn)
			winHelp.Hide();
	}
}

// ----------------------------------------------------------------------
// ShowHelp()
// ----------------------------------------------------------------------

function ShowHelp(String helpMessage)
{
	if (winHelp != None)
	{
		winHelp.Show();
		winHelp.SetText(helpMessage);
	}
}

// ----------------------------------------------------------------------
// HideHelp()
// ----------------------------------------------------------------------

function HideHelp()
{
	if (winHelp != None)
		winHelp.Hide();
}

// ----------------------------------------------------------------------
// ProcessMenuAction()
// ----------------------------------------------------------------------

function ProcessMenuAction(EMenuActions action, Class menuActionClass, optional String key)
{
	switch(action)
	{
		case MA_Menu:
			root.InvokeMenu(Class<DeusExBaseWindow>(menuActionClass));
			break;

		case MA_MenuScreen:
			root.InvokeMenuScreen(Class<DeusExBaseWindow>(menuActionClass));
			break;

		case MA_Previous:
			root.PopWindow();
			break;

		case MA_Quit:
			messageBoxMode = MB_Exit;
			root.MessageBox(MessageBoxTitle, ExitMessage, 0, False, Self);
			break;

		case MA_Intro:
			ConfirmIntro();
			break;

		case MA_NewGame:
			StartNewGame();
			break;

		case MA_Training:
			ConfirmTraining();
			break;

		case MA_Custom:
			ProcessCustomMenuButton(key);
			break;

	}
}

// ----------------------------------------------------------------------
// ProcessCustomMenuButton()
// ----------------------------------------------------------------------

function ProcessCustomMenuButton(string key)
{
}

// ----------------------------------------------------------------------
// StartNewGame()
// ----------------------------------------------------------------------

function StartNewGame()
{
	// Check to see if the player has already ran the training mission
	// or been prompted
	if (player.bAskedToTrain == False)
	{
		messageBoxMode = MB_AskToTrain;
		player.bAskedToTrain = True;		// Only prompt ONCE!
		player.SaveConfig();
		root.MessageBox(AskToTrainTitle, AskToTrainMessage, 0, False, Self);
	}
	else
	{
		root.InvokeMenuScreen(Class'MenuSelectDifficulty');
	}
}

// ----------------------------------------------------------------------
// ConfirmIntro()
// ----------------------------------------------------------------------

function ConfirmIntro()
{
	local DeusExLevelInfo info;

	info = player.GetLevelInfo();

	// If the game is running, first *PROMPT* the user, becauase
	// otherwise the current game will be lost

	if (((info != None) && (info.MissionNumber >= 0)) &&
	   !((player.IsInState('Dying')) || (player.IsInState('Paralyzed'))))
	{
		messageBoxMode = MB_Intro;
		root.MessageBox(MessageBoxTitle, IntroWarningMessage, 0, False, Self);
	}
	else
	{
		player.ShowIntro();
	}
}

// ----------------------------------------------------------------------
// ConfirmTraining()
// ----------------------------------------------------------------------

function ConfirmTraining()
{
	local DeusExLevelInfo info;

	info = player.GetLevelInfo();

	// If the game is running, first *PROMPT* the user, becauase
	// otherwise the current game will be lost

	if (((info != None) && (info.MissionNumber >= 0)) &&
	   !((player.IsInState('Dying')) || (player.IsInState('Paralyzed'))))
	{
		messageBoxMode = MB_Training;
		root.MessageBox(MessageBoxTitle, TrainingWarningMessage, 0, False, Self);
	}
	else
	{
		player.StartTrainingMission();
	}
}

// ----------------------------------------------------------------------
// ProcessActionButton()
// ----------------------------------------------------------------------

function bool ProcessActionButton(MenuUIActionButtonWindow btnAction)
{
	local int  buttonIndex;
	local bool bHandled;

	bHandled = False;

	// Find out which button this is in our array

	for(buttonIndex=0; buttonIndex<arrayCount(actionButtons); buttonIndex++)
	{
		if (actionButtons[buttonIndex].btn == btnAction)
		{
			switch(actionButtons[buttonIndex].action)
			{
				case AB_OK:
					SaveSettings();
					root.PopWindow();
					break;

				case AB_Cancel:
					CancelScreen();
					break;

				case AB_Reset:
					ResetToDefaults();
					break;

				case AB_Previous:
					SaveSettings();
					root.PopWindow();
					break;

				case AB_Other:
					ProcessAction(actionButtons[buttonIndex].key);
					break;		
			}

			bHandled = True;
			break;
		}
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// ProcessAction()
//
// Meant to be called in derived class
// ----------------------------------------------------------------------

function ProcessAction(String actionKey)
{
}

// ----------------------------------------------------------------------
// SaveSettings()
//
// Meant to be called in derived class
// ----------------------------------------------------------------------

function SaveSettings()
{
	// Play OK Sound
	PlaySound(Sound'Menu_OK', 0.25); 
}

// ----------------------------------------------------------------------
// CancelScreen()
// ----------------------------------------------------------------------

function CancelScreen()
{
	// Play Cancel Sound
	PlaySound(Sound'Menu_Cancel', 0.25); 

	root.PopWindow();
}

// ----------------------------------------------------------------------
// ResetToDefaults()
//
// Meant to be called in derived class
// ----------------------------------------------------------------------

function ResetToDefaults()
{
}

// ----------------------------------------------------------------------
// BoxOptionSelected()
// ----------------------------------------------------------------------

event bool BoxOptionSelected(Window button, int buttonNumber)
{
	// Destroy the msgbox!  
	root.PopWindow();

	switch(messageBoxMode)
	{
		case MB_Exit:
			if ( buttonNumber == 0 ) 
			{
				/* TODO: This is what Unreal Does,
				player.SaveConfig();
				if ( Level.Game != None )
					Level.Game.SaveConfig();
				*/

				root.ExitGame();
			}
			break;

		case MB_AskToTrain:
			if (buttonNumber == 0)
				player.StartTrainingMission();
			else
				root.InvokeMenuScreen(Class'MenuSelectDifficulty');
			break;

		case MB_Training:
			if (buttonNumber == 0)
				player.StartTrainingMission();
			break;

		case MB_Intro:
			if (buttonNumber == 0)
				player.ShowIntro();
			break;

		case MB_JoinGameWarning:
			if (buttonNumber == 0)
			{
				if (Self.IsA('MenuScreenJoinGame'))
					MenuScreenJoinGame(Self).RefreshServerList();
			}
			break;
	}

	return true;
}

// ----------------------------------------------------------------------
// CreateMenuLabel()
// ----------------------------------------------------------------------

function MenuUILabelWindow CreateMenuLabel(int posX, int posY, String strLabel, Window winParent)
{
	local MenuUILabelWindow newLabel;

	newLabel = MenuUILabelWindow(winParent.NewChild(Class'MenuUILabelWindow'));

	newLabel.SetPos(posX, posY);
	newLabel.SetText(strLabel);

	return newLabel;
}

// ----------------------------------------------------------------------
// CreateMenuHeader()
// ----------------------------------------------------------------------

function MenuUIHeaderWindow CreateMenuHeader(int posX, int posY, String strLabel, Window winParent)
{
	local MenuUIHeaderWindow newLabel;

	newLabel = MenuUIHeaderWindow(winParent.NewChild(Class'MenuUIHeaderWindow'));

	newLabel.SetPos(posX, posY);
	newLabel.SetText(strLabel);

	return newLabel;
}

// ----------------------------------------------------------------------
// CreateMenuEditWindow()
// ----------------------------------------------------------------------

function MenuUIEditWindow CreateMenuEditWindow(int posX, int posY, int editWidth, int maxChars, Window winParent)
{
	local MenuUIInfoButtonWindow btnInfo;
	local ClipWindow             clipName;
	local MenuUIEditWindow       newEdit;

	// Create an info button behind this sucker
	btnInfo = MenuUIInfoButtonWindow(winParent.NewChild(Class'MenuUIInfoButtonWindow'));
	btnInfo.SetPos(posX, posY);
	btnInfo.SetWidth(editWidth);
	btnInfo.SetSensitivity(False);

	clipName = ClipWindow(winClient.newChild(Class'ClipWindow'));
	clipName.SetWidth(editWidth - 8);
	clipName.ForceChildSize(False, True);
	clipName.SetPos(posX + 4, posY + 5);

	newEdit = MenuUIEditWindow(clipName.NewChild(Class'MenuUIEditWindow'));
	newEdit.SetMaxSize(maxChars);

	return newEdit;
}

// ----------------------------------------------------------------------
// CreateHeaderButton()
// ----------------------------------------------------------------------

function MenuUIListHeaderButtonWindow CreateHeaderButton(
	int posX, 
	int posY, 
	int buttonWidth, 
	String strLabel, 
	Window winParent)
{
	local MenuUIListHeaderButtonWindow newButton;

	newButton = MenuUIListHeaderButtonWindow(winParent.NewChild(Class'MenuUIListHeaderButtonWindow'));

	newButton.SetPos(posX, posY);
	newButton.SetWidth(buttonWidth);
	newButton.SetButtonText(strLabel);

	return newButton;
}

// ----------------------------------------------------------------------
// CreateScrollAreaWindow()
// ----------------------------------------------------------------------

function MenuUIScrollAreaWindow CreateScrollAreaWindow(Window winParent)
{
	return MenuUIScrollAreaWindow(winParent.NewChild(Class'MenuUIScrollAreaWindow'));
}

// ----------------------------------------------------------------------
// EnableActionButton()
//
// Checks the state of the list control and updates the pushbuttons
// appropriately
// ----------------------------------------------------------------------

function EnableActionButton(
	EActionButtonEvents action, 
	bool bEnable, 
	optional String key)
{
	local S_ActionButtonDefault enableButton;
	local int buttonIndex;

	// First find our button to make sure it exists
	for(buttonIndex=0; buttonIndex<arrayCount(actionButtons); buttonIndex++)
	{
		if (actionButtons[buttonIndex].action == action)
		{
			if ((action != AB_Other) || ((action == AB_Other) && (actionButtons[buttonIndex].key == key)))
			{
				if (actionButtons[buttonIndex].btn != None)
				{
					actionButtons[buttonIndex].btn.SetSensitivity(bEnable);
				}
				break;
			}
		}
	}
}

// ----------------------------------------------------------------------
// IsActionButtonEnabled()
// ----------------------------------------------------------------------

function bool IsActionButtonEnabled(
	EActionButtonEvents action, 
	optional String key)
{
	local S_ActionButtonDefault enableButton;
	local int buttonIndex;
	local bool bButtonEnabled;

	bButtonEnabled = False;

	// First find our button to make sure it exists
	for(buttonIndex=0; buttonIndex<arrayCount(actionButtons); buttonIndex++)
	{
		if (actionButtons[buttonIndex].action == action)
		{
			if ((action != AB_Other) || ((action == AB_Other) && (actionButtons[buttonIndex].key == key)))
			{
				if (actionButtons[buttonIndex].btn != None)
				{
					bButtonEnabled = actionButtons[buttonIndex].btn.IsSensitive();
					break;
				}
			}
		}
	}

	return bButtonEnabled;
}

// ======================================================================
// ======================================================================
// Color Scheme Functions
// ======================================================================
// ======================================================================

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;
	local Color colCursor;

	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	colCursor = theme.GetColorFromName('MenuColor_Cursor');

	SetDefaultCursor(Texture'DeusExCursor1', Texture'DeusExCursor1_Shadow', 32, 32, colCursor);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bUsesHelpWindow=True
     bEscapeSavesSettings=True
     defaultHelpLeftOffset=7
     defaultHelpHeight=27
     defaultHelpClientDiffY=21
     btnLabelOK="|&OK"
     btnLabelCancel="|&Cancel"
     btnLabelPrevious="|&Previous"
     btnLabelResetToDefaults="|&Restore Defaults"
     MessageBoxTitle="Please Confirm"
     ExitMessage="Are you sure you|nwant to exit Deus Ex?"
     TrainingWarningMessage="The current game you are playing will be lost if you have not already saved it.  Do you still wish to enter the training mission?"
     IntroWarningMessage="The current game you are playing will be lost if you have not already saved it.  Do you still wish to view the intro?"
     AskToTrainTitle="Training Mission"
     AskToTrainMessage="Before starting a new game for the first time, we suggest running through the Training Mission.  Would you like to do this now?"
}
