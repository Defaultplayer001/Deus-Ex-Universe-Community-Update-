//=============================================================================
// MenuScreenJoinInternet (multiplayer)
//=============================================================================

class MenuScreenJoinInternet expands MenuScreenJoinGame;

var DeusExGSpyLink Link;

// ----------------------------------------------------------------------
// Query()
// ----------------------------------------------------------------------

function Query()
{
   Link = GetPlayerPawn().GetEntryLevel().Spawn(class'DeusExGSpyLink');

	Link.MasterServerAddress = MasterServerAddress;
	Link.MasterServerTCPPort = MasterServerTCPPort;
	Link.Region = Region;
	Link.MasterServerTimeout = MasterServerTimeout;
	Link.GameName = GameName;
   Link.OwnerWindow = Self;

   Link.Start();
}

// ---------------------------------------------------------------------
// QueryFinished()
// ---------------------------------------------------------------------

function QueryFinished(bool bSuccess, optional string ErrorMsg)
{
	Link.Destroy();
	Link = None;

   PingUnpingedServers();
}

// ---------------------------------------------------------------------
// ShutdownLink()
// ---------------------------------------------------------------------

function ShutdownLink()
{
	if(Link != None)
		Link.Destroy();
	Link = None;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	bHandled = True;

	switch( buttonPressed )
	{
		case HostButton:
         ProcessMenuAction(MA_MenuScreen,Class'MenuScreenHostNet');
			break;

		default:
			bHandled = False;
			break;
	}

	if ( !bHandled )
		bHandled = Super.ButtonActivated(buttonPressed);

	return bHandled;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     Title="Start Multiplayer Internet Game"
}
