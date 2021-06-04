Delete old Manifest to prevent merge issues

del "%~dp0\System\Manifest.ini"

rem del "%~dp0\Optional FilesGroupHeaderAppend.ini"

rem del "%~dp0\value*.*"

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

rem Merge Post Exec files into master files

type "%~dp0\*PostExecSetupHeaderAppend.ini" >> "%~dp0\ManifestHeader-1-Setup.ini"

type "%~dp0\*PostExecGroupHeaderAppend.ini" >> "%~dp0\ManifestHeader-3-Groups.ini"

type "%~dp0\*PostExecManifestIntAppend.ini" >> "%~dp0\System\Manifest.int"

rem Copy Custom entries into Manifest.int

type "%~dp0\Custom Manifest.int Entries.txt" >> "%~dp0\System\Manifest.int"

rem type "%~dp0\ModsDXTOptional FilesFileListNearFinal.txt" >> "%~dp0\%ValueNoexe%PostExecHeaderAppend.ini"

rem Merge optional files with their own groups into the master groups... group

rem type "%~dp0\*Optional Files*FileListFinal.txt" >> "%~dp0\ManifestHeader-2-Groups.ini"

rem Delete so they can't be written again in the next steps

del "%~dp0\*Optional Files*FileListFinal.txt"

;Delete so language files don't get handled twice. (Already manually entered in ManifestHeader-2-Game Group.ini)
del "%~dp0\ModsCommunity UpdateFileListFinal.txt"

;Ditto for Confix / Japanese Port / 1002f Maps / .con Files for Translations and Demo
del "%~dp0\ModsCommunity UpdateLanguagesConfixSystemFileListFinal.txt"
del "%~dp0\ModsCommunity UpdateLanguagesConfix (Russian Port)SystemFileListFinal.txt"
del "%~dp0\ModsCommunity UpdateLanguagesJapanese PortSystemFileListFinal.txt"
del "%~dp0\ModsCommunity UpdateLanguagesJapanese PortHelpFileListFinal.txt"
del "%~dp0\ModsCommunity UpdateMapsFileListFinal.txt"
del "%~dp0\ModsCommunity UpdateUed2*FileListFinal.txt"
del "%~dp0\ModsCommunity UpdateEditing*FileListFinal.txt"
del "%~dp0\ModsCommunity UpdateLanguages.con Files for Translations and Demo*FileListFinal.txt"

rem Used to override manifest with custom group order. Reverse rem comment to generate a new unorganized group list.
copy "ManifestHeader-1-Setup (Custom Override).ini" + "ManifestHeader-2-Game Group.ini" + "*FileListFinal.txt" + "ManifestHeader-3-Groups.ini" "%~dp0\System\Manifest.ini"
rem Original
rem copy "ManifestHeader-1-Setup.ini" + "ManifestHeader-2-Game Group.ini" + "*FileListFinal.txt" + "ManifestHeader-3-Groups.ini" "%~dp0\System\Manifest.ini"

rem type *FileListFinal.txt >> "%~dp0\System\Manifest.ini"

rem Apparently added file size was intentional "the per file overhead is probably to round to sector count or something like that for the filesystem - the per install overhead is probably free space for savegames" - nah

rem type "%~dp0\FileSizeDummyFile.txt" >> "%~dp0\System\Manifest.ini"



