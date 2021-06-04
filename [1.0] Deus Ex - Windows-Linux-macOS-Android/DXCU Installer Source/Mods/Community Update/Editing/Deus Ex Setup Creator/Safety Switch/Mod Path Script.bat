@ECHO OFF
rem Trying to do a project based on this installer? Feel free to email me directly about it, I made it(with a little(a lot of)) help from my friends! 
rem Defaultplayer001@gmail.com
rem Put the subject as "UPv3 project"

::::::::::::::::::::::::::::::::::::::::::::
:: Elevate.cmd - Version 4
:: Automatically check & get admin rights
:: see "https://stackoverflow.com/a/12264592/1016343" for description
::::::::::::::::::::::::::::::::::::::::::::
 @echo off
 CLS
 ECHO.
 ECHO =============================
 ECHO Running Admin shell
 ECHO =============================

:init
 setlocal DisableDelayedExpansion
 set cmdInvoke=1
 set winSysFolder=System32
 set "batchPath=%~0"
 for %%k in (%0) do set batchName=%%~nk
 set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
 setlocal EnableDelayedExpansion

:checkPrivileges
  NET FILE 1>NUL 2>NUL
  if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
  if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
  ECHO.
  ECHO **************************************
  ECHO Invoking UAC for Privilege Escalation
  ECHO **************************************

  ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
  ECHO args = "ELEV " >> "%vbsGetPrivileges%"
  ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
  ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
  ECHO Next >> "%vbsGetPrivileges%"

  if '%cmdInvoke%'=='1' goto InvokeCmd 

  ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
  goto ExecElevation

:InvokeCmd
  ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
  ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
 "%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
 exit /B

:gotPrivileges
 setlocal & cd /d %~dp0
 if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

 ::::::::::::::::::::::::::::
 ::START
 ::::::::::::::::::::::::::::


rem Delete Community Update Registry keys to start with a clean slate. Prevents repetitive \DeusExCommunityUpdate\DeusEx\DeusExCommunityUpdate\DeusEx error. -DP 2019/9/28 801
REG Delete "HKLM\Software\Unreal Technology\Installed Apps\Deus Ex Mod" /f
rem Copy Deus Ex install registry values to the Community Update reg path. Primarily for install path value.
REG COPY "HKLM\Software\Unreal Technology\Installed Apps\Deus Ex" "HKLM\Software\Unreal Technology\Installed Apps\Deus Ex Mod" /f /s
rem Second pass for Windows versions past XP.
rem Only needed if running manually from a 64-bit command prompt, when run in the distributed setup a 32-bit command prompt get launched simply because the extractor (7-zip or WinZip) is a 32-bit program. -DP 2019/9/28 1119
REG Delete "HKLM\Software\WOW6432Node\Unreal Technology\Installed Apps\Deus Ex Mod" /f
REG COPY "HKLM\SOFTWARE\WOW6432Node\Unreal Technology\Installed Apps\Deus Ex" "HKLM\Software\WOW6432Node\Unreal Technology\Installed Apps\Deus Ex Mod" /s /f
rem Order reversed here to prevent repetitive \DeusExCommunityUpdate\DeusEx\DeusExCommunityUpdate\DeusEx error. -DP 2019/9/28 1115
set append=\DeusExCommunityUpdate\DeusEx
set key="HKLM\Software\Unreal Technology\Installed Apps\Deus Ex Mod"
set value=Folder
set oldVal=
for /F "skip=2 Delims=" %%r in ('reg query %key% /v %value%') do set oldVal=%%r
echo previous=%oldVal:~24%
set newVal=%oldVal:~24%%append%
if ERRORLEVEL=1 set newVal=C:\Program Files (x86)\Steam\steamapps\common\Deus Ex
echo new=%newVal%
reg add %key% /v %value% /d "%newVal%" /f
rem If running from a 32-bit command prompt as is normal with the distributed setup, both the above and below append sections are read compltely identically. "HKLM\Software\" is read as "HKLM\Software\WOW6432Node\". This delete is needed to prevent the repetitive \DeusExCommunityUpdate\DeusEx\DeusExCommunityUpdate\DeusEx error. Only needed if running manually from a 64-bit command prompt, when run in the distributed setup a 32-bit command prompt get launched simply because the extractor (7-zip or WinZip) is a 32-bit program. -DP 2019/9/28 1129
rem Delete Community Update Registry keys to start with a clean slate. Prevents repetitive \DeusExCommunityUpdate\DeusEx\DeusExCommunityUpdate\DeusEx error. -DP 2019/9/28 801
rem wait a fucking second you need to folder you can just delete it.
reg Delete "HKLM\Software\Unreal Technology\Installed Apps\Deus Ex Mod" /f
rem Copy Deus Ex install registry values to the Community Update reg path. Primarily for install path value.
REG COPY "HKLM\Software\Unreal Technology\Installed Apps\Deus Ex" "HKLM\Software\Unreal Technology\Installed Apps\Deus Ex Mod" /f /s
rem Test append
set append=\DeusExCommunityUpdate\DeusEx
set key="HKLM\Software\WOW6432Node\Unreal Technology\Installed Apps\Deus Ex Mod"
set value=Folder
set oldVal=
for /F "skip=2 Delims=" %%r in ('reg query %key% /v %value%') do set oldVal=%%r
echo previous=%oldVal:~24%
set newVal=%oldVal:~24%%append%
if ERRORLEVEL=1 set newVal=C:\Program Files (x86)\Steam\steamapps\common\Deus Ex
echo new=%newVal%
reg add %key% /v %value% /d "%newVal%" /f
Rem Add install path to manifest.ini -dp 2021/2/24 2055
"%~dp0\fart.exe" -V "%~dp0\System\Manifest.*" "DefaultFolder=\"C:\Program Files (x86)\Steam\steamapps\common\Deus Ex\\"\"  "DefaultFolder=\"%newVal%\""
Rem Add install folder path for "Open Install Folder" button
"%~dp0\fart.exe" -V "%~dp0\System\Manifest.*" "ProductURL=\"C:\Program Files (x86)\Steam\steamapps\common\Deus Ex\\"\"  "ProductURL=\"%newVal%\""
Rem Add install path to Deus Ex Community Update.ini -dp 2021/3/12 1416
"%~dp0\fart.exe" "%~dp0\System\*.ini" ";Paths=\"\System\*.u\"" "Paths=\"%newVal%\System\*.u\""
"%~dp0\fart.exe" "%~dp0\System\*.ini" ";Paths=\"\Maps\*.dx\"" "Paths=\"%newVal%\Maps\*.dx\""
"%~dp0\fart.exe" "%~dp0\System\*.ini" ";Paths=\"\Textures\*.utx\"" "Paths=\"%newVal%\Textures\*.utx\""
"%~dp0\fart.exe" "%~dp0\System\*.ini" ";Paths=\"\Sounds\*.uax\"" "Paths=\"%newVal%\Sounds\*.uax\""
"%~dp0\fart.exe" "%~dp0\System\*.ini" ";Paths=\"\Music\*.umx\"" "Paths=\"%newVal%\Music\*.umx\""
Call "%~dp0\system\setup.exe"

cd ..
del /f /s /q "%CD%\Deus Ex Mod\*.*" > nul
rmdir "%CD%\Deus Ex Mod\*.*" /S /Q

exit