//=============================================================================
// PersonaGoalTextWindow
//=============================================================================

class PersonaGoalTextWindow extends TextWindow;

var Font fontText;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetFont(fontText);
	SetTextAlignments(HALIGN_Left, VALIGN_Center);
	SetTextMargins(5, 2);
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     fontText=Font'DeusExUI.FontMenuSmall'
}
