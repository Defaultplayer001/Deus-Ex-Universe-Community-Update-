//=============================================================================
// MenuUILoadSaveEditWindow
//=============================================================================

class MenuUILoadSaveEditWindow extends MenuUIEditWindow;

var Texture texBackground;
var Color   colWhite;

var bool    bReadOnly;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetBackground(texBackground);
	SetBackgroundStyle(DSTY_Normal);
}

// ----------------------------------------------------------------------
// FilterChar()
//
// Do not allow the semicolon, as this is used as a column
// delimiter in the listbox!!
// ----------------------------------------------------------------------

function bool FilterChar(out string chStr)
{
	return ((chStr != ";") || (!bReadOnly));
}

// ----------------------------------------------------------------------
// SetReadOnly()
// ----------------------------------------------------------------------

function SetReadOnly(bool bNewReadOnly)
{
	bReadOnly = bNewReadOnly;
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local int keyIndex;
	local bool bKeyHandled;

	bKeyHandled = True;

	// If the user hits the up or down arrow keys or the Page Up/Down 
	// keys, we want to pass them back to the parent window so the 
	// user can easily scroll between savegames.

	if ((key == IK_Up) || (key == IK_Down) || (key == IK_PageUp) || (key == IK_PageDown))
		return False;
	else
		return Super.VirtualKeyPressed(key, bRepeat);
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	Super.StyleChanged();

	SetTextColor(colWhite);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texBackground=Texture'Extension.Solid'
     colWhite=(R=255,G=255,B=255)
}
