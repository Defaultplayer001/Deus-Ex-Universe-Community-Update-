[Public]
;Preferences=(Caption="Advanced",Parent="Advanced Options")
;Preferences=(Caption="Launch File System",Parent="Advanced",Class=LaunchInternal.LaunchSystem,Immediate=True)

[General]
Start=Launch (Starting)
Exit=Launch (Exiting)
Run=Launch (Running)
Product=Launch
RunBang=Run!
FirstTime=Launch First-Time Configuration
SafeMode=Launch Safe Mode
Video=Launch Video Configuration
Audio=Launch Audio Configuration
RecoveryMode=Launch Recovery Mode
WebPage=http://coding.hanfling.de/launch/
Direct3DWebPage=http://www.deusex.com/Direct3D.htm
Detecting=Detecting 3D video devices, please wait...
SoundLow=Low sound quality
SoundHigh=High sound quality
SkinsLow=Medium detail player skin textures
SkinsHigh=High detail player skins
WorldLow=Medium detail world textures
WorldHigh="High detail textures"
ResLow=Low video resolution
ResHigh=Standard video resolution
FailedResDetect=Failed to detect supported resolutions.

[Descriptions]
SoftDrv.SoftwareRenderDevice=Software renderer.  Compatible with all video cards.  Not recommended - use at your own risk.
GlideDrv.GlideRenderDevice=3dfx Glide support, the optimal choice for 3dfx owners.  3dfx card required.
D3DDrv.D3DRenderDevice=Direct3D hardware rendering.
OpenGLDrv.OpenGLRenderDevice=OpenGL support.
MetalDrv.MetalRenderDevice=For users with S3 Savage4 video cards.
Galaxy.GalaxyAudioSubsystem=Default UnrealEngine Audio Subsystem.
ALAudio.ALAudioSubsystem=Experimental OpenAL Support.

[IDDIALOG_ConfigPageDetail]
IDC_ConfigPageDetail=
IDC_DetailPrompt=Based on your computer's speed, memory, and video card, Launch has selected the following detail options in order to optimize performance.
IDC_DetailNote=You may change these options from the game's "Preferences" window later, if you wish.

[IDDIALOG_ConfigPageFirstTime]
IDC_ConfigPageFirstTime=
IDC_Prompt=Launch is starting up for the first time.  If you experience any problems, please read the release notes in the "Programs / Launch" section of the Windows "Start" menu.

[IDDIALOG_ConfigPageRenderer]
IDC_ConfigPageRenderer=
IDC_RenderPrompt=Your computer supports the following 3D video devices. If you wish to change the current, highlight an option below.
IDC_RenderNote=
IDC_Compatible=Show certified, compatible devices
IDC_All=Show all devices

[IDDIALOG_ConfigPageResolution]
IDC_ConfigPageRenderer=
IDC_RenderPrompt=Your computer supports the following fullscreen resolutions. If you wish to change the current, highlight an option below.
IDC_RenderNote=

[IDDIALOG_ConfigPageAudioSubsystem]
IDC_ConfigPageRenderer=
IDC_RenderPrompt=Your computer supports the following audio subsystem. If you wish to change the current, highlight an option below.
IDC_RenderNote=

[IDDIALOG_ConfigPageSafeMode]
IDC_ConfigPageSafeMode=
IDC_SafeModePrompt=The previous time Launch was run, it was not shut down properly.  In case the shut down was caused by a problem, you may use the options below for recovery.
IDC_SafeModePrompt2=Launch safe mode options: If you are experiencing problems, you may use the options below for recovery.
;IDC_Run=Run Launch
IDC_Run=Run
;IDC_Video=Change your 3D video device
IDC_Video=Change RenderDevice
IDC_Audio=Change AudioSubsystem
;IDC_SafeMode=Run Launch in safe mode - for troubleshooting
IDC_SafeMode=Run in safe mode
;IDC_Web=Visit Web site
IDC_Web=Website

[IDDIALOG_ConfigPageSafeOptions]
IDC_ConfigPageSafeOptions=
IDC_SafeOptions=Safe mode options, for diagnosing problems
IDC_NoSound=Disable all sound
IDC_No3DSound=Disable 3D sound hardware
IDC_No3DVideo=Disable 3D video hardware
IDC_Window=Run the game in a window (rather than fullscreen)
IDC_Res=Run in standard 640x480 resolution
IDC_ResetConfig=Reset all configuration options to defaults
IDC_NoProcessor=Disable Pentium III/3DNow processor extensions
IDC_NoJoy=Disable joystick support

[IDDIALOG_ConfigPageDriver]
IDC_ConfigPageDriver=
IDC_DriverText=Launch has detected the following Direct3D compatible video card:
IDC_DriverInfo=Since you have chosen Direct3D, Launch will attempt to use this video card's driver for Direct3D support.\n\nHowever, some 3D card drivers must be updated in order to work reliably with Launch's leading-edge 3D features.  We recommend following the web link below for more information about your video card's compatibility, and to obtain the latest Direct3D drivers.\n\nIf you experience any graphical problems such as incorrect colors, flashing polygons, slow performance, or crashes, please use the "Launch Safe Mode" link in the "Start / Programs" to change your video driver.
IDC_Web=For links the latest drivers, visit our web page:
IDC_WebButton=Direct3D Information && Drivers Page
IDC_Card=Unknown

[IDDIALOG_WizardDialog]
IDC_WizardDialog=Launch Setup
