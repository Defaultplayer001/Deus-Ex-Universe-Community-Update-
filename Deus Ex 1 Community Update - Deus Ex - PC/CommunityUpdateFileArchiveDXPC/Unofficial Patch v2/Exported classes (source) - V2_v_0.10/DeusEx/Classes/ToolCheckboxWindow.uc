//=============================================================================
// ToolCheckboxWindow
//=============================================================================

class ToolCheckboxWindow expands CheckboxWindow;

// Defaults
var Color colText;
var Font  fontText;
var int fontBaseLine;
var int fontAcceleratorLineHeight;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetFont(fontText);
	SetTextColors(colText, colText, colText, colText);
	SetTextAlignments(HALIGN_Left, VALIGN_Center);
	SetTextMargins(0, 0);
	SetCheckboxTextures(Texture'ToolWindowCheckbox_Off', Texture'ToolWindowCheckbox_On', 13, 13);
	SetCheckboxSpacing(6);
	SetCheckboxStyle(DSTY_Normal);
	SetBaselineData(fontBaseLine, fontAcceleratorLineHeight);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     fontText=Font'DeusExUI.FontSansSerif_8'
     fontBaseLine=1
     fontAcceleratorLineHeight=1
}
