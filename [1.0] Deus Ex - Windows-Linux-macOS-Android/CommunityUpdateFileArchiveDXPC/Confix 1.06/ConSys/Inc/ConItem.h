// ----------------------------------------------------------------------
//  File Name   :  ConItem.h
//  Programmer  :  Albert Yarusso
//  Description :  
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONITEM_H_
#define _CONITEM_H_

// ----------------------------------------------------------------------
// DConItem
// ----------------------------------------------------------------------

class CONSYS_API DConItem : public DConObject
{
public:
	DECLARE_CLASS(DConItem, DConObject, 0)

public:
	DConObject* conObject;
	DConItem*  next;

	// Constructor
	DConItem();
};

#endif // _CONITEM_H_
