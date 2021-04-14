// ----------------------------------------------------------------------
//  File Name   :  ConUtils.h
//  Programmer  :  Albert Yarusso (ay)
//  Description :  Conversation Utilities
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------


// ----------------------------------------------------------------------
// ReadConString
// -------------
// Reads a string from a conversation editor file and stuffs it into
// an FString.  The conversation editor stores strings as the string
// length (long) followed by the actual string.
// ----------------------------------------------------------------------

extern "C" INT ReadConString( FILE* importFile, TCHAR *newString, INT maxLength = 0);

// ----------------------------------------------------------------------
// ReadBool
// --------
// Reads a Boolean value from the conversation editor and imports it 
// into a BITFIELD:1 as they're stored for UnrealScript.
// ----------------------------------------------------------------------

extern "C" BITFIELD ReadBool( FILE* importFile );
