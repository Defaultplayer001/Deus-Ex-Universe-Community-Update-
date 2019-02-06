//=============================================================================
// PersonaAmmoDetailButton
//=============================================================================

class PersonaAmmoDetailButton expands PersonaItemButton;

var Class<Ammo> ammo;
var Bool       bDisabledByDefault;
var Bool       bLoaded;
var Bool       bHasIt;
var int        rounds;

var Color colSelectionBorderHalf;

var localized String RoundLabel;
var localized String RoundsLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
	SetSensitivity(bDisabledByDefault);
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	local String str, descStr;
	local float strWidth, strHeight, strRoundsHeight;

	// Draw background
	if (bLoaded)
	{
		// Draw the background
		gc.SetStyle(DSTY_Translucent);
		gc.SetTileColor(colFillSelected);
		gc.DrawPattern(1, 1, width - 2, height - 2, 0, 0, Texture'Solid');
	}

	// Draw icon
	if (icon != None)
	{
		// Draw the icon
		if (bIconTranslucent)
			gc.SetStyle(DSTY_Translucent);		
		else
			gc.SetStyle(DSTY_Masked);	

		if (bHasIt)
			gc.SetTileColor(colIcon);
		else
			gc.SetTileColor(colSelectionBorderHalf);

		gc.DrawTexture(((borderWidth) / 2)  - (iconPosWidth / 2),
					   ((borderHeight) / 2) - (iconPosHeight / 2),
					   iconPosWidth, iconPosHeight, 
					   0, 0,
					   icon);
	}

	// Draw border
	if (!bSelected)
		gc.SetTileColor(colSelectionBorderHalf);
	else
		gc.SetTileColor(colSelectionBorder);

	gc.SetStyle(DSTY_Masked);
	gc.DrawBorders(0, 0, borderWidth, borderHeight, 0, 0, 0, 0, texBorders);

	// Draw the item name
	descStr = ammo.Default.beltDescription;

	gc.SetFont(Font'FontTiny');
	gc.SetAlignments(HALIGN_Center, VALIGN_Top);
	gc.GetTextExtent(0, strWidth, strHeight, descStr);

	if ((bHasIt) && (rounds > 0))
	{
		str = String(rounds);

		if (str == "1")
			str = Sprintf(RoundLabel, str);
		else
			str = Sprintf(RoundsLabel, str);
	}

	if (bHasIt)
		gc.SetTextColor(colHeaderText);
	else
		gc.SetTextColor(colSelectionBorderHalf);

	if (str != "")
	{
		gc.GetTextExtent(0, strWidth, strRoundsHeight, str);
		gc.DrawText(0, height - strHeight - strRoundsHeight + 2, width, strHeight, descStr);
		gc.DrawText(0, height - strRoundsHeight, width, strHeight, str);
	}
	else
	{
		gc.DrawText(0, height - strHeight - strRoundsHeight, width, strHeight, descStr);
	}
}

// ----------------------------------------------------------------------
// SetAmmo()
// ----------------------------------------------------------------------

function SetAmmo(Class<Ammo> newAmmo, bool bNewHasIt, optional int newRounds)
{
	ammo   = newAmmo;
	bHasIt = bNewHasIt;
	rounds = newRounds;
	
	SetClientObject(ammo);
	SetIcon(Class<DeusExAmmo>(ammo).Default.Icon);
	UpdateIconColor(bHasIt);
	SetSensitivity(bHasIt);	
}

// ----------------------------------------------------------------------
// GetAmmo()
// ----------------------------------------------------------------------

function Class<Ammo> GetAmmo()
{
	return ammo;
}

// ----------------------------------------------------------------------
// SetLoaded()
// ----------------------------------------------------------------------

function SetLoaded(bool bNewLoaded)
{
	bLoaded = bNewLoaded;
}

// ----------------------------------------------------------------------
// IsLoaded()
// ----------------------------------------------------------------------

function bool IsLoaded()
{
	return bLoaded;
}

// ----------------------------------------------------------------------
// UpdateIconColor()
// ----------------------------------------------------------------------

function UpdateIconColor(bool bHasIt)
{
	// Show the ammo in half intensity if the player doesn't have it!
	if ((ammo != None) && (bHasIt))
	{
		colIcon = Default.colIcon;
	}
	else
	{
		colIcon.r = Default.colIcon.r / 3;
		colIcon.g = Default.colIcon.g / 3;
		colIcon.b = Default.colIcon.b / 3;
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bDisabledByDefault=True
     colSelectionBorderHalf=(R=128,G=128,B=128)
     RoundLabel="%d Round"
     RoundsLabel="%d Rounds"
     iconPosWidth=42
     iconPosHeight=37
     buttonWidth=44
     buttonHeight=44
     borderWidth=44
     borderHeight=44
     bIconTranslucent=False
}
