//=============================================================================
// PersonaItemDetailIconWindow
//=============================================================================

class PersonaItemDetailIconWindow expands PersonaBaseWindow;

var DeusExPickup item;
var Texture      icon;
var int			 iconWidth;
var int			 iconHeight;
var Color        colIcon;
var Bool         bIgnoreCount;

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
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	local String str;
	local int count;

	Super.DrawWindow(gc);

	// Draw icon
	gc.SetStyle(DSTY_Masked);
	gc.SetTileColor(colIcon);

	gc.DrawTexture(((width) / 2)  - (iconWidth / 2),
				   ((height) / 2) - (iconHeight / 2),
				   iconWidth, iconHeight, 
				   0, 0,
				   icon);

	// Don't draw count if we're ignoring
	if (!bIgnoreCount)
	{
		// Draw a Count
		if (item == None)
			count = 0;
		else
			count = item.NumCopies;

		str = Sprintf(CountLabel, count);

		gc.SetFont(Font'FontMenuSmall_DS');
		gc.SetAlignments(HALIGN_Center, VALIGN_Top);
		gc.SetTextColor(colHeaderText);
		gc.DrawText(1, height - 10, width, 10, str);
	}
}

// ----------------------------------------------------------------------
// SetIcon()
// ----------------------------------------------------------------------

function SetIcon(Texture newIcon)
{
	icon = newIcon;
}

// ----------------------------------------------------------------------
// SetItem()
// ----------------------------------------------------------------------

function SetItem(DeusExPickup newItem)
{
	item = newItem;

	// Show the icon in half intensity if the player doesn't have it!
	if ((item != None) || (bIgnoreCount))
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
// ----------------------------------------------------------------------

defaultproperties
{
     IconWidth=42
     IconHeight=37
     colIcon=(R=255,G=255,B=255)
     CountLabel="Count: %d"
}
