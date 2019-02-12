//=============================================================================
// PersonaBorderButtonWindow
//=============================================================================

class PersonaBorderButtonWindow extends ButtonWindow;

struct S_MenuUIBorderButtonTextures
{
	var Texture tex;
	var int     width;
};

var DeusExPlayer player;

var String buttonText;

// 0 = Normal
// 1 = Depressed
// 2 = Focus
// 3 = Insensitive

var S_MenuUIBorderButtonTextures Left_Textures[2];
var S_MenuUIBorderButtonTextures Right_Textures[2];
var S_MenuUIBorderButtonTextures Center_Textures[2];

var Color colButtonFace;
var Color colText[4];

// Used when drawing button
var int textureIndex;
var int textOffset;
var int leftOffset;
var int textColorIndex;
var int buttonVerticalOffset;
var int leftMargin;
var int rightMargin;
var int fontBaseLine;
var int fontAcceleratorLineHeight;

// Defaults
var Font fontButtonText;
var int  verticalTextMargin;
var int  buttonHeight;
var bool bBaseWidthOnText;
var int  minimumButtonWidth;
var int  maxTextWidth;
var bool bTranslucent;
var bool bUseTextOffset;
var bool bCenterText;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	EnableTextAsAccelerator(false);

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	// TODO: Unique HUD sounds
	SetButtonSounds(None, Sound'Menu_Press');
	SetFocusSounds(Sound'Menu_Focus');
	SetSoundVolume(0.25);

	SetBaselineData(fontBaseLine, fontAcceleratorLineHeight);

	StyleChanged();
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	SetButtonMetrics();

	// Draw the textures
	if (bTranslucent)
		gc.SetStyle(DSTY_Translucent);
	else
		gc.SetStyle(DSTY_Masked);

	gc.SetTileColor(colButtonFace);

	// Left
	gc.DrawTexture(
		leftOffset, buttonVerticalOffset, 
		Left_Textures[textureIndex].width, buttonHeight, 
		0, 0, 
		Left_Textures[textureIndex].tex);

	// Center
	gc.DrawPattern(
		leftOffset + Left_Textures[textureIndex].width, buttonVerticalOffset, 
		width - Left_Textures[textureIndex].width - Right_Textures[textureIndex].width - leftOffset, buttonHeight, 
		0, 0,
		Center_Textures[textureIndex].tex);

	// Right
	gc.DrawTexture(
		width - Right_Textures[textureIndex].width, buttonVerticalOffset, 
		Right_Textures[textureIndex].width, buttonHeight, 
		0, 0, 
		Right_Textures[textureIndex].tex);

	// Draw the text!
	gc.SetFont(fontButtonText);
	gc.SetTextColor(colText[textColorIndex]);
	gc.SetVerticalAlignment(VALIGN_Center);

	if (bCenterText)
	{
		gc.SetHorizontalAlignment(HALIGN_Center);
		leftMargin = 0;
	}
	else
	{
		gc.SetHorizontalAlignment(HALIGN_Left);
	}

	if (bUseTextOffset)
	{
		gc.DrawText(
			leftMargin + textOffset, verticalTextMargin + textOffset + buttonVerticalOffset,
			width, height, buttonText);
	}
	else
	{
		gc.DrawText(
			leftMargin, verticalTextMargin + buttonVerticalOffset, 
			width, height, buttonText);
	}
}

// ----------------------------------------------------------------------
// SetVerticalOffset()
// ----------------------------------------------------------------------

function SetVerticalOffset(int newButtonVerticalOffset)
{
	buttonVerticalOffset = newButtonVerticalOffset;
}

// ----------------------------------------------------------------------
// ParentRequestedPreferredSize()
// ----------------------------------------------------------------------

event ParentRequestedPreferredSize(bool bWidthSpecified, out float preferredWidth,
                                   bool bHeightSpecified, out float preferredHeight)
{
	local float clientWidth, clientHeight;
	local float textWidth, textHeight;
	local GC gc;

	gc = GetGC();

	gc.SetFont(fontButtonText);
	gc.GetTextExtent(maxTextWidth, textWidth, textHeight, buttonText);

	preferredWidth  = Max(minimumButtonWidth, Left_Textures[0].width + leftMargin + textWidth + rightMargin + Right_Textures[0].width);
	preferredHeight = buttonHeight + buttonVerticalOffset;

	ReleaseGC(gc);
}

// ----------------------------------------------------------------------
// SetButtonMetrics()
//
// Calculates which set of textures we're going to use as well as 
// any text offset (used if the button is pressed in)
// ----------------------------------------------------------------------

function SetButtonMetrics()
{
	if (bIsSensitive)
	{
		if (bButtonPressed)				// button pressed
		{
			textureIndex = 1;
			textOffset = 1;
			textColorIndex = 2;
		}
		else if (IsFocusWindow())		// focus
		{
			textureIndex = 0;
			textOffset = 0;
			textColorIndex = 1;
		}
		else							// normal
		{
			textureIndex = 0;
			textOffset = 0;
			textColorIndex = 0;
		}
	}
	else								// disabled
	{
		textureIndex = 0;
		textOffset = 0;
		textColorIndex = 3;
	}
}	

// ----------------------------------------------------------------------
// SetButtonText()
// ----------------------------------------------------------------------

function SetButtonText(String newText)
{
	buttonText = newText;

	SetAcceleratorText(newText);

	AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// CenterText()
// ----------------------------------------------------------------------

function CenterText(optional bool bNewCenter)
{
	bCenterText = bNewCenter;
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	bTranslucent  = player.GetHUDBackgroundTranslucency();

	colButtonFace = theme.GetColorFromName('HUDColor_ButtonFace');
	colText[0]    = theme.GetColorFromName('HUDColor_ButtonTextNormal');
	
	colText[1]    = theme.GetColorFromName('HUDColor_ButtonTextFocus');
	colText[2]    = colText[1];

	colText[3]    = theme.GetColorFromName('HUDColor_ButtonTextDisabled');
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colButtonFace=(R=255,G=255,B=255)
     colText(0)=(R=200,G=200,B=200)
     colText(1)=(R=255,G=255,B=255)
     colText(2)=(R=255,G=255,B=255)
     colText(3)=(R=50,G=50,B=50)
     leftMargin=6
     fontBaseLine=1
     fontAcceleratorLineHeight=1
     fontButtonText=Font'DeusExUI.FontMenuHeaders'
     verticalTextMargin=1
     maxTextWidth=200
     bUseTextOffset=True
}
