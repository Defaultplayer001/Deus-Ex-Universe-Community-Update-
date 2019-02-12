//=============================================================================
// MenuUIListWindow
//=============================================================================

class MenuUIListWindow extends ListWindow;

var DeusExPlayer player;

var Color   colText;
var Color	colTextHighlight;
var Color	colHighlight;
var Color	colFocus;
var Texture texHighlight;
var Texture texFocus;
var Font    fontText;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetFont(fontText);

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	StyleChanged();

	SetListSounds(Sound'Menu_Press', Sound'Menu_Focus');
	SetSoundVolume(0.25);

	SetNumColumns(0);
	SetNumColumns(1);
}

// ----------------------------------------------------------------------
// VirtualKeyPressed() 
//
// Eat the space so we don't get the god damned listbox toggling 
// itself on/off when an EditWindow is overlaid on top of a 
// listbox (like in the MenuUISaveWindow).
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool retval;

	retval = False;

	// Handle keys
	switch (key)
	{
		case IK_Space:  // toggle selection
			retval = true;
			break;
	}

	if (!retval)
		retval = Super.VirtualKeyPressed(key, bRepeat);

	// Return TRUE if we handled this
	return (retval);
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;
	local Int colIndex;

	// Background color
	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	colText          = theme.GetColorFromName('MenuColor_ListText');
	colTextHighlight = theme.GetColorFromName('MenuColor_ListTextHighlight');
	colHighlight     = theme.GetColorFromName('MenuColor_ListHighlight');
	colFocus         = theme.GetColorFromName('MenuColor_ListFocus');

	SetTextColor(colText);
	SetHighlightTextColor(colTextHighlight);
	SetHighlightTexture(texHighlight);
	SetHighlightColor(colHighlight);
	SetFocusTexture(texFocus);
	SetFocusColor(colFocus);

	// Loop through columns, setting text color
	for (colIndex=0; colIndex<GetNumColumns(); colIndex++)
		SetColumnColor(colIndex, colText);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colText=(R=255,G=255,B=255)
     colTextHighlight=(R=255,G=255,B=255)
     colHighlight=(R=128,G=128,B=128)
     colFocus=(R=64,G=64,B=64)
     texHighlight=Texture'Extension.Solid'
     texFocus=Texture'Extension.Solid'
     fontText=Font'DeusExUI.FontMenuSmall'
}
