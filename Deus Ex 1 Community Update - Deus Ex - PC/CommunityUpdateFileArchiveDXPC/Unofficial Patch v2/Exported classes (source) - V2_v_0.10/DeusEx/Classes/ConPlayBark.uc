//=============================================================================
// ConPlayBark
//=============================================================================
class ConPlayBark expands Actor;

var Conversation con;

// ----------------------------------------------------------------------
// SetConversation()
// ----------------------------------------------------------------------

function SetConversation(Conversation newCon)
{
	con = newCon;
}

// ----------------------------------------------------------------------
// GetBarkSpeech()
// ----------------------------------------------------------------------

function ConSpeech GetBarkSpeech()
{
	local ConEvent event;
	local ConSpeech outSpeech;

	// Abort if we don't have a valid conversation
	if (con == None)
		return None;

	// Default return value
	outSpeech = None;

	// Loop through the events until we hit some speech
	event = con.eventList;

	while(event != None)
	{
		switch(event.eventType)
		{
			case ET_Speech:
				outSpeech = ConEventSpeech(event).conSpeech;
				event = None;
				break;
			
			case ET_Jump:
				event = ProcessEventJump(ConEventJump(event));
				break;

			case ET_Random:
				event = ProcessEventRandomLabel(ConEventRandomLabel(event));
				break;

			case ET_End:
				event = None;
				break;

			default:
				event = event.nextEvent;
				break;
		}
	}

	return outSpeech;
}

// ----------------------------------------------------------------------
// ProcessEventJump()
// ----------------------------------------------------------------------

function ConEvent ProcessEventJump(ConEventJump event)
{
	local ConEvent nextEvent;

	// Check to see if the jump label is empty.  If so, then we just want
	// to fall through to the next event.  This can happen when jump
	// events get inserted during the import process.  ConEdit will not
	// allow the user to create events like this. 

	if (event.jumpLabel == "")
	{
		nextEvent = event.nextEvent;
	}
	else
	{
		if ((event.jumpCon != None) && (event.jumpCon != con))
			nextEvent = None;			// not yet supported
		else
			nextEvent = con.GetEventFromLabel(event.jumpLabel);
	}

	return nextEvent;
}

// ----------------------------------------------------------------------
// ProcessEventRandomLabel()
// ----------------------------------------------------------------------

function ConEvent ProcessEventRandomLabel(ConEventRandomLabel event)
{
	local String nextLabel;

	// Pick a random label
	nextLabel = event.GetRandomLabel();

	return con.GetEventFromLabel(nextLabel);
}

defaultproperties
{
}
