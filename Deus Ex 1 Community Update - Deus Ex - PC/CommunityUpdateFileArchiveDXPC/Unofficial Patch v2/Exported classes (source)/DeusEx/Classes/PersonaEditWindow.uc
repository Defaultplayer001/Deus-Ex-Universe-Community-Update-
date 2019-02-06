//=============================================================================
// PersonaEditWindow
//=============================================================================

class PersonaEditWindow extends EditWindow;

var DeusExPlayer player;

var Color colText;
var Color colHighlight;
var Color colCursor;
var Color colBlack;

var Font  fontText;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
	
	SetFont(fontText);
	SetInsertionPointType(INSTYPE_Insert);
	EnableSingleLineEditing(False);

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	StyleChanged();
}

// ----------------------------------------------------------------------
// VirtualKeyPressed() 
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bIgnoreKey;

	if (Super.VirtualKeyPressed(key, bRepeat))
		return True;

	// Return true except for keys we want to be processed 
	// externally, like Escape an Tab

	switch(key)
	{
		case IK_Tab:
		case IK_Escape:
			bIgnoreKey = False;
			break;
		
		default:
			bIgnoreKey = True;
			break;
	}

	return bIgnoreKey;
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	// Title colors
	colText          = theme.GetColorFromName('HUDColor_ListText');
	colHighlight     = theme.GetColorFromName('HUDColor_ListHighlight');
	colCursor        = theme.GetColorFromName('HUDColor_Cursor');

	SetTextColor(colText);
	SetTileColor(colHighlight);
	SetSelectedAreaTexture(Texture'Solid', colText);
	SetSelectedAreaTextColor(colBlack);
	SetEditCursor(Texture'DeusExEditCursor', Texture'DeusExEditCursor_Shadow', colCursor);
	SetInsertionPointTexture(Texture'Solid', colCursor);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     fontText=Font'DeusExUI.FontMenuSmall'
}
