// ----------------------------------------------------------------------
//  File Name   :  ConEventEnd.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event End Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTEND_H_
#define _CONEVENTEND_H_

// ----------------------------------------------------------------------
// DConEventEnd Class
// ----------------------------------------------------------------------

class CONSYS_API DConEventEnd : public DConEvent
{
	DECLARE_CLASS(DConEventEnd, DConEvent, 0)

public:
	// Constructor
	DConEventEnd() {};		

	void ImportFile(DConImport *conImport);
};


#endif // _CONEVENTEND_H_
