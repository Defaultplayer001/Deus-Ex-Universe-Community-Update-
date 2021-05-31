//=============================================================================
// PersonaButtonBarWindow
//=============================================================================

class PersonaButtonBarWindow expands PersonaBaseWindow;

var int defaultBarHeight;
var int buttonSpacing;
var Window winFiller;
var bool bFillAllSpace;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetHeight(defaultBarHeight);

	CreateFillerWindow();
	StyleChanged();
}

// ----------------------------------------------------------------------
// CreateFillerWindow()
// ----------------------------------------------------------------------

function CreateFillerWindow()
{
	winFiller = NewChild(Class'Window');
	winFiller.SetBackground(Texture'PersonaButtonFiller');
}

// ----------------------------------------------------------------------
// FillAllSpace()
// ----------------------------------------------------------------------

function FillAllSpace(bool bFill)
{
	bFillAllSpace = bFill;
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
//
// Determine placement of all our pretty buttons
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	local float qWidth, qHeight;
	local int leftX;
	local int numButtons;
	local int remainingSpace;
	local int buttonPadding;
	local Window winPlace;

	leftX      = 0;
	numButtons = 0;

	// Loop through all buttons and try to place them
	winPlace = GetTopChild();
	while(winPlace != None)
	{
		if (winPlace.IsA('ButtonWindow'))
		{
			winPlace.QueryPreferredSize(qWidth, qHeight);

			if (!bFillAllSpace)
				winPlace.ConfigureChild(leftX, 0, qWidth, qHeight);

			numButtons++;

			leftX += qWidth;
		}

		winPlace = winPlace.GetLowerSibling();

		if ((winPlace != None) && (winPlace.IsA('ButtonWindow')))
			leftX += buttonSpacing;
	}

	// Now, if we need to make all the buttons an equal width
	if (bFillAllSpace)
	{
		remainingSpace = width - leftX;

		// Loop through the buttons again, adding "remaining space / #buttons" 
		// width to each button

		leftX = 0;

		winPlace = GetTopChild();
		while(winPlace != None)
		{
			if (winPlace.IsA('ButtonWindow'))
			{
				winPlace.QueryPreferredSize(qWidth, qHeight);

				buttonPadding = (remainingSpace / numButtons);
				qWidth += buttonPadding;

				winPlace.ConfigureChild(leftX, 0, qWidth, qHeight);

				leftX += qWidth;
			}

			winPlace = winPlace.GetLowerSibling();

			if ((winPlace != None) && (winPlace.IsA('ButtonWindow')))
				leftX += buttonSpacing;
		}
	}

	// Now calculate the position of the filler window
	winFiller.ConfigureChild(leftX, 0, width - leftX, height);
}

// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

function bool ChildRequestedReconfiguration(window child)
{
	return FALSE;
}

// ----------------------------------------------------------------------
// DescendantAdded()
// ----------------------------------------------------------------------

event DescendantAdded(Window descendant)
{
	AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	Super.StyleChanged();

	if (winFiller != None)
	{
		winFiller.SetTileColor(colBackground);
		winFiller.SetBackgroundStyle(backgroundDrawStyle);
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultBarHeight=16
     bFillAllSpace=True
}
