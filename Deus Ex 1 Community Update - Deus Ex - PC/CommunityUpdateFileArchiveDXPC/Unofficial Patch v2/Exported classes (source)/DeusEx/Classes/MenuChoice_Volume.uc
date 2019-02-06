//=============================================================================
// MenuChoice_Volume
//=============================================================================

class MenuChoice_Volume extends MenuUIChoiceSlider;

var localized String VolumeOffText;
var localized String VolumeMaxText;

// ----------------------------------------------------------------------
// SetEnumerators()
// ----------------------------------------------------------------------

function SetEnumerators()
{
	// The first sliders use the same enumerations
	SetEnumeration(0, VolumeOffText);
	SetEnumeration(1, "1");
	SetEnumeration(2, "2");
	SetEnumeration(3, "3");
	SetEnumeration(4, "4");
	SetEnumeration(5, "5");
	SetEnumeration(6, "6");
	SetEnumeration(7, "7");
	SetEnumeration(8, "8");
	SetEnumeration(9, "9");
	SetEnumeration(10, VolumeMaxText);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     VolumeOffText="OFF"
     VolumeMaxText="MAX"
     endValue=255.000000
}
