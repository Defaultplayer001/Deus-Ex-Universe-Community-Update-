//=============================================================================
// MenuUISliderButtonWindow
//=============================================================================

class MenuUISliderButtonWindow extends Window;

var DeusExPlayer player;

var ScaleWindow winSlider;
var ScaleManagerWindow winScaleManager;
var MenuUIInfoButtonWindow winScaleText;

var Texture defaultScaleTexture;
var Texture defaultThumbTexture;

var int defaultWidth;
var int defaultHeight;
var int defaultScaleWidth;
var Bool bUseScaleText;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(defaultWidth, defaultHeight);

	// Create the Scale Manager Window
	winScaleManager = ScaleManagerWindow(NewChild(Class'ScaleManagerWindow'));
	winScaleManager.SetSize(defaultScaleWidth, 21);
	winScaleManager.SetMarginSpacing(20);

	// Create the slider window 
	winSlider = ScaleWindow(winScaleManager.NewChild(Class'ScaleWindow'));
	winSlider.SetScaleOrientation(ORIENT_Horizontal);
	winSlider.SetThumbSpan(0);
	winSlider.SetScaleTexture(defaultScaleTexture, defaultScaleWidth, 21, 8, 8);
	winSlider.SetThumbTexture(defaultThumbTexture, 9, 15);
	winSlider.SetScaleSounds(Sound'Menu_Press', None, Sound'Menu_Slider');
	winSlider.SetSoundVolume(0.25);

	// Create the text window
	if (bUseScaleText)
	{
		winScaleText = MenuUIInfoButtonWindow(NewChild(Class'MenuUIInfoButtonWindow'));
		winScaleText.SetSelectability(False);
		winScaleText.SetWidth(60);
		winScaleText.SetPos(184, 1);
	}

	// Tell the Scale Manager wazzup.
	winScaleManager.SetScale(winSlider);

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	StyleChanged();
}

// ----------------------------------------------------------------------
// SetTicks()
// ----------------------------------------------------------------------

function SetTicks( int numTicks, int startValue, int endValue)
{
	winSlider.SetValueRange(startValue, endValue);
	winSlider.SetNumTicks(numTicks);
}

// ----------------------------------------------------------------------
// ScalePositionChanged() : Called when an ancestor scale window's
//                          position is moved
// ----------------------------------------------------------------------

event bool ScalePositionChanged(Window scale, int newTickPosition,
                                float newValue, bool bFinal)
{
	if (winScaleText != None)
		winScaleText.SetButtonText(winSlider.GetValueString());

	return False;
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;
	local Color colButtonFace;

	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	// Title colors
	colButtonFace = theme.GetColorFromName('MenuColor_ButtonFace');

	winSlider.SetThumbColor(colButtonFace);
	winSlider.SetScaleColor(colButtonFace);
	winSlider.SetTickColor(colButtonFace);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultScaleTexture=Texture'DeusExUI.UserInterface.MenuSliderBar'
     defaultThumbTexture=Texture'DeusExUI.UserInterface.MenuSlider'
     DefaultWidth=243
     defaultHeight=21
     defaultScaleWidth=177
     bUseScaleText=True
}
