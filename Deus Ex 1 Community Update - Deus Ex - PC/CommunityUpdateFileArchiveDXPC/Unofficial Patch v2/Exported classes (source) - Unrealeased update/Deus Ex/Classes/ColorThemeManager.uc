//=============================================================================
// ColorThemeManager 
//=============================================================================
class ColorThemeManager extends Actor;

Enum EColorThemeTypes
{
	CTT_Menu,
	CTT_HUD
};

var travel ColorTheme FirstColorTheme;
var travel ColorTheme CurrentSearchTheme;
var travel EColorThemeTypes CurrentSearchThemeType;

var travel ColorTheme currentHUDTheme;
var travel ColorTheme currentMenuTheme;

// ----------------------------------------------------------------------
// SetCurrentHUDColorTheme()
// ----------------------------------------------------------------------

simulated function SetCurrentHUDColorTheme(ColorTheme newTheme)
{
	if (newTheme != None)
		currentHUDTheme = newTheme;
}

// ----------------------------------------------------------------------
// SetCurrentMenuColorTheme()
// ----------------------------------------------------------------------

simulated function SetCurrentMenuColorTheme(ColorTheme newTheme)
{
	if (newTheme != None)
		currentMenuTheme = newTheme;
}

// ----------------------------------------------------------------------
// NextHUDColorTheme()
// ----------------------------------------------------------------------

simulated function NextHUDColorTheme()
{
	currentHUDTheme = GetNextThemeByType(currentHUDTheme, CTT_HUD);
}

// ----------------------------------------------------------------------
// NextMenuColorTheme()
// ----------------------------------------------------------------------

simulated function NextMenuColorTheme()
{
	currentMenuTheme = GetNextThemeByType(currentMenuTheme, CTT_Menu);
}

// ----------------------------------------------------------------------
// GetCurrentHUDColorTheme()
// ----------------------------------------------------------------------

simulated function ColorTheme GetCurrentHUDColorTheme()
{
	return currentHUDTheme;
}

// ----------------------------------------------------------------------
// GetCurrentMenuColorTheme()
// ----------------------------------------------------------------------

simulated function ColorTheme GetCurrentMenuColorTheme()
{
	return currentMenuTheme;
}

// ----------------------------------------------------------------------
// DeleteColorTheme()
// ----------------------------------------------------------------------

simulated function bool DeleteColorTheme(String themeName)
{
	local ColorTheme deleteTheme;
	local ColorTheme prevTheme;
	local Bool bDeleted;
	
	bDeleted    = False;
	prevTheme   = None;
	deleteTheme = FirstColorTheme;
	
	while(deleteTheme != None)
	{
		if ((deleteTheme.GetThemeName() == themeName) && (deleteTheme.IsSystemTheme() != True))
		{
			if (deleteTheme == FirstColorTheme)
				FirstColorTheme = deleteTheme.next;
				
			if (prevTheme != None)
				prevTheme.next = deleteTheme.next;
			
			bDeleted = True;
			break;
		}
		
		prevTheme   = deleteTheme;
		deleteTheme = deleteTheme.next;
	}
}

// ----------------------------------------------------------------------
// CreateTheme()
// ----------------------------------------------------------------------

function ColorTheme CreateTheme(Class<ColorTheme> newThemeClass, String newThemeName)
{
	local ColorTheme newTheme;
	
	newTheme = AddTheme(newThemeClass);

	if (newTheme != None)
		newTheme.SetThemeName(newThemeName);

	return newTheme;
}

// ----------------------------------------------------------------------
// AddTheme()
// ----------------------------------------------------------------------

simulated function ColorTheme AddTheme(Class<ColorTheme> newThemeClass)
{
	local ColorTheme newTheme;
	local ColorTheme theme;

	if (newThemeClass == None)
		return None;
		
	// Spawn the class
	newTheme = Spawn(newThemeClass, Self);

	if (FirstColorTheme == None)
	{
		FirstColorTheme = newTheme;
	}
	else
	{
		theme = FirstColorTheme;

		// Add at end for now
		while(theme.next != None) 
			theme = theme.next;
		
		theme.next = newTheme;
	}

	return newTheme;
}

// ----------------------------------------------------------------------
// GetFirstTheme()
//
// Intended to be called from external classes since we can't freakin' 
// pass in the EColorThemeTypes.  God I hate that.
// ----------------------------------------------------------------------

simulated function ColorTheme GetFirstTheme(int intThemeType)
{
	local EColorThemeTypes themeType;

	if (intThemeType == 0)
		themeType = CTT_Menu;
	else
		themeType = CTT_HUD;
	
	CurrentSearchThemeType = themeType;
	CurrentSearchTheme     = GetNextThemeByType(None, CurrentSearchThemeType);

	return CurrentSearchTheme;
}

// ----------------------------------------------------------------------
// GetNextTheme()
// ----------------------------------------------------------------------

simulated function ColorTheme GetNextTheme()
{
	if (CurrentSearchTheme != None)
		CurrentSearchTheme = GetNextThemeByType(CurrentSearchTheme, CurrentSearchThemeType);

	return CurrentSearchTheme;
}

// ----------------------------------------------------------------------
// GetNextThemeByType()
// ----------------------------------------------------------------------

simulated function ColorTheme GetNextThemeByType(ColorTheme theme, EColorThemeTypes themeType)
{
	if (theme == None)
		theme = FirstColorTheme;
	else
		theme = theme.next;

	while(theme != None)
	{
		if (theme.themeType == themeType)
			break;
			
		theme = theme.next;
	}

	return theme;
}

// ----------------------------------------------------------------------
// FindTheme()
// ----------------------------------------------------------------------

simulated function ColorTheme FindTheme(String themeName)
{
	local ColorTheme theme;

	theme = FirstColorTheme;

	while(theme != None)
	{
		if (theme.GetThemeName() == themeName)
			break;
	}

	return theme;
}

// ----------------------------------------------------------------------
// SetHUDThemeByName()
// ----------------------------------------------------------------------

simulated function ColorTheme SetHUDThemeByName(String themeName)
{
	local ColorTheme theme;
	local ColorTheme firstHUDTheme;

	theme = FirstColorTheme;

	while(theme != None)
	{
		if (theme.themeType == CTT_HUD)
			firstHUDTheme = theme;

		if ((theme.GetThemeName() == themeName) && (theme.themeType == CTT_HUD))
		{
			currentHUDTheme = theme;			
			break;
		}

		theme = theme.next;
	}

	if (currentHUDTheme != None)
		return currentHUDTheme;
	else
		return firstHUDTheme;
}

// ----------------------------------------------------------------------
// SetMenuThemeByName()
// ----------------------------------------------------------------------

simulated function ColorTheme SetMenuThemeByName(String themeName)
{
	local ColorTheme theme;
	local ColorTheme firstMenuTheme;

	theme = FirstColorTheme;

	while(theme != None)
	{
		if (theme.themeType == CTT_Menu)
			firstMenuTheme = theme;

		if ((theme.GetThemeName() == themeName) && (theme.themeType == CTT_Menu))
		{
			currentMenuTheme = theme;			
			break;
		}

		theme = theme.next;
	}

	if (currentMenuTheme != None)
		return currentMenuTheme;
	else
		return firstMenuTheme;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bHidden=True
     bTravel=True
}
