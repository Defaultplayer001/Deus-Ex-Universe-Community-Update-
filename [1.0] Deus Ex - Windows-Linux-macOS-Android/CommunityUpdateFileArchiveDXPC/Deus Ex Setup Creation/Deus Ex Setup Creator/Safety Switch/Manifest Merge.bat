Delete old Manifest to prevent merge issues

del "%~dp0\System\Manifest.ini"

del "%~dp0\Optional FilesGroupHeaderAppend.ini"

del "%~dp0\value*.*"

rem copy "OptionalFiles*SetupHeaderAppend.ini" "%~dp0\ManifestHeader-1-Setup.ini"

rem type "OptionalFiles*GroupHeaderAppend.ini" > "%~dp0\ManifestHeader-2-Groups.ini"

rem "OptionalFiles*ManifestIntAppend.txt" "%~dp0\Manifest.int"

Rem Copy over necessary header information into next text file from source file. 

rem copy "ManifestHeader-1-Setup.ini" + "ManifestHeader-2-Groups.ini" + "ManifestHeader-3-Game Group.ini" %~dp0\System\Manifest.ini"

Rem Copies over any inis if present, since they are presumably preferred. 
Rem What? Delete this.
rem copy "%~dp0\*.ini" "%~dp0\System" /Y=[]


Rem Also copy over ints, could do a basic copy for this one, or both in hindsight actually. But eh. 

type Manifest.int > "%~dp0\System\Manifest.int"

Not working right, instead doing one by one in folder creator like the other appends.
rem Copy "Manifest.int" + "OptionalFiles*ManifestIntAppend.txt" "%~dp0\System\Manifest.int"

type Setup.int > "%~dp0\System\Setup.int"

Rem Root System folder not needed for recursive path setup

del SystemFileListFinal.txt /q

Rem Prevent setup files from being written to the manifest.

del "%~dp0\Deus Ex Setup Creator Files BackupFileListFinal.txt" /q

del "%~dp0\Deus Ex Setup Creator Files Backup7zip Self Extracting EXE CreatorFileListFinal.txt" /q

Rem Merge text files

copy "ManifestHeader-1-Setup.ini" + "ManifestHeader-2-Groups.ini" + "ManifestHeader-3-Game Group.ini" + "*FileListFinal.txt" "%~dp0\System\Manifest.ini"

rem type *FileListFinal.txt >> "%~dp0\System\Manifest.ini"

rem Apparently added file size was intentional "the per file overhead is probably to round to sector count or something like that for the filesystem - the per install overhead is probably free space for savegames" - nah

rem type "%~dp0\FileSizeDummyFile.txt" >> "%~dp0\System\Manifest.ini"



