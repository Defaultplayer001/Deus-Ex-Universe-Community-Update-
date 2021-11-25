@echo Safety Switch

Pause

exit

copy "%~dp0\Safety Switch\*.*" "%~dp0\" /y

copy "%~dp0\Deus Ex Setup Creator Files Backup\*.*" "%~dp0\" /y

copy "%~dp0\Deus Ex Setup Creator Files Backup\ConfigSetupFiles.txt" "%~dp0\Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator" /y

copy "%~dp0\Deus Ex Setup Creator Files Backup\Setup.exe Creator.bat" "%~dp0\Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator" /y

copy "%~dp0\Deus Ex Setup Creator Files Backup\SteamProxy.bat" "%~dp0\Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator" /y

copy "%~dp0\Deus Ex Setup Creator Files Backup\SystemFilesCreatorSteamProxy.bat" "%~dp0\Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator" /y

copy "%~dp0\Deus Ex Setup Creator Files Backup\ConfigSteamProxy.txt" "%~dp0\Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator" /y

for %%I in (.) do set CurrDirName=%%~nxI

"%~dp0\fart.exe" "%~dp0\(Right click to edit this and put in your mod name) Rename Deus Ex Mod.bat" "ModAcronym" "%CurrDirName:~0,4%" 

"%~dp0\fart.exe" "%~dp0\(Right click to edit this and put in your mod name) Rename Deus Ex Mod.bat" "ModTitle" "%CurrDirName%" 

ren "%~dp0\Safety Switch" "Deus Ex Setup Creator Files Backup"

call "%~dp0\Manifest Creation Script.bat"

call "%~dp0\Folderlist.bat"

call "%~dp0\Manifest Merge.bat"

call "%~dp0\(Right click to edit this and put in your mod name) Rename Deus Ex Mod.bat"



@echo Setup creation complete! You may want to test it by running Setup.exe. The following command will archive this folder and create a final distibutable EXE!  


Pause

"%~dp0\Deus Ex Setup Creator Files Backup\Cleanup.bat"