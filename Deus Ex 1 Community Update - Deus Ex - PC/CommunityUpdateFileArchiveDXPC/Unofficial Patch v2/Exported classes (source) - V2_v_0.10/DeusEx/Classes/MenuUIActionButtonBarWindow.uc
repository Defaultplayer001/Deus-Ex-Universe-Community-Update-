//=============================================================================
// MenuUIActionButtonBarWindow
//=============================================================================

class MenuUIActionButtonBarWindow expands Window;

struct S_BarButton
{
	var MenuUIActionButtonWindow btn;
	var EHALIGN align;
};

var S_BarButton actionButtons[5];
var int buttonCount;
var int defaultBarHeight;
var int buttonSpacing;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetHeight(defaultBarHeight);
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
//
// Determine placement of all our pretty buttons
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	local float qWidth, qHeight;
	local int leftX, rightX;
	local int buttonIndex;
	local int btnPos;
	local MenuUIActionButtonWindow btn;

	leftX  = 0;
	rightX = width;

	// Loop through all buttons and try to place them
	for(buttonIndex=0; buttonIndex<buttonCount; buttonIndex++)
	{
		btn = actionButtons[buttonIndex].btn;

 		if (btn != None)
		{
			btn.QueryPreferredSize(qWidth, qHeight);

			switch(actionButtons[buttonIndex].align)
			{
				case HALIGN_Left:
				case HALIGN_Center:
				case HALIGN_Full:
					btnPos = leftX;
					leftX  += buttonSpacing + qWidth;
					break;

				case HALIGN_Right:
					rightX -= qWidth;
					btnPos = rightX;
					rightX -= buttonSpacing;
					break;
			}
			btn.ConfigureChild(btnPos, 1, qWidth, qHeight);
		}			
	}
}


// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

function bool ChildRequestedReconfiguration(window child)
{
	return FALSE;
}

// ----------------------------------------------------------------------
// AddButton()
// ----------------------------------------------------------------------

function MenuUIActionButtonWindow AddButton(string buttonLabel, EHALIGN buttonAlignment)
{
	local MenuUIActionButtonWindow newButton;

	// Add button to our list of buttons, make sure we don't try to add
	// too many buttons
	if (buttonCount == arrayCount(actionButtons))
		return None;	

	actionButtons[buttonCount].align = buttonAlignment;

	newButton = MenuUIActionButtonWindow(NewChild(Class'MenuUIActionButtonWindow'));
	newButton.SetButtonText(buttonLabel);

	actionButtons[buttonCount].btn   = newButton;

	buttonCount++;

	AskParentForReconfigure();
		
	return newButton;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultBarHeight=21
     buttonSpacing=2
}
