del "%~dp0\..\..\A.zip"

del "%~dp0\A.temp"

"%~dp0\7z.exe" a "%~dp0\..\..\A.zip" "%~dp0\..\.."

for /f %%x in ('wmic path win32_localtime get /format:list ^| findstr "="') do set %%x
set today=%Year%-%Month%-%Day%

ren "%~dp0\..\..\A.zip" "DXCU 2.4.2 %Year%-%Month%-%Day% %Hour%%Minute%.zip"

rem Final Setup archive creation complete! Continue with Winzip SFX!

pause