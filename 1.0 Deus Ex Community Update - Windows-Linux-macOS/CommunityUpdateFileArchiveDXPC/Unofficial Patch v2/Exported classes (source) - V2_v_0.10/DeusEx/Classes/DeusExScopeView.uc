//=============================================================================
// DeusExScopeView.
//=============================================================================
class DeusExScopeView expands Window;

var bool bActive;		// is this view actually active?

var DeusExPlayer player;
var Color colLines;
var Bool  bBinocs;
var Bool  bViewVisible;
var int   desiredFOV;

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

	bTickEnabled = true;

	StyleChanged();
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
	local Crosshair        cross;
	local DeusExRootWindow dxRoot;

	dxRoot = DeusExRootWindow(GetRootWindow());
	if (dxRoot != None)
	{
		cross = dxRoot.hud.cross;

		if (bActive)
			cross.SetCrosshair(false);
		else
			cross.SetCrosshair(player.bCrosshairVisible);
	}
}

// ----------------------------------------------------------------------
// ActivateView()
// ----------------------------------------------------------------------

function ActivateView(int newFOV, bool bNewBinocs, bool bInstant)
{
	desiredFOV = newFOV;

	bBinocs = bNewBinocs;

	if (player != None)
	{
		if (bInstant)
			player.SetFOVAngle(desiredFOV);
		else
			player.desiredFOV = desiredFOV;

		bViewVisible = True;
		Show();
	}
}

// ----------------------------------------------------------------------
// DeactivateView()
// ----------------------------------------------------------------------

function DeactivateView()
{
	if (player != None)
	{
		Player.DesiredFOV = Player.Default.DefaultFOV;
		bViewVisible = False;
		Hide();
	}
}

// ----------------------------------------------------------------------
// HideView()
// ----------------------------------------------------------------------

function HideView()
{
	if (bViewVisible)
	{
		Hide();
		Player.SetFOVAngle(Player.Default.DefaultFOV);
	}
}

// ----------------------------------------------------------------------
// ShowView()
// ----------------------------------------------------------------------

function ShowView()
{
	if (bViewVisible)
	{
		Player.SetFOVAngle(desiredFOV);
		Show();
	}
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	local float			fromX, toX;
	local float			fromY, toY;
	local float			scopeWidth, scopeHeight;

	Super.DrawWindow(gc);

	if (GetRootWindow().parentPawn != None)
	{
		if (player.IsInState('Dying'))
			return;
	}

	// Figure out where to put everything
	if (bBinocs)
		scopeWidth  = 512;
	else
		scopeWidth  = 256;

	scopeHeight = 256;

	fromX = (width-scopeWidth)/2;
	fromY = (height-scopeHeight)/2;
	toX   = fromX + scopeWidth;
	toY   = fromY + scopeHeight;

	// Draw the black borders
	gc.SetTileColorRGB(0, 0, 0);
	gc.SetStyle(DSTY_Normal);
	if ( Player.Level.NetMode == NM_Standalone )	// Only block out screen real estate in single player
	{
		gc.DrawPattern(0, 0, width, fromY, 0, 0, Texture'Solid');
		gc.DrawPattern(0, toY, width, fromY, 0, 0, Texture'Solid');
		gc.DrawPattern(0, fromY, fromX, scopeHeight, 0, 0, Texture'Solid');
		gc.DrawPattern(toX, fromY, fromX, scopeHeight, 0, 0, Texture'Solid');
	}
	// Draw the center scope bitmap
	// Use the Header Text color 

//	gc.SetStyle(DSTY_Masked);
	if (bBinocs)
	{
		gc.SetStyle(DSTY_Modulated);
		gc.DrawTexture(fromX,       fromY, 256, scopeHeight, 0, 0, Texture'HUDBinocularView_1');
		gc.DrawTexture(fromX + 256, fromY, 256, scopeHeight, 0, 0, Texture'HUDBinocularView_2');

		gc.SetTileColor(colLines);
		gc.SetStyle(DSTY_Masked);
		gc.DrawTexture(fromX,       fromY, 256, scopeHeight, 0, 0, Texture'HUDBinocularCrosshair_1');
		gc.DrawTexture(fromX + 256, fromY, 256, scopeHeight, 0, 0, Texture'HUDBinocularCrosshair_2');
	}
	else
	{
		// Crosshairs - Use new scope in multiplayer, keep the old in single player
		if ( Player.Level.NetMode == NM_Standalone )
		{
			gc.SetStyle(DSTY_Modulated);
			gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HUDScopeView');
			gc.SetTileColor(colLines);
			gc.SetStyle(DSTY_Masked);
			gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HUDScopeCrosshair');
		}
		else
		{
			if ( WeaponRifle(Player.inHand) != None )
			{
				gc.SetStyle(DSTY_Modulated);
				gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HUDScopeView3');
			}
			else
			{
				gc.SetStyle(DSTY_Modulated);
				gc.DrawTexture(fromX, fromY, scopeWidth, scopeHeight, 0, 0, Texture'HUDScopeView2');
			}
		}
	}
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colLines = theme.GetColorFromName('HUDColor_HeaderText');
}

defaultproperties
{
}
