//=============================================================================
// DeusExScrollAreaWindow
//=============================================================================
class DeusExScrollAreaWindow expands ScrollAreaWindow;

var Color colScrollBars;
var Color colScale;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetAreaMargins(0, 0);
	SetScrollbarDistance(0);

	vScale.SetThumbCaps(Texture'ToolWindowVScrollThumb_Top', Texture'ToolWindowVScrollThumb_Bottom', 16, 2, 16, 2);
	vScale.SetThumbTexture(Texture'ToolWindowVScrollThumb_Center', 16, 2);
	vScale.SetScaleTexture(Texture'ToolWindowVScrollScale', 16, 16);
	vScale.SetScaleMargins(0, 0);
	vScale.SetScaleColor(colScale);
	vScale.SetThumbColor(colScrollBars);
	vScale.SetScaleStyle(DSTY_Normal);
	vScale.SetThumbStyle(DSTY_Normal);
	vScale.SetThumbStep(10);

	hScale.SetThumbCaps(Texture'ToolWindowHScrollThumb_Left', Texture'ToolWindowHScrollThumb_Right', 2, 16, 2, 16);
	hScale.SetThumbTexture(Texture'ToolWindowHScrollThumb_Center', 2, 16);
	hScale.SetScaleTexture(Texture'ToolWindowHScrollScale', 16, 16);
	hScale.SetScaleMargins(0, 0);
	hScale.SetScaleColor(colScale);
	hScale.SetThumbColor(colScrollBars);
	hScale.SetScaleStyle(DSTY_Normal);
	hScale.SetThumbStyle(DSTY_Normal);
	hScale.SetThumbStep(10);

	upButton.SetSize(16, 16);
	upButton.SetBackgroundStyle(DSTY_Normal);
	upButton.SetButtonColors(colScrollBars, colScrollBars, colScrollBars, colScrollBars, colScrollBars, colScrollBars);
	upButton.SetButtonTextures(
		Texture'ToolWindowScrollUpButton_Normal', Texture'ToolWindowScrollUpButton_Pressed',
		Texture'ToolWindowScrollUpButton_Normal', Texture'ToolWindowScrollUpButton_Pressed',
		Texture'ToolWindowScrollUpButton_Normal', Texture'ToolWindowScrollUpButton_Pressed');

	downButton.SetSize(16, 16);
	downButton.SetBackgroundStyle(DSTY_Normal);
	downButton.SetButtonColors(colScrollBars, colScrollBars, colScrollBars, colScrollBars, colScrollBars, colScrollBars);
	downButton.SetButtonTextures(
		Texture'ToolWindowScrollDownButton_Normal', Texture'ToolWindowScrollDownButton_Pressed',
		Texture'ToolWindowScrollDownButton_Normal', Texture'ToolWindowScrollDownButton_Pressed',
		Texture'ToolWindowScrollDownButton_Normal', Texture'ToolWindowScrollDownButton_Pressed');

	leftButton.SetSize(16, 16);
	leftButton.SetBackgroundStyle(DSTY_Normal);
	leftButton.SetButtonColors(colScrollBars, colScrollBars, colScrollBars, colScrollBars, colScrollBars, colScrollBars);
	leftButton.SetButtonTextures(
		Texture'ToolWindowScrollLeftButton_Normal', Texture'ToolWindowScrollLeftButton_Pressed',
		Texture'ToolWindowScrollLeftButton_Normal', Texture'ToolWindowScrollLeftButton_Pressed',
		Texture'ToolWindowScrollLeftButton_Normal', Texture'ToolWindowScrollLeftButton_Pressed');

	rightButton.SetSize(16, 16);
	rightButton.SetBackgroundStyle(DSTY_Normal);
	rightButton.SetButtonColors(colScrollBars, colScrollBars, colScrollBars, colScrollBars, colScrollBars, colScrollBars);
	rightButton.SetButtonTextures(
		Texture'ToolWindowScrollRightButton_Normal', Texture'ToolWindowScrollRightButton_Pressed',
		Texture'ToolWindowScrollRightButton_Normal', Texture'ToolWindowScrollRightButton_Pressed',
		Texture'ToolWindowScrollRightButton_Normal', Texture'ToolWindowScrollRightButton_Pressed');
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colScrollBars=(G=240,B=240)
     colScale=(G=180,B=180)
}
