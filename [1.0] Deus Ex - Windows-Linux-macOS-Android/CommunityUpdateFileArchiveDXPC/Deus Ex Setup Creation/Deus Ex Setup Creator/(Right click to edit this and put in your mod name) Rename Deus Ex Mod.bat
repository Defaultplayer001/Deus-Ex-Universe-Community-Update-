rem Don't use parentheses, breaks things, I don't know why. Probably missing something obvious, let me know if you see it.
rem Special characters either
rem Spaces should be fine. 
rem Replace everything after "="

set Fullvalue=ModTitle
set DevName=YourName

rem Keep the following single words
set value=ModAcronym
rem Leave empty if using the root / not using a subdir, also make sure to disable the del command for systemfileslist.txt at the top of Manifest Merge.bat
set Subvalue=ModSubdirectory
set EXEvalue=EXEName
set Language=int
set version=ModVersion



rem For further customizations, edit ini/int files in Safety Switch / Deus Ex Setup Creator Files Backup
rem See "Manifest.ini Usage.txt" for further information.









rem Don't change any of the following unless you know what you're doing!

rem Changes developer name
"%~dp0\fart.exe" "%~dp0\system\Manifest.*" "ION Storm Austin" "%DevName%"


rem Change mod name in manifest.ini
call "%~dp0\fart.exe" "%~dp0\System\Manifest.ini" "DeusExModString" "%value%"

rem Change mod name in manifest.int
call "%~dp0\fart.exe" "%~dp0\System\Manifest.%Language%" "Deus Ex Mod" "%Fullvalue%"
rem "%~dp0\fart.exe" "%~dp0\Deus Ex Setup Creator Files Backup\Manifest.*" "Deus Ex Mod" "%Fullvalue%"


Rem Adds custom subdir to manifestheader.ini
"%~dp0\fart.exe" "%~dp0\System\Manifest.ini" "subdir" "%Subvalue%"

rem Remove Substring from any optional file entries, needs to be set BEFORE custom subdir write or it will DELETE it. 
rem Remove any backslash from value for writing a file name
set SubvalueSafe=%Subvalue:\=%
"%~dp0\fart.exe" "%~dp0\System\Manifest.%Language%" "Caption=%SubvalueSafe%" "Caption="

echo %SubvalueSafe%

pause

Rem Adds custom subdir to manifest.int
"%~dp0\fart.exe" "%~dp0\system\Manifest.int" "subdir" "%Subvalue%"


Rem Changes EXE name in the manifest
"%~dp0\fart.exe" "%~dp0\System\Manifest.ini" "DeusExModEXEString.exe" "%EXEvalue%.exe"

Rem Changes version number
"%~dp0\fart.exe" "%~dp0\System\Manifest.ini" "1300u" "%Version%"

rem 7Zip files isolated to make cleanup easier
"%~dp0\fart.exe" "%~dp0\Safety Switch\7zip Self Extracting EXE Creator\*.*" "Deus Ex Mod" "%value%" 
"%~dp0\fart.exe" "%~dp0\Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator\*.*" "Deus Ex Mod" "%value%" 
"%~dp0\fart.exe" "%~dp0\Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator\*.*" "DeusExModFullName" "%Fullvalue%" 
"%~dp0\fart.exe" "%~dp0\Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator\*.*" "subdir" "%Subvalue%"

Rem Rename anything not caught in the previous step (Set last JIC, had issues with it rewriting THIS .bat before. Experiment with.)
"%~dp0\fart.exe" "%~dp0\*.*" "Deus Ex Mod" "%value%" 