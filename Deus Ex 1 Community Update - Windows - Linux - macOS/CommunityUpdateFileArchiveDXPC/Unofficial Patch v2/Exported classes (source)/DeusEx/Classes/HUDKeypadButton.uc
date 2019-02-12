//=============================================================================
// HUDKeypadButton
//=============================================================================

class HUDKeypadButton expands ButtonWindow;

var DeusExPlayer player;

// Border and Background Translucency
var bool bBorderTranslucent;
var bool bBackgroundTranslucent;
var bool bDrawBorder;

// Default Colors
var Color colBackground;
var Color colBorder;
var Color colHeaderText;
var Color colSensitive;
var Color colInsensitive;

var int num;	// what number should I be?

var Texture keypadButtonTextures[2];

// ----------------------------------------------------------------------
// InitWindow()
//
// Responsible for creating the various and sundry sub-windows for
// the keypad popup.
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
	
	SetSize(25, 27);

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	StyleChanged();
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{		
	local HUDKeypadWindow parent;

	parent = HUDKeypadWindow(GetParent());

	// Draw the button graphic
	gc.SetTileColor(colBackground);

	if (bBackgroundTranslucent)
		gc.SetStyle(DSTY_Translucent);
	else
		gc.SetStyle(DSTY_Masked);
	
	if (bButtonPressed)
		gc.DrawTexture(0, 0, width, height, 0, 0, keypadButtonTextures[1]);
	else
		gc.DrawTexture(0, 0, width, height, 0, 0, keypadButtonTextures[0]);

	// Display darker if the button's insensitive
	if (bIsSensitive)
		gc.SetTextColor(colSensitive);
	else
		gc.SetTextColor(colInsensitive);

	// If the button is currently being depressed, then draw the 
	// graphic down and to the right one.
	gc.SetFont(Font'FontMenuExtraLarge');
	gc.SetAlignments(HALIGN_Center, VALIGN_Center);
	gc.EnableTranslucentText(True);

	if (bButtonPressed)
		gc.DrawText(1, 3, width, height, parent.IndexToString(num));
	else
		gc.DrawText(0, 2, width, height, parent.IndexToString(num));
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colBackground = theme.GetColorFromName('HUDColor_Background');

	bBorderTranslucent     = player.GetHUDBorderTranslucency();
	bBackgroundTranslucent = player.GetHUDBackgroundTranslucency();
	bDrawBorder            = player.GetHUDBordersVisible();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colSensitive=(R=255,G=255,B=255)
     colInsensitive=(R=64,G=64,B=64)
     keypadButtonTextures(0)=Texture'DeusExUI.UserInterface.HUDKeypadButton_Normal'
     keypadButtonTextures(1)=Texture'DeusExUI.UserInterface.HUDKeypadButton_Pressed'
}
