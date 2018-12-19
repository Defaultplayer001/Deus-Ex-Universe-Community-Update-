-- DX Modernization Fixes --

There are quite some issues running Deus Ex on modern hardware. Thus I've collected a couple of fixes from various projects to help provide a smooth experience while still keeping it vanilla.

Changes:

* Direct3D 9 renderer that works better on modern systems compared to the older Direct3D renderer. It also supports:
	- S3TC compression (for 24-bit textures used by other mods)
	- 4096x4096 textures
	- Anti-Aliasing & Anisotropic filtering.
	- A bunch of smaller rendering errors corrected.

* RenderExt that prevents certain levels (most prominently Vandenberg, Tunnels) from crashing due to too many lit surfaces at one time.

* The Revision Framework that includes the following fixes: 
	- Fix for too small ConCamera object, that might cause memory related crashes.
	- Finer grained control over Brightness and Mouse sensitivity.
	- Now displays all resolutions in the resolution display settings.
	- Fixes the previously broken Effects Channels to go up to the supported maximum for both Galaxy and AlAudio audio subsystems.
	- Makes it possible to save on drives with more than 4TB of free space.
	- Makes it possible to delete QuickSaves.
	- Adds UI scaling option via the ini/command line, defaults to tiny UI just as the OTP UI Fix.

* Updated launcher that includes the following fixes:
	- Timing issues causing speedup/slowdown on modern CPU's have been fixed.
	- Clamping FPS to 200 to prevent weird bugs due to the game running too fast.
	- Opting out of DEP if this is enabled.
	- Increased Stack and LargeAddressAware flag added to improve stability with high usage of RAM.
	- A lot of support for mods.
	
	
How to install:

* Delete DeusEx.ini and User.ini if they exist, so fresh copies will be made from the defaults.
* Extract the two folders in this archive to the root of your DX installation so the stuff in the Maps and System folders overwrite existing content.

NOTE: This changes/overwrites files from the original Deus Ex. If you care about keeping those make backups before overwriting.

Credits:

Direct3D 9 renderer is made by Chris Dohnal and is taken from: http://www.cwdohnal.com/utglr/
RenderExt and the updated launcher was created by Hanfling for Deus Ex: Revision and can be found on: https://coding.hanfling.de/launch/
The Revision Framework was written for Deus Ex: Revision by hanfling, but ported without many changes to be standalone by me.

--
	Björn Ehrby, bjorn@dx-revision.com, 2018-02-14