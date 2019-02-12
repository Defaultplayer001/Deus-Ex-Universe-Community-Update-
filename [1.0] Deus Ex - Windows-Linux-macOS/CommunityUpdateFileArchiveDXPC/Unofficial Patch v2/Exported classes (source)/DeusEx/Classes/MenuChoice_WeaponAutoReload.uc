//=============================================================================
// MenuChoice_WeaponAutoReload
//=============================================================================

class MenuChoice_WeaponAutoReload extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bAutoReload));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bAutoReload = !bool(GetValue());
	if ( player.Level.NetMode != NM_Standalone )
		player.ServerSetAutoReload( player.bAutoReload );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bAutoReload));
	if ( player.Level.NetMode != NM_Standalone )
		player.ServerSetAutoReload( player.bAutoReload );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="If enabled, weapons will automatically reload when their ammo is depleted."
     actionText="|&Weapon Auto-Reload"
}
