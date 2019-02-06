//=============================================================================
// MenuChoice_ToggleCrouch
//=============================================================================

class MenuChoice_ToggleCrouch extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bToggleCrouch));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bToggleCrouch = !bool(GetValue());
}

// ----------------------------------------------------------------------
// -------------------------------	---------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bToggleCrouch));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="If set to Enabled, the crouch key will act as a toggle"
     actionText="|&Toggle Crouch"
}
