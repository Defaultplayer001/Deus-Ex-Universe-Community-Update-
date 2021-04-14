// ----------------------------------------------------------------------
//  File Name   :  ConChoice.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Conversation Choice Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------


#ifndef _CONCHOICE_H_
#define _CONCHOICE_H_

class DConChoice;
class DConImport;

class CONSYS_API DConChoice : public DConObject
{
	DECLARE_CLASS(DConChoice, DConObject, 0)

public:
	FStringNoInit choiceText;				// Choice Text
	FStringNoInit choiceLabel;				// Choice Label

	BITFIELD bDisplayAsSpeech:1;			// Display choice as speech after user selects it
	INT   soundID;							// Sound file associated with speech
	
	class UClass* skillNeeded;				// Skill needed to see this choice
	INT   skillLevelNeeded;					// Skill level needed

	class DConFlagRef *flagRefList;			// Flags associated with this choice

	class DConChoice* nextChoice;			// Pointer to next choice

	// Constructor
	DConChoice();
	
	void Import(DConImport *conImport, INT choiceNumber);
};

#endif // _CONCHOICE_H_