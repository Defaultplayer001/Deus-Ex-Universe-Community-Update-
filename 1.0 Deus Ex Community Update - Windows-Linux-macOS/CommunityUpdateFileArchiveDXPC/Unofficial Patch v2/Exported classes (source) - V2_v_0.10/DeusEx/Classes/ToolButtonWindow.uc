//=============================================================================
// ToolButtonWindow
//=============================================================================

class ToolButtonWindow expands ButtonWindow;

var String buttonText;

// Defaults
var Color colBackgroundColor;
var Color colText;
var Color colTextDisabledBack;
var Color colTextDisabledFore;

var Font fontText;
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

	EnableTextAsAccelerator(false);

	// Center this window	
	SetSize(75, 23);
	SetFont(fontText);
	SetTextColors(colText, colText, colText, colText, colText, colText);
	SetButtonTextures(
		Texture'ToolButtonWindow_Normal', Texture'ToolButtonWindow_Normal',
		Texture'ToolButtonWindow_NormalFocus', Texture'ToolButtonWindow_PressedFocus',
		Texture'ToolButtonWindow_Normal', Texture'ToolButtonWindow_Normal');

	SetBaselineData(fontBaseLine, fontAcceleratorLineHeight);
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	// Draw the text

	// If the button is insensitive, then draw it differently
	if ( bIsSensitive )
	{
		gc.SetTextColor(colText);

		// If the button is pressed, draw the text down and to the right
		if ( bButtonPressed )
			gc.DrawText(1, 1, width, height, buttonText);
		else
			gc.DrawText(0, 0, width, height, buttonText);
	}
	else
	{
		gc.SetTextColor(colTextDisabledBack);
		gc.DrawText(1, 1, width, height, buttonText);
		gc.SetTextColor(colTextDisabledFore);
		gc.DrawText(0, 0, width, height, buttonText);
	}
}

// ----------------------------------------------------------------------
// SetButtonText()
// ----------------------------------------------------------------------

function SetButtonText(String newButtonText)
{
	buttonText = newButtonText;

	SetAcceleratorText(newButtonText);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colBackgroundColor=(R=192,G=192,B=192)
     colTextDisabledBack=(R=255,G=255,B=255)
     colTextDisabledFore=(R=128,G=128,B=128)
     fontText=Font'DeusExUI.FontSansSerif_8'
     fontBaseLine=1
     fontAcceleratorLineHeight=1
}
