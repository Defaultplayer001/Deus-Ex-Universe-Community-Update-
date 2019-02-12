//=============================================================================
// DeusExServerList
//		Stores a server entry in a DeusEx Server List
//=============================================================================

class DeusExServerList extends UWindowList;

// Valid for sentinel only
var	MenuScreenJoinGame	Owner;
var int					TotalServers;
var int					TotalPlayers;
var int					TotalMaxPlayers;
var bool				bNeedUpdateCount;

// Config
var config int			MaxSimultaneousPing;

// Master server variables
var string				IP;
var int					QueryPort;
var string				Category;		// Master server categorization
var string				GameName;		// Unreal, Unreal Tournament

// State of the ping
var DeusExServerPing	ServerPing;
var bool				bPinging;
var bool				bPingFailed;
var bool				bPinged;
var bool				bNoInitalPing;
var bool				bOldServer;

// Rules and Lists
var UBrowserRulesList	RulesList;
var UBrowserPlayerList  PlayerList;
var bool				bKeepDescription;	// don't overwrite HostName
var int					PlayerListSortColumn;

// Unreal server variables
var bool				bLocalServer;
var float				Ping;
var string				HostName;
var int					GamePort;
var string				MapName;
var string				MapTitle;
var string				MapDisplayName;
var string				GameType;
var string				GameMode;
var int					NumPlayers;
var int					MaxPlayers;
var int					GameVer;
var int					MinNetVer;

function DestroyListItem() 
{
	Owner = None;

	if(ServerPing != None)
	{
		ServerPing.Destroy();
		ServerPing = None;
	}
	Super.DestroyListItem();
}

function QueryFinished(UBrowserServerListFactory Fact, bool bSuccess, optional string ErrorMsg)
{
   //DEUS_EX AMSD Call to owner for callback 
	Owner.ListQueryFinished(Fact, bSuccess, ErrorMsg); //*******
}

// Functions for server list entries only.
function PingServer(bool bInitial, bool bJustThisServer, bool bNoSort)
{
	// Create the UdpLink to ping the server
	ServerPing = GetPlayerOwner().GetEntryLevel().Spawn(class'DeusExServerPing');
	ServerPing.Server = Self;
	ServerPing.StartQuery('GetInfo', 2);
	ServerPing.bInitial = bInitial;
	ServerPing.bJustThisServer = bJustThisServer;
	ServerPing.bNoSort = bNoSort;
	bPinging = True;
}

function ServerStatus()
{
	// Create the UdpLink to ping the server
	ServerPing = GetPlayerOwner().GetEntryLevel().Spawn(class'DeusExServerPing');
	ServerPing.Server = Self;
	ServerPing.StartQuery('GetStatus', 2);
	bPinging = True;
}

function StatusDone(bool bSuccess)
{
	// Destroy the UdpLink
	ServerPing.Destroy();
	ServerPing = None;

	bPinging = False;

	RulesList.Sort();
	PlayerList.Sort();
   DeusExServerList(Sentinel).Owner.PingStatusDone(Self);
}

function CancelPing()
{
	if(bPinging && ServerPing != None && ServerPing.bJustThisServer)
		PingDone(False, True, False, True);
}

function PingDone(bool bInitial, bool bJustThisServer, bool bSuccess, bool bNoSort)
{
	local MenuScreenJoinGame W;
	local DeusExServerList OldSentinel;

	// Destroy the UdpLink
	if(ServerPing != None)
		ServerPing.Destroy();
	
	ServerPing = None;

	bPinging = False;
	bPingFailed = !bSuccess;
	bPinged = True;

	OldSentinel = DeusExServerList(Sentinel);
	if(!bNoSort)
	{
		Remove();

		// Move to the ping list
		if(!bPingFailed || (OldSentinel != None && OldSentinel.Owner != None && OldSentinel.Owner.bShowFailedServers))
		{
			if(OldSentinel.Owner.PingedList != None)
				OldSentinel.Owner.PingedList.AppendItem(Self);
		}
	}
	else
	{
		if(OldSentinel != None && OldSentinel.Owner != None && OldSentinel != OldSentinel.Owner.PingedList)
			Log("Unsorted PingDone lost as it's not in ping list!");
	}

	if(Sentinel != None)
	{
		DeusExServerList(Sentinel).bNeedUpdateCount = True;

//		if(bInitial)
			//ConsiderForSubsets();
	}

	if(!bJustThisServer)
		if(OldSentinel != None)
		{
			W = OldSentinel.Owner;

			if(W.bPingSuspend)
			{
				W.bPingResume = True;
				W.bPingResumeInitial = bInitial;
			}
			else
				OldSentinel.PingNext(bInitial, bNoSort);
		}

   OldSentinel.Owner.ListPingDone(self);
}

//***************

// Functions for sentinel only

function InvalidatePings()
{
	local DeusExServerList l;

	for(l = DeusExServerList(Next);l != None;l = DeusExServerList(l.Next)) 
		l.Ping = 9999;
}

function PingServers(bool bInitial, bool bNoSort)
{
	local DeusExServerList l;
	
	bPinging = False;

	for(l = DeusExServerList(Next);l != None;l = DeusExServerList(l.Next)) 
	{
		l.bPinging = False;
		l.bPingFailed = False;
		l.bPinged = False;
	}

	PingNext(bInitial, bNoSort);
}

function PingNext(bool bInitial, bool bNoSort)
{
	local int TotalPinging;
	local DeusExServerList l;
	local bool bDone;
	
	TotalPinging = 0;
	
	bDone = True;
	for(l = DeusExServerList(Next);l != None;l = DeusExServerList(l.Next)) 
	{
		if(!l.bPinged)
			bDone = False;
		if(l.bPinging)
			TotalPinging ++;
	}
	
	if(bDone && Owner != None)
	{
		bPinging = False;
		Owner.PingFinished();
	}
	else
	if(TotalPinging < MaxSimultaneousPing)
	{
		for(l = DeusExServerList(Next);l != None;l = DeusExServerList(l.Next))
		{
			if(		!l.bPinging 
				&&	!l.bPinged 
				&&	(!bInitial || !l.bNoInitalPing)
				&&	TotalPinging < MaxSimultaneousPing
			)
			{
				TotalPinging ++;		
				l.PingServer(bInitial, False, bNoSort);
			}

			if(TotalPinging >= MaxSimultaneousPing)
				break;
		}
	}
}

function DeusExServerList FindExistingServer(string FindIP, int FindQueryPort)
{
	local UWindowList l;

	for(l = Next;l != None;l = l.Next)
	{
		if(DeusExServerList(l).IP == FindIP && DeusExServerList(l).QueryPort == FindQueryPort)
			return DeusExServerList(l);
	}
	return None;
}

function PlayerPawn GetPlayerOwner()
{
	return DeusExServerList(Sentinel).Owner.GetPlayerPawn();
}

function UWindowList CopyExistingListItem(Class<UWindowList> ItemClass, UWindowList SourceItem)
{
	local DeusExServerList L;

	L = DeusExServerList(Super.CopyExistingListItem(ItemClass, SourceItem));

	L.bLocalServer	= DeusExServerList(SourceItem).bLocalServer;
	L.IP			= DeusExServerList(SourceItem).IP;
	L.QueryPort		= DeusExServerList(SourceItem).QueryPort;
	L.Ping			= DeusExServerList(SourceItem).Ping;
	L.HostName		= DeusExServerList(SourceItem).HostName;
	L.GamePort		= DeusExServerList(SourceItem).GamePort;
	L.MapName		= DeusExServerList(SourceItem).MapName;
	L.MapTitle		= DeusExServerList(SourceItem).MapTitle;
	L.MapDisplayName= DeusExServerList(SourceItem).MapDisplayName;
	L.MapName		= DeusExServerList(SourceItem).MapName;
	L.GameType		= DeusExServerList(SourceItem).GameType;
	L.GameMode		= DeusExServerList(SourceItem).GameMode;
	L.NumPlayers	= DeusExServerList(SourceItem).NumPlayers;
	L.MaxPlayers	= DeusExServerList(SourceItem).MaxPlayers;
	L.GameVer		= DeusExServerList(SourceItem).GameVer;
	L.MinNetVer		= DeusExServerList(SourceItem).MinNetVer;
	L.bKeepDescription = DeusExServerList(SourceItem).bKeepDescription;

	return L;
}

function int Compare(UWindowList T, UWindowList B)
{
   return 0; 
	//CompareCount++; //*********
	//return DeusExServerList(Sentinel).Owner.Grid.Compare(DeusExServerList(T), DeusExServerList(B));
}

function AppendItem(UWindowList L)
{
	Super.AppendItem(L);
	DeusExServerList(Sentinel).bNeedUpdateCount = True;
}

function Remove()
{
	local DeusExServerList S;

	S = DeusExServerList(Sentinel);
	Super.Remove();

	if(S != None)
		S.bNeedUpdateCount = True;
}

// Sentinel only
// FIXME: slow when lots of servers!!
function UpdateServerCount()
{
	local DeusExServerList l;

	TotalServers = 0;
	TotalPlayers = 0;
	TotalMaxPlayers = 0;

	for(l = DeusExServerList(Next);l != None;l = DeusExServerList(l.Next))
	{
		TotalServers++;
		TotalPlayers += l.NumPlayers;
		TotalMaxPlayers += l.MaxPlayers;
	}
}

function bool DecodeServerProperties(string Data)
{
	return True;
}

defaultproperties
{
     MaxSimultaneousPing=10
     PlayerListSortColumn=1
}
