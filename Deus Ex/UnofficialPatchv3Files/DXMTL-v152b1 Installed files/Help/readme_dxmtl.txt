Version 1.52 beta 1
September 2, 2002


Visit these websites for more help and information:

http://www.deaclan.us/board/
http://dxcbp.deus-ex.org/
http://members.fortunecity.co.uk/dmv27/



To use this version, you must completely uninstall any old version of DXMTL.
Skip this step if you do not have any old versions installed.
Replace the "*" with the version number of the currently installed mod.

Manual Uninstall:

1. Remove these files if they exist. You can keep the U files if you need them for demos.
   SCN100.u, SCN100.int, BugFix1.u, BugFix1.int
   DXMTL*.u, DXMTL*.int, DXMTL*.det, DXMTL*.frt

2. Remove any old INI file sections related to DXMTL103

3. Open DeusEx.ini and DXMTL.ini and replace all "DXMTL*" with "DXMTL152b1"

4. Remove DXMTL from the EditPackages in section [Editor.EditorEngine] if it exists.
   If you do not remove this line, then UnrealEd and the compiler will crash.

5. Follow the instructions for installation.



Manual Install:

1. Extract all the files to the DeusEx\System folder.

2. Open DeusEx.ini and find the [DeusEx.DeusExGameEngine] section
   Add/Update one line for the mod
   ServerPackages=DXMTL152b1

3. Find the [URL] section at the top and change the line
   Class=DeusEx.JCDentonMale
   to
   Class=DXMTL152b1.MTLJCDenton

4. Find the [Engine.Engine] section and change the lines
   DefaultGame=DeusEx.DeusExGameInfo
   DefaultServerGame=DeusEx.DeathMatchGame
   to
   DefaultGame=DXMTL152b1.MTLGameInfo
   DefaultServerGame=DXMTL152b1.MTLDeathMatch



Servers:

Dedicated servers that start up using scripts will need to have their command lines changed.
For example, if the command line looks like this:

DXMP_CMD?Game=DXMTL103.MTLAdvTeam?Mutator=SCN100.AntiCheat1,BugFix1.BugFix1?-server?log=server.log

change it to look like this:

DXMP_CMD?Game=DXMTL152b1.MTLAdvTeam?-server?log=server.log

Other game types:
MTLAdvTeam
MTLBasicTeam
MTLTeam
MTLDeathmatch


Version 152b1 and above use new movement code. These are the networking settings that should give
the best performance for both the client and the server. These settings replace the existing
settings in DeusEx.ini. MaxClientRate should be adjusted based on the upload speed of the server.


[IpDrv.TcpNetDriver]
AllowDownloads=True
ConnectionTimeout=15.0
InitialConnectTimeout=30.0
AckTimeout=1.0
KeepAliveTime=0.5
MaxClientRate=20000
SimLatency=0
RelevantTimeout=4.0
SpawnPrioritySeconds=1.0
ServerTravelPause=4.0
NetServerMaxTickRate=20
LanServerMaxTickRate=20
StaticUpdateRate=12
DynamicUpdateRate=40
