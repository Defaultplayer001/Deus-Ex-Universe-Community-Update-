rem Renaming THIS file to anything but "(Right click to edit this and put in your mod name) Rename Deus Ex Mod.bat" will cause things to break. Hindsight 20/20, I realize those instructions are kinda confusing; will eventually be not lazy and change "name" to "details". That probably works better.
rem Don't use parentheses, breaks things, I don't know why. Probably missing something obvious, let me know if you see it.
rem Special characters either
rem Spaces should be fine. 
rem Replace everything after "="

set Fullvalue=ModTitle
set DevName=YourName

rem Leave empty if using the root / not using a subdir, also make sure to disable the del command for systemfileslist.txt at the top of Manifest Merge.bat
By default setup for mods to be in a Mods\ directory,
rem Use a period "." for a root install.
set Subvalue=Mods\ModSubdirectory
rem .exe not necessary and will actually mess things up, just put the name!
set EXEvalue=EXEName
set version=ModVersion
rem For changing link urls, manually edit the manifest.int for now.




rem For further customizations, edit ini/int files in Safety Switch / Deus Ex Setup Creator Files Backup
rem See "Manifest.ini Usage.txt" for further information.









rem Don't change any of the following unless you know what you're doing!

rem Changes developer name
"%~dp0\fart.exe" "%~dp0\system\Manifest.*" "ION Storm Austin" "%DevName%"


rem Change mod name in manifest.ini
call "%~dp0\fart.exe" "%~dp0\System\Manifest.ini" "DeusExModString" "%Fullvalue%"

rem Change mod name in manifest.int
"%~dp0\fart.exe" "%~dp0\System\Manifest.int" "Deus Ex Mod" "%Fullvalue%"
rem "%~dp0\fart.exe" "%~dp0\Deus Ex Setup Creator Files Backup\Manifest.*" "Deus Ex Mod" "%Fullvalue%"


Rem Adds custom subdir to manifestheader.ini
"%~dp0\fart.exe" "%~dp0\System\Manifest.ini" "subdir" "%Subvalue%"

rem Remove Substring from any optional file entries, needs to be set BEFORE custom subdir write or it will DELETE it. 
rem Remove any backslash from value for writing a file name
set SubvalueSafe=%Subvalue:\=%
"%~dp0\fart.exe" "%~dp0\System\Manifest.int" "Caption=%SubvalueSafe%" "Caption="

echo %SubvalueSafe%


Rem Adds custom subdir to manifest.int
"%~dp0\fart.exe" "%~dp0\system\Manifest.int" "subdir" "%Subvalue%"


Rem Changes EXE name in the manifest
"%~dp0\fart.exe" "%~dp0\System\Manifest.ini" "DeusExModEXEString" "%EXEvalue%"

Rem Changes version number
"%~dp0\fart.exe" "%~dp0\System\Manifest.ini" "1300u" "%Version%"

Rem Removes any question marks from the name string before writing files, since they aren't allowed filename characters.
Rem Added specifically for Vanilla? Madders.
set FullvalueSafe=%Fullvalue:?=%
set FullvalueSafe=%FullvalueSafe:.=%

Rem 7Zip files isolated to make cleanup easier
"%~dp0\fart.exe" "%~dp0\Safety Switch\7zip Self Extracting EXE Creator\*.*" "Deus Ex Mod" "%FullvalueSafe%" 
"%~dp0\fart.exe" "%~dp0\Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator\*.*" "Deus Ex Mod" "%FullvalueSafe%"
"%~dp0\fart.exe" "%~dp0\Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator\*.*" "VersionString" "%version%" 
"%~dp0\fart.exe" "%~dp0\Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator\*.*" "DeusExModFullName" "%FullvalueSafe%" 
"%~dp0\fart.exe" "%~dp0\Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator\*.*" "subdir" "%Subvalue%"
"%~dp0\fart.exe" "%~dp0\Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator\SteamProxy.bat" "DeusEx" "%EXEvalue%"

Rem Steam Proxy customization
"%~dp0\Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator\7z.exe" a "%~dp0\Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator\SteamProxy.7z" "%~dp0\Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator\SteamProxy.bat"

"%~dp0\Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator\SystemFilesCreatorSteamProxy.bat"
