// ----------------------------------------------------------------------
//  File Name   :  ConEventAddNote.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event Add Note Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTADDNOTE_H_
#define _CONEVENTADDNOTE_H_

// ----------------------------------------------------------------------
// DConEventAddNote Class
// ----------------------------------------------------------------------

class CONSYS_API DConEventAddNote : public DConEvent
{
	DECLARE_CLASS(DConEventAddNote, DConEvent, 0)

public:
	FStringNoInit noteText;
	BITFIELD bNoteAdded:1;				// Used to prevent note from getting added twice

	// Constructor
	DConEventAddNote();

	void ImportFile(DConImport *conImport);
};


#endif // _CONEVENTADDNOTE_H_
