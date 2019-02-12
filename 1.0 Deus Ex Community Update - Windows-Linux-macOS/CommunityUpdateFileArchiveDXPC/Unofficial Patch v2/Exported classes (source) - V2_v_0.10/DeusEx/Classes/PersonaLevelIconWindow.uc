//=============================================================================
// PersonaLevelIconWindow
//=============================================================================

class PersonaLevelIconWindow extends PersonaBaseWindow;

var int     currentLevel;
var Texture texLevel;
var Bool    bSelected;

var int iconSizeX;
var int iconSizeY;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(23, 5);
}

// ----------------------------------------------------------------------
// SetSelected()
// ----------------------------------------------------------------------

function SetSelected(bool bNewSelected)
{
	bSelected = bNewSelected;
	StyleChanged();
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	local int levelCount;

	gc.SetTileColor(colText);
	gc.SetStyle(DSTY_Masked);

	for(levelCount=0; levelCount<=currentLevel; levelCount++)
	{
		gc.DrawTexture(levelCount * (iconSizeX + 1), 0, iconSizeX, iconSizeY, 
			0, 0, texLevel);
	}
}

// ----------------------------------------------------------------------
// SetLevel()
// ----------------------------------------------------------------------

function SetLevel(int newLevel)
{
	currentLevel = newLevel;
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	if (bSelected)
		colText = theme.GetColorFromName('HUDColor_ButtonTextFocus');
	else
		colText = theme.GetColorFromName('HUDColor_ButtonTextNormal');
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texLevel=Texture'DeusExUI.UserInterface.PersonaSkillsChicklet'
     iconSizeX=5
     iconSizeY=5
}
