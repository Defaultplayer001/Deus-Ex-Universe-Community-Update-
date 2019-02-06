//=============================================================================
// MenuChoice_MusicVolume
//=============================================================================

class MenuChoice_MusicVolume extends MenuChoice_Volume;

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

	Player.SetInstantMusicVolume(byte(newValue));

	return False;
}

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	Super.LoadSetting();
	Player.SetInstantMusicVolume(GetValue());
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
     defaultValue=153.000000
     HelpText="Adjusts the Music volume."
     actionText="|&Music Volume"
     configSetting="ini:Engine.Engine.AudioDevice MusicVolume"
}
