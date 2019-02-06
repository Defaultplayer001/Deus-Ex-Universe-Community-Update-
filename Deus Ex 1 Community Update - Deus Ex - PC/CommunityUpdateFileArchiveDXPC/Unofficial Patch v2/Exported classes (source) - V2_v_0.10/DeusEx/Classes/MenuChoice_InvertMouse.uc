//=============================================================================
// MenuChoice_InvertMouse
//=============================================================================

class MenuChoice_InvertMouse extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bInvertMouse));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bInvertMouse = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bInvertMouse));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="Inverts the vertical mouse axis so when you push up you look down and vice versa"
     actionText="Invert |&Mouse"
}
