// ----------------------------------------------------------------------
//  File Name   :  ConEvent.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Conversation Event Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENT_H_
#define _CONEVENT_H_

class DConImport;

// ----------------------------------------------------------------------
// DConEvent
// ---------
// Abstract class that all conversation events are derived from.
// ----------------------------------------------------------------------

class CONSYS_API DConEvent : public DConObject
{
	DECLARE_CLASS(DConEvent, DConObject, 0)

public:
	BYTE  eventType;							// Event type
	FStringNoInit label;						// Optional event label
	class DConEvent* nextEvent;					// Pointer to next event
	class DConversation* conversation;			// Conversation that owns this event

	virtual void ImportFile(DConImport *conImport) {};
	virtual bool BindActor(AActor *invokeActor, AActor *actorToBind, DConversation *con) { return false; };
	void ClearBindActors(void) {};
	DConEvent();
};


#endif // _CONEVENT_H_
