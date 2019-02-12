//=============================================================================
// HUDMultiplayer
//=============================================================================

class HUDMultiplayer extends DeusExBaseWindow;			// This should only happen at the end of a match

var String			winnerName;
var int				winningTeam;
var float			inputLockoutTimer;						// Don't even try to kill window until timer counts down
const	inputLockoutDelay = 3;									// Seconds until user can proceed

var bool				bDestroy;
var String			winKiller, winKillee, winMethod;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Refresh the scoreArray, then freeze the scores so when players jump into next game
	// the data doesn't change.
	if ( DeusExMPGame(Player.DXGame) != None )
	{
		DeusExMPGame(Player.DXGame).RefreshScoreArray( Player );
		Player.bShowScores = True;
	}
	SetWindowAlignments(HALIGN_Full, VALIGN_Full);
	Show();
	root.ShowCursor( False );
	inputLockoutTimer = Player.Level.Timeseconds + inputLockoutDelay;
	bDestroy = False;
}																			  

// ----------------------------------------------------------------------
// DestroyWindow()
// ----------------------------------------------------------------------

event DestroyWindow()
{
	root.ShowCursor( True );

	// Unfreeze the scoreArray now that we are starting out next game
	if ( DeusExMPGame(Player.DXGame) != None )
	{
		Player.bShowScores = False;
	}
	inputLockoutTimer = 0;
	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	if ( Player != None )
	{
		if ( DeathMatchGame(Player.DXGame) != None )
			DeathMatchGame(Player.DXGame).PlayerWinScreen( Player, GC, width, height, winningTeam, winnerName, winKiller, winKillee, winMethod );
		else if ( TeamDMGame(Player.DXGame) != None )
			TeamDMGame(Player.DXGame).TeamWinScreen( Player, GC, width, height, winningTeam, winKiller, winKillee, winMethod );
	}
	Super.DrawWindow(gc);
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bKeyHandled;
	local String KeyName, Alias;

	bKeyHandled = False;

	if (!bRepeat)
	{
		switch(key) 
		{
			case IK_Escape:
				bKeyHandled = True;
				break;
		}
	}

	// Let them send chat messages
	KeyName = player.ConsoleCommand("KEYNAME "$key );
	Alias = 	player.ConsoleCommand( "KEYBINDING "$KeyName );

	if ( Alias ~= "Talk" )
		Player.Player.Console.Talk();
	else if ( Alias ~= "TeamTalk" )
		Player.Player.Console.TeamTalk();

	if ( !bKeyHandled && ( inputLockoutTimer > Player.Level.Timeseconds ))
		return True;

	if ( bKeyHandled && !bDestroy )
	{
		bDestroy = True;
		Player.DisconnectPlayer();
		return True;
	}
	return True;
}

defaultproperties
{
}
