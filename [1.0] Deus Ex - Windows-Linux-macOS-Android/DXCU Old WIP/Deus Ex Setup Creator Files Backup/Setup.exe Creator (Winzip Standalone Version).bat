


for /f %%x in ('wmic path win32_localtime get /format:list ^| findstr "="') do set %%x
set today=%Year%-%Month%-%Day%


"WZIPSE32.exe" "A.zip"  -y -i "Deus Ex Setup CU.ico" -win32 -c setup

ren "%~dp0\A.exe" "DXCU 2.4.2 %Year%-%Month%-%Day% %Hour%%Minute%.exe"
rem Winzip SFX Creation Complete!
pause

del "%~dp0\A.zip"
del "%~dp0\WZIPSE32.exe"
del "%~dp0\WINZIPSE.HLP"
del "%~dp0\winzipse.dat"
del "%~dp0\winzipse.ini"
del "%~dp0\WINZIPSE.DIZ"
del "%~dp0\Deus Ex Setup CU.ico"