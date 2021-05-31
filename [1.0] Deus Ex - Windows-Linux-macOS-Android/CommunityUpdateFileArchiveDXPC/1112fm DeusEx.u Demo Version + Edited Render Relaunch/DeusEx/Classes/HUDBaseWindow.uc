//=============================================================================
// HUDBaseWindow
//=============================================================================
class HUDBaseWindow extends Window;

var DeusExPlayer player;

// Border and Background Translucency
var bool       bDrawBorder;
var EDrawStyle borderDrawStyle;
var EDrawStyle backgroundDrawStyle;

// Position/size of background
var int backgroundWidth;
var int backgroundHeight;
var int backgroundPosX;
var int backgroundPosY;

// Default Colors
var Color colBackground;
var Color colBorder;
var Color colHeaderText;
var Color colText;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
	
	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	StyleChanged();
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	// First draw the background then the border
	DrawBackground(gc);
	DrawBorder(gc);
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
}

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

function DrawBorder(GC gc)
{
}

// ----------------------------------------------------------------------
// RefreshHUDDisplay()
// ----------------------------------------------------------------------

function RefreshHUDDisplay(float DeltaTime)
{
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	coLBackground = theme.GetColorFromName('HUDColor_Background');
	colBorder     = theme.GetColorFromName('HUDColor_Borders');
	colText       = theme.GetColorFromName('HUDColor_NormalText');
	colHeaderText = theme.GetColorFromName('HUDColor_HeaderText');

	bDrawBorder            = player.GetHUDBordersVisible();

	if (player.GetHUDBorderTranslucency())
		borderDrawStyle = DSTY_Translucent;
	else
		borderDrawStyle = DSTY_Masked;

	if (player.GetHUDBackgroundTranslucency())
		backgroundDrawStyle = DSTY_Translucent;
	else
		backgroundDrawStyle = DSTY_Masked;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bDrawBorder=True
     colBackground=(R=128,G=128,B=128)
     colBorder=(R=128,G=128,B=128)
     colText=(R=255,G=255,B=255)
}
