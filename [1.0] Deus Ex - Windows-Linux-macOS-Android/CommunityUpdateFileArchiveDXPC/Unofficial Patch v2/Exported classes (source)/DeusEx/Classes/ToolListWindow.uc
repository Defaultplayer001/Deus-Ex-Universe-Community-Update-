//=============================================================================
// ToolListWindow
//=============================================================================

class ToolListWindow expands ListWindow;

// Defaults
var Color colBackground;
var Color colText;
var Color colTextHighlight;
var Color colFocus;
var Color colHighlight;

var Font fontText;


// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetHighlightTextColor(colTextHighlight);
	SetHighlightTexture(Texture'Solid');
	SetHighlightColor(colHighlight);
	SetFocusTexture(Texture'Dithered');
	SetFocusColor(colFocus);
	SetBackgroundStyle(DSTY_Normal);
	SetBackground(Texture'Solid');
	SetTileColor(colBackground);
	SetColumnColor(0, colText);
	SetColumnFont(0, fontText);
}

// ----------------------------------------------------------------------
// SetColumns()
// ----------------------------------------------------------------------

function SetColumns(int newColumnCount)
{
	local int colIndex;

	SetNumColumns(newColumnCount);

	for (colIndex=0; colIndex<newColumnCount; colIndex++)
	{
		SetColumnColor(colIndex, colText);
		SetColumnFont(colIndex, fontText);
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colBackground=(R=255,G=255,B=255)
     colTextHighlight=(R=255,G=255,B=255)
     colHighlight=(B=128)
     fontText=Font'DeusExUI.FontSansSerif_8'
}
