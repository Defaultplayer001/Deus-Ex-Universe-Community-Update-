// ----------------------------------------------------------------------
//  File Name   :  ConEventSetFlag.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event Set Flag Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTSETFLAG_H_
#define _CONEVENTSETFLAG_H_

// ----------------------------------------------------------------------
// DConEventSetFlag Class
// ----------------------------------------------------------------------

class CONSYS_API DConEventSetFlag : public DConEvent
{
	DECLARE_CLASS(DConEventSetFlag, DConEvent, 0)

public:
	class DConFlagRef *flagRefList;		// TODO:  Turn this into chain

	// Constructor
	DConEventSetFlag();		

	void ImportFile(DConImport *conImport);
};


#endif // _CONEVENTSETFLAG_H_
