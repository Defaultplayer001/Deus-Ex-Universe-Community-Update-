//=============================================================================
// ToolWindow
//=============================================================================

class ToolWindow extends DeusExBaseWindow;

var Window winContainer;
var ToolTitleBarWindow winTitleBar;

var Bool	bWindowBeingDragged;
var Bool	bTitleBarVisible;
var Bool	bAllowWindowDragging;
var float	windowStartDragX;
var float	windowStartDragY;

// Defaults
var Color colBackgroundColor;
var Color colText;
var Font fontText;
var Texture textureMouse;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	bWindowBeingDragged  = False;
	bAllowWindowDragging = False;
			
	// Center this window	
	SetBackground(Texture'Solid');
	SetTileColor(colBackgroundColor);
	SetBackgroundStyle(DSTY_Normal);
	SetWindowAlignments(HALIGN_Center, VALIGN_Center);
	SetMouseFocusMode(MFOCUS_Click);
	bSizeChildrenToParent = False;

	// Create BorderWindow
	winContainer = CreateToolWindowContainer(Self);

	// Only want to respond to a max. of two mouse clicks
	maxClicks = 2;

	// Create the Title Bar
	winTitleBar = ToolTitleBarWindow(winContainer.NewChild(Class'ToolTitleBarWindow'));

	// Set a Windows-style Cursor
	SetDefaultCursor(textureMouse, None, 0, 0);
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	bHandled   = True;

	switch( buttonPressed )
	{
		case winTitleBar.btnClose:
			root.PopWindow();
			break;

		default:
			bHandled = False;
			break;
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// MouseMoved()
//
// If we're dragging the window around, move
// ----------------------------------------------------------------------

event MouseMoved(float newX, float newY)
{
	if ( bWindowBeingDragged )
		SetPos( x + (newX - windowStartDragX), y + (newY - windowStartDragY) );
}

// ----------------------------------------------------------------------
// MouseButtonPressed() 
//
// If the user presses the mouse button while over the title bar,
// initiate window dragging.
// ----------------------------------------------------------------------

event bool MouseButtonPressed(float pointX, float pointY, EInputKey button,
                              int numClicks)
{
	local float relativeX;
	local float relativeY;

//	if ( ( button == IK_LeftMouse ) && ( numClicks == 1 ) && ( FindWindow(pointX, pointY, relativeX, relativeY) == winTitleBar ) )
	if ( ( button == IK_LeftMouse ) && ( numClicks == 1 ) && 
		( ( FindWindow(pointX, pointY, relativeX, relativeY) == winTitleBar ) || ( bAllowWindowDragging )))
	{
		bWindowBeingDragged = True;
		windowStartDragX = pointX;
		windowStartDragY = pointY;

		GrabMouse();
	}
	else
	{
		bWindowBeingDragged = False;
	}

	return bWindowBeingDragged;  
}

// ----------------------------------------------------------------------
// MouseButtonReleased() 
//
// First check to see if we're dragging the window.  If so, then
// end the drag event.
// 
// Otherwise, check to see if the user double-clicked on the app icon to 
// close the window
// ----------------------------------------------------------------------

event bool MouseButtonReleased(float pointX, float pointY, EInputKey button,
                               int numClicks)
{
	local float relativeX;
	local float relativeY;

	if ( ( button == IK_LeftMouse ) )
	{
		if ( bWindowBeingDragged )
		{
			bWindowBeingDragged = False;			
		}
		else
		{
			if ( ( numClicks == 2 ) && ( FindWindow(pointX, pointY, relativeX, relativeY) == winTitleBar.btnAppIcon ) )
			{
				root.PopWindow();
			}
		}
	}

	return True;
}

// ----------------------------------------------------------------------
// CreateToolWindowContainer()
// ----------------------------------------------------------------------

function Window CreateToolWindowContainer( Window winParent )
{
	local BorderWindow winBorder;
	local Window winContainer;

	winBorder = BorderWindow(winParent.NewChild(Class'BorderWindow'));
	winBorder.SetWindowAlignments(HALIGN_Full, VALIGN_Full);

	// Assign border textures
	winBorder.SetBorders(Texture'ToolWindowBorder_TL', Texture'ToolWindowBorder_TR', 
					     Texture'ToolWindowBorder_BL', Texture'ToolWindowBorder_BR',
					     Texture'ToolWindowBorder_L',  Texture'ToolWindowBorder_R',
					     Texture'ToolWindowBorder_T',  Texture'ToolWindowBorder_B');
//						 Texture'ToolWindowBorder_Center');

	winBorder.SetTileColor(colWhite);
	winBorder.SetBorderStyle(DSTY_Normal);
	winBorder.BaseMarginsFromBorder(True);

	winContainer = winBorder.NewChild(Class'Window');

	return winContainer;
}

// ----------------------------------------------------------------------
// CreateToolBorderContainer()
//
// Creates a border container
// ----------------------------------------------------------------------

function Window CreateToolBorderContainer( int posX, int posY, int sizeX, int sizeY, Window winParent )
{
	local ToolBorderWindow winBorder;
	local Window winContainer;

	winBorder = ToolBorderWindow(winParent.NewChild(Class'ToolBorderWindow'));
	winBorder.SetPos( posX, posY );
	winBorder.SetSize( sizeX, sizeY );

	winContainer = winBorder.NewChild(Class'Window');

	return winContainer;
}

// ======================================================================
// Public Functions
// ======================================================================

// ----------------------------------------------------------------------
// SetTitle()
//
// Sets the title bar text
// ----------------------------------------------------------------------

function SetTitle(String newTitleText)
{
	winTitleBar.SetTitleBarText(newTitleText);
}

// ----------------------------------------------------------------------
// SetAppIcon()
// ----------------------------------------------------------------------

function SetAppIcon(Texture newAppIcon)
{
	winTitleBar.SetAppIcon(newAppIcon);
}

// ----------------------------------------------------------------------
// SetTitleBarVisibility()
// ----------------------------------------------------------------------

function SetTitleBarVisibility(Bool bNewVisibility)
{
	bTitleBarVisible = bNewVisibility;
	winTitleBar.Show(bTitleBarVisible);
}

// ----------------------------------------------------------------------
// SetWindowDragging()
//
// If true, the window can be dragged by clicking anywhere outside 
// a control, but on the window.
// ----------------------------------------------------------------------

function SetWindowDragging(Bool bNewDragging)
{
	bAllowWindowDragging = bNewDragging;
}

// ----------------------------------------------------------------------
// CreateToolButton()
// ----------------------------------------------------------------------

function ToolButtonWindow CreateToolButton( int posX, int posY, String caption, optional Window winParent)
{
	local ToolButtonWindow newButton;

	if ( winParent == None )
		newButton = ToolButtonWindow(winContainer.NewChild(Class'ToolButtonWindow'));
	else
		newButton = ToolButtonWindow(winParent.NewChild(Class'ToolButtonWindow'));

	newButton.SetPos(posX, posY);
	newButton.SetButtonText(caption);

	return newButton;
}

// ----------------------------------------------------------------------
// CreateToolList()
// ----------------------------------------------------------------------

function ToolListWindow CreateToolList(int posX, int posY, int width, int height)
{
	local ToolListWindow newList;
	local Window winListContainer;
	local ToolScrollAreaWindow winScroll;
	local int colIndex;

	// First, create our border window
	winListContainer = CreateToolBorderContainer(posX, posY, width, height, winContainer);

	// First, create the scrolling region
	winScroll = ToolScrollAreaWindow(winListContainer.NewChild(Class'ToolScrollAreaWindow'));
	winScroll.SetSize(width - 4, height - 4);
	winScroll.ClipWindow.SetBackground(Texture'Solid');
	winScroll.ClipWindow.SetTileColorRGB(255, 255, 255);

	// Now create the List Window
	newList = ToolListWindow(winScroll.clipWindow.NewChild(Class'ToolListWindow'));

	return newList;
}

// ----------------------------------------------------------------------
// CreateToolEditWindow
// ----------------------------------------------------------------------

function ToolEditWindow CreateToolEditWindow(int posX, int posY, int width, int maxChars, optional int height)
{
	local ToolEditWindow newEdit;
	local Window winEditContainer;
	local ClipWindow editClip;

	if (height == 0)
		height = 20;

	// First, create our border window
	winEditContainer = CreateToolBorderContainer(posX, posY, width, height, winContainer);
	winEditContainer.SetTileColorRGB(255, 255, 255);
	
	// Now create our clip window
	editClip = ClipWindow(winEditContainer.NewChild(Class'ClipWindow'));
	editClip.ForceChildSize(False, True);

	// Scott said he should have explained this better
	editClip.SetWindowAlignments(HALIGN_Full, VALIGN_Full);

	// Finally, create the edit window
	newEdit = ToolEditWindow(editClip.NewChild(Class'ToolEditWindow'));
	newEdit.SetMaxSize(maxChars);

	return newEdit;
}

// ----------------------------------------------------------------------
// CreateToolLabel()
// ----------------------------------------------------------------------

function TextWindow CreateToolLabel(int posX, int posY, String strLabel, optional Window winParent)
{
	local TextWindow newText;

	if ( winParent == None )
		newText = TextWindow(winContainer.NewChild(Class'TextWindow'));
	else
		newText = TextWindow(winParent.NewChild(Class'TextWindow'));

	newText.SetPos(posX, posY);
	newText.SetFont(fontText);
	newText.SetTextColor(colText);
	newText.SetTextMargins(0, 0);
	newText.SetText(strLabel);

	return newText;
}

// ----------------------------------------------------------------------
// CreateToolCheckbox()
// ----------------------------------------------------------------------

function ToolCheckboxWindow CreateToolCheckbox(int posX, int posY, String label, bool bDefaultValue)
{
	local ToolCheckboxWindow newCheckbox;

	newCheckbox = ToolCheckboxWindow(winContainer.NewChild(Class'ToolCheckboxWindow'));
	newCheckbox.SetPos(posX, posY);
	newCheckbox.SetText(label);
	newCheckbox.SetToggle(bDefaultValue);

	return newCheckbox;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colBackgroundColor=(R=192,G=192,B=192)
     fontText=Font'DeusExUI.FontSansSerif_8'
     textureMouse=Texture'DeusExUI.UserInterface.ToolWindowCursor'
     ScreenType=ST_Tool
}
