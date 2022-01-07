// ----------------------------------------------------------------------
//  File Name   :  ConListItem.h
//  Programmer  :  Albert Yarusso
//  Description :  
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONLISTITEM_H_
#define _CONLISTITEM_H_

// ----------------------------------------------------------------------
// DConListItem
// ----------------------------------------------------------------------

class CONSYS_API DConListItem : public DConObject
{
public:
	DECLARE_CLASS(DConListItem, DConObject, 0)

public:
	DConversation* con;
	DConListItem*  next;

	// Constructor
	DConListItem();
};

#endif // _CONLISTITEM_H_
