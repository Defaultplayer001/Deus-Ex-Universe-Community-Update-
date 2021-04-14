// ----------------------------------------------------------------------
//  File Name   :  ConEventAddGoal.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event Add Goal Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTADDGOAL_H_
#define _CONEVENTADDGOAL_H_

// ----------------------------------------------------------------------
// DConEventAddGoal Class
// ----------------------------------------------------------------------

class CONSYS_API DConEventAddGoal : public DConEvent
{
	DECLARE_CLASS(DConEventAddGoal, DConEvent, 0)

public:
	class FName goalName;
	BITFIELD bGoalCompleted:1;
	FStringNoInit goalText;
	BITFIELD bPrimaryGoal:1;
	
	// Constructor
	DConEventAddGoal() {};		

	void ImportFile(DConImport *conImport);
};


#endif // _CONEVENTADDGOAL_H_
