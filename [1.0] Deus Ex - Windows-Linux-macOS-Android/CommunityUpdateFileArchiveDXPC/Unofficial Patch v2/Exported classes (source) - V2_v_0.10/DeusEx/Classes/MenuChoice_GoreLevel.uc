//=============================================================================
// MenuChoice_GoreLevel
//=============================================================================

class MenuChoice_GoreLevel extends MenuUIChoiceEnum;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	// Check for German system and disable this option
	if (player.Level.Game.bVeryLowGore)
		btnAction.EnableWindow(False);
	else
		SetValue(int(!player.Level.Game.bLowGore));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.Level.Game.bLowGore = !bool(GetValue());
	player.Level.Game.SaveConfig();
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(defaultValue);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     enumText(0)="Low"
     enumText(1)="Normal"
     defaultValue=1
     defaultInfoWidth=88
     HelpText="Setting to low will remove blood from the game"
     actionText="|&Gore Level"
}
