// ----------------------------------------------------------------------
//  File Name   :  ConEventSpeech.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event Speech Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTSPEECH_H_
#define _CONEVENTSPEECH_H_

// ----------------------------------------------------------------------
// DConEventSpeech Class
// ----------------------------------------------------------------------

class CONSYS_API DConEventSpeech : public DConEvent
{
	DECLARE_CLASS(DConEventSpeech, DConEvent, 0)

public:
	class AActor *speaker;						// Actor who speaks
	FStringNoInit speakerName;					// Actor Name
	class AActor *speakingTo;					// Actor who is being spoken to
	FStringNoInit speakingToName;				// Actor Name
	class DConSpeech *conSpeech;				// Speech
	BITFIELD bContinued:1;						// True if this speech continued from last speech event
	BITFIELD bBold:1;							// True if speech is Bold
	BYTE  speechFont;							// Font used for speech

	// Constructor
	DConEventSpeech();		

	void ImportFile(DConImport *conImport);
	bool BindActor(AActor *invokeActor, AActor *actorToBind, DConversation *con);
	void ClearBindActors(void);
};

#endif // _CONEVENTSPEECH_H_
