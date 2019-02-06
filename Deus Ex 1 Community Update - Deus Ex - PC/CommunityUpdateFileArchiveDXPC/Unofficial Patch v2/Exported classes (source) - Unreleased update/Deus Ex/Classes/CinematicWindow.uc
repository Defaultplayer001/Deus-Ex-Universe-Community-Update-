//=============================================================================
// CinematicWindow.
//=============================================================================
class CinematicWindow extends Window;

function InitWindow()
{
	Super.InitWindow();

	SetWindowAlignments(HALIGN_Full, VALIGN_Full);
}

function DestroyWindow()
{
	ResetRootViewport();

	Super.DestroyWindow();
}

function ConfigurationChanged()
{
	SetRootViewport();
}

event VisibilityChanged(bool bNewVisibility)
{
	Super.VisibilityChanged( bNewVisibility );

	if (bNewVisibility)
		SetRootViewport();
	else
		ResetRootViewport();
}

function SetRootViewport()
{
	local RootWindow root;
	local float      cinWidth, cinHeight;
	local float      cinX,     cinY;
	local float ratio;

	root      = GetRootWindow();

	// calculate the correct 16:9 ratio
	ratio = 0.5625 * (root.width / root.height);

	cinWidth  = root.width;
	cinHeight = root.height * ratio;
	cinX      = 0;
	cinY      = int(0.5 * (root.height - cinHeight));

	// make sure we don't invert the letterbox if the screen size is strange
	if (cinY < 0)
		root.ResetRenderViewport();
	else
		root.SetRenderViewport(cinX, cinY, cinWidth, cinHeight);
}

function ResetRootViewport()
{
	local RootWindow root;

	root = GetRootWindow();
	root.ResetRenderViewport();
}

defaultproperties
{
}
