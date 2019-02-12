//=============================================================================
// MenuChoice_SpeechVolume
//=============================================================================

class MenuChoice_SpeechVolume extends MenuChoice_Volume;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	btnSlider.winSlider.SetScaleSounds(None, None, None);
}

// ----------------------------------------------------------------------
// ScalePositionChanged() 
//
// Update the Mouse Sensitivity value
// ----------------------------------------------------------------------

event bool ScalePositionChanged(Window scale, int newTickPosition,
                                float newValue, bool bFinal)
{
	// Don't do anything while initializing as we get several 
	// ScalePositionChanged() events before LoadSetting() is called.

	if (bInitializing)
		return False;

	Player.SetInstantSpeechVolume(byte(newValue));
	Player.PlaySound(sound'Menu_SpeechTest', SLOT_Talk,, True);

	return False;
}

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	Super.LoadSetting();
	Player.SetInstantSpeechVolume(GetValue());
}

// ----------------------------------------------------------------------
// CancelSetting()
// ----------------------------------------------------------------------

function CancelSetting()
{
	Super.CancelSetting();
	LoadSetting();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultValue=255.000000
     HelpText="Adjusts the Speech volume."
     actionText="|&Speech Volume"
     configSetting="ini:Engine.Engine.AudioDevice SpeechVolume"
}
