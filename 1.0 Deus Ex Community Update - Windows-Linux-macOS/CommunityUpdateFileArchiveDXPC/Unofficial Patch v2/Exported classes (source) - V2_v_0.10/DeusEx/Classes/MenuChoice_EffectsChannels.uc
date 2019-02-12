//=============================================================================
// MenuChoice_EffectsChannels
//=============================================================================

class MenuChoice_EffectsChannels extends MenuUIChoiceSlider;

// ----------------------------------------------------------------------
// SetEnumerators()
// ----------------------------------------------------------------------

function SetEnumerators()
{
	local int enumIndex;
	local int counter;

	counter = 0;

	for(enumIndex=4;enumIndex<17;enumIndex++)
	{
		SetEnumeration(counter, enumIndex);
		counter++;
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     numTicks=13
     startValue=4.000000
     endValue=16.000000
     defaultValue=16.000000
     HelpText="Number of sound effects channels"
     actionText="E|&ffects Channels"
     configSetting="ini:Engine.Engine.AudioDevice EffectsChannels"
}
