@ECHO OFF
Rem This Bat will fetch the current install path for a CD or GOG based install of Deus Ex
Rem Then, it will add this install path to the path list of any .ini in a \system folder. (So long as the needed placeholders are present.)
Rem Not Steam yet because it doesn't set the install directory in the expected way
Rem https://stackoverflow.com/questions/34090258/find-steam-games-folder/34091380

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




set key="HKLM\Software\WOW6432Node\Unreal Technology\Installed Apps\Deus Ex"
set value=Folder
set oldVal=
for /F "skip=2 Delims=" %%r in ('reg query %key% /v %value%') do set oldVal=%%r
echo previous=%oldVal%
set newVal=%oldVal:~24%
echo new=%newVal%
reg add %key% /v %value% /d "%newVal%" /f
Rem Add install path to Deus Ex Community Update.ini -dp 2021/3/12 1416
"%~dp0\fart.exe" "%~dp0\System\*.ini" ";Paths=\"\System\*.u\"" "Paths=\"%newVal%\System\*.u\""
"%~dp0\fart.exe" "%~dp0\System\*.ini" ";Paths=\"\Maps\*.dx\"" "Paths=\"%newVal%\Maps\*.dx\""
"%~dp0\fart.exe" "%~dp0\System\*.ini" ";Paths=\"\Textures\*.utx\"" "Paths=\"%newVal%\Textures\*.utx\""
"%~dp0\fart.exe" "%~dp0\System\*.ini" ";Paths=\"\Sounds\*.uax\"" "Paths=\"%newVal%\Sounds\*.uax\""
"%~dp0\fart.exe" "%~dp0\System\*.ini" ";Paths=\"\Music\*.umx\"" "Paths=\"%newVal%\Music\*.umx\""



pause
exit