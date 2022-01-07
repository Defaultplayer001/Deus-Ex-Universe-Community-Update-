// ----------------------------------------------------------------------
//  File Name   :  ConAudioList.h
//  Programmer  :  Albert Yarusso
//  Description :  Header for AllConversations class
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONAUDIOLIST_H_
#define _CONAUDIOLIST_H_

#define CONAUDIOLIST_NAME_TEMPLATE		TEXT("ConAudioList_%s")

// ----------------------------------------------------------------------
// DConAudioList
// -----------------
// Maintains a collection of Conversation objects
// ----------------------------------------------------------------------

class CONSYS_API DConAudioList : public DConObject
{
public:
	DECLARE_CLASS(DConAudioList, DConObject, 0)

public:
	TArray<USound*> conAudioList;		
	INT audioCount;

	// Constructor
	DConAudioList() {};

	void Serialize( FArchive& Ar );				// UObject Interface

	// Helper functions
	void AddAudio(USound *sound);
};

#endif // _CONAUDIOLIST_H_
