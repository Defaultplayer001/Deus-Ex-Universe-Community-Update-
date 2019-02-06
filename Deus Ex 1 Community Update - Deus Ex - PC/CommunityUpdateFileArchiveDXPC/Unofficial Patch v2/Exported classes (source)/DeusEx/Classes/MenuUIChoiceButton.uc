//=============================================================================
// MenuUIChoiceButton
//=============================================================================

class MenuUIChoiceButton extends MenuUIActionButtonWindow;

var String helpText;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetWidth(243);
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Let the parent window handle [Return] so we can use it as "OK"
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bHandled;

	if (key == IK_Enter)
		return False;
	else
		return Super.VirtualKeyPressed(key, bRepeat);
}

// ----------------------------------------------------------------------
// SetHelpText()
// ----------------------------------------------------------------------

function SetHelpText(String newHelpText)
{
	helpText = newHelpText;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     verticalTextMargin=0
}
