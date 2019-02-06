//=============================================================================
// HUDConWindowFirst
//=============================================================================
class HUDConWindowFirst expands HUDSharedBorderWindow;

var TileWindow lowerConWindow;					// Lower letterbox region
var TextWindow nameWindow;						// Window displaying Actor name
var TextWindow lastTextWindow;					// Most recent text window added

var ConPlay conPlay;							// Pointer into current conPlay object

var Color colConTextPlayer;
var Color colConTextName;
var Color colLine;

var Font  fontName;

var float conStartTime;
var int   txtVertMargin;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Initialize some variables and stuff
	conPlay = None;
	lastTextWindow	= None;

	// Create text window where we'll display the conversation
	lowerConWindow = TileWindow(NewChild(Class'TileWindow'));
	lowerConWindow.SetOrder(ORDER_Down);
	lowerConWindow.SetChildAlignments(HALIGN_Full, VALIGN_Top);
	lowerConWindow.MakeWidthsEqual(False);
	lowerConWindow.MakeHeightsEqual(False);
	lowerConWindow.SetMargins(20, 10);

	CreateNameWindow();

	conStartTime = player.level.TimeSeconds;
}

// ----------------------------------------------------------------------
// CreateNameWindow()
// ----------------------------------------------------------------------

function CreateNameWindow()
{
	local Window winLine;

	// Create the Name Window
	nameWindow = TextWindow(lowerConWindow.NewChild(Class'TextWindow'));
	nameWindow.SetTextAlignments( HALIGN_Left, VALIGN_Center);
	nameWindow.SetTextMargins(0, 2);
	nameWindow.SetFont(fontName);
	nameWindow.SetTextColor(colConTextName);

	// Create line between name and scrolling text
	winLine = lowerConWindow.NewChild(Class'Window');
	winLine.SetHeight(1);
	winLine.SetBackgroundStyle(DSTY_Normal);
	winLine.SetBackground(Texture'Solid');
	winLine.SetTileColor(colLine);
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
		lowerConWindow.QueryPreferredSize(preferredWidth, preferredHeight);

		if (preferredHeight < minHeight)
			preferredHeight = minHeight;
	}
	else if (bWidthSpecified)
	{
		preferredHeight = lowerConWindow.QueryPreferredHeight(preferredWidth);

		if (preferredHeight < minHeight)
			preferredHeight = minHeight;
	}
	else
	{
		preferredWidth = lowerConWindow.QueryPreferredWidth(preferredHeight);
	}
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
//
// Set the size of stuff and stuff.
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	lowerConWindow.ConfigureChild(0, 0, width, height);
}

// ----------------------------------------------------------------------
// DisplayName()
//
// Displays the Actor's name at the top line of the conversation
// ----------------------------------------------------------------------

function DisplayName(string text)
{
	nameWindow.SetText( text );
}

// ----------------------------------------------------------------------
// DisplayText()
//
// Displays a string of conversation text
// ----------------------------------------------------------------------

function DisplayText(string text, Actor speakingActor)
{
	local TextWindow newText;
	local float txtWidth;
	local GC gc;

	newText = TextWindow(lowerConWindow.NewChild(Class'TextWindow'));
	newText.SetTextAlignments( HALIGN_Left, VALIGN_Center);
	newText.SetTextMargins(10, 5);
	newText.SetFont(Font'FontMenuSmall_DS');
	newText.SetText(text);

	// Use a different color for the player's text
	if ( DeusExPlayer(speakingActor) != None ) 
		newText.SetTextColor(colConTextPlayer);
	else	
		newText.SetTextColor(colText);

	lastTextWindow = newText;

	AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// AppendText()
//
// Adds string to the last button
// ----------------------------------------------------------------------

function AppendText(string text)
{
	// Make sure we have a text window
	if ( lastTextWindow == None )
		return;
	
	lastTextWindow.AppendText(text);

	AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// DestroyChildren()
//
// Destroys all the windows used to display text and choices, 
// including the name window
// ----------------------------------------------------------------------

function DestroyChildren()
{
	local Window win;

	win = lowerConWindow.GetTopChild();
	while( win != None )
	{
		win.Destroy();
		win = lowerConWindow.GetTopChild();
	}

	// Reset variables
	lastTextWindow	= None;

	// Recreate the Name window
	CreateNameWindow();
}

// ----------------------------------------------------------------------
// Close()
// ----------------------------------------------------------------------

function Close()
{
	Hide();
}

// ----------------------------------------------------------------------
// Clear()
//
// Clears the screen
// ----------------------------------------------------------------------

function Clear()
{
	DestroyChildren();
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	Super.StyleChanged();

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colConTextPlayer = theme.GetColorFromName('HUDColor_NormalText');
	colConTextName   = theme.GetColorFromName('HUDColor_HeaderText');
	colLine          = colConTextName;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     FontName=Font'DeusExUI.FontMenuHeaders_DS'
     txtVertMargin=10
}
