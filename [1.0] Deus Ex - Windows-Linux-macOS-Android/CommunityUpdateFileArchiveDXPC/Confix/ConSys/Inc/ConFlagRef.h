// ----------------------------------------------------------------------
//  File Name   :  ConFlagRef.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Header for Conversation Flag Ref class
//
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONFLAGREF_H_
#define _CONFLAGREF_H_

// ----------------------------------------------------------------------
// DConFlagREf Class
// ------------------
// This class is used to keep track of Flag references in the 
// conversation system.  For example, each conversation has a list of 
// flags that need to be set to the correct value for the conversation
// to be triggered.  A DConFlagRef is a reference to an existing flag in
// the system, along with the value we're looking for.
// ----------------------------------------------------------------------

class CONSYS_API DConFlagRef : public DConObject
{
	DECLARE_CLASS(DConFlagRef, DConObject, 0)

public:

	class FName flagName;				// Flag Name we're referencing
	BITFIELD bValue:1;					// Value we're seeking
	INT   expiration;					// Mission this flag expires in, 0 = permanent
	class DConFlagRef *nextFlagRef;		// Next flag ref

	// Constructor
	DConFlagRef();
};

#endif // _CONFLAGREF_H_
