//=============================================================================
// PersonaNotesEditWindow
//=============================================================================
class PersonaNotesEditWindow expands PersonaEditWindow;

var Color colBracket;

var Texture texBordersNormal[9];
var Texture texBordersFocus[9];

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetTextMargins(10, 5);
}

// ----------------------------------------------------------------------
// DrawWindow()
//
// Draws the brackets around the note
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	// Draw the Gamma Scale
	gc.SetTileColor(colBracket);
	gc.SetStyle(DSTY_Masked);

	// Draw background
	gc.DrawBorders(0, 0, width, height, 0, 0, 0, 0, texBordersNormal);
}

// ----------------------------------------------------------------------
// FilterChar()
//
// Backslaces are EVIL and cannot be entered, because of 
// travel export/import issues (we use this backslash to represent
// the return character)
// ----------------------------------------------------------------------

function bool FilterChar(out string chStr)
{
	return (chStr != "\\");
}

// ----------------------------------------------------------------------
// SetNote()
// ----------------------------------------------------------------------

function SetNote( DeusExNote newNote )
{
	SetClientObject(newNote);

	SetText( newNote.text );
}

// ----------------------------------------------------------------------
// GetNote()
// ----------------------------------------------------------------------

function DeusExNote GetNote()
{
	return DeusExNote(GetClientObject());
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	Super.StyleChanged();

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colBracket = theme.GetColorFromName('HUDColor_HeaderText');
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texBordersNormal(0)=Texture'DeusExUI.UserInterface.PersonaNoteNormal_TL'
     texBordersNormal(1)=Texture'DeusExUI.UserInterface.PersonaNoteNormal_TR'
     texBordersNormal(2)=Texture'DeusExUI.UserInterface.PersonaNoteNormal_BL'
     texBordersNormal(3)=Texture'DeusExUI.UserInterface.PersonaNoteNormal_BR'
     texBordersNormal(4)=Texture'DeusExUI.UserInterface.PersonaNoteNormal_Left'
     texBordersNormal(5)=Texture'DeusExUI.UserInterface.PersonaNoteNormal_Right'
     texBordersNormal(6)=Texture'DeusExUI.UserInterface.PersonaNoteNormal_Top'
     texBordersNormal(7)=Texture'DeusExUI.UserInterface.PersonaNoteNormal_Bottom'
     texBordersNormal(8)=Texture'DeusExUI.UserInterface.PersonaNoteNormal_Center'
     texBordersFocus(0)=Texture'DeusExUI.UserInterface.PersonaNoteFocus_TL'
     texBordersFocus(1)=Texture'DeusExUI.UserInterface.PersonaNoteFocus_TR'
     texBordersFocus(2)=Texture'DeusExUI.UserInterface.PersonaNoteFocus_BL'
     texBordersFocus(3)=Texture'DeusExUI.UserInterface.PersonaNoteFocus_BR'
     texBordersFocus(4)=Texture'DeusExUI.UserInterface.PersonaNoteFocus_Left'
     texBordersFocus(5)=Texture'DeusExUI.UserInterface.PersonaNoteFocus_Right'
     texBordersFocus(6)=Texture'DeusExUI.UserInterface.PersonaNoteFocus_Top'
     texBordersFocus(7)=Texture'DeusExUI.UserInterface.PersonaNoteFocus_Bottom'
     texBordersFocus(8)=Texture'DeusExUI.UserInterface.PersonaNoteFocus_Center'
}
