rem Don't use parentheses, breaks things, I don't know why. Probably missing something obvious, let me know if you see it.
rem Special characters either
rem Spaces should be fine. 

set value=YOURMODACRONYMHERE
set Fullvalue=YOUR MOD NAME HERE

rem Change this For a custom developer name.

"%~dp0\fart.exe" "%~dp0\System\Manifest.*" "ION Storm Austin" "%Fullvalue% Devs"

Rem Change if using a language other then English!

set Language=int



"%~dp0\fart.exe" "%~dp0\(Right click to edit this and put in your mod name) Rename Deus Ex Mod.bat" "YOUR MOD NAME HERE" "%CurrDirName%"

"%~dp0\fart.exe" "%~dp0\(Right click to edit this and put in your mod name) Rename Deus Ex Mod.bat" "YOUR MOD NAME HERE" "%CurrDirName%" 

rem Change these 3 manually if using different exe name! (Or just run the bat twice, once to edit names in this, another to properly set.)

ren "%~dp0\System\Deus Ex Mod.exe" "%value%.exe"

ren "%~dp0\System\Deus Ex Mod.int" "%value%.int"

ren "%~dp0\System\Deus Ex Mod.ini" "%value%.ini"

Rem These 3 too if using the community update

ren "%~dp0\System\Deus Ex Mod Community Update.exe" "%value% Community Update.exe"

ren "%~dp0\System\Deus Ex Mod Community Update.int" "%value% Community Update.int"

ren "%~dp0\System\Deus Ex Mod Community Update.ini" "%value% Community Update.ini"

ren "%~dp0\System\Deus Ex Mod Community UpdateDefUser.ini" "%value% Community UpdateDefUser.ini"

Rem I don't know why this is needed, would think the above would work, but it doesn't capture *exact* matches.

Delete if nothing goes wrong 

rem ren "%~dp0\System\Deus Ex Mod.*" "%value%.*?"

"%~dp0\fart.exe" "%~dp0\System\Manifest.ini" "Deus Ex Mod." "%value%."

call "%~dp0\fart.exe" "%~dp0\System\Manifest.%Language%" "Deus Ex Mod" "%Fullvalue%"


rem "%~dp0\fart.exe" "%~dp0\Deus Ex Setup Creator Files Backup\Manifest.*" "Deus Ex Mod" "%value%"

"%~dp0\fart.exe" "%~dp0\ConfigSetupFiles.cfg" "Deus Ex Mod" "%value%" 

rem Prevent issues If the new name contains the old name by changing it specifically.

"%~dp0\fart.exe" "%~dp0\(Right click to edit this and put in your mod name) Rename Deus Ex Mod.bat" "set value=Burden of 80 Proof of 80 Proof of 80 Proof of 80 Proof of 80 Proof" "%value%" 

Rem This sets install path! 

"%~dp0\fart.exe" "%~dp0\*.*" "\DeusExCommunityUpdate\DeusEx" "\Mods\%value%"

rem (Needs to be set last or it interrupts the rest of the script by rewriting *this* file!
"%~dp0\fart.exe" "%~dp0\*.*" "Deus Ex Mod" "%value%" 

