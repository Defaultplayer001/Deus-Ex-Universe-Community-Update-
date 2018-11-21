TocaEdit Xbox 360 Controller Emulator 3.2.9.81 (2015-10-04)

System Requirements

• Windows Vista or newer.
• .NET 3.5 (includes 2.0 and 3.0) - included in Windows 7.
http://www.microsoft.com/en-us/download/details.aspx?id=22
In Windows 8 and 10: Control Panel > Programs and Features > Turn Windows features on or off > enable “.NET Framework 3.5 (includes 2.0 and 3.0)”.
• .NET 4.6 (includes 4.0) - included in Windows 8 and 10.
http://www.microsoft.com/en-us/download/details.aspx?id=48130
• DirectX End-User Runtime (June 2010) - Required regardless of OS; .NET MUST be installed prior to the DirectX update.
http://www.microsoft.com/en-us/download/details.aspx?id=8109
• Visual C++ Redistributable for Visual Studio 2013 - For x64 systems install both x86 and x64 redistributables.
http://www.microsoft.com/en-us/download/details.aspx?id=40784

Files

• xinput1_3.dll (Library) - Translates XInput calls to DirectInput calls - supports old, non-XInput compatible GamePads.
• x360ce.exe - (Application) - Allows for editing and testing of Library settings.
• x360ce.ini - (Configuration) - Contain Library settings (button, axis, slider maps).
• x360ce.gdb - (Game Database) Includes required hookmasks for various games).
• Dinput8.dll - (DirectInput 8 spoof/wrapping file to improve x360ce compatibility in rare cases).

Installation

Run this program from the same directory as the game executable. XInput library files exist with several different names and some games require a change in its name. Known names:

• xinput1_4.dll
• xinput1_3.dll
• xinput1_2.dll
• xinput1_1.dll
• xinput9_1_0.dll

Uninstallation

Delete x360ce.exe, x360ce.ini and all XInput DLLs from the game's executable directory.

Troubleshooting

Some games have control issues, when Dead Zone is reduced to 0%.

You may need to increase the Anti-Dead Zone value, if there is gap between the moment, when you start to push the axis related button, and the reaction in game.

Some controllers will only operate in game, if they are set as “GamePad”. Try to:

1. Run x360ce.exe
2. Select [Controller #] tab page with your controller.
3. Open [Advanced] tab page.
4. Set "Device Type" drop down list value to: GamePad.
5. Click [Save] button.
6. Close x360ce Application, run game.

Only one controller, mapped to PAD1, may work correctly in some games. Try to:

1. Run x360ce.exe
2. Select the [Controller #] tab page corresponding to your controller.
3. Open the [Direct Input Device] tab page (visible when the controller is connected).
4. Set "Map To" drop down list value to: 1.
5. Set "Map To" drop down list values (repeat steps 2. to 4.) for other controllers, if you have them, to: 2, 3 or 4.
6. Click [Save] button.
7. Close x360ce Application, run game.

To use more than one controller in game, you may need to combine them. Try to:

1. Run x360ce.exe
2. Select the [Controller #] tab page corresponding to your additional controller.
3. Open the [Advanced] tab page.
4. Set "Combine Into" drop down list value to: One.
5. Select [Options] tab page.
6. Check "Enable Combining" check-box. (Note: Uncheck "Enable Combining" check-box, when you want to configure the controller.)
7. Click [Save] button.
8. Close x360ce Application, run game.

The x360ce.exe application can be closed before launching the game; the game doesn't need it and it uses your computer's resources. The x360ce.exe application is just a GUI for editing x360ce.ini and testing your controller.

If [Controller #] tab page light won't turn green / Red light on [Controller #] tab page:

• The controller profile loaded may match the name of your controller, but not actually be for the controller you own.
• There just might not be a profile for your control at all. The light should turn green once the 2 sticks, triggers and D-pad are assigned. Sometimes x360ce.exe application needs to be restarted, after assigning these, for the light to turn green.
• The controller profile might have PassThrough (check-box) enabled.
• The DInput state of the controller might be incorrect due to an application crashing previously and not unloading the controller or some other reason. Opening up Joy.cpl (Set Up USB Game Controllers) and clicking the [Advanced] button, and then Okaying out of the window, that appears, can fix it.
If you have questions about installation or configuration, please go to our NGemu x360ce forum: http://ngemu.com/forums/x360ce.140