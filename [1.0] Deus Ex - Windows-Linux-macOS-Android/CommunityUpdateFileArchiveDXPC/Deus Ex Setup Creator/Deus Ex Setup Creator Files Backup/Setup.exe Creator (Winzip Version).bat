del "%~dp0\..\..\A.zip"

del "%~dp0\A.temp"

"%~dp0\7z.exe" a "%~dp0\..\..\A.zip" "%~dp0\..\.."

for /f %%x in ('wmic path win32_localtime get /format:list ^| findstr "="') do set %%x
set today=%Year%-%Month%-%Day%

copy "%~dp0\..\..\..\Winzip SFX for Deus Ex\WZIPSE32.exe"  "%~dp0\..\..\"
copy "%~dp0\..\..\..\Winzip SFX for Deus Ex\WINZIPSE.HLP"  "%~dp0\..\..\"
copy "%~dp0\..\..\..\Winzip SFX for Deus Ex\winzipse.dat"  "%~dp0\..\..\"
copy "%~dp0\..\..\..\Winzip SFX for Deus Ex\winzipse.ini"  "%~dp0\..\..\"
copy "%~dp0\..\WINZIPSE.DIZ"  "%~dp0\..\..\"
copy "%~dp0\..\..\..\Winzip SFX for Deus Ex\Deus Ex Setup CU.ico"  "%~dp0\..\..\"


cd "%~dp0\..\..\"


"WZIPSE32.exe" "A.zip"  -y -i "Deus Ex Setup CU.ico" -win32 -c setup

rem Exe created! (Pause inserted here to let the exe finish being made before rename)

pause

ren "%~dp0\..\..\A.exe" "DeusExModFullName VersionString %Year%-%Month%-%Day% %Hour%%Minute%.exe"
pause

rem Final Setup EXE creation complete!	

del "%~dp0\..\..\A.zip"
del "%~dp0\..\..\WZIPSE32.exe"
del "%~dp0\..\..\WINZIPSE.HLP"
del "%~dp0\..\..\winzipse.dat"
del "%~dp0\..\..\winzipse.ini"
del "%~dp0\..\..\WINZIPSE.DIZ"
del "%~dp0\..\..\Deus Ex Setup CU.ico"

del "%~dp0\A.temp"