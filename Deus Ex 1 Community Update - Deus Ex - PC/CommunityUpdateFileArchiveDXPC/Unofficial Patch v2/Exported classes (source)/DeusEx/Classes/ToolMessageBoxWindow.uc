//=============================================================================
// ToolMessageBoxWindow
//=============================================================================
class ToolMessageBoxWindow expands ToolWindow;

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
var Font  fontMessageText;

// Buttons
var ToolButtonWindow btnYes;
var ToolButtonWindow btnNo;
var ToolButtonWindow btnOK;

// Windows
var TextWindow winText;

// Mode
var int mbMode;

// Window to be notified when user makes a selection
var Window winNotify;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(200, 150);

	winText = CreateToolLabel(10, 40, "");
	winText.SetSize(175, 60);
}

// ----------------------------------------------------------------------
// SetMessageText()
//
// Sets the text displayed in the message box
// ----------------------------------------------------------------------

function SetMessageText( String msgText )
{
	winText.SetText(msgText);
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
			btnYes = CreateToolButton( 20,  110, "Yes" );
			btnNo  = CreateToolButton( 106, 110, "No" );
			SetFocusWindow(btnYes);
			break;

		case 1:			// MB_OK:
			btnOK = CreateToolButton( 63, 110, "OK" );
			SetFocusWindow(btnOK);
			break;
	}
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
			PostResult(0);  // MR_Yes;
			break;

		case btnNo:
			PostResult(1);
			break;

		case btnOK:
			PostResult(0);
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
			PostResult(0);
			bHandled = True;
			break;

		case IK_Y:
			if ( mbMode == 0  /*MB_YesNo*/ )
			{
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
     fontMessageText=Font'DeusExUI.FontSansSerif_8'
}
