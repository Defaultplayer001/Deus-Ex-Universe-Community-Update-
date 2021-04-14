// ----------------------------------------------------------------------
//  File Name   :  ConSys.h
//  Programmer  :  Albert Yarusso
//  Description :  Main header for the Conversation System Package and DLL
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONSYS_H_
#define _CONSYS_H_

#include <engine.h>

//#include "extension.h"

// ----------------------------------------------------------------------
// Needed for all routines and classes visible outside the DLL

#ifndef CONSYS_API
#define CONSYS_API DLL_IMPORT
#endif

// ----------------------------------------------------------------------
// Define boolean values, if not already defined

#ifndef TRUE
	#define TRUE (1)
#endif

#ifndef FALSE
	#define FALSE (0)
#endif
	
// ----------------------------------------------------------------------
// Enumerations used for intrinsic routines in the ConSys DLL

enum
{
	CONSYS_CreateFlagRef=2050,
	CONSYS_CreateConCamera=2051,
	CONSYS_BindEvents=2052,
	CONSYS_BindActorEvents=2053,
	CONSYS_ClearBindEvents=2054,
	CONSYS_GetSpeechAudio=2055,
	CONSYS_GetSpeechLength=2056,

	CONSYS_GetLabelCount=2060,
	CONSYS_GetLabel=2061,
	CONSYS_GetRandomLabel=2062, 
};

// ----------------------------------------------------------------------

#include "ConObject.h"
#include "ConAudioList.h"
#include "ConSpeech.h"
#include "ConFlagRef.h"
#include "ConChoice.h"
#include "ConEvent.h"
#include "Conversation.h"
#include "ConItem.h"
#include "ConListItem.h"
#include "ConversationList.h"
#include "ConversationMissionList.h"
#include "ConHistory.h"
#include "ConHistoryEvent.h"

#endif // _CONSYS_H_
