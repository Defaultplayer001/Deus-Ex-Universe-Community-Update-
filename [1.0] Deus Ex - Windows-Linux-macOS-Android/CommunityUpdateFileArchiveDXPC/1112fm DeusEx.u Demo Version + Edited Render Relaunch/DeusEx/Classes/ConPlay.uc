//=============================================================================
// ConPlay
//=============================================================================
class ConPlay expands ConPlayBase;

var ConEvent currentEvent;

var transient HUDConWindowFirst conWinFirst;		// Third-Person Conversation Window

var Actor currentSpeaker;
var Actor currentSpeakingTo;
var Bool SetupInitialCamera;

var Actor speakingActor;				// Currently Animating speaking Actor
var ConCamera cameraInfo;				// Camera Information
var Bool randomCamera;					// True if random camera placement
var Bool interactiveCamera;				// True when we have interactive camera control
var ConEventMoveCamera pendingCameraEvent;
var Bool bSetupInitialCamera;
var Bool bEndingConversation;
var Bool bWaitingForConWin;
var Bool bActorsTurned;
var Bool bSaveContinueSpeech;
var Bool bSaveNoPlayedFlag;

// If starting a third-person convo, then we want to temporarily
// put away whatever the player may have been holding until the 
// conversation is over.  This variable holds that item. 

var Inventory playerInHand;				

// These variables are used to calculate length of time to display text
// if there is no audio for the text or the player has speech dialog 
// disabled.

var Float perCharDelay;					
var Float minimumTextPause;

// Conversation fonts for third-person convos
var Font ConversationSpeechFonts[2];
var Font ConversationNameFonts[2];

// ----------------------------------------------------------------------
// StartConversation()
//
// Starts a conversation.  
//
// 1.  Initializes the Windowing system
// 2.  Gets a pointer to the first Event
// 3.  Jumps into the 'PlayEvent' state
// ----------------------------------------------------------------------

function Bool StartConversation(DeusExPlayer newPlayer, optional Actor newInvokeActor, optional bool bForcePlay)
{
	if ( Super.StartConversation(newPlayer, newInvokeActor, bForcePlay) == False )
		return False;

	bEndingConversation = False;

	// Check to see if this conversation uses random camera placement
	randomCamera = con.bRandomCamera;

	// Based on whether we're in first-person or third-person mode, 
	// we need to derive our conversation window differently.  First-person
	// conversation mode is non-interactive and only allows speech, for
	// the most part.

	if ( con.bFirstPerson )
	{
		displayMode = DM_FirstPerson;

		conWinFirst = rootWindow.hud.CreateConWindowFirst();

		// Initialize Windowing System
		conWinFirst.conPlay = Self;
	}
	else
	{
		displayMode = DM_ThirdPerson;

		// Hide the hud display if this is a third-person convo
		rootWindow.hud.Hide();

		conWinThird = ConWindowActive(rootWindow.NewChild(Class'ConWindowActive', False));
		conWinThird.SetForcePlay(bForcePlay);

		// Setup default camera information, but only if bForcePlay is set to false
		if (!bForcePlay)
		{
			cameraInfo = con.CreateConCamera();
			cameraInfo.InitializeCameraValues(Self);

			if ( randomCamera )
				cameraInfo.SetupRandomCameraPosition();
		}

		// Initialize Windowing System
		conWinThird.conPlay = Self;

		// Align the conversation window
		conWinThird.SetWindowAlignments(HALIGN_Full, VALIGN_Full);
		conWinThird.Show();
	}

	// Check to see if this is a passive or interactive conversation
	// Passive conversations are beyond the PC's control and do not have
	// things like Choices, etc. in them.

	if ( con.bNonInteractive )
		playMode = PM_Passive;
	else
		playMode = PM_Active;

	// Grab the first event!
	currentEvent = con.eventList;

	// Create a ConHistory object
	if (!bForcePlay)
		SetupHistory(player.GetDisplayName(startActor, True));

	// Play this event!
	GotoState('PlayEvent');

	return True;
}

// ----------------------------------------------------------------------
// SetInHand()
// ----------------------------------------------------------------------

function SetInHand(Inventory newInHand)
{
	playerInHand = newInHand;
}

// ----------------------------------------------------------------------
// TerminateConversation()
//
// Time to go away to that nice happy place!
// ----------------------------------------------------------------------

function TerminateConversation(optional bool bContinueSpeech, optional bool bNoPlayedFlag)
{
	// Save this for when we call Super.TerminateConversation() later
	bSaveContinueSpeech = bContinueSpeech;
	bSaveNoPlayedFlag   = bNoPlayedFlag;

	// Some protection to make sure this doesn't happen 
	// more than once.

	if (!bEndingConversation)
	{
		bEndingConversation = True;

		// Tell the Conversation Window to shut down
		if ((conWinThird != None) && (!bForcePlay))
			GotoState('WaitForConWin');
		else
			ConWinFinished();
	}
}

// ----------------------------------------------------------------------
// PostTerminateConversation()
// ----------------------------------------------------------------------

function PostTerminateConversation()
{
	// Notify the player we're no longer inside 
	// a conversation

	player.EndConversation();

	// Remove the highlights
	if (cameraInfo != None)
		cameraInfo.DestroyHighlights();

	// Save the conversation history
	if ( history != None )
	{
		history.next = player.conHistory;
		player.conHistory = history;
		history = None;		// in case we get called more than once!!
	}

	// If the player was holding something when 
	// the conversation started, put the item back 
	// in his hand.
	if (playerInHand != None)
		player.PutInHand(playerInHand);

	Super.TerminateConversation(bSaveContinueSpeech, bSaveNoPlayedFlag);
}

// ----------------------------------------------------------------------
// ConWinFinished()
//
// Called when the conversation window has finished moving and we 
// can destroy the ConPlay actor.
// ----------------------------------------------------------------------

function ConWinFinished()
{
	// Nuke the conversation window
	if (displayMode == DM_FirstPerson)
	{
		if (conWinFirst != None)
			conWinFirst.Destroy();
	}
	else
	{
		if (conWinThird != None)
			conWinThird.Destroy();

		// Show the hud display if this was a third-person convo
		if (!bForcePlay)
			rootWindow.hud.Show();
	}

	PostTerminateConversation();
 
	// Now nuke ourself.
	Destroy();
}

// ----------------------------------------------------------------------
// JumpToConversation()
//
// Jumps to another conversation
// ----------------------------------------------------------------------

function JumpToConversation( Conversation jumpCon, String startLabel )
{
	assert( jumpCon != None );

	// If this is a new conversation, assign it to our "Con" variable
	// and set the con.conName $ "_Played" flag to True.
	if (jumpCon != con)
	{
		SetPlayedFlag();

		// Some cleanup for the existing conversation
		con.ClearBindEvents();
		con.radiusDistance = saveRadiusDistance;

		// Assign the new conversation and bind the events
		con = jumpCon;
		con.BindEvents(ConActorsBound, startActor);
	}

	// Get the event to start at, or the beginning if one wasn't
	// passed in.  However, if a label is passed in *and* it's not 
	// found, then abort the conversation!!

	currentEvent = con.GetEventFromLabel( startLabel );

	if (( currentEvent == None ) && ( startLabel != "" ))
	{
		Log("ConPlay::JumpToConversation() --------------------------------------");
		Log("  WARNING!  Label [" $ startLabel $ "] NOT FOUND in Conversation [" $ jumpCon.conName $ "]");
		log("  Conversation Terminated.");
		TerminateConversation();
		return;
	}

	if ( currentEvent == None )
		currentEvent = con.eventList;

	// Start the conversation!
	GotoState('PlayEvent');
}

// ----------------------------------------------------------------------
// GetNextEvent()
//
// Returns the next event
// ----------------------------------------------------------------------

function ConEvent GetNextEvent()
{
	return currentEvent.nextEvent;
}

// ----------------------------------------------------------------------
// GetDisplayMode()
// ----------------------------------------------------------------------

function EDisplayMode GetDisplayMode()
{
	return displayMode;
}

// ----------------------------------------------------------------------
// PlayChoice()
//
// Called from ConWindow object when a choice is selected
// ----------------------------------------------------------------------

function PlayChoice( ConChoice choice )
{
	local ConSpeech choiceSpeech;

	// First, save the choice text, but only if the DisplayAsSpeech 
	// flag isn't set, in which case the speech will be setup as a 
	// speech event and saved that way.

	if ( !choice.bDisplayAsSpeech )
	{
		choiceSpeech = new(None) Class'ConSpeech';
		choiceSpeech.speech = choice.choiceText;	
		choiceSpeech.soundID = choice.soundID;

		AddHistoryEvent(player.GetDisplayName(player, True), choiceSpeech );
	}

	// If this choice has a label, then jump to it.  Otherwise just
	// continue with the conversation.

	if ( choice.choiceLabel != "" ) 
		ProcessAction( EA_JumpToLabel, choice.choiceLabel );
	else
		ProcessAction( EA_NextEvent, "" );
}

// ----------------------------------------------------------------------
// PlayNextEvent()
//
// Called from the ConWindow object when the user clicks to 
// continue with Conversation
// ----------------------------------------------------------------------

function PlayNextEvent()
{
	// Restrict input again until we've finished processing this event
	if (conWinThird != None)
		conWinThird.RestrictInput(True);

	// Stop any sound that was playing
	StopSpeech();

	ProcessAction( EA_NextEvent, "" );
}

// ----------------------------------------------------------------------
// ProcessAction()
//
// Processes the current Action
// ----------------------------------------------------------------------

function ProcessAction( EEventAction nextAction, string nextLabel )
{
	// Don't do squat if the currentEvent is NONE
	if (currentEvent == None)
		return;

	switch( nextAction ) 
	{
		case EA_NextEvent:
			// Proceed to the next event.
			lastEvent = currentEvent;
			currentEvent = currentEvent.nextEvent;
			GotoState('PlayEvent');
			break;

		case EA_JumpToLabel:
			// Use the label passed back and jump to it
			lastEvent = currentEvent;
			currentEvent = con.GetEventFromLabel( nextLabel );
			if ( currentEvent == None )
			{
				Log("ConPlay::ProcessAction() - EA_JumpToLabel ----------------------------");
				Log("  WARNING!  Label " $ nextLabel $ " NOT FOUND in Conversation " $ con.conName);
				log("  Conversation Terminated.");
			}
			GotoState('PlayEvent');
			break;

		case EA_JumpToConversation:
			lastEvent = currentEvent;
			JumpToConversation( ConEventJump(currentEvent).jumpCon, nextLabel );
			break;

		case EA_WaitForInput:
			// We need to wait for some user input before
			// proceeding any further, so jump into a wait state
			lastEvent = currentEvent;
			GotoState('WaitForInput');
			break;

		case EA_WaitForSpeech:
			// Wait for a piece of audio to finish playing
			lastEvent = currentEvent;
			GotoState('WaitForSpeech');
			break;
			
		case EA_WaitForText:
			lastEvent = currentEvent;
			GotoState('WaitForText');
			break;
				
		case EA_PlayAnim:
			lastEvent = currentEvent;
			GotoState('ConPlayAnim');
			break;

		case EA_ConTurnActors:
			GotoState('ConTurnActors');
			break;

		case EA_End:
			TerminateConversation();
			break;
	}
}

// ----------------------------------------------------------------------
// PlaySpeech()
// ----------------------------------------------------------------------

function PlaySpeech( int soundID, Actor speaker )
{
	local Sound speech;

	speech = con.GetSpeechAudio(soundID);

	// Keep a pointer to the current speaking pawn so we can stop 
	// the speech animation when we're finished.

	if (speech != None)
	{
		// If this is an intro/endgame, force speech to play through
		// the player so we can *hear* it.
		if (bForcePlay)
		{
			// Check how close the player is to this actor.  If the player is 
			// close enough to the speaker, play through the speaker.
			if ((speaker == None) || (VSize(player.Location - speaker.Location) > 400))
			{
				playingSoundID = player.PlaySound(speech, SLOT_Talk,,,65536.0); 
			}
			else
			{
				playingSoundID = speaker.PlaySound(speech, SLOT_Talk,,,65536.0); 
			}
		}
		else
		{
			// If this is a forced conversation (bCannotBeInterrupted = True)
			// then set the radius higher.  This is a hack.  Yes, a hack, 
			// in some situations where the PC is far from one or more speaking
			// NPCs but needs to be able to overhear them.  Also, want to make
			// this reasonably loud for letterbox convos

			if ((con.bCannotBeInterrupted) || (!con.bFirstPerson))
				playingSoundID = speaker.PlaySound(speech, SLOT_Talk,,,65536.0); 
			else
				playingSoundID = speaker.PlaySound(speech, SLOT_Talk,,,512.0 + initialRadius); 
		}
	}

	StartSpeakingAnimation();
}

// ----------------------------------------------------------------------
// StopSpeech()
// ----------------------------------------------------------------------

function StopSpeech()
{
	Super.StopSpeech();
	StopSpeakingAnimation();
}

// ----------------------------------------------------------------------
// StartSpeakingAnimation()
//
// Start the speaking animation.  We only have animations for Pawns, so if a 
// decoration is speaking there's nothing to animate (this may change).
//
// If this is a speech event, then grab ahold of the speaker.  Otherwise,
// if it's a choice event that's playing the selected choice, the PC 
// is speaking.
// ----------------------------------------------------------------------

function StartSpeakingAnimation()
{
	if ( ConEventSpeech(currentEvent) != None )
		speakingActor = Pawn(ConEventSpeech(currentEvent).speaker);
	else
		speakingActor = player;

	if ( speakingActor != None )
	{
		Pawn(speakingActor).bIsSpeaking = True;
		Pawn(speakingActor).bWasSpeaking = True;
	}
}

// ----------------------------------------------------------------------
// StopSpeakingAnimation()
//
// Stop the speaking animation
// ----------------------------------------------------------------------

function StopSpeakingAnimation()
{
	if ( Pawn(speakingActor) != None )
	{
		Pawn(speakingActor).bIsSpeaking = False;
		speakingActor = None;
	}
}

// ----------------------------------------------------------------------
// PlayEvent()
//
// Plays an event
// Assumes currentEvent is already setup
// ----------------------------------------------------------------------

state PlayEvent
{
	function SetupEvent()
	{
		local EEventAction nextAction;			
		local String nextLabel;

		switch( currentEvent.EventType ) 
		{
			case ET_Speech:
				if ( !bActorsTurned )
					nextAction = SetupEventSpeechPre( ConEventSpeech(currentEvent), nextLabel );
				else
					nextAction = SetupEventSpeechPost( ConEventSpeech(currentEvent), nextLabel );
				break;

			case ET_Choice:
				// Not allowed in passive mode
				if ( playMode == PM_Active )
				{
					nextAction = SetupEventChoice( ConEventChoice(currentEvent), nextLabel );
				}
				break;

			case ET_SetFlag:
				nextAction = SetupEventSetFlag( ConEventSetFlag(currentEvent), nextLabel );
				break;

			case ET_CheckFlag:
				nextAction = SetupEventCheckFlag( ConEventCheckFlag(currentEvent), nextLabel );
				break;

			case ET_CheckObject:
				nextAction = SetupEventCheckObject( ConEventCheckObject(currentEvent), nextLabel );
				break;

			case ET_TransferObject:		
				nextAction = SetupEventTransferObject( ConEventTransferObject(currentEvent), nextLabel );
				break;

			case ET_MoveCamera:
				// Not allowed in passive mode
				if ( playMode == PM_Active )
				{
					nextAction = SetupEventMoveCamera( ConEventMoveCamera(currentEvent), nextLabel );
				}
				break;

			case ET_Animation:
				nextAction = SetupEventAnimation( ConEventAnimation(currentEvent), nextLabel );
				break;

			case ET_Trade:
				// Not allowed in passive mode
				if ( playMode == PM_Active )
				{
					nextAction = SetupEventTrade( ConEventTrade(currentEvent), nextLabel );
				}
				break;

			case ET_Jump:
				nextAction = SetupEventJump( ConEventJump(currentEvent), nextLabel );
				break;

			case ET_Random:
				nextAction = SetupEventRandomLabel( ConEventRandomLabel(currentEvent), nextLabel );
				break;

			case ET_Trigger:
				nextAction = SetupEventTrigger( ConEventTrigger(currentEvent), nextLabel );
				break;

			case ET_AddGoal:
				nextAction = SetupEventAddGoal( ConEventAddGoal(currentEvent), nextLabel );
				break;

			case ET_AddNote:
				nextAction = SetupEventAddNote( ConEventAddNote(currentEvent), nextLabel );
				break;

			case ET_AddSkillPoints:
				nextAction = SetupEventAddSkillPoints( ConEventAddSkillPoints(currentEvent), nextLabel );
				break;

			case ET_AddCredits:
				nextAction = SetupEventAddCredits( ConEventAddCredits(currentEvent), nextLabel );
				break;

			case ET_CheckPersona:
				nextAction = SetupEventCheckPersona( ConEventCheckPersona(currentEvent), nextLabel );
				break;

			case ET_End:
				nextAction = SetupEventEnd( ConEventEnd(currentEvent), nextLabel );
				break;
		}

		// Based on the result of the setup, we either need to jump to another event
		// or wait for some input from the user.

		ProcessAction( nextAction, nextLabel );
	}

Begin:
	if ( currentEvent == None )
		TerminateConversation();
	else
		SetupEvent();
}

// ----------------------------------------------------------------------
// State WaitForConWin()
// ----------------------------------------------------------------------

state WaitForConWin
{
	function Timer()
	{
		if ( (( displayMode == DM_FirstPerson ) && (conWinFirst != None) && ( !conWinFirst.IsVisible())) || 
			 (( displayMode == DM_ThirdPerson ) && (conWinThird != None) && ( !conWinThird.IsVisible())) )
		{
			SetTimer(0, False);
			ConWinFinished();
		}
		else
		{
			SetTimer(0.2, True);
		}
	}

	function PlayNextEvent()
	{
		SetTimer(0, False);
		ConWinFinished();
	}

	function CloseConWindow()
	{
		if ( displayMode == DM_FirstPerson ) 
		{
			if (conWinFirst != None )
				conWinFirst.Close();
		}
		else
		{
			if (conWinThird != None)
				conWinThird.Close();
		}

		// Wait for the window to finish
		SetTimer(0.2, True);
	}

	function BeginState()
	{
		// Allow input
		if (conWinThird != None)
			conWinThird.RestrictInput(False);

		CloseConWindow();
	}
}

// ----------------------------------------------------------------------
// GetCurrentSpeechFont()
// ----------------------------------------------------------------------

function Font GetCurrentSpeechFont()
{
	local int resWidth;

	resWidth = GetCurrentResolutionWidth();

	if ((resWidth > 800) && (resWidth < 1280))
		return ConversationSpeechFonts[1];
	else
		return ConversationSpeechFonts[0];
}

// ----------------------------------------------------------------------
// GetCurrentNameFont()
// ----------------------------------------------------------------------

function Font GetCurrentNameFont()
{
	local int resWidth;

	resWidth = GetCurrentResolutionWidth();

	if ((resWidth > 800) && (resWidth < 1280))
		return ConversationNameFonts[1];
	else
		return ConversationNameFonts[0];
}

// ----------------------------------------------------------------------
// GetCurrentResolutionWidth()
// ----------------------------------------------------------------------

function int GetCurrentResolutionWidth()
{
	local int p;
	local int resX;
	local int resWidth;
	local string CurrentRes;

	CurrentRes   = player.ConsoleCommand("GetCurrentRes");

	resX      = InStr(CurrentRes,"x");
	resWidth  = int(Left(CurrentRes, resX));

	return resWidth;
}

// ----------------------------------------------------------------------
// ToggleInteractiveCamera()
//
// Toggles the interactive camera on and off, which allows the user to
// screw around the with the camera in Conversation mode
// ----------------------------------------------------------------------

function ToggleInteractiveCamera()
{
	if (cameraInfo != None)
	{
		interactiveCamera = !interactiveCamera;

		if ( interactiveCamera )
		{
			conWinThird.CreateCameraWindow();
			UpdateCameraInfo();
		}
		else
		{
			conWinThird.DestroyCameraWindow();
		}

		cameraInfo.SetInteractiveCamera(interactiveCamera);
	}
}

// ----------------------------------------------------------------------
// UpdateCameraInfo()
// ----------------------------------------------------------------------

function UpdateCameraInfo()
{
	if (conWinThird != None)
		conWinThird.UpdateCameraInfo();
}

// ----------------------------------------------------------------------
// SetCameraActors()
//
// If we have a "SpeakingTo" actor, then we'll use it as the actor who's 
// being spoken to.  Otherwise use the last actor that was speaking.
// ----------------------------------------------------------------------

function SetCameraActors()
{
	// Totally ignore this if "bForcePlay" is set to true
	if (bForcePlay)
		return;

	if ((currentspeaker != None) && (currentSpeakingTo != None))
	{
		// Update the Actors used by the camera
		if (cameraInfo != None)
		{
			// If we have a pending camera event, then notify the 
			// camera system with the actors
			
			if (pendingCameraEvent != None)
			{
				cameraInfo.SetActors(currentSpeaker, currentSpeakingTo);
				cameraInfo.SetupCameraFromEvent(pendingCameraEvent);
				pendingCameraEvent = None;
				bSetupInitialCamera = True;
			}

			// Otherwise, if we're using a fallback camera and it's a headshot
			// then we want to make sure the camera is properly trained on 
			// the person talking.

			else if ((cameraInfo.UsingFallbackCamera()) && (cameraInfo.UsingHeadshot()))
			{
				cameraInfo.SetActors(currentSpeaker, currentSpeakingTo);
			}
		}

		// If we haven't setup an initial camera then do so, 
		// because we don't want to play a speech or choice
		// event without the camera first having been placed

		if ((cameraInfo != None) && (!bSetupInitialCamera))
		{
			cameraInfo.SetActors(currentSpeaker, currentSpeakingTo);
			cameraInfo.SetupFallbackCamera();
			bSetupInitialCamera = True;
		}
	}
}

// ----------------------------------------------------------------------
// state ConPlayAnim
//
// Plays an animation and then runs the next event.
// Optionally will wait for the animation to finish
// ----------------------------------------------------------------------

state ConPlayAnim
{
Begin:
	
	// Check to see if we need to just play this animation once or 
	// loop it.
	
	if ( ConEventAnimation(currentEvent).bLoopAnim ) 
		ConEventAnimation(currentEvent).eventOwner.LoopAnim( ConEventAnimation(currentEvent).sequence );
	else
		ConEventAnimation(currentEvent).eventOwner.PlayAnim( ConEventAnimation(currentEvent).sequence );

	// If we're not looping the animation and we need to wait for this one to finish,
	// then do so.

	if (( !ConEventAnimation(currentEvent).bLoopAnim ) && ( ConEventAnimation(currentEvent).bFinishAnim ))
		ConEventAnimation(currentEvent).eventOwner.FinishAnim();

	currentEvent = currentEvent.nextEvent;
	GotoState('PlayEvent');
}

// ----------------------------------------------------------------------
// state ConTurnActors
//
// Turns the actors to face each other when speaking
// ----------------------------------------------------------------------

state ConTurnActors
{

Begin:
	// We used to turn the actors here, but this is now handled by
	// the pawns themselves...

	bActorsTurned = True;
	GotoState('PlayEvent');
}

// ----------------------------------------------------------------------
// state WaitForSpeech
//
// Waiting for a sound to finish playing
// ----------------------------------------------------------------------

state WaitForSpeech
{
	// We get here when the timer we set when playing the sound
	// has finished.  We want to play the next event.
	function Timer()
	{
		GotoState( 'WaitForSpeech', 'SpeechFinished' );
	}

SpeechFinished:
	// Restrict input
	if (conWinThird != None)
		conWinThird.RestrictInput(True);

	StopSpeakingAnimation();

	// Sleep for a second before continuing
	Sleep(0.5);

	// Fire the next event
	PlayNextEvent();
	Stop;

Idle:
	// Allow input
	if (conWinThird != None)
		conWinThird.RestrictInput(False);

	Sleep(0.5);
	Goto('Idle');

Begin:
	// If this is a first person conversation and A) we don't have speech
	// or B) we're in "Subtitles Only" mode, then set a timer based on 
	// the length of speech.

	if ( ConEventSpeech(currentEvent).conSpeech.soundID == -1 )
	{
		SetTimer( FMax(lastSpeechTextLength * perCharDelay, minimumTextPause), False );
	}
	else
	{
		// Play the sound, set the timer and go to sleep until the sound
		// has finished playing.
		
		// First Stop any sound that was playing
		PlaySpeech( ConEventSpeech(currentEvent).conSpeech.soundID, ConEventSpeech(currentEvent).Speaker ); 

		// Add two seconds to the sound since there seems to be a slight lag
		SetTimer( con.GetSpeechLength(ConEventSpeech(currentEvent).conSpeech.soundID), False );
	}

	Goto('Idle');
}

// ----------------------------------------------------------------------
// state WaitForText
//
// Waiting for a text to finish
// ----------------------------------------------------------------------

state WaitForText
{
	// We get here when the timer we set when playing the sound
	// has finished.  We want to play the next event.
	function Timer()
	{
		GotoState( 'WaitForText', 'TextFinished' );
	}

TextFinished:
	// Fire the next event

	// Restrict input
	if (conWinThird != None)
		conWinThird.RestrictInput(True);

	PlayNextEvent();
	Stop;

Idle:
	// Allow input
	if (conWinThird != None)
		conWinThird.RestrictInput(False);

	Sleep(0.5);
	Goto('Idle');

Begin:
	SetTimer( FMax(lastSpeechTextLength * perCharDelay, minimumTextPause), False );
	Goto('Idle');
}

// ----------------------------------------------------------------------
// state WaitForInput
//
// We're waiting to come back from an event that requires User Input (such as 
// the speech and choice events)
// ----------------------------------------------------------------------

state WaitForInput
{
Begin:
	// Allow input
	if (conWinThird != None)
		conWinThird.RestrictInput(False);

	Sleep(1);
	goto('Begin');
}

// ----------------------------------------------------------------------------
// All the unique Setup routines for each event type are located here
// ----------------------------------------------------------------------------

function EEventAction SetupEventSpeechPre( ConEventSpeech event, out String nextLabel )
{
	nextLabel = "";
	return EA_ConTurnActors;
}

// ----------------------------------------------------------------------
// SetupEventSpeechPost()
//
// Display the speech and wait for feedback.
// ----------------------------------------------------------------------

function EEventAction SetupEventSpeechPost( ConEventSpeech event, out String nextLabel )
{
	local EEventAction nextAction;
	local ConEvent checkEvent;
	local String speech;
	local bool bHaveSpeechAudio;

	bActorsTurned = False;

	// Restrict input until we've finished setting up this event
	if (conWinThird != None)
		conWinThird.RestrictInput(True);

	// Keep track of the current speaker and speaking to actors
	if ((currentSpeaker != event.speaker) || (currentSpeakingTo != event.speakingTo))
	{
		// If we're in "Random Camera" mode, then we want to 
		// pick a new camera position.

		if ((randomCamera) && (cameraInfo != None))
			cameraInfo.SetupRandomCameraPosition();

		// Update our actor variables
		currentSpeaker    = event.speaker;
		currentSpeakingTo = event.speakingTo;

		UpdateCameraInfo();
	}

	// Update the Actors used by the camera
	SetCameraActors();

	// Cause the speaking actor to turn towards the person he is
	// speaking to.
	TurnSpeakingActors(event.speaker, event.speakingTo);

	// Calculate the length of the text string, this is used later


	speech = event.conSpeech.speech;

	bHaveSpeechAudio = (event.conSpeech.soundID != -1);

	lastSpeechTextLength = len(speech);

	// Display the speech text, if:
	// 
	// 1.  Player has bSubtitles flag on
	// 2.  No speech audio exists for the speech

	if ((player.bSubtitles) || (!bHaveSpeechAudio))
	{			
		if ( displayMode == DM_FirstPerson )
			conWinFirst.Show();

		// If we're continuing from the last speech, then we want to Append 
		// and not Display the first chunk.
		if ( event.bContinued == True )
		{
			if ( displayMode == DM_FirstPerson )
				conWinFirst.AppendText( speech );
			else
				conWinThird.AppendText( speech );
		}
		else
		{
			if ( displayMode == DM_FirstPerson )
			{	
				// Clear the window
				conWinFirst.Clear();

				conWinFirst.DisplayName( player.GetDisplayName(event.speaker) );
				conWinFirst.DisplayText( speech, currentSpeaker );
			}
			else
			{
				// Clear the window
				conWinThird.Clear();

				conWinThird.DisplayName( player.GetDisplayName(event.speaker) );
				conWinThird.DisplayText( speech, currentSpeaker );
			}
		}
	}
	else if (displayMode == DM_FirstPerson)
	{
		conWinFirst.Hide();
	}

	// Save this event in the history
	AddHistoryEvent(player.GetDisplayName(event.Speaker, True), event.conSpeech);

	// If we have speech audio, play it!
	if (bHaveSpeechAudio)
	{
		nextAction = EA_WaitForSpeech;
	}
	else
	{
		// Otherwise, we'll wait for the text to play (either in passive mode, which
		// means the text will continue on its own, or in ACTIVE mode, in which case
		// we'll wait for a keypress before continuing.

		if (( playMode == PM_PASSIVE ) || ( displayMode == DM_FirstPerson ))
		{
			nextAction = EA_WaitForText;
		}
		else
		{
			// If we're here, we either have no speech or we're in a text-only mode
			//
			// We want to wait for input unless the next event is a 
			// speech event and has the "Continued" flag set, which 
			// allows for additional speech and choices to 
			// appear immediately after the current speech.
			//
			// Choices automatically continue unless they have the "Clear Screen"
			// flag set.

			checkEvent = GetNextEvent();

			if ( (( ConEventChoice(checkEvent) != None ) && ( !ConEventChoice(checkEvent).bClearScreen )) || 
			   (( ConEventSpeech(checkEvent) != None ) && ( ConEventSpeech(checkEvent).bContinued )) )
				nextAction = EA_NextEvent;
			else
				nextAction = EA_WaitForInput;
		}
	}

	nextLabel = "";
	return nextAction;
}

// ----------------------------------------------------------------------
// SetupEventChoice()
// ----------------------------------------------------------------------

function EEventAction SetupEventChoice( ConEventChoice event, out String nextLabel )
{
	local ConChoice choice;
	local ButtonWindow newButton;
	local int choiceCount;
	local EEventAction nextAction;

	// Notify the conversation window to ignore input until we're done
	// creating the choices (this is done to prevent the user from being
	// able to make a choice while drawing, only a problem on slow machines)

	if (conWinThird != None)
		conWinThird.RestrictInput(True);

	// For choices, the speaker is always the player.  The person being 
	// spoken to, well, that's more complicated (unless I force that to be
	// set in ConEdit).  For now we'll assume that the owner of the 
	// conversation is the person being spoken to.

	currentSpeaker    = player;
	currentSpeakingTo = startActor;
	
	// Update the Actors used by the camera
	SetCameraActors();

	// Clear the screen if need be
	if ( event.bClearScreen )
		conWinThird.Clear();

	// Okay, we want to create as many buttons as we have choices
	// and display them.  We'll then return and let conPlay get some
	// user input.  

	choice = event.ChoiceList;
	choiceCount = 0;

	while( choice != None )
	{	
		// Before we blindly display this choice, we first need to check a 
		// few things.  Specifically: 
		// 
		// 1.  Check to see if any flags are associated with this choice.
		// 2.  Check to see if this choice is skill-based.
		// 3.  If there are *NO* valid choices, skip to the next event
		//     as a failsafe
		//
		// If the above conditions are met, then display the choice.
		
		if ( player.CheckFlagRefs( choice.flagRef ) )
		{			
			// Now check the skills		
			if ( choice.skillNeeded != None )
			{
				// Does player have it?
				if ( player.SkillSystem.IsSkilled(choice.skillNeeded, choice.skillLevelNeeded) )
				{
					// Display the choice with some feedback!
					conWinThird.DisplaySkillChoice( choice );
					choiceCount++;
				}
			}
			else
			{
				// Plain old vanilla choice
				conWinThird.DisplayChoice(choice);
				choiceCount++;
			}
		}

		choice = choice.nextChoice;
	}

	nextLabel = "";

	if ( choiceCount > 0 ) 
		nextAction = EA_WaitForInput;
	else
		nextAction = EA_NextEvent;

	// Okay to accept user input again
	if (conWinThird != None)
		conWinThird.RestrictInput(False);

	return nextAction;
}

// ----------------------------------------------------------------------
// SetupEventMoveCamera()
// ----------------------------------------------------------------------

function EEventAction SetupEventMoveCamera( ConEventMoveCamera event, out String nextLabel )
{
	pendingCameraEvent = event;

	nextLabel = "";
	return EA_NextEvent;
}

// ----------------------------------------------------------------------
// SetupEventEnd()
// ----------------------------------------------------------------------

function EEventAction SetupEventEnd( ConEventEnd event, out String nextLabel )
{
	nextLabel = "";
	return EA_End;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     perCharDelay=0.100000
     minimumTextPause=3.000000
     ConversationSpeechFonts(0)=Font'DeusExUI.FontConversation'
     ConversationSpeechFonts(1)=Font'DeusExUI.FontConversationLarge'
     ConversationNameFonts(0)=Font'DeusExUI.FontConversationBold'
     ConversationNameFonts(1)=Font'DeusExUI.FontConversationLargeBold'
     bHidden=True
}
