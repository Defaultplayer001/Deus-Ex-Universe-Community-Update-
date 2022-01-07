// ----------------------------------------------------------------------
//  File Name   :  ConEventTrade.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event Trade Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTTRADE_H_
#define _CONEVENTTRADE_H_

// ----------------------------------------------------------------------
// DConEventTrade Class
// ----------------------------------------------------------------------
class CONSYS_API  DConEventTrade : public DConEvent
{
	DECLARE_CLASS(DConEventTrade, DConEvent, 0)

public:
	class AActor *eventOwner;					// Actor who initiates Trade
	FStringNoInit eventOwnerName;				// Actor Name

	// Constructor
	DConEventTrade();

	void ImportFile(DConImport *conImport);
	bool BindActor(AActor *invokeActor, AActor *actorToBind, DConversation *con);
	void ClearBindActors(void);
};


#endif // _CONEVENTTRADE_H_
