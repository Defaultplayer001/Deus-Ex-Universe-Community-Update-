Rem Copy over necessary header information into next text file from source file. 

type ManifestHeader.ini > "%~dp0\System\Manifest.ini"

Rem Copies over any inis if present, since they are presumably preferred. 

copy "%~dp0\*.ini" "%~dp0\System" /Y

Rem Also copy over ints, could do a basic copy for this one, or both in hindsight actually. But eh. 

type Manifest.int > "%~dp0\System\Manifest.int"

type Setup.int > "%~dp0\System\Setup.int"


Rem Merge text files

type *.txt >> "%~dp0\System\Manifest.ini"