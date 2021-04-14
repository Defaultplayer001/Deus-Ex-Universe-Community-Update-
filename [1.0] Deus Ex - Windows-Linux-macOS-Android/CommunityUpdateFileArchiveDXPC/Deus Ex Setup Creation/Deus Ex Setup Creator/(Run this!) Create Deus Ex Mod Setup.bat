Rem Safety Switch

Exit

copy "%~dp0\Safety Switch\*.*" "%~dp0\"

for %%I in (.) do set CurrDirName=%%~nxI

"%~dp0\fart.exe" "%~dp0\(Right click to edit this and put in your mod name) Rename Deus Ex Mod.bat" "YOURMODACRONYMHERE" "%CurrDirName:~0,4%" 

"%~dp0\fart.exe" "%~dp0\(Right click to edit this and put in your mod name) Rename Deus Ex Mod.bat" "YOUR MOD NAME HERE" "%CurrDirName%" 

ren "%~dp0\Safety Switch" "Deus Ex Setup Creator Files Backup"

call "%~dp0\Manifest Creation Script.bat"

call "%~dp0\Folderlist.bat"

call "%~dp0\Manifest Merge.bat"

call "%~dp0\(Right click to edit this and put in your mod name) Rename Deus Ex Mod.bat"

Rem Called twice because it doesn't rename everything properly the first time around for some reason. Look at FART documentation, probably missing something. For now this should work fine. 

rem call "%~dp0\(Right click to edit this and put in your mod name) Rename Deus Ex Mod.bat"

copy "%~dp0\(R*.*" "%~dp0\Deus Ex Setup Creator Files Backup" /Y

copy "%~dp0\System\Manifest.int" "%~dp0\Deus Ex Setup Creator Files Backup" /Y

copy "%~dp0\ConfigSetupFiles.cfg" "%~dp0\Deus Ex Setup Creator Files Backup" /Y

copy "%~dp0\Setup.exe Creator.bat" "%~dp0\Deus Ex Setup Creator Files Backup" /Y

copy "%~dp0\Mod Path Script.bat" "%~dp0\Deus Ex Setup Creator Files Backup" /Y

rem copy "%~dp0\(Run this!) Create Deus Ex Mod Setup.bat" "%~dp0\Safety Switch"

rem copy "%~dp0\(Right click to edit this and put in your mod name) Rename Deus Ex Mod.bat" "%~dp0\Safety Switch"

Echo off
Echo Setup creation complete! You may want to test it by running Setup.exe. The following command will archive this folder and create a final distibutable EXE! 
Echo on 

Pause

call "%~dp0\Setup.exe Creator.bat"