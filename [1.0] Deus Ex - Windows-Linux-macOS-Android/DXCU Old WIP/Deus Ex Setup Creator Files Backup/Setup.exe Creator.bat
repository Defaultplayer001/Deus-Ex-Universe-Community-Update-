del "%~dp0\A.zip"

del "%~dp0\A.temp"

"%~dp0\7z.exe" a "%~dp0\A.zip" "%~dp0\..\.."

for /f %%x in ('wmic path win32_localtime get /format:list ^| findstr "="') do set %%x
set today=%Year%-%Month%-%Day%

"%~dp0\WZIPSE32.exe" "%~dp0\A.zip" -y -win32 -c setup

ren "%~dp0\A.exe" "DeusExModFullName Version 2.4 Installer %Year%-%Month%-%Day% %Hour%%Minute%.zip"
pause

rem Final Setup EXE creation complete!

del "%~dp0\A.zip"

del "%~dp0\A.temp"