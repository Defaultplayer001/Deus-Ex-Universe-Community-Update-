// ----------------------------------------------------------------------
//  File Name   :  ConSpeech.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Header for DConSpeech class
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _DCONSPEECH_H_
#define _DCONSPEECH_H_

class DConImport;

#define SPEECH_PAGE_SIZE	199

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// DConSpeech

class CONSYS_API DConSpeech : public DConObject
{
public:
	DECLARE_CLASS(DConSpeech, DConObject, 0)

	FStringNoInit speech;
	INT   soundID;								// Sound file associated with speech

public:
	DConSpeech();								// Default Constructor
	DConSpeech( FString &speechText );			// Constructor
	void Import( DConImport *conImport );		// Import ConSpeech object
	void SetSpeechAudioID( int newSoundID );
};


#endif // _DCONSPEECH_H_
