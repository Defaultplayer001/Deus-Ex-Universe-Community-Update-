//=============================================================================
// MenuChoice_ReverseStereo
//=============================================================================

class MenuChoice_ReverseStereo extends MenuChoice_OnOff;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	LoadSettingBool();
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	SaveSettingBool();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=83
     HelpText="If enabled, the left and right stereo channels are reversed."
     actionText="|&Reverse Stereo"
     configSetting="ini:Engine.Engine.AudioDevice ReverseStereo"
}
