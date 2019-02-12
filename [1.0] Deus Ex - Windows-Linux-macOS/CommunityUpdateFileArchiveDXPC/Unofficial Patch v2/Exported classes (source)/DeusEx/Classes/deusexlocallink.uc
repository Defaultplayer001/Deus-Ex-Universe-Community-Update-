//=============================================================================
// DeusExLocalLink: Receives LAN beacons from servers.
//=============================================================================
class DeusExLocalLink extends UdpLink
	transient;

// Misc
var MenuScreenJoinGame	OwnerWindow;

// Config
var config string						BeaconProduct;
var config int							ServerBeaconPort;

function Start()
{
	local int p;

	if( BindPort() == 0 )
	{
		OwnerWindow.QueryFinished(False, "DeusExLocalLink: Could not bind to a free port.");
		return;
	}
	BroadcastBeacon();
}

function Timer()
{
	OwnerWindow.QueryFinished(True);
}

function BroadcastBeacon()
{
	local IpAddr Addr;
	local int i;

	Addr.Addr = BroadcastAddr;

	for(i=0;i<10;i++)
	{
		Addr.Port = ServerBeaconPort + i;
		SendText( Addr, "REPORTQUERY" );
	}
}

event ReceivedText( IpAddr Addr, string Text )
{
	local int n;
	local int QueryPort;
	local string Address;

	n = len(BeaconProduct);
	if( Left(Text,n+1) ~= (BeaconProduct$" ") )
	{
		QueryPort = int(Mid(Text, n+1));
		Address = IpAddrToString(Addr);
		Address = Left(Address, InStr(Address, ":"));
		OwnerWindow.FoundServer(Address, QueryPort, "", BeaconProduct);
	}
}

event Destroyed()
{
   OwnerWindow = None;
   Super.Destroyed();
}

defaultproperties
{
     BeaconProduct="DeusEx"
     ServerBeaconPort=8777
}
