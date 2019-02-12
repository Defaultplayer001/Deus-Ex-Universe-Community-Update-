//=============================================================================
// MenuChoice_SurroundSound
//=============================================================================

class MenuChoice_SurroundSound extends MenuChoice_OnOff;

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
     defaultValue=1
     defaultInfoWidth=83
     HelpText="Enables Dolby Surround Sound support.  Requires a Dolby Pro-Logic Surround Sound Processor."
     actionText="|&Dolby Surround Sound"
     configSetting="ini:Engine.Engine.AudioDevice UseSurround"
}
