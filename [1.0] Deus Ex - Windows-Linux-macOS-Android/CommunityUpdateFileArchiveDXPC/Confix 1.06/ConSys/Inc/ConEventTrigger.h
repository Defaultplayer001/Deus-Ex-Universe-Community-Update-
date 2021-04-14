// ----------------------------------------------------------------------
//  File Name   :  ConEventTrigger.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event Trigger Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTTRIGGER_H_
#define _CONEVENTTRIGGER_H_

// ----------------------------------------------------------------------
// DConEventTrigger Class
// ----------------------------------------------------------------------

class CONSYS_API DConEventTrigger : public DConEvent
{
	DECLARE_CLASS(DConEventTrigger, DConEvent, 0)

public:
	class FName triggerTag;

	// Constructor
	DConEventTrigger();		

	void ImportFile(DConImport *conImport);
};


#endif // _CONEVENTTRIGGER_H_
