// ============================================================================
//  SwFMOD 1.0.0.8: 3D Audio subsystem for Deus Ex
// ============================================================================
//  Copyright (C) 2007 Roman Switch` Dzieciol
//  FMOD Sound System Copyright (C) Firelight Technologies Pty, Ltd., 1994-2006
// ============================================================================
//  Website: http://sourceforge.net/projects/swfmod
//  Support: http://sourceforge.net/forum/forum.php?forum_id=715911
// ============================================================================

    Index:
     - ABOUT
     - REQUIREMENTS
     - INSTALLATION NOTES
     - MANUAL INSTALLATION
     - KNOWN ISSUES
     - INGAME MENU
     - CONSOLE COMMANDS
     - INI CONFIGURATION
     - MP3/OGG MUSIC
     - CHANGELOG
     - LICENSE
     

//
// ABOUT
//
    
SwFMOD is a fully featured audio subsystem for Unreal Engine 1 games, Deus Ex in particular. SwFMOD uses FMOD, a cross-platform audio library offering high-quality, high-performance, hardware-independent, 100% software audio mixing. 

Unlike other audio subsystems for UE1 games, SwFMOD is open source and fully software. It's a great starting point for other developers, as all the basic features are already implemented. Extension possibilities are limited mostly by coder's skill, not the sound driver or hardware. Custom DSP filters are the most interesting possibility, SwFMOD offers already basic HRTF & occlusion effects. 

End users can enjoy high quality sound no matter what sound card or operating system (ie vista) they have. All common speaker modes are supported, from mono to 7 point 1. Configuration file allows tweaking or overriding most of the audio system properties. 

SwFMOD is currently a Win32 DLL for the Deus Ex game. Porting to Linux or other UE1 games should require little to no source code changes. Porting to Mac or UE2 games is doable given modified UE headers and an experienced person. It could be also used as a base for other game audio projects as the interface and implementation are fairly universal.



//
// REQUIREMENTS
//

There are no special requirements, other than the latest 1112fm patch.
 - Windows
 - Deus Ex version 1112fm
 - *Any* soundcard


  
//
// INSTALLATION NOTES
//

SwFMOD installer will update all valid .INI files in your DeusEx folder to enable the new sound system. Uninstaller restores old settings.

This readme and the uninstaller can be accessed through the start menu.


  
//
// MANUAL INSTALLATION
//

To install SwFMOD manually:
 - stop the game
 - extract /System/SwFMOD.dll to /DeusEx/System/SwFMOD.dll
 - extract /System/SwFMOD.int to /DeusEx/System/SwFMOD.int
 - extract /System/fmodex.dll to /DeusEx/System/fmodex.dll
 - extract /Help/SwFMOD.int.txt to /DeusEx/Help/SwFMOD.int.txt
 - open /DeusEx/System/SwFMOD.ini in text editor
 - in SwFMOD.ini find line starting with "AudioDevice=" 
   (ie: "AudioDevice=Galaxy.GalaxyAudioSubsystem") 
 - and replace the text after "=" with "SwFMOD.SwFMOD" 
   (ie: "AudioDevice=SwFMOD.SwFMOD" )
 - Save DeusEx.ini
 


// 
// INGAME MENU
//

The ingame sound menu (Settings->Sound) is still functional. You can use the volume sliders and the Sound Quality option.  Setting sound quality to "8bit" doesn't make it 8bit, it just enables the LowSoundQuality option (see INI CONFIGURATION).  The other settings in sound menu are not compatible with SwFMOD and have no effect.


  
//
// KNOWN ISSUES
//

 - No reverb
Reverb isn't implemented at this time.

 - Occlusion doesn't sound right
Occlusion is an experimental feature that's not finished yet. That's why it's disabled by default.

 - Stuttering/skipping sound
Most likely it's caused by applications that modify the sound output somehow, ie running NVIDIA nvMixer or using volume controls on media keyboard might cause this. It might be a bad application, bad sound card driver or bad video card driver. This may also happen after alt-tab or alt-enter on some systems.



//
// CONSOLE COMMANDS
//

"ASTAT GLOBAL"
 - displays CPU and memory usage

"ASTAT CHANNELGROUP"
 - displays channel group statistics

"ASTAT CHANNELS"
 - displays currently playing sounds

"ASTAT RENDER"
 - displays level geometry used for sound occlusion
 
 
 
// 
// INI CONFIGURATION
//

You can modify all parameters by editing the DeusEx.ini file if the game isn't running. The [SwFMOD.SwFMOD] config section doesn't exist in  .INI just after installation. To force the game to create it, change ie sound volume ingame then exit.

Alternatively use the "preferences" console command to edit them ingame, nearly all changes require restart of Deus Ex though. Also keep in mind that the old "Audio" tab is no longer functional, use the "SwFMOD" tab instead.

Some modifications may result in poor sound quality or even crashing. To restore default settings: 
 - stop the game
 - open DeusEx.ini in text editor
 - find the [SwFMOD.SwFMOD] section
 - remove this section and all properties that belong to it
 - save DeusEx.ini
    
    
[SwFMOD.SwFMOD]
SoundVolume=255.000000  // Volume of sound effects. Range: 0.0-255.0
SpeechVolume=255.000000  // Volume of speech and other mp3 sound effects. Range: 0.0-255.0
MusicVolume=255.000000  // Volume of music. Range: 0.0-255.0
AmbientFactor=0.700000  // Ambient sound volume multiplier. Final volume is equal SoundVolume*AmbientFactor. Range: 0.0-10.0
AmbientHysteresis=256.000000  // Extra ambient sound distance, doesn't affect volume. It prevents stopping the ambient sound as soon as you step out of it's distance.
SampleInterpolation=Spline  // Sample interpolation, affects sound quality and framerate. Values from best performance to best quality: No, Linear, Cubic, Spline. Recommended: Linear or higher.
SampleFormat=PCMFLOAT  // Sample format, affects sound quality and framerate. Values from best performance to best quality: PCM8, PCM16. PCM32, PCMFLOAT. Recommended: PCM16 or higher.
sampleRate=48000Hz  // Sample rate, affects sound quality and framerate. Values from best performance to best quality:  8000Hz, 11025Hz, 16000Hz, 22050Hz, 32000Hz, 44100Hz, 48000Hz. Recommended: 48000Hz.
VirtualThreshold=0.000000  // Sounds with audibility less or equal this value become virtual (optimized mute) to increase performance. Recommended: 0.
VirtualChannels=64  // Amount of virtual sound channels. Those are used for sounds that aren't currently audible, because ie player moved away or all real channels are playing more important sounds. Range: 0-4096. Recommended: 64 or higher.
Channels=64  // Amount of real, audible sound channels. Determines max amount of sounds that can be audible at once. Range: 0-4096. Recommended: 64 or higher.
PriorityAmbient=192 // Priority of ambient sounds. Used only when number of currently playing sounds is higher than real channel count.
PrioritySpeech=127  // Priority of speech sounds. See above.
PrioritySound=255  // Priority of sound effects. See above.
PriorityMusic=0  // Priority of music. See above.
HRTFFreq=4000.000000  // Cutoff frequency for HRTF effect
HRTFMaxAngle=360.000000  // Angle at which HRTF is at full strength
HRTFMinAngle=180.000000  // Angle at which HRTF kicks in
bHRTF=1  // Muffle sounds that are behind you
RolloffScale=1.000000  // Rolloff scale
DistanceFactor=1.000000  // Distance model factor
DistanceMin=50.000000  // Sounds closer than this do not use the distance model
DopplerScale=1.000000  // Doppler scale
ToMeters=0.020000  // 1uu to 1meter conversion. Default: 50uu = 1meter.
OverrideSpeakerMode=-1  // Do not modify.
OverrideDebugFlags=-1  // Do not modify.
OverrideInitFlags=-1  // Do not modify.
OverrideDSPBufferCount=-1  // Do not modify.
OverrideDSPBufferLength=-1  // Do not modify.
OverrideInputChannels=2  // Do not modify.
OverrideOutputChannels=-1  // Do not modify.
OverrideOutput=-1  // Do not modify.
Max3D=0  // Max amount of 3D hardware sound channels used. Do not modify.
Min3D=0  // Min amount of 3D hardware sound channels used. Do not modify.
Max2D=0  // Max amount of 2D hardware sound channels used. Do not modify.
Min2D=0  // Min amount of 2D hardware sound channels used. Do not modify.
Driver=0  // Sound card selector. Available drivers are listed in DeusEx.log. Do not modify unless you have multiple soundcards installed.
bOcclusion=0  // Experimental: Sound sources without line of sight are muffled. Recommended: 0
LowSoundQuality=0  // No occlusion, no HRTF, Linear Interpolation, PCM16 format, 44100Hz rate, 16 real channels, 16 virtual channels
b3DCameraSounds=1  // Sounds that originate from player/camera use 3D attenuation
bPrecache=1  // Preloads sound & music on level start
StatPositions=0  // Draws music positions for first 6 sections
StatRender=0  // See CONSOLE COMMANDS
StatChannels=0  // See CONSOLE COMMANDS
StatChannelGroup=0  // See CONSOLE COMMANDS
StatGlobal=0  // See CONSOLE COMMANDS
bLogPlugins=0  // Dumps list of available plugins to log.



//
// MP3/OGG MUSIC
//

You can use MP2, MP3 or OGG music in addition to the old module format. The new formats do support dynamic music changes, see below for instructions.


# IMPORTING GUIDE:

Importing the new formats is no different from importing the old module music.
 * Remove any spaces from the name of your mp3/ogg file, ie: "My File.mp3" -> "MyFile.mp3"
 * Now it's a good time to rename it, you can't do that after import
 * Add "_Music" postfix to your filename, ie:  "MyFile.mp3" ->  "MyFile_Music.mp3"
 * copy your file to a folder without space characters in path, ie: C:\MyFile_Music.mp3
 * open UnrealEd, open the music browser
 * click the "Import" button, change filter to "All files (*.*)" and choose your mp3/ogg file
 * click the "Save" button and save it as "MyFile_Music.umx" in your /DeusEx/Music/ folder, the umx filename *MUST* be identical to the mp3/ogg filename.
 * your music is now ready


# DYNAMIC MP3/OGG MUSIC:

Deus Ex supports 6 dynamic music sections:
 1. Default music
 2. Dying music
 3. Ambient music
 4. Combat music
 5. Dialog (Conversation) music
 6. Outro music

Game picks one of the music sections depending on player's situation. If the section doesn't exist default music is played.

If you want to use dynamic music with the new formats, you have to create one UMX file for each section. 

The file names of the extra UMX files are very important, their format must be:
<default_section_name>_<section_name>.umx

Valid section names are:
 1. "" (no section name)
 2. "Dying"
 3. "Ambient"
 4. "Combat"
 5. "Dialog"
 6. "Outro"

For example:
 * NavalBase_Music.umx
 * NavalBase_Music_Dying.umx
 * NavalBase_Music_Ambient.umx
 * NavalBase_Music_Combat.umx
 * NavalBase_Music_Dialog.umx
 * NavalBase_Music_Outro.umx
 
Keep in mind that the umx file name and the imported music name must be identical, see the Importing Guide above.
 
If "NavalBase_Music" is chosen as the default level music and game wants to play combat music, "NavalBase_Music_Combat" will be automatically loaded and played. Once the combat ends "NavalBase_Music" will be resumed. *Do not* choose those extra postfixed files as default level music or dynamic music system won't work.

And that's all!



//
// CHANGELOG
//

1.0.0.8
 * MP2 sound effects
 * MP2, MP3 & OGG music, import file in UED then save as UMX
 * MP2/MP3/OGG music can be dynamic, special sections use files with special postfix
 * Music resumes from last known position when section changes, ie it doesn't restart the combat section everytime you go into combat
 * Looped sound effects now loop ingame, pushing sounds fixed



// 
// LICENSE
//

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.



// EOF