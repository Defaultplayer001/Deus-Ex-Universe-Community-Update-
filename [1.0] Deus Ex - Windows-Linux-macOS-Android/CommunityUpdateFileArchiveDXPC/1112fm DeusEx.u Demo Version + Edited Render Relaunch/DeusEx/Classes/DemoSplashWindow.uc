//=============================================================================
// DemoSplashWindow
//=============================================================================

class DemoSplashWindow extends DeusExBaseWindow;

// ----------------------------------------------------------------------
// Local Variables
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(640, 480);
	SetWindowAlignments(HALIGN_Center, VALIGN_Center);
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	player.Level.Game.SendPlayer(player, "dxonly");
	return True;
}

// ----------------------------------------------------------------------
// MouseButtonReleased()
//
// Exit the window if the mouse button is presse
// ----------------------------------------------------------------------

event bool MouseButtonReleased(float pointX, float pointY, EInputKey button,
                               int numClicks)
{
	player.Level.Game.SendPlayer(player, "dxonly");
	return True;
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

function DrawWindow(GC gc)
{
	gc.SetStyle(DSTY_Normal);

	gc.DrawIcon(  0,   0, Texture'Demo_Splash_1');
	gc.DrawIcon(256,   0, Texture'Demo_Splash_2');
	gc.DrawIcon(512,   0, Texture'Demo_Splash_3');
	gc.DrawIcon(  0, 256, Texture'Demo_Splash_4');
	gc.DrawIcon(256, 256, Texture'Demo_Splash_5');
	gc.DrawIcon(512, 256, Texture'Demo_Splash_6');
}

defaultproperties
{
}
