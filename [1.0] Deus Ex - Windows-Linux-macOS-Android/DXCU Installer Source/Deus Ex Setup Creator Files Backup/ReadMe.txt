IGNORE THE REST OF THIS IF YOU JUST WANT TO MANUALLY INSTALL THE MOD!
For that simply:

1. Copy the Mods folder into your Deus Ex folder = Or any folder, if you want to use the demo / try a portable install (Make sure the redundant paths in default.ini lead to an actual game path on your system! If not add a FULL game path, drive included.)
	If you don't want to play the demo, delete Mods\Community Update\Optional Files\Demo.
		Otherwise the mod will end after the second mission is complete.

2. Navigate to Mods\Community Update\System

3. Run the exe there to play the mod

4. Optionally, create a shortcut by right clicking the exe. Copying to Desktop / Start Menu if desired


To enable Confix, for English / Russian users only: 

1. Navigate to Mods\Community Update

2. Run "Confix Enable.exe" or "Confix Enable (Russian).exe". This will paste over an ini with the Confix folder in it's pathlist. Otherwise identical to the current one.
	Note that this will overrite your current default.ini, and won't take effect until you delete your current "Deus Ex Community Update.ini"! 
	

To change langauge:

1. Open "Deus Ex Community Update.int". (Default.ini as well if you want to change the default setting.)

2. Change Language=int into the desired language code:
;DXCU=English (Use "Confix Enable.exe" to enable Confix. DeusEx.u renamed to .DXCU for HUT compatibility reasons. Other files likewise kept as .int files to not break standard ompatibility.) 
;czt=Cestina
;det=Deutsch 
;est=Espanol
;frt=Francais
;itt=Italiano
;hut=magyar
;plt=Polskie
;ptt=Portugues
;rut=Russian (Use "Confix Enable (Russian).exe" to enable the Confix port.)
;jpt=Nihongo (Use SystemFilesJPT.exe instead to create a shortcut DeusEx.exe to the custom port, under Mods/Japanese Port)


Setup creation instructions below


Community Update Manual customization notes:

Everything automated currently! 

Don't forget if you wanna generate a new manifest group list you'll need to edit Manifest Merge.bat.

Oh and anything in the optional files with "Demo" in the folder name gets seletected=false! (Could probably automate this and insert it into the main setup creator. Maybe instead of demo, a "false" string or somethin' that gets deleted before writing the name.)

Keeping this section to make those notes and for when it is inevitably needed again.




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

Make installer defaults and manual install defaults match.
