Windows Manager updates by Hanfling.

Not 100% sure what the difference is between the two. Neither is Hanfling it seems. 

"uhm
lemme check
i think for lite i started to throw out backwards compat with directdraw and such shit
and more aggressivly tryign to reimplement stuff
not sure"
= Hanfling, Revision Discord.

For now recommended to use Lite, TNM2 and GMDX CU both use it and it seems to work fine.

Usage: Change / add the following ini values.

ViewportManager=WinDrvLite.WindowsClientLite

[WinDrv.WindowsClient]
WindowedViewportX=1024
WindowedViewportY=768
WindowedColorBits=32
FullscreenViewportX=1024
FullscreenViewportY=768
FullscreenColorBits=32
Brightness=0.500000
MipFactor=1.000000
UseDirectDraw=False
UseJoystick=False
CaptureMouse=True
StartupFullscreen=True
CurvedSurfaces=True
ScreenFlashes=True
NoLighting=False
SlowVideoBuffering=False
DeadZoneXYZ=True
DeadZoneRUV=False
InvertVertical=False
ScaleXYZ=1000.000000
ScaleRUV=2000.000000
SkinDetail=High
TextureDetail=High
Decals=True
MinDesiredFrameRate=30.000000
UseDirectInput=False
NoDynamicLights=False

For Ext replace "Lite" with "Ext". (I think? Can only find examples for Lite.)

Could probably get away with renaming the .int too.
 