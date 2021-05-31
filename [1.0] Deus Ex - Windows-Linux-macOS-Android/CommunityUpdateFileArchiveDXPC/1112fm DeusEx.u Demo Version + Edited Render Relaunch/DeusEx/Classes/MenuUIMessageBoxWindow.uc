//=============================================================================
// MenuUIMessageBoxWindow
//=============================================================================

class MenuUIMessageBoxWindow expands MenuUIWindow;

// ----------------------------------------------------------------------
// Enumerated Types
// ----------------------------------------------------------------------

enum EMessageBoxModes
{
	MB_YesNo,
	MB_OK,
};

enum EMessageBoxResults
{
	MR_Yes,
	MR_No,
	MR_OK
};
	
// ----------------------------------------------------------------------
// Local Variables
// ----------------------------------------------------------------------

// Text Colors used by menus
var Color colTextMessage;

// Buttons
var MenuUIActionButtonWindow btnYes;
var MenuUIActionButtonWindow btnNo;
var MenuUIActionButtonWindow btnOK;

// Windows
var MenuUIHeaderWindow winText;

// Mode
var int  mbMode;
var bool bDeferredKeyPress;
var bool bKeyPressed;

// Window to be notified when user makes a selection
var Window winNotify;

var int textBorderX;
var int textBorderY;
var int numButtons;

// Localized strings
var localized string btnLabelYes;
var localized string btnLabelNo;
var localized string btnLabelOK;
var localized string btnLabelCancel;


// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Force the title bar to be a certain width;
	winTitle.minTitleWidth = 250;

	CreateTextWindow();
}

// ----------------------------------------------------------------------
// CreateTextWindow()
// ----------------------------------------------------------------------

function CreateTextWindow()
{
	winText = CreateMenuHeader(21, 13, "", winClient);
	winText.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winText.SetFont(Font'FontMenuHeaders_DS');
	winText.SetWindowAlignments(HALIGN_Full, VALIGN_Full, textBorderX, textBorderY);
}

// ----------------------------------------------------------------------
// SetMessageText()
//
// Sets the text displayed in the message box
// ----------------------------------------------------------------------

function SetMessageText( String msgText )
{
	winText.SetText(msgText);

	AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// SetDeferredKeyPress()
// ----------------------------------------------------------------------

function SetDeferredKeyPress(bool bNewDeferredKeyPress)
{
	bDeferredKeyPress = bNewDeferredKeyPress;
}

// ----------------------------------------------------------------------
// SetMode()
//
// Sets the message box mode and creates the buttoms appropriately
// ----------------------------------------------------------------------

function SetMode( int newMode )
{
	// Store away
	mbMode = newMode;
	
	// Now create buttons appropriately

	switch( mbMode )
	{
		case 0:			// MB_YesNo:
			btnNo  = winButtonBar.AddButton(btnLabelNo, HALIGN_Right);
			btnYes = winButtonBar.AddButton(btnLabelYes, HALIGN_Right);
			numButtons = 2;
			SetFocusWindow(btnYes);
			break;

		case 1:			// MB_OK:
			btnOK = winButtonBar.AddButton(btnLabelOK, HALIGN_Right);
			numButtons = 1;
			SetFocusWindow(btnOK);
			break;
	}

	// Tell the shadow which bitmap to use
	if (winShadow != None)
		MenuUIMessageBoxShadowWindow(winShadow).SetButtonCount(numButtons);
}

// ----------------------------------------------------------------------
// GetNumButtons()
// ----------------------------------------------------------------------

function int GetNumButtons()
{
	return numButtons;
}

// ----------------------------------------------------------------------
// SetNotifyWindow()
// ----------------------------------------------------------------------

function SetNotifyWindow( Window newWinNotify )
{
	winNotify = newWinNotify;
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	bHandled = True;

	Super.ButtonActivated(buttonPressed);

	switch( buttonPressed )
	{
		case btnYes:
			if ((bDeferredKeyPress) && (IsKeyDown(IK_Enter) || IsKeyDown(IK_Space) || IsKeyDown(IK_Y)))
				bKeyPressed = True;
			else
				PostResult(0);  // MR_Yes;

			bHandled = True;
			break;

		case btnNo:
			PostResult(1);
			break;

		case btnOK:
			if ((bDeferredKeyPress) && (IsKeyDown(IK_Enter) || IsKeyDown(IK_Space) || IsKeyDown(IK_Y)))
				bKeyPressed = True;
			else
				PostResult(0);

			bHandled = True;
			break;

		default:
			bHandled = False;
			break;
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// MouseButtonReleased()
//
// For message boxes, don't allow the user to click outside the window
// or buttons to proceed
// ----------------------------------------------------------------------

event bool MouseButtonReleased(float pointX, float pointY, EInputKey button, int numClicks)
{
	return True;
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bHandled;

	switch( key ) 
	{	
		case IK_Escape:
			switch( mbMode )
			{
				case 0:		// MB_YesNo:
					PostResult(1);
					break;
				case 1:		// MB_OK:
					PostResult(0);
					break;
			}
			bHandled = True;
			break;

		case IK_Enter:	
		case IK_Space:
			if (bDeferredKeyPress) 
				bKeyPressed = True;
			else
				PostResult(0);

			bHandled = True;
			break;

		case IK_Y:
			if ( mbMode == 0  /*MB_YesNo*/ )
			{
				if (bDeferredKeyPress)
					bKeyPressed = True;
				else
					PostResult(0);

				bHandled = True;
			}
			break;

		case IK_N:
			if ( mbMode == 0  /*MB_YesNo*/ )
			{
				PostResult(1);
				bHandled = True;
			}
			break;
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// RawKeyPressed()
// ----------------------------------------------------------------------

event bool RawKeyPressed(EInputKey key, EInputState iState, bool bRepeat)
{
	if (((key == IK_Enter) || (key == IK_Space) || (key == IK_Y)) &&
	   ((iState == IST_Release) && (bKeyPressed)))
	{
		PostResult(0);
		return True;
	}
	else
	{
		return false;  // don't handle
	}
}

// ----------------------------------------------------------------------
// PostResult()
//
// Sends the result up through the parent windows until we either run
// out of windows or the result is eaten.
// ----------------------------------------------------------------------

function PostResult( int buttonNumber )
{
	if ( winNotify != None )
		winNotify.BoxOptionSelected(Self, buttonNumber);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     textBorderX=20
     textBorderY=14
     btnLabelYes="|&Yes"
     btnLabelNo="|&No"
     btnLabelOK="|&OK"
     btnLabelCancel="|&Cancel"
     ClientWidth=280
     ClientHeight=85
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuMessageBoxBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuMessageBoxBackground_2'
     textureRows=1
     textureCols=2
     bActionButtonBarActive=True
     bUsesHelpWindow=False
     winShadowClass=Class'DeusEx.MenuUIMessageBoxShadowWindow'
}
