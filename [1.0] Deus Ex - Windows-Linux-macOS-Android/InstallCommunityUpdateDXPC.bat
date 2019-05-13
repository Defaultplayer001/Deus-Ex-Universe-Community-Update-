@ECHO OFF
rem Trying to do a project based on this installer? Feel free to email me directly about it, I made it(with a little(a lot of)) help from my friends! 
rem Defaultplayer001@gmail.com
rem Put the subject as "UPv3 project"

rem Official Deus Ex setup file modification, choices left for fallback, comment out the next line for normal usage.
goto :setsetupflag
rem PS2 setup version! 
rem goto :setps2setupflag

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
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Translations\French" "%~dp0" /S /Y
ren "%~dp0\Help\ReadMePatch1.htm" "FrenchReadMePatch1.htm"
echo You have installed the French translation! 
goto :choice

rem		German
:German
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Translations\German" "%~dp0" /S /Y
ren "%~dp0\Help\ReadMePatch1.htm" "GermanReadMePatch1.htm"
echo You have installed the German translation! 
goto :choice

rem		Italian
:Italian
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Translations\Italian" "%~dp0" /S /Y
echo You have installed the Italian translation! 
goto :choice

rem		Japanese
:Japanese
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Translations\Japanese" "%~dp0" /S /Y
ren "%~dp0\Help\ReadMePatch1.htm" "JapaneseReadMePatch1.htm"
echo You have installed the Japanese translation! 
goto :choice

rem		Russian
:Russian
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Translations\Russian" "%~dp0" /S /Y
echo You have installed the Russian translation! 
goto :choice

rem		Spanish
:Spanish
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Translations\Spanish" "%~dp0" /S /Y
echo You have installed the Spanish translation! 
goto :choice			

:Yes2	
rem	Demos
Set Demo=Yes
rem Extract the demo exe compressed due to github size restrictions 2018/11/12
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\DeusExDemo.7z.001" -o"%~dp0\CommunityUpdateFileArchiveDXPC\" -y
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\DeusExDemo.exe" -y
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\DeusExM02.exe" -o"%~dp0\" -y
ren "%~dp0\Help\ReadMe.htm" "ReadMeDemo.htm"
del "%~dp0\CommunityUpdateFileArchiveDXPC\DeusExDemo.7z.001" /Q
del "%~dp0\CommunityUpdateFileArchiveDXPC\DeusExDemo.7z.002" /Q
:no

rem Patches
rem		GOTY/Multiplayer
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\patch1112fm.exe" -o"%~dp0\CommunityUpdateFileArchiveDXPC\" -y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\ReleaseMPPatch1112fm\Help\*" "%~dp0\Help\" /y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\ReleaseMPPatch1112fm\Maps\*" "%~dp0\Maps\" /y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\ReleaseMPPatch1112fm\System\*" "%~dp0\System\" /y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\ReleaseMPPatch1112fm\setup.exe" "%~dp0" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\ReleaseMPPatch1112fm" /S /Q

Rem		1014 Patch install files (Doesn't auto check all options like 1112fm does no matter the selected= value) 
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\deusex1014f.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPC\deusex1014f" -y
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\deusex1014f\DeusExPatch1014f.exe" -o"%~dp0\CommunityUpdateFileArchiveDXPC\deusex1014f\DeusExPatch1014f" -y
ren "%~dp0\Help\ReadMePatch1.htm" "ReadMePatch1014.htm"
echo d|xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\deusex1014f\DeusExPatch1014f\ReleasePatch1014f\Help" "%~dp0\Help" /y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\deusex1014f\DeusExPatch1014f\ReleasePatch1014f\System\Setup.exe" "%~dp0\System" /y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\deusex1014f\DeusExPatch1014f\ReleasePatch1014f\setup.exe" "%~dp0" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\deusex1014f" /S /Q

rem :IF "%setup%"=="No" (
rem :	goto :skipmapspatch
rem :	)
	
rem		1.110 Maps Patch
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\Maps Patch\DeusEx_MapsPatch11.7z" -o"%~dp0\CommunityUpdateFileArchiveDXPC\Maps Patch\DeusEx_MapsPatch11" -y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Maps Patch\ReadMe.txt" "%~dp0\Help\Maps Patch ReadMe.txt" /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Maps Patch\DeusEx_MapsPatch11\maps" "%~dp0\maps" /Y /S
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\Maps Patch\DeusEx_MapsPatch11" /S /Q
rem del "%~dp0\CommunityUpdateFileArchiveDXPC\Maps Patch\DeusEx_MapsPatch11\Instructions.txt" /Q
rem 1002f Supplemental 
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\Maps Patch\DeusExMapsPatchVanillaSupplemental.7z" -y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Maps Patch\DeusExMapsPatchVanillaSupplemental\Maps\" "%~dp0\Maps\" /Y /S
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\Maps Patch\DeusExMapsPatchVanillaSupplemental" /S /Q

rem :skipmapspatch

IF "%setup%"=="Yes" (
	goto :demoskip
	)

rem 		Unofficial Patch v2 *DEMO*
IF "%Demo%"=="Yes" copy "%~dp0\CommunityUpdateFileArchiveDXPC\Unofficial Patch V2 Demo Version\DeusEx.u" "%~dp0\System\DeusEx.u"
IF "%Demo%"=="Yes" copy "%~dp0\CommunityUpdateFileArchiveDXPC\Unofficial Patch v2 Demo Version\ReadMe.txt" "%~dp0\Help\Unofficial-Patch-v2-Demo-Version-ReadMe.txt" /Y
IF "%Demo%"=="Yes" goto :demoskip 	
:demoskip
rem 		Unofficial Patch v2
:Now using an edited version of UPV2 by default
:"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\Unofficial Patch v2\Unofficial_DeusExV2_v_0.10.zip" -y
;copy "%~dp0\CommunityUpdateFileArchiveDXPC\Unofficial Patch v2\ReadMe.txt" "%~dp0\Help\Unofficial-Patch-V2-edited-render-relaunch-ReadMe.txt" /Y
;xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Unofficial Patch v2\Unofficial_DeusExV2_v_0.10\*" "%~dp0\System\" /Y /S
;rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\Unofficial Patch v2\Unofficial_DeusExV2_v_0.10" /S /Q
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Unofficial Patch V2 edited render relaunch\ReadMe.txt" "%~dp0\Help\Unofficial-Patch-V2-edited-render-relaunch-ReadMe.txt" /Y
echo f|xcopy "%~dp0\System\DeusEx.u" "%~dp0\System\1112fm Deus Ex.u (original)\DeusEx.u" /Y 
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Unofficial Patch v2 edited render relaunch\UnofficialPatchv2editedrenderrelaunch.exe" "%~dp0\System\UnofficialPatchv2editedrenderrelaunch.exe" /Y

rem		Engine DLL Fix
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\Engine DLL Fix (Demo Recording Fix)\engine-dll-fix.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPC\Engine DLL Fix (Demo Recording Fix)\engine-dll-fix" -y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Engine DLL Fix (Demo Recording Fix)\ReadMe.txt" "%~dp0\Help\Engine DLL Fix ReadMe.txt" /Y
ren "%~dp0\System\engine.dll" "Engine original.dll"
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Engine DLL Fix (Demo Recording Fix)\engine-dll-fix\Engine.dll" "%~dp0\System" /Y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\Engine DLL Fix (Demo Recording Fix)\engine-dll-fix" /S /Q


rem 	Conversation Files (1112fm GOTY) 
;Original con files, needed for translations.
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Conversation Files (1112fm GOTY)\*.u" "%~dp0\System\*.u" /y

rem		Confix 1.06
IF "%Translation%"=="Yes" goto :skipConfix 
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Confix 1.06\ReadMe.txt" "%~dp0\Help\ReadMe - Confix 1.06.txt" /Y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Confix 1.06\*.u" "%~dp0\System\*.u" /y

:skipConfix

rem		OTPUIFix
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\OTPUIFix.Zip" -o"%~dp0\System" -y
copy "%~dp0\System\OTP UI Fix Readme.txt" "%~dp0\Help\OTP-UI-Fix-Readme.txt" /Y
del "%~dp0\System\OTP UI Fix Readme.txt" /Q

rem		Revision Framework
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Revision Framework\ReadMe.txt" "%~dp0\Help\Revision-Framework-Readme.txt" /Y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Revision Framework\RF.dll" "%~dp0\system\RF.dll" /y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Revision Framework\RF.u" "%~dp0\system\RF.u" /y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Revision Framework\vcredist_x86.exe" "%~dp0\system\vcredist_x86.exe" /y

rem		RenderExt
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\Deus Ex Modernization Package\DXModernizationLite.7z" -o"%~dp0\CommunityUpdateFileArchiveDXPC\Deus Ex Modernization Package\DXModernizationLite" -y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Deus Ex Modernization Package\DXModernizationLite\System\RenderExt.dll" "%~dp0\System\RenderExt.dll"
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Deus Ex Modernization Package\DXModernizationLite\System\RenderExt.int" "%~dp0\System\RenderExt.int"
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\Deus Ex Modernization Package\DXModernizationLite\"
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Deus Ex Modernization Package\ReadMe - Deus Ex Modernization Package.txt\" "%~dp0\Help\"

rem EXE's
ren "%~dp0\System\DeusEx.exe" "DeusEx Original.exe"

rem 	Kentie's
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\Kentie's Deus EXE\DeusExe-v8.1.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPC\Kentie's Deus EXE\DeusExe-v8.1" -y
ren "%~dp0\CommunityUpdateFileArchiveDXPC\Kentie's Deus EXE\DeusExe-v8.1\DeusEx.exe" "DeusEx Kentie's.exe"
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Kentie's Deus EXE\ReadMe.txt" "%~dp0\Help\Deus EXE ReadMe.txt" /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Kentie's Deus EXE\DeusExe-v8.1" "%~dp0\System" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\Kentie's Deus EXE\DeusExe-v8.1" /S /Q

rem 	Han's
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's Launch\Launch-DeusEx-1112f-20180729.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's Launch\Launch-DeusEx-1112f-20180729" -y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's Launch\Launch-DeusEx-1112f-20180729\ReadMe.txt"  "%~dp0\Help\Launch EXE ReadMe.txt" /Y
del "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's Launch\Launch-DeusEx-1112f-20180729\Launch.txt" /Q
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's Launch\Launch-DeusEx-1112f-20180729" "%~dp0\System" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's Launch\Launch-DeusEx-1112f-20180729" /S /Q
del "%~dp0\System\DeusEx.exe" /Q
ren "%~dp0\System\Launch.exe" "DeusEx.exe"
ren "%~dp0\System\UCC.exe" "UCC Original.exe"
ren "%~dp0\System\LCC.exe" "UCC.exe"
rem			Combined int file
ren "%~dp0\System\Deusex.int" "DeusEx Original.int"
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Int Files\Combined&updated Deus Ex int file" "%~dp0\System" /y
rem			Multiplayer exe, int and Ini
copy "%~dp0\System\DeusEx.exe" "%~dp0\System\DeusExMultiplayer.exe" /y
rem Double check that this is needed
rem It is
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Int Files\Combined&updated Deus Ex int file\DeusEx.int" "%~dp0\System\DeusExMultiplayer.int" /y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Ini Files\DXMTL Multiplayer ini\*" "%~dp0\System\" /y /s

rem Renderers
rem 	Video
rem 		Nglide
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\nGlide105_setup.exe" -o"%~dp0\CommunityUpdateFileArchiveDXPC\nGlide105_setup" -y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\nGlide105_setup\$PLUGINSDIR" /S /Q
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\nGlide105_setup"  "%~dp0\System" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\nGlide105_setup" /S /Q
copy "%~dp0\System\nglide_readme.txt"  "%~dp0\Help\nGlide-ReadMe.txt" /Y
del "%~dp0\System\nglide_readme.txt" /q

rem 		d3d10
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\d3d10drv-v29.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPC\d3d10drv-v29" -y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\d3d10drv-v29\ReadMe.txt"  "%~dp0\Help\D3D10-ReadMe.txt" /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\d3d10drv-v29\DeusEx"  "%~dp0\System" /e /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\d3d10drv-v29\" /S /Q
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Int Files\Typo Fixed D3D10Drv Int" "%~dp0\System" /y

rem			dxd3d9
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\DXD3D\dxd3d9r13.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPC\DXD3D\dxd3d9r13" -y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\DXD3D\dxd3d9r13"  "%~dp0\System" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\DXD3D\dxd3d9r13" /S /Q
copy "%~dp0\CommunityUpdateFileArchiveDXPC\DXD3D\ReadMe.txt"  "%~dp0\Help\dxd3d9-ReadMe.txt" /Y

rem			dxd3d8
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\DXD3D\dxd3d8r10.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPC\DXD3D\dxd3d8r10" -y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\DXD3D\dxd3d8r10"  "%~dp0\System" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\DXD3D\dxd3d8r10" /S /Q

rem			OpenGl
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\OpenGL\dxglr21.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPC\OpenGL\dxglr21" -y
ren "%~dp0\System\OpenGLDrv.dll" "OpenGLDrv Original.dll"
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\OpenGL\dxglr21"  "%~dp0\System" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\OpenGL\dxglr21" /S /Q
rem			dxd3d8/9/OpenGL readme (cwdohnal)
copy "%~dp0\CommunityUpdateFileArchiveDXPC\OpenGL\ReadMe.txt"  "%~dp0\Help\D3D8-9-OpenGL-ReadMe.txt" /Y


rem		Audio
rem			OpenAL
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\OpenAL\OpenAL_v2.4.8_DeusEx.7z" -o"%~dp0\CommunityUpdateFileArchiveDXPC\OpenAL\" -y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\OpenAL\ReadMe.txt"  "%~dp0\Help\OpenAL-ReadMe.txt" /Y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\OpenAL\OpenAL_v2.4.8_DeusEx\License.txt"  "%~dp0\Help\OpenAL-License.txt" /y
del "%~dp0\CommunityUpdateFileArchiveDXPC\OpenAL\OpenAL_v2.4.8_DeusEx\License.txt" /Q
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\OpenAL\OpenAL_v2.4.8_DeusEx"  "%~dp0\System" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\OpenAL\OpenAL_v2.4.8_DeusEx" /S /Q

rem			SwFMOD
rem Move to int file older
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" e "%~dp0\CommunityUpdateFileArchiveDXPC\SwFMOD_DeusEx_1.0.0.8.exe" -o"%~dp0\CommunityUpdateFileArchiveDXPC\SwFMOD_DeusEx_1.0.0.8" -y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\SwFMOD_DeusEx_1.0.0.8\SwFMOD.int.txt"  "%~dp0\Help\SwFMOD-ReadMe.txt" /Y
del "%~dp0\CommunityUpdateFileArchiveDXPC\SwFMOD_DeusEx_1.0.0.8\SwFMOD.int.txt" /Q
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\SwFMOD_DeusEx_1.0.0.8\*.*"  "%~dp0\System" /Y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\SwFMOD_DeusEx_1.0.0.8" /S /Q
rem			Fixed int
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Int Files\SwFMOD Fixed INT file\SwFMOD.int"  "%~dp0\System" /Y

rem		Multiplayer

rem			DXMTL
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\DXMTL-v152b1 Installed files" "%~dp0" /Y /E
ren "%~dp0\Help\readme_dxmtl.txt" "DXMTL-ReadMe.txt"
ren "%~dp0\Help\license_dxmtl.txt" "DXMTL-License.txt"

rem			Nephthys
rem "%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\Nephthys\Nephthys_v1.4b10_inst.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPC\Nephthys\Nephthys_v1.4b10_inst" -y
rem "%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\Nephthys\Nephthys_v1.4b10_inst\Nephthys_v1.4b10_inst.exe" -o"%~dp0\CommunityUpdateFileArchiveDXPC\Nephthys\Nephthys_v1.4b10_inst\Nephthys_v1.4b10_inst" -y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Nephthys\ReadMe.txt"  "%~dp0\Help\ReadMe-Nephthys.txt" /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Nephthys\Nephthys_v1.4b10_installed files (7zip does not extract properly)" "%~dp0\System" /y
;xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Ini Files\Nepthys ini changes" "%~dp0\System" /y /s

rem		HX Co-Op
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's Co-op (HX)\HX-0.9.89.3.zip" -o"%~dp0" -y
echo f|xcopy "%~dp0\Help\HX\Readme.txt"  "%~dp0\Help\Multiplayer\Co-Op (HX)\ReadMe Co-Op (HX).txt" /S /Y
echo f|xcopy "%~dp0\Help\HX\Cheats.txt"  "%~dp0\Help\Multiplayer\Co-Op (HX)\Cheats Co-Op (HX).txt" /y /s
echo f|xcopy "%~dp0\Help\HX\Changelog.txt"  "%~dp0\Help\Multiplayer\Co-Op (HX)\Changelog Co-Op (HX).txt" /y /s
echo f|xcopy "%~dp0\Help\HX\Ports.txt"  "%~dp0\Help\Multiplayer\Co-Op (HX)\Ports Co-Op (HX).txt" /y /s
rem not sure if I should rename?
rem ren "%~dp0\System\HX.exe"  "%~dp0\System\DeusExCoOp.exe" /Y
rmdi "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's Co-op (HX)\HX-0.9.89.3" /S /Q
rmdir "%~dp0\Help\HX" /S /Q
			
			HXExt
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's Co-op (HX)\HXExt - Bogie's HX mod\HXExt Stable Version 1.9.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's Co-op (HX)\HXExt - Bogie's HX mod\HXExt Stable Version 1.9" -y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's Co-op (HX)\HXExt - Bogie's HX mod\HXExt Stable Version 1.9\HXExt README.txt"  "%~dp0\Help\ReadMe - Co-Op - HXExt.txt" /Y
del "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's Co-op (HX)\HXExt - Bogie's HX mod\HXExt Stable Version 1.9\HXExt README.txt"
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's Co-op (HX)\HXExt - Bogie's HX mod\HXExt Stable Version 1.9\Player Class List.txt"  "%~dp0\Help\ReadMe - Co-Op - HXExt - Player Class List.txt" /Y
del "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's Co-op (HX)\HXExt - Bogie's HX mod\HXExt Stable Version 1.9\Player Class List.txt"
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's Co-op (HX)\HXExt - Bogie's HX mod\HXExt Stable Version 1.9\*" "%~dp0\System\" /y /s
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's Co-op (HX)\HXExt - Bogie's HX mod\HXExt Stable Version 1.9\" /S /Q

rem			MiniHX
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's Co-op (HX)\Cozmo's MiniHX hotfix\ReadMe.txt"  "%~dp0\Help\ReadMe-CoOp-MiniHX.txt" /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's Co-op (HX)\Cozmo's MiniHX hotfix\*" "%~dp0\System\" /s /y
del "%~dp0\System\ReadMe.txt"

rem			Editing
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's HTK Commandlets\HTK-20160618.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's HTK Commandlets\HTK-20160618\" -y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's HTK Commandlets\HTK-20160618\lib3ds.COPYING"  "%~dp0\Help\License - lib3ds.txt" /Y
del "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's HTK Commandlets\HTK-20160618\lib3ds.COPYING"
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's HTK Commandlets\HTK-20160618\lib3ds.README"  "%~dp0\Help\ReadMe - lib3ds.txt" /Y
del "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's HTK Commandlets\HTK-20160618\lib3ds.README"
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's HTK Commandlets\HTK-20160618\UpkgOptions.txt"  "%~dp0\Help\HTK - UpkgOptions.txt" /Y
del "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's HTK Commandlets\HTK-20160618\UpkgOptions.txt"
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's HTK Commandlets\HTK-20160618\*" "%~dp0\System\" /s /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's HTK Commandlets\HTK-20160618\"
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Hanfling's HTK Commandlets\ReadMe - HTK Commandlets.txt" "%~dp0\Help\"

rem		Misc
rem			Antimicro
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Deus Ex Controller proxy (Antimicro)\*"  "%~dp0\System\" /e /y

rem			Custom "Augmented" Keybind Ini
IF "%Translation%"=="Yes" (
	goto :skipIni
	)
ren "%~dp0\System\DefUser.ini" "%~dp0\System\DefUser Original.ini"
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Ini Files\Modernized Keybinds\Augmented\DefUser.ini" "%~dp0\System\DefUser.ini" /Y
:skipini

rem Organize this			
rem			Setup
IF "%setup%"=="No" (
	goto :skipsetup
	)
rem Moved to bottom due to installing-like-a-mod additions. Should probably be deleted after new way is confirmed working.
goto :modsetupskip
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Deus Ex Setup Creation\Unofficial Patch Manifest"  "%~dp0\System\" /y	
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\English\SystemFilesINT.7z.001" -o"%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\English\" -y
del "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\English\SystemFilesINT.7z.001" /Q
del "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\English\SystemFilesINT.7z.002" /Q
del "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\English\SystemFilesINT.7z.003" /Q
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\English" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\Cestina-Czech" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\Deutsche-German" "%~dp0" /S /Y
rem ren "%~dp0\Help\ReadMePatch1.htm" "Deutsche-GermanReadMePatch1.htm"
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\Francais-French" "%~dp0" /S /Y
rem ren "%~dp0\Help\ReadMePatch1.htm" "Francais-FrenchReadMePatch1.htm"
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\Espanol-Spanish" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\Italiano-Italian" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\magyar-Hungarian" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\Polskie-Polish" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\Portugues-Portuguese" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\Russkiy-Russian" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\Nihongo-Japanese" "%~dp0" /S /Y
rem ren "%~dp0\Help\ReadMePatch1.htm" "Nihongo-JapaneseReadMePatch1.htm"
:modsetupskip
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Icons & Logos\Windows 95 Notepad Icon.ico" "%~dp0\Help\Windows 95 Notepad Icon.ico" /Y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Icons & Logos\Windows 95 Internet Explorer Icon.ico" "%~dp0\Help\Windows 95 Internet Explorer Icon.ico" /Y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Unofficial Patch V2 edited render relaunch\DeusEx.u" "%~dp0\System\DeusEx.u"
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Unofficial Patch v2 Demo Version\UnofficialPatchv2DemoVersion.exe" "%~dp0\System\UnofficialPatchv2DemoVersion.exe" /Y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Unofficial Patch v2 Demo Version\ReadMe.txt" "%~dp0\Help\Unofficial-Patch-v2-Demo-Version-ReadMe.txt" /Y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\DXEditingPACK_2_2_Full_Community_Update_edit.exe" "%~dp0\System\SystemFiles.exe" /Y
copy "%~dp0\CommunityUpdateFileArchiveDXPC\Deus Ex Editor Fix\DeusExEditorFixSelfExtracting.exe" "%~dp0\DeusExEditorFixSelfExtracting.exe" /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Readme.md converted to HTML" "%~dp0\Help" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Ini Files\Deus Ex Community Update INI\*" "%~dp0\System\" /y /s
rem Move all folders to the DXCU subfolder, to be used like a mod
echo d|xcopy "%~dp0\DirectX7" "%~dp0\DeusExCommunityUpdate\DirectX7" /S /Y
rmdir "%~dp0\DirectX7\" /S /Q
echo d|xcopy "%~dp0\Help" "%~dp0\DeusExCommunityUpdate\Help" /S /Y
rmdir "%~dp0\Help\" /S /Q
echo d|xcopy "%~dp0\Maps" "%~dp0\DeusExCommunityUpdate\Maps" /S /Y
rmdir "%~dp0\Maps\" /S /Q
echo d|xcopy "%~dp0\Music" "%~dp0\DeusExCommunityUpdate\Music" /S /Y
rmdir "%~dp0\Music\" /S /Q
echo d|xcopy "%~dp0\Sounds" "%~dp0\DeusExCommunityUpdate\Sounds" /S /Y
rmdir "%~dp0\Sounds\" /S /Q
echo d|xcopy "%~dp0\System" "%~dp0\DeusExCommunityUpdate\System" /S /Y
rmdir "%~dp0\System\" /S /Q
echo d|xcopy "%~dp0\Textures" "%~dp0\DeusExCommunityUpdate\Textures" /S /Y
rmdir "%~dp0\Textures\" /S /Q
rem Copy of the 1014 Patch setup group, edited to include all the files, needed since setup files need to be in the same place. Deletion section moved to very end.
Rem		1014 Patch install files (Doesn't auto check all options like 1112fm does no matter the selected= value) 
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\deusex1014f.zip" -o"%~dp0\CommunityUpdateFileArchiveDXPC\deusex1014f" -y
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\deusex1014f\DeusExPatch1014f.exe" -o"%~dp0\CommunityUpdateFileArchiveDXPC\deusex1014f\DeusExPatch1014f" -y
ren "%~dp0\Help\ReadMePatch1.htm" "ReadMePatch1014.htm"
echo d|xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\deusex1014f\DeusExPatch1014f\ReleasePatch1014f\Help" "%~dp0\Help" /y
echo d|xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\deusex1014f\DeusExPatch1014f\ReleasePatch1014f\System" "%~dp0\System" /y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\Deus Ex Setup Creation\Unofficial Patch Manifest"  "%~dp0\System\" /y
"%~dp0\CommunityUpdateFileArchiveDXPC\7z1800\7z.exe" x "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\English\SystemFilesINT.7z.001" -o"%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\English\" -y
del "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\English\SystemFilesINT.7z.001" /Q
del "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\English\SystemFilesINT.7z.002" /Q
del "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\English\SystemFilesINT.7z.003" /Q
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\English" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\Cestina-Czech" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\Deutsche-German" "%~dp0" /S /Y
rem ren "%~dp0\Help\ReadMePatch1.htm" "Deutsche-GermanReadMePatch1.htm"
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\Francais-French" "%~dp0" /S /Y
rem ren "%~dp0\Help\ReadMePatch1.htm" "Francais-FrenchReadMePatch1.htm"
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\Espanol-Spanish" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\Italiano-Italian" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\magyar-Hungarian" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\Polskie-Polish" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\Portugues-Portuguese" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\Russkiy-Russian" "%~dp0" /S /Y
xcopy "%~dp0\CommunityUpdateFileArchiveDXPC\UPV3's Language Pack v2\Nihongo-Japanese" "%~dp0" /S /Y
rem ren "%~dp0\Help\ReadMePatch1.htm" "Nihongo-JapaneseReadMePatch1.htm"
xcopy "*.*" "%~dp0\DeusExCommunityUpdate\*.*" /Y
del "%~dp0\*.exe*"
copy "%~dp0\CommunityUpdateFileArchiveDXPC\deusex1014f\DeusExPatch1014f\ReleasePatch1014f\setup.exe" "%~dp0" /y
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC\deusex1014f" /S /Q
"%~dp0\setup.exe"
rem exit
pause

:skipsetup

@rem Done
echo Complete!
echo The requested files have been installed! 

choice /c yn /n /t 10 /d n /m "Would you like to keep the Unofficial Patch v3 install files? If you do nothing they will be deleted in 10s! [Y/N]?"
IF ERRORLEVEL 2 goto :Delete
IF ERRORLEVEL 1 goto :Keep

:keep
echo The patch files are located where you installed Deus Ex in a folder named "CommunityUpdateFileArchiveDXPC" 
echo You can reinstall them anytime using the "InstallCommunityUpdateDXPC.bat" located in your install folder root.
pause
exit

:Deleted
@rem Cleanup
rmdir "%~dp0\CommunityUpdateFileArchiveDXPC" /S /Q
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
