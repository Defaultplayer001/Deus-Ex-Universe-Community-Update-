IGNORE THE REST OF THIS IF YOU JUST WANT TO MANUALLY INSTALL THE MOD!
For that simply:

1. Copy the Mods folder into your Deus Ex folder

2. Navigate to Mods\ModName\System

3. Run the exe there to play the mod

4. Optionally, create a shortcut by right clicking the exe. Copying to Desktop / Start Menu if desired

Setup creation instructions below




Note: This ReadMe assumes your mod has already been set up with "Deus Ex Mod Install Framework"

Create / update a mod installer:

1. Right click to edit "(Right click to edit this and put in your mod name) Rename Deus Ex Mod.bat"

2. Edit values as indicated

3. Copy / paste the .bat into the "Safety Switch" / "Deus Ex Setup Creator Files Backup" folder, overwriting when asked

4. Run "(Run this!) Create Deus Ex Mod Setup.bat" (Note: Everything in the root directory will be deleted after manifest creation!)

If no files were ADDED or REMOVED, the following can also simply be done. 
Update a mod installer:

1. Navigate to \Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator

2. Run "Setup.exe Creator.bat"



Update your mod: 

1. Update files in your mods subdirectory by overwriting the old or simply adding if previously not present

2. Double check that the new package actually runs properly before creaing the setup

3. Run "(Run this!) Create Deus Ex Mod Setup.bat" (Note: Everything in the root directory will be deleted after manifest creation!)



Further customize your mod installer: 

1. Edit ini/int files in the "Safety Switch" / "Deus Ex Setup Creator Files Backup" folder, NOT "System"
	Note: Any replaced "Deus Ex Mod" strings will no longer be automatically handled by "-Rename Deus Ex Mod.bat"

2. See "Manifest.ini Usage.txt" for further information

3. Run "(Run this!) Create Deus Ex Mod Setup.bat" (Note: Everything in the root directory will be deleted after manifest creation!)

Add custom header / shortcut icon (2 methods):

1. Replace LogoSmall.bmp  / DeusEx.ico in subdir\Help with your custom one.

2. Add a custom named one to Manifest.int, then add it to subdir\Help (Manifest.ini for shortcut icons)

Really I'd just go with number 1. If this was a root install then number 2 would be your only choice - but eh. Do what's easier.

Replace setup icon:

1. Use Resource Hacker
	http://www.angusj.com/resourcehacker/

To-do:

Rewrite with direct generation of filenames/sizes using %~n1 and %z~I.