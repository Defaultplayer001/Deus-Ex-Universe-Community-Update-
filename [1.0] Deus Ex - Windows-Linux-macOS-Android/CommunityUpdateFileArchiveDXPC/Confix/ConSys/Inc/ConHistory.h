// ----------------------------------------------------------------------
//  File Name   :  ConHistory.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Header for DConHistory class
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _DCONHISTORY_H_
#define _DCONHISTORY_H_

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// DConHistory

class CONSYS_API DConHistory : public DConObject
{
public:
	DECLARE_CLASS(DConHistory, DConObject, 0)

	FStringNoInit strConOwner;				// String name of conversation owner
	FStringNoInit strLocation;				// String description of location
	FStringNoInit strDescription;			// Conversation Description
	BITFIELD bInfoLink:1;					// True if InfoLink
	class DConHistoryEvent	*firstEvent;	// First Conversation History Event
	class DConHistoryEvent	*lastEvent;		// Last Conversation History Event
	class DConHistory		*next;			// Pointer to next ConHistory

public:
	// Constructor
	DConHistory();
	void Destroy(void);
};


#endif // _DCONHISTORY_H_
