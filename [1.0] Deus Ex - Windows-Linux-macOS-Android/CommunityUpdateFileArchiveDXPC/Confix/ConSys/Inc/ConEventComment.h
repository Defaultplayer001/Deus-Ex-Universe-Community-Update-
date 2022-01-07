// ----------------------------------------------------------------------
//  File Name   :  ConEventComment.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event Comment Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTCOMMENT_H_
#define _CONEVENTCOMMENT_H_

// ----------------------------------------------------------------------
// DConEventComment Class
// ----------------------------------------------------------------------

class CONSYS_API DConEventComment : public DConEvent
{
	DECLARE_CLASS(DConEventComment, DConEvent, 0)

public:
	FStringNoInit commentText;

	// Constructor
	DConEventComment();		

	void ImportFile(DConImport *conImport);
};


#endif // _CONEVENTCOMMENT_H_
