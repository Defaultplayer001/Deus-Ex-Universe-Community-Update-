//=============================================================================
// HUDMedBotAugCanWindow
//=============================================================================

class HUDMedBotAugCanWindow extends PersonaBaseWindow;

var AugmentationCannister augCan;

var Window winCanIcon;
var PersonaNormalTextWindow txtAugDesc;
var HUDMedBotAugItemButton btnAug1;
var HUDMedBotAugItemButton btnAug2;

var Texture texBorders[9];
var Color   colBorder;

var localized String AugContainsText;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(226, 38);

	CreateControls();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	winCanIcon = NewChild(Class'Window');
	winCanIcon.SetBackgroundStyle(DSTY_Masked);
	winCanIcon.SetPos(-7, 1);
	winCanIcon.SetSize(42, 37);

	txtAugDesc = PersonaNormalTextWindow(NewChild(Class'PersonaNormalTextWindow'));
	txtAugDesc.SetPos(29, 2);
	txtAugDesc.SetSize(133, 34);
	txtAugDesc.SetTextMargins(0, 0);
	txtAugDesc.SetWordWrap(False);

	btnAug1 = HUDMedBotAugItemButton(NewChild(Class'HUDMedBotAugItemButton'));
	btnAug1.SetPos(155, 2);

	btnAug2 = HUDMedBotAugItemButton(NewChild(Class'HUDMedBotAugItemButton'));
	btnAug2.SetPos(190, 2);
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	gc.SetTileColor(colBorder);
	gc.SetStyle(DSTY_Translucent);
	gc.DrawBorders(0, 0, width, height, 0, 0, 0, 0, texBorders);
}

// ----------------------------------------------------------------------
// SetCannister()
// ----------------------------------------------------------------------

function SetCannister(AugmentationCannister newAugCan)
{
	local String augDesc;

	augCan = newAugCan;

	winCanIcon.SetBackground(augCan.Icon);
	btnAug1.SetAugmentation(augCan.GetAugmentation(0));
	btnAug1.SetAugCan(augCan);
	btnAug2.SetAugmentation(augCan.GetAugmentation(1));
	btnAug2.SetAugCan(augCan);

	augDesc = AugContainsText $ " " $ btnAug1.GetAugDesc() $ "|n" $ " " $ btnAug2.GetAugDesc();

	txtAugDesc.SetText(augDesc);
}

// ----------------------------------------------------------------------
// GetCannister()
// ----------------------------------------------------------------------

function AugmentationCannister GetCannister()
{
	return augCan;
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	Super.StyleChanged();

	colBorder.r = Int(Float(colBackground.r) / 2);
	colBorder.g = Int(Float(colBackground.g) / 2);
	colBorder.b = Int(Float(colBackground.b) / 2);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texBorders(0)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_TL'
     texBorders(1)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_TR'
     texBorders(2)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_BL'
     texBorders(3)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_BR'
     texBorders(4)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Left'
     texBorders(5)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Right'
     texBorders(6)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Top'
     texBorders(7)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Bottom'
     texBorders(8)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Center'
     AugContainsText="Contains:|n"
}
