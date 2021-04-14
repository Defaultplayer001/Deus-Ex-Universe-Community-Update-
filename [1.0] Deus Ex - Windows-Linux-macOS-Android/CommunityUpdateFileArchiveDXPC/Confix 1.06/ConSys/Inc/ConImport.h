// ----------------------------------------------------------------------
//  File Name   :  ConImport.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Conversation File Import Header
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONIMPORT_H_
#define _CONIMPORT_H_

#include <stdio.h>
#include "ConSys.h"
#include "ConEventJump.h"

class DConversation;

#define DEUSEX_CONVERSATION_HEADER TEXT("Deus Ex Conversation File")
#define DEUSEX_PC_NAME TEXT("JCDenton")
#define DEUSEX_CONAUDIOEXTENSION TEXT("mp3")

// Maximum length of a flag name
#define FLAG_NAME_MAX_LEN		64

// Last supported version
#define CONFILE_LAST_SUPPORTED_VERSION		26

// Tables used to keep track of conversation IDs for the current
// file being imported.  This is used to later match up jump
// links with the correct conversation.

struct ConIDLookupTableStruct
{
	INT	  conID;
	DConversation *con;
};

struct JumpTableStruct
{
	INT	conID;
	DConEventJump *jump;
};

struct ActorReferenceStruct
{
	INT actorID;
	INT refCount;
};

// ----------------------------------------------------------------------
// DConImport Class
// ----------------------------------------------------------------------

class CONSYS_API DConImport : public DConObject
{
//	DECLARE_CLASS(DConImport, DConObject, CLASS_Transient)
	DECLARE_CLASS(DConImport, DConObject, 0)

public:
//	FArchive *inFile;
	FILE *inFile;
	long conVersion;
	
	UPackage *textPackage;					// Package
	UPackage *audioPackage;					// Audio Package
	FStringNoInit audioPackageName;			// Name of audio package

	TArray<ConIDLookupTableStruct>	conIDTable;
	TArray<JumpTableStruct>			conJumpEvents;

	// These next two variables are used to build audio filenames
	TArray<ActorReferenceStruct>	actorRefs;
	INT intChoiceCount;

	class DConversation *con;										// Conversation being imported
	FStringNoInit conSpeakerName;
	FStringNoInit conLastNonPlayerSpeakerName;
	INT   conSpeakerID;

	// Missions
	TArray<INT>		missions;				// Missions this conversation file belongs to

	// Constructor
	DConImport();
	void Destroy(void);

	// Import File
	void ImportFile(FString packageName, FString importFileName);
	int  GetConVersion(void);

	DConversationMissionList* GetMissionConList(void);
	DConAudioList* GetConAudioList(void);

	UPackage *GetTextPackage( void );
	UPackage *GetAudioPackage( void );

	// Import FlagRef List
	DConFlagRef* ImportFlagRefs( void );

	// Misc. file type importing routines
	int   ImportString( FString &newString, int maxLength );		// Import a String
	void  ImportLabel( FString &label );							// Import a label
	INT   ImportActorName( FString &actorName );					// Import an Actor Name
	DWORD ImportBool( void );										// Import a Boolean
	INT   ImportLong( void );										// Import a Long Value
	void  ImportEnum( BYTE *enumImport );							// Import an Enumerated Type
	INT ImportAudio(FString &postFilename);
	INT ImportSpeechAudio( void );
	INT ImportChoiceAudio(INT choiceNumber);

	void DiscardLong( void );										// Discards a long
	void DiscardString( void );										// Discards a string

	// Generate unique speech label
	FString &GetNextSpeechLabel( FString &speechLabel );			
	FString &GetNextChoiceEndLabel( FString &choiceLabel );

	void ClearActorReferenceTable(void);
	INT  IncActorReference(INT actorID);
	INT  GetActorReferenceCount(INT actorID);
	void ClearChoiceCount(void);
	INT  IncChoiceCount(void);
	INT  GetChoiceCount(void);
	DWORD IsDataLinkCon(void);
	void ClearAudioCount(void);
	INT  IncAudioCount(void);
	INT  GetAudioCount(void);
	FString GetAudioName(void);

	void SetSpeakerName(FString &newSpeakerName);
	FString &GetSpeakerName(void);
	FString &GetLastNonPlayerSpeakerName(void);
	void  SetSpeakerID(INT newSpeakerID);
	INT   GetSpeakerID(void);
	FString GetSpeakerFirstName(void);

private:
	TArray<FString> conDescriptions;		// Used to link up jumps
	DConversationMissionList* conMissionList;
	DConAudioList* conAudioList;
	
	int intSpeechLabelCounter;				// Used to generate unique labels
	int intChoiceEndCounter;				// Used to generate unique labels

	// Bind jump links
	void BindJumpLinks(void);
};

#endif // _CONIMPORT_H_
