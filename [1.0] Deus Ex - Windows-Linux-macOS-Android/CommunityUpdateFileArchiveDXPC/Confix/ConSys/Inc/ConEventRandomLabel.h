// ----------------------------------------------------------------------
//  File Name   :  ConEventRandomLabel.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event Random Label Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTRANDOMLABEL_H_
#define _CONEVENTRANDOMLABEL_H_

// ----------------------------------------------------------------------
// DConEventRandomLabel Class
// ----------------------------------------------------------------------

class CONSYS_API  DConEventRandomLabel : public DConEvent
{
	DECLARE_CLASS(DConEventRandomLabel, DConEvent, 0)

public:
	TArray<FString> labels;
	BITFIELD bCycleEvents:1;
	BITFIELD bCycleOnce:1;
	BITFIELD bCycleRandom:1;

	INT cycleIndex;
	BITFIELD bLabelsCycled:1;

	// Constructor
	DConEventRandomLabel() {};		
	void Serialize( FArchive& Ar );

	void ImportFile(DConImport *conImport);

	DECLARE_FUNCTION(execGetLabelCount)
	DECLARE_FUNCTION(execGetLabel)
	DECLARE_FUNCTION(execGetRandomLabel)
};


#endif // _CONEVENTRANDOMLABEL_H_
