//=============================================================================
// ConWindowActive
//
// Used for third-person, interactive conversations with the PC involved.
//=============================================================================
class ConWindowActive extends ConWindow;

var Window upperConWindow;						// Upper letterbox region
var int numChoices;								// Number of choice buttons
var ConChoiceWindow conChoices[10];				// Maximum of ten buttons
var HUDReceivedDisplay winReceived;
var bool bRestrictInput;

var Color colConTextFocus;
var Color colConTextChoice;
var Color colConTextSkill;

var float currentWindowPos;
var float lowerFinalHeightPercent;
var float upperFinalHeightPercent;

var float movePeriod;

enum EMoveModes {
	MM_Enter,
	MM_Exit,
	MM_None
};

var EMoveModes moveMode;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	root.ShowCursor(False);

	// Modify lower window
	lowerConWindow.SetBackgroundStyle(DSTY_Normal);

	// Create upper window
	upperConWindow = NewChild(Class'Window');
	upperConWindow.SetBackground(conTexture);

	moveMode = MM_None;

	CreateReceivedWindow();
}

// ----------------------------------------------------------------------
// DestroyWindow()
// ----------------------------------------------------------------------

event DestroyWindow()
{
	// Turn the cursor back on
	root.ShowCursor(True);
}

// ----------------------------------------------------------------------
// RestrictInput()
// ----------------------------------------------------------------------

function RestrictInput(bool bNewRestrictInput)
{
	bRestrictInput = bNewRestrictInput;
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
	local float increment;

	Super.Tick(deltaSeconds);

	// Compute how much we should move the windows this frame
	increment = deltaSeconds/movePeriod;

	// Check to see if we're moving up or down

	switch( moveMode )
	{
		case MM_Enter:
			currentWindowPos += increment;
			if (currentWindowPos >= 1.0)
			{
				currentWindowPos = 1.0;
				moveMode = MM_None;
			}
			AskParentForReconfigure();
			break;

		case MM_Exit:
			// Don't increment while the Items Received window
			// is still active

			if (!winReceived.IsVisible())
			{
				currentWindowPos -= increment;
				if (currentWindowPos <= 0.0)
				{
					currentWindowPos = 0.0;
					moveMode = MM_None;
					Hide();
				}
				AskParentForReconfigure();
			}
			break;

		default:
			bTickEnabled = False;
	}
}

// ----------------------------------------------------------------------
// Close()
//
// Called when the conversation is over and we need to gracefully
// close the window.  Sets up the two child windows so they'll 
// move offscreen
// ----------------------------------------------------------------------

function Close()
{
	moveMode     = MM_Exit;
	bTickEnabled = True;
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
//
// Resize the letterbox regions when we get this event
// ----------------------------------------------------------------------

event ConfigurationChanged()
{
	CalculateWindowSizes();
}

// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

event bool ChildRequestedReconfiguration(window childWin)
{
	return False;
}

// ----------------------------------------------------------------------
// VisibilityChanged()
// ----------------------------------------------------------------------

event VisibilityChanged(bool bNewVisibility)
{
	local RootWindow root;

	Super.VisibilityChanged(bNewVisibility);

	// We're visible -- start moving the windows in
	if (bNewVisibility)
	{
		moveMode     = MM_Enter;
		bTickEnabled = true;
	}

	// We're *not* visible -- reset everything
	else
	{
		moveMode     = MM_None;
		bTickEnabled = false;
		root = GetRootWindow();
		if (root != None)
			root.ResetRenderViewport();
	}
}

// ----------------------------------------------------------------------
// CalculateWindowSizes()
// ----------------------------------------------------------------------

function CalculateWindowSizes()
{
	local float lowerHeight;
	local float upperHeight;
	local float lowerCurrentPos;
	local float upperCurrentPos;
	local float recWidth, recHeight;
	local float cinHeight;
	local float ratio;
	local RootWindow root;

	root = GetRootWindow();

	// Determine the height of the convo windows, based on available space
	if (bForcePlay)
	{
		// calculate the correct 16:9 ratio
		ratio = 0.5625 * (root.width / root.height);
		cinHeight = root.height * ratio;

		upperCurrentPos = 0;
		upperHeight     = int(0.5 * (root.height - cinHeight));
		lowerCurrentPos = upperHeight + cinHeight;
		lowerHeight     = upperHeight;

		// make sure we don't invert the letterbox if the screen size is strange
		if (upperHeight < 0)
			root.ResetRenderViewport();
		else
			root.SetRenderViewport(0, upperHeight, width, cinHeight);
	}
	else
	{
		upperHeight = int(height * upperFinalHeightPercent);
		lowerHeight = int(height * lowerFinalHeightPercent);

		// Compute positions for the convo windows
		lowerCurrentPos = int(height - (lowerHeight*currentWindowPos));
		upperCurrentPos = int(-upperHeight * (1.0-currentWindowPos));

		// Squeeze the rendered area
		if (root != None)
			root.SetRenderViewport(0, upperCurrentPos+upperHeight,
		                       width, lowerCurrentPos-(upperCurrentPos+upperHeight));
	}

	// Configure conversation windows
	if (upperConWindow != None)
		upperConWindow.ConfigureChild(0, upperCurrentPos, width, upperHeight);
	if (lowerConWindow != None)
		lowerConWindow.ConfigureChild(0, lowerCurrentPos, width, lowerHeight);

	// Configure Received Window
	if (winReceived != None)
	{
		winReceived.QueryPreferredSize(recWidth, recHeight);
		winReceived.ConfigureChild(10, lowerCurrentPos - recHeight - 5, recWidth, recHeight);
	}

	ConfigureCameraWindow(lowerCurrentPos);
}

// ----------------------------------------------------------------------
// DisplayChoice()
//
// Displays a choice, but sets up the button a little differently than 
// when displaying normal conversation text
// ----------------------------------------------------------------------

function DisplayChoice( ConChoice choice )
{
	local ConChoiceWindow newButton;

	newButton = CreateConButton( HALIGN_Left, colConTextChoice, colConTextFocus );
	newButton.SetText( "~ " $ choice.choiceText );
	newButton.SetUserObject( choice );

	// These next two calls handle highlighting of the choice
	newButton.SetButtonTextures(,Texture'Solid', Texture'Solid', Texture'Solid');
	newButton.SetButtonColors(,colConTextChoice, colConTextChoice, colConTextChoice);

	// Add the button
	AddButton( newButton );
}

// ----------------------------------------------------------------------
// DisplaySkillChoice()
//
// Displays a Skilled choice, a choice that's only visible if the user
// has a particular skill at a certain skill level
// ----------------------------------------------------------------------

function DisplaySkillChoice( ConChoice choice )
{
	local ConChoiceWindow newButton;

	newButton = CreateConButton( HALIGN_Left, colConTextSkill, colConTextFocus );
	newButton.SetText( 	"~  " $ choice.choiceText $ "  (" $ choice.SkillNeeded $ ":" $ choice.SkillLevelNeeded $ ")" );
	newButton.SetUserObject( choice );

	// Add the button
	AddButton( newButton );
}

// ----------------------------------------------------------------------
// AddButton()
//
// Creates a button to display text or a choice.
// ----------------------------------------------------------------------

function AddButton( ConChoiceWindow newButton )
{
	// Turn the cursor on so the user can use the cursor to 
	// select a choice.
	root.ShowCursor(True);

	// Add to our button array
	conChoices[numChoices++] = newButton;
}


// ----------------------------------------------------------------------
// DestroyChildren()
//
// Destroys all the buttons used to display  choices.
// ----------------------------------------------------------------------

function DestroyChildren()
{
	local int buttonIndex;

	Super.DestroyChildren();

	// Clear our array as well

	for ( buttonIndex=0; buttonIndex<numChoices; buttonIndex++ )
		conChoices[buttonIndex] = None;

	numChoices = 0;
}

// ----------------------------------------------------------------------
// ButtonActivated()
//
// We received a button click, which we want to return to the ConPlay
// object so it can process it.
//
// We'll just return the index into our array of buttons and let
// ConPlay figure out what to do with it!
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local int buttonIndex;

	// Abort if we're restricting input
	if (bRestrictInput)
		return True;

	// Restrict input again until we've finished processing this choice
	bRestrictInput = True;

	// Abort if we're in the process of moving
	if ( moveMode != MM_None )
		return True;

	// Take a look to make sure it's one of our buttons before continuing.
	for ( buttonIndex=0; buttonIndex<numChoices; buttonIndex++ )
	{
		if (conChoices[buttonIndex] == buttonPressed)
		{
			// Turn the cursor back off
			root.ShowCursor(False);
			conPlay.PlayChoice( ConChoice(conChoices[buttonIndex].GetUserObject()) );

			// Clear the screen
			Clear();

			break;
		}
	}

	return True;
}

// ----------------------------------------------------------------------
// MouseButtonReleased
//
// If there are no choices visible, the user can click anywhere on the screen
// to continue.  Otherwise the user must click on one of the choices to 
// continue.
// ----------------------------------------------------------------------

event bool MouseButtonReleased(float pointX, float pointY, EInputKey button, int numClicks)
{
	// Abort if we're restricting input
	if (bRestrictInput)
		return True;

	// Ignore keys in bForcePlay mode
	if (bForcePlay)
	{
		AbortCinematicConvo();
		return True;
	}
	
	// Abort if we're in the process of moving
	if ( moveMode != MM_None )
		return True;

	if ( numChoices == 0 ) 
		conPlay.PlayNextEvent();

	return True;
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// If the user hits Return while just Speech is displayed, allow them 
// to continue
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bHandled;
	bHandled = True;

	// Abort if we're restricting input
	if (bRestrictInput)
		return True;

	// Ignore keys in bForcePlay mode
	if (bForcePlay)
	{
		if (key == IK_Escape)
		{	
			AbortCinematicConvo();
			return True;
		}
		else
		{
			return False;
		}
	}
	
	// Check for Ctrl-F9, which is a hard-coded key to take a screenshot
	if ( IsKeyDown( IK_Ctrl ) && ( key == IK_F9 ))
	{
		player.ConsoleCommand("SHOT");			
		return True;
	}

	if (( conPlay.interactiveCamera ) && ( key != IK_F1 ))
	{
		ProcessCameraKey( key );
	}
	else
	{
		switch( key ) 
		{	
			// Toggle interactive conversations on/off
//			case IK_F1:
//				conPlay.ToggleInteractiveCamera();
//				break;

			case IK_Escape:
			case IK_Enter:	
			case IK_Space:
				if ( numChoices == 0 )
					conPlay.PlayNextEvent();
				break;

			// Let Up and Down arrows through for choices
			case IK_Up:
			case IK_Down:
				bHandled = False;
				break;
		}
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// AbortCinematicConvo()
// ----------------------------------------------------------------------

function AbortCinematicConvo()
{
	local MissionEndgame script;
	local DeusExPlayer localPlayer;

	localPlayer = player;

	conPlay.TerminateConversation();

	foreach localPlayer.AllActors(class'MissionEndgame', script)	
		break;

	if (script != None)
		script.FinishCinematic();
}

// ----------------------------------------------------------------------
// CreateConButton()
// ----------------------------------------------------------------------

function ConChoiceWindow CreateConButton( EHAlign hAlign, Color colTextNormal, Color colTextFocus )
{
	local ConChoiceWindow newButton;

	newButton = ConChoiceWindow(lowerConWindow.NewChild(Class'ConChoiceWindow'));
	newButton.SetTextAlignments(hAlign, VALIGN_Center);
	newButton.SetTextMargins(10, 2);
	newButton.SetFont(conPlay.GetCurrentSpeechFont());
	newButton.SetTextColors( colTextNormal, colTextFocus, colTextFocus, colTextFocus );

	return newButton;
}

// ----------------------------------------------------------------------
// CreateReceivedWindow()
// ----------------------------------------------------------------------

function CreateReceivedWindow()
{
	winReceived = HUDReceivedDisplay(NewChild(Class'HUDReceivedDisplay'));
	winReceived.Hide();
}

// ----------------------------------------------------------------------
// ShowReceivedItem()
// ----------------------------------------------------------------------

function ShowReceivedItem(Inventory invItem, int count)
{
	if (winReceived != None)
	{
		winReceived.AddItem(invItem, count);
	}
}

// ----------------------------------------------------------------------
// SetForcePlay()
// ----------------------------------------------------------------------

function SetForcePlay(bool bNewForcePlay)
{
	Super.SetForcePlay(bNewForcePlay);

	if (bForcePlay)
		movePeriod = 0.0;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colConTextFocus=(R=255,G=255)
     colConTextChoice=(B=255)
     colConTextSkill=(R=255)
     lowerFinalHeightPercent=0.210000
     upperFinalHeightPercent=0.104000
     movePeriod=0.600000
     conTexture=Texture'DeusExUI.UserInterface.ConWindowActiveBackground'
}
