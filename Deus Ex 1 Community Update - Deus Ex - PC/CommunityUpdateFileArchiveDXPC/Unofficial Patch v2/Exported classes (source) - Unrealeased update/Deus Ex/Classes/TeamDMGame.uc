//=============================================================================
// TeamDeathMatch
//=============================================================================
class TeamDMGame expands DeusExMPGame;

var int TeamScore[2];

var localized String			EnemiesString, AlliesString, VictoryConString1, VictoryConString2, TimeLimitString1, TimeLimitString2;
var localized String			TeamScoreString;

var ScoreElement				teamSE[32];				// Local array to keep track of team lists


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
// Login()
// ---------------------------------------------------------------------
event PlayerPawn Login(string Portal, string Options, out string Error, class<playerpawn> SpawnClass)
{
	local PlayerPawn newPlayer;
   local int TeamOption;
   local string StringTeamOption;

   TeamOption = TEAM_AUTO;
   if (HasOption(Options,"Team"))
   {
      StringTeamOption = ParseOption(Options,"Team");
	  if (StringTeamOption != "")
		  TeamOption = int(StringTeamOption);
   }

   if (!ApproveTeam(TeamOption))
	   TeamOption = TEAM_AUTO;

   if (TeamOption == TEAM_AUTO)
      TeamOption = GetAutoTeam();

   if (TeamOption == TEAM_UNATCO)
      SpawnClass = class'MPUnatco';
   else if (TeamOption == TEAM_NSF)
      SpawnClass = class'MPNSF';

   ChangeOption(Options,"Team",string(TeamOption));

	newPlayer = Super.Login(Portal, Options, Error, SpawnClass);

	newPlayer.bAutoActivate = true;

	return newPlayer;
}

// ---------------------------------------------------------------------
// PostLogin()
// ---------------------------------------------------------------------
event PostLogin(playerpawn NewPlayer)
{
   local DeusExPlayer DXPlayer;

   DXPlayer = DeusExPlayer(NewPlayer);

	// Set teams up if in a team game
   SetTeam( DXPlayer );

   Super.PostLogin(NewPlayer);
}

// ----------------------------------------------------------------------
// ApproveTeam()
// Is this Team allowed for this gametype?  Override if you want to be 
// other than UNATCO/NSF/AUTO
// ----------------------------------------------------------------------

function bool ApproveTeam(int CheckTeam)
{
	if (CheckTeam == TEAM_UNATCO)
		return true;
	if (CheckTeam == TEAM_NSF)
		return true;
	if (CheckTeam == TEAM_AUTO)
		return true;

	return false;
}


// ---------------------------------------------------------------------
// GetAutoTeam()
// ---------------------------------------------------------------------
function int GetAutoTeam()
{
   local int NumUNATCO;
   local int NumNSF;
   local int CurTeam;
   local Pawn CurPawn;

   NumUNATCO = 0;
   NumNSF = 0;

   for (CurPawn = Level.Pawnlist; CurPawn != None; CurPawn = CurPawn.NextPawn)
   {
      if ((PlayerPawn(CurPawn) != None) && (PlayerPawn(CurPawn).PlayerReplicationInfo != None))
      {

         CurTeam = PlayerPawn(CurPawn).PlayerReplicationInfo.Team;
         if (CurTeam == TEAM_UNATCO)
         {
            NumUNATCO++;
         }
         else if (CurTeam == TEAM_NSF)
         {
            NumNSF++;
         }
      }
   }

   if (NumUNATCO < NumNSF)
      return TEAM_UNATCO;
   else if (NumUNATCO > NumNSF)
      return TEAM_NSF;
   else
      return TEAM_UNATCO;
}

// ---------------------------------------------------------------------
// ChangeOption()
// ---------------------------------------------------------------------

function ChangeOption(out string Options, string OptionKey, string NewValue)
{
   local string NewOptions;//new option string
   local string CurOption;
   local string CurKey;
   local string CurValue;

   NewOptions = "";

   while (GrabOption(Options,CurOption))
   {
      GetKeyValue(CurOption, CurKey, CurValue);
      if (CurKey ~= OptionKey)
         CurValue = NewValue;
      NewOptions = NewOptions $ "?" $ CurKey $ "=" $ CurValue;
   }

   Options = NewOptions;
}

// ---------------------------------------------------------------------
// ArePlayersAllied()
// ---------------------------------------------------------------------

simulated function bool ArePlayersAllied(DeusExPlayer FirstPlayer, DeusExPlayer SecondPlayer)
{
   if ((FirstPlayer == None) || (SecondPlayer == None))
      return false;
   return (FirstPlayer.PlayerReplicationInfo.team == SecondPlayer.PlayerReplicationInfo.team);
}

// ---------------------------------------------------------------------
// EvaluatePlayerStart()
// ---------------------------------------------------------------------
function float EvaluatePlayerStart(Pawn Player, PlayerStart PointToEvaluate, optional byte InTeam)
{
   local bool bTooClose;
   local DeusExPlayer OtherPlayer;
   local Pawn CurPawn;
   local float Dist;
   local float Cost;
   local float CumulativeDist;

   bTooClose = False;

   if (PointToEvaluate.bNonTeamOnlyStart)
   {
      return -100000;
   }

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
         Cost = 0;

         if (dist < 200)
            cost = 300;
         else if (dist < 400)
            cost = 250;
         else if (dist < 800)
            cost = 175;
         else if (dist < 1600)
            cost = 100;
         else if (dist < 3200)
            cost = 25;
         else 
            cost = 0;
         //Cost = 10000/Dist;

         //Now someone close to you has a really high Dist, and someone far away has a really low dist.
         //This should bias away from putting you right next to someone.

         
         //Subract distances of opponents, add distance of friends.
         //If first spawn, just put you someplace.
         if ( ((DeusExPlayer(Player) != None) && (!ArePlayersAllied(DeusExPlayer(Player),OtherPlayer))) ||
              ((InTeam != 255) && (InTeam != OtherPlayer.PlayerReplicationInfo.Team)) )
         {
            CumulativeDist = CumulativeDist - 5*Cost;
         }
         else
         {
            CumulativeDist = CumulativeDist + Cost;
         }
      }
   }

   if (bTooClose)
   {
      return -100000;
   }
   else
   {
      return CumulativeDist;
   }
}

// ---------------------------------------------------------------------
// TeamWinScreen()
// ---------------------------------------------------------------------

simulated function TeamWinScreen( DeusExPlayer thisPlayer, GC gc, float screenWidth, float screenHeight, int winningTeam,
											String killerStr, String killeeStr, String methodStr )
{
	local String str;
	local float x, y, w, h;

	// Show who won the match
	if ( thisPlayer.PlayerReplicationInfo.team == winningTeam )
		gc.SetTextColor( GreenColor );
	else
		gc.SetTextColor( RedColor );

	gc.SetFont(Font'FontMenuExtraLarge');

	switch( winningTeam )
	{
		case TEAM_NSF:
			str = TeamNsfString $ WonMatchString;
			break;
		case TEAM_UNATCO:
			str = TeamUnatcoString $ WonMatchString;
			break;
		case TEAM_DRAW:
			str = TeamDrawString;
			break;
	}

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
	ShowTeamDMScoreboard( thisPlayer, gc, screenWidth, screenHeight );

	// Press fire to continue message
	ContinueMsg( gc, screenWidth, screenHeight );
}

// ---------------------------------------------------------------------
// SetTeam()
// ---------------------------------------------------------------------

function SetTeam( DeusExPlayer player )
{
	if ( player.IsA('MPUnatco'))
	{
		player.PlayerReplicationInfo.Team = TEAM_UNATCO;
		player.MultiplayerNotifyMsg( player.MPMSG_TeamUnatco );
	}
	else if ( player.IsA('MPNsf'))
	{
		player.PlayerReplicationInfo.Team = TEAM_NSF;
		player.MultiplayerNotifyMsg( player.MPMSG_TeamNsf );
	}
	else
		log( "Warning: Player:"$player$" has chosen an invalid team!" );
}


// ---------------------------------------------------------------------
// GetTeamList()
// ---------------------------------------------------------------------

simulated function int GetTeamList( DeusExPlayer player, bool Allies )
{
	local int i, numTeamList;

	if ( player == None )
		return( 0 );

	numTeamList = 0;

	for ( i = 0; i < scorePlayers; i++ )
	{
		if ( (Allies && (scoreArray[i].Team == player.PlayerReplicationInfo.Team) ) ||
			  (!Allies && (scoreArray[i].Team != player.PlayerReplicationInfo.Team) ) )
		{
				teamSE[numTeamList] = scoreArray[i];
				numTeamList += 1;
		}
	}
	return( numTeamList );
}

// ---------------------------------------------------------------------
// CalcTeamScore()
// ---------------------------------------------------------------------

function CalcTeamScores()
{
	local DeusExPlayer curPlayer;
	local Pawn curPawn;

	TeamScore[TEAM_NSF] = 0;
	TeamScore[TEAM_UNATCO] = 0;

	// This only happens once per kill on the server
	curPawn = Level.PawnList;
	while ( curPawn != None )
	{
		if ( curPawn.IsA('DeusExPlayer') )
		{
			if ( DeusExPlayer(curPawn).PlayerReplicationInfo.team == TEAM_NSF )
				TeamScore[TEAM_NSF] += int(DeusExPlayer(curPawn).PlayerReplicationInfo.Score);
			if ( DeusExPlayer(curPawn).PlayerReplicationInfo.team == TEAM_UNATCO )
				TeamScore[TEAM_UNATCO] += int(DeusExPlayer(curPawn).PlayerReplicationInfo.Score);
		}
		curPawn = curPawn.nextPawn;
	}
}

// ---------------------------------------------------------------------
// TeamFinalCheckScores()
// ---------------------------------------------------------------------

simulated function bool TeamFinalCheckScores()
{
	local int i, nsfScore, unatcoScore;

	nsfScore = 0;
	unatcoScore = 0;
	for ( i = 0; i < scorePlayers; i++ )
	{
		if ( scoreArray[i].team == TEAM_NSF )
			nsfScore += (scoreArray[i].score);
		else if ( scoreArray[i].team == TEAM_UNATCO )
			unatcoScore += (scoreArray[i].score);
	}
	if ( (nsfScore >= ScoreToWin) || (unatcoScore >= ScoreToWin))
		return True;
	else
		return False;
}

// ---------------------------------------------------------------------
// TeamHasWon()
// ---------------------------------------------------------------------

function TeamHasWon( int team, Pawn Killer, Pawn Killee, String Method )
{
	local Pawn curPawn;
	local String str, killerStr, killeeStr;

	PreGameOver();

	killerStr = ""; killeeStr = "";
	if (( Killer != None ) && ( Killee != None ))
	{
		killerStr = Killer.PlayerReplicationInfo.PlayerName;
		killeeStr = Killee.PlayerReplicationInfo.PlayerName;
	}

	if ( team == TEAM_UNATCO )
		str = TeamUnatcoString;
	else
		str = TeamNsfString;

	curPawn = Level.PawnList;
	while ( curPawn != None )
	{
		if ( curPawn.IsA('DeusExPlayer') )
		{
			DeusExPlayer(curPawn).ShowMultiplayerWin( str, team, killerStr, killeeStr, Method );
		}
		curPawn = curPawn.nextPawn;
	}

   GameOver();
}

// ---------------------------------------------------------------------
// CheckVictoryCondtions()
// ---------------------------------------------------------------------

function bool CheckVictoryConditions(Pawn Killer, Pawn Killee, String Method)
{
	local float timeLimit;

	CalcTeamScores();

	if ( VictoryCondition ~= "Frags" )
	{	
		if (( TeamScore[TEAM_UNATCO] == ScoreToWin-(ScoreToWin/5)) && ( ScoreToWin >= 10 ))
			NotifyGameStatus( ScoreToWin/5, TeamUnatcoString, False, False );
		if (( TeamScore[TEAM_UNATCO] == ScoreToWin - 1 ) && (ScoreTowin >= 2 ))
			NotifyGameStatus( 1, TeamUnatcoString, False, True );
		if (( TeamScore[TEAM_NSF] == ScoreToWin-(ScoreToWin/5)) && ( ScoreToWin >= 10 ))
			NotifyGameStatus( ScoreToWin/5, TeamNsfString, False, False );
		if (( TeamScore[TEAM_NSF] == ScoreToWin-1 ) && (ScoreTowin >= 2 ))
			NotifyGameStatus( 1, TeamNsfString, False, True );

		if ( TeamScore[TEAM_UNATCO] >= ScoreToWin )
		{
			TeamHasWon( TEAM_UNATCO, Killer, Killee, Method );
			return true;
		}
		if ( TeamScore[TEAM_NSF] >= ScoreToWin )
		{
			TeamHasWon( TEAM_NSF, Killer, Killee, Method );
			return true; 
		}
	}
	else if ( VictoryCondition ~= "Time" )
	{
		timeLimit = float(ScoreToWin)*60.0;

		if (( Level.Timeseconds >= (timeLimit-NotifyMinutes*60.0) ) && ( timeLimit >= NotifyMinutes*60.0*2.0 ))
		{
			if ( TeamScore[TEAM_UNATCO] > TeamScore[TEAM_NSF] )
				NotifyGameStatus( int(NotifyMinutes), TeamUnatcoString, True, True );
			else if ( TeamScore[TEAM_UNATCO] == TeamScore[TEAM_NSF] )
				NotifyGameStatus( int(NotifyMinutes), "Tied", True, True );
			else
				NotifyGameStatus( int(NotifyMinutes), TeamNsfString, True, True );
		}

		if ( Level.Timeseconds >= timeLimit )
		{
			if ( TeamScore[TEAM_UNATCO] > TeamScore[TEAM_NSF] )
			{
				TeamHasWon( TEAM_UNATCO, Killer, Killee, Method );
				return true;
			}
			else if ( TeamScore[TEAM_UNATCO] < TeamScore[TEAM_NSF] )
			{
				TeamHasWon( TEAM_NSF, Killer, Killee, Method );
				return true;
			}
			else
			{
				TeamHasWon( TEAM_DRAW, Killer, Killee, Method );
				return true;
			}
		}
	}
	else
		log( "Warning: Unknown victory type:"$VictoryCondition$" " );

	return false;
}

// ---------------------------------------------------------------------
// ShowVictoryConditions()
// ---------------------------------------------------------------------

simulated function ShowVictoryConditions( GC gc, float screenWidth, float yoffset, DeusExPlayer thisPlayer )
{
	local String str, secStr;
	local float x, y, w, h;
	local int minutesLeft, secondsLeft, timeLeft;
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
// SortTeamScores()
//-------------------------------------------------------------------------------------------------
simulated function SortTeamScores( int PlayerCount )
{
	local ScoreElement tmpSE;
	local int i, j, max;
	
	for ( i = 0; i < PlayerCount-1; i++ )
	{
		max = i;
		for ( j = i+1; j < PlayerCount; j++ )
		{
			if ( teamSE[j].Score > teamSE[max].Score )
				max = j;
			else if (( teamSE[j].Score == teamSE[max].Score) && (teamSE[j].Deaths < teamSE[max].Deaths))
				max = j;
		}
		tmpSE = teamSE[max];
		teamSE[max] = teamSE[i];
		teamSE[i] = tmpSE;
	}
}

// ---------------------------------------------------------------------
// LocalGetTeamTotals()
// ---------------------------------------------------------------------

simulated function LocalGetTeamTotals( int teamSECnt, out float score, out float deaths, out float streak )
{
	local int i;

	score = 0; deaths = 0; streak = 0;
	for ( i = 0; i < teamSECnt; i++ )
	{
		score += teamSE[i].Score;
		deaths += teamSE[i].Deaths;
		streak += teamSE[i].Streak;
	}
}


// ---------------------------------------------------------------------
// ShowTeamDMScoreboard()
// ---------------------------------------------------------------------

simulated function ShowTeamDMScoreboard( DeusExPlayer thisPlayer, GC gc, float screenWidth, float screenHeight )
{
	local float yoffset, ystart, xlen, ylen, w, h, w2;
	local bool bLocalPlayer;
	local int i, allyCnt, enemyCnt, barLen;
	local ScoreElement fakeSE;
	local String str, teamStr;

	if ( !thisPlayer.PlayerIsClient() )
		return;

	// Always use this font
	gc.SetFont(Font'FontMenuSmall');
	str = "TEST";
	gc.GetTextExtent( 0, xlen, ylen, str );

	// Refresh out local array
	RefreshScoreArray( thisPlayer );

	// Just allies
	allyCnt = GetTeamList( thisPlayer, True );
	SortTeamScores( allyCnt );

	ystart = screenHeight * PlayerY;
	yoffset = ystart;

	// Headers
	gc.SetTextColor( WhiteColor );
	ShowVictoryConditions( gc, screenWidth, ystart, thisPlayer );
	yoffset += (ylen * 2.0);
	DrawHeaders( gc, screenWidth, yoffset );
	yoffset += (ylen * 1.5);

	if ( thisPlayer.PlayerReplicationInfo.team == TEAM_UNATCO )
		teamStr = TeamUnatcoString;
	else
		teamStr = TeamNsfString;

	// Allies
	gc.SetTextColor( GreenColor );
	fakeSE.PlayerName = AlliesString $ " (" $ teamStr $ ")";
	LocalGetTeamTotals( allyCnt, fakeSE.score, fakeSE.deaths, fakeSE.streak );
	DrawNameAndScore( gc, fakeSE, screenWidth, yoffset );
	gc.GetTextExtent( 0, w, h, StreakString );
	barLen = (screenWidth * StreakX + w)-(PlayerX*screenWidth);
	gc.SetTileColorRGB(0,255,0);
	gc.DrawBox( PlayerX * screenWidth, yoffset+h, barLen, 1, 0, 0, 1, Texture'Solid');
	yoffset += ( h * 0.25 );
	for ( i = 0; i < allyCnt; i++ )
	{
		bLocalPlayer = (teamSE[i].PlayerID == thisPlayer.PlayerReplicationInfo.PlayerID);
		if ( bLocalPlayer )
			gc.SetTextColor( GoldColor );
		else
			gc.SetTextColor( GreenColor );
		yoffset += ylen;
		DrawNameAndScore( gc, teamSE[i], screenWidth, yoffset );
	}

	yoffset += (ylen*2);

	if ( thisPlayer.PlayerReplicationInfo.team == TEAM_UNATCO )
		teamStr = TeamNsfString;
	else
		teamStr = TeamUnatcoString;

	// Enemies
	enemyCnt = GetTeamList( thisPlayer, False );
	SortTeamScores( enemyCnt );
	gc.SetTextColor( RedColor );
	gc.GetTextExtent( 0, w, h, EnemiesString );
	gc.DrawText( PlayerX * screenWidth, yoffset, w, h, EnemiesString );
	fakeSE.PlayerName = EnemiesString $ " (" $ teamStr $ ")";
	LocalGetTeamTotals( enemyCnt, fakeSE.score, fakeSE.deaths, fakeSE.streak );
	DrawNameAndScore( gc, fakeSE, screenWidth, yoffset );
	gc.SetTileColorRGB(255,0,0);
	gc.DrawBox( PlayerX * screenWidth, yoffset+h, barLen, 1, 0, 0, 1, Texture'Solid');
	yoffset += ( h * 0.25 );

	for ( i = 0; i < enemyCnt; i++ )
	{
		yoffset += ylen;
		DrawNameAndScore( gc, teamSE[i], screenWidth, yoffset );
	}
}

// ---------------------------------------------------------------------
// ChangeTeam()
// ---------------------------------------------------------------------

function bool ChangeTeam(Pawn PawnToChange, int NewTeam)
{
   local int iSkin;
   local int CurTeam;
   local DeusExPlayer PlayerToChange;

   if (!ApproveTeam(NewTeam))
	   NewTeam = TEAM_AUTO;

   //DEUS_EX AMSD Autoteam midmatch shouldn't change my team.
   if (NewTeam == TEAM_AUTO)
   {
      if (PlayerPawn(PawnToChange) != None)
      {
         CurTeam = PlayerPawn(PawnToChange).PlayerReplicationInfo.Team;
         NewTeam = CurTeam;
      }
      else
         return false;
   }
   
   if (!Super.ChangeTeam(PawnToChange, NewTeam))
      return false;

   PlayerToChange = DeusExPlayer(PawnToChange);
   if (PlayerToChange == None)
      return false;

   if (NewTeam == TEAM_UNATCO)
   {
      for (iSkin = 0; iSkin < ArrayCount(PlayerToChange.MultiSkins); iSkin++)
      {
         PlayerToChange.MultiSkins[iSkin] = class'mpunatco'.Default.MultiSkins[iSkin];
      }
      PlayerToChange.CarcassType = class'mpunatco'.Default.CarcassType;
      PlayerToChange.Mesh = class'mpunatco'.Default.Mesh;
   }
   else if (NewTeam == TEAM_NSF)
   {
      for (iSkin = 0; iSkin < ArrayCount(PlayerToChange.MultiSkins); iSkin++)
      {
         PlayerToChange.MultiSkins[iSkin] = class'mpnsf'.Default.MultiSkins[iSkin];
      }
      PlayerToChange.CarcassType = class'mpnsf'.Default.CarcassType;
      PlayerToChange.Mesh = class'mpnsf'.Default.Mesh;
   }
   else
   {
      return false;
   }
   
   return true;
}

defaultproperties
{
     EnemiesString="Enemies"
     AlliesString="Allies"
     VictoryConString1="Objective: First team that reaches "
     VictoryConString2=" kills wins the match."
     TimeLimitString1="Objective: Score the most kills before the clock ( "
     TimeLimitString2=" ) runs out!"
     TeamScoreString=" Team Score:"
     bAutoInstall=False
     bTeamGame=True
     DefaultPlayerClass=Class'DeusEx.Mpunatco'
}
