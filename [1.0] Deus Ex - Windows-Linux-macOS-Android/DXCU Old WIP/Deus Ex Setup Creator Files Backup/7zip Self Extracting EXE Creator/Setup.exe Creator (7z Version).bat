del "%~dp0\Deus Ex Community Update.7z"

del "%~dp0\Deus Ex Community Update.temp"

"%~dp0\7z.exe" a "%~dp0\Deus Ex Community Update.7z" "%~dp0\..\.."

"%~dp0..\ResourceHacker.exe" -open "%~dp0\7zSD.sfx" -save "%~dp0\7zSDCustomIcon.sfx" -action addskip -res "%~dp0..\..\Mods\Community Update\Help\DeusExCU.ico" -mask ICONGROUP,MAINICON,

for /f %%x in ('wmic path win32_localtime get /format:list ^| findstr "="') do set %%x
set today=%Year%-%Month%-%Day%

copy /b "%~dp0\7zSDCustomIcon.sfx" + "%~dp0\ConfigSetupFiles.txt" + "%~dp0Deus Ex Community Update.7z" "%~dp0..\..\Deus Ex Community Update Version 2.4 Installer %Year%-%Month%-%Day% %Hour%%Minute%.exe"

pause

rem Final Setup EXE creation complete!

del "%~dp0\Deus Ex Community Update.7z"

del "%~dp0\Deus Ex Community Update.temp"