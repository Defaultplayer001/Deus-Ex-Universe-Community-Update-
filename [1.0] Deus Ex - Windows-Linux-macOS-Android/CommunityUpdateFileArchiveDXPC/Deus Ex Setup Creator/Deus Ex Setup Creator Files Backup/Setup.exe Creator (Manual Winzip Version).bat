del "%~dp0\..\..\A.zip"

del "%~dp0\A.temp"

"%~dp0\7z.exe" a "%~dp0\..\..\A.zip" "%~dp0\..\.."

rem Final Setup archive creation complete! Continue with Winzip SFX!

pause