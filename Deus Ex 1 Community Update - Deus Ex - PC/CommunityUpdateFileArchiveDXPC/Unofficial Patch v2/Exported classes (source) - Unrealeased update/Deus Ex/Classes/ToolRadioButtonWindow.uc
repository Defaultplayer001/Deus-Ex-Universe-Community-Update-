//=============================================================================
// ToolRadioButtonWindow
//=============================================================================

class ToolRadioButtonWindow expands ToolCheckboxWindow;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetCheckboxTextures(Texture'ToolRadioButton_Off', Texture'ToolRadioButton_On', 12, 12);
	SetCheckboxStyle(DSTY_Masked);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
