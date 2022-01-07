// ----------------------------------------------------------------------
//  File Name   :  ConEventMoveCamera.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event Move Camera Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTMOVECAMERA_H_
#define _CONEVENTMOVECAMERA_H_

// ----------------------------------------------------------------------
// DConEventMoveCamera Class
// ----------------------------------------------------------------------
class CONSYS_API  DConEventMoveCamera : public DConEvent
{
	DECLARE_CLASS(DConEventMoveCamera, DConEvent, 0)

public:

	BYTE  cameraType;								// Camera Type
	BYTE  cameraPosition;							// Predefined camera position
	BYTE  cameraTransition;							// Camera Transition (from previous position)

	// Variables used for specific camera placement
	FVector cameraOffset;							// Camera Offset
	FRotator rotation;								// Camera rotation
	FLOAT heightModifier;							// Height Modifier
	FLOAT centerModifier;							// Center modifier
	FLOAT distanceMultiplier;						// Distance modifier

	// Actor, used with CT_Actor camera type
	class AActor* cameraActor;						// Actor who owns this event
	FStringNoInit cameraActorName;					// Text name

	// Constructor
	DConEventMoveCamera();		

	void ImportFile(DConImport *conImport);
	bool BindActor(AActor *invokeActor, AActor *actorToBind, DConversation *con);
	void ClearBindActors(void);
};


#endif // _CONEVENTMOVECAMERA_H_
