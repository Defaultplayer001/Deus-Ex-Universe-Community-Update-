//=============================================================================
// DataLinkPlay
//=============================================================================
class DataLinkPlay expands ConPlayBase
	transient;

struct S_InfoLinkNames 
{
	var String BindName;
	var String DisplayName;
};

var HUDInfoLinkDisplay datalink;			    // Window that displays the datalink
var Sound		startSound;
var Float		eventTimer;
var Bool		bStartTransmission;
var Bool		bEndTransmission;
var Float		blinkRate;
var Float		startDelay;
var Float		endDelay;
var Float		perCharDelay;
var Bool        bSilent;

// Array of Bind -> Display names. Yes, horrible hack. Oh well.
var S_InfoLinkNames infoLinkNames[17];

// Queue to support queuing of up to eight DataLinks
var Conversation dataLinkQueue[8];

// Save the DatalinkTrigger so we can notify the trigger when 
// the datalink has finished playing.
var DatalinkTrigger datalinkTrigger;

var localized String EndTransmission;

// ----------------------------------------------------------------------
// SetConversation()
//
// Sets the conversation to be played.  Returns True if successful
// ----------------------------------------------------------------------

function bool SetConversation( Conversation newCon )
{
	local bool bConSet;

	// If this is the first conversation, then 
	// set the 'con' variable.

	bConSet = False;

	if ((con == None) && (dataLink == None))
	{
		startCon = newCon;
		con      = newCon;
		bConSet  = True;
	}
	else
	{
		if (PushDataLink(newCon) && (dataLink != None))
		{
			dataLink.MessageQueued(True);
			bConSet = True;
		}
	}

	return bConSet;
}

// ----------------------------------------------------------------------
// SetTrigger()
// ----------------------------------------------------------------------

function SetTrigger(DataLinkTrigger newDatalinkTrigger)
{
	datalinkTrigger = newDatalinkTrigger;
}

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
	local Actor tempActor;

	if ( Super.StartConversation(newPlayer, newInvokeActor, bForcePlay) == False )
		return False;

	// Create the DataLink display if necessary.  If it already exists,
	// then we're presently in a DataLink and need to queue this one up
	// for play after the current DataLink is finished.
	//
	// Don't play the DataLink if 
	//
	// 1.  A First-person conversation is currently playing 
	// 2.  Player is rooting around inside a computer
	//
	// In these cases we'll just queue it up instead

	if ( ( dataLink == None ) && 
	    ((player.conPlay == None) && (NetworkTerminal(rootWindow.GetTopWindow()) == None)))
	{
		lastSpeechTextLength = 0;
		bEndTransmission = False;
		eventTimer = 0;

		datalink = rootWindow.hud.CreateInfoLinkWindow();

		if ( dataLinkQueue[0] != None )
			dataLink.MessageQueued(True);
	}
	else
	{
		return True;
	}

	// Grab the first event!
	currentEvent = con.eventList;

	// Create the history object.  Passing in True means
	// this is an InfoLink conversation.
	SetupHistory(GetDisplayName(con.GetFirstSpeakerDisplayName()), True);

	// Play a sound and wait a few seconds before starting
	datalink.ShowTextCursor(False);
	player.PlaySound(startSound, SLOT_None); 
	bStartTransmission = True;
	SetTimer(blinkRate, True);
	return True;
}
	
// ----------------------------------------------------------------------
// TerminateConversation()
// ----------------------------------------------------------------------

function TerminateConversation(optional bool bContinueSpeech, optional bool bNoPlayedFlag)
{
	// Make sure sound is no longer playing
	player.StopSound(playingSoundId);

	// Save the DataLink history
	if ((history != None) && (player != None))
	{
		history.next = player.conHistory;
		player.conHistory = history;
		history = None;		// in case we get called more than once!!
	}

	SetTimer(blinkRate, True);

	if ((dataLink != None) && (datalink.winName != None))
		datalink.winName.SetText(EndTransmission);

	bEndTransmission = True;

	// Notify the trigger that we've finished
	NotifyDatalinkTrigger();

	Super.TerminateConversation(bContinueSpeech, bNoPlayedFlag);
}

// ----------------------------------------------------------------------
// NotifyDatalinkTrigger()
// ----------------------------------------------------------------------

function NotifyDatalinkTrigger()
{
 	if (datalinkTrigger != None)
		datalinkTrigger.DatalinkFinished();
}

// ----------------------------------------------------------------------
// AbortDataLink()
//
// Aborts the current datalink playing immediately
// ----------------------------------------------------------------------

function AbortDataLink()
{
	// Make sure there's no audio playing
	player.StopSound(playingSoundId);

	GotoState('');

	SetTimer(0.0, False);

	if (dataLink != None)
	{
		rootWindow.hud.DestroyInfoLinkWindow();
		dataLink = None;

		// Put the currently playing DataLink at the front of the queue,
		// but *only* if the bEndTransmission flag isn't set (which means
		// we're just waiting for the "END TRANSMISSION" pause at the end
		// of a DataLink).

		if (!bEndTransmission)
			InsertDataLink(con);	
	}

	con          = None;
	currentEvent = None;
	lastEvent    = None;
}

// ----------------------------------------------------------------------
// ResumeDataLinks()
//
// Resumes aborted and queued DataLinks
// ----------------------------------------------------------------------

function ResumeDataLinks()
{
	SetConversation(PopDataLink());

	if ( con != None )
	{
		StartConversation(player, invokeActor);
	}
	else
	{
		if (dataLink != None)
		{
			rootWindow.hud.DestroyInfoLinkWindow();
			dataLink = None;
		}
		player.dataLinkPlay = None;
		Destroy();
	}
}

// ----------------------------------------------------------------------
// InsertDataLink()
//
// Inserts a DL at the front of the queue.
// ----------------------------------------------------------------------

function InsertDataLink( Conversation insertCon )
{
	local Int queueIndex;

	// Bump all the existing DataLinks up one.  If we already have a 
	// full stack we'll lose the last one (but this should never happen)

	for( queueIndex=7; queueIndex>0; queueIndex-- )
		dataLinkQueue[queueIndex] = dataLinkQueue[queueIndex-1];

	// Now insert the conversation at the beginning
	dataLinkQueue[0] = insertCon;
}

// ----------------------------------------------------------------------
// PushDataLink()
//
// Queues a DataLink for play after the current DataLink is complete.
// ----------------------------------------------------------------------

function bool PushDataLink( Conversation queueCon )
{
	local Int queueIndex;
	local Bool bPushed;

	bPushed = False;

	// If this is the currently playing datalink, don't requeue it
	// 
	// We're using the startCon variable, as we want to check the 
	// conversation that was -started initially-, as opposed to a 
	// conversation that was -jumped into-. 

	if ( queueCon == startCon )
		return bPushed;
		
	// Now push this conversation on the stack
	for( queueIndex=0; queueIndex<8; queueIndex++ )
	{
		// If this conversation is already in the queue, 
		// don't queue it again
		if ( dataLinkQueue[queueIndex] == queueCon )
			break;

		if ( dataLinkQueue[queueIndex] == None )
		{
			dataLinkQueue[queueIndex] = queueCon;
			bPushed = True;
			break;
		}
	}

	return bPushed;
}

// ----------------------------------------------------------------------
// PopDataLink()
//
// Pops a DataLink conversation off the stack.  If there are no 
// DataLinks available, returns None
// ----------------------------------------------------------------------

function Conversation PopDataLink()
{
	local Conversation conResult;
	local Int queueIndex;

	conResult = None;

	if ( dataLinkQueue[0] != None )
	{
		// Save a pointer to the first entry and move the 
		// others down.
		conResult = dataLinkQueue[0];
	
		for( queueIndex=0; queueIndex<7; queueIndex++ )
			dataLinkQueue[queueIndex] = dataLinkQueue[queueIndex+1];

		dataLinkQueue[7] = None;
	}

	return conResult;
}

// ----------------------------------------------------------------------
// FireNextDataLink()
//
// Checks to see if there's another DataLink that needs to be triggered,
// and if so, starts it off.
//
// Returns True if we found a DataLink
// ----------------------------------------------------------------------

function Bool FireNextDataLink()
{
	local Bool bResult;

	bResult = False;

	con      = PopDataLink();
	startCon = con;

	if ( con != None )
	{
		StartConversation(player, invokeActor);
		bResult = True;
	}

	return bResult;
}

// ----------------------------------------------------------------------
// AbortAndSaveHistory()
// ----------------------------------------------------------------------

function AbortAndSaveHistory()
{
	bSilent = True;

	// Make sure no sound playing
	player.StopSound(playingSoundId);

	if ((!bEndTransmission) && (bStartTransmission))
	{
		bStartTransmission = False;
		GotoState('PlayEvent');
		SetTimer(0.0, False);
	}
	else
	{
		PlayNextEvent();
	}
}

// ----------------------------------------------------------------------
// Timer()
//
// Used to provide some flash at the beginning and end of the 
// transmission
// ----------------------------------------------------------------------

function Timer()
{
	eventTimer += blinkRate;

	if ((!bEndTransmission) && (bStartTransmission))
	{
		datalink.ShowDatalinkIcon(!datalink.winPortrait.IsVisible());

		if ( eventTimer > startDelay )
		{
			bStartTransmission = False;
			eventTimer = 0.0;
			SetTimer(0.0, False);

			datalink.ShowTextCursor(True);

			// Play this event!
			GotoState('PlayEvent');
		}
	}
	else if (bEndTransmission)
	{
		datalink.winName.Show(!datalink.winName.IsVisible());

		if ( eventTimer > endDelay )
		{
			SetTimer(0.0, False);
			bEndTransmission = False;
			rootWindow.hud.DestroyInfoLinkWindow();
			dataLink = None;

			// Check to see if there's another DataLink to trigger
			if ( FireNextDataLink() == False )
			{
				player.dataLinkPlay = None;
				Destroy();
			}
		}
	}
}

// ----------------------------------------------------------------------
// JumpToConversation()
//
// Jumps to another conversation
// ----------------------------------------------------------------------

function JumpToConversation( Conversation jumpCon, String startLabel )
{
	assert( jumpCon != None );

	// Conversation to switch to
	con = jumpCon;

	// Get the event to start at, or the beginning if one wasn't
	// passed in.

	currentEvent = con.GetEventFromLabel( startLabel );
	if ( currentEvent == None )
		currentEvent = con.eventList;

	// Start the conversation!
	GotoState('PlayEvent');
}

// ----------------------------------------------------------------------
// PlayNextEvent()
//
// Called from the ConWindow object when the user clicks to 
// continue with Conversation
// ----------------------------------------------------------------------

function PlayNextEvent()
{
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
	lastEvent = currentEvent;

	switch( nextAction ) 
	{
		case EA_NextEvent:
			// Proceed to the next event.
			currentEvent = currentEvent.nextEvent;
			GotoState('PlayEvent');
			break;

		case EA_JumpToLabel:
			// Use the label passed back and jump to it
			if (con != None)
			{
				currentEvent = con.GetEventFromLabel( nextLabel );
				GotoState('PlayEvent');
			}
			else
			{
				currentEvent = None;
				TerminateConversation();
			}
			break;

		case EA_JumpToConversation:
			if (ConEventJump(currentEvent).jumpCon != None)
			{
				JumpToConversation( ConEventJump(currentEvent).jumpCon, nextLabel );
			}
			else
			{
				currentEvent = None;
				TerminateConversation();
			}
			break;

		case EA_WaitForSpeech:
			if (!bSilent)
			{
				// Wait for a piece of audio to finish playing
				GotoState('WaitForSpeech');
			}
			else
			{
				PlayNextEvent();
			}
			break;

		case EA_End:
			// End the Transmission
			currentEvent = None;
			TerminateConversation();
			break;
	}
}

// ----------------------------------------------------------------------
// PlaySpeech()
//
// All speech eminates from the player in DataLink transmissions
// ----------------------------------------------------------------------

function PlaySpeech( int soundID )
{
	local Sound speech;

	speech = con.GetSpeechAudio(soundID);

	if (speech != None)
		playingSoundID = player.PlaySound(speech, SLOT_Talk); 
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
			// Unsupported events
			case ET_MoveCamera:
			case ET_Choice:
			case ET_Animation:
			case ET_Trade:
				break;

			case ET_Speech:
				nextAction = SetupEventSpeech( ConEventSpeech(currentEvent), nextLabel );
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

			case ET_TransferObject:		
				nextAction = SetupEventTransferObject( ConEventTransferObject(currentEvent), nextLabel );
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

	// Sleep for a second before continuing
	Sleep(0.5);

	// Fire the next event
	PlayNextEvent();
	Stop;

Idle:
	Sleep(0.5);
	Goto('Idle');

Begin:
	// Play the sound, set the timer and go to sleep until the sound
	// has finished playing.
	
	// First Stop any sound that was playing
	StopSpeech();

	// Check to see if there's speech to play.  If so, play it and set a 
	// timer that should complete after the speech finishes.  Otherwise 
	// we'll just display the datalink message for a set amount of time
	// and continue.

	if (ConEventSpeech(currentEvent).conSpeech.soundID != -1 )
	{
		PlaySpeech( ConEventSpeech(currentEvent).conSpeech.soundID ); 

		// Add two seconds to the sound since there seems to be a slight lag
		SetTimer( con.GetSpeechLength(ConEventSpeech(currentEvent).conSpeech.soundID), False );
	}
	else
	{
		SetTimer( lastSpeechTextLength * perCharDelay, False );
	}

	Goto('Idle');
}

// ----------------------------------------------------------------------------
// All the unique Setup routines for each event type are located here
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------
// SetupEventSpeech()
//
// Display the speech and wait for feedback.
// ----------------------------------------------------------------------

function EEventAction SetupEventSpeech( ConEventSpeech event, out String nextLabel )
{
	local EEventAction nextAction;
	local ConEvent checkEvent;
	local String speech;

	// Keep track of the last speaker
	lastActor = event.speaker;

	// Display the first speech chunk.
	speech = event.conSpeech.speech;

	if (!bSilent)
	{
		// If we're continuing from the last speech, then we want to Append 
		// and not Display the first chunk.
		if ( event.bContinued == True )
		{
			datalink.AppendText(speech);
		}
		else
		{
			// Clear the window, set the name of the currently speaking
			// actor and then start displaying the speech.

			datalink.ClearScreen();
			datalink.SetSpeaker(event.speakerName, GetDisplayName(event.speakerName));
			datalink.ShowPortrait();
			datalink.DisplayText(speech);

			lastSpeechTextLength = len(speech);
		}
	}

	// Save this event in the history
	AddHistoryEvent(GetDisplayName(event.speakerName), event.conSpeech );

	nextAction = EA_WaitForSpeech;
	nextLabel = "";
	return nextAction;
}

// ----------------------------------------------------------------------
// GetDisplayName()
// ----------------------------------------------------------------------

function String GetDisplayName(String bindName)
{
	local int nameIndex;
	local string displayName;

	displayName = "";

	for(nameIndex=0; nameIndex<arrayCount(infoLinkNames); nameIndex++)
	{
		if (infoLinkNames[nameIndex].BindName == bindName)
		{
			displayName = infoLinkNames[nameIndex].DisplayName;
			break;
		}
	}
	return displayName;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     startSound=Sound'DeusExSounds.UserInterface.DataLinkStart'
     blinkRate=0.500000
     startDelay=1.500000
     endDelay=1.000000
     perCharDelay=0.030000
     infoLinkNames(0)=(BindName="AlexJacobson",displayName="Alex Jacobson")
     infoLinkNames(1)=(BindName="AnnaNavarre",displayName="Anna Navarre")
     infoLinkNames(2)=(BindName="BobPage",displayName="Bob Page")
     infoLinkNames(3)=(BindName="BobPageAug",displayName="Bob Page")
     infoLinkNames(4)=(BindName="Daedalus",displayName="Daedalus")
     infoLinkNames(5)=(BindName="GarySavage",displayName="Gary Savage")
     infoLinkNames(6)=(BindName="GuntherHermann",displayName="Gunther Hermann")
     infoLinkNames(7)=(BindName="Helios",displayName="Helios")
     infoLinkNames(8)=(BindName="Icarus",displayName="Icarus")
     infoLinkNames(9)=(BindName="JaimeReyes",displayName="Jaime Reyes")
     infoLinkNames(10)=(BindName="Jock",displayName="Jock")
     infoLinkNames(11)=(BindName="MorganEverett",displayName="Morgan Everett")
     infoLinkNames(12)=(BindName="PaulDenton",displayName="Paul Denton")
     infoLinkNames(13)=(BindName="SamCarter",displayName="Sam Carter")
     infoLinkNames(14)=(BindName="StantonDowd",displayName="Stanton Dowd")
     infoLinkNames(15)=(BindName="TracerTong",displayName="Tracer Tong")
     infoLinkNames(16)=(BindName="WaltonSimons",displayName="Walton Simons")
     EndTransmission="END TRANSMISSION..."
     bHidden=True
}
