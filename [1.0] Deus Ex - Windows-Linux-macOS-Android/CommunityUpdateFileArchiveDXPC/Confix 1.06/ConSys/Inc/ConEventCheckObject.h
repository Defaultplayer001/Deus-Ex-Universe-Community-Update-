// ----------------------------------------------------------------------
//  File Name   :  ConEventCheckObject.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event Check Object Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTCHECKOBJECT_H_
#define _CONEVENTCHECKOBJECT_H_

// ----------------------------------------------------------------------
// DConEventCheckObject Class
// ----------------------------------------------------------------------
class CONSYS_API  DConEventCheckObject : public DConEvent
{
	DECLARE_CLASS(DConEventCheckObject, DConEvent, 0)

public:
	FStringNoInit objectName;
	class UClass* checkObject;
	FStringNoInit failLabel;

	// Constructor
	DConEventCheckObject() {};		

	void ImportFile(DConImport *conImport);
	bool BindActor(AActor *invokeActor, AActor *actorToBind, DConversation *con);
	void ClearBindActors(void);
};


#endif // _CONEVENTCHECKOBJECT_H_
