//=============================================================================
// CharacterModelButton
//=============================================================================

class CharacterModelButton expands ButtonWindow;

var Texture modelTexture;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(179, 295);
	SetSensitivity(False);
}

// ----------------------------------------------------------------------
// SetModelTexture()
// ----------------------------------------------------------------------

function SetModelTexture( Texture newTexture )
{
	modelTexture = newTexture;
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	gc.SetStyle(DSTY_Masked);
	gc.DrawIcon(-38, 17, modelTexture);
}

defaultproperties
{
}
