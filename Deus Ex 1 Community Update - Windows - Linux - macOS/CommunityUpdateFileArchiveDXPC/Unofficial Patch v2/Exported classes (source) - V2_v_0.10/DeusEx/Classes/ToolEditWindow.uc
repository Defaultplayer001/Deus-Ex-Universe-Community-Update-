//=============================================================================
// ToolEditWindow
//=============================================================================

class ToolEditWindow expands EditWindow;

// Default values
var Color colBackgroundSensitive;
var Color colBackgroundInsensitive;
var Color colText;
var Color colTextSelected;
var Color colInsert;
var Color colHighlight;
var Texture textureInsert;
var Font  fontText;

// Optional filter used to prevent certain characters from being typed
var String filterString;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetBackground(Texture'Solid');
	SetTileColor(colBackgroundSensitive);

	SetFont(fontText);
	SetTextColor(colText);
	SetInsertionPointType(INSTYPE_Insert);
	EnableSingleLineEditing(True);
	SetInsertionPointTexture(textureInsert, colInsert);
	SetSelectedAreaTexture(Texture'Solid', colHighlight);
	SetSelectedAreaTextColor(colTextSelected);
	SetEditCursor(Texture'ToolMouseInsertCursor');
	SetTextAlignments(HALIGN_Left, VALIGN_Center);
}

// ----------------------------------------------------------------------
// FilterChar()
//
// Prevent the user from typing illegal filename characters
// ----------------------------------------------------------------------

function bool FilterChar(out string chStr)
{
	local int filterIndex;
	local bool bResult;

	bResult = True;

	for(filterIndex=0; filterIndex < Len(filterString); filterIndex++)
	{
		if ( Mid(filterString, filterIndex, 1) == chStr )
		{
			bResult = False;
			break;
		}
	}

	return bResult;
}

// ----------------------------------------------------------------------
// SensitivityChanged() : Called when this window becomes sensitive or
//                        insensitive
// ----------------------------------------------------------------------

event SensitivityChanged(bool bNewSensitivity)
{
	if (bNewSensitivity)
		SetTileColor(colBackgroundSensitive);
	else
		SetTileColor(colBackgroundInsensitive);
}

// ----------------------------------------------------------------------
// SetFilter()
// ----------------------------------------------------------------------

function SetFilter(String newFilter)
{
	filterString = newFilter;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colBackgroundSensitive=(R=255,G=255,B=255)
     colBackgroundInsensitive=(R=192,G=192,B=192)
     colTextSelected=(R=255,G=255,B=255)
     colHighlight=(B=128)
     textureInsert=Texture'DeusExUI.UserInterface.ToolInsertCursor'
     fontText=Font'DeusExUI.FontSansSerif_8'
}
