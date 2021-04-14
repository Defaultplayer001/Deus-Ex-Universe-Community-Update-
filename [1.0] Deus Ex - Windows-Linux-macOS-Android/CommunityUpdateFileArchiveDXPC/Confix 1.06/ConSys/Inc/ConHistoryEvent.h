// ----------------------------------------------------------------------
//  File Name   :  ConHistoryEvent.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Header for DConHistoryEvent class
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _DCONHISTORYEVENT_H_
#define _DCONHISTORYEVENT_H_

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// DCONHISTORYEVENT

class CONSYS_API DConHistoryEvent : public DConObject
{
public:
	DECLARE_CLASS(DConHistoryEvent, DConObject, 0)

public:
	FStringNoInit strConSpeaker;				// Speaker
	FStringNoInit speech;						// Speech
	INT   soundID;								// Sound file associated with speech
	
	class DConHistoryEvent *next;				// Next event

	// Constructor
	DConHistoryEvent();
};


#endif // _DCONHISTORYEVENT_H_
