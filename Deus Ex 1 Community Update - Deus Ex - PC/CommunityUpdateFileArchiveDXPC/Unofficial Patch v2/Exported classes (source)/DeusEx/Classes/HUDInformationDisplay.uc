//=============================================================================
// HUDInformationDisplay
//
// Used to display information text in a window
//=============================================================================

class HUDInformationDisplay expands HUDSharedBorderWindow;

// ----------------------------------------------------------------------
// Local Variables
// ----------------------------------------------------------------------

// Tile window containing all the child TextWindows
var TileWindow winTile;
var Color colInfoText;
var Font fontInfo;

var Texture texBackgrounds[9];
var Texture texBorders[9];

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Create the tile window that will contain all the text windows
	winTile = TileWindow(NewChild(Class'TileWindow'));
	winTile.SetOrder( ORDER_Down );
	winTile.SetChildAlignments( HALIGN_Full, VALIGN_Top );
	winTile.SetMargins(20, 0);
	winTile.SetMinorSpacing(0);
	winTile.MakeWidthsEqual(True);
	winTile.MakeHeightsEqual(False);
}

// ----------------------------------------------------------------------
// ParentRequestedPreferredSize()
// ----------------------------------------------------------------------

event ParentRequestedPreferredSize(bool bWidthSpecified, out float preferredWidth,
                                   bool bHeightSpecified, out float preferredHeight)
{
	local float tileWidth, tileHeight;

	if (winTile.IsVisible())
	{
		if ((!bWidthSpecified) && (!bHeightSpecified))
		{
			winTile.QueryPreferredSize(preferredWidth, preferredHeight);

			preferredHeight += topMargin + bottomMargin;
	
			if (preferredHeight < minHeight)
				preferredHeight = minHeight;
		}
		else if (bWidthSpecified)
		{
			preferredHeight = winTile.QueryPreferredHeight(preferredWidth);
			preferredHeight += topMargin + bottomMargin;
	
			if (preferredHeight < minHeight)
				preferredHeight = minHeight;
		}
		else
		{
			preferredWidth = winTile.QueryPreferredWidth(preferredHeight + topMargin + bottomMargin);
		}
	}
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	winTile.ConfigureChild(0, topMargin, width, height);
}

// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

event bool ChildRequestedReconfiguration(window childWin)
{
	return False;
}

// ----------------------------------------------------------------------
// AddTextWindow()
//
// Adds a text window
// ----------------------------------------------------------------------

function TextWindow AddTextWindow()
{
	local TextWindow winText;

	// Create the Text window containing the message text
	winText = TextWindow(winTile.NewChild(Class'TextWindow'));
	winText.SetFont(fontInfo);
	winText.SetTextColor(colInfoText);
	winText.SetWordWrap(True);
	winText.SetTextAlignments(HALIGN_Left, VALIGN_Top);	
	winText.SetTextMargins(0, 0);

	AskParentForReconfigure();

	return winText;
}

// ----------------------------------------------------------------------
// ClearTextWindows()
//
// Removes all the text window
// ----------------------------------------------------------------------

function ClearTextWindows()
{
	winTile.DestroyAllChildren();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colInfoText=(R=250,G=250,B=250)
     fontInfo=Font'DeusExUI.FontMenuSmall_DS'
}
