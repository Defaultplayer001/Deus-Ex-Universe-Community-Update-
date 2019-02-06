//=============================================================================
// PersonaHealthRegionWindow
//=============================================================================
class PersonaHealthRegionWindow extends PersonaBaseWindow;

var PersonaNormalTextWindow winTitle;
var ProgressBarWindow       winHealthBar;
var TextWindow              winHealthBarText;
var PersonaHealthActionButtonWindow btnHeal;
var ButtonWindow            btnRegion;

var Bool  bUseHealButton;
var int   partIndex;
var Float maxHealth;
var Float currentHealth;
var Color colBarBack;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(71, 39);

	CreateControls();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	CreateHealthBar();
	CreateTitle();
	CreateHealButton();
	CreateRegionButton();
}

// ----------------------------------------------------------------------
// CreateHealthBar()
// ----------------------------------------------------------------------

function CreateHealthBar()
{
	winHealthBar = ProgressBarWindow(NewChild(Class'ProgressBarWindow'));
	winHealthBar.SetPos(4, 13);
	winHealthBar.SetSize(66, 11);
	winHealthBar.SetValues(0, 100);
	winHealthBar.SetVertical(False);
	winHealthBar.SetScaleColorModifier(0.5);
	winHealthBar.UseScaledColor(True);
	winHealthBar.SetDrawBackground(True);
	winHealthBar.SetBackColor(colBarBack);

	winHealthBarText = TextWindow(NewChild(Class'TextWindow'));
	winHealthBarText.SetPos(4, 14);
	winHealthBarText.SetSize(66, 11);
	winHealthBarText.SetTextMargins(0, 0);
	winHealthBarText.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winHealthBarText.SetFont(Font'FontMenuSmall_DS');
	winHealthBarText.SetTextColorRGB(255, 255, 255);
}

// ----------------------------------------------------------------------
// CreateHealButton()
// ----------------------------------------------------------------------

function CreateHealButton()
{
	btnHeal = PersonaHealthActionButtonWindow(NewChild(Class'PersonaHealthActionButtonWindow'));
	btnHeal.SetPos(5, 26);
	btnHeal.Raise();
}

// ----------------------------------------------------------------------
// CreateRegionButton()
// ----------------------------------------------------------------------

function CreateRegionButton()
{
	btnRegion = ButtonWindow(NewChild(Class'ButtonWindow'));
	btnRegion.SetPos(0, 0);
	btnRegion.SetSize(98, 25);
}

// ----------------------------------------------------------------------
// CreateTitle()
// ----------------------------------------------------------------------

function CreateTitle()
{
	winTitle = PersonaNormalTextWindow(NewChild(Class'PersonaNormalTextWindow'));
	winTitle.SetSize(50, 11);
	winTitle.SetPos(3, 2);
}

// ----------------------------------------------------------------------
// SetPartIndex()
// ----------------------------------------------------------------------

function SetPartIndex(int newPartIndex)
{
	partIndex = newPartIndex;

	if (btnHeal != None)
		btnHeal.SetPartIndex(newPartIndex);
}

// ----------------------------------------------------------------------
// GetPartIndex()
// ----------------------------------------------------------------------

function int GetPartIndex()
{
	return partIndex;
}

// ----------------------------------------------------------------------
// SetMaxHealth()
// ----------------------------------------------------------------------

function SetMaxHealth(float newMaxHealth)
{
	maxHealth = newMaxHealth;

	winHealthBar.SetValues(0, maxHealth);
}

// ----------------------------------------------------------------------
// SetHealth()
// ----------------------------------------------------------------------

function SetHealth(float newHealth)
{
	currentHealth = newHealth;

	winHealthBar.SetCurrentValue(currentHealth);
	winHealthBarText.SetText(String(Int(newHealth)) @ "/" @ String(Int(maxHealth)));
}

// ----------------------------------------------------------------------
// IsDamaged()
// ----------------------------------------------------------------------

function Bool IsDamaged()
{
	return (currentHealth < maxHealth);
}

// ----------------------------------------------------------------------
// SetTitle()
// ----------------------------------------------------------------------

function SetTitle(String newTitle)
{
	if (winTitle != None)
		winTitle.SetText(newTitle);
}

// ----------------------------------------------------------------------
// GetTitle()
// ----------------------------------------------------------------------

function String GetTitle()
{
	if (winTitle != None)
		return winTitle.GetText();
	else
		return "";
}

// ----------------------------------------------------------------------
// ShowHealButton()
// ----------------------------------------------------------------------

function ShowHealButton(bool bShow)
{
	if (btnHeal != None)
		btnHeal.Show(bShow);
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	local medKit medKit;

	// First make sure the player has a medkit
	medKit = MedKit(player.FindInventoryType(Class'MedKit'));

	btnHeal.EnableWindow((currentHealth < maxHealth) && (medKit != None));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bUseHealButton=True
}
