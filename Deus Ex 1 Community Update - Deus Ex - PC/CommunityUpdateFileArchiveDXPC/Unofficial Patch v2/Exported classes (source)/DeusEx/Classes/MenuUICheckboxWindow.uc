//=============================================================================
// MenuUICheckboxWindow
//=============================================================================

class MenuUICheckboxWindow expands CheckboxWindow;

var DeusExPlayer player;

// Defaults
var Color colText;
var Color colButtonFace;
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
	SetTextAlignments(HALIGN_Left, VALIGN_Center);
	SetTextMargins(0, 0);
	SetCheckboxTextures(Texture'MenuCheckBox_Off', Texture'MenuCheckBox_On', 13, 13);
	SetCheckboxSpacing(6);
	SetCheckboxStyle(DSTY_Masked);
	SetBaselineData(fontBaseLine, fontAcceleratorLineHeight);

	SetButtonSounds(None, Sound'Menu_Press');
	SetSoundVolume(0.25);

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	StyleChanged();
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	colText       = theme.GetColorFromName('MenuColor_ButtonTextNormal');
	colButtonFace = theme.GetColorFromName('MenuColor_ButtonFace');

	SetTextColors(colText, colText, colText, colText);
	SetButtonColors(colButtonFace, colButtonFace, colButtonFace,
	                colButtonFace, colButtonFace, colButtonFace);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colText=(R=255,G=255,B=255)
     fontText=Font'DeusExUI.FontMenuTitle'
     fontBaseLine=1
     fontAcceleratorLineHeight=1
}
