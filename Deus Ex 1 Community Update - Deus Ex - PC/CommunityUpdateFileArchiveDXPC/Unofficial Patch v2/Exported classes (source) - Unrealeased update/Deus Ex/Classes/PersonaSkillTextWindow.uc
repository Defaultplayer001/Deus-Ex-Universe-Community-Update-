//=============================================================================
// PersonaSkillTextWindow
//=============================================================================

class PersonaSkillTextWindow extends PersonaNormalTextWindow;

var bool bSelected;

// ----------------------------------------------------------------------
// SetSelected()
// ----------------------------------------------------------------------

function SetSelected(bool bNewSelected)
{
	bSelected = bNewSelected;
	StyleChanged();
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;
	local Color colText;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	// Title colors
	if (bSelected)
		colText = theme.GetColorFromName('HUDColor_ButtonTextFocus');
	else
		colText = theme.GetColorFromName('HUDColor_ButtonTextNormal');

	SetTextColor(colText);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
