// ----------------------------------------------------------------------
//  File Name   :  EditorEngineExt.h
//  Programmer  :  Albert Yarusso
//  Description :  Header for the Editor Engine Extension Class
// ----------------------------------------------------------------------
//  Copyright ©1998 ION Storm Austin.  This software is a trade secret.
// ----------------------------------------------------------------------

#ifndef _EDITOR_ENGINE_EXT_H_
#define _EDITOR_ENGINE_EXT_H_

// ----------------------------------------------------------------------
// DEditorEngineExt class

class CONSYS_API DEditorEngineExt : public UEditorEngine
{

	DECLARE_CLASS(DEditorEngineExt, UEditorEngine, CLASS_Transient | CLASS_Config)

	public:
		DEditorEngineExt();

		// UEditorEngine interface
		void Init(void);
		UBOOL SafeExec( FString &InStr, FOutputDevice& Ar=GOut );

};  // DEditorEngineExt


#endif // _EDITOR_ENGINE_EXT_H_
