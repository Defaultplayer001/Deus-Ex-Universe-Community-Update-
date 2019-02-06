//=============================================================================
// MenuScreenDisplay
//=============================================================================

class MenuScreenDisplay expands MenuUIScreenWindow;

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     choices(0)=Class'DeusEx.MenuChoice_Brightness'
     choices(1)=Class'DeusEx.MenuChoice_FullScreen'
     choices(2)=Class'DeusEx.MenuChoice_RenderDevice'
     choices(3)=Class'DeusEx.MenuChoice_Resolution'
     choices(4)=Class'DeusEx.MenuChoice_TextureColorBits'
     choices(5)=Class'DeusEx.MenuChoice_WorldTextureDetail'
     choices(6)=Class'DeusEx.MenuChoice_ObjectTextureDetail'
     choices(7)=Class'DeusEx.MenuChoice_DetailTextures'
     choices(8)=Class'DeusEx.MenuChoice_Decals'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
     Title="Display Settings"
     ClientWidth=391
     ClientHeight=408
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuDisplayBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuDisplayBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuDisplayBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuDisplayBackground_4'
     textureCols=2
     helpPosY=354
}
