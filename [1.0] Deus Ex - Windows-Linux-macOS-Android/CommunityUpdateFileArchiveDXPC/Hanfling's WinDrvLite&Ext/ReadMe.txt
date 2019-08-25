Windows Manager updates by Hanfling.

Not 100% sure what the difference is between the two. Neither is Hanfling it seems. 

"uhm
lemme check
i think for lite i started to throw out backwards compat with directdraw and such shit
and more aggressivly tryign to reimplement stuff
not sure"
= Hanfling, Revision Discord.

For now recommended to use Lite, TNM2 and GMDX CU both use it and it seems to work fine.

Usage: Change / add the following DeusEx.ini values.

1. Change your ViewportManager setting. In the third group right at the top, [Engine.Engine].

ViewportManager=WinDrvLite.WindowsClientLite

2. Add this to bottom of the ini (Optionally for neatness, put below the default WinDrv category)

[WinDrvLite.WindowsClientLite]
ScaleRUV=2000.000000
ScaleXYZ=1000.000000
InvertVertical=False
DeadZoneRUV=False
DeadZoneXYZ=True
SlowVideoBuffering=False
StartupFullscreen=True
UseJoystick=False
UseDirectInput=False
UseDirectDraw=False
NoDynamicLights=False
Decals=True
MinDesiredFrameRate=30.000000
NoLighting=False
ScreenFlashes=True
SkinDetail=High
TextureDetail=High
CurvedSurfaces=True
CaptureMouse=True
Brightness=0.500000
MipFactor=1.000000
WindowedViewportX=1024
WindowedViewportY=768
WindowedColorBits=32
FullscreenViewportX=1024
FullscreenViewportY=768
FullscreenColorBits=32

For Ext replace "Lite" with "Ext". (I think? Can only find examples for Lite.)