//=============================================================================
// DeusExServerPing: Query a DeusEx server for its details
//=============================================================================
class DeusExServerPing extends UdpLink;

var DeusExServerList	Server;

var IpAddr				ServerIPAddr;
var float				RequestSentTime;
var float				LastDelta;
var name				QueryState;
var bool				bInitial;
var bool				bJustThisServer;
var bool				bNoSort;
var int					PingAttempts;
var int					AttemptNumber;
var int					BindAttempts;

var localized string	AdminEmailText;
var localized string	AdminNameText;
var localized string	ChangeLevelsText;
var localized string	MultiplayerBotsText;
var localized string	FragLimitText;
var localized string	TimeLimitText;
var localized string	GameModeText;
var localized string	GameTypeText;
var localized string	GameVersionText;
var localized string	WorldLogText;
var localized string	MutatorsText;
var localized string	TrueString;
var localized string	FalseString;
var localized string	ServerAddressText;
var localized string	GoalTeamScoreText;
var localized string	MinPlayersText;
var localized string	PlayersText;
var localized string	MaxTeamsText;
var localized string	BalanceTeamsText;
var localized string	PlayersBalanceTeamsText;
var localized string	FriendlyFireText;
var localized string	MinNetVersionText;
var localized string	BotSkillText;
var localized string	TournamentText;
var localized string	ServerModeText;
var localized string	DedicatedText;
var localized string	NonDedicatedText;
var localized string	WorldLogWorkingText;
var localized string	WorldLogWorkingTrue;
var localized string	WorldLogWorkingFalse;
var localized string StartingSkillsText;
var localized string SkillsPerKillText;
var localized string StartingAugsText;
var localized string AugsPerKillText;
var localized string AugsAllowedText;
var localized string TargetKillsText;
var localized string TargetTimeText;
var localized string PasswordText;

// config
var config int			MaxBindAttempts;
var config int			BindRetryTime;
var config int			PingTimeout;
var config bool			bUseMapName;

function ValidateServer()
{
	if(Server.ServerPing != Self)
	{
		Log("ORPHANED: "$Self);
		Destroy();
	}
}

function StartQuery(name S, int InPingAttempts)
{
	QueryState = S;
	ValidateServer();
	ServerIPAddr.Port = Server.QueryPort;
	GotoState('Resolving');
	PingAttempts=InPingAttempts;
	AttemptNumber=1;
}

function Resolved( IpAddr Addr )
{
	ServerIPAddr.Addr = Addr.Addr;

	GotoState('Binding');
}

function bool GetNextValue(string In, out string Out, out string Result)
{
	local int i;
	local bool bFoundStart;

	Result = "";
	bFoundStart = False;

	for(i=0;i<Len(In);i++) 
	{
		if(bFoundStart)
		{
			if(Mid(In, i, 1) == "\\")
			{
				Out = Right(In, Len(In) - i);
				return True;
			}
			else
			{
				Result = Result $ Mid(In, i, 1);
			}
		}
		else
		{
			if(Mid(In, i, 1) == "\\")
			{
				bFoundStart = True;
			}
		}
	}

	return False;
}

function string LocalizeBoolValue(string Value)
{
	if(Value ~= "True")
		return TrueString;
	
	if(Value ~= "False")
		return FalseString;

	return Value;
}

function string LocalizeSkin(string SkinName)
{
	local string MeshName, Junk, SkinDesc;

	MeshName = Left(SkinName, InStr(SkinName, "."));

	GetNextSkin(MeshName, SkinName$"1", 0, Junk, SkinDesc);
	if(Junk == "")
		GetNextSkin(MeshName, SkinName, 0, Junk, SkinDesc);
	if(Junk == "")
		return GetItemName(SkinName);
	
	return SkinDesc;
}

function string LocalizeTeam(string TeamNum)
{
	if(TeamNum == "255")
		return "";

	return TeamNum;
}

function AddRule(string Rule, string Value)
{
	local UBrowserRulesList  RulesList;

	ValidateServer();

	for(RulesList = UBrowserRulesList(Server.RulesList.Next); RulesList != None; RulesList = UBrowserRulesList(RulesList.Next))
		if(RulesList.Rule == Rule)
			return; // Rule already exists

	// Add the rule
	RulesList = UBrowserRulesList(Server.RulesList.Append(class'UBrowserRulesList'));
	RulesList.Rule = Rule;
	RulesList.Value = Value;
}

state Binding
{
Begin:
	if( BindPort(2000, true) == 0 )
	{
		Log("DeusExServerPing: Port failed to bind.  Attempt "$BindAttempts);
		BindAttempts++;

		ValidateServer();
		if(BindAttempts == MaxBindAttempts)
			Server.PingDone(bInitial, bJustThisServer, False, bNoSort);
		else
			GotoState('BindFailed');
	}
	else
	{
		GotoState(QueryState);
	}
}

state BindFailed
{
	event Timer()
	{
		GotoState('Binding');
	}

Begin:
	SetTimer(BindRetryTime, False);
}

state GetStatus 
{
	event ReceivedText( IpAddr Addr, string Text )
	{
		local string Value;
		local string In;
		local string Out;
		local byte ID;
		local bool bOK;
		local UBrowserPlayerList PlayerEntry;

		ValidateServer();

      log("Received text "$Text);

		In = Text;
		do 
		{
			bOK = GetNextValue(In, Out, Value);
			In = Out;
			if(Left(Value, 7) == "player_")
			{
				ID = Int(Right(Value, Len(Value) - 7));

				PlayerEntry = Server.PlayerList.FindID(ID);
				if(PlayerEntry == None) 
					PlayerEntry = UBrowserPlayerList(Server.PlayerList.Append(class'UBrowserPlayerList'));
				PlayerEntry.PlayerID = ID;

				bOK = GetNextValue(In, Out, Value);
				In = Out;
				PlayerEntry.PlayerName = Value;
			} 
			else if(Left(Value, 6) == "frags_") 
			{
				ID = Int(Right(Value, Len(Value) - 6));

				bOK = GetNextValue(In, Out, Value);
				In = Out;
				PlayerEntry = Server.PlayerList.FindID(ID);
				PlayerEntry.PlayerFrags = Int(Value);
			}
			else if(Left(Value, 5) == "ping_")
			{
				ID = Int(Right(Value, Len(Value) - 5));

				bOK = GetNextValue(In, Out, Value);
				In = Out;
				PlayerEntry = Server.PlayerList.FindID(ID);
				PlayerEntry.PlayerPing = Int(Right(Value, len(Value) - 1));  // leading space
			}
			else if(Left(Value, 5) == "team_")
			{
				ID = Int(Right(Value, Len(Value) - 5));

				bOK = GetNextValue(In, Out, Value);
				In = Out;
				PlayerEntry = Server.PlayerList.FindID(ID);
				PlayerEntry.PlayerTeam = LocalizeTeam(Value);
			}
			else if(Left(Value, 5) == "skin_")
			{
				ID = Int(Right(Value, Len(Value) - 5));

				bOK = GetNextValue(In, Out, Value);
				In = Out;
				PlayerEntry = Server.PlayerList.FindID(ID);
				PlayerEntry.PlayerSkin = LocalizeSkin(Value);
			}
			else if(Left(Value, 5) == "face_")
			{
				ID = Int(Right(Value, Len(Value) - 5));

				bOK = GetNextValue(In, Out, Value);
				In = Out;
				PlayerEntry = Server.PlayerList.FindID(ID);
				PlayerEntry.PlayerFace = GetItemName(Value);
			}
			else if(Left(Value, 5) == "mesh_")
			{
				ID = Int(Right(Value, Len(Value) - 5));

				bOK = GetNextValue(In, Out, Value);
				In = Out;
				PlayerEntry = Server.PlayerList.FindID(ID);
				PlayerEntry.PlayerMesh = Value;
			}
			else if(Left(Value, 9) == "ngsecret_")
			{
				ID = Int(Right(Value, Len(Value) - 9));

				bOK = GetNextValue(In, Out, Value);
				In = Out;
				PlayerEntry = Server.PlayerList.FindID(ID);
				PlayerEntry.PlayerStats = Value;
			}
			else if(Value == "final")
			{
				Server.StatusDone(True);
				return;
			}
			else if(Value ~= "gamever")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(GameVersionText, Value);
			}
			else if(Value ~= "minnetver")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(MinNetVersionText, Value);
			}
			else if(Value ~= "gametype")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(GameTypeText, Value);
			}
/*			else if(Value ~= "gamemode") // "openplaying"
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(GameModeText, Value);
			}*/
			else if(Value ~= "timelimit") 
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(TimeLimitText, Value);
			}
			else if(Value ~= "fraglimit") 
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(FragLimitText, Value);
			}
			else if(Value ~= "MultiplayerBots") 
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(MultiplayerBotsText, LocalizeBoolValue(Value));
			}
			else if(Value ~= "AdminName") 
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(AdminNameText, Value);
			}
			else if(Value ~= "AdminEMail")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(AdminEmailText, Value);
			}
			//else if(Value ~= "WantWorldLog")
			//{
			//	bOK = GetNextValue(In, Out, Value);
				//AddRule(WorldLogText, LocalizeBoolValue(Value));
			//}
			//else if(Value ~= "WorldLog")
			//{
				//bOK = GetNextValue(In, Out, Value);
				//if( Server.GameVer >= 406 )
				//{
					//if( Value ~= "True" )
						//AddRule(WorldLogWorkingText, WorldLogWorkingTrue);
					//else
						//AddRule(WorldLogWorkingText, WorldLogWorkingFalse);
				//}
				//else
					//AddRule(WorldLogText, LocalizeBoolValue(Value));
			//}
			else if(Value ~= "mutators")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(MutatorsText, Value);
			}
			else if(Value ~= "goalteamscore")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(GoalTeamScoreText, Value);		
			}
			else if(Value ~= "minplayers")
			{
				bOK = GetNextValue(In, Out, Value);
				if(Value == "0")
					AddRule(MultiplayerBotsText, FalseString);
				else
					AddRule(MinPlayersText, Value@PlayersText);		
			}
			else if(Value ~= "changelevels")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(ChangeLevelsText, LocalizeBoolValue(Value));		
			}
			else if(Value ~= "botskill")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(BotSkillText, Value);		
			}
			else if(Value ~= "maxteams")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(MaxTeamsText, Value);
			}
			else if(Value ~= "balanceteams")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(BalanceTeamsText, LocalizeBoolValue(Value));
			}
			else if(Value ~= "playersbalanceteams")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(PlayersBalanceTeamsText, LocalizeBoolValue(Value));
			}
			else if(Value ~= "friendlyfire")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(FriendlyFireText, Value);
			}
			else if(Value ~= "gamestyle")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(GameModeText, Value);
			}
			else if(Value ~= "tournament")
			{
				bOK = GetNextValue(In, Out, Value);
				AddRule(TournamentText, LocalizeBoolValue(Value));
			}
			else if(Value ~= "listenserver")
			{
				bOK = GetNextValue(In, Out, Value);
				if(bool(Value))
					AddRule(ServerModeText, NonDedicatedText);
				else
					AddRule(ServerModeText, DedicatedText);
			}
         else if(Value ~= "SkillsAvail")
         {
            bOK = GetNextValue(In, Out, Value);
            AddRule(StartingSkillsText, Value);
         }
         else if(Value ~= "SkillsPerKill")
         {
            bOK = GetNextValue(In, Out, Value);
            AddRule(SkillsPerKillText, Value);
         }
         else if(Value ~= "InitialAugs")
         {
            bOK = GetNextValue(In, Out, Value);
            AddRule(StartingAugsText, Value);
         }
         else if(Value ~= "AugsPerKill")
         {
            bOK = GetNextValue(In, Out, Value);
            AddRule(AugsPerKillText, Value);
         }
         else if(Value ~= "AugsAllowed")
         {
            bOK = GetNextValue(In, Out, Value);
            AddRule(AugsAllowedText, LocalizeBoolValue(Value));
         }
         else if(Value ~= "KillsToWin")
         {
            bOK = GetNextValue(In, Out, Value);
            AddRule(TargetKillsText, Value);
         }
         else if(Value ~= "TimeToWin")
         {
            bOK = GetNextValue(In, Out, Value);
            AddRule(TargetTimeText, Value);
         }
		 else if(Value ~= "Password")
		 {
			 bOK = GetNextValue(In, Out, Value);
			 AddRule(PasswordText, Value);
		 }
		} until(!bOK);
	}	

	event Timer()
	{
		if(AttemptNumber < PingAttempts)
		{
			Log("Timed out getting player replies.  Attempt "$AttemptNumber);
			AttemptNumber++;
			GotoState(QueryState);
		}
		else
		{
			Server.StatusDone(False);
			Log("Timed out getting player replies.  Giving Up");
		}
	}
Begin:
	// Player info

	ValidateServer();
	if(Server.PlayerList != None)
	{
		Server.PlayerList.DestroyList();
	}
	Server.PlayerList = New(None) class'UBrowserPlayerList';
	Server.PlayerList.SetupSentinel();	

	if(Server.RulesList != None)
	{
		Server.RulesList.DestroyList();
	}
	Server.RulesList = New(None) class'UBrowserRulesList';
	Server.RulesList.SetupSentinel();
	AddRule(ServerAddressText, "unreal://"$Server.IP$":"$string(Server.GamePort));

	SendText( ServerIPAddr, "\\status\\" );
	SetTimer(PingTimeout + Rand(200)/100, False);
}

function string ParseReply(string Text, string Key)
{
	local int i;
	local string Temp;

	i=InStr(Text, "\\"$Key$"\\");
	Temp = Mid(Text, i + Len(Key) + 2);
	return Left(Temp, InStr(Temp, "\\"));
}

state GetInfo
{
	event ReceivedText(IpAddr Addr, string Text)
	{
		local string Temp;
		local float ElapsedTime;

		// Make sure this packet really is for us.
		Temp = IpAddrToString(Addr);
		if(Server.IP != Left(Temp, InStr(Temp, ":")))
			return;

		ValidateServer();
		ElapsedTime = (Level.TimeSeconds - RequestSentTime) * Level.TimeDilation;
		Server.Ping = Max(1000*ElapsedTime - (0.5*LastDelta) - 10, 4); // subtract avg client and server frametime from ping.
		if(!Server.bKeepDescription)
			Server.HostName = Server.IP;
		Server.GamePort = 0;
		Server.MapName = "";
		Server.MapTitle = "";
		Server.MapDisplayName = "";
		Server.GameType = "";
		Server.GameMode = "";
		Server.NumPlayers = 0;
		Server.MaxPlayers = 0;
		Server.GameVer = 0;
		Server.MinNetVer = 0;

		Temp = ParseReply(Text, "hostname");
		if(Temp != "" && !Server.bKeepDescription)
			Server.HostName = Temp;

		Temp = ParseReply(Text, "hostport");
		if(Temp != "")
			Server.GamePort = Int(Temp);

		Temp = ParseReply(Text, "mapname");
		if(Temp != "")
			Server.MapName = Temp;

		Temp = ParseReply(Text, "maptitle");
		if(Temp != "")
		{
			Server.MapTitle = Temp;
			Server.MapDisplayName = Server.MapTitle;
			if(Server.MapTitle == "" || Server.MapTitle ~= "Untitled" || bUseMapName)
				Server.MapDisplayName = Server.MapName;
		}
		
		Temp = ParseReply(Text, "gametype");
		if(Temp != "")
			Server.GameType = Temp;
	
		Temp = ParseReply(Text, "numplayers");
		if(Temp != "")
			Server.NumPlayers = Int(Temp);

		Temp = ParseReply(Text, "maxplayers");
		if(Temp != "")
			Server.MaxPlayers = Int(Temp);
	
		Temp = ParseReply(Text, "gamemode");
		if(Temp != "")
			Server.GameMode = Temp;

		Temp = ParseReply(Text, "gamever");
		if(Temp != "")
			Server.GameVer = Int(Temp);

		Temp = ParseReply(Text, "minnetver");
		if(Temp != "")
			Server.MinNetVer = Int(Temp);

		if( Server.DecodeServerProperties(Text) )
		{
			Server.PingDone(bInitial, bJustThisServer, True, bNoSort);
			Disable('Tick');
		}
	}

	event Tick(Float DeltaTime)
	{
		LastDelta = DeltaTime;
	}

	event Timer()
	{
		ValidateServer();
		if(AttemptNumber < PingAttempts)
		{
			Log("Ping Timeout from "$Server.IP$".  Attempt "$AttemptNumber);
			AttemptNumber++;
			GotoState(QueryState);
		}
		else
		{
			Log("Ping Timeout from "$Server.IP$" Giving Up");

			Server.Ping = 9999;
			Server.GamePort = 0;
			Server.MapName = "";
			Server.MapDisplayName = "";
			Server.MapTitle = "";
			Server.GameType = "";
			Server.GameMode = "";
			Server.NumPlayers = 0;
			Server.MaxPlayers = 0;

			Disable('Tick');

			Server.PingDone(bInitial, bJustThisServer, False, bNoSort);
		}
	}

Begin:
	Enable('Tick');
	SendText( ServerIPAddr, "\\info\\" );
	RequestSentTime = Level.TimeSeconds;
	SetTimer(PingTimeout + Rand(200)/100, False);
}

state Resolving
{
Begin:
	Resolve( Server.IP );
}

defaultproperties
{
     AdminEmailText="Admin Email"
     AdminNameText="Admin Name"
     ChangeLevelsText="Change Levels"
     MultiplayerBotsText="Bots in Multiplayer"
     FragLimitText="Frag Limit"
     TimeLimitText="Time Limit"
     GameModeText="Game Mode"
     GameTypeText="Game Type"
     GameVersionText="Game Version"
     WorldLogText="ngWorldStats"
     MutatorsText="Mutators"
     TrueString="Enabled"
     FalseString="Disabled"
     ServerAddressText="Server Address"
     GoalTeamScoreText="Required Team Score"
     MinPlayersText="Bots Enter Game for Min. of"
     PlayersText="Players"
     MaxTeamsText="Max Teams"
     BalanceTeamsText="Bots Balance Teams"
     PlayersBalanceTeamsText="Force Team Balance"
     FriendlyFireText="Friendly Fire Damage"
     MinNetVersionText="Min. Compatible Version"
     BotSkillText="Bot Skill"
     TournamentText="Tournament Mode"
     ServerModeText="Server Mode"
     DedicatedText="Dedicated"
     NonDedicatedText="Non-Dedicated"
     WorldLogWorkingText="ngWorldStats Status"
     WorldLogWorkingTrue="Processing Stats Correctly"
     WorldLogWorkingFalse="Not Processing Stats Correctly"
     StartingSkillsText="Skill points at start"
     SkillsPerKillText="Skill points per kill"
     StartingAugsText="Augmentations at start"
     AugsPerKillText="Augmentations per kill"
     AugsAllowedText="Augmentations"
     TargetKillsText="Frag limit"
     TargetTimeText="Time limit(minutes)"
     PasswordText="Password protected"
     MaxBindAttempts=5
     BindRetryTime=10
     PingTimeout=5
}
