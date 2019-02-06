//=============================================================================
// MenuScreenSound
//=============================================================================

class MenuScreenSound expands MenuUIScreenWindow;

// ----------------------------------------------------------------------
// SaveSettings()
// ----------------------------------------------------------------------

function SaveSettings()
{
	Super.SaveSettings();
	player.SaveConfig();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     choices(0)=Class'DeusEx.MenuChoice_MusicVolume'
     choices(1)=Class'DeusEx.MenuChoice_SoundVolume'
     choices(2)=Class'DeusEx.MenuChoice_SpeechVolume'
     choices(3)=Class'DeusEx.MenuChoice_EffectsChannels'
     choices(4)=Class'DeusEx.MenuChoice_SampleRate'
     choices(5)=Class'DeusEx.MenuChoice_SoundQuality'
     choices(6)=Class'DeusEx.MenuChoice_ReverseStereo'
     choices(7)=Class'DeusEx.MenuChoice_SurroundSound'
     choices(8)=Class'DeusEx.MenuChoice_Use3DHardware'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
     Title="Sound Settings"
     ClientWidth=537
     ClientHeight=408
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuSoundBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuSoundBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuSoundBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuSoundBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.MenuSoundBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.MenuSoundBackground_6'
     helpPosY=354
}
