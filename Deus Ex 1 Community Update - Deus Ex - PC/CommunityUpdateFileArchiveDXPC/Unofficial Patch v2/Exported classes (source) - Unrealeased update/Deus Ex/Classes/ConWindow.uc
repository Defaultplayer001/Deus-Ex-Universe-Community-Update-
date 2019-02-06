//=============================================================================
// ConWindow
//
// Used for non-interactive conversations displayed in first-person
// mode.  This type of conversation can only display spoken text,
// choices are -not- allowed.  
//=============================================================================

class ConWindow extends DeusExBaseWindow;

var TileWindow lowerConWindow;					// Lower letterbox region
var ConWindowSpeech winSpeech;					// Speech window
var ConCameraWindow cameraWin;					// Camera Stats displayed here
var Texture    conTexture;						// Background texture for window

var ConPlay conPlay;							// Pointer into current conPlay object

var DeusExPlayer player;
var DeusExRootWindow root;

var float conStartTime;
var bool  bForcePlay;

//var float fadeInterval;
//var float lastTick;
//var int   fadeColor;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Get a pointer to the player
	player = DeusExPlayer(DeusExRootWindow(GetRootWindow()).parentPawn);

	// Get a pointer to the root window
	root = DeusExRootWindow(GetRootWindow());

	// Set default mouse focus mode
	SetMouseFocusMode(MFocus_Enter);

	// Initialize some variables and stuff
	conPlay = None;

	// Create text window where we'll display the conversation
	lowerConWindow = TileWindow(NewChild(Class'TileWindow'));
	lowerConWindow.SetBackground(conTexture);
	lowerConWindow.SetBackgroundStyle(DSTY_Modulated);
	lowerConWindow.SetOrder(ORDER_Down);
	lowerConWindow.SetChildAlignments(HALIGN_Full, VALIGN_Top);
	lowerConWindow.SetMargins(2, 2);
	lowerConWindow.MakeWidthsEqual(False);
	lowerConWindow.MakeHeightsEqual(False);
	lowerConWindow.SetTileColorRGB(0, 0, 0);

	conStartTime = player.level.TimeSeconds;

//	lastTick     = 0;
//	fadeColor    = 255;
}

// ----------------------------------------------------------------------
// CreateSpeechWindow()
// ----------------------------------------------------------------------

function CreateSpeechWindow()
{
	if (winSpeech == None)
	{
		winSpeech = ConWindowSpeech(lowerConWindow.NewChild(Class'ConWindowSpeech'));
		winSpeech.SetSpeechFont(conPlay.GetCurrentSpeechFont());
		winSpeech.SetNameFont(conPlay.GetCurrentNameFont());
		winSpeech.SetForcePlay(bForcePlay);
	}
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{

	
//////////////////////////////////////////////////////////////////
// This code is commented out because setting the tile color for 
// modulated textures DOES NOT WORK (damn).  Someday perhaps we'll
// find a work-around or fix the engine to support this.
//////////////////////////////////////////////////////////////////
/*
	if ( lastTick + deltaSeconds > fadeInterval ) 
	{
		fadeColor--;
		lowerConWindow.SetTileColorRGB(fadeColor, fadeColor, fadeColor);
		lastTick = ( lastTick - fadeInterval);
		
		// Stop the tick event once the box is solid black.
		if ( fadeColor == 0 ) 
			bTickEnabled = False;
	}
	else
	{
		lastTick = lastTick + deltaSeconds;
	}
*/
}

// ----------------------------------------------------------------------
// CreateCameraWindow()
// ----------------------------------------------------------------------

function CreateCameraWindow()
{
	if (( cameraWin == None ) && (conPlay != None))
	{
		cameraWin = ConCameraWindow(NewChild(Class'ConCameraWindow'));
		cameraWin.SetConCamera(conPlay.cameraInfo);
	}
}

// ----------------------------------------------------------------------
// DestroyCameraWindow()
// ----------------------------------------------------------------------

function DestroyCameraWindow()
{
	if ( cameraWin != None )
	{
		cameraWin.Destroy();
		cameraWin = None;
	}
}

// ----------------------------------------------------------------------
// UpdateCameraInfo()
// ----------------------------------------------------------------------

function UpdateCameraInfo()
{
	if ( cameraWin != None )
		cameraWin.UpdateCameraInfo();
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
//
// Resize the letterbox regions when we get this event
// ----------------------------------------------------------------------

event ConfigurationChanged()
{
	local float newHeight;
	local float lowerConPosY;

	newHeight = height * 0.15;

	lowerConPosY = height - newHeight - 30;
	lowerConWindow.ConfigureChild(75, lowerConPosY, width - 150, newHeight);

	ConfigureCameraWindow(lowerConPosY);
}

// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

event bool ChildRequestedReconfiguration(window childWin)
{
	ConfigurationChanged();

	return True;
}

// ----------------------------------------------------------------------
// ConfigureCameraWindow()
// ----------------------------------------------------------------------

function ConfigureCameraWindow(float lowerConPosY)
{
	local float qWidth, qHeight;

	// If the camera window is visible, position it right above the lower window
	if (cameraWin != None)
	{
		cameraWin.QueryPreferredSize(qWidth, qHeight);
		cameraWin.ConfigureChild(10, lowerConPosY - qHeight - 10, qWidth, qHeight);	
	}
}

// ----------------------------------------------------------------------
// DisplayName()
//
// Displays the Actor's name at the top line of the conversation
// ----------------------------------------------------------------------

function DisplayName(string text)
{
	// Don't do this if bForcePlay == True

	if (!bForcePlay)
	{
		if (winSpeech == None ) 
			CreateSpeechWindow();

		winSpeech.SetName(text);
	}
}

// ----------------------------------------------------------------------
// DisplayText()
//
// Displays a string of conversation text
// ----------------------------------------------------------------------

function DisplayText(string text, Actor speakingActor)
{
	if (winSpeech == None ) 
		CreateSpeechWindow();

	winSpeech.SetSpeech(text, speakingActor);
}

// ----------------------------------------------------------------------
// AppendText()
//
// Adds string to the last button
// ----------------------------------------------------------------------

function AppendText(string text)
{
	if (winSpeech == None ) 
		CreateSpeechWindow();

	winSpeech.AppendSpeech(text);
}

// ----------------------------------------------------------------------
// DestroyChildren()
//
// Destroys all the windows used to display text and choices, 
// including the name window
// ----------------------------------------------------------------------

function DestroyChildren()
{
	local Window win;

	win = lowerConWindow.GetTopChild();
	while( win != None )
	{
		win.Destroy();
		win = lowerConWindow.GetTopChild();
	}

	// Reset variables
	winSpeech = None;
}

// ----------------------------------------------------------------------
// Close()
// ----------------------------------------------------------------------

function Close()
{
	Hide();
}

// ----------------------------------------------------------------------
// Clear()
//
// Clears the screen
// ----------------------------------------------------------------------

function Clear()
{
	DestroyChildren();
}

// ----------------------------------------------------------------------
// MouseButtonReleased
//
// Any mouse click will allow the conversation to continue
// ----------------------------------------------------------------------

event bool MouseButtonReleased(float pointX, float pointY, EInputKey button, int numClicks)
{
	// Ignore the mouse click if we're less than two seconds 
	// into the conversation 

	if (player.level.TimeSeconds - conStartTime < 2) 
	{
		return False;
	}
	else
	{
		conPlay.PlayNextEvent();
		return True;
	}
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// If the user hits return, enter or ESC, allow the conversation
// to continue
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bHandled;

	if ( conPlay.interactiveCamera )
		bHandled = ProcessCameraKey( key );

	// Check for Ctrl-F9, which is a hard-coded key to take a screenshot
	if ( IsKeyDown( IK_Ctrl ) && ( key == IK_F9 ))
	{
		player.ConsoleCommand("SHOT");			
		return True;
	}

	// If the key wasn't handled, let's take a look to see if we can
	// use it.

	if ( bHandled == False )
	{
		switch( key ) 
		{	
			// Toggle interactive conversations on/off
//			case IK_F1:
//				conPlay.ToggleInteractiveCamera();
//				bHandled = True;
//				break;

			case IK_Escape:
			case IK_Enter:	
			case IK_Space:
				conPlay.PlayNextEvent();
				bHandled = True;
				break;
		}
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// ProcessCameraKey()
//
// Processes keys that control camera movement in conversations
// Returns TRUE if the key is handled here
// ----------------------------------------------------------------------

function bool ProcessCameraKey(EInputKey key)
{
	local float magnitude;
	local bool rotationControl;
	local ConCamera ci;
	local bool bHandled;

	// Get a pointer to the Camera Object for shorthand reference
	ci = conPlay.cameraInfo;

	// Allow the user to hold down shift or ctrl for less/finer
	// resolution

	if ( IsKeyDown(IK_SHIFT) ) 
		magnitude = 10.0;
	else
		magnitude = 1.0;

	// If the user is holding down Control, then we're toying with
	// the camera rotation

	rotationControl = IsKeyDown(IK_CTRL);

	// Keys are different based on whether we're in Speakers or Actor camera mode.

	if (( ci.cameraMode == CT_Actor ) && ( rotationControl == False ))
	{
		switch( key )
		{
			// Move Left/Right (X Axis)
			case IK_Left:
				ci.cameraOffset.X -= (0.10 * magnitude);
				bHandled = True;
				break;
			case IK_Right:
				ci.cameraOffset.X += (0.10 * magnitude);
				bHandled = True;
				break;

			// Move Up/Down (Y Axis)
			case IK_Up:
				ci.cameraOffset.Y -= (0.10 * magnitude);
				bHandled = True;
				break;
			case IK_Down:
				ci.cameraOffset.Y += (0.10 * magnitude);
				bHandled = True;
				break;

			// Zoom-In/Out (Z Axis)
			case IK_A:
				ci.cameraOffset.Z -= (0.10 * magnitude);
				bHandled = True;
				break;
			case IK_Z:
				ci.cameraOffset.Z += (0.10 * magnitude);
				bHandled = True;
				break;		
		}
	}
	else if (( ci.cameraMode == CT_Speakers ) && ( rotationControl == False ))
	{
		switch( key )
		{
			// Center Modifier
			case IK_Left:
				ci.centerModifier += (0.10 * magnitude);
				bHandled = True;
				break;
			case IK_Right:
				ci.centerModifier -= (0.10 * magnitude);
				bHandled = True;
				break;

			// Camera Height Modifier
			case IK_Up:
				ci.heightModifier += (0.10 * magnitude);
				bHandled = True;
				break;
			case IK_Down:
				ci.heightModifier -= (0.10 * magnitude);
				bHandled = True;
				break;

			// Distance Multiplier
			case IK_A:
				ci.distanceMultiplier += (0.10 * magnitude);
				bHandled = True;
				break;
			case IK_Z:
				ci.distanceMultiplier -= (0.10 * magnitude);
				bHandled = True;
				break;
		}
	}

	// If the key still hasn't been handled, check to see there's a key
	// common to both modes

	if ( bHandled == False )
	{
		// Keys common to both modes
		switch( key ) 
		{	
			// Pitch
			case IK_Up:
				ci.rotation.pitch += (100 * magnitude);
				bHandled = True;
				break;
			case IK_Down:
				ci.rotation.pitch -= (100 * magnitude);
				bHandled = True;
				break;

			// Yaw 
			case IK_Left:
				ci.rotation.yaw += (100 * magnitude);
				bHandled = True;
				break;
			case IK_Right:
				ci.rotation.yaw -= (100 * magnitude);
				bHandled = True;
				break;

			// Roll
			case IK_A:
				ci.rotation.roll += (100 * magnitude);
				bHandled = True;
				break;
			case IK_Z:
				ci.rotation.roll -= (100 * magnitude);
				bHandled = True;
				break;

			// Toggle through camera views
			case IK_PageUp:
				ci.IncCameraMode();
				break;

			case IK_PageDown:
				ci.DecCameraMode();
				break;

			// Write camera info to log
			case IK_SPACE:
				ci.LogCameraInfo();
				bHandled = True;
				break;

			// Switch camera modes
			case IK_ENTER:
				ci.SwitchCameraMode();
				bHandled = True;
				break;
		}
	}

	// If we processed this key, update the camera window

	if (( bHandled )  && (cameraWin != None))
		cameraWin.UpdateCameraInfo();

	return bHandled;
}

// ----------------------------------------------------------------------
// ShowReceivedItem()
// ----------------------------------------------------------------------

function ShowReceivedItem(Inventory invItem, int count)
{
}

// ----------------------------------------------------------------------
// SetForcePlay()
// ----------------------------------------------------------------------

function SetForcePlay(bool bNewForcePlay)
{
	bForcePlay = bNewForcePlay;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     conTexture=Texture'DeusExUI.UserInterface.ConWindowBackground'
     ScreenType=ST_Conversation
}
