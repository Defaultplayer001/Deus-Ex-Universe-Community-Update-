//=============================================================================
// PersonaItemDetailWindow
//=============================================================================

class PersonaItemDetailWindow expands PersonaBaseWindow;

var PersonaItemDetailButton winIcon;
var PersonaNormalTextWindow winText;

var PersonaScrollAreaWindow winScroll;
var PersonaHeaderTextWindow winTitle;

var int defaultHeight;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetHeight(defaultHeight);

	CreateControls();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	winIcon = PersonaItemDetailButton(NewChild(Class'PersonaItemDetailButton'));
	winIcon.SetPos(0, 0);

	winScroll = PersonaScrollAreaWindow(NewChild(Class'PersonaScrollAreaWindow'));

	winText = PersonaNormalTextWindow(winScroll.ClipWindow.NewChild(Class'PersonaNormalTextWindow'));
	winText.SetTextMargins(2, 2);
	winText.SetWordWrap(True);
	winText.SetTextAlignments(HALIGN_Left, VALIGN_Top);
}

// ----------------------------------------------------------------------
// GetItemButton()
// ----------------------------------------------------------------------

function PersonaItemDetailButton GetItemButton()
{
	return winIcon;
}

// ----------------------------------------------------------------------
// SetIcon()
// ----------------------------------------------------------------------

function SetIcon(Texture newIcon)
{
	if (winIcon != None)
		winIcon.SetIcon(newIcon);
}

// ----------------------------------------------------------------------
// SetIconSize()
// ----------------------------------------------------------------------

function SetIconSize(int newWidth, int newHeight)
{
	if (winIcon != None)
	{
		winIcon.iconPosWidth  = newWidth;
		winIcon.iconPosHeight = newHeight;
	}
}

// ----------------------------------------------------------------------
// SetItem()
// ----------------------------------------------------------------------

function SetItem(DeusExPickup newItem)
{
	if (winIcon != None)
	{
		winIcon.SetItem(newItem);
		winIcon.SetIconSize(newItem.largeIconWidth, newItem.largeIconHeight);
	}
}

// ----------------------------------------------------------------------
// SetTextFont()
// ----------------------------------------------------------------------

function SetTextFont(Font newFont)
{
	if (newFont != None)
		winText.SetFont(newFont);
}

// ----------------------------------------------------------------------
// SetText()
// ----------------------------------------------------------------------

function SetText(String newText)
{
	winText.SetText(newText);
}

// ----------------------------------------------------------------------
// SetTextAlignments()
// ----------------------------------------------------------------------

function SetTextAlignments(EHAlign newHAlign, EVAlign newVAlign)
{
	winText.SetTextAlignments(newHAlign, newVAlign);
}

// ----------------------------------------------------------------------
// AppendText()
// ----------------------------------------------------------------------

function AppendText(String newText)
{
	winText.AppendText(newText);
}

// ----------------------------------------------------------------------
// SetIgnoreCount()
// ----------------------------------------------------------------------

function SetIgnoreCount(bool bIgnore)
{
	if (winIcon != None)
		winIcon.SetIgnoreCount(bIgnore);
}

// ----------------------------------------------------------------------
// SetCount()
// ----------------------------------------------------------------------

function SetCount(int newCount)
{
	if (winIcon != None)
		winIcon.SetCount(newCount);
}

// ----------------------------------------------------------------------
// SetCountLabel()
// ----------------------------------------------------------------------

function SetCountLabel(String newLabel)
{
	if (winIcon != None)
		winIcon.SetCountLabel(newLabel);
}

// ----------------------------------------------------------------------
// SetIconSensitivity()
// ----------------------------------------------------------------------

function SetIconSensitivity(bool bSensitive)
{
	if (winIcon != None)
		winIcon.SetSensitivity(bSensitive);
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	local float iconWidth, iconHeight;
	local float scrollWidth, scrollHeight;

	if (winIcon != None)
	{
		winIcon.QueryPreferredSize(iconWidth, iconHeight);
		winIcon.ConfigureChild(0, 0, iconWidth, iconHeight);
	}

	if (winScroll != None)
	{
		winScroll.QueryPreferredSize(scrollWidth, scrollHeight);
		winScroll.ConfigureChild(
			iconWidth + 1, 2, 
			width - iconWidth - 3, height - 4);
	}
}

// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

function bool ChildRequestedReconfiguration(window child)
{
	ConfigurationChanged();

	return True;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultHeight=55
}
