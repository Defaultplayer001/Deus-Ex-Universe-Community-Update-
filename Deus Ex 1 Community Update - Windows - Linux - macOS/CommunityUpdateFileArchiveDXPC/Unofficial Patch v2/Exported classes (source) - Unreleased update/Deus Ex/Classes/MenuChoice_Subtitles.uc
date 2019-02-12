//=============================================================================
// MenuChoice_Subtitles
//=============================================================================

class MenuChoice_Subtitles extends MenuChoice_OnOff;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(player.bSubtitles));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bSubtitles = bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(player.bSubtitles));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultValue=1
     defaultInfoWidth=88
     HelpText="If subtitles are On, conversation dialogue will be displayed on-screen."
     actionText="|&Subtitles"
}
