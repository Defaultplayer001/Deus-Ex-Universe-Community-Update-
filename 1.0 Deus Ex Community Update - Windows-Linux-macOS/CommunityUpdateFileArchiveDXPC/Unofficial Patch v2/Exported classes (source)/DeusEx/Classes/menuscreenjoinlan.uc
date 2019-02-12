//=============================================================================
// MenuScreenJoinLan (multiplayer)
//=============================================================================

class MenuScreenJoinLan expands MenuScreenJoinGame;

var DeusExLocalLink Link;
var string						BeaconProduct;
var int							ServerBeaconPort;

// ----------------------------------------------------------------------
// Query()
// ----------------------------------------------------------------------

function Query()
{
   Link = GetPlayerPawn().GetEntryLevel().Spawn(class'DeusExLocalLink');

   Link.OwnerWindow = Self;
   Link.Start();
   Link.SetTimer(1.0,False);
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
// GetExtraJoinOptions()
// ----------------------------------------------------------------------

function string GetExtraJoinOptions()
{
   return Super.GetExtraJoinOptions() $ "?lan";
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
         ProcessMenuAction(MA_MenuScreen,Class'MenuScreenHostLan');
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
     Title="Start Multiplayer LAN Game"
}
