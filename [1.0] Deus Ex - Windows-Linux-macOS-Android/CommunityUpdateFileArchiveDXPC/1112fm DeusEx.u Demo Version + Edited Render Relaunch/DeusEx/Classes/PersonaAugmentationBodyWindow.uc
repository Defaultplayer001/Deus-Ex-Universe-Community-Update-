//=============================================================================
// PersonaAugmentationBodyWindow
//=============================================================================

class PersonaAugmentationBodyWindow extends Window;

var Texture bodyTextures[2];

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(174, 359);
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	// Draw window background
	gc.SetStyle(DSTY_Masked);

	gc.DrawTexture(0,   0, 174, 256, 0, 0, bodyTextures[0]);
	gc.DrawTexture(0, 256, 174, 103, 0, 0, bodyTextures[1]);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bodyTextures(0)=Texture'DeusExUI.UserInterface.AugmentationsBody_1'
     bodyTextures(1)=Texture'DeusExUI.UserInterface.AugmentationsBody_2'
}
