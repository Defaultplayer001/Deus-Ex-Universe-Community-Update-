del "%~dp0\DXCU.7z"

del "%~dp0\DXCU.temp"

"%~dp0\7z.exe" a "%~dp0\DXCU.7z" "%~dp0\..\.."

copy /b "%~dp0\7zSD.sfx" + "%~dp0\ConfigSetupFiles.txt" + "%~dp0DXCU.7z" "%~dp0..\..\DXCU.exe"

pause

rem Final Setup EXE creation complete!

del "%~dp0\DXCU.7z"

del "%~dp0\DXCU.temp"

for /f %%x in ('wmic path win32_localtime get /format:list ^| findstr "="') do set %%x
set today=%Year%-%Month%-%Day%

"%~dp0..\ResourceHacker.exe" -open "%~dp0..\..\DXCU.exe" -save "%~dp0..\..\Deus Ex Community Update 2.0 Installer %Year%-%Month%-%Day% %Hour%%Minute%.exe" -action addskip -res "%~dp0..\..\Mods\Community Update\Help\DeusEx.ico" -mask ICONGROUP,MAINICON,

del "%~dp0..\..\DXCU.exe"