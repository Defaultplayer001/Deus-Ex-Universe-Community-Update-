//=============================================================================
// MenuChoice_MouseSensitivity
//=============================================================================

class MenuChoice_MouseSensitivity extends MenuUIChoiceSlider;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	saveValue = player.MouseSensitivity;
	SetValue(player.MouseSensitivity);
}

// ----------------------------------------------------------------------
// CancelSetting()
// ----------------------------------------------------------------------

function CancelSetting()
{
	player.UpdateSensitivity(saveValue);
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
log("MenuChoice_MouseSensitivy::ResetToDefaults()----------------------");
log("  devaultValue = "$  defaultValue);

	player.UpdateSensitivity(defaultValue);
	SetValue(player.MouseSensitivity);
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
// ScalePositionChanged() 
//
// Update the Mouse Sensitivity value
// ----------------------------------------------------------------------

event bool ScalePositionChanged(Window scale, int newTickPosition,
                                float newValue, bool bFinal)
{
	// Don't do anything while initializing as we get several 
	// ScalePositionChanged() events before LoadSetting() is called.

	if (bInitializing)
		return False;

	player.UpdateSensitivity(GetValue());
	return false;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     numTicks=10
     startValue=1.000000
     defaultValue=3.000000
     HelpText="Modifies the mouse sensitivity"
     actionText="Mouse |&Sensitivity"
}
