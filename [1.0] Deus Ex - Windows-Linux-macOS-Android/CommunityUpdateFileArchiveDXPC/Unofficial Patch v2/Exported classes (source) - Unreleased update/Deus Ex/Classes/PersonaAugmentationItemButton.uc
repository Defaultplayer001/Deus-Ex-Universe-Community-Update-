//=============================================================================
// PersonaAugmentationItemButton
//=============================================================================
class PersonaAugmentationItemButton extends PersonaItemButton;

var PersonaLevelIconWindow winLevels;
var bool  bActive;
var int   hotkeyNumber;
var Color colIconActive;
var Color colIconNormal;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetActive(False);
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	local String str;

	Super.DrawWindow(gc);

	// Draw the hotkey info in lower-left corner
	if (hotkeyNumber >= 3)
	{
		str = "F" $ hotkeyNumber;
		gc.SetFont(Font'FontMenuSmall_DS');
		gc.SetAlignments(HALIGN_Left, VALIGN_Top);
		gc.SetTextColor(colHeaderText);
		gc.DrawText(2, iconPosHeight - 9, iconPosWidth - 2, 10, str);
	}
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	winLevels = PersonaLevelIconWindow(NewChild(Class'PersonaLevelIconWindow'));
	winLevels.SetPos(30, 54);
	winLevels.SetSelected(True);
}

// ----------------------------------------------------------------------
// SetHotkeyNumber()
// ----------------------------------------------------------------------

function SetHotkeyNumber(int num)
{
	hotkeyNumber = num;
}

// ----------------------------------------------------------------------
// SetActive()
// ----------------------------------------------------------------------

function SetActive(bool bNewActive)
{
	bActive = bNewActive;

	if (bActive)
		colIcon = colIconActive;
	else
		colIcon = colIconNormal;
}

// ----------------------------------------------------------------------
// SetLevel()
// ----------------------------------------------------------------------

function SetLevel(int newLevel)
{
	if (winLevels != None)
		winLevels.SetLevel(newLevel);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colIconActive=(G=255)
     colIconNormal=(R=255,G=255)
     buttonHeight=59
}
