//=============================================================================
// MenuChoice_SoundVolume
//=============================================================================

class MenuChoice_SoundVolume extends MenuChoice_Volume;

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

	Player.SetInstantSoundVolume(byte(newValue));
	Player.PlaySound(sound'Menu_SoundTest', SLOT_None,, True);

	return False;
}

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	Super.LoadSetting();
	Player.SetInstantSoundVolume(GetValue());
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
     defaultValue=204.000000
     HelpText="Adjusts the Sound Effects volume."
     actionText="Sound |&Effects Volume"
     configSetting="ini:Engine.Engine.AudioDevice SoundVolume"
}
