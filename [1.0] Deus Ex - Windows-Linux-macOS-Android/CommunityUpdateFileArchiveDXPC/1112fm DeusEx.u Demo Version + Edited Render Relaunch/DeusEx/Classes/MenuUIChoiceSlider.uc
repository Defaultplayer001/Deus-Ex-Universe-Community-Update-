//=============================================================================
// MenuUIChoiceSlider
//=============================================================================

class MenuUIChoiceSlider extends MenuUIChoice;

// Defaults
var MenuUISliderButtonWindow btnSlider;

var int numTicks;
var float startValue;
var float endValue;
var float defaultValue;
var float saveValue;
var Bool  bInitializing;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	bInitializing=True;

	Super.InitWindow();

	CreateSlider();
	SetEnumerators();

	bInitializing=False;
}

// ----------------------------------------------------------------------
// ParentRequestedPreferredSize()
// ----------------------------------------------------------------------

event ParentRequestedPreferredSize(bool bWidthSpecified, out float preferredWidth,
                                   bool bHeightSpecified, out float preferredHeight)
{
	local float sliderWidth, sliderHeight;

	if (btnSlider!= None)
		btnSlider.QueryPreferredSize(sliderWidth, sliderHeight);

	preferredWidth  = sliderWidth;
	preferredHeight = sliderHeight;
}

// ----------------------------------------------------------------------
// CreateSlider()
// ----------------------------------------------------------------------

function CreateSlider()
{
	btnSlider = MenuUISliderButtonWindow(NewChild(Class'MenuUISliderButtonWindow'));

	btnSlider.SetSelectability(False);
	btnSlider.SetPos(choiceControlPosX, 0);
	btnSlider.SetTicks(numTicks, startValue, endValue);
}

// ----------------------------------------------------------------------
// SetEnumerators()
// ----------------------------------------------------------------------

function SetEnumerators()
{
}

// ----------------------------------------------------------------------
// SetEnumeration()
// ----------------------------------------------------------------------

function SetEnumeration(int tickPos, coerce string newStr)
{
	if (btnSlider != None)
		btnSlider.winSlider.SetEnumeration(tickPos, newStr);
}

// ----------------------------------------------------------------------
// SetValue()
// ----------------------------------------------------------------------

function SetValue(float newValue)
{
	if (btnSlider  != None)
		btnSlider.winSlider.SetValue(newValue);
}

// ----------------------------------------------------------------------
// GetValue()
// ----------------------------------------------------------------------

function float GetValue()
{
	if (btnSlider != None)
		return btnSlider.winSlider.GetValue();
	else
		return 0;
}

// ----------------------------------------------------------------------
// CycleNextValue()
// ----------------------------------------------------------------------

function CycleNextValue()
{
	local int newValue;

	if (btnSlider != None)
	{
		// Get the current slider value and attempt to increment.
		// If at the max go back to the beginning

		newValue = btnSlider.winSlider.GetTickPosition() + 1;

		if (newValue == btnSlider.winSlider.GetNumTicks())
			newValue = 0;

		btnSlider.winSlider.SetTickPosition(newValue);
	}
}

// ----------------------------------------------------------------------
// CyclePreviousValue()
// ----------------------------------------------------------------------

function CyclePreviousValue()
{
	local int newValue;

	if (btnSlider != None)
	{
		// Get the current slider value and attempt to increment.
		// If at the max go back to the beginning

		newValue = btnSlider.winSlider.GetTickPosition() - 1;

		if (newValue < 0)
			newValue = btnSlider.winSlider.GetNumTicks() - 1;

		btnSlider.winSlider.SetTickPosition(newValue);
	}
}

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	if (configSetting != "")
		SetValue(float(player.ConsoleCommand("get " $ configSetting)));
	else
		ResetToDefault();
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	if (configSetting != "")
		player.ConsoleCommand("set " $ configSetting $ " " $ GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	if (configSetting != "")
	{
		player.ConsoleCommand("set " $ configSetting $ " " $ defaultValue);
		LoadSetting();
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     numTicks=11
     endValue=10.000000
     buttonVerticalOffset=1
     actionText="Slider Choice"
}
