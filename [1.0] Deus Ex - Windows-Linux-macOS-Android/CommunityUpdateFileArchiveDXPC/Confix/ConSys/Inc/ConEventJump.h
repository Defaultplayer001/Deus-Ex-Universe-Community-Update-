// ----------------------------------------------------------------------
//  File Name   :  ConEventJump.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event Jump Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTJUMP_H_
#define _CONEVENTJUMP_H_

// ----------------------------------------------------------------------
// DConEventJump Class
// ----------------------------------------------------------------------

class CONSYS_API  DConEventJump : public DConEvent
{
	DECLARE_CLASS(DConEventJump, DConEvent, 0)

public:
	FStringNoInit jumpLabel;
	class DConversation *conversation;
	INT   conID;

	// Constructor
	DConEventJump();		

	void ImportFile(DConImport *conImport);
};


#endif // _CONEVENTJUMP_H_
