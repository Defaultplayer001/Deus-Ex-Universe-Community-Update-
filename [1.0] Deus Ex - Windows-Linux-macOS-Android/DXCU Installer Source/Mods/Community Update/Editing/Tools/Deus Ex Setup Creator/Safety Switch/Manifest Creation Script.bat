dir /b /ad /s > FolderList.bat

sed -i "s/^/Set value=/" Folderlist.bat

sed -i "s/$/\& call \"%%\~dp0\\Manifest Folder Creator.bat\"/" Folderlist.bat

rem sed -e "a\\ call \"%~dp0\\Manifest Folder Creator.bat\" < FolderList.bat

rem sed -i "s/$/ dir %~dp0\%value% /b /a-d > %value%FileList.txt

rem -i "s/^/File=(Src=\"%value%\\/" %value%FileList.txt

rem -i "s/$/\")/" %value%FileList.txt/" Folderlist.bat