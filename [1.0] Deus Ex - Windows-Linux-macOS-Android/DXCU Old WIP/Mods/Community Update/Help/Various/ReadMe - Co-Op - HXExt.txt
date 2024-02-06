[What is HXExt?]

HXExt is a remake of another mod, BogieHX, which was a mod for Hanfling's HX Deus Ex coop. It
includes many new fixes, as well as new skins (all available in Changelog.txt of Version 1.0
and Player Class List.txt).

[Why did you scrap BogieHX and restart?]

Without sugarcoating it, BogieHX's codebase was pretty bad. It still used the old
'ucc make' method, which made it far harder to develop, including having to put in new lines for
importing new textures (which itself takes a bit of time), and less control over rebuilding.

[Install Instructions]

Extract all contents to your DeusEx/System folder. Then, in your HX.ini (HXDefault.ini if that
doesn't exist), changed the 'Root=HX.HXRootWindow' line to 'Root=HXExt.HXRootWindowExt', otherwise
you won't be able to join any HXExt servers.

[Player Skins]

You can set up your player class by changing your 'Class=' line in HXUser.ini 
(or HXUserDefault.ini if that doesn't exist). There is a list of player classes included, in 
'Player Class List.txt'. For example; 'Class=HXExt.HXBobPage', or 'Class=HXExt.HXAlexDentonMale2'. 

Alternatively, classes can be changed in game using the 'SetPlayerSkin' command, along side the 
class name. For example; 'SetPlayerSkin HXExt.HXAlexDentonFemale', or 'SetPlayerSkin
HXExt.HXPaulStrange' (Hidden skin discovered! Congratulations, you actually read the readme!).