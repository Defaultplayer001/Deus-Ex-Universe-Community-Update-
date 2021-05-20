NGLIDE README FILE
--------------------------------------------------------------------------

Version: 1.05


Table of contents
------------------------
1. Overview
2. Requirements
3. Installation and Playing
4. Frequently Asked Questions
5. Compatibility List
6. Changelog
7. Thanks
8. Support & Contact Information
9. Legal


1. Overview
------------------------

nGlide is a 3Dfx Voodoo Glide wrapper. It allows you to play games designed for 3Dfx Glide API without the need for having 3Dfx Voodoo graphics card. All three API versions are supported, Glide 2.1 (glide.dll), Glide 2.4 (glide2x.dll) and Glide 3.0 (glide3x.dll). nGlide translates all Glide calls to Direct3D. Glide wrapper also supports high resolution modes.


2. Requirements
------------------------

For the most games (running at full speed) this configuration is good enough.

Processor: Intel / AMD at 2.0 GHz
Graphics card: Compatible with DirectX 9
Operating system: Windows XP / Windows 7 / Windows 8 / Windows 10


3. Installation and Playing
---------------------------

Run the nGlideXXX_setup.exe and click Install button. That's all.
You can now play your 3Dfx Glide games.


4. Frequently Asked Questions
-----------------------------

Q: I have a Glide game that doesn't work/has bugs with this glide wrapper. What can I do?
A: Send to us an e-mail/create a topic in the forum with game title, operating system version, graphics card name/model, nGlide version and of course full problem/bug description. Good idea is to attach some screenshots.

Q: Does nGlide also support DOS Glide games?
A: Yes, but not in native Windows environment. You must install DOSBox with Gulikoza's patch. These three builds contain it: Ykhwong's (http://ykhwong.x-y.net/), CosmicDan's (http://www.zeus-software.com/files/nglide/dosbox-2010-03-22-custom-glide.zip), Gulikoza's (http://www.si-gamer.net/gulikoza/). After installation delete glide2x.dll file from DOSBox directory (if any) and set memsize=63 in dosbox.conf. Last step is to install nGlide. Now you can run DOS Glide games from DOSBox console.

Q: Does nGlide support widescreen monitors?
A: Yes, nGlide supports 16:9 and 16:10 widescreen resolutions. For these, you can set original 4:3 aspect ratio to avoid image stretching.

Q: Does nGlide render in 16-bit color depth?
A: No. All is converted and rendered in 32-bit, no matter what color depth mode is selected in-game. This eliminates color banding problem.

Q: How to enable antialiasing / anisotropic filtering with nGlide?
A: Go to your Display driver panel and set Antialiasing Mode to 'Override application setting'. Adjust Antialiasing Level setting. Anisotropic Filtering Mode setting can be found on the same page.

Q: How to switch between fullscreen and windowed mode?
A: Press Alt+Enter on a keyboard while playing.

Q: How to set Windows 95 Compatibility Mode?
A: Right click on the game .exe file and click Properties. Select Compatibility tab, and choose 'Windows 95' from the list. Click Apply and OK button.

Q: How to Disable desktop composition?
A: Right click on the game .exe file and click Properties. Select Compatibility tab, and check 'Disable desktop composition' option. Click Apply and OK button.

Q: My Glide game is working too fast.
A: Go to nGlide configurator and set 'Vertical synchronization' option to 'On'.

Q: I'm experiencing screen tearing effect.
A: Go to nGlide configurator and set 'Vertical synchronization' option to 'On'.

Q: How to disable 3Dfx logo splash screen?
A: Go to nGlide configurator and set '3Dfx logo splash screen' option to 'Off'.

Q: How to make your own game patch?
A: 1) Download and install Microsoft Application Compatibility Toolkit.
   2) Run Compatibility Administrator.
   3) Click 'Fix' button. Enter game name and browse game exe file.
   4) In the 'Compatibility Fixes' dialog try selecting some of these fixes: 'CorrectFilePaths', 'EmulateGetDiskFreeSpace', 'GlobalMemoryStatusLie', 'EmulateDirectDrawSync', 'EmulateEnvironmentBlock', 'EmulateHeap', 'EmulateFindHandles', 'SingleProcAffinity'. Make sure you have 'DisableBoostThread' fix unchecked.
   5) Save your patch to *.sdb file.
   6) Create install batch file (PatchInstall.bat with command: sdbinst.exe -q "%CD%\yourpatch.sdb")
   7) Create uninstall batch file (PatchUninstall.bat with command: sdbinst.exe -u -q "%CD%\yourpatch.sdb").


5. Compatibility List
------------------------

To check game compatibility list, visit:
http://www.zeus-software.com/downloads/nglide/compatibility


6. Changelog
------------------------

nGlide 1.05:
------------------------

Glide2:
-added support for F-16: Fighting Falcon
-added support for Space Haste
-fixed Actua Golf 2 ui issues with older Radeons
-fixed Actua Soccer 2 seams glitch
-fixed Driver missing lens flare effect and wrong drawing distance
-fixed Killer Loop buggy time indicator background
-fixed Powerslide blinking car shadows
-fixed Time Warriors glitches with 320x200/640x400 viewports
-fixed Total Soccer 2k disappearing goal nets
-fixed Ultimate Race Pro incorrect fog and low texture detail with v1.50
-fixed Warzone 2100 invisible map after building command center
-fixed lack of gamma correction control with games utilizing SST_GAMMA

Glide3:
-added support for Les Visiteurs: La Relique De Sainte Rolande
-fixed NFL Blitz 2000 missing ui text with 3x renderer
-fixed Tiger Woods PGA TOUR 2000 long loading time
-fixed Tiger Woods PGA TOUR 2001 wrong target arrow distance and long loading time
-fixed Xtreme Air Racing resolution issue

Miscellaneous:
-added support for windowed mode (press Alt+Enter while in game to switch)
-added support for extended resolutions
-added support for edge anti-aliasing
-"4:3" aspect ratio option in nGlide configurator renamed to "Preserve original"
-framerate is now capped at 1000fps with VSync=off or windowed mode to reduce power consumption / coil whine
-fixed Alt+Tab switching in multithreaded games
-fixed regressions


nGlide 1.04:
------------------------

Glide2:
-added support for Hind
-added support for SimCopter
-added support for Xtom 3D
-fixed Codename: Eagle disappearing textures
-fixed Dreams to Reality (with DOSBox + Gulikoza's patch) fog problem
-fixed Formula 1 track surface details problem
-fixed Formula 1 '97 depth fighting issue
-fixed Incubation: Time Is Running Out image quality with high resolutions
-fixed Incubation: The Wilderness Missions image quality with high resolutions
-fixed Jane's Combat Simulations: F-15 Classic cross cursor issues
-fixed NASCAR Racing 3 cursor traces
-fixed Newman Haas Racing blinking car shadow
-fixed Return Fire 2 disappearing objects
-fixed Star Wars: Rogue Squadron 3D ctd after ending mission
-fixed Ultima 9: Ascension cursor in videos
-fixed V-Rally missing shadows under cars
-fixed Vigilance switch video modes error

Glide3:
-added support for TEXFMT extension (FXT1 and S3TC compressed / 32-bit / 2k textures)
-added support for PIXEXT extension (T-Buffer / Stencil buffer)
-added support for 24bit-Z mode
-fixed Homeworld garbled graphics in 1024x768
-fixed Serious Sam: The First Encounter missing lens flare effect
-fixed Serious Sam: The Second Encounter missing lens flare effect

Miscellaneous:
-added support for individual configurations via environment variables
-added support for Windows 10
-added 144Hz refresh rate mode
-added support for Direct3D reference rasterizer (software rendering)
 (place d3dref9.dll from DirectX SDK into game directory to use it)
-fixed missing 1024x768+ resolutions in several Glide2 games
-fixed minor glitch with lines rendering
-fixed some incompatibilities with anisotropic filtering
-improved performance of lfb reads and writes
-unsupported internal resolutions by GPU are now upscaled by default


nGlide 1.03:
------------------------

Glide2:
-added support for Pro Pilot 99
-added support for Pro Pilot 99 (Demo)
-added support for Requiem: Avenging Angel
-added support for Requiem: Avenging Angel (Demo)
-fixed Airfix Dogfighter black pickup items
-fixed Descent 2 (with DOSBox + Gulikoza's patch) main menu glitch
-fixed F-16 Multirole Fighter clipping issue
-fixed F-22 Lightning 3 clipping issue
-fixed Game Net Match no intro
-fixed Gex 2: Enter The Gecko rendering glitch
-fixed Gunmetal buggy static effect, wall decals, fog and horizon
-fixed MIG-29 Fulcrum clipping issue
-fixed NHL 99 broken loading screen
-fixed Tiger Woods 2001 crash with voodoo1 driver
-fixed Triple Play 99 disappearing players
-fixed Triple Play 2001 crash with voodoo1 driver

Glide3:
-added support for Star Trek: Voyager - Elite Force
-added support for COMBINE, PALETTE6666 and GETGAMMA extensions
-added support for stipple patterns
-added support for advanced alpha blending
-fixed Divine Divinity ctd at exit
-fixed Serious Sam: The First Encounter menu glitches
-fixed Serious Sam: The Second Encounter menu glitches
-fixed Star Trek: Elite Force 2 crash with flares=precise

Miscellaneous:
-improved performance of geometry rendering and texture creation
-fixed regressed games in the previous release


nGlide 1.02:
------------------------

Glide2:
-added support for Battlecruiser 3000AD 2.0 (with DOSBox + Gulikoza's patch)
-added support for Extreme Assault (with DOSBox + Gulikoza's patch)
-added support for F1 Racing Simulation
-added support for Falcon 4.0
-added support for Future Cop L.A.P.D.
-added support for Grand Prix Legends
-added support for Jane's Combat Simulations: AH-64D Longbow Gold
-added support for Monaco GP Racing Simulation 2
-added support for Monaco GP Racing Simulation 2 (Demo)
-added support for Tie Break Tennis (with DOSBox + Gulikoza's patch)
-fixed Carmageddon (with DOSBox + Gulikoza's patch) glitches in 3dfx.exe version
-fixed CyberStrike 2 missing HUD elements
-fixed Hexen 2 missing loading bars
-fixed Hexen 2: Portal of Praevus missing loading bars
-fixed Joint Strike Fighter internal resolution switching crash
-fixed Lands of Lore 2 (with DOSBox + Gulikoza's patch) blinking cursor
-fixed NHL 99 loading screen glitch
-fixed POD Gold grSstWinOpen error with videos enabled
-fixed Rayman 2: The Great Escape internal resolution switching crash
-fixed Return Fire 2 glitches
-fixed Star Wars: Rogue Squadron 3D crash in 800x600
-fixed Test Drive 4 blinking esc menu
-fixed Test Drive Off-Road 2 blinking esc menu
-fixed Trophy Bass 3D ctd at exit
-fixed Trophy Bass 4 ctd at exit

Glide3:
-added support for American McGee's Alice
-added support for Heavy Metal: F.A.K.K. 2
-added support for MDK 2
-added support for Quake 3 Arena
-added support for Serious Sam: The First Encounter
-added support for Serious Sam: The Second Encounter
-added support for Soldier of Fortune
-added support for Star Trek: Elite Force 2
-added support for Tiger Woods PGA TOUR 2001
-added support for Quantum3D splash plugin
-fixed Divine Divinity broken fog
-fixed NHL 2000 slow interface and missing special effects
-fixed NHL 2001 slow interface and missing special effects
-fixed NHL 2002 slow interface and missing special effects
-fixed Pro Rally 2001 crash in 800x600

Miscellaneous:
-improved performance of lfb and texture operations


nGlide 1.01:
------------------------

Glide2:
-added support for Centipede
-added support for Scorched Planet
-fixed Extreme Boards and Blades missing skate wheels
-fixed Gulf War: Operation Desert Hammer texturing issue
-fixed Incubation: Time Is Running Out main menu issues
-fixed Incubation: The Wilderness Missions main menu issues
-fixed POD Gold lens flare effect
-fixed UEFA Euro 2000 main menu glitch
-fixed Ultima 9: Ascension missing special effects
-fixed Uprising 2: Lead and Destroy broken text

Glide3:
-added support for Pro Rally 2001
-added support for Xtreme Air Racing
-added support for CHROMARANGE and TEXCHROMA extensions
-fixed 2002 FIFA World Cup main menu glitch
-fixed Die Hard Trilogy 2 crash
-fixed FIFA 2002 main menu glitch
-fixed NHL 2000 tutorials screen glitch
-fixed Return to Castle Wolfenstein high detail light maps crash

Miscellaneous:
-fixed several SDK and demoscene demos


nGlide 1.00:
------------------------

Glide2:
-added support for Barrage
-added support for S.C.A.R.S.
-fixed Airfix Dogfighter no intro bug
-fixed Bio F.R.E.A.K.S. black background issue
-fixed Carnivores sky issue
-fixed Carnivores 2 sky issue
-fixed Carnivores: Ice Age sky issue
-fixed CART Precision Racing image quality
-fixed Codename: Eagle texturing issue
-fixed Descent: Freespace ship lights
-fixed Excalibur 2555AD text glitch
-fixed F/A-18 Korea garbled debriefing screen
-fixed Lands of Lore 3 Alt+Tab crash
-fixed Monster Truck Madness 2 image quality
-fixed Motorhead lights visible through walls
-fixed Py³ (with DOSBox + Gulikoza's patch) lights visible through walls
-fixed Starsiege menu buttons glitch
-fixed SWIV 3D platform and shadow glitches
-fixed TNN Outdoors Pro Hunter engine crash with 640x480 and above

Glide3:
-added support for ePSXe, PS1 Emulator (with Lewpy's Glide plugin)
-added support for TEXMIRROR extension
-fixed Arabian Nights complex shadows bug
-fixed Hardwar: The Future is Greedy oblique lines glitch
-fixed Hype: The Time Quest blinking character shadows
-fixed Lander shadow glitch
-fixed realMYST transparency issue in menu

Miscellaneous:
-fixed Resolution: By desktop setting (with DOSBox + Gulikoza's patch)
-improved compatibility with Wine


nGlide 0.99:
------------------------

Glide2:
-added support for Anachronox
-added support for Descent
-added support for F/A-18 Korea
-added support for F/A-18 Korea (Demo)
-added support for Time Warriors
-fixed Archimedean Dynasty (with DOSBox + Gulikoza's patch) voxel radar indicators
-fixed Jane's Combat Simulations: F-15 Classic 2D cockpit glitch
-fixed Lands of Lore 2: Guardians of Destiny (with DOSBox + Gulikoza's patch) black glitches
-fixed Montezuma's Return shadows
-fixed Pandemonium no movies and no pause menu bugs
-fixed Py³ (with DOSBox + Gulikoza's patch) enemies visiblity range

Glide3:
-fixed Diablo 2 contrast/gamma issue
-fixed Turok 2: Seeds of Evil fog issue

Miscellaneous:
-added support for shameless plug
-fixed 4:3 aspect ratio for 1280x1024
-fixed nGlide's configuration access issue


nGlide 0.98:
------------------------

Glide2:
-added support for Archimedean Dynasty (with DOSBox + Gulikoza's patch)
-added support for Deathtrap Dungeon
-added support for Formula 1
-added support for Gunmetal
-added support for MechWarrior 2: 31st Century Combat
-added support for Pandemonium
-added support for Py³ (with DOSBox + Gulikoza's patch)
-added support for Severance: Blade of Darkness
-fixed Hardcore 4x4 freeze
-fixed Lands of Lore 2: Guardians of Destiny (with DOSBox + Gulikoza's patch) special effects
-fixed Lands of Lore 3 transparency issues
-fixed POD Gold shadows
-fixed V-Rally pause menu

Miscellaneous:
-added support for Glide 2.1.1 library (glide.dll)
-3x faster texture palettes handling


nGlide 0.97:
------------------------

Glide2:
-added support for Descent 2 (with DOSBox + Gulikoza's patch)
-added support for F-16 Multirole Fighter
-added support for F-22 Lightning 3
-added support for Nascar Racing 3
-added support for TrickStyle
-added support for Uprising: Join or Die
-added support for Uprising 2: Lead and Destroy
-added support for Uprising 2: Lead and Destroy (Demo)
-fixed Croc: Legend of the Gobbos transparency issues
-fixed MIG-29 Fulcrum textures bugs
-fixed POD Gold car wheels bug
-fixed Powerslide texturing and primitive issues
-fixed Sports Car GT mipmap option crash
-fixed Sub Culture no movies bug
-fixed Wacky Races blue menu bug

Glide3:
-improved support for TEXTUREBUFFER extension (used by Glide64)
-fixed Sinistar: Unleashed crash

Miscellaneous:
-added support for Alt+Tab switching
-improved points and lines drawing method
-fixed compatibility with Antialiasing forced in the Display driver panel
-fixed primitive clipping problem on AMD Radeons


nGlide 0.96:
------------------------

Glide2:
-added support for Gulf War: Operation Desert Hammer
-added support for Screamer 2 (with DOSBox + Gulikoza's patch)
-added support for Screamer Rally (with DOSBox + Gulikoza's patch)
-fixed Nascar Legends car decals
-fixed Nuclear Strike menu bugs
-fixed Tomb Raider credits crash
-fixed Unreal & Unreal Tournament textures bugs

Glide3:
-added support for Fifa 2000
-added support for Fifa 2001
-added support for GP 500
-added support for Hardwar: The Future is Greedy
-added support for Hype: The Time Quest
-added support for TEXTUREBUFFER extension (used by Glide64)
-fixed Arabian Nights in-game resolution change crash
-fixed Operation Flashpoint: Cold War Crisis menu glitches

Miscellaneous:
-added ability to choose screen aspect ratio
-50% faster texture palettes handling
-improved internal Glide FPS limiter (smoother animation)
-improved gamma correction scale
-improved splash screen rendering (no resolution switching)


nGlide 0.95:
------------------------

Glide2:
-added support for Actua Tennis
-added support for Kingpin: Life of Crime
-added support for San Francisco Rush: The Rock Alcatraz Edition
-fixed Clive Barker's Undying black mirrors and textures bugs

Glide3:
-added support for Divine Divinity
-added support for Return to Castle Wolfenstein
-added support for Supreme Snowboarding
-fixed Rollcage Stage 2 Ventura track crash
-fixed Test Drive 5 black car bug

Miscellaneous:
-added support for multitexturing
-added support for widescreen 16:9 resolutions
-added '3Dfx logo splash screen' option in nGlide configurator
-'Vertical synchronization' option in nGlide configurator is now 'On' by default


nGlide 0.94:
------------------------

Glide2:
-added support for Clusterball
-added support for Dreams to Reality (with DOSBox + Gulikoza's patch)
-added support for Independence War: Deluxe Edition
-added support for Interstate '76: Gold Edition
-added support for Lands of Lore 2: Guardians of Destiny
-added support for Lands of Lore 3
-added support for Metal Fatigue
-added support for Simon the Sorcerer 3D
-added support for Test Drive 4
-fixed Fleet Command 800x600 crash
-fixed King's Quest: Mask of Eternity 800x600 crash

Glide3:
-added support for Arabian Nights
-added support for Lander
-added TEXUMA extension for Glide64

Miscellaneous:
-added 'Refresh rate' option in nGlide configurator
-added 'Vertical synchronization' option in nGlide configurator


nGlide 0.93:
------------------------

Glide2:
-added support for Tomb Raider (with DOSBox + Gulikoza's patch)
-added support for Tomb Raider: Unfinished Business (with DOSBox + Gulikoza's patch)
-added support for Grand Theft Auto (with DOSBox + Gulikoza's patch)
-added support for Grand Theft Auto: London 1969 (with DOSBox + Gulikoza's patch)
-added support for Carmageddon (with DOSBox + Gulikoza's patch)
-fixed Red Line Racer cursor issue
-fixed Carmageddon 2 fog bug

Glide3:
-added support for Hitman: Codename 47
-added support for Operation Flashpoint: Cold War Crisis

Miscellaneous:
-added support for high resolution modes
-added 3Dfx logo splash screen
-faster linear frame buffers read/write operations
-better linear frame buffers color representation
-better gamma correction representation


nGlide 0.92:
------------------------

Added support for Glide3 library (glide3x.dll). In particular:

-added support for Diablo 2
-added support for Diablo 2: Lord of Destruction
-added support for Fifa 99
-added support for Heli Heroes
-added support for Le Mans 24 Hours
-added support for Need For Speed 3: Hot Pursuit
-added support for Need For Speed 4: High Stakes
-added support for Need For Speed 5: Porsche Unleashed
-added support for Project64, N64 Emulator (with Glide64 plugin)
-added support for realMYST: Interactive 3D Edition
-added support for Rollcage
-added support for Rollcage Stage 2
-added support for Sinistar: Unleashed
-added support for Test Drive 5
-added support for Turok 2: Seeds of Evil
-added support for World War 3: Black Gold


nGlide 0.91:
------------------------

-added support for Sentinel in 800x600
-added support for Midnight Racing
-added partial support for San Francisco Rush: The Rock Alcatraz Edition
-added partial support for Uprising 2: Lead and Destroy
-fixed light sources flicker issue in Motorhead and Motorhead Demo


nGlide 0.90:
------------------------

-first release


7. Thanks
------------------------

Very big thanks to any 3Dfx fan and 3Dfx Interactive company. We will never forget.

Special thanks:
Taz - for Glide SDKs, almost full Glide games list and a lot more
All users of Zeus Software Forum and e-mail supporters - for testing and suggestions
Gamecollector - for nGlide versus my glide games collection project
DOSBox Crew - for DOSBox - great DOS Emulator (http://www.dosbox.com)
Gulikoza - for DOSBox Glide patch (http://www.si-gamer.net/gulikoza/)
Taewoong Yoo - for DOSBox build with Gulikoza's Glide patch (http://ykhwong.x-y.net)
Cosmic Dan - for DOSBox build with Gulikoza's Glide patch (http://jonus.me)
GALAH - for EA thrash drivers (http://fifa.galahs.com.au)
Nullsoft NSIS - for his great application installer (http://nsis.sourceforge.net)


8. Support & Contact Information
--------------------------------

If you have any problems, suggestions or you want to ask about the wrapper, here are some contact information.

Zeus Software
http://www.zeus-software.com

Email: info@zeus-software.com
Contact form: http://www.zeus-software.com/contacts
Forum: http://www.zeus-software.com/forum


9. Legal
------------------------

nGlide is the property of Zeus Software.

3DfxSpl.dll, 3DfxSpl2.dll and 3DfxSpl3.dll files included with this software (3Dfx Interactive splash logo plugins) are the property of 3Dfx Interactive.