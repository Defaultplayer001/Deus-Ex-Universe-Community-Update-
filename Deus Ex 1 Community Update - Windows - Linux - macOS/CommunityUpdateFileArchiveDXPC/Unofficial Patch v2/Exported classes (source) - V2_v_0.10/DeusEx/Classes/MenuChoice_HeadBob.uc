//=============================================================================
// MenuChoice_HeadBob
//=============================================================================

class MenuChoice_HeadBob extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	if (player.bob == 0)
		SetValue(1);
	else
		SetValue(0);
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	if (GetValue() == 0)
//		player.bob = player.default.bob;
		player.bob = 0.016;			// for some reason, setting default doesn't work
	else
		player.bob = 0.0;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	if (player.bob == 0)
		SetValue(1);
	else
		SetValue(0);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="If enabled, the player will bob up and down slightly while walking."
     actionText="|&Player Bob"
}
