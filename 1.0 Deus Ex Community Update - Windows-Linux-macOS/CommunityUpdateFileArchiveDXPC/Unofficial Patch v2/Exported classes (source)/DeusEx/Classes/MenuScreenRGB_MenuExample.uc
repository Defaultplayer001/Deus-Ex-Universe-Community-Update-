//=============================================================================
// MenuScreenRGB_MenuExample
//=============================================================================

class MenuScreenRGB_MenuExample expands Window;

var DeusExPlayer player;

var Window winTitle;
var Window winTitleBubble;
var Window winActionButtonDisabled;
var Window winActionButtonNormal;
var Window winActionButtonFocus;
var Window winActionButtonPressed;
var Window winMenuButtonDisabled;
var Window winMenuButtonNormal;
var Window winMenuButtonFocus;
var Window winMenuButtonPressed;
var Window winSmallButtonNormal;
var Window winSmallButtonPressed;
var Window winScroll;
var Window winListFocus;

var TextWindow winTextButtonMenuDisabled;
var TextWindow winTextButtonMenuNormal;
var TextWindow winTextButtonMenuFocus;
var TextWindow winTextButtonMenuPressed;
var TextWindow winTextButtonSmallNormal;
var TextWindow winTextButtonSmallPressed;
var TextWindow winTextButtonActionDisabled;
var TextWindow winTextButtonActionNormal;
var TextWindow winTextButtonActionFocus;
var TextWindow winTextButtonActionPressed;
var TextWindow winTextList;
var TextWindow winTextListFocus;
var TextWindow winTextEdit;
var TextWindow winTextTitle;

var Color   colBackground;
var Color   colListFocus;
var Font    fontMenuButtonText;
var Texture texListFocusBorders[9];

var bool bBackgroundTranslucent;

var localized String ButtonMenuDisabledLabel;
var localized String ButtonMenuNormalLabel;
var localized String ButtonMenuFocusLabel;
var localized String ButtonMenuPressedLabel;
var localized String ButtonSmallPressedLabel;
var localized String ButtonSmallNormalLabel;
var localized String ButtonActionDisabledLabel;
var localized String ButtonActionNormalLabel;
var localized String ButtonActionFocusLabel;
var localized String ButtonActionPressedLabel;
var localized String ListNormalLabel;
var localized String ListFocusLabel;
var localized String EditLabel;
var localized String TitleLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(423, 178);

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	CreateControls();
	StyleChanged();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	local Window winIcon;

	// Load the menu font from the DXFonts package
	fontMenuButtonText = Font(DynamicLoadObject("DXFonts.MainMenuTrueType", Class'Font'));

	// Title bar graphic
	winTitle = NewChild(Class'Window');
	winTitle.SetPos(0, 0);
	winTitle.SetSize(195, 75);
	winTitle.SetBackgroundStyle(DSTY_Masked);
	winTitle.SetBackground(Texture'RGB_MenuTitleBarBackground');

	// Title bar bubble
	winTitleBubble = NewChild(Class'Window');
	winTitleBubble.SetPos(3, 2);
	winTitleBubble.SetSize(168, 18);
	winTitleBubble.SetBackgroundStyle(DSTY_Masked);
	winTitleBubble.SetBackground(Texture'RGB_MenuTitleBar');

	// Title Text
	winTextTitle = CreateActionText(32, 5, TitleLabel);

	// Title bar icon
	winIcon = NewChild(Class'Window');
	winIcon.SetPos(12, 3);
	winIcon.SetSize(16, 16);
	winIcon.SetBackground(Texture'MenuIcon_DeusEx');

	// List focus
	winListFocus = NewChild(Class'Window');
	winListFocus.SetBackgroundStyle(DSTY_Normal);
	winListFocus.SetBackground(Texture'Solid');
	winListFocus.SetSize(148, 11);
	winListFocus.SetPos(252, 64);

	// List Text
	winTextList      = CreateListText(255, 53, ListNormalLabel);
	winTextListFocus = CreateListText(255, 65, ListFocusLabel);
	winTextEdit      = CreateListText(255, 77, EditLabel);

	// Scroll bar graphics
	winScroll = NewChild(Class'Window');
	winScroll.SetPos(401, 50);
	winScroll.SetSize(15, 93);
	winScroll.SetBackgroundStyle(DSTY_Masked);
	winScroll.SetBackground(Texture'RGB_MenuScrollBar');

	// Button Menu Backgrounds
	winMenuButtonDisabled = CreateMenuButton(17,  31, Texture'RGB_MenuButtonLarge_Normal');
	winMenuButtonNormal   = CreateMenuButton(17,  61, Texture'RGB_MenuButtonLarge_Normal');
	winMenuButtonFocus    = CreateMenuButton(17,  91, Texture'RGB_MenuButtonLarge_Focus');
	winMenuButtonPressed  = CreateMenuButton(17, 121, Texture'RGB_MenuButtonLarge_Pressed');

	// Button Menu Text
	winTextButtonMenuDisabled = CreateMenuText(32,  32, ButtonMenuDisabledLabel);
	winTextButtonMenuNormal   = CreateMenuText(32,  62, ButtonMenuNormalLabel);
	winTextButtonMenuFocus    = CreateMenuText(32,  92, ButtonMenuFocusLabel);
	winTextButtonMenuPressed  = CreateMenuText(32, 123, ButtonMenuPressedLabel);

	// Action Buttons
	winActionButtonDisabled = CreateActionButton( 11, 158, Texture'RGB_MenuButtonSmall_Normal');
	winActionButtonNormal   = CreateActionButton(172, 158, Texture'RGB_MenuButtonSmall_Normal');
	winActionButtonFocus    = CreateActionButton(256, 158, Texture'RGB_MenuButtonSmall_Normal');
	winActionButtonPressed  = CreateActionButton(340, 158, Texture'RGB_MenuButtonSmall_Pressed');

	// Action Button Text
	winTextButtonActionDisabled = CreateActionText( 19, 162, ButtonActionDisabledLabel);
	winTextButtonActionNormal   = CreateActionText(181, 162, ButtonActionNormalLabel);
	winTextButtonActionFocus    = CreateActionText(265, 162, ButtonActionFocusLabel);
	winTextButtonActionPressed  = CreateActionText(349, 162, ButtonActionPressedLabel);

	// Small Buttons
	winSmallButtonNormal  = CreateSmallButton(252, 31, Texture'RGB_MenuButtonHeader_Normal');
	winSmallButtonPressed = CreateSmallButton(312, 31, Texture'RGB_MenuButtonHeader_Pressed');
	winSmallButtonPressed.SetWidth(74);

	// Small Button Text
	winTextButtonSmallNormal  = CreateSmallText(257, 34, ButtonSmallNormalLabel);
	winTextButtonSmallPressed = CreateSmallText(319, 34, ButtonSmallPressedLabel);
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	// Draw client area
	if (bBackgroundTranslucent)
		gc.SetStyle(DSTY_Translucent);
	else
		gc.SetStyle(DSTY_Masked);

	gc.SetTileColor(colBackground);
	gc.DrawTexture( 10, 23, 256, 134, 0, 0, Texture'RGB_MenuSampleBackground_1');		
	gc.DrawTexture(266, 23, 157, 134, 0, 0, Texture'RGB_MenuSampleBackground_2');		
}

// ----------------------------------------------------------------------
// PostDrawWindow()
// ----------------------------------------------------------------------

event PostDrawWindow(GC gc)
{
	// List focus border
	gc.SetTileColor(colListFocus);
	gc.SetStyle(DSTY_Normal);
	gc.DrawBorders(252, 64, 148, 11, 0, 0, 0, 0, texListFocusBorders);
}

// ----------------------------------------------------------------------
// CreateMenuButton()
// ----------------------------------------------------------------------

function Window CreateMenuButton(int posX, int posY, Texture buttonBackground)
{
	local Window winButton;

	winButton = NewChild(Class'Window');
	winButton.SetPos(posX, posY);
	winButton.SetSize(204, 27);
	winButton.SetBackgroundStyle(DSTY_Translucent);
	winButton.SetBackground(buttonBackground);

	return winButton;
}

// ----------------------------------------------------------------------
// CreateMenuText()
// ----------------------------------------------------------------------

function TextWindow CreateMenuText(int posX, int posY, String label)
{
	local TextWindow winText;

	winText = TextWindow(NewChild(Class'TextWindow'));
	winText.SetPos(posX, posY);
	winText.SetTextMargins(0, 0);
	winText.SetTextAlignments(HALIGN_Left, VALIGN_Top);
	winText.SetText(label);
	winText.SetFont(fontMenuButtonText);
	winText.EnableTranslucentText(True);

	return winText;
}

// ----------------------------------------------------------------------
// CreateActionButton()
// ----------------------------------------------------------------------

function Window CreateActionButton(int posX, int posY, Texture buttonBackground)
{
	local Window winButton;

	winButton = NewChild(Class'Window');
	winButton.SetPos(posX, posY);
	winButton.SetSize(83, 19);
	winButton.SetBackgroundStyle(DSTY_Masked);
	winButton.SetBackground(buttonBackground);

	return winButton;
}

// ----------------------------------------------------------------------
// CreateActionText()
// ----------------------------------------------------------------------

function TextWindow CreateActionText(int posX, int posY, String label)
{
	local TextWindow winText;

	winText = TextWindow(NewChild(Class'TextWindow'));
	winText.SetPos(posX, posY);
	winText.SetTextMargins(0, 0);
	winText.SetTextAlignments(HALIGN_Left, VALIGN_Top);
	winText.SetText(label);
	winText.SetFont(Font'FontMenuTitle');

	return winText;
}

// ----------------------------------------------------------------------
// CreateSmallButton()
// ----------------------------------------------------------------------

function Window CreateSmallButton(int posX, int posY, Texture buttonBackground)
{
	local Window winButton;

	winButton = NewChild(Class'Window');
	winButton.SetPos(posX, posY);
	winButton.SetSize(59, 15);
	winButton.SetBackgroundStyle(DSTY_Masked);
	winButton.SetBackground(buttonBackground);

	return winButton;
}

// ----------------------------------------------------------------------
// CreateSmallText()
// ----------------------------------------------------------------------

function TextWindow CreateSmallText(int posX, int posY, String label)
{
	local TextWindow winText;

	winText = TextWindow(NewChild(Class'TextWindow'));
	winText.SetPos(posX, posY);
	winText.SetTextMargins(0, 0);
	winText.SetTextAlignments(HALIGN_Left, VALIGN_Top);
	winText.SetText(label);
	winText.SetFont(Font'FontMenuHeaders');

	return winText;
}

// ----------------------------------------------------------------------
// CreateListText()
// ----------------------------------------------------------------------

function TextWindow CreateListText(int posX, int posY, String label)
{
	local TextWindow winText;

	winText = TextWindow(NewChild(Class'TextWindow'));
	winText.SetPos(posX, posY);
	winText.SetTextMargins(0, 0);
	winText.SetTextAlignments(HALIGN_Left, VALIGN_Top);
	winText.SetText(label);
	winText.SetFont(Font'FontMenuSmall');

	return winText;
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	colBackground = theme.GetColorFromName('MenuColor_Background');

	winTitle.SetTileColor(theme.GetColorFromName('MenuColor_ButtonFace'));
	winTitleBubble.SetTileColor(theme.GetColorFromName('MenuColor_TitleBackground'));

	colListFocus = theme.GetColorFromName('MenuColor_ListFocus');
	winListFocus.SetTileColor(theme.GetColorFromName('MenuColor_ListHighlight'));

	winMenuButtonDisabled.SetTileColor(theme.GetColorFromName('MenuColor_ButtonFace'));
	winMenuButtonNormal.SetTileColor(theme.GetColorFromName('MenuColor_ButtonFace'));
	winMenuButtonFocus.SetTileColor(theme.GetColorFromName('MenuColor_ButtonFace'));
	winMenuButtonPressed.SetTileColor(theme.GetColorFromName('MenuColor_ButtonFace'));
	winActionButtonDisabled.SetTileColor(theme.GetColorFromName('MenuColor_ButtonFace'));
	winActionButtonNormal.SetTileColor(theme.GetColorFromName('MenuColor_ButtonFace'));
	winActionButtonFocus.SetTileColor(theme.GetColorFromName('MenuColor_ButtonFace'));
	winActionButtonPressed.SetTileColor(theme.GetColorFromName('MenuColor_ButtonFace'));
	winSmallButtonNormal.SetTileColor(theme.GetColorFromName('MenuColor_ButtonFace'));
	winSmallButtonPressed.SetTileColor(theme.GetColorFromName('MenuColor_ButtonFace'));
	winScroll.SetTileColor(theme.GetColorFromName('MenuColor_ButtonFace'));

	winTextButtonMenuDisabled.SetTextColor(theme.GetColorFromName('MenuColor_ButtonTextDisabled'));
	winTextButtonMenuNormal.SetTextColor(theme.GetColorFromName('MenuColor_ButtonTextNormal'));
	winTextButtonMenuFocus.SetTextColor(theme.GetColorFromName('MenuColor_ButtonTextFocus'));
	winTextButtonMenuPressed.SetTextColor(theme.GetColorFromName('MenuColor_ButtonTextNormal'));
	winTextButtonSmallNormal.SetTextColor(theme.GetColorFromName('MenuColor_ButtonTextNormal'));
	winTextButtonSmallPressed.SetTextColor(theme.GetColorFromName('MenuColor_ButtonTextNormal'));
	winTextButtonActionDisabled.SetTextColor(theme.GetColorFromName('MenuColor_ButtonTextDisabled'));
	winTextButtonActionNormal.SetTextColor(theme.GetColorFromName('MenuColor_ButtonTextNormal'));
	winTextButtonActionFocus.SetTextColor(theme.GetColorFromName('MenuColor_ButtonTextFocus'));
	winTextButtonActionPressed.SetTextColor(theme.GetColorFromName('MenuColor_ButtonTextNormal'));
	winTextList.SetTextColor(theme.GetColorFromName('MenuColor_ListText'));
	winTextListFocus.SetTextColor(theme.GetColorFromName('MenuColor_ListTextHighlight'));
	winTextEdit.SetTextColor(theme.GetColorFromName('MenuColor_ListText'));
	winTextTitle.SetTextColor(theme.GetColorFromName('MenuColor_TitleText'));

	bBackgroundTranslucent = player.GetMenuTranslucency();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texListFocusBorders(0)=Texture'DeusExUI.UserInterface.RGB_ListSelectionBorder'
     texListFocusBorders(1)=Texture'DeusExUI.UserInterface.RGB_ListSelectionBorder'
     texListFocusBorders(2)=Texture'DeusExUI.UserInterface.RGB_ListSelectionBorder'
     texListFocusBorders(3)=Texture'DeusExUI.UserInterface.RGB_ListSelectionBorder'
     texListFocusBorders(4)=Texture'DeusExUI.UserInterface.RGB_ListSelectionBorder'
     texListFocusBorders(5)=Texture'DeusExUI.UserInterface.RGB_ListSelectionBorder'
     texListFocusBorders(6)=Texture'DeusExUI.UserInterface.RGB_ListSelectionBorder'
     texListFocusBorders(7)=Texture'DeusExUI.UserInterface.RGB_ListSelectionBorder'
     ButtonMenuDisabledLabel="Disabled"
     ButtonMenuNormalLabel="Normal"
     ButtonMenuFocusLabel="Focus"
     ButtonMenuPressedLabel="Pressed"
     ButtonSmallPressedLabel="Pressed"
     ButtonSmallNormalLabel="Normal"
     ButtonActionDisabledLabel="Disabled"
     ButtonActionNormalLabel="Normal"
     ButtonActionFocusLabel="Focus"
     ButtonActionPressedLabel="Pressed"
     ListNormalLabel="Normal"
     ListFocusLabel="Focus"
     EditLabel="Edit"
     TitleLabel="Title"
}
