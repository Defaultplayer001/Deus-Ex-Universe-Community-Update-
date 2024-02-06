del "%~dp0\..\Deus Ex Setup Creator Files Backup\..\*.*"

copy "%~dp0\(R*.*" "%~dp0\.."

copy "%~dp0\ReadMe.txt" "%~dp0\.."

copy "%~dp0\Setup.exe" "%~dp0\.."

copy "%~dp0\DELETED, everything in this folder will be. -Yoda.txt" "%~dp0\.."

copy "%~dp0\PostExecs\*.*" "%~dp0\.."

rem 7Zip files isolated to make cleanup easier

CHOICE /N /C:123 /M "Press 1 to continue with default 7zip SFX creation, press 2 to continue with Winzip SFX creation, requires a low level directory install to avoid errors, see .bat for details, press 3 to simply build an archive"

IF ERRORLEVEL ==3 GOTO THREE
IF ERRORLEVEL ==2 GOTO TWO
IF ERRORLEVEL ==1 GOTO ONE

:THREE

"%~dp0\7zip Self Extracting EXE Creator\Setup.exe Creator (Manual Winzip Version).bat"

pause

GOTO END

:TWO

"%~dp0\7zip Self Extracting EXE Creator\Setup.exe Creator (Winzip Version).bat"

pause

GOTO END

:ONE

"%~dp0\7zip Self Extracting EXE Creator\Setup.exe Creator (7z Version).bat"

pause

GOTO END

:End
pause