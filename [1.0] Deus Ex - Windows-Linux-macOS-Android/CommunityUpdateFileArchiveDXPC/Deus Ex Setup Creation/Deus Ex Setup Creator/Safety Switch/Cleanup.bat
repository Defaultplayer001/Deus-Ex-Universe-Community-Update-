del "%~dp0\..\*.*"

copy "%~dp0\(R*.*" "%~dp0\.."

copy "%~dp0\ReadMe.txt" "%~dp0\.."

copy "%~dp0\Setup.exe" "%~dp0\.."

rem 7Zip files isolated to make cleanup easier

"%~dp0\Deus Ex Setup Creator Files Backup\7zip Self Extracting EXE Creator\Setup.exe Creator.bat"

"%~dp0\7zip Self Extracting EXE Creator\Setup.exe Creator.bat"