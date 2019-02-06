//=============================================================================
// PersonaItemDetailButton
//=============================================================================

class PersonaItemDetailButton expands PersonaItemButton;

var DeusExPickup item;
var Bool         bIgnoreCount;
var Bool         bDisabledByDefault;
var int          itemCount;

var localized String CountLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetItem(None);

	SetSensitivity(bDisabledByDefault);
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	local String str;
	local float strWidth, strHeight;

	Super.DrawWindow(gc);

	// Don't draw count if we're ignoring
	if (!bIgnoreCount)
	{
		str = Sprintf(CountLabel, itemCount);

		gc.SetFont(Font'FontMenuSmall_DS');
		gc.SetAlignments(HALIGN_Center, VALIGN_Top);
		gc.SetTextColor(colHeaderText);
		gc.GetTextExtent(0, strWidth, strHeight, str);
		gc.DrawText(0, height - strHeight, width, strHeight, str);
	}
}

// ----------------------------------------------------------------------
// SetItem()
// ----------------------------------------------------------------------

function SetItem(DeusExPickup newItem)
{
	item = newItem;

	SetClientObject(item);

	if (item != None)
		itemCount = item.NumCopies;

	UpdateIconColor();
}

// ----------------------------------------------------------------------
// UpdateIconColor()
// ----------------------------------------------------------------------

function UpdateIconColor()
{
	// Show the icon in half intensity if the player doesn't have it!
	if ((item != None) || (bIgnoreCount) || ((!bIgnoreCount) && (itemCount > 0)))
	{
		colIcon = Default.colIcon;
	}
	else
	{
		colIcon.r = Default.colIcon.r / 2;
		colIcon.g = Default.colIcon.g / 2;
		colIcon.b = Default.colIcon.b / 2;
	}
}

// ----------------------------------------------------------------------
// SetIgnoreCount()
// ----------------------------------------------------------------------

function SetIgnoreCount(bool bIgnore)
{
	bIgnoreCount = bIgnore;
	SetItem(Item);
}


// ----------------------------------------------------------------------
// SetCount()
// ----------------------------------------------------------------------

function SetCount(int newCount)
{
	itemCount = newCount;

	UpdateIconColor();
}

// ----------------------------------------------------------------------
// SetCountLabel()
// ----------------------------------------------------------------------

function SetCountLabel(String newLabel)
{
	CountLabel = newLabel;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bDisabledByDefault=True
     CountLabel="Count: %d"
     iconPosWidth=53
     iconPosHeight=53
     buttonWidth=55
     buttonHeight=55
     borderWidth=55
     borderHeight=55
     bIconTranslucent=False
}
