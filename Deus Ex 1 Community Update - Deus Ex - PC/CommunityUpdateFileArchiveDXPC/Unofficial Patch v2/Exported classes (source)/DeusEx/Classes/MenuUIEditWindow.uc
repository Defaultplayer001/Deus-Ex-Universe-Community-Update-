//=============================================================================
// MenuUIEditWindow
//=============================================================================

class MenuUIEditWindow extends EditWindow;

var DeusExPlayer player;

var Color colText;
var Color colHighlight;
var Color colCursor;
var Color colBlack;

var Font  fontText;
var Int   maxHeight;

// Optional filter string
var String filterString;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
	
	SetFont(fontText);
	SetHeight(maxHeight);
	SetInsertionPointType(INSTYPE_Insert);
	EnableSingleLineEditing(True);

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	StyleChanged();
}

// ----------------------------------------------------------------------
// FilterChar()
//
// Prevent the user from typing illegal characters
// ----------------------------------------------------------------------

function bool FilterChar(out string chStr)
{
	local int filterIndex;
	local bool bResult;

	if (filterString == "")
	{
		bResult = True;
	}
	else
	{
		bResult = False;

		for(filterIndex=0; filterIndex < Len(filterString); filterIndex++)
		{
			if ( Mid(filterString, filterIndex, 1) == chStr )
			{
				bResult = True;
				break;
			}
		}
	}

	return bResult;
}

// ----------------------------------------------------------------------
// SetFilter()
// ----------------------------------------------------------------------

function SetFilter(String newFilterString)
{
	filterString = newFilterString;
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	// Title colors
	colText          = theme.GetColorFromName('MenuColor_ListText');
	colHighlight     = theme.GetColorFromName('MenuColor_ListHighlight');
	colCursor        = theme.GetColorFromName('MenuColor_Cursor');

	SetTextColor(colText);
	SetTileColor(colHighlight);
	SetSelectedAreaTexture(Texture'Solid', coltext);
	SetSelectedAreaTextColor(colBlack);
	SetEditCursor(Texture'DeusExEditCursor', Texture'DeusExEditCursor_Shadow', colCursor);
	SetInsertionPointTexture(Texture'Solid', colCursor);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     fontText=Font'DeusExUI.FontMenuSmall'
     maxHeight=11
}
