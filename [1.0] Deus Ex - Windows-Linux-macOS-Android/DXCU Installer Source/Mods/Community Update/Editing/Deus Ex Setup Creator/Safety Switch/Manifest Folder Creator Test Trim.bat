rem %Value%

rem Remove current directory from Value to make a relative path. 

call set ValueDir=%%Value:%~dp0=%%

rem Add double slashes to the directory value to make it safe for SED commands

set ValueDir=%ValueDir:\=\\%

set ValueSafeFileName=%ValueDir%

(echo %ValueSafeFileName%)>%ValueSafeFileName%.bat

rem A filename can't contain any of the following characters: \ / : * ? " < > |

"%~dp0\fart.exe" "%~dp0\System\%ValueSafeFileName%.bat" "\\" ""

"%~dp0\fart.exe" "%~dp0\System\%ValueSafeFileName%.bat" "/" ""

"%~dp0\fart.exe" "%~dp0\System\%ValueSafeFileName%.bat" ":" ""

"%~dp0\fart.exe" "%~dp0\System\%ValueSafeFileName%.bat" "\*" ""

"%~dp0\fart.exe" "%~dp0\System\%ValueSafeFileName%.bat" "\?" ""

"%~dp0\fart.exe" "%~dp0\System\%ValueSafeFileName%.bat" "\"" ""

"%~dp0\fart.exe" "%~dp0\System\%ValueSafeFileName%.bat" "<" ""

"%~dp0\fart.exe" "%~dp0\System\%ValueSafeFileName%.bat" ">" ""

"%~dp0\fart.exe" "%~dp0\System\%ValueSafeFileName%.bat" "|" ""

call %ValueSafeFileName%.bat

rem Remove any backslash from value for writing a file name, since they aren't allowed in Window's filenames.

rem set ValueSafeFileName=%ValueDir:\=%

dir "%~dp0\%ValueDir%"/b /a-d > "%ValueSafeFileName%FileList.txt"

sed -i "s/^/File=(Src=\"%ValueDir%\\/" "%ValueSafeFileName%FileList.txt"

sed -i "s/$/\")/" "%ValueSafeFileName%FileList.txt"