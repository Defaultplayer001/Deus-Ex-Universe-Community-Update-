@ECHO OFF
rem Trying to do a project based on this installer? Feel free to email me directly about it, I made it(with a little(a lot of)) help from my friends! 
rem Defaultplayer001@gmail.com
rem Put the subject as "UPv3 project"

rem Official Deus Ex setup file modification, choices left for fallback, comment out the next line for normal usage.
goto :setsetupflag


Set setup=no
:choice

choice /c ynt /n /t 10 /d n /m "Would you like to install the Deus Ex Demo and Multiplayer files [Y/N]? To install a translation patch, Press T"

IF ERRORLEVEL 3 goto Translations
IF ERRORLEVEL 2 goto No
IF ERRORLEVEL 1 goto Yes

:choice
	
:AllinOne
choice /c yn /n /t 10 /d n /m "Are you sure you want to install everything?[Y/N]?"
IF ERRORLEVEL 2 goto :choice
IF ERRORLEVEL 1 goto :setaioflag

:setsetupflag
Set setup=Yes
goto :no

:yes

choice /c yn /n /t 10 /d n /m "Do not install the Demo and Multiplayer files over a regular install! It WILL break things, do you understand [Y/N]?"
IF ERRORLEVEL 2 goto :choice
IF ERRORLEVEL 1 goto :Yes2

:Translations

rem Translations
Set Translation=Yes
choice /c fgijrs /n /m "Which translation would you like to install, (F)rench, (G)erman, (Italian), (J)apanese, (R)ussian, or (S)panish?"
IF ERRORLEVEL 6 goto :Spanish
IF ERRORLEVEL 5 goto :Russian
IF ERRORLEVEL 4 goto :Japanese
IF ERRORLEVEL 3 goto :Italian
IF ERRORLEVEL 2 goto :German
IF ERRORLEVEL 1 goto :French

rem		French
:French
xcopy "%~dp0\Unofficial Patch v3 Files\Translations\French" "%~dp0" /S /Y
ren "%~dp0\Help\ReadMePatch1.htm" "FrenchReadMePatch1.htm"
echo You have installed the French translation! 
goto :choice

rem		German
:German
xcopy "%~dp0\Unofficial Patch v3 Files\Translations\German" "%~dp0" /S /Y
ren "%~dp0\Help\ReadMePatch1.htm" "GermanReadMePatch1.htm"
echo You have installed the German translation! 
goto :choice

rem		Italian
:Italian
xcopy "%~dp0\Unofficial Patch v3 Files\Translations\Italian" "%~dp0" /S /Y
echo You have installed the Italian translation! 
goto :choice

rem		Japanese
:Japanese
xcopy "%~dp0\Unofficial Patch v3 Files\Translations\Japanese" "%~dp0" /S /Y
ren "%~dp0\Help\ReadMePatch1.htm" "JapaneseReadMePatch1.htm"
echo You have installed the Japanese translation! 
goto :choice

rem		Russian
:Russian
xcopy "%~dp0\Unofficial Patch v3 Files\Translations\Russian" "%~dp0" /S /Y
echo You have installed the Russian translation! 
goto :choice

rem		Spanish
:Spanish
xcopy "%~dp0\Unofficial Patch v3 Files\Translations\Spanish" "%~dp0" /S /Y
echo You have installed the Spanish translation! 
goto :choice			

:Yes2	
rem	Demos
Set Demo=Yes
"%~dp0\Unofficial Patch v3 Files\7z1800\7z.exe" x "%~dp0\Unofficial Patch v3 Files\DeusExDemo.exe" -y
"%~dp0\Unofficial Patch v3 Files\7z1800\7z.exe" x "%~dp0\Unofficial Patch v3 Files\DeusExM02.exe" -y
ren "%~dp0\Help\ReadMe.htm" "ReadMeDemo.htm"
:no

rem Patches
rem		GOTY/Multiplayer
"%~dp0\Unofficial Patch v3 Files\7z1800\7z.exe" x "%~dp0\Unofficial Patch v3 Files\patch1112fm.exe" -y
xcopy "%~dp0\ReleaseMPPatch1112fm\Help\*" "%~dp0\Help\" /y
xcopy "%~dp0\ReleaseMPPatch1112fm\Maps\*" "%~dp0\Maps\" /y
xcopy "%~dp0\ReleaseMPPatch1112fm\System\*" "%~dp0\System\" /y
rmdir "%~dp0\ReleaseMPPatch1112fm" /S /Q

rem		1.110 Maps Patch
"%~dp0\Unofficial Patch v3 Files\7z1800\7z.exe" x "%~dp0\Unofficial Patch v3 Files\Maps Patch\DeusEx_MapsPatch11.7z" -o"%~dp0\Unofficial Patch v3 Files\Maps Patch\DeusEx_MapsPatch11" -y
copy "%~dp0\Unofficial Patch v3 Files\Maps Patch\ReadMe.txt" "%~dp0\Help\Maps Patch ReadMe.txt" /Y
move "%~dp0\Unofficial Patch v3 Files\Maps Patch\DeusEx_MapsPatch11\maps" "%~dp0\maps" /is /it
rmdir "%~dp0\Unofficial Patch v3 Files\Maps Patch\DeusEx_MapsPatch11" /S /Q

rem 	Unofficial Patch v2 *DEMO*
IF "%Demo%"=="Yes" copy "%~dp0\Unofficial Patch v3 Files\Unofficial Patch V2 Demo version\DeusEx.u" "%~dp0\System\DeusEx.u"
IF "%Demo%"=="Yes" copy "%~dp0\Unofficial Patch v3 Files\Unofficial Patch v2\ReadMe.txt" "%~dp0\Help\Unofficial Patch v2 ReadMe.txt" /Y
IF "%Demo%"=="Yes" goto :demoskip 	
rem 	Unofficial Patch v2
"%~dp0\Unofficial Patch v3 Files\7z1800\7z.exe" x "%~dp0\Unofficial Patch v3 Files\Unofficial Patch v2\Unofficial_DeusExV2_v_0.10.zip" -y
copy "%~dp0\Unofficial Patch v3 Files\Unofficial Patch v2\ReadMe.txt" "%~dp0\Help\Unofficial Patch v2 ReadMe.txt" /Y
xcopy "%~dp0\Unofficial Patch v3 Files\Unofficial Patch v2\Unofficial_DeusExV2_v_0.10\*" "%~dp0\System\" /Y /S
rmdir "%~dp0\Unofficial Patch v3 Files\Unofficial Patch v2\Unofficial_DeusExV2_v_0.10" /S /Q

:demoskip

rem		Engine DLL Fix
"%~dp0\Unofficial Patch v3 Files\7z1800\7z.exe" x "%~dp0\Unofficial Patch v3 Files\Engine DLL Fix (Demo Recording Fix)\engine-dll-fix.zip" -o"%~dp0\Unofficial Patch v3 Files\Engine DLL Fix (Demo Recording Fix)\engine-dll-fix" -y
copy "%~dp0\Unofficial Patch v3 Files\Engine DLL Fix (Demo Recording Fix)\ReadMe.txt" "%~dp0\Help\Engine DLL Fix ReadMe.txt" /Y
ren "%~dp0\System\engine.dll" "Engine original.dll"
copy "%~dp0\Unofficial Patch v3 Files\Engine DLL Fix (Demo Recording Fix)\engine-dll-fix\Engine.dll" "%~dp0\System" /Y
rmdir "%~dp0\Unofficial Patch v3 Files\Engine DLL Fix (Demo Recording Fix)\engine-dll-fix" /S /Q

rem		Confix 1.05
IF "%Translation%"=="Yes" goto :skipConfix
copy "%~dp0\Unofficial Patch v3 Files\Confix 1.05\ReadMe.txt" "%~dp0\Help\Confix 1.05 ReadMe.txt" /Y
xcopy "%~dp0\Unofficial Patch v3 Files\Confix 1.05" "%~dp0\System" *.u /y

:skipConfix

rem		OTPUIFix
"%~dp0\Unofficial Patch v3 Files\7z1800\7z.exe" x "%~dp0\Unofficial Patch v3 Files\OTPUIFix.Zip" -o"%~dp0\System" -y
copy "%~dp0\System\OTP UI Fix Readme.txt" "%~dp0\Help\OTP UI Fix Readme.txt" /Y
del "%~dp0\System\OTP UI Fix Readme.txt" /Q

rem EXE's
ren "%~dp0\System\DeusEx.exe" "DeusEx Original.exe"

rem 	Kentie's
"%~dp0\Unofficial Patch v3 Files\7z1800\7z.exe" x "%~dp0\Unofficial Patch v3 Files\Kentie's Deus EXE\DeusExe-v8.1.zip" -o"%~dp0\Unofficial Patch v3 Files\Kentie's Deus EXE\DeusExe-v8.1" -y
ren "%~dp0\Unofficial Patch v3 Files\Kentie's Deus EXE\DeusEx.exe" "DeusEx Kentie's.exe"
copy "%~dp0\Unofficial Patch v3 Files\Kentie's Deus EXE\ReadMe.txt" "%~dp0\Help\Deus EXE ReadMe.txt" /Y
xcopy "%~dp0\Unofficial Patch v3 Files\Kentie's Deus EXE\DeusExe-v8.1" "%~dp0\System" /y
rmdir "%~dp0\Unofficial Patch v3 Files\Kentie's Deus EXE\DeusExe-v8.1"

rem 	Han's
"%~dp0\Unofficial Patch v3 Files\7z1800\7z.exe" x "%~dp0\Unofficial Patch v3 Files\Launch-DeusEx-1112f-20151113.zip" 	-y
ren "%~dp0\Unofficial Patch v3 Files\Hanfling's Launch\Launch-DeusEx-1112f-20151113\Launch.exe" "DeusEx.exe"
copy "%~dp0\Unofficial Patch v3 Files\Hanfling's Launch\Launch-DeusEx-1112f-20151113"  "%~dp0\Help\Launch EXE ReadMe.txt" /Y
del "%~dp0\Unofficial Patch v3 Files\Hanfling's Launch\Launch-DeusEx-1112f-20151113\Launch.txt" /Q
xcopy "%~dp0\Unofficial Patch v3 Files\Hanfling's Launch\Launch-DeusEx-1112f-20151113" "%~dp0\System" /y
rmdir "%~dp0\Unofficial Patch v3 Files\Hanfling's Launch\Launch-DeusEx-1112f-20151113"
rem			Combined int file
ren "%~dp0\System\Deusex.int" "DeusEx original.int"
xcopy "%~dp0\Unofficial Patch v3 Files\Int Files\Combined&updated Deus Ex int file" "%~dp0\System" /y

rem Renderers
rem 	Video
rem 		Nglide
"%~dp0\Unofficial Patch v3 Files\7z1800\7z.exe" x "%~dp0\Unofficial Patch v3 Files\nGlide105_setup.exe" -o"%~dp0\Unofficial Patch v3 Files\nGlide105_setup" -y
rmdir "%~dp0\Unofficial Patch v3 Files\nGlide105_setup\$PLUGINSDIR" /S /Q
xcopy "%~dp0\Unofficial Patch v3 Files\nGlide105_setup"  "%~dp0\System" /y
rmdir "%~dp0\Unofficial Patch v3 Files\nGlide105_setup" /S /Q
copy "%~dp0\System\nglide_readme.txt"  "%~dp0\Help\nGlide ReadMe.txt" /Y
del "%~dp0\System\nglide_readme.txt" /q

rem 		d3d10
"%~dp0\Unofficial Patch v3 Files\7z1800\7z.exe" x "%~dp0\Unofficial Patch v3 Files\d3d10drv-v29.zip" -o"%~dp0\Unofficial Patch v3 Files\d3d10drv-v29" -y
copy "%~dp0\Unofficial Patch v3 Files\d3d10drv-v29\ReadMe.txt"  "%~dp0\Help\D3D10 ReadMe.txt" /Y
xcopy "%~dp0\Unofficial Patch v3 Files\d3d10drv-v29\DeusEx"  "%~dp0\System" /e /y
rmdir "%~dp0\Unofficial Patch v3 Files\d3d10drv-v29\" /S /Q

rem			dxd3d8
"%~dp0\Unofficial Patch v3 Files\7z1800\7z.exe" x "%~dp0\Unofficial Patch v3 Files\DXD3D\dxd3d8r10.zip" -o"%~dp0\Unofficial Patch v3 Files\DXD3D\dxd3d8r10" -y
xcopy "%~dp0\Unofficial Patch v3 Files\DXD3D\dxd3d8r10"  "%~dp0\System" /y
rmdir "%~dp0\Unofficial Patch v3 Files\DXD3D\dxd3d8r10" /S /Q

rem			dxd3d9
"%~dp0\Unofficial Patch v3 Files\7z1800\7z.exe" x "%~dp0\Unofficial Patch v3 Files\DXD3D\dxd3d9r13.zip" -o"%~dp0\Unofficial Patch v3 Files\DXD3D\dxd3d9r13" -y
xcopy "%~dp0\Unofficial Patch v3 Files\DXD3D\dxd3d9r13"  "%~dp0\System" /y
rmdir "%~dp0\Unofficial Patch v3 Files\DXD3D\dxd3d9r13" /S /Q

rem			OpenGl
"%~dp0\Unofficial Patch v3 Files\7z1800\7z.exe" x "%~dp0\Unofficial Patch v3 Files\OpenGL\dxglr21.zip" -o"%~dp0\Unofficial Patch v3 Files\OpenGL\dxglr21" -y
xcopy "%~dp0\Unofficial Patch v3 Files\OpenGL\dxglr21"  "%~dp0\System" /y
rmdir "%~dp0\Unofficial Patch v3 Files\OpenGL\dxglr21" /S /Q
rem			dxd3d8/9/OpenGL readme (cwdohnal)
copy "%~dp0\Unofficial Patch v3 Files\OpenGL\ReadMe.txt"  "%~dp0\Help\D3D8,9,OpenGL ReadMe.txt" /Y


rem		Audio
rem			SwFMOD
"%~dp0\Unofficial Patch v3 Files\7z1800\7z.exe" e "%~dp0\Unofficial Patch v3 Files\SwFMOD_DeusEx_1.0.0.8.exe" -o"%~dp0\Unofficial Patch v3 Files\SwFMOD_DeusEx_1.0.0.8" -y
copy "%~dp0\Unofficial Patch v3 Files\SwFMOD_DeusEx_1.0.0.8\SwFMOD.int.txt"  "%~dp0\Help\SwFMOD ReadMe.txt" /Y
del "%~dp0\Unofficial Patch v3 Files\SwFMOD_DeusEx_1.0.0.8\SwFMOD.int.txt" /Q
xcopy "%~dp0\Unofficial Patch v3 Files\SwFMOD_DeusEx_1.0.0.8\*.*"  "%~dp0\System" /Y
rmdir "%~dp0\Unofficial Patch v3 Files\SwFMOD_DeusEx_1.0.0.8" /S /Q
rem			Fixed int
copy "%~dp0\Unofficial Patch v3 Files\SwFMOD Fixed INT file\SwFMOD.int"  "%~dp0\System" /Y

rem			OpenAL
"%~dp0\Unofficial Patch v3 Files\7z1800\7z.exe" x "%~dp0\Unofficial Patch v3 Files\OpenAL\OpenAL_v2.4.8_DeusEx.7z" -o"%~dp0\Unofficial Patch v3 Files\OpenAL\" -y
copy "%~dp0\Unofficial Patch v3 Files\OpenAL\ReadMe.txt"  "%~dp0\Help\OpenAL ReadMe.txt" /Y
copy "%~dp0\Unofficial Patch v3 Files\OpenAL\OpenAL_v2.4.8_DeusEx\License.txt"  "%~dp0\Help\OpenAL License.txt" /y
del "%~dp0\Unofficial Patch v3 Files\OpenAL\OpenAL_v2.4.8_DeusEx\License.txt" /Q
xcopy "%~dp0\Unofficial Patch v3 Files\OpenAL\OpenAL_v2.4.8_DeusEx"  "%~dp0\System" /y
rmdir "%~dp0\Unofficial Patch v3 Files\OpenAL\OpenAL_v2.4.8_DeusEx" /S /Q

rem		Misc
rem			Antimicro
copy "%~dp0\Unofficial Patch v3 Files\Deus Ex Controller.bat"  "%~dp0\System\Deus Ex Controller.bat" /Y
xcopy "%~dp0\Unofficial Patch v3 Files\antimicro\*"  "%~dp0\System\antimicro\" /e /y

rem			Custom "Augmented" Keybind Ini
IF "%Translation%"=="Yes" (
	goto :skipIni
	)
ren "%~dp0\System\DefUser.ini" "%~dp0\System\DefUser Original.ini"
copy "%~dp0\Unofficial Patch v3 Files\Ini Files\Modernized Keybinds\Augmented\DefUser.ini" "%~dp0\System\DefUser.ini" /Y
:skipini
			
rem			Setup
IF "%setup%"=="No" (
	goto :skipsetup
	)
xcopy "%~dp0\Unofficial Patch v3 Files\setup\*"  "%~dp0\System\" /y	
xcopy "%~dp0\Unofficial Patch v3 Files\Translations\Czech" "%~dp0" /S /Y
xcopy "%~dp0\Unofficial Patch v3 Files\Translations\French" "%~dp0" /S /Y
rem ren "%~dp0\Help\ReadMePatch1.htm" "FrenchReadMePatch1.htm"
xcopy "%~dp0\Unofficial Patch v3 Files\Translations\German" "%~dp0" /S /Y
xcopy "%~dp0\Unofficial Patch v3 Files\Translations\Hungarian" "%~dp0" /S /Y
rem ren "%~dp0\Help\ReadMePatch1.htm" "GermanReadMePatch1.htm"
xcopy "%~dp0\Unofficial Patch v3 Files\Translations\Italian" "%~dp0" /S /Y
xcopy "%~dp0\Unofficial Patch v3 Files\Translations\Polish" "%~dp0" /S /Y
xcopy "%~dp0\Unofficial Patch v3 Files\Translations\Portuguese" "%~dp0" /S /Y
rem ren "%~dp0\Help\ReadMePatch1.htm" "JapaneseReadMePatch1.htm"
xcopy "%~dp0\Unofficial Patch v3 Files\Translations\Russian" "%~dp0" /S /Y
xcopy "%~dp0\Unofficial Patch v3 Files\Translations\Spanish" "%~dp0" /S /Y
"%~dp0\setup.exe"
exit

:skipsetup

@rem Done
echo Complete!
echo The requested files have been installed! 

choice /c yn /n /t 10 /d n /m "Would you like to keep the Unofficial Patch v3 install files? If you do nothing they will be deleted in 10s! [Y/N]?"
IF ERRORLEVEL 2 goto :Delete
IF ERRORLEVEL 1 goto :Keep

:keep
echo The patch files are located where you installed Deus Ex in a folder named "Unofficial Patch v3 Files" 
echo You can reinstall them anytime using the "InstallUnofficialPatchv3.bat" located in your install folder root.
pause
exit

:Delete
@rem Cleanup
rmdir "%~dp0\Unofficial Patch v3 Files" /S /Q
del "%~dp0\InstallUnofficialPatchv3.bat" /Q
exit





