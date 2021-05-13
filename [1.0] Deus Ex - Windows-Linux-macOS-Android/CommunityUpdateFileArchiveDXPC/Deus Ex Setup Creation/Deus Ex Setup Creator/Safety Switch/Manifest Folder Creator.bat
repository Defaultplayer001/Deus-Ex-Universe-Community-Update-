rem %Value%

Rem Here because the source value append text files keep getting merged for some reason. Instead drawing directly from source.

del "%~dp0\value*.*"

rem Ah, issue was actually with the empty "Optional Files" root folder being caught impartially. 
rem In the wrong place - Gotta set it after it's created in the middle of the script, duh.

rem Remove current directory from Value to make a relative path. 

call set ValueDir=%%Value:%~dp0=%%

rem Add double slashes to the directory value to make it safe for SED commands

set ValueDir=%ValueDir:\=\\%

rem Remove any backslash from value for writing a file name, since they aren't

set ValueSafeFileName=%ValueDir:\=%

rem Isolate Optional File name / Folder name from Optional Files

set ValueOptionalFileHeaderName=%ValueSafeFileName:Optional Files=%

rem Do the reverse for if commands checking whether or not the current file being deal with is an Optional Fle

set ValueOptionalFilesIsolate=%ValueSafeFileName:~0,14%

Rem Create custom append files (Processes all files, messy, does unecessary work.)

if not x"%ValueSafeFileName:Optional Files=%"==x"%ValueSafeFileName%" type "%~dp0\Deus Ex Setup Creator Files Backup\valueManifestIntAppend.txt" > "%~dp0\%ValueSafeFileName%ManifestIntAppend.ini"
if not x"%ValueSafeFileName:Optional Files=%"==x"%ValueSafeFileName%" type "%~dp0\Deus Ex Setup Creator Files Backup\valueSetupHeaderAppend.txt" > "%~dp0\%ValueSafeFileName%SetupHeaderAppend.ini"
if not x"%ValueSafeFileName:Optional Files=%"==x"%ValueSafeFileName%" type "%~dp0\Deus Ex Setup Creator Files Backup\valueGroupHeaderAppend.txt" > "%~dp0\%ValueSafeFileName%GroupHeaderAppend.ini"

rem Ah, issue was actually with the empty "Optional Files" root folder being caught impartially. 

del "*Optional FilesManifestIntAppend.ini"
del "*Optional FilesSetupHeaderAppend.ini"
del "*Optional FilesGroupHeaderAppend.ini"

rem Rename "Value" strings to custom Optional File name

if not x"%ValueSafeFileName:Optional Files=%"==x"%ValueSafeFileName%"  "%~dp0\fart.exe" "%~dp0\*Optional Files*.*" "Value" "%ValueOptionalFileHeaderName%"

rem Copy custom header append to file list, ONLY if their for a custom file. (This could be cleaner ofc, try to find a way to prevent it from even processing anything but the optional files)

rem done at the bottom now, delete if the bottom one doesn't have that stupid random character

rem if not x"%ValueSafeFileName:Optional Files=%"==x"%ValueSafeFileName%"  type "%~dp0\Optional Files*GroupHeaderAppend.ini" > "%~dp0\%ValueSafeFileName%FileListFinal.txt"


dir "%~dp0\%ValueDir%"/b /a-d > "%ValueSafeFileName%FileList.txt"

sed -i "s/^/File=(Src=\"%ValueDir%\\/" "%ValueSafeFileName%FileList.txt"

cd "%Value%"

for /F "tokens=4" %%a in ('dir') do echo %%a >> "%~dp0\%ValueSafeFileName%FileSizeList.txt"

cd "%~dp0"

"%~dp0\fart.exe" "%~dp0\%ValueSafeFileName%FileSizeList.txt" --remove "F"

"%~dp0\fart.exe" "%~dp0\%ValueSafeFileName%FileSizeList.txt" --remove "is"

"%~dp0\fart.exe" "%~dp0\%ValueSafeFileName%FileSizeList.txt" --remove "Installer"

"%~dp0\fart.exe" "%~dp0\%ValueSafeFileName%FileSizeList.txt" --remove "<DIR>"

"%~dp0\fart.exe" "%~dp0\%ValueSafeFileName%FileSizeList.txt" --remove "bytes"

"%~dp0\fart.exe" "%~dp0\%ValueSafeFileName%FileSizeList.txt" --remove ","

"%~dp0\fart.exe" "%~dp0\%ValueSafeFileName%FileSizeList.txt" --remove " "

Rem -C switch for C-style extended characters, specifically "\r\n", representing carriage return and newline respectively.

"%~dp0\fart.exe" -C -w "%~dp0\%ValueSafeFileName%FileSizeList.txt" --remove "\r\n"
	
sed -i "s/$/\",Size/" "%ValueSafeFileName%FileList.txt"

if not x"%ValueSafeFileName:Optional Files=%"==x"%ValueSafeFileName%" goto optionalfilesprocess

"%~dp0\paste.exe" -d "=" "%~dp0\%ValueSafeFileName%FileList.txt" "%~dp0\%ValueSafeFileName%FileSizeList.txt" >> "%~dp0\%ValueSafeFileName%FileListFinal.txt"

sed -i "s/$/)/" "%ValueSafeFileName%FileListFinal.txt"

goto end

:optionalfilesprocess:
"%~dp0\paste.exe" -d "=" "%~dp0\%ValueSafeFileName%FileList.txt" "%~dp0\%ValueSafeFileName%FileSizeList.txt" >> "%~dp0\%ValueSafeFileName%FileListNearFinal.txt"

sed -i "s/$/)/" "%ValueSafeFileName%FileListNearFinal.txt"

if not x"%ValueSafeFileName:Optional Files=%"==x"%ValueSafeFileName%" copy "%~dp0\%ValueSafeFileName%GroupHeaderAppend.ini" + "%~dp0\%ValueSafeFileName%FileListNearFinal.txt" "%~dp0\%ValueSafeFileName%FileListFinal.txt"

if not x"%ValueSafeFileName:Optional Files=%"==x"%ValueSafeFileName%" type "%~dp0\%ValueSafeFileName%SetupHeaderAppend.ini" >> "%~dp0\ManifestHeader-1-Setup.ini"

if not x"%ValueSafeFileName:Optional Files=%"==x"%ValueSafeFileName%" type "%~dp0\%ValueSafeFileName%ManifestIntAppend.ini" >> "%~dp0\Manifest.int"

rem Ah, issue was actually with the empty "Optional Files" root folder being caught impartially. 

del "*Optional FilesFile*.*"

:end: