//=============================================================================
// TimerDisplay.
//=============================================================================
class TimerDisplay expands Window;

var Texture timerBackground;
var Color colNormal, colCritical, colBlack;
var bool bCritical;
var bool bFlash;
var float time;
var float flashTime;
var string message;
		
// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	bTickEnabled = True;
	SetBackgroundStyle(DSTY_Modulated);
	SetBackground(timerBackground);
	SetTileColorRGB(0, 0, 0);
	SetSize(80, 36);

	time = 0;
	flashTime = 0;
}

event Tick(float deltaTime)
{
	if (bFlash)
		flashTime += deltaTime;
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	local string str;
	local int mins;
	local float secs;

	Super.DrawWindow(gc);

	// Draw the timer
	gc.SetFont(Font'FontComputer8x20_B');
	gc.SetAlignments(HALIGN_Center, VALIGN_Bottom);
	gc.EnableWordWrap(False);

	if (bCritical)
		gc.SetTextColor(colCritical);
	else
		gc.SetTextColor(colNormal);

	// print the time nicely
	mins = time / 60;
	secs = time % 60;

	if (mins < 10)
		str = "0";
	str = str $ mins $ ":";
	if (secs < 10)
		str = str $ "0";
	str = str $ secs;

	if (bFlash && (flashTime >= 0.75))
	{
		gc.SetTextColor(colBlack);
		if (flashTime >= 1.0)
			flashTime = 0;
	}

	gc.DrawText(0, 0, width, height, str);

	// draw title
	gc.SetFont(Font'TechSmall');
	gc.SetAlignments(HALIGN_Left, VALIGN_Top);
	gc.DrawText(2, 2, width-2, height-2, message);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     timerBackground=Texture'DeusExUI.UserInterface.ConWindowBackground'
     colNormal=(G=255)
     colCritical=(R=255)
}
