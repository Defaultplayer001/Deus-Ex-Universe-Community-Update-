//=============================================================================
// MenuChoice_ThemeColor
//=============================================================================

class MenuChoice_ThemeColor extends MenuUIChoiceEnum;

var ColorTheme currentTheme;
var String     defaultTheme;

// ----------------------------------------------------------------------
// PopulateThemes()
// ----------------------------------------------------------------------

function PopulateThemes(int themeType)
{
	local ColorTheme theme;
	local int themeIndex;
	
	theme = player.ThemeManager.GetFirstTheme(themeType);
	
	while(theme != None)
	{
		enumText[themeIndex++] = theme.GetThemeName();
		theme = player.ThemeManager.GetNextTheme();
	}
}

// ----------------------------------------------------------------------
// SetValueFromString()
// ----------------------------------------------------------------------

function SetValueFromString(String stringValue)
{
	local int enumIndex;

	for(enumIndex=0; enumIndex<arrayCount(enumText); enumIndex++)
	{
		if (enumText[enumIndex] == stringValue)
		{
			SetValue(enumIndex);
			break;
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
