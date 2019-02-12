Deus Ex Editor Fix

Description:
After placing over one thousand spawnpoints for HX in a set of maps to extract them later I took the frequent UnrealEd crashes quite personal. Hence I decided to figure out the cause of the preferences window crash when no Actor is selected. Thanks to Smirftsch for the line I snagged out of Unreal 227i headers after hunting down the issue. As the too many lit surfaces crash/hangup remained quite common I also include RenderExt, where I addressed that issue before. The increased stack size and /LARGEADDRESSAWARE improve stability when using UnrealEd for a long time and/or when rebuilding large maps.

Changelog:
 * Fix for frequent preferences window crash when no actor is selected.
 * Fix for too many lit surfaces (frequently happens in 12_Vandenberg_Tunnels).
 * Changed map file selection mask to *.dx
 * Updated Surface Flags.
 * Set /LARGEADDRESSAWARE flag and increased stack size of UnrealEd.exe.
 * Option for toggling Coronas On/Off in Editor (Preferences -> Rendering -> Extended Renderer -> UseEditorCoronas).
 * A few non Editor related fixes in RenderExt.dll/Window.dll.

Known Issues:
 * Using Camera -> Close All Free Cameras closes all viewports.

Further Plans:
Once I have rewritten the selection code for my OpenGLDrv I will include it as well in this patch, to get once and for all rid of SoftDrv in Editor.

Installation:
Backup Window.dll and UnrealEd.exe in your DeusEx/System directory. Extract all files contained in this zip file into the DeusEx/System directory. Open up your DeusEx.ini or the ini file you use with UnrealEd in a text editor and change the Render=Render.Render entry under [Engine.Engine] to Render=RenderExt.RenderExt . If you dont want to use the RenderExt ingame, you caould copy your DeusEx.ini file to Another.ini and startup UnrealEd with added -INI=ANother.ini command line.

Additional Notes:
If UnrealEd complains at startup about missing dll or ocx files, you should search the net for unrealedfix4, which contains the required dependencies. You don't need to and should not install unrealedfix4 into your Deus Ex directory. Just choose some random directory.
If your system DEP policy is Opt-Out you need to either lower it to at least Opt-In or add an exception in your system preferences for UnrealEd.exe. If your system DEP policy is Always-On you need to lower to reliable use UnrealEd, because the Galaxy and Fire package have known DEP issues.

Bug Reports:
If you encounter further bugs feel free to report them either by mail to ed.gnilfnah@em, drop me a line on moddb (hanfling) or on otp board. In any case I need as much information as possible. This includes a description what you did before it crash, what you did before in the UnrealEd session that crashed, how long you have been using UnrealEd in that session, the Editor.log file, your DeusEx.ini/User.ini files, preferable a TXT report out of CPU-Z, if you use non standard Deus Ex files (NV, HDTP, mods with changed DeusEx.u/DeusExUI.u, etc.), if it was the first time you got that crash, etc. Don't rule anything out as irrelevant, just give me as much information as possible -- I plain can't hunt down a bug where I barely know anything about. If the Editor viewports just hung up, try open a map file as this mostly makes the Editor crash to get a non truncated Editor.log file. Bonus stage: Try to reproduce the bug, BUT SAVE THE Editor.log BEFORE YOU RESTART THE EDITOR TO TRY IT OUT. If you can reproduce it and use non standard Deus Ex files, try again if you can reproduce the bug with standard Deus Ex files. If you manage to reproduce the bug and I can reproduce it too that way, great -- you have saved me hours of work and made it likely to get fixed.

2014-2015 by Sebastian Kaufel

Visit:
http://coding.hanfling.de/launch/
http://www.moddb.com/mods/hx
