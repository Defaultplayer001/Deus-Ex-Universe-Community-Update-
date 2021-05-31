nah — 01/23/2018
InterpolateEnd() is overriden in dxplayer
so it shows up there instead of going to mission 02
along with two other hacks to disable intro option and jump straight into the game instead of intro
thats all
thats all left as comments in the code
just search for DEUS_EX_DEMO
Defaultmom001 — 01/23/2018
oh nice, found it! So all I gotta do is uncomment these 3 lines out?  Then recompile Deusex.u and copy it over if the user chooses to install the demo?
Gonna test it out
nah — 01/23/2018
almost
for
localPlayer.ShowIntro(True);
//            localPlayer.StartNewGame(localPlayer.strStartMap);
it's switching the comments
but remember that there was also mission 02 available later
so you would need to check that deusex.u what they did there in particular
but afaik mission 02 interpolates out as well, so thats most likely just another mapname there which is checked
Defaultmom001 — 01/23/2018
YEAH! Got the demo splash screen to load, thanks!
I'd love to try to detect the demo and dynamically load the splash screen, maybe by checking what texture files the player has? Not sure how though.
Also, I can't find any of these strings: " localPlayer.ShowIntro(True);
//            localPlayer.StartNewGame(localPlayer.strStartMap);" ?
nah — 01/23/2018
MenuScreenNewGame.uc
should pop up when searching for DEUS_EX_DEMO
but i mean
you can try to dynamic load the maps
and see if the packages exits that way
but i don't quite see the point in the demo stuff
there wasnt anything different content wise in the demo
just the game had no intro and it stopped at some point earlier
Defaultmom001 — 01/23/2018
Awesome! Works perfectly! I'm gonna look into setting demo check later, but for now I'll just switch out DeusEx.u files