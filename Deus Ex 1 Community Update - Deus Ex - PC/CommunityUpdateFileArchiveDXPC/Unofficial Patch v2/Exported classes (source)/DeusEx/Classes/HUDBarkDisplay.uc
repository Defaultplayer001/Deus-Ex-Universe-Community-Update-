//=============================================================================
// HUDBarkDisplay
//=============================================================================
class HUDBarkDisplay expands HUDSharedBorderWindow;

var TileWindow winBarks;					
var Int barkCount;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Create text window where we'll display the conversation
	winBarks = TileWindow(NewChild(Class'TileWindow'));
	winBarks.SetOrder(ORDER_Down);
	winBarks.SetChildAlignments(HALIGN_Full, VALIGN_Top);
	winBarks.MakeWidthsEqual(True);
	winBarks.MakeHeightsEqual(False);
	winBarks.SetMargins(20, topMargin);
	winBarks.SetMinorSpacing(2);
	winBarks.SetWindowAlignments(HALIGN_Full, VALIGN_Top);
}

// ----------------------------------------------------------------------
// ParentRequestedPreferredSize() 
// ----------------------------------------------------------------------

event ParentRequestedPreferredSize(bool bWidthSpecified, out float preferredWidth,
                                   bool bHeightSpecified, out float preferredHeight)
{
	local float tileWidth, tileHeight;

	if ((!bWidthSpecified) && (!bHeightSpecified))
	{
		winBarks.QueryPreferredSize(preferredWidth, preferredHeight);

		if (preferredHeight < minHeight)
			preferredHeight = minHeight;
	}
	else if (bWidthSpecified)
	{
		preferredHeight = winBarks.QueryPreferredHeight(preferredWidth);

		if (preferredHeight < minHeight)
			preferredHeight = minHeight;
	}
	else
	{
		preferredWidth = winBarks.QueryPreferredWidth(preferredHeight);
	}
}

// ----------------------------------------------------------------------
// AddBark()
// ----------------------------------------------------------------------

function AddBark(string text, float newDisplayTime, Actor speakingActor)
{
	local HUDBarkDisplayItem newBark;

	if (TrimSpaces(text) != "")
	{
		newBark = HUDBarkDisplayItem(winBarks.NewChild(Class'HUDBarkDisplayItem'));
		newBark.SetBarkSpeech(text, newDisplayTime, speakingActor);

		barkCount++;

		Show();

		AskParentForReconfigure();
	}
}

// ----------------------------------------------------------------------
// DescendantRemoved()
// ----------------------------------------------------------------------

event DescendantRemoved(Window descendant)
{
	if (descendant.IsA('HUDBarkDisplayItem'))
	{
		if (--barkCount == 0)
			Hide();

		AskParentForReconfigure();
	}
}

// ----------------------------------------------------------------------
// TrimSpaces()
// ----------------------------------------------------------------------

function String TrimSpaces(String trimString)
{
	local int trimIndex;
	local int trimLength;

	if ( trimString == "" ) 
		return trimString;

	trimIndex = Len(trimString) - 1;
	while ((trimIndex >= 0) && (Mid(trimString, trimIndex, 1) == " ") )
		trimIndex--;

	if ( trimIndex < 0 )
		return "";

	trimString = Mid(trimString, 0, trimIndex + 1);

	trimIndex = 0;
	while((trimIndex < Len(trimString) - 1) && (Mid(trimString, trimIndex, 1) == " "))
		trimIndex++;

	trimLength = len(trimString) - trimIndex;
	trimString = Right(trimString, trimLength);

	return trimString;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
