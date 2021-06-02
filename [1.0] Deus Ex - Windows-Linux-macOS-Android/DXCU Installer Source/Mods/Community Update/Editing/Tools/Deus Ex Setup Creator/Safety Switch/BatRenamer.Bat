set value=Deus Ex Mod
set value2=something


rem Prevent issues If the new name contains the old name by changing it specifically.
"%~dp0\fart.exe" "%~dp0\(Right click to edit this and put in your mod name) Rename Deus Ex Mod.bat" "set value=Deus Ex Mod" "%value%" 

rem Rename bat files to match the new name.
ren "%~dp0\(Right click to edit this and put in your mod name) Rename %value%.bat" "(Right click to edit this and put in your mod name) Rename %value2%.bat"
ren "%~dp0\(Run this!) Create %value% Setup.bat" "(Run this!) Create %value2% Setup.bat"
rem Rename the ones in root just to be safe
ren "%~dp0\..\(Right click to edit this and put in your mod name) Rename %value%.bat" "(Right click to edit this and put in your mod name) Rename %value2%.bat"
ren "%~dp0\..\(Run this!) Create %value% Setup.bat" "(Run this!) Create %value2% Setup.bat"

rem Rename all mod acronym strings in the bats. (This is done earlier, but since the bats are active they are not consitently overwritten.)
"%~dp0\fart.exe" "%~dp0\*.*" "Deus Ex Mod" "%value2%" 
rem Rename the ones in root just to be safe
"%~dp0\fart.exe" "%~dp0\*.*" "Deus Ex Mod" "%value2%"

copy "%~dp0\(R*.*" "%~dp0\.." 

"%~dp0\Renamer Isolation\BatRenamerRenamer.bat" 