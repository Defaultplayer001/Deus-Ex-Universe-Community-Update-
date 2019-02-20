//=============================================================================
// MenuScreenAdjustColors
//=============================================================================

class MenuScreenAdjustColors expands MenuUIScreenWindow;

var MenuScreenAdjustColorsExample winExample;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	CreateExampleWindow();	
}

// ----------------------------------------------------------------------
// CreateExampleWindow()
// ----------------------------------------------------------------------

function CreateExampleWindow()
{
	winExample = MenuScreenAdjustColorsExample(winClient.NewChild(Class'MenuScreenAdjustColorsExample'));
	winExample.SetPos(395, 25);	
}

// ----------------------------------------------------------------------
// SaveSettings()
// ----------------------------------------------------------------------

function SaveSettings()
{
	Super.SaveSettings();
	player.SaveConfig();
	player.ThemeManager.SaveConfig();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     choices(0)=Class'DeusEx.MenuChoice_MenuTranslucency'
     choices(1)=Class'DeusEx.MenuChoice_MenuColor'
     choices(2)=Class'DeusEx.MenuChoice_HUDBordersVisible'
     choices(3)=Class'DeusEx.MenuChoice_HUDBorderTranslucency'
     choices(4)=Class'DeusEx.MenuChoice_HUDTranslucency'
     choices(5)=Class'DeusEx.MenuChoice_HUDColor'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
     Title="Adjust Colors"
     ClientWidth=620
     ClientHeight=300
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuColorBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuColorBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuColorBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuColorBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.MenuColorBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.MenuColorBackground_6'
     helpPosY=246
}
