// ----------------------------------------------------------------------
//  File Name   :  ConEventChoice.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event Choice Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTCHOICE_H_
#define _CONEVENTCHOICE_H_

// ----------------------------------------------------------------------
// DConEventChoice Class
// ----------------------------------------------------------------------
class CONSYS_API DConEventChoice : public DConEvent
{
	DECLARE_CLASS(DConEventChoice, DConEvent, 0)

public:
	BITFIELD bClearScreen:1;
	class DConChoice *choiceList;

	// Constructor
	DConEventChoice();		

	void ImportFile(DConImport *conImport);
};

#endif // _CONEVENTCHOICE_H_
