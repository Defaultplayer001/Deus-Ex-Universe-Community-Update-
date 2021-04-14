// ----------------------------------------------------------------------
//  File Name   :  ConObject.h
//  Programmer  :  Albert Yarusso
//  Description :  Conversation Base Object
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONOBJECT_H_
#define _CONOBJECT_H_

#define ACTOR_NAME_MAX_LEN	32		// Maximum length of Actor name
#define LABEL_MAX_LEN		32		// Maximum label length
#define NAME_MAX_LEN		64		// Max length of goal name

// Possible Event Actions
enum EEventAction
{
    EA_NextEvent			= 0,
	EA_JumpToLabel			= 1,
	EA_JumpToConversation	= 2,
	EA_WaitForInput			= 3,
	EA_WaitForSpeech		= 4,
	EA_PlayAnim				= 5,
	EA_ConTurnActors		= 6,
	EA_End					= 7
};

// Various and sundry Event Types
enum EEventType
{
	ET_Speech				= 0,
	ET_Choice				= 1,
	ET_SetFlag				= 2,
	ET_CheckFlag			= 3,
	ET_CheckObject			= 4,
	ET_TransferObject		= 5,
	ET_MoveCamera			= 6,
	ET_Animation			= 7,
	ET_Trade				= 8,
	ET_Jump					= 9,
	ET_Random				= 10,
	ET_Trigger				= 11,
	ET_AddGoal				= 12,
	ET_AddNote				= 13,
	ET_AddSkillPoints		= 14,
	ET_AddCredits			= 15,
	ET_CheckPersona			= 16,
	ET_Comment				= 17,
	ET_End					= 18
};

// Camera Types
enum ECameraTypes
{
    CT_Predefined			= 0,
	CT_Speakers				= 1,
	CT_Actor				= 2,
    CT_Random				= 3
};

// Predefined Camera Positions
enum ECameraPositions
{
	CP_SideTight				= 0,
	CP_SideMid					= 1,
	CP_SideAbove				= 2,
	CP_SideAbove45				= 3,
	CP_ShoulderLeft				= 4,
	CP_ShoulderRight			= 5,
	CP_HeadShotTight			= 6,
	CP_HeadShotMid				= 7,
	CP_HeadShotLeft				= 8,
	CP_HeadShotRight			= 9,
	CP_HeadShotSlightRight		= 10,
	CP_HeadShotSlightLeft		= 11,
	CP_StraightAboveLookingDown	= 12,
	CP_StraightBelowLookingUp   = 13,
	CP_BelowLookingUp           = 14
};

enum ECameraTransitions
{
    TR_Jump					= 0,
    TR_Spline				= 1
};

enum ESpeechFonts
{
	SF_Normal				= 0,
	SF_Computer				= 1
};

enum EAnimationModes
{
    AM_Loop					= 0,
    AM_Once					= 1
};

enum EConditions
{
	EC_Less					= 0,
	EC_LessEqual			= 1,
	EC_Equal				= 2,
	EC_GreaterEqual			= 3,
	EC_Greater				= 4
};

// Event Persona types
enum EPersonaTypes
{
	EP_Credits				= 0,
	EP_Health				= 1,
	EP_SkillPoints			= 2
};

// ----------------------------------------------------------------------
// DConObject
// ----------
// All conversation objects are derived from this class
// ----------------------------------------------------------------------

class CONSYS_API DConObject : public UObject
{
	DECLARE_CLASS(DConObject, UObject, 0)

public:
	DConObject() {};
};



#endif // _CONOBJECT_H_
