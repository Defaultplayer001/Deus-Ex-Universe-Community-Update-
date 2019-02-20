//=============================================================================
// StaticWindow
//=============================================================================
class StaticWindow expands Window;

// ----------------------------------------------------------------------
// Local Variables
// ----------------------------------------------------------------------

var Float lineInterval;
var Float lastLine;
var int currentLinePosY;
var Bool bLinePauseDelay;
var Bool bLineVisible;
var Float linePauseDelay;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// 20% chance that the line won't be visible
	bLineVisible = (FRand() > 0.20);

	Hide();
}

// ----------------------------------------------------------------------
// RandomizeStatic()
// ----------------------------------------------------------------------

function RandomizeStatic()
{
	lineInterval    = (FRand() / 15);
	linePauseDelay  = (FRand() / 2) + 0.75;
	currentLinePosY = (Rand(hardcodedHeight) - 6);
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	// First draw the static
	gc.SetStyle(DSTY_Translucent);
	gc.DrawPattern(0, 0, width, height, rand(128), rand(128), Texture'Static');

	// Now draw the line
	if (bLineVisible)
	{
		gc.SetStyle(DSTY_Modulated);
		gc.DrawPattern(0, currentLinePosY, width, 6, 0, 0, Texture'StaticLine');
	}
}

// ----------------------------------------------------------------------
// VisibilityChanged()
// ----------------------------------------------------------------------

event VisibilityChanged(bool bNewVisibility)
{
	bTickEnabled = (bNewVisibility && bLineVisible);
}

// ----------------------------------------------------------------------
// Tick()
//
// Used to update the energy bar
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
	lastLine += deltaSeconds;

	if (bLinePauseDelay)
	{
		if (lastLine > linePauseDelay)
		{
			bLinePauseDelay = False;
			lastLine = 0.0;
		}
	}
	else
	{
		if (lastLine > LineInterval)
		{
			lastLine = 0.0;

			currentLinePosY += 1;

			if (currentLinePosY > Height)
			{
				currentLinePosY = -6;
				bLinePauseDelay = True;
			}
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     lineInterval=0.020000
     currentLinePosY=-6
     bLineVisible=True
     linePauseDelay=1.000000
}
