//=============================================================================
// HUDBarkDisplayItem
//=============================================================================
class HUDBarkDisplayItem expands AlignWindow;

var DeusExPlayer player;

var TextWindow winName;
var TextWindow winBark;

var Float timeToDisplay;
var Float timeDisplayed;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Defaults for tile window
	SetChildVAlignment(VALIGN_Top);

	winName = TextWindow(NewChild(Class'TextWindow'));
	winName.SetFont(Font'FontMenuHeaders_DS');
	winName.SetTextAlignments(HALIGN_Left, VALIGN_Top);
	winName.SetTextMargins(0, 0);

	winBark = TextWindow(NewChild(Class'TextWindow'));
	winBark.SetTextAlignments(HALIGN_Left, VALIGN_Top);
	winBark.SetFont(Font'FontMenuSmall_DS');
	winBark.SetTextMargins(0, 1);
	winBark.SetWordWrap(True);

	// Get a pointer to the player
	player = DeusExPlayer(GetPlayerPawn());

	StyleChanged();
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
	timeDisplayed += deltaSeconds;

	if (timeDisplayed > timeToDisplay)
	{
		bTickEnabled = False;
		Destroy();
	}
}

// ----------------------------------------------------------------------
// SetBarkSpeech()
// ----------------------------------------------------------------------

function SetBarkSpeech(string text, float newDisplayTime, Actor speakingActor)
{
	winName.SetText(speakingActor.UnfamiliarName $ ": ");
	winBark.SetText(text);

	timeToDisplay = newDisplayTime;
	timeDisplayed = 0;
	bTickEnabled  = True;
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;
	local Color colNameText;
	local Color colText;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colNameText   = theme.GetColorFromName('HUDColor_HeaderText');
	colText       = theme.GetColorFromName('HUDColor_NormalText');

	winName.SetTextColor(colNameText);
	winBark.SetTextColor(colText);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     timeToDisplay=3.000000
}
