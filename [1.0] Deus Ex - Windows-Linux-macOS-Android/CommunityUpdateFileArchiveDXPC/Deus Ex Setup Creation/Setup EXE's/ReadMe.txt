A collection of Deus Ex Setup EXE's 

TLDR: Use 1003c

The Deus Ex 1112fm GOTY disc/patch(same as 1109f, 1003f_F8) version seems to work the best.
1002f at least doesn't seem to postexec reliably, if at all. I haven't tested with 1003c.

Edit: The 1112fm version seems to select all options by default, limiting you ability to create options. 

Edit2: However, the 1014f version does not seem to have this limitation!

Edit3: It does REQUIRE a MaxVersion= be set however if Require= is set. OTherwise it will fail any version check. Setting MaxVersion=9999z works as a workaround.

Edit4: 1003c is working without EITHER of the above limitations? Why on earth didn't I test it sooner, literally wrote "I haven't tested with 1003c." above. JFC.

All shortcut EXE's seem to be the same, kept for convienance. 

Can be used to create new setup files by modifying the manifest.ini

Shortcut EXE will launch the main EXE from a \system\ folder.
Not strictly necessary AFAIK

-Defaultplayer
