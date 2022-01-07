// ----------------------------------------------------------------------
//  File Name   :  ConEventAddCredits.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event Add Credits Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTADDCREDITS_H_
#define _CONEVENTADDCREDITS_H_

// ----------------------------------------------------------------------
// DConEventAddCredits Class
// ----------------------------------------------------------------------

class CONSYS_API DConEventAddCredits : public DConEvent
{
	DECLARE_CLASS(DConEventAddCredits, DConEvent, 0)

public:
	INT   creditsToAdd;

	// Constructor
	DConEventAddCredits() {};

	void ImportFile(DConImport *conImport);
};


#endif // _CONEVENTADDCREDITS_H_
