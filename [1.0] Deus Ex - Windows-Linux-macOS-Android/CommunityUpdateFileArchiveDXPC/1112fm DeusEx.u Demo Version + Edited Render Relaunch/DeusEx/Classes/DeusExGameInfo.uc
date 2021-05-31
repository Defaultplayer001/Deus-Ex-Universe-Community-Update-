//=============================================================================
// DeusExGameInfo.
//=============================================================================
class DeusExGameInfo expands GameInfo
	config;
	
// ----------------------------------------------------------------------
// Login()
// ----------------------------------------------------------------------

event playerpawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<playerpawn> SpawnClass
)
{
	local DeusExPlayer player;
	local NavigationPoint StartSpot;
	local byte InTeam;
	local DumpLocation dump;

   //DEUS_EX AMSD In non multiplayer games, force JCDenton.
   if (!ApproveClass(SpawnClass))
   {
      SpawnClass=class'JCDentonMale';
   }

	player = DeusExPlayer(Super.Login(Portal, Options, Error, SpawnClass));

	// If we're traveling across a map on the same mission, 
	// nuke the player's crap and 

	if ((player != None) && (!HasOption(Options, "Loadgame")))
	{
		player.ResetPlayerToDefaults();

		dump = player.CreateDumpLocationObject();

		if ((dump != None) && (dump.HasLocationBeenSaved()))
		{
			dump.LoadLocation();

			player.Pause();
			player.SetLocation(dump.currentDumpLocation.Location);
			player.SetRotation(dump.currentDumpLocation.ViewRotation);
			player.ViewRotation = dump.currentDumpLocation.ViewRotation;
			player.ClientSetRotation(dump.currentDumpLocation.ViewRotation);

			CriticalDelete(dump);
		}
		else
		{
			InTeam    = GetIntOption( Options, "Team", 0 ); // Multiplayer now, defaults to Team_Unatco=0
         if (Level.NetMode == NM_Standalone)			
            StartSpot = FindPlayerStart( None, InTeam, Portal );
         else
            StartSpot = FindPlayerStart( Player, InTeam, Portal );

			player.SetLocation(StartSpot.Location);
			player.SetRotation(StartSpot.Rotation);
			player.ViewRotation = StartSpot.Rotation;
			player.ClientSetRotation(player.Rotation);
		}
	}
	return player;
}

// ----------------------------------------------------------------------
// ApproveClass()
// Is this class allowed for this gametype?  Override if you want to be 
// other than JCDentonMale.  If it returns false, will force JCDenton spawn.
// ----------------------------------------------------------------------

function bool ApproveClass( class<playerpawn> SpawnClass)
{
	return false;
}

// ----------------------------------------------------------------------
// DiscardInventory()
// ----------------------------------------------------------------------

function DiscardInventory( Pawn Other )
{
	// do nothing
}

// ----------------------------------------------------------------------
// ScoreKill()
// ----------------------------------------------------------------------

function ScoreKill(pawn Killer, pawn Other)
{
	// do nothing	
}

// ----------------------------------------------------------------------
// ClientPlayerPossessed()
// ----------------------------------------------------------------------
function ClientPlayerPossessed(PlayerPawn CheckPlayer)
{
	CheckPlayerWindow(CheckPlayer);
	CheckPlayerConsole(CheckPlayer);
}

// ----------------------------------------------------------------------
// CheckPlayerWindow()
// ----------------------------------------------------------------------
function CheckPlayerWindow(PlayerPawn CheckPlayer)
{
	// do nothing.
}

// ----------------------------------------------------------------------
// CheckPlayerConsole()
// ----------------------------------------------------------------------
function CheckPlayerConsole(PlayerPawn CheckPlayer)
{
	// do nothing.
}

// ----------------------------------------------------------------------
// FailRootWindowCheck()
// ----------------------------------------------------------------------
function FailRootWindowCheck(PlayerPawn FailPlayer)
{
	// do nothing
}

// ----------------------------------------------------------------------
// FailConsoleCheck()
// ----------------------------------------------------------------------
function FailConsoleCheck(PlayerPawn FailPlayer)
{
	// do nothing
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bMuteSpectators=True
     AutoAim=1.000000
}
