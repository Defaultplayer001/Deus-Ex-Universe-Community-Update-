#Download

https://drive.google.com/file/d/1CPs4A5EsHZ_586OiCtYmeEvybsI5iMFb/view?usp=sharing

https://www.moddb.com/mods/deus-ex-video-proxy/downloads

#Description

This is a script and collection of tools that lets you play video *from* Deus Ex. But not **in**.

Included is a simple proof of concept mod that changes Area 51 to trigger the PS2's Tong ending pre-rendered cut scene rather then the real-time rendered PC one. No other endings are changed, and the video file used is a raw un-rencoded rip from the NTSC PS2 version.

#How it works:

Rather then actually implementing a video player in UE1, this simply calls any external player into full screen and plays the requested video file, then closes and returns you back to Deus Ex. Used and included by default is MPC-BE. (An example for VLC is included in the .bat)
A combination of the tools "Cmdow" and "Sound Volume View" handles window control and muting of Deus Ex.

This is done by using a probably unintended feature of the "open" command to open a "File:\\\" URL instead of a standard web URL, which lets you open any arbitrary file. 

Which, y'know, massive security hole especially for MP that shouldn't even exist, and should already be patched out of at least one MP mod.
Generally not considered the best idea to use, or as how I best liked it put: https://www.youtube.com/watch?v=kY-pUxKQMUE

For bonus sketchy points, "Cmdow" is often used nefariously and therefore sets off like 60% of anti-virus software.

Also since it's based on URL usage, relative paths aren't allowed. It requires the script, tools, video player and videos all be in the same fixed location for every user, editing that location requires editing the map file. It *has* to be in very specifically "C:/Program Files (x86)/Deus Ex Video Proxy/" and **nowhere** else.

Absolutely a non-ideal and janky solution. 

---

Nonetheless, it does work! Surprisingly well in my very biased opinion. 
I've no doubt results will vary, but for me I just get that classic "switching resolution for the cut scene" stutter that isn't terribly uncommon on PC games.

For anyone suspicious of it, feel free to examine the relatively simple "play vid.bat" script and "Video Proxy Triggers.t3d".
Never install any kind of software from a source you don't trust! Even game mods can exploit stuff like this.



#Install:

Note: PS2 video files will be played in the wrong aspect ratio / size unless "mpc-be64-settings.reg" is used to set the correct settings. (Video Frame>Touch Window From Outside, Keep Aspect Ratio deselected, Override Aspect Ratio>16:9, "New process for every file" under "Player" on the Options screen is also selected to prevent having a previously open MPC-BE window from causing issues.)

WILL overwrite any pre-existing MPC-BE settings. Backup or change manually if you want to keep your settings.

1. Copy "Deus Ex Video Proxy" folder to "C:/Program Files (x86)".
    1. MUST be installed in "C:/Program Files (x86)/Deus Ex Video Proxy/". Installing anywhere else requires a map modification as described below.

2. (Optional): To use the A51 Tong PS2 Cut Scene Replacement Proof of Concept, simply copy the files inside the folder into your Deus Ex folder, overwriting when asked. 
    1. (Back up your vanilla A51 map before!) 

3. You can test it by opening Area 51 and typing "causeevent destroy_generatorV" into the console. (Or just play the map to trigger the Tong ending as normal)
    1. Remember that it's just launching a normal media player in fullscreen, you'll still have full control over the video. If you end it early you'll be brought back into the game but may have to wait for the credits trigger countdown, though there is also a fallback movement based trigger around the generator buttons that gets activated.
	2. To easily open the console / maps, create / edit a Deus Ex shortcut to have "-hax0r" after the target. Outside the quotes. For example: "C:\Deus Ex 1112fm\System\DeusEx.exe" -hax0r
    3. Then simply press "Esc" at the main menu to hide the UI, then "T". Delete "say" and enter the command "legend". This will bring up a menu that will let you select any map. Follow the same steps replacing "legend" for any other desired console command.
	

#Usage: 

1. Replace video file path in "PlayVid.bat" with desired video file path. (Remembering that the path must be absolute. Can't do fun relative path tricks like ../)
    1. Optionally customizing the filename for the .bat as well. Needed for playing multiple different videos at multiple different points. Can use a playlist for playing multiple videos at once otherwise.
    2. Note: Supported formats vary depending on player used, default player MPC-BE supports most formats. YouTube links are also supported!
	
2. Open "Video Proxy Triggers.t3d" in a text editor and customize "PlayVid.bat"'s file path ("file:///C:/Program Files (x86)/Deus Ex Video Proxy/PlayTongEndgameHidden.lnk") and cut scene trigger name (destroy_generatorV) to desired values.
    1. Remember to keep video files in "C:/Program Files (x86)/Deus Ex Video Proxy/Videos"! Also use forwards slashes or they'll get commented out upon re-importing from a .t3d file!
    2. Optionally, customize the dispatcher as well to setup a post cut scene event. Adding a checkflagtrigger at the point of cut scene activation as a fallback method to activate the event if the video fails / is ended early. 
    3. An "EndCreditsTrigger" was also created and is in the included "MoreMoreTriggers" that will trigger the end credits. (Would be simpler / less janky to avoid any post cut scene / credits handling. Could just design the next map to be loaded into a "neutral" state not requiring player input, and include credits as a video file.)
    4. You may also create a create a shortcut based on "PlayTongEndgameHidden.lnk" that will hide the .bat launch for a more polished look. Otherwise simply launch the video file directly.
	
3. After opening your map in UED, go to File>Import Level. Select "Video Proxy Triggers.t3d", and then select "Add contents to existing map". Hit Ctrl+P to play and test using the console command "causeevent yourtriggernamehere". Save if successful! 
    1. For example, for this proof of concept the command to start the cut scene is "causeevent destroy_generatorV".


