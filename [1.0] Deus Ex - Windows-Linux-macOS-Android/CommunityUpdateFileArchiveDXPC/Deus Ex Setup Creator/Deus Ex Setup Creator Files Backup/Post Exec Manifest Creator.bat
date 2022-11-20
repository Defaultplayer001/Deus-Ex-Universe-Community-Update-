rem %PostExecExe%

rem Skip if not a .exe.
if x"%PostExecExe:.exe=%"==x"%PostExecExe%" goto noexe

rem Create name only value with no ".exe"
set ValueNoexe=%PostExecExe:.exe=%


Rem Create custom append files

type "%~dp0\Deus Ex Setup Creator Files Backup\valuePostExecManifestIntAppend.txt" > "%~dp0\%ValueNoexe%PostExecManifestIntAppend.ini"
type "%~dp0\Deus Ex Setup Creator Files Backup\valuePostExecSetupHeaderAppend.txt" > "%~dp0\%ValueNoexe%PostExecSetupHeaderAppend.ini"
type "%~dp0\Deus Ex Setup Creator Files Backup\valuePostExecGroupHeaderAppend.txt" > "%~dp0\%ValueNoexe%PostExecGroupHeaderAppend.ini"
type "%~dp0\Deus Ex Setup Creator Files Backup\valuePostExecHeaderAppend.txt" > "%~dp0\%ValueNoexe%PostExecHeaderAppend.ini"

"%~dp0\fart.exe" "%~dp0\%ValueNoexe%*.ini" "Value" "%ValueNoexe%"
"%~dp0\fart.exe" "%~dp0\%ValueNoexe%*.ini" "Subdir" "%ValueDir%"

set PostExecExe=true

:noexe:
