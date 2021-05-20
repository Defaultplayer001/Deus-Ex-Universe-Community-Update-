IGNORE THE REST OF THIS IF YOU JUST WANT TO MANUALLY INSTALL THE MOD!
For that simply:

1. Copy the Mods folder into your Deus Ex folder
	If you don't want to play the demo, delete Mods\Community Update\Optional Files\Demo.
		Otherwise the mod will end after the second mission is complete.

2. Navigate to Mods\Community Update\System

3. Run the exe there to play the mod

4. Optionally, create a shortcut by right clicking the exe. Copying to Desktop / Start Menu if desired


To enable Confix, for English users only: 

1. Navigate to Mods\Community Update

2. Run "Confix Enable.exe". This will paste over an ini with the Confix folder in it's pathlist. Otherwise identical to the current one.


To change langauge:

1. Open "Deus Ex Community Update.int". (Default.ini as well if you want to change the default setting.)

2. Change Language=int into the desired language code:
	czt=Cestina
	int=English
	det=Deutsch 
	est=Espanol
	frt=Francais
	itt=Italiano
	hut=magyar
	plt=Polskie
	ptt=Portugues
	rut=Russian
	jpt=Japanese




Setup creation instructions below


Community Update Manual customization notes:

1. Delete "Confix Enable.exe" and "SystemFilesJPT.exe" from GameGroup in Manifest.ini. 

2. Add Selected=False to the Demo group.




Note: This ReadMe assumes your mod has already been set up with "DXCU Install Framework"

Create / update a mod installer:

1. Right click to edit "(Right click to edit this and put in your mod name) Rename DXCU.bat"

2. Edit values as indicated

3. Copy / paste the .bat into the "Safety Switch" / "Deus Ex Setup Creator Files Backup" folder, overwriting when asked

4. Run "(Run this!) Create DXCU Setup.bat"



Update your mod: 

1. Update files in your mods subdirectory by overwriting the old or simply adding if previously not present

2. Double check that the new package actually runs properly before creaing the setup

3. Run "(Run this!) Create DXCU Setup.bat"



Further customize your mod installer: 

1. Edit ini/int files in the "Safety Switch" / "Deus Ex Setup Creator Files Backup" folder, NOT "System"
	Note: Any replaced "DXCU" strings will no longer be automatically handled by "-Rename DXCU.bat"

2. See "Manifest.ini Usage.txt" for further information

3. Run "(Run this!) Create DXCU Setup.bat"

Add custom header / shortcut icon (2 methods):

1. Replace LogoSmall.bmp  / DeusEx.ico in subdir\Help with your custom one.

2. Add a custom named one to Manifest.int, then add it to subdir\Help (Manifest.ini for shortcut icons)

Really I'd just go with number 1. If this was a root install then number 2 would be your only choice - but eh. Do what's easier.

Replace setup icon:

1. Use Resource Hacker
	http://www.angusj.com/resourcehacker/