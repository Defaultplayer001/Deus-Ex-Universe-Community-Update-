//=============================================================================
// DeathMatchGame.
//=============================================================================
class DeathMatchGame expands DeusExMPGame;

var localized String	VictoryConString1, VictoryConString2, TimeLimitString1, TimeLimitString2;

//
// PreGameOver is called before end of match notice is sent out
//
function PreGameOver()
{
	Super.PreGameOver();
}

//
// GameOver is called after all end of match notices have been sent out
//
function GameOver()
{
	Super.GameOver();
}

// ---------------------------------------------------------------------
// EvaluatePlayerStart()
// ---------------------------------------------------------------------
function float EvaluatePlayerStart(Pawn Player, PlayerStart PointToEvaluate, optional byte InTeam)
{
   local bool bTooClose;
   local DeusExPlayer OtherPlayer;
   local float Dist;
   local Pawn CurPawn;
   local float CumulativeDist;

   bTooClose = False;

   if (PointToEvaluate.bTeamOnlyStart)
      return -100000;

   //DEUS_EX AMSD Small random factor.
   CumulativeDist = FRand();

   for (CurPawn = Level.PawnList; CurPawn != None; CurPawn = CurPawn.NextPawn)
   {
      OtherPlayer = DeusExPlayer(CurPawn);
      if ((OtherPlayer != None) && (OtherPlayer != Player))
      {
         //Get Dist
         Dist = VSize(OtherPlayer.Location - PointToEvaluate.Location);

         //Do a quick distance check
         if (Dist < 100.0)
         {
            bTooClose = TRUE;
         }

         //Make it non zero
         Dist = Dist + 0.1;
         Dist = 10000/Dist;

         //Now someone close to you has a really high Dist, and someone far away has a really low dist.
         //This should bias away from putting you right next to someone.
         
         //Add in distances of opponents.
         CumulativeDist = CumulativeDist - Dist;
      }
   }

   if (bTooClose)
      return -100000;
   else
      return CumulativeDist;
}

// ---------------------------------------------------------------------
// PlayerWinScreen()
// ---------------------------------------------------------------------

simulated function PlayerWinScreen( DeusExPlayer thisPlayer, GC gc, float screenWidth, float screenHeight, int winningTeam, String winnerName,
											  String killerStr, String killeeStr, String methodStr )
{
	local String str;
	local float x, y, w, h;

	// Show who won the match
	gc.SetTextColor( GoldColor );
	gc.SetFont(Font'FontMenuExtraLarge');

	if ( winningTeam == TEAM_DRAW )
		str = TeamDrawString;
	else
		str = winnerName $ WonMatchString;

	gc.GetTextExtent( 0, w, h, str );
	x = (screenWidth * 0.5) - (w * 0.5);
	y = screenHeight * WinY;
	gc.DrawText( x, y, w, h, str );

	y += h;

	// Show who won it and who got killed
	if ( VictoryCondition ~= "Frags" )
	{
		gc.SetFont(Font'FontMenuTitle');
		if (( killerStr ~= "" ) || (killeeStr ~= "") || (methodStr ~=""))
			log( "Warning:Bad kill string in final death message." );
		else
		{
			str = MatchEnd1String $ killerStr $ MatchEnd2String $ killeeStr $ methodStr;
			gc.GetTextExtent( 0, w, h, str );
			if ( w >= screenWidth )
			{
				y -= (h * 0.5);
				str = MatchEnd1String $ killerStr $ MatchEnd2String $ killeeStr;
				gc.GetTextExtent( 0, w, h, str );
				x = (screenWidth * 0.5) - (w * 0.5);
				gc.DrawText( x, y, w, h, str );
				y += h;
				str = methodStr;
				gc.GetTextExtent( 0, w, h, str );
				x = (screenWidth * 0.5) - (w * 0.5);
				gc.DrawText( x, y, w, h, str );

			}
			else
			{
				x = (screenWidth * 0.5) - (w * 0.5);
				gc.DrawText( x, y, w, h, str );
			}
		}
	}

	// Show the scoreboard for all to see
	ShowDMScoreboard( thisPlayer, gc, screenWidth, screenHeight );

	// Press fire to continue message
	ContinueMsg( gc, screenWidth, screenHeight );
}

// ---------------------------------------------------------------------
// PlayerHasWon()
// ---------------------------------------------------------------------

function PlayerHasWon( Pawn winPawn, Pawn Killer, Pawn Killee, String Method )
{
	local Pawn curPawn;
	local String killerStr, killeeStr;
	local int tieFlag;

	PreGameOver();

	killerStr = ""; killeeStr = "";
	if (( Killer != None ) && ( Killee != None ))
	{
		killerStr = Killer.PlayerReplicationInfo.PlayerName;
		killeeStr = Killee.PlayerReplicationInfo.PlayerName;
	}

	if ( winPawn == None )
		tieFlag = TEAM_DRAW;
	else
		tieFlag = 0;

	// Notify all palyers that so-and-so won the match
	curPawn = Level.PawnList;
	while ( curPawn != None )
	{
		if ( curPawn.IsA( 'DeusExPlayer' ) )
		{
			DeusExPlayer(curPawn).ShowMultiplayerWin( winPawn.PlayerReplicationInfo.PlayerName, tieFlag, killerStr, killeeStr, Method );
		}
		curPawn = curPawn.nextPawn;
	}

   GameOver();
}

// ---------------------------------------------------------------------
// GetWinningPlayer
// ---------------------------------------------------------------------

function GetWinningPlayer( out Pawn curWinner )
{
	local Pawn winner, curPawn, tiePawn;

	curPawn = Level.PawnList;
	winner = curPawn;
	tiePawn = None;

	while ( curPawn != None )
	{
		if ( curPawn.IsA( 'DeusExPlayer' ) )
		{											   					  
			if ( curPawn.PlayerReplicationInfo.Score > winner.PlayerReplicationInfo.Score )
				winner = curPawn;
			else if (( curPawn.PlayerReplicationInfo.Score == winner.PlayerReplicationInfo.Score ) &&
					  ( curPawn.PlayerReplicationInfo.Deaths < winner.PlayerReplicationInfo.Deaths ) )
				winner = curPawn;
			else if ( ( curPawn.PlayerReplicationInfo.Score == winner.PlayerReplicationInfo.Score ) && 
					  ( curPawn.PlayerReplicationInfo.Deaths == winner.PlayerReplicationInfo.Deaths ) &&
					  ( curPawn.PlayerReplicationInfo.Streak > winner.PlayerReplicationInfo.Streak) )
				winner = curPawn;
			else if ( (curPawn != winner) && ( curPawn.PlayerReplicationInfo.Score == winner.PlayerReplicationInfo.Score ) &&
					  ( curPawn.PlayerReplicationInfo.Deaths == winner.PlayerReplicationInfo.Deaths ) &&
					  ( curPawn.PlayerReplicationInfo.Streak == winner.PlayerReplicationInfo.Streak) )
				tiePawn = curPawn;

		}
		curPawn = curPawn.nextPawn;
	}
	if ( tiePawn != None )
	{
		if ( ( tiePawn.PlayerReplicationInfo.Score == winner.PlayerReplicationInfo.Score ) &&
		   ( tiePawn.PlayerReplicationInfo.Deaths == winner.PlayerReplicationInfo.Deaths ) &&
		   ( tiePawn.PlayerReplicationInfo.Streak == winner.PlayerReplicationInfo.Streak) )
			curWinner = None;
		else
			curWinner = winner;
	}
	else
		curWinner = winner;
}

// ---------------------------------------------------------------------
// CheckVictoryCondtions()
// ---------------------------------------------------------------------

function bool CheckVictoryConditions( Pawn Killer, Pawn Killee, String Method )
{
	local Pawn winner;

	if ( VictoryCondition ~= "Frags" )
	{
		GetWinningPlayer( winner );

		if ( winner != None )
		{
			if (( winner.PlayerReplicationInfo.Score == ScoreToWin-(ScoreToWin/5)) && ( ScoreToWin >= 10 ))
				NotifyGameStatus( ScoreToWin/5, winner.PlayerReplicationInfo.PlayerName, False, False );
			else if (( winner.PlayerReplicationInfo.Score == (ScoreToWin - 1) ) && (ScoreTowin >= 2 ))
				NotifyGameStatus( 1, winner.PlayerReplicationInfo.PlayerName, False, True );

			if ( winner.PlayerReplicationInfo.Score >= ScoreToWin )
			{
				PlayerHasWon( winner, Killer, Killee, Method );
				return True;
			}
		}
	}
	else if ( VictoryCondition ~= "Time" )
	{
		timeLimit = float(ScoreToWin)*60.0;

		if (( Level.Timeseconds >= timeLimit-NotifyMinutes*60.0 ) && ( timeLimit > NotifyMinutes*60.0*2.0 ))
		{
			GetWinningPlayer( winner );
			NotifyGameStatus( int(NotifyMinutes), winner.PlayerReplicationInfo.PlayerName, True, True );
		}

		if ( Level.Timeseconds >= timeLimit )
		{
			GetWinningPlayer( winner );
			PlayerHasWon( winner, Killer, Killee, Method );
			return true;
		}
	}
	return false;
}

// ---------------------------------------------------------------------
// ShowVictoryConditions()
// ---------------------------------------------------------------------

simulated function ShowVictoryConditions( GC gc, float screenWidth, float yoffset, DeusExPlayer thisPlayer )
{
	local String str, secStr;
	local float x, y, w, h;
	local int timeLeft, minutesLeft, secondsLeft;
	local float ftimeLeft;

	if ( VictoryCondition ~= "Frags" )
		str = VictoryConString1 $ ScoreToWin $ VictoryConString2;
	else if ( VictoryCondition ~= "Time" )
	{
		timeLeft = ScoreToWin * 60 - Level.Timeseconds - thisPlayer.ServerTimeDiff;
		if ( timeLeft < 0 )
			timeleft = 0;
		minutesLeft = timeLeft/60;
		ftimeLeft = float(timeLeft);
		secondsLeft = int(ftimeLeft%60);
		if ( secondsLeft < 10 )
			secStr = "0" $ secondsLeft;
		else
			secStr = "" $ secondsLeft;

		str = TimeLimitString1 $ minutesLeft $ ":" $ secStr $ TimeLimitString2;
	}
	else
		log( "Warning: Unknown victory type:"$VictoryCondition$" " );

	gc.GetTextExtent( 0, w, h, str );
	x = (screenWidth * 0.5) - (w * 0.5);
	gc.DrawText( x, yoffset, w, h, str );
}

//-------------------------------------------------------------------------------------------------
// ShowDMScoreboard()
//-------------------------------------------------------------------------------------------------
simulated function ShowDMScoreboard( DeusExPlayer thisPlayer, GC gc, float screenWidth, float screenHeight )
{
	local float yoffset, ystart, xlen, ylen;
	local String str;
	local bool bLocalPlayer;
	local int i;

	if ( !thisPlayer.PlayerIsClient() )
		return;

	gc.SetFont(Font'FontMenuSmall');

	RefreshScoreArray( thisPlayer );

	SortScores();

	str = "TEST";
	gc.GetTextExtent( 0, xlen, ylen, str );

	ystart = screenHeight * PlayerY;
	yoffset = ystart;

	gc.SetTextColor( WhiteColor );
	ShowVictoryConditions( gc, screenWidth, ystart, thisPlayer );
	yoffset += (ylen * 2.0);
	DrawHeaders( gc, screenWidth, yoffset );
	yoffset += (ylen * 1.5);

	for ( i = 0; i < scorePlayers; i++ )
	{
		bLocalPlayer = (scoreArray[i].PlayerID == thisPlayer.PlayerReplicationInfo.PlayerID);

		if ( bLocalPlayer )
			gc.SetTextColor( GoldColor );
		else
			gc.SetTextColor( WhiteColor );

		yoffset += ylen;
		DrawNameAndScore( gc, scoreArray[i], screenWidth, yoffset );
	}
}

defaultproperties
{
     VictoryConString1="Objective: First player that reaches "
     VictoryConString2=" kills wins the match."
     TimeLimitString1="Objective: Score the most kills before the clock ( "
     TimeLimitString2=" ) runs out!"
     bAutoInstall=False
}
