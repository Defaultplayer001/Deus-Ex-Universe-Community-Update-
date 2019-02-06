//=============================================================================
// MenuChoice_LogTimeoutValue
//=============================================================================

class MenuChoice_LogTimeoutValue extends MenuUIChoiceSlider;

var localized String msgSecond;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(player.GetLogTimeout());
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.SetLogTimeout(GetValue());
}

// ----------------------------------------------------------------------
// SetEnumerators()
// ----------------------------------------------------------------------

function SetEnumerators()
{
	local float timeOut;
	local int enumIndex;

	enumIndex=0;
	for(timeOut=1.0; timeOut<=10; timeOut+=0.5)
	{
		SetEnumeration(enumIndex++, Left(String(timeOut), Instr(String(timeOut), ".") + 2) $ msgSecond);
	}
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
     msgSecond="s"
     numTicks=19
     startValue=1.000000
     defaultValue=3.000000
     HelpText="Select the amount of time log messages remain visible on the screen"
     actionText="|&Log Timeout Value"
}
