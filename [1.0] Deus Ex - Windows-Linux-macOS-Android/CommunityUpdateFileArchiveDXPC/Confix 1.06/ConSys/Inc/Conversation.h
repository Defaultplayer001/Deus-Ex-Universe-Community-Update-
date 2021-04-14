// ----------------------------------------------------------------------
//  File Name   :  Conversation.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Header for Conversation class
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _CONVERSATION_H_
#define _CONVERSATION_H_

class DConversation;
class DConImport;

// Wave file format, used to determine the length of a sound

typedef struct
{
    char riff[4];               /* the characters "RIFF" */
    unsigned long file_length;  /* file length - 8 */
    char wave[8];               /* the characters "WAVEfmt " */
    unsigned long offset;       /* position of "data"-20 (usually 16) */
    unsigned short format;      /* 1 = PCM */
    unsigned short nchans;      /* #channels (eg. 2=stereo) */
    unsigned long sampsec;      /* #samples/sec (eg. 44100 for CD rate) */
    unsigned long bytesec;      /* #bytes/sec */
    unsigned short bytesamp;    /* #bytes/sample  */
    unsigned short bitsamp;     /* #bits/sample */
    char dataheader[4];         /* the characters "data" */
    unsigned long datalen;      /* #bytes of actual data */
} WAV_Format;

//
// CNN - MP3 frame header (32 bits)
//
// frameSync (11) -			must be all 1
//
// versionID (2) -			00 = MPEG 2.5
//							01 = reserved
//							10 = MPEG 2.0
//							11 = MPEG 1.0
//
// layerDesc (2) -			00 = reserved
//							01 = Layer III
//							10 = Layer II
//							11 = Layer I
//
// bProtection (1) -		0 = protected by CRC
//							1 = not protected
//
// bitrateIndex (4) -		bits	V1,L1	V1,L2	V1,L3	V2,L1	V2,L2,L3
//							----	-----	-----	-----	-----	--------
//							0000	free	free	free	free	free
//							0001	32		32		32		32		8
//							0010	64		46		40		48		16
//							0011	96		56		48		56		24
//							0100	128		64		56		64		32
//							0101	160		80		64		80		40
//							0110	192		96		80		96		48
//							0111	224		112		96		112		56
//							1000	256		128		112		128		64
//							1001	288		160		128		144		80
//							1010	320		192		160		160		96
//							1011	352		224		192		176		112
//							1100	384		256		224		192		128
//							1101	416		320		256		224		144
//							1110	448		384		320		256		160
//							1111	bad		bad		bad		bad		bad
//
//							NOTES:
//								All values are in kbps
//								V1 = MPEG 1.0
//								V2 = MPEG 2.0 and 2.5
//								L1 = Layer I
//								L2 = Layer II
//								L3 = Layer III
//
// sampleRateIndex (2) -	bits	MPEG 1.0	MPEG 2.0	MPEG 2.5
//							----	--------	--------	--------
//							00		44100		22050		11025
//							01		48000		24000		12000
//							10		32000		16000		8000
//							11		reserved	reserved	reserved
//
// bPadding (1) -			0 = frame is not padded
//							1 = frame is padded with one extra slot
//
// bPrivate (1) -			unused
//
// channelMode (2) -		00 = stereo
//							01 = joint stereo (stereo)
//							10 = dual channel (stereo)
//							11 = single channel (mono)
//
// modeExtension (2) -		bits	L1,L2			L3
//							----	-----			--
//							00		bands 4 to 31	intensity stereo = off, MS stereo = off
//							01		bands 8 to 31	intensity stereo = on, MS stereo = off
//							10		bands 12 to 31	intensity stereo = off, MS stereo = on
//							11		bands 16 to 31	intensity stereo = on, MS stereo = on
//
//							NOTES:
//								Applies to joint stereo ONLY
//
// bCopyright (1) -			0 = audio is not copyrighted
//							1 = audio is copyrighted
//
// bOriginal (1) -			0 = copy of original media
//							1 = original media
//
// emphasis (2) -			00 = none
//							01 = 50/15 ms
//							10 = reserved
//							11 = CCIT J.17
//

#define MP3_VERSION1  0x3
#define MP3_VERSION2  0x2
#define MP3_VERSION25 0x0

#define MP3_LAYER1 0x3
#define MP3_LAYER2 0x2
#define MP3_LAYER3 0x1

//
// NOTES:
//	Frame Size is the number of _samples_ in a frame
//	Frame Size is always always constant
//	Frame Length is the number of _bytes_ of compressed data in a frame
//	Frame Length is variable from frame to frame
//
#define MP3_FRAMESIZE_LAYER1 384
#define MP3_FRAMESIZE_LAYER2 1152
#define MP3_FRAMESIZE_LAYER3 1152

#define MP3_BITRATE_MULT 1000

typedef struct
{
	BITFIELD		frameSyncHi:8;

	BITFIELD		bProtection:1;
	BITFIELD		layerDesc:2;
	BITFIELD		versionID:2;
	BITFIELD		frameSyncLo:3;

	BITFIELD		bPrivate:1;
	BITFIELD		bPadding:1;
	BITFIELD		samplingRateIndex:2;
	BITFIELD		bitrateIndex:4;

	BITFIELD		emphasis:2;
	BITFIELD		bOriginal:1;
	BITFIELD		bCopyright:1;
	BITFIELD		modeExtension:2;
	BITFIELD		channelMode:2;
} MP3_FrameHeader;

//
// END CNN
//

// ----------------------------------------------------------------------
// DConversation Class
// -------------------
// Individual Conversation.  Includes a collection of Event objects
// that comprise the conversation
// ----------------------------------------------------------------------

#define MAX_ACTORS_BOUND	10

class CONSYS_API DConversation : public DConObject
{
public:
	DECLARE_CLASS(DConversation, DConObject, 0)

public:
	class FName		conName;				// Conversation Name
	FStringNoInit	description;			// Description
	FStringNoInit	createdBy;				// Who created event
	FStringNoInit	conOwnerName;			// Conversation owner name
	BITFIELD		bDataLinkCon:1;			// TRUE if this is a DataLink conversation
	BITFIELD		bDisplayOnce:1;			// Flag to display conversation only once
	BITFIELD		bFirstPerson:1;			// Remain in First-Person mode
    BITFIELD		bNonInteractive:1;		// Non-interactive conversation
    BITFIELD		bRandomCamera:1;		// Random Camera Placement (can be overridden)
	BITFIELD		bCanBeInterrupted:1;	// True if this conversation can be interupted by another
	BITFIELD		bCannotBeInterrupted:1;	// True if this conversation CANNOT be interupted by another
	BITFIELD		bGenerateAudioNames:1;	// True if we're to auto-generate filenames for the audio

	BITFIELD		bInvokeBump:1;			// Invoke by Bumping
	BITFIELD		bInvokeFrob:1;			// Invoke by Frobbing
	BITFIELD		bInvokeSight:1;			// Invoke by Sight
	BITFIELD		bInvokeRadius:1;		// Invoke by Radius
	INT				invokeRadius;			// Distance from PC needed to invoke conversation

	DConEvent		*eventList;				// First Event
	DConFlagRef		*flagRefList;			// First Flag Ref

	INT				conID;					// Internal Conversation ID

	// Unique identifier of audio package.  This is used to generate
	// audio names so we can demand load audio from a package
	FStringNoInit audioPackageName;

	FLOAT			lastPlayedTime;			// Time when conversation last played (ended).
	INT				ownerRefCount;			// Number of owners this conversation has

	// Constructor
	DConversation();

	// Intrinsics
	DECLARE_FUNCTION(execCreateFlagRef)		// Creates a new DConFlagRef Object
	DECLARE_FUNCTION(execCreateConCamera)	// Creates a new DConCamera Object
	DECLARE_FUNCTION(execBindEvents)		// Binds actors to events
	DECLARE_FUNCTION(execBindActorEvents)	// Binds specific actor to events
	DECLARE_FUNCTION(execClearBindEvents)	// Clears bound events
	DECLARE_FUNCTION(execGetSpeechAudio)	// Returns a pointer to a USound object
	DECLARE_FUNCTION(execGetSpeechLength)	// Returns length of speech object passed in

	// Import conversation objects 
	void ImportFile(DConImport *conImport);
	void ProcessChoices( DConImport *conImport );
	DConEvent* CreateChoiceEvents(DConImport *conImport, DConEvent *currentEvent);
	void BindEvents(AActor *conActorsBound[], AActor *invokeActor);
	void BindEventsToActor(AActor *conActorsBound[], AActor *invokeActor, AActor *actorToBind);
	void BindActorEvents(AActor *actorToBind);
	void ClearBindEvents(void);
	void AddBoundActor(AActor *conActorsBound[], AActor *actorToBind);

	// Sound helper routines
	USound *GetSpeechAudio(INT soundID);
	FLOAT GetSpeechLength(INT soundID);
	FLOAT GetSoundLength(USound *sound);
};


#endif // _CONVERSATION_H_
