//=============================================================================
// PersonaItemButton
//=============================================================================
class PersonaItemButton extends ButtonWindow
	abstract;

var DeusExPlayer player;

var Texture	 icon;						// Icon to draw
var int      iconPosWidth;
var int      iconPosHeight;

var int      buttonWidth;
var int      buttonHeight;
var int      borderWidth;
var int      borderHeight;

var Bool     bSelected;
var Bool     bIconTranslucent;

var Texture texBorders[9];

// Border and Background Translucency
var bool bBorderTranslucent;
var bool bBackgroundTranslucent;
var bool bDrawBorder;

// Default Colors
var Color colBackground;
var Color colBorder;
var Color colHeaderText;
var Color colText;
var Color colIcon;
var Color colSelectionBorder;
var Color colFillSelected;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(buttonWidth, buttonHeight);

	CreateControls();

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	StyleChanged();
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	if (icon != None)
	{
		// Draw the icon
		if (bIconTranslucent)
			gc.SetStyle(DSTY_Translucent);		
		else
			gc.SetStyle(DSTY_Masked);	

		gc.SetTileColor(colIcon);
		gc.DrawTexture(((borderWidth) / 2)  - (iconPosWidth / 2),
					   ((borderHeight) / 2) - (iconPosHeight / 2),
					   iconPosWidth, iconPosHeight, 
					   0, 0,
					   icon);
	}

	// Draw selection border
	if (bSelected)
	{
		gc.SetTileColor(colSelectionBorder);
		gc.SetStyle(DSTY_Masked);
		gc.DrawBorders(0, 0, borderWidth, borderHeight, 0, 0, 0, 0, texBorders);
	}
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	return False;
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
}

// ----------------------------------------------------------------------
// SetIcon()
// ----------------------------------------------------------------------

function SetIcon(Texture newIcon)
{
	icon = newIcon;
}

// ----------------------------------------------------------------------
// SetIconSize()
// ----------------------------------------------------------------------

function SetIconSize(int newWidth, int newHeight)
{
	iconPosWidth  = newWidth;
	iconPosHeight = newHeight;
}

// ----------------------------------------------------------------------
// SetBorderSize()
// ----------------------------------------------------------------------

function SetBorderSize(int newWidth, int newHeight)
{
	borderWidth  = newWidth;
	borderHeight = newHeight;
}

// ----------------------------------------------------------------------
// SelectButton()
// ----------------------------------------------------------------------

function SelectButton(Bool bNewSelected)
{
	// TODO: Replace with HUD sounds
	PlaySound(Sound'Menu_Press', 0.25); 

	bSelected = bNewSelected;
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colBackground = theme.GetColorFromName('HUDColor_Background');
	colBorder     = theme.GetColorFromName('HUDColor_Borders');
	colText       = theme.GetColorFromName('HUDColor_NormalText');
	colHeaderText = theme.GetColorFromName('HUDColor_HeaderText');

	colFillSelected.r = Int(Float(colBackground.r) * 0.50);
	colFillSelected.g = Int(Float(colBackground.g) * 0.50);
	colFillSelected.b = Int(Float(colBackground.b) * 0.50);

	bBorderTranslucent     = player.GetHUDBorderTranslucency();
	bBackgroundTranslucent = player.GetHUDBackgroundTranslucency();
	bDrawBorder            = player.GetHUDBordersVisible();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     iconPosWidth=52
     iconPosHeight=52
     buttonWidth=54
     buttonHeight=54
     borderWidth=54
     borderHeight=54
     bIconTranslucent=True
     texBorders(0)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_TL'
     texBorders(1)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_TR'
     texBorders(2)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_BL'
     texBorders(3)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_BR'
     texBorders(4)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Left'
     texBorders(5)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Right'
     texBorders(6)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Top'
     texBorders(7)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Bottom'
     texBorders(8)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Center'
     colIcon=(R=255,G=255,B=255)
     colSelectionBorder=(R=255,G=255,B=255)
}
