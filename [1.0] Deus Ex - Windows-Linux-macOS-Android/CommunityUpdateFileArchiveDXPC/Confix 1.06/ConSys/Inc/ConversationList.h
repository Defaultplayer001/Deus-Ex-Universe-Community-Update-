// ----------------------------------------------------------------------
//  File Name   :  AllConversations.h
//  Programmer  :  Albert Yarusso
//  Description :  Header for AllConversations class
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONVERSATION_LIST_H_
#define _CONVERSATION_LIST_H_

#define CONLIST_NAME_TEMPLATE		TEXT("ConList_Mission%02d")
#define CON_BARK_PREFIX				TEXT("_Bark")

// ----------------------------------------------------------------------
// DConversationList
// -----------------
// Maintains a collection of Conversation objects
// ----------------------------------------------------------------------

class CONSYS_API DConversationList : public DConObject
{
public:
	DECLARE_CLASS(DConversationList, DConObject, 0)

public:
	// Master list of conversations, generated during the import process.
	// This list is used to bind conversation events

	//TArray<DConversation*> conversations;		

	DConItem *conversations;

	// Mission description and number, pulled from the DeusExLevelInfo, 
	// these are used by the handy dandy dialog that lets you easily start conversations
	FStringNoInit missionDescription;
	INT   missionNumber;

	// Constructor
	DConversationList() {};

	// Helper functions
	void AddConversation(DConImport* conImport, DConversation *con);
	void BindConversations(AActor *bindActor);
	void PurgeBoundConversations(AActor *bindActor);
};

#endif // _CONVERSATION_LIST_H_
