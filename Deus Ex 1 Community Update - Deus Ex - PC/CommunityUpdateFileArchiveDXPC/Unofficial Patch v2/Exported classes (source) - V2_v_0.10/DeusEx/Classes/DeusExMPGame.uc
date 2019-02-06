//=============================================================================
// DeusExMultiplayerGame
//=============================================================================
class DeusExMPGame expands DeusExGameInfo;

//DEUS_EX AMSD Note to mod developers:  All the globalconfig type vars here should work perfectly
//well if you change them.  Some others have been tested (GlobalUpgradesPerKill, bAutoInstall), but 
//not in a while.  Others, like bMultiPlayerBots, don't really do anything.  Several are just legacy.
//Don't assume that because a variable is here that it works (unless its globalconfig).

var() globalconfig int  SkillsTotal;
var() globalconfig int  SkillsAvail;
var() globalconfig int  SkillsPerKill; //number of skill points you get when you kill someone
var() globalconfig int  InitialAugs; //number of augs you start with
var() globalconfig int  AugsPerKill; //number of augs added when you kill someone
var() globalconfig int	ScoreToWin; // Summed kills to win
var() globalconfig string VictoryCondition; //type of victory condition
// Frags is frag limit
// Time is time limit

var() globalconfig int MPSkillStartLevel; //starting level of skills in mp game.
var() globalconfig string CurrentMap; //maptype selected (for saving in ui)
var() globalconfig float	fFriendlyFireMult;	// Friendly fire multiplier

// *********UGLY stat tracking vars
var() globalconfig bool bTrackWeapons; // whether to track weaponstats or not Not that this tracking helps much.


var() int	FragLimit; 
var() int	TimeLimit; // time limit in minutes
var() int  GlobalUpgradesPerKill; //number of points all augs go up when you kill someone
var() bool	bMultiPlayerBots; //DEUS_EX AMSD No support done for this one.
var() bool bChangeLevels;
var() bool bAutoInstall; //whether augs get autoinstalled when you pick one up
var() bool bDarkHiding; //whether to do special translucency effects for hiding
var() bool bSpawnEffects; // whether or not to spawn things like shell casings and blood.
var() bool bAugsAllowed; //whether or not players have augmentations.
var() float StartHiding; //if bDarkHiding is true, vis value at which player becomes translucent
var() float EndHiding; //if bDarkHiding is true, vis value at which player becomes nontranslucent
var() float CloakEffect; //multiplicative scaleglow if cloak(or adaptive) is on

var bool bCustomizable; //Whether or not the gametype is customizable through the menu interface

var bool bStartWithPistol;

var int PistolShotsFired;
var int PistolShotsHit;
var float PistolAverageHitDamage;

var int StealthPistolShotsFired;
var int StealthPistolShotsHit;
var float StealthPistolAverageHitDamage;

var int AssaultRifleShotsFired;
var int AssaultRifleShotsHit;
var float AssaultRifleAverageHitDamage;

var int AssaultShotgunShotsFired;
var int AssaultShotgunShotsHit;
var float AssaultShotgunAverageHitDamage;

var int SawedOffShotgunShotsFired;
var int SawedOffShotgunShotsHit;
var float SawedOffShotgunAverageHitDamage;

var int SniperRifleShotsFired;
var int SniperRifleShotsHit;
var float SniperRifleAverageHitDamage;
// *********end stat tracking vars

const NewMapDelay				= 16.0;
var bool							bCycleMap;
var bool							bNewMap, bClientNewMap;
var float						NewMapTime;

var bool							bGameEnded;
var bool							bAlreadyChanged;

var bool							bSecondaryNotice;
var bool							bSecondaryNsf;
var bool							bSecondaryUnatco;
var bool							bPrimaryNotice;
var bool							bPrimaryNsf;
var bool							bPrimaryUnatco;

var localized String			TooManyPlayers;

const TEAM_UNATCO = 0;
const TEAM_NSF		= 1;
const TEAM_DRAW	= 2;
const TEAM_AUTO   = 128;

// For the scoreboard
var bool							bFreezeScores;			// Don't modify scoreArray if we are displaying end of game stats

struct ScoreElement
{
	var String	PlayerName;
	var float	score;
	var float	deaths;
	var float	streak;
	var int		team;
	var int		PlayerID;
};

var ScoreElement				scoreArray[32];	// Array to store the scores
var int							scorePlayers;		// Number of players in the current scoreArray

var color						WhiteColor, SilverColor, RedColor, GreenColor, GoldColor;
var localized String			StreakString, KillsString, DeathsString, PlayerString, NewMapSecondsString, WonMatchString;
var localized String			EscapeString;
var localized String			MatchEnd1String, MatchEnd2String;
var localized String			TeamNsfString, TeamUnatcoString, TeamDrawString;

const PlayerX	= 0.17;		// Multiplier of screenWidth
const KillsX	= 0.55;		
const DeathsX	= 0.65;		
const StreakX	= 0.75;		
const PlayerY	= 0.25;
const WinY		= 0.15;		// Mutliplier of screenHeight
const FireContY = 0.80;

const NotifyMinutes = 1.0;

replication
{
	// Server to client
	reliable if ( Role == ROLE_Authority )
		ScoreToWin, bNewMap, VictoryCondition;
}

// Return beacon text for server
event string GetBeaconText()
{
	local string Result;
	Result = Super.GetBeaconText();
	Result = Result $ " (" $ NumPlayers $ "/" $ MaxPlayers $ ")";
	return Result;
}

event PreLogin
(
	string Options,
	string Address,
	out string Error,
	out string FailCode
)
{
	Super.PreLogin(Options, Address, Error, FailCode);

	bClientNewMap = False;

	if ((MaxPlayers > 0) && (NumPlayers >= MaxPlayers) )
		Error = TooManyPlayers;
}

event PlayerPawn Login(string Portal, string Options, out string Error, class<playerpawn> SpawnClass)
{
	local PlayerPawn newPlayer;
	local DeusExPlayer dxPlayer;

	if ((MaxPlayers > 0) && (NumPlayers >= MaxPlayers) )
	{
		Error = TooManyPlayers;
		return None;
	}

	newPlayer = Super.Login(Portal, Options, Error, SpawnClass);

	newPlayer.bAutoActivate = true;

	return newPlayer;
}

event PostLogin(playerpawn NewPlayer)
{
   local DeusExPlayer DXPlayer;

   DXPlayer = DeusExPlayer(NewPlayer);

   log("class of new player is "$DXPlayer.Class$", class of game is "$Class$".");
   // DEUS_EX AMSD Setup abilities now called when server syncs up with options.
	//   SetupAbilities(DXPlayer);

	// MB I tried putting this in postbeginplay and postpostbeginplay, but PlayerIsListenClient failed to do the right thing at that point
   if ( DXPlayer.PlayerIsListenClient() )
   {
		DXPlayer.CreatePlayerTracker();
		if (DXPlayer.ThemeManager == NONE)
		{
		  DXPlayer.CreateColorThemeManager();
		  DXPlayer.ThemeManager.SetOwner( DXPlayer );
		  DXPlayer.ThemeManager.SetCurrentHUDColorTheme(DXPlayer.ThemeManager.GetFirstTheme(1));		
		  DXPlayer.ThemeManager.SetCurrentMenuColorTheme(DXPlayer.ThemeManager.GetFirstTheme(0)); 
		  DXPlayer.ThemeManager.SetMenuThemeByName(DXPlayer.MenuThemeName);
		  DXPlayer.ThemeManager.SetHUDThemeByName(DXPlayer.HUDThemeName);
		  DeusExRootWindow(DXPlayer.rootWindow).ChangeStyle();
		}
		DXPlayer.ReceiveFirstOptionSync(DXPlayer.AugPrefs[0], DXPlayer.AugPrefs[1], DXPlayer.AugPrefs[2], DXPlayer.AugPrefs[3], DXPlayer.AugPrefs[4]);
      DXPlayer.ReceiveSecondOptionSync(DXPlayer.AugPrefs[5], DXPlayer.AugPrefs[6], DXPlayer.AugPrefs[7], DXPlayer.AugPrefs[8]);
		DXPlayer.ShieldStatus = SS_Off;
   }
   Super.PostLogin(NewPlayer);
}

// ----------------------------------------------------------------------
// ApproveClass()
// Is this class allowed for this gametype?  Override if you want to be 
// other than JCDentonMale.  If it returns false, will force JCDenton spawn.
// ----------------------------------------------------------------------

function bool ApproveClass( class<playerpawn> SpawnClass)
{
	return true;
}

//
// Pawn exits.
//
function Logout( pawn Exiting )
{
	local DeusExPlayer ExitingPlayer;
	local Computers CompActor;

	ExitingPlayer = DeusExPlayer(Exiting);
	if (ExitingPlayer != None)
	{
		foreach AllActors(class'Computers',CompActor)
		{
			if ((CompActor.CurFrobber != None) && (CompActor.CurFrobber == ExitingPlayer))
			{
				log("====>Player logged out while logged in, forcing computer closed");
				ExitingPlayer.CloseComputerScreen(CompActor);
			}
		}
	}

	Super.Logout(Exiting);
}

function bool RestartPlayer( pawn aPlayer )	
{
    local DeusExPlayer PlayerToRestart;
    local bool SuperResult;

    log("DeusEx Multiplayer Game restart player");
    PlayerToRestart = DeusExPlayer(aPlayer);

    if (PlayerToRestart == None)
    {
        log("Trying to restart non Deus Ex player!");
        return false;
    }

    //Restore HUD    
    PlayerToRestart.ShowHud(True);
    //Clear Augmentations
    PlayerToRestart.AugmentationSystem.ResetAugmentations();
    //Clear Skills
    PlayerToRestart.SkillSystem.ResetSkills();
    
    //DEUS_EX AMSD For some reason, reset player to defaults doesn't do all of the spiffy things that it should...
    //so some of it will be doneon the side
    PlayerToRestart.ResetPlayerToDefaults();
    
    SuperResult = Super.RestartPlayer(aPlayer);       
    
    //Restore Augs
    PlayerToRestart.ClearAugmentationDisplay();
    PlayerToRestart.AugmentationSystem.CreateAugmentations(PlayerToRestart);
    PlayerToRestart.AugmentationSystem.AddDefaultAugmentations();
    //Restore Bio-Energy
    PlayerToRestart.Energy = PlayerToRestart.EnergyMax;
    //Restore Skills
    PlayerToRestart.SkillSystem.CreateSkills(PlayerToRestart);
    //Replace with skill points based on game info.
    SetupAbilities(PlayerToRestart);

	 PlayerToRestart.myProjKiller = None;

    return SuperResult;
}

function SetupAbilities(DeusExPlayer aPlayer)
{
   if (aPlayer == None)
      return;

   aPlayer.SkillPointsAvail = SkillsAvail;
   aPlayer.SkillPointsAvail = SkillsAvail;

   if (bAugsAllowed)   
      GrantAugs(aPlayer, InitialAugs);
}

//DEUS_EX AMSD New algorithm.  Gets a weighting on each player start, finds the one with the highest weight.
//Different game types can have different weighting functions.
function NavigationPoint FindPlayerStart( Pawn Player, optional byte InTeam, optional string incomingName )
{
	local PlayerStart Dest;
   local PlayerStart BestDest;
   local float BestWeight;
   local float CurWeight;
   
   BestWeight = -100001;
   BestDest = None;

   foreach AllActors( class 'PlayerStart', Dest )
   {
      if( Dest.bSinglePlayerStart && Dest.bEnabled )
      {         
         CurWeight = EvaluatePlayerStart(Player,Dest,InTeam);
         if (CurWeight > BestWeight)
         {
            BestDest = Dest;
            BestWeight = CurWeight;
         }
      }
   }

   if (BestDest != None)
      return BestDest;
      
      // if none, reenable them all, and just pick one.
      log("All single player starts were disabled, reenabling all");
      foreach AllActors( class 'PlayerStart', Dest )
      {
         if( Dest.bSinglePlayerStart )
            Dest.bEnabled = true;
      }
      
      foreach AllActors( class 'PlayerStart', Dest)
      {
         if( Dest.bSinglePlayerStart && Dest.bEnabled )
         {
            Dest.bEnabled = false;
            return Dest;
         }
      }
      log( "ERROR! No single player start found" );
      return None;
}

// Just makes sure that no other player is in that starting point, and assigns
// an additional random factor.
function float EvaluatePlayerStart(Pawn Player, PlayerStart PointToEvaluate, optional byte InTeam)
{
   local bool bTooClose;
   local DeusExPlayer OtherPlayer;
   local Pawn CurPawn;
   local float Dist;

   bTooClose = False;

   for (CurPawn = Level.PawnList; CurPawn != None; CurPawn = CurPawn.NextPawn)
   {
      OtherPlayer = DeusExPlayer(CurPawn);
      if ((OtherPlayer != None) && (OtherPlayer != Player))
      {
         Dist = VSize(OtherPlayer.Location - PointToEvaluate.Location);
         if (VSize(OtherPlayer.Location - PointToEvaluate.Location) < 100.0)
         {
            bTooClose = TRUE;
         }
      }
   }

   if (bTooClose)
      return -100000;
   else
      return FRand();
}

//
// HandleDeathNotification
//

function HandleDeathNotification( Pawn killer, Pawn killee )
{
	local bool killedSelf, valid;

	killedSelf = (killer == killee);

	if (( killee != None ) && killee.IsA('DeusExPlayer'))
	{
		valid = DeusExPlayer(killee).killProfile.bValid;

		if ( killedSelf )
			valid = False;

		DeusExPlayer(killee).MultiplayerDeathMsg( killer, killedSelf, valid, DeusExPlayer(killee).killProfile.name, DeusExPlayer(killee).killProfile.methodStr );
	}
}

//
// Killed DEUS_EX AMSD Killed function for broadcasting death messages
//

function Killed( pawn Killer, pawn Other, name damageType )
{
	local bool NotifyDeath;
	local DeusExPlayer otherPlayer;
	local Pawn CurPawn;

   if ( bFreezeScores )
      return;

	NotifyDeath = False;

	// Record the death no matter what, and reset the streak counter
	if ( Other.bIsPlayer )
	{
		otherPlayer = DeusExPlayer(Other);
		Other.PlayerReplicationInfo.Deaths += 1;
		Other.PlayerReplicationInfo.Streak = 0;
		// Penalize the player that commits suicide by losing a kill, but don't take them below zero
		if ((Killer == Other) || (Killer == None))
		{
			if ( Other.PlayerReplicationInfo.Score > 0 )
			{
				if (( DeusExProjectile(otherPlayer.myProjKiller) != None ) && DeusExProjectile(otherPlayer.myProjKiller).bAggressiveExploded )
				{
					// Don't dock them if it nano exploded in their face
				}
				else
					Other.PlayerReplicationInfo.Score -= 1;
			}
		}
		NotifyDeath = True;
	}

   //both players...
   if ((Killer.bIsPlayer) && (Other.bIsPlayer))
   {
 	    //Add to console log as well (with pri id) so that kick/kickban can work better
 	    log(Killer.PlayerReplicationInfo.PlayerName$"("$Killer.PlayerReplicationInfo.PlayerID$") killed "$Other.PlayerReplicationInfo.PlayerName $ otherPlayer.killProfile.methodStr);
		for (CurPawn = Level.PawnList; CurPawn != None; CurPawn = CurPawn.NextPawn)
		{
			if ((CurPawn.IsA('DeusExPlayer')) && (DeusExPlayer(CurPawn).bAdmin))
				DeusExPlayer(CurPawn).LocalLog(Killer.PlayerReplicationInfo.PlayerName$"("$Killer.PlayerReplicationInfo.PlayerID$") killed "$Other.PlayerReplicationInfo.PlayerName $ otherPlayer.killProfile.methodStr);
		}

		if ( otherPlayer.killProfile.methodStr ~= "None" )
			BroadcastMessage(Killer.PlayerReplicationInfo.PlayerName$" killed "$Other.PlayerReplicationInfo.PlayerName$".",false,'DeathMessage');
		else
			BroadcastMessage(Killer.PlayerReplicationInfo.PlayerName$" killed "$Other.PlayerReplicationInfo.PlayerName $ otherPlayer.killProfile.methodStr, false, 'DeathMessage');

		if (Killer != Other)
		{
			// Penalize for killing your teammates
			if ((TeamDMGame(Self) != None) && (TeamDMGame(Self).ArePlayersAllied(DeusExPlayer(Other),DeusExPlayer(Killer))))
			{
				if ( Killer.PlayerReplicationInfo.Score > 0 )
					Killer.PlayerReplicationInfo.Score -= 1;
				DeusExPlayer(Killer).MultiplayerNotifyMsg( DeusExPlayer(Killer).MPMSG_KilledTeammate, 0, "" );
			}
			else
			{
				// Grant the kill to the killer, and increase his streak
				Killer.PlayerReplicationInfo.Score += 1;
				Killer.PlayerReplicationInfo.Streak += 1;

				Reward(Killer);

				// Check for victory conditions and end the match if need be
				if ( DeathMatchGame(Self) != None )
				{
					if ( DeathMatchGame(Self).CheckVictoryConditions(Killer, Other, otherPlayer.killProfile.methodStr) )
               {
                  bFreezeScores = True;
                  NotifyDeath = False;
               }
				}
				if ( TeamDMGame(Self) != None )
				{
					if ( TeamDMGame(Self).CheckVictoryConditions(Killer, Other, otherPlayer.killProfile.methodStr) )
               {
                  bFreezeScores = True;
                  NotifyDeath = False;
               }
				}
			}
		}
		if ( NotifyDeath )
			HandleDeathNotification( Killer, Other );
   }
   else
   {
		if (NotifyDeath)
			HandleDeathNotification( Killer, Other );

      Super.Killed(Killer,Other,damageType);
   }
}

//-------------------------------------------------------------------------------------------------
// Tick()
//-------------------------------------------------------------------------------------------------

function Tick( float deltaTime )
{
	local bool	bCheck;
	local float	timeLimit, notifySec;

	bCheck = False;

	if ( Role == ROLE_Authority )
	{
		timeLimit = float(ScoreToWin)*60.0;
		notifySec = timeLimit - NotifyMinutes * 60.0;

		bCheck = ((VictoryCondition ~= "Time") && (((Level.Timeseconds>timeLimit) && !bCycleMap) || ((Level.Timeseconds>notifySec) && ( timeLimit > NotifyMinutes*60.0*2.0 ) && !bPrimaryNotice)));

		if ( bCheck )
		{
			// Check for victory conditions and end the match if need be
			if ( DeathMatchGame(Self) != None )
				DeathMatchGame(Self).CheckVictoryConditions( None, None, "" );
			if ( TeamDMGame(Self) != None )
				TeamDMGame(Self).CheckVictoryConditions( None, None, "" );
		}
	}
	Super.Tick( deltaTime );
}

//-------------------------------------------------------------------------------------------------
// Reward()
//-------------------------------------------------------------------------------------------------
function Reward(pawn Rewardee)
{
   local DeusExPlayer PlayerToReward;

   PlayerToReward = DeusExPlayer(Rewardee);
   if (PlayerToReward != None)
   {
		// MB Removed some of this so it's not quite so cluttered
		// if (SkillsPerKill > 0)
		//    PlayerToReward.ClientMessage("Rewarding you with "$SkillsPerKill$" skill points.");
      PlayerToReward.SkillPointsAdd(SkillsPerKill);
		//      if (GlobalUpgradesPerKill > 0)
		//         PlayerToReward.ClientMessage("Raising all augmentations by "$GlobalUpgradesPerKill$".");
		
		// Took this out because we are now always level 4 augs : MBCODE
      // PlayerToReward.AugmentationSystem.IncreaseAllAugs(GlobalUpgradesPerKill);

      if ((AugsPerKill > 0) && (bAugsAllowed))
      {
		//         PlayerToReward.ClientMessage("Granting additional augmentations");
         GrantAugs(PlayerToReward, AugsPerKill);
      }
   }
}

//-------------------------------------------------------------------------------------------------
// GrantAugs()
//-------------------------------------------------------------------------------------------------
function GrantAugs(DeusExPlayer Player, int NumAugs)
{
   Player.GrantAugs(NumAugs);
}

//-------------------------------------------------------------------------------------------------
// RefreshScoreArray()
//-------------------------------------------------------------------------------------------------
simulated function RefreshScoreArray( DeusExPlayer player )
{
	local PlayerReplicationInfo lpri;
	local PlayerPawn pp;
	local int i;

	pp = player.GetPlayerPawn();
	if ( pp == None )
		return;

	scorePlayers = 0;

	for ( i = 0; i < 32; i++ )
	{
		if ( pp.GameReplicationInfo.PRIArray[i] != None )
		{
			lpri = pp.GameReplicationInfo.PRIArray[i];
			if ( !lpri.bIsSpectator || lpri.bWaitingPlayer )
			{
				scoreArray[scorePlayers].PlayerName = lpri.PlayerName;
				scoreArray[scorePlayers].score = lpri.Score;
				scoreArray[scorePlayers].deaths = lpri.Deaths;
				scoreArray[scorePlayers].streak = lpri.Streak;
				scoreArray[scorePlayers].team = lpri.Team;
				scoreArray[scorePlayers].PlayerID = lpri.PlayerID;
				scorePlayers += 1;
				if ( scorePlayers == ArrayCount(scoreArray) )
					break;
			}
		}
	}
}

//-------------------------------------------------------------------------------------------------
// SortScores()
//-------------------------------------------------------------------------------------------------
simulated function SortScores()
{
	local PlayerReplicationInfo tmpri;
	local int i, j, max;
	local ScoreElement tmpSE;
	
	for ( i = 0; i < scorePlayers-1; i++ )
	{
		max = i;
		for ( j = i+1; j < scorePlayers; j++ )
		{
			if ( scoreArray[j].score > scoreArray[max].score )
				max = j;
			else if (( scoreArray[j].score == scoreArray[max].score) && (scoreArray[j].deaths < scoreArray[max].deaths))
				max = j;
		}
		tmpSE = scoreArray[max];
		scoreArray[max] = scoreArray[i];
		scoreArray[i] = tmpSE;
	}
}

//-------------------------------------------------------------------------------------------------
// DrawNameAndScore()
//-------------------------------------------------------------------------------------------------
simulated function DrawNameAndScore( GC gc, ScoreElement se, float screenWidth, float yoffset )
{
	local float x, w, h, w2, xoffset, killcx, deathcx, streakcx;
	local String str;
	
	// Draw Name
	str = se.PlayerName;
	gc.GetTextExtent( 0, w, h, str );
	x = screenWidth * PlayerX;
	gc.DrawText( x, yoffset, w, h, str );

	// Draw Kills
	str = "00";
	gc.GetTextExtent( 0, w, h, KillsString );
	killcx = screenWidth * KillsX + w * 0.5;
	gc.GetTextExtent( 0, w, h, str );
	str = int(se.Score) $ "";
	gc.GetTextExtent( 0, w2, h, str );
	x = killcx + (w * 0.5) - w2;
	gc.DrawText( x, yoffset, w2, h, str );

	// Draw Deaths
	gc.GetTextExtent( 0, w2, h, DeathsString );
	deathcx = screenWidth * DeathsX + w2 * 0.5;
	str = int(se.Deaths) $ "";
	gc.GetTextExtent( 0, w2, h, str );
	x = deathcx + (w * 0.5) - w2;
	gc.DrawText( x, yoffset, w2, h, str );

	// Draw Streak
	gc.GetTextExtent( 0, w2, h, StreakString );
	streakcx = screenWidth * StreakX + w2 * 0.5;
	str = int(se.Streak) $ "";
	gc.GetTextExtent( 0, w2, h, str );
	x = streakcx + (w * 0.5) - w2;
	gc.DrawText( x, yoffset, w2, h, str );
}

//-------------------------------------------------------------------------------------------------
// ShowScores()
//-------------------------------------------------------------------------------------------------
simulated function DrawHeaders( GC gc, float screenWidth, float yoffset )
{
	local float x, w, h, barLen;

	// Player header
	gc.GetTextExtent( 0, w, h, PlayerString );
	x = screenWidth * PlayerX;
	gc.DrawText( x, yoffset, w, h, PlayerString );

	// Kills header
	gc.GetTextExtent( 0, w, h, KillsString );
	x = screenWidth * KillsX;
	gc.DrawText( x, yoffset, w, h, KillsString );

	// Deaths header
	gc.GetTextExtent( 0, w, h, DeathsString );
	x = screenWidth * DeathsX;
	gc.DrawText( x, yoffset, w, h, DeathsString );

	// Deaths header
	gc.GetTextExtent( 0, w, h, StreakString );
	x = screenWidth * StreakX;
	gc.DrawText( x, yoffset, w, h, StreakString );

	gc.SetTileColorRGB(255,255,255);
	gc.DrawBox( PlayerX * screenWidth, yoffset+h, (x + w)-(PlayerX*screenWidth), 1, 0, 0, 1, Texture'Solid');
}

// ---------------------------------------------------------------------
// NotifyGameStatus
// ---------------------------------------------------------------------

function NotifyGameStatus( int param, String winningStr, bool bTimeCondition, bool bPrimary )
{
	local Pawn curPawn;

	if (( TeamDMGame(Self) != None ) && (VictoryCondition ~= "Frags"))
	{
		if ( bPrimary )
		{
			if ( winningStr ~= TeamNsfString )
			{
				if ( bPrimaryNsf )
					return;
				else
					bPrimaryNsf = True;
			}
			if ( winningStr ~= TeamUnatcoString )
			{
				if ( bPrimaryUnatco )
					return;
				else
					bPrimaryUnatco = True;
			}
		}
		else
		{
			if ( winningStr ~= TeamNsfString )
			{
				if ( bSecondaryNsf )
					return;
				else
					bSecondaryNsf = True;
			}
			if ( winningStr ~= TeamUnatcoString )
			{
				if ( bSecondaryUnatco )
					return;
				else
					bSecondaryUnatco = True;
			}
		}
	}
	else
	{
		if ( bPrimary )
		{
			if ( bPrimaryNotice )
				return;
			else
				bPrimaryNotice = True;
		}
		else
		{
			if ( bSecondaryNotice )
				return;
			else
				bSecondaryNotice = True;
		}
	}

	for ( curPawn = Level.PawnList; curPawn != None; curPawn = curPawn.nextPawn )
	{
		if ( curPawn.IsA('DeusExPlayer') )
		{
			if ( bTimeCondition )
				DeusExPlayer(curPawn).MultiplayerNotifyMsg( DeusExPlayer(curPawn).MPMSG_TimeNearEnd, param, winningStr );
			else
				DeusExPlayer(curPawn).MultiplayerNotifyMsg( DeusExPlayer(curPawn).MPMSG_CloseKills, param, winningStr );
		}
	}
}

// ---------------------------------------------------------------------
// ContinueMsg()
// ---------------------------------------------------------------------
simulated function ContinueMsg( GC gc, float screenWidth, float screenHeight )
{
	local String str;
	local float x, y, w, h;
	local int t;

	if ( bNewMap && !bClientNewMap)
	{
		NewMapTime = Level.Timeseconds + NewMapDelay - 0.5;
		bClientNewMap = True;
	}
	t = int(NewMapTime - Level.Timeseconds);
	if ( t < 0 )
		t = 0;

	str = t $ NewMapSecondsString;

	gc.SetTextColor( WhiteColor );
	gc.SetFont(Font'FontMenuTitle');
	gc.GetTextExtent( 0, w, h, str );
	x = (screenWidth * 0.5) - (w * 0.5);
	y = screenHeight * FireContY;
	gc.DrawText( x, y, w, h, str );

	y += (h*2.0);
	str = EscapeString;
	gc.GetTextExtent( 0, w, h, str );
	x = (screenWidth * 0.5) - (w * 0.5);
	gc.DrawText( x, y, w, h, str );
}

// ---------------------------------------------------------------------
// GetRules()
// ---------------------------------------------------------------------
function string GetRules()
{
   local string ResultSet;

   ResultSet = "";

   ResultSet = ResultSet $ "\\SkillsAvail\\" $ SkillsAvail;
   ResultSet = ResultSet $ "\\SkillsPerKill\\" $ SkillsPerKill;

   if (bAugsAllowed)
   {
      ResultSet = ResultSet $ "\\InitialAugs\\" $ InitialAugs;
      ResultSet = ResultSet $ "\\AugsPerKill\\" $ AugsPerKill;
   }
   else   
      ResultSet = ResultSet $ "\\AugsAllowed\\" $ bAugsAllowed;

   if (VictoryCondition ~= "Frags")   
      ResultSet = ResultSet $ "\\KillsToWin\\" $ ScoreToWin;
   else if (VictoryCondition ~= "Time")
      ResultSet = ResultSet $ "\\TimeToWin\\" $ ScoreToWin;

   ResultSet = ResultSet $ Super.GetRules();

   return ResultSet;
}

// ---------------------------------------------------------------------
// Timer()
// ---------------------------------------------------------------------

function Timer()
{
   local string URLstr;
	local DXMapList mapList;

	if ( bCycleMap )
	{
      mapList = Spawn(class'DXMapList');
      URLstr = mapList.GetNextMap();
      mapList.Destroy();
      bCycleMap = False;
      Level.ServerTravel( URLstr, False );
      bFreezeScores = False;
	}
}


//
// PreGameOver
//
function PreGameOver()
{
	local Computers comp;

	// Close out any computer screens
	foreach AllActors( class'Computers', comp )
	{
		if ((comp != None ) && ( comp.curFrobber != None ))
		{
			// This is for the client
			comp.curFrobber.CloseThisComputer( comp );
			// This is for the server
			comp.curFrobber.CloseComputerScreen( comp );
		}
	}
}

// ---------------------------------------------------------------------
// GameOver()
// Any things to be done at end of game before notices have been sent out
// ---------------------------------------------------------------------
function GameOver()
{
   if (bTrackWeapons)
   {
      log("======>Pistol Stats.  Shots: "$PistolShotsFired$", Hits: "$PistolShotsHit$", Damage: "$PistolAverageHitDamage);
      log("======>StealthPistol Stats.  Shots: "$StealthPistolShotsFired$", Hits: "$StealthPistolShotsHit$", Damage: "$StealthPistolAverageHitDamage);
      log("======>AssaultRifle Stats.  Shots: "$AssaultRifleShotsFired$", Hits: "$AssaultRifleShotsHit$", Damage: "$AssaultRifleAverageHitDamage);
      log("======>AssaultShotgun Stats.  Shots: "$AssaultShotgunShotsFired$", Hits: "$AssaultShotgunShotsHit$", Damage: "$AssaultShotgunAverageHitDamage);
      log("======>SawedOffShotgun Stats.  Shots: "$SawedOffShotgunShotsFired$", Hits: "$SawedOffShotgunShotsHit$", Damage: "$SawedOffShotgunAverageHitDamage);
      log("======>SniperRifle Stats.  Shots: "$SniperRifleShotsFired$", Hits: "$SniperRifleShotsHit$", Damage: "$SniperRifleAverageHitDamage);
   }
	bNewMap = True;
	bCycleMap = True;
	SetTimer( NewMapDelay, false );
}

// ---------------------------------------------------------------------
// TrackWeapon()
// For tracking stats of used weapons
// ugly and slow
// ---------------------------------------------------------------------
simulated function TrackWeapon(DeusExWeapon WeaponUsed, float RawDamage)
{
   if (!bTrackWeapons)
      return;

   if (WeaponUsed.IsA('WeaponPistol'))
      TrackPistol(WeaponPistol(WeaponUsed),RawDamage);
   
   else if (WeaponUsed.IsA('WeaponStealthPistol'))
      TrackStealthPistol(WeaponStealthPistol(WeaponUsed),RawDamage);
   
   else if (WeaponUsed.IsA('WeaponAssaultGun'))
      TrackAssaultRifle(WeaponAssaultGun(WeaponUsed),RawDamage);
   
   else if (WeaponUsed.IsA('WeaponAssaultShotgun'))
      TrackAssaultShotgun(WeaponAssaultShotgun(WeaponUsed),RawDamage);
   
   else if (WeaponUsed.IsA('WeaponRifle'))
      TrackSniperRifle(WeaponRifle(WeaponUsed),RawDamage);

   else if (WeaponUsed.IsA('WeaponSawedOffShotgun'))
      TrackSawedOffShotgun(WeaponSawedOffShotgun(WeaponUsed),RawDamage);
}

simulated function TrackPistol(WeaponPistol PistolUsed, float RawDamage)
{
   PistolShotsFired++;
   if (RawDamage > 0)
   {
      PistolShotsHit++;
      PistolAverageHitDamage = (PistolAverageHitDamage*(PistolShotsHit - 1) + RawDamage)/PistolShotsHit;
   }
}

simulated function TrackStealthPistol(WeaponStealthPistol StealthPistolUsed, float RawDamage)
{
   StealthPistolShotsFired++;
   if (RawDamage > 0)
   {
      StealthPistolShotsHit++;
      StealthPistolAverageHitDamage = (StealthPistolAverageHitDamage*(StealthPistolShotsHit - 1) + RawDamage)/StealthPistolShotsHit;
   }
}

simulated function TrackAssaultRifle(WeaponAssaultGun AssaultRifleUsed, float RawDamage)
{
   AssaultRifleShotsFired++;
   if (RawDamage > 0)
   {
      AssaultRifleShotsHit++;
      AssaultRifleAverageHitDamage = (AssaultRifleAverageHitDamage*(AssaultRifleShotsHit - 1) + RawDamage)/AssaultRifleShotsHit;
   }
}

simulated function TrackAssaultShotgun(WeaponAssaultShotgun AssaultShotgunUsed, float RawDamage)
{
   AssaultShotgunShotsFired++;
   if (RawDamage > 0)
   {
      AssaultShotgunShotsHit++;
      AssaultShotgunAverageHitDamage = (AssaultShotgunAverageHitDamage*(AssaultShotgunShotsHit - 1) + RawDamage)/AssaultShotgunShotsHit;
   }
}

simulated function TrackSawedOffShotgun(WeaponSawedOffShotgun SawedOffShotgunUsed, float RawDamage)
{
   SawedOffShotgunShotsFired++;
   if (RawDamage > 0)
   {
      SawedOffShotgunShotsHit++;
      SawedOffShotgunAverageHitDamage = (SawedOffShotgunAverageHitDamage*(SawedOffShotgunShotsHit - 1) + RawDamage)/SawedOffShotgunShotsHit;
   }
}

simulated function TrackSniperRifle(WeaponRifle SniperRifleUsed, float RawDamage)
{
   SniperRifleShotsFired++;
   if (RawDamage > 0)
   {
      SniperRifleShotsHit++;
      SniperRifleAverageHitDamage = (SniperRifleAverageHitDamage*(SniperRifleShotsHit - 1) + RawDamage)/SniperRifleShotsHit;
   }
}

// ---------------------------------------------------------------------
// ResetNonCustomizableOptions()
// Stub for sub gametypes to keep people from changing things in the configs.
// ---------------------------------------------------------------------

function ResetNonCustomizableOptions()
{
}

// ----------------------------------------------------------------------
// CheckPlayerWindow()
// ----------------------------------------------------------------------
function CheckPlayerWindow(PlayerPawn CheckPlayer)
{
	if (DeusExPlayer(CheckPlayer) != None)
		DeusExPlayer(CheckPlayer).VerifyRootWindow(Class'DeusEx.DeusExRootWindow');
}

// ----------------------------------------------------------------------
// CheckPlayerConsole()
// ----------------------------------------------------------------------
function CheckPlayerConsole(PlayerPawn CheckPlayer)
{
	if (DeusExPlayer(CheckPlayer) != None)
		DeusExPlayer(CheckPlayer).VerifyConsole(Class'Engine.Console');
}

// ----------------------------------------------------------------------
// FailRootWindowCheck()
// ----------------------------------------------------------------------
function FailRootWindowCheck(PlayerPawn FailPlayer)
{
	if (DeusExPlayer(FailPlayer) != None)
		DeusExPlayer(FailPlayer).ForceDisconnect("Invalid RootWindow class, disconnecting");
}

// ----------------------------------------------------------------------
// FailConsoleCheck()
// ----------------------------------------------------------------------
function FailConsoleCheck(PlayerPawn FailPlayer)
{
	if (DeusExPlayer(FailPlayer) != None)
		DeusExPlayer(FailPlayer).ForceDisconnect("Invalid Console class, disconnecting");
}

// ---------------------------------------------------------------------
// ChangeTeam()
// ---------------------------------------------------------------------
function bool ChangeTeam(Pawn PawnToChange, int NewTeam)
{
   return Super.ChangeTeam(PawnToChange,NewTeam);
}

function bool CanSpectate( pawn Viewer, actor ViewTarget )
{
	return false;
}

defaultproperties
{
     SkillsTotal=2000
     SkillsAvail=2000
     SkillsPerKill=2000
     InitialAugs=2
     AugsPerKill=2
     ScoreToWin=20
     VictoryCondition="Frags"
     MPSkillStartLevel=2
     CurrentMap="DXMP_Cmd"
     fFriendlyFireMult=0.500000
     bChangeLevels=True
     bAutoInstall=True
     bSpawnEffects=True
     bAugsAllowed=True
     EndHiding=0.010000
     bCustomizable=True
     TooManyPlayers="Too many players"
     WhiteColor=(R=255,G=255,B=255)
     SilverColor=(R=138,G=164,B=166)
     RedColor=(R=255)
     GreenColor=(G=255)
     GoldColor=(R=255,G=255)
     StreakString="Current Streak"
     KillsString="Kills"
     DeathsString="Deaths"
     PlayerString="Player"
     NewMapSecondsString=" seconds to new map."
     WonMatchString=" has won the match!"
     EscapeString="Press <Escape> to disconnect."
     MatchEnd1String="The match ended with "
     MatchEnd2String=" taking out "
     TeamNsfString="Team NSF"
     TeamUnatcoString="Team Unatco"
     TeamDrawString="The match is a draw!"
     DefaultPlayerClass=Class'DeusEx.JCDentonMale'
     bAlwaysRelevant=True
}
