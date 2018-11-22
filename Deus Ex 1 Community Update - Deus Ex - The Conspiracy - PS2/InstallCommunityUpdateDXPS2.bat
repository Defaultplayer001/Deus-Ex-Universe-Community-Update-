@ECHO OFF
rem Trying to do a project based on this installer? Feel free to email me directly about it, I made it(with a little(a lot of)) help from my friends! 
rem Defaultplayer001@gmail.com
rem Put the subject as "UPv3 project"

rem Official Deus Ex setup file modification, choices left for fallback, comment out the next line for normal usage.
rem goto :setsetupflag
rem PS2 setup version! 
goto :setps2setupflag

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
Set Translation=Yes
goto :yes2 

:setps2setupflag
Set PS2setup=Yes
goto :yesps2 

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
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Translations\French" "%~dp0" /S /Y
ren "%~dp0\Help\ReadMePatch1.htm" "FrenchReadMePatch1.htm"
echo You have installed the French translation! 
goto :choice

rem		German
:German
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Translations\German" "%~dp0" /S /Y
ren "%~dp0\Help\ReadMePatch1.htm" "GermanReadMePatch1.htm"
echo You have installed the German translation! 
goto :choice

rem		Italian
:Italian
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Translations\Italian" "%~dp0" /S /Y
echo You have installed the Italian translation! 
goto :choice

rem		Japanese
:Japanese
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Translations\Japanese" "%~dp0" /S /Y
ren "%~dp0\Help\ReadMePatch1.htm" "JapaneseReadMePatch1.htm"
echo You have installed the Japanese translation! 
goto :choice

rem		Russian
:Russian
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Translations\Russian" "%~dp0" /S /Y
echo You have installed the Russian translation! 
goto :choice

rem		Spanish
:Spanish
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Translations\Spanish" "%~dp0" /S /Y
echo You have installed the Spanish translation! 
goto :choice			

:Yes2	
rem	Demos
Set Demo=Yes
rem Extract the demo exe compressed due to github size restrictions 2018/11/12
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\DeusExDemo.7z.001" -o"%~dp0\CommunityUpdateFileArchiveDXPS2\" -y
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\DeusExDemo.exe" -y
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\DeusExM02.exe" -o"%~dp0\" -y
ren "%~dp0\Help\ReadMe.htm" "ReadMeDemo.htm"
del "%~dp0\CommunityUpdateFileArchiveDXPS2\DeusExDemo.7z.001" /Q
del "%~dp0\CommunityUpdateFileArchiveDXPS2\DeusExDemo.7z.002" /Q
:no

rem Patches
rem		GOTY/Multiplayer
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\patch1112fm.exe" -o"%~dp0\CommunityUpdateFileArchiveDXPS2\" -y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\ReleaseMPPatch1112fm\Help\*" "%~dp0\Help\" /y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\ReleaseMPPatch1112fm\Maps\*" "%~dp0\Maps\" /y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\ReleaseMPPatch1112fm\System\*" "%~dp0\System\" /y
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\ReleaseMPPatch1112fm\setup.exe" "%~dp0" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPS2\ReleaseMPPatch1112fm" /S /Q

rem :IF "%setup%"=="No" (
rem :	goto :skipmapspatch
rem :	)
	
rem		1.110 Maps Patch
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\Maps Patch\DeusEx_MapsPatch11.7z" -o"%~dp0\CommunityUpdateFileArchiveDXPS2\Maps Patch\DeusEx_MapsPatch11" -y
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\Maps Patch\ReadMe.txt" "%~dp0\Help\Maps Patch ReadMe.txt" /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Maps Patch\DeusEx_MapsPatch11\maps" "%~dp0\maps" /Y /S
rmdir "%~dp0\CommunityUpdateFileArchiveDXPS2\Maps Patch\DeusEx_MapsPatch11" /S /Q
rem del "%~dp0\CommunityUpdateFileArchiveDXPS2\Maps Patch\DeusEx_MapsPatch11\Instructions.txt" /Q
rem 1002f Supplemental 
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\Maps Patch\DeusExMapsPatchVanillaSupplemental.7z" -y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Maps Patch\DeusExMapsPatchVanillaSupplemental\maps" "%~dp0\maps" /Y /S
rmdir "%~dp0\CommunityUpdateFileArchiveDXPS2\Maps Patch\DeusExMapsPatchVanillaSupplemental" /S /Q

rem :skipmapspatch

IF "%setup%"=="No" (
	goto :demoskip
	)

rem 	Unofficial Patch v2 *DEMO*
IF "%Demo%"=="Yes" copy "%~dp0\CommunityUpdateFileArchiveDXPS2\Unofficial Patch V2 Demo version\DeusEx.u" "%~dp0\System\DeusEx.u"
IF "%Demo%"=="Yes" copy "%~dp0\CommunityUpdateFileArchiveDXPS2\Unofficial Patch v2\ReadMe.txt" "%~dp0\Help\Unofficial Patch v2 ReadMe.txt" /Y
IF "%Demo%"=="Yes" goto :demoskip 	
rem 	Unofficial Patch v2
:Now using an edited version of UPV2 by default
:"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\Unofficial Patch v2\Unofficial_DeusExV2_v_0.10.zip" -y
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\Unofficial Patch V2 edited render relaunch\ReadMe.txt" "%~dp0\Help\Unofficial Patch V2 edited render relaunch ReadMe.txt" /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Unofficial Patch V2 edited render relaunch\Unofficial_DeusExV2_v_0.10\*" "%~dp0\System\" /Y /S
rmdir "%~dp0\CommunityUpdateFileArchiveDXPS2\Unofficial Patch V2 edited render relaunch\Unofficial_DeusExV2_v_0.10" /S /Q

:demoskip

rem		Engine DLL Fix
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\Engine DLL Fix (Demo Recording Fix)\engine-dll-fix.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPS2\Engine DLL Fix (Demo Recording Fix)\engine-dll-fix" -y
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\Engine DLL Fix (Demo Recording Fix)\ReadMe.txt" "%~dp0\Help\Engine DLL Fix ReadMe.txt" /Y
ren "%~dp0\System\engine.dll" "Engine original.dll"
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\Engine DLL Fix (Demo Recording Fix)\engine-dll-fix\Engine.dll" "%~dp0\System" /Y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPS2\Engine DLL Fix (Demo Recording Fix)\engine-dll-fix" /S /Q

rem		Confix 1.05
IF "%Translation%"=="Yes" goto :skipConfix
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\Confix 1.05\ReadMe.txt" "%~dp0\Help\Confix 1.05 ReadMe.txt" /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Confix 1.05" "%~dp0\System" *.u /y

:skipConfix

rem		OTPUIFix
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\OTPUIFix.Zip" -o"%~dp0\System" -y
copy "%~dp0\System\OTP UI Fix Readme.txt" "%~dp0\Help\OTP-UI-Fix-Readme.txt" /Y
del "%~dp0\System\OTP UI Fix Readme.txt" /Q

rem EXE's
ren "%~dp0\System\DeusEx.exe" "DeusEx Original.exe"

rem 	Kentie's
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\Kentie's Deus EXE\DeusExe-v8.1.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPS2\Kentie's Deus EXE\DeusExe-v8.1" -y
ren "%~dp0\CommunityUpdateFileArchiveDXPS2\Kentie's Deus EXE\DeusExe-v8.1\DeusEx.exe" "DeusEx Kentie's.exe"
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\Kentie's Deus EXE\ReadMe.txt" "%~dp0\Help\Deus EXE ReadMe.txt" /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Kentie's Deus EXE\DeusExe-v8.1" "%~dp0\System" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPS2\Kentie's Deus EXE\DeusExe-v8.1" /S /Q

rem 	Han's
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\Hanfling's Launch\Launch-DeusEx-1112f-20180729.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPS2\Hanfling's Launch\Launch-DeusEx-1112f-20180729" -y
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\Hanfling's Launch\Launch-DeusEx-1112f-20180729\ReadMe.txt"  "%~dp0\Help\Launch EXE ReadMe.txt" /Y
del "%~dp0\CommunityUpdateFileArchiveDXPS2\Hanfling's Launch\Launch-DeusEx-1112f-20180729\Launch.txt" /Q
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Hanfling's Launch\Launch-DeusEx-1112f-20180729" "%~dp0\System" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPS2\Hanfling's Launch\Launch-DeusEx-1112f-20180729" /S /Q
del "%~dp0\System\DeusEx.exe" /Q
ren "%~dp0\System\Launch.exe" "DeusEx.exe"
ren "%~dp0\System\UCC.exe" "%~dp0\System\UCC Original.exe"
ren "%~dp0\System\LCC.exe" "%~dp0\System\UCC.exe"
rem			Combined int file
ren "%~dp0\System\Deusex.int" "DeusEx original.int"
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Int Files\Combined&updated Deus Ex int file" "%~dp0\System" /y

rem Renderers
rem 	Video
rem 		Nglide
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\nGlide105_setup.exe" -o"%~dp0\CommunityUpdateFileArchiveDXPS2\nGlide105_setup" -y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPS2\nGlide105_setup\$PLUGINSDIR" /S /Q
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\nGlide105_setup"  "%~dp0\System" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPS2\nGlide105_setup" /S /Q
copy "%~dp0\System\nglide_readme.txt"  "%~dp0\Help\nGlide-ReadMe.txt" /Y
del "%~dp0\System\nglide_readme.txt" /q

rem 		d3d10
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\d3d10drv-v29.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPS2\d3d10drv-v29" -y
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\d3d10drv-v29\ReadMe.txt"  "%~dp0\Help\D3D10-ReadMe.txt" /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\d3d10drv-v29\DeusEx"  "%~dp0\System" /e /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPS2\d3d10drv-v29\" /S /Q
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Int Files\Typo Fixed D3D10Drv Int" "%~dp0\System" /y

rem			dxd3d9
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\DXD3D\dxd3d9r13.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPS2\DXD3D\dxd3d9r13" -y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\DXD3D\dxd3d9r13"  "%~dp0\System" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPS2\DXD3D\dxd3d9r13" /S /Q
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\DXD3D\ReadMe.txt"  "%~dp0\Help\dxd3d9&10-ReadMe.txt" /Y

rem			dxd3d8
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\DXD3D\dxd3d8r10.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPS2\DXD3D\dxd3d8r10" -y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\DXD3D\dxd3d8r10"  "%~dp0\System" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPS2\DXD3D\dxd3d8r10" /S /Q

rem			OpenGl
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\OpenGL\dxglr21.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPS2\OpenGL\dxglr21" -y
ren "%~dp0\System\OpenGLDrv.dll" "%~dp0\System\OpenGLDrv Original.dll"
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\OpenGL\dxglr21"  "%~dp0\System" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPS2\OpenGL\dxglr21" /S /Q
rem			dxd3d8/9/OpenGL readme (cwdohnal)
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\OpenGL\ReadMe.txt"  "%~dp0\Help\D3D8,9,OpenGL ReadMe.txt" /Y


rem		Audio
rem			OpenAL
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\OpenAL\OpenAL_v2.4.8_DeusEx.7z" -o"%~dp0\CommunityUpdateFileArchiveDXPS2\OpenAL\" -y
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\OpenAL\ReadMe.txt"  "%~dp0\Help\OpenAL-ReadMe.txt" /Y
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\OpenAL\OpenAL_v2.4.8_DeusEx\License.txt"  "%~dp0\Help\OpenAL-License.txt" /y
del "%~dp0\CommunityUpdateFileArchiveDXPS2\OpenAL\OpenAL_v2.4.8_DeusEx\License.txt" /Q
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\OpenAL\OpenAL_v2.4.8_DeusEx"  "%~dp0\System" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPS2\OpenAL\OpenAL_v2.4.8_DeusEx" /S /Q

rem			SwFMOD
rem Move to int file older
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" e "%~dp0\CommunityUpdateFileArchiveDXPS2\SwFMOD_DeusEx_1.0.0.8.exe" -o"%~dp0\CommunityUpdateFileArchiveDXPS2\SwFMOD_DeusEx_1.0.0.8" -y
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\SwFMOD_DeusEx_1.0.0.8\SwFMOD.int.txt"  "%~dp0\Help\SwFMOD-ReadMe.txt" /Y
del "%~dp0\CommunityUpdateFileArchiveDXPS2\SwFMOD_DeusEx_1.0.0.8\SwFMOD.int.txt" /Q
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\SwFMOD_DeusEx_1.0.0.8\*.*"  "%~dp0\System" /Y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPS2\SwFMOD_DeusEx_1.0.0.8" /S /Q
rem			Fixed int
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\Int Files\SwFMOD Fixed INT file\SwFMOD.int"  "%~dp0\System" /Y

rem		Multiplayer

rem			DXMTL
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\DXMTL-v152b1 Installed files\Help\readme_dxmtl.txt"  "%~dp0\Help\DXMTL-ReadMe.txt" /Y
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\DXMTL-v152b1 Installed files\Help\license_dxmtl.txt"  "%~dp0\Help\DXMTL-License.txt" /Y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPS2\DXMTL-v152b1 Installed files\Help" /S /Q
del "%~dp0\CommunityUpdateFileArchiveDXPS2\DXMTL-v152b1 Installed files\System\DeusEx.ini" /Q
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\DXMTL-v152b1 Installed files" "%~dp0" /y /s

Rem			Nephthys
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\Nephthys\Nephthys_v1.4b10_inst.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPS2\Nephthys\Nephthys_v1.4b10_inst" -y
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\Nephthys\Nephthys_v1.4b10_inst\Nephthys_v1.4b10_inst.exe" -o"%~dp0\CommunityUpdateFileArchiveDXPS2\Nephthys\Nephthys_v1.4b10_inst\Nephthys_v1.4b10_inst" -y
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\Nephthys\ReadMe.txt"  "%~dp0\Help\Nephthys-ReadMe.txt" /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Nephthys\Nephthys_v1.4b10_installed files (7zip does not extract properly)" "%~dp0\System" /y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Ini Files\Nepthys ini changes" "%~dp0\System" /y /s

rem		Misc
rem			Antimicro
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\Deus Ex Controller.bat"  "%~dp0\System\Deus Ex Controller.bat" /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\antimicro\*"  "%~dp0\System\antimicro\" /e /y

rem			Custom "Augmented" Keybind Ini
IF "%Translation%"=="Yes" (
	goto :skipIni
	)
ren "%~dp0\System\DefUser.ini" "%~dp0\System\DefUser Original.ini"
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\Ini Files\Modernized Keybinds\Augmented\DefUser.ini" "%~dp0\System\DefUser.ini" /Y
:skipini
			
rem			Setup
IF "%setup%"=="No" (
	goto :skipsetup
	)
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Deus Ex Setup Creation\Unofficial Patch Manifest"  "%~dp0\System\" /y	
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\UPV3's Language Pack v2\English\System\SystemFilesINT.7z.001" -o"%~dp0\CommunityUpdateFileArchiveDXPS2\UPV3's Language Pack v2\English\System\" -y
del "%~dp0\CommunityUpdateFileArchiveDXPS2\UPV3's Language Pack v2\English\System\SystemFilesINT.7z.001" /Q
del "%~dp0\CommunityUpdateFileArchiveDXPS2\UPV3's Language Pack v2\English\System\SystemFilesINT.7z.002" /Q
del "%~dp0\CommunityUpdateFileArchiveDXPS2\UPV3's Language Pack v2\English\System\SystemFilesINT.7z.003" /Q
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\UPV3's Language Pack v2\English" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\UPV3's Language Pack v2\Cestina-Czech" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\UPV3's Language Pack v2\Deutsche-German" "%~dp0" /S /Y
rem ren "%~dp0\Help\ReadMePatch1.htm" "Deutsche-GermanReadMePatch1.htm"
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\UPV3's Language Pack v2\Francais-French" "%~dp0" /S /Y
rem ren "%~dp0\Help\ReadMePatch1.htm" "Francais-FrenchReadMePatch1.htm"
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\UPV3's Language Pack v2\Espanol-Spanish" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\UPV3's Language Pack v2\Italiano-Italian" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\UPV3's Language Pack v2\magyar-Hungarian" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\UPV3's Language Pack v2\Polskie-Polish" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\UPV3's Language Pack v2\Portugues-Portuguese" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\UPV3's Language Pack v2\Russkiy-Russian" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\UPV3's Language Pack v2\Nihongo-Japanese" "%~dp0" /S /Y
rem ren "%~dp0\Help\ReadMePatch1.htm" "Nihongo-JapaneseReadMePatch1.htm"
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\DXEditingPACK_2_2_Full_Community_Update_edit.exe" "%~dp0\System\SystemFiles.exe" /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Readme.md converted to HTML" "%~dp0\Help" /S /Y
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
echo The patch files are located where you installed Deus Ex in a folder named "CommunityUpdateFileArchiveDXPS2" 
echo You can reinstall them anytime using the "InstallCommunityUpdateDXPC.bat" located in your install folder root.
pause
exit

:Delete
@rem Cleanup
rmdir "%~dp0\CommunityUpdateFileArchiveDXPS2" /S /Q
del "%~dp0\InstallCommunityUpdateDXPC.bat" /Q
exit


:Yesps2	
rem Patches
rem		GOTY/Multiplayer
"%~dp0\CommunityUpdateFileArchiveDXPS2\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPS2\patch1112fm.exe" -o"%~dp0\CommunityUpdateFileArchiveDXPS2\" -y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\ReleaseMPPatch1112fm\Help\*" "%~dp0\Help\" /y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\ReleaseMPPatch1112fm\Maps\*" "%~dp0\Maps\" /y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\ReleaseMPPatch1112fm\System\*" "%~dp0\System\" /y
copy "%~dp0\CommunityUpdateFileArchiveDXPS2\ReleaseMPPatch1112fm\setup.exe" "%~dp0" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPS2\ReleaseMPPatch1112fm" /S /Q

rem Install PS2 manifest
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Deus Ex Setup Creation\Community Patch DXPS2 Manifest"  "%~dp0\System\" /y	

rem Install PCSX2 files
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\PCSX2\*" "%~dp0\PCSX2\" /Y

xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Int Files\PS2 Manifest Int" "%~dp0\System" /y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Community Update Language Pack DXPS2\Deutsche-German" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Community Update Language Pack DXPS2\Francais-French" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Community Update Language Pack DXPS2\Espanol-Spanish" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Community Update Language Pack DXPS2\Italiano-Italian" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Community Update Language Pack DXPS2\magyar-Hungarian" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Community Update Language Pack DXPS2\Polskie-Polish" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Community Update Language Pack DXPS2\Portugues-Portuguese" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPS2\Community Update Language Pack DXPS2\Russkiy-Russian" "%~dp0" /S /Y
"%~dp0\setup.exe"
exit
