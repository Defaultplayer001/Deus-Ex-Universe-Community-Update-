// ----------------------------------------------------------------------
//  File Name   :  ConEventCheckPersona.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event Check Persona Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTCHECKPERSONA_H_
#define _CONEVENTCHECKPERSONA_H_

// ----------------------------------------------------------------------
// DConEventCheckPersona Class
// ----------------------------------------------------------------------

class CONSYS_API DConEventCheckPersona : public DConEvent
{
	DECLARE_CLASS(DConEventCheckPersona, DConEvent, 0)

public:
	BYTE			personaType;		// Type of value we're checking
	BYTE			condition;			// Condition
	INT				value;				// Value to check
	FStringNoInit	jumpLabel;			// Label to jump to

	// Constructor
	DConEventCheckPersona() {};		

	void ImportFile(DConImport *conImport);
};


#endif // _CONEVENTCHECKPERSONA_H_
