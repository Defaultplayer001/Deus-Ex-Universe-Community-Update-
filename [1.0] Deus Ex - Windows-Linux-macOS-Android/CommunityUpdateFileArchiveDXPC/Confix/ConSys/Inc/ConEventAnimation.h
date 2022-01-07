// ----------------------------------------------------------------------
//  File Name   :  ConEventAnimation.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event Animation Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTANIMATION_H_
#define _CONEVENTANIMATION_H_

// ----------------------------------------------------------------------
// DConEventAnimation Class
// ----------------------------------------------------------------------

class CONSYS_API DConEventAnimation : public DConEvent
{
	DECLARE_CLASS(DConEventAnimation, DConEvent, 0)

public:
	class AActor *eventOwner;						// Actor who Animates
	FStringNoInit eventOwnerName;					// Actor Name

	FName sequence;									// Sequence to animate
	BYTE  playMode;									// Animation Mode
	INT	  playLength;								// Play length, in seconds
	BITFIELD bFinishAnim:1;							// Wait for animation to finish

	// Constructor
	DConEventAnimation();

	void ImportFile(DConImport *conImport);
	bool BindActor(AActor *invokeActor, AActor *actorToBind, DConversation *con);
	void ClearBindActors(void);
};

#endif // _CONEVENTANIMATION_H_
