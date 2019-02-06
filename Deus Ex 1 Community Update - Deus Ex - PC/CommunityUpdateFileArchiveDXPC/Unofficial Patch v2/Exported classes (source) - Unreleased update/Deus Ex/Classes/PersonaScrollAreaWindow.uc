//=============================================================================
// PersonaScrollAreaWindow
//=============================================================================

class PersonaScrollAreaWindow extends ScrollAreaWindow;

var DeusExPlayer player;

var Color colButtonFace;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
	EnableScrolling(False, True);
	SetAreaMargins(0, 0);
	SetScrollbarDistance(0);

	vScale.SetThumbCaps(
		Texture'PersonaScrollThumb_Top', 
		Texture'PersonaScrollThumb_Bottom', 
		7, 4, 7, 4);

	// TODO: Replace Menu sounds with HUD sounds

	vScale.SetThumbTexture(Texture'PersonaScrollThumb_Center', 7, 2);
	vScale.SetScaleTexture(Texture'PersonaScrollScale', 11, 2, 0, 0);
	vScale.SetScaleMargins(0, 0);
	vScale.SetScaleStyle(DSTY_Translucent);
	vScale.SetThumbStyle(DSTY_Translucent);
	vScale.SetThumbStep(10);
	vScale.SetScaleSounds(Sound'Menu_Press', Sound'Menu_Press', Sound'Menu_Slider');
	vScale.SetSoundVolume(0.25);

	upButton.SetSize(11, 12);
	upButton.SetBackgroundStyle(DSTY_Translucent);
	upButton.SetButtonTextures(
		Texture'PersonaScrollUpButton_Normal', Texture'PersonaScrollUpButton_Pressed',
		Texture'PersonaScrollUpButton_Focus',  Texture'PersonaScrollUpButton_Pressed',
		Texture'PersonaScrollUpButton_Normal', Texture'PersonaScrollUpButton_Pressed');
	upButton.SetButtonSounds(None, Sound'Menu_Press');
	upButton.SetFocusSounds(Sound'Menu_Focus');
	upButton.SetSoundVolume(0.25);

	downButton.SetSize(11, 12);
	downButton.SetBackgroundStyle(DSTY_Translucent);
	downButton.SetButtonTextures(
		Texture'PersonaScrollDownButton_Normal', Texture'PersonaScrollDownButton_Pressed',
		Texture'PersonaScrollDownButton_Focus',  Texture'PersonaScrollDownButton_Pressed',
		Texture'PersonaScrollDownButton_Normal', Texture'PersonaScrollDownButton_Pressed');
	downButton.SetButtonSounds(None, Sound'Menu_Press');
	downButton.SetFocusSounds(Sound'Menu_Focus');
	downButton.SetSoundVolume(0.25);

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

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	// Title colors
	colButtonFace = theme.GetColorFromName('HUDColor_ButtonFace');

	upButton.SetButtonColors(colButtonFace, colButtonFace, colButtonFace,
                             colButtonFace, colButtonFace, colButtonFace);

	downButton.SetButtonColors(colButtonFace, colButtonFace, colButtonFace,
	                           colButtonFace, colButtonFace, colButtonFace);

	vScale.SetScaleColor(colButtonFace);
	vScale.SetThumbColor(colButtonFace);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colButtonFace=(R=255,G=255,B=255)
}
