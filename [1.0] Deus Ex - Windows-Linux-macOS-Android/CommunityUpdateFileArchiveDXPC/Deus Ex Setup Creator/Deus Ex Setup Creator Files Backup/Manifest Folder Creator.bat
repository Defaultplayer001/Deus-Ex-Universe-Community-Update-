rem %Value%

Rem Here because the source value append text files keep getting merged for some reason. Instead drawing directly from source.

rem del "%~dp0\value*.*"

del /ah "Desktop.ini" /s /q /f

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

set PostExecExe=

Rem Create custom append files

if not x"%ValueSafeFileName:Optional Files=%"==x"%ValueSafeFileName%" type "%~dp0\Deus Ex Setup Creator Files Backup\valueManifestIntAppend.txt" > "%~dp0\%ValueSafeFileName%ManifestIntAppend.ini"
if not x"%ValueSafeFileName:Optional Files=%"==x"%ValueSafeFileName%" type "%~dp0\Deus Ex Setup Creator Files Backup\valueSetupHeaderAppend.txt" > "%~dp0\%ValueSafeFileName%SetupHeaderAppend.ini"
if not x"%ValueSafeFileName:Optional Files=%"==x"%ValueSafeFileName%" type "%~dp0\Deus Ex Setup Creator Files Backup\valueGroupHeaderAppend.txt" > "%~dp0\%ValueSafeFileName%GroupHeaderAppend.ini"
if not x"%ValueSafeFileName:Demo=%"==x"%ValueSafeFileName%" type "%~dp0\Deus Ex Setup Creator Files Backup\valueGroupHeaderAppend (Selected=False).txt" > "%~dp0\%ValueSafeFileName%GroupHeaderAppend.ini"


rem Ah, issue was actually with the empty "Optional Files" root folder being caught impartially. 

del "*Optional FilesManifestIntAppend.ini"
del "*Optional FilesSetupHeaderAppend.ini"
del "*Optional FilesGroupHeaderAppend.ini"

rem Rename "Value" strings to custom Optional File name (This could be cleaner probably? "*Optional Files*.*" repetedly probably wastes a bit of time, wouldn't something like "%ValueSafeFileNameOptional Files*.*" work?)

if not x"%ValueSafeFileName:Optional Files=%"==x"%ValueSafeFileName%"  "%~dp0\fart.exe" "%~dp0\*Optional Files*.*" "Value" "%ValueOptionalFileHeaderName%"

rem Copy custom header append to file list, ONLY if their for a custom file. (This could be cleaner ofc, try to find a way to prevent it from even processing anything but the optional files)

rem done at the bottom now, delete if the bottom one doesn't have that stupid random character

rem if not x"%ValueSafeFileName:Optional Files=%"==x"%ValueSafeFileName%" type "%~dp0\Optional Files*GroupHeaderAppend.ini" > "%~dp0\%ValueSafeFileName%FileListFinal.txt"

dir "%~dp0\%ValueDir%"/b /a-d > "%ValueSafeFileName%FileList.txt"

rem  Interrupt the "%ValueSafeFileName%FileList.txt" creation process, to create a copy (%ValueSafeFileName%PostExecFileList.bat) that instead appends the list to set them as values and launch a new bat 
rem THIS
rem if "%ValueSafeFileName%"=="%ValueOptionalFileHeaderName%Optional Files" goto noexe
if x"%ValueSafeFileName:Optional Files=%"==x"%ValueSafeFileName%" goto noexe
copy "%ValueSafeFileName%FileList.txt" "%ValueSafeFileName%PostExecFileList.bat"
sed -i "s/^/Set PostExecExe=/" "%ValueSafeFileName%PostExecFileList.bat"

sed -i "s/$/\& call \"%%\~dp0\\Post Exec Manifest Creator.bat\"/" "%ValueSafeFileName%PostExecFileList.bat"

call "%~dp0\%ValueSafeFileName%PostExecFileList.bat"

:noexe:

sed -i "s/^/File=(Src=\"%ValueDir%\\/" "%ValueSafeFileName%FileList.txt"

cd "%Value%"

del /ah "Desktop.ini" /s /q /f

Rem JFC thank you Han for telling me about zI

for %%I in (*.*) do echo %%~zI >> "%~dp0\%ValueSafeFileName%FileSizeList.txt"

cd "%~dp0"

Rem Remove spaces

"%~dp0\fart.exe" "%~dp0\%ValueSafeFileName%FileSizeList.txt" --remove " "

Rem -C switch for C-style extended characters, specifically "\r\n", representing carriage return and newline respectively.

"%~dp0\fart.exe" -C -w "%~dp0\%ValueSafeFileName%FileSizeList.txt" --remove "\r\n"
	
sed -i "s/$/\",Size/" "%ValueSafeFileName%FileList.txt"

if "%ValueSafeFileName%"=="%ValueOptionalFileHeaderName%Optional Files" goto end
if not x"%ValueSafeFileName:Optional Files=%"==x"%ValueSafeFileName%" goto optionalfilesprocess
:continue:

"%~dp0\paste.exe" -d "=" "%~dp0\%ValueSafeFileName%FileList.txt" "%~dp0\%ValueSafeFileName%FileSizeList.txt" >> "%~dp0\%ValueSafeFileName%FileListFinal.txt"

sed -i "s/$/)/" "%ValueSafeFileName%FileListFinal.txt"

goto end

:optionalfilesprocess:
"%~dp0\paste.exe" -d "=" "%~dp0\%ValueSafeFileName%FileList.txt" "%~dp0\%ValueSafeFileName%FileSizeList.txt" >> "%~dp0\%ValueSafeFileName%FileListNearFinal.txt"

sed -i "s/$/)/" "%ValueSafeFileName%FileListNearFinal.txt"

if "%PostExecExe%"=="true" goto postexecprocess

rem THIS is the command that ain't workin
rem if not x"%ValueSafeFileName:Optional Files=%"==x"%ValueSafeFileName%" copy "%~dp0\%ValueSafeFileName%GroupHeaderAppend.ini" + "%~dp0\%ValueSafeFileName%FileListNearFinal.txt" "%~dp0\%ValueSafeFileName%FileListFinal.txt"

copy "%~dp0\%ValueSafeFileName%GroupHeaderAppend.ini" + "%~dp0\%ValueSafeFileName%FileListNearFinal.txt" "%~dp0\%ValueSafeFileName%FileListFinal.txt"

type "%~dp0\%ValueSafeFileName%SetupHeaderAppend.ini" >> "%~dp0\ManifestHeader-1-Setup.ini"

type "%ValueSafeFileName%FileListFinal.txt" >> "%~dp0\ManifestHeader-3-Groups.ini"

rem if "%ValueSafeFileName%"=="%ValueOptionalFileHeaderName%Optional Files" type "%~dp0\*PostExecSetupHeaderAppend.ini" >> "%~dp0\ManifestHeader-1-Setup.ini"

rem if "%ValueSafeFileName%"=="%ValueOptionalFileHeaderName%Optional Files" type "%~dp0\*PostExecGroupHeaderAppend.ini" >> "%~dp0\ManifestHeader-3-Groups.ini"

rem if "%ValueSafeFileName%"=="%ValueOptionalFileHeaderName%Optional Files" type "%~dp0\*PostExecManifestHeaderAppend.ini" >> "%~dp0\Manifest.int"

if not x"%ValueSafeFileName:Optional Files=%"==x"%ValueSafeFileName%" type "%~dp0\%ValueSafeFileName%ManifestIntAppend.ini" >> "%~dp0\Manifest.int"

rem Ah, issue was actually with the empty "Optional Files" root folder being caught impartially. 

rem del "*Optional FilesFile*.*"

goto end

:postexecprocess:

echo %PostExecExe%


type "%ValueSafeFileName%FileListNearFinal.txt" >> "%~dp0\%ValueNoexe%PostExecHeaderAppend.ini"

type "%~dp0\%ValueNoexe%PostExecHeaderAppend.ini" >> "%~dp0\%ValueNoexe%PostExecGroupHeaderAppend.ini" 

rem copy "%ValueSafeFileName%FileListNearFinal.txt" "%ValueSafeFileName%FileListFinal.txt"

type "%ValueSafeFileName%FileListFinal.txt" >> "%~dp0\ManifestHeader-2-Groups.ini"

:end: