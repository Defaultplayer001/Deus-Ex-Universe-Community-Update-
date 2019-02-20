//=============================================================================
// MenuUIRGBSliderButtonWindow
//=============================================================================

class MenuUIRGBSliderButtonWindow extends Window;

var DeusExPlayer player;

var ScaleWindow            winSlider;
var ScaleManagerWindow     winScaleManager;
var MenuUIEditWindow       editScaleText;
var MenuUIInfoButtonWindow winEditBorder;

var Texture defaultScaleTexture;
var Texture defaultThumbTexture;

var int defaultWidth;
var int defaultHeight;

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
	winScaleManager.SetSize(177, 21);
	winScaleManager.SetMarginSpacing(20);

	// Create the slider window 
	winSlider = ScaleWindow(winScaleManager.NewChild(Class'ScaleWindow'));
	winSlider.SetScaleOrientation(ORIENT_Horizontal);
	winSlider.SetThumbSpan(0);
	winSlider.SetScaleTexture(defaultScaleTexture, 177, 21, 8, 8);
	winSlider.SetThumbTexture(defaultThumbTexture, 9, 15);

	winEditBorder = MenuUIInfoButtonWindow(NewChild(Class'MenuUIInfoButtonWindow'));
	winEditBorder.SetWidth(43);
	winEditBorder.SetPos(185, 1);
	winEditBorder.SetSensitivity(False);

	// Create the text window
	editScaleText = MenuUIEditWindow(NewChild(Class'MenuUIEditWindow'));
	editScaleText.SetSize(39, 10);
	editScaleText.SetPos(187, 6);
	editScaleText.SetMaxSize(3);

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
// ScalePositionChanged() 
// ----------------------------------------------------------------------

event bool ScalePositionChanged(Window scale, int newTickPosition,
                                float newValue, bool bFinal)
{
	editScaleText.SetText(winSlider.GetValueString());
	editScaleText.SetInsertionPoint(Len(editScaleText.GetText()));
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
     DefaultWidth=230
     defaultHeight=21
}
