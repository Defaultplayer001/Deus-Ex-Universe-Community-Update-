=======================================================================================
                      Off Topic Productions User Interface Fix
=======================================================================================

                           Created by NVShacker, 11/16/07


===========
Description:
===========
A fix for the ugly upscaling of the GUI in DX at high resolutions


============
Installation:
============
(1) Extract otpUIfix.dll, detoured.dll, and otpUIfix.u into your DeusEx\System directory.
(2) Open up \DeusEx\System\DeusEx.ini and change this line:

	Root=DeusEx.DeusExRootWindow
    to
	Root=otpUIfix.otpRootWindow

(3) Launch the game at your desired resolution.
(4) Enjoy.


=======================
Nonstandard Resolutions:
=======================
The Display menu in Deus Ex cuts off the highest possible resolution. If you wish to 
run a higher resolution than the Display menu permits, open \DeusEx\System\DeusEx.ini
and change these lines:

    FullscreenViewportX=
    FullscreenViewportY=


============
Known Issues:
============
Changing resolution in-game can cause issues. Avoid going into the Display menu and 
escaping out (this will cause the resolution to reset for nonstandard resolutions).