//=============================================================================
// PersonaImageNoteWindow
//=============================================================================
class PersonaImageNoteWindow expands PersonaEditWindow;

var Color colEditTextNormal;
var Color colEditTextFocus;
var Color colEditTextHighlight;
var Color colEditHighlight;
var Color colBackground;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetTextMargins(2, 2);
	SetMaxSize(200);				// maybe increase this later, probably not.
	SetNormalColors();
	SetSelectedAreaTexture(Texture'Solid', colEditHighlight);
	SetSelectedAreaTextColor(colEditTextHighlight);

	SetBackgroundStyle(DSTY_Modulated);
	SetTileColor(colBackground);
	SetBackground(Texture'NoteEditBackground');
}

// ----------------------------------------------------------------------
// SetFocusColors()
// ----------------------------------------------------------------------

function SetFocusColors()
{
	SetTextColor(colEditTextFocus);
}

// ----------------------------------------------------------------------
// SetNormalColors()
// ----------------------------------------------------------------------

function SetNormalColors()
{
	SetTextColor(colEditTextNormal);
}

// ----------------------------------------------------------------------
// SetNote()
// ----------------------------------------------------------------------

function SetNote(DataVaultImageNote newNote)
{
	SetPos(newNote.posX, newNote.posY);
	SetText(newNote.noteText);
	SetClientObject(newNote);
}

// ----------------------------------------------------------------------
// GetNote()
// ----------------------------------------------------------------------

function DataVaultImageNote GetNote()
{
	return DataVaultImageNote(GetClientObject());
}

// ----------------------------------------------------------------------
// SetTextColors()
// ----------------------------------------------------------------------

function SetTextColors(Color colTextNormal, Color colTextFocus, Color colBack)
{
	colEditTextNormal    = colTextNormal;
	colEditTextFocus     = colTextFocus;
	colEditTextHighlight = colBack;
	colEditHighlight     = colTextFocus;
	colBackground        = colBack;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colEditTextNormal=(G=200,B=200)
     colEditTextFocus=(R=255,G=255,B=255)
     colEditHighlight=(R=255,G=255,B=255)
     colBackground=(R=32,G=32,B=32)
}
