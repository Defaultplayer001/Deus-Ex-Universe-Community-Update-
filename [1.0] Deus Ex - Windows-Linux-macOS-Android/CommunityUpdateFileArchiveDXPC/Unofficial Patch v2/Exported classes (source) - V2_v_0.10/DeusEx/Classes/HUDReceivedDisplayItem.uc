//=============================================================================
// HUDReceivedDisplayItem
//=============================================================================
class HUDReceivedDisplayItem extends TileWindow;

var DeusExPlayer player;

var Window     winIcon;
var TextWindow winLabel;

var Color colText;
var Font fontLabel;

var Class<Inventory> itemClass; //The class of the item we're displaying
var int itemCount; //The number of items we're tracking

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetOrder(ORDER_DownThenRight);
	SetChildAlignments(HALIGN_Center, VALIGN_Top);
	SetMargins(0, 0);
	SetMinorSpacing(2);
	MakeWidthsEqual(False);
	MakeHeightsEqual(False);

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	StyleChanged();
}

// ----------------------------------------------------------------------
// SetItem()
// ----------------------------------------------------------------------

event SetItem(Inventory invItem, int count)
{
	local String labelText;
	local Texture icontex;

	winIcon = NewChild(Class'Window');
	winIcon.SetSize(42, 37);
	winIcon.SetBackgroundStyle(DSTY_Masked);

	icontex = invItem.Icon;

	if(icontex == None)
		icontex = invItem.Default.Icon;

	winIcon.SetBackground(icontex);

	itemClass = invItem.Class; //For tracking duplicates
	itemCount = count;

	winLabel = TextWindow(NewChild(Class'TextWindow'));
	winLabel.SetFont(fontLabel);
	winLabel.SetTextColor(colText);
	winLabel.SetTextAlignments(HALIGN_Center, VALIGN_Top);

	labelText = invItem.beltDescription;
	if(labelText == "") //== Weird bug with robots, no idea why
		labelText = invItem.Default.beltDescription;
	if (count > 1 || invItem.IsA('Ammo')) //== Y|y for Ammo we ALWAYS want to list the amount
		labelText = labelText $ " (" $ String(count) $ ")";

	winLabel.SetText(labelText);
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colText = theme.GetColorFromName('HUDColor_NormalText');

	if (winLabel != None)
		winLabel.SetTextColor(colText);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     fontLabel=Font'DeusExUI.FontMenuSmall_DS'
}
