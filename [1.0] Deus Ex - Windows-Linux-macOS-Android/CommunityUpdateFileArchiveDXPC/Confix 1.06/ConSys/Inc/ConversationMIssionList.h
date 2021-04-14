// ----------------------------------------------------------------------
//  File Name   :  ConversationMissionList.h
//  Programmer  :  Albert Yarusso
//  Description :  Header for ConversationMissionList class
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONVERSATIONMISSIONLIST_H_
#define _CONVERSATIONMISSIONLIST_H_

#define CONMISSIONLIST_NAME		TEXT("ConMissionList")

// ----------------------------------------------------------------------
// DConversationMissionList
//
// Maintains a collection of ConversationList objects
// ----------------------------------------------------------------------

class CONSYS_API DConversationMissionList: public DConObject
{
public:
	DECLARE_CLASS(DConversationMissionList, DConObject, 0)

public:
	// Master list of conversations, generated during the import process.
	// This list is used to bind conversation events
//	TArray<DConversationList*> missions;		

	DConItem *missions;

	// Constructor
	DConversationMissionList();

	// Helper functions
	void AddConversation(DConImport *conImport, DConversation *con);
	DConversationList* GetConList(DConImport *conImport, INT missionNumber);
	void AddConversationList(DConImport* conImport, DConversationList *conList);
	void BindConversations(AActor *bindActor,	INT missionNumber);
};

#endif // _CONVERSATIONMISSIONLIST_H_
