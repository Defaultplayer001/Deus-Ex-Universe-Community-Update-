// ----------------------------------------------------------------------
//  File Name   :  ConEventCheckFlag.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event Check Flag Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTCHECKFLAG_H_
#define _CONEVENTCHECKFLAG_H_

// ----------------------------------------------------------------------
// DConEventCheckFlag Class
// ----------------------------------------------------------------------
class CONSYS_API DConEventCheckFlag : public DConEvent
{
	DECLARE_CLASS(DConEventCheckFlag, DConEvent, 0)

public:
	class DConFlagRef *flagRefList;		// Flags to check
	FStringNoInit setLabel;				// Label to jump to if flags check out

	// Constructor
	DConEventCheckFlag();		

	void ImportFile(DConImport *conImport);
};


#endif // _CONEVENTCHECKFLAG_H_
