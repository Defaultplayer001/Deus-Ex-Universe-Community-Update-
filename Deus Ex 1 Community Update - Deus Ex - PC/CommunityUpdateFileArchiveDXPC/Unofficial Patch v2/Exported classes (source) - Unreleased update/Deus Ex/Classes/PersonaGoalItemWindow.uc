//=============================================================================
// PersonaGoalItemWindow
//=============================================================================

class PersonaGoalItemWindow extends AlignWindow;

var DeusExPlayer player;

var PersonaGoalTextWindow winBullet;
var PersonaGoalTextWindow winGoalText;

var Bool bCompleted;
var Bool bPrimaryGoal;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetChildVAlignment(VALIGN_Top);

	CreateTextWindows();

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	StyleChanged();
}

// ----------------------------------------------------------------------
// CreateTextWindows()
// ----------------------------------------------------------------------

function CreateTextWindows()
{
	winBullet   = PersonaGoalTextWindow(NewChild(Class'PersonaGoalTextWindow'));
	winGoalText = PersonaGoalTextWindow(NewChild(Class'PersonaGoalTextWindow'));
}

// ----------------------------------------------------------------------
// SetGoalProperties()
// ----------------------------------------------------------------------

function SetGoalProperties(bool bNewPrimaryGoal, bool bNewCompleted, string goalText, optional bool bNoBullet)
{
	bPrimaryGoal = bNewPrimaryGoal;
	bCompleted   = bNewCompleted;

	winGoalText.SetText(goalText);

	if (bNoBullet)
		winBullet.SetText("");
	else
		winBullet.SetText("~");

	StyleChanged();
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;
	local Color colText;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	// Title colors
	colText = theme.GetColorFromName('HUDColor_NormalText');

	// Display completed goals in a different color
	if (bCompleted)
	{
		winBullet.SetTextColorRGB(colText.r / 2, colText.g / 2, colText.b / 2);
		winGoalText.SetTextColorRGB(colText.r / 2, colText.g / 2, colText.b / 2);
	}
	else
	{
		winBullet.SetTextColor(colText);
		winGoalText.SetTextColor(colText);
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
