// ----------------------------------------------------------------------
//  File Name   :  ConEventTransferObject.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event Transfer Object Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTTRANSFEROBJECT_H_
#define _CONEVENTTRANSFEROBJECT_H_

// ----------------------------------------------------------------------
// DConEventTransferObject Class
// ----------------------------------------------------------------------
class CONSYS_API  DConEventTransferObject : public DConEvent
{
	DECLARE_CLASS(DConEventTransferObject, DConEvent, 0)

public:
	FStringNoInit objectName;
	class UClass* giveObject;
	INT           transferCount;
	class AActor* fromActor;
	FStringNoInit fromName;
	class AActor* toActor;
	FStringNoInit toName;
	FStringNoInit failLabel;

	// Constructor
	DConEventTransferObject();		

	void ImportFile(DConImport *conImport);
	bool BindActor(AActor *invokeActor, AActor *actorToBind, DConversation *con);
	void ClearBindActors(void);
};


#endif // _CONEVENTTRANSFEROBJECT_H_
