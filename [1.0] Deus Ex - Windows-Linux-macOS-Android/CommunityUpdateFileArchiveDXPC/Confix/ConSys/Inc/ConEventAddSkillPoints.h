// ----------------------------------------------------------------------
//  File Name   :  ConEventAddSkillPoints.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Event Add Skill Points Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONEVENTADDSKILLPOINTS_H_
#define _CONEVENTADDSKILLPOINTS_H_

// ----------------------------------------------------------------------
// DConEventAddSkillPoints Class
// ----------------------------------------------------------------------

class CONSYS_API DConEventAddSkillPoints : public DConEvent
{
	DECLARE_CLASS(DConEventAddSkillPoints, DConEvent, 0)

public:
	INT pointsToAdd;
	FStringNoInit awardMessage;

	// Constructor
	DConEventAddSkillPoints() {};

	void ImportFile(DConImport *conImport);
};


#endif // _CONEVENTADDSKILLPOINTS_H_
