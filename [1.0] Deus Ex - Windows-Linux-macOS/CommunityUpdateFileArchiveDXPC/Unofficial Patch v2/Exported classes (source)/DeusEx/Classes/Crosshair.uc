//=============================================================================
// Crosshair.
//=============================================================================
class Crosshair extends Window;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	local Color col;

	Super.InitWindow();

	SetBackgroundStyle(DSTY_Masked);
	SetBackground(Texture'CrossSquare');
	col.R = 255;
	col.G = 255;
	col.B = 255;
	SetCrosshairColor(col);
}

// ----------------------------------------------------------------------
// SetCrosshair()
// ----------------------------------------------------------------------

function SetCrosshair( bool bShow )
{
	Show(bShow);
}

// ----------------------------------------------------------------------
// SetCrosshairColor()
// ----------------------------------------------------------------------

function SetCrosshairColor(color newColor)
{
	SetTileColor(newColor);
}

defaultproperties
{
}
