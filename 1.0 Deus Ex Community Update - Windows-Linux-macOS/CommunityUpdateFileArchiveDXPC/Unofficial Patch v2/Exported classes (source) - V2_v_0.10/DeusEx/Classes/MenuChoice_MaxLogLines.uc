//=============================================================================
// MenuChoice_MaxLogLines
//=============================================================================

class MenuChoice_MaxLogLines extends MenuUIChoiceSlider;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(player.GetMaxLogLines());
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.SetMaxLogLines(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	player.UpdateSensitivity(defaultValue);
}

// ----------------------------------------------------------------------
// SetEnumerators()
// ----------------------------------------------------------------------

function SetEnumerators()
{
	local int enumIndex;

	for(enumIndex=1;enumIndex<11;enumIndex++)
		SetEnumeration(enumIndex-1, enumIndex);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     numTicks=13
     startValue=3.000000
     endValue=15.000000
     defaultValue=5.000000
     HelpText="Maximum number of log lines visible on the screen at any given time"
     actionText="Max. Log Lines"
}
