//=============================================================================
// DeusExPlayer.
//=============================================================================
class DeusExPlayer extends PlayerPawnExt
	native;

#exec OBJ LOAD FILE=Effects

// Name and skin assigned to PC by player on the Character Generation screen
var travel String	TruePlayerName;
var travel int      PlayerSkin;

// Combat Difficulty, set only at new game time
var travel Float CombatDifficulty;

// Augmentation system vars
var travel AugmentationManager AugmentationSystem;

// Skill system vars
var travel SkillManager SkillSystem;

var() travel int SkillPointsTotal;
var() travel int SkillPointsAvail;

// Credits (money) the player has
var travel int Credits;

// Energy the player has
var travel float Energy;
var travel float EnergyMax;
var travel float EnergyDrain;				// amount of energy left to drain
var travel float EnergyDrainTotal;		// total amount of energy to drain
var float MaxRegenPoint;     // in multiplayer, the highest that auto regen will take you
var float RegenRate;         // the number of points healed per second in mp

// Keyring, used to store any keys the player picks up
var travel NanoKeyRing KeyRing;		// Inventory Item
var travel NanoKeyInfo KeyList;		// List of Keys

// frob vars
var() float MaxFrobDistance;
var Actor FrobTarget;
var float FrobTime;

// HUD Refresh Timer
var float LastRefreshTime; 

// Conversation System Vars
var ConPlay conPlay;						// Conversation
var DataLinkPlay dataLinkPlay;				// Used for DataLinks
var travel ConHistory conHistory;			// Conversation History

// Inventory System Vars
var travel byte				invSlots[30];		// 5x6 grid of inventory slots
var int						maxInvRows;			// Maximum number of inventory rows
var int						maxInvCols;			// Maximum number of inventory columns
var travel Inventory		inHand;				// The current object in hand
var travel Inventory		inHandPending;		// The pending item waiting to be put in hand
var travel Inventory		ClientinHandPending; // Client temporary inhand pending, for mousewheel use.
var travel Inventory		LastinHand;			// Last object inhand, so we can detect inhand changes on the client.
var travel bool				bInHandTransition;	// The inHand is being swapped out
// DEUS_EX AMSD  Whether to ignore inv slots in multiplayer
var bool bBeltIsMPInventory;

// Goal Tracking
var travel DeusExGoal FirstGoal;	
var travel DeusExGoal LastGoal;

// Note Tracking
var travel DeusExNote FirstNote;
var travel DeusExNote LastNote;

// Data Vault Images
var travel DataVaultImage FirstImage;

// Log Messages
var DeusExLog FirstLog;
var DeusExLog LastLog;

// used by ViewModel
var Actor ViewModelActor[8];

// DEUS_EX AMSD For multiplayer option propagation UGH!
// In most cases options will sync on their own.  But for
// initial loadout based on options, we need to send them to the
// server.  Easiest thing to do is have a function at startup
// that sends that info.
var bool bFirstOptionsSynced;
var bool bSecondOptionsSynced;

// used while crouching
var travel bool bForceDuck;
var travel bool bCrouchOn;				// used by toggle crouch
var travel bool bWasCrouchOn;			// used by toggle crouch
var travel byte lastbDuck;				// used by toggle crouch

// leaning vars
var bool bCanLean;
var float curLeanDist;
var float prevLeanDist;

// toggle walk
var bool bToggleWalk;

// communicate run silent value in multiplayer
var float	RunSilentValue;

// cheats
var bool  bWarrenEMPField;
var float WarrenTimer;
var int   WarrenSlot;

// used by lots of stuff
var name FloorMaterial;
var name WallMaterial;
var Vector WallNormal;

// drug effects on the player
var float drugEffectTimer;

// shake variables
var float JoltMagnitude;  // magnitude of bounce imposed by heavy footsteps

// poison dart effects on the player
var float poisonTimer;      // time remaining before next poison TakeDamage
var int   poisonCounter;    // number of poison TakeDamages remaining
var int   poisonDamage;     // damage taken from poison effect

// bleeding variables
var     float       BleedRate;      // how profusely the player is bleeding; 0-1
var     float       DropCounter;    // internal; used in tick()
var()   float       ClotPeriod;     // seconds it takes bleedRate to go from 1 to 0

var float FlashTimer; // How long it should take the current flash to fade.

// length of time player can stay underwater
// modified by SkillSwimming, AugAqualung, and Rebreather
var float swimDuration;
var float swimTimer;
var float swimBubbleTimer;

// conversation info
var Actor ConversationActor;
var Actor lastThirdPersonConvoActor;
var float lastThirdPersonConvoTime;
var Actor lastFirstPersonConvoActor;
var float lastFirstPersonConvoTime;

var Bool bStartingNewGame;							// Set to True when we're starting a new game. 
var Bool bSavingSkillsAugs;

// Put spy drone here instead of HUD
var bool bSpyDroneActive;
var int spyDroneLevel;
var float spyDroneLevelValue;
var SpyDrone aDrone;

// Buying skills for multiplayer
var bool		bBuySkills;

// If player wants to see a profile of the killer in multiplayer
var bool		bKillerProfile;

// Multiplayer notification messages
const			MPFLAG_FirstSpot				= 0x01;
const			MPSERVERFLAG_FirstPoison	= 0x01;
const			MPSERVERFLAG_FirstBurn		= 0x02;
const			MPSERVERFLAG_TurretInv		= 0x04;
const			MPSERVERFLAG_CameraInv		= 0x08;
const			MPSERVERFLAG_LostLegs		= 0x10;
const			MPSERVERFLAG_DropItem		= 0x20;
const			MPSERVERFLAG_NoCloakWeapon = 0x40;

const			mpMsgDelay = 4.0;

var int		mpMsgFlags;
var int		mpMsgServerFlags;

const	MPMSG_TeamUnatco		=0;
const	MPMSG_TeamNsf			=1;
const	MPMSG_TeamHit			=2;
const	MPMSG_TeamSpot			=3;
const	MPMSG_FirstPoison		=4;
const	MPMSG_FirstBurn		=5;
const	MPMSG_TurretInv		=6;
const	MPMSG_CameraInv		=7;
const	MPMSG_CloseKills		=8;
const	MPMSG_TimeNearEnd		=9;
const	MPMSG_LostLegs			=10;
const	MPMSG_DropItem			=11;
const MPMSG_KilledTeammate =12;
const MPMSG_TeamLAM			=13;
const MPMSG_TeamComputer	=14;
const MPMSG_NoCloakWeapon	=15;
const MPMSG_TeamHackTurret	=16;

var int			mpMsgCode;
var float		mpMsgTime;
var int			mpMsgOptionalParam;
var String		mpMsgOptionalString;

// Variables used when starting new game to show the intro first.
var String      strStartMap;
var travel Bool bStartNewGameAfterIntro;
var travel Bool bIgnoreNextShowMenu;

// map that we're about to travel to after we finish interpolating
var String NextMap;

// Configuration Variables
var globalconfig bool bObjectNames;					// Object names on/off
var globalconfig bool bNPCHighlighting;				// NPC highlighting when new convos
var globalconfig bool bSubtitles;					// True if Conversation Subtitles are on
var globalconfig bool bAlwaysRun;					// True to default to running
var globalconfig bool bToggleCrouch;				// True to let key toggle crouch
var globalconfig float logTimeout;					// Log Timeout Value
var globalconfig byte  maxLogLines;					// Maximum number of log lines visible
var globalconfig bool bHelpMessages;				// Multiplayer help messages

// Overlay Options (TODO: Move to DeusExHUD.uc when serializable)
var globalconfig byte translucencyLevel;			// 0 - 10?
var globalconfig bool bObjectBeltVisible;
var globalconfig bool bHitDisplayVisible;
var globalconfig bool bAmmoDisplayVisible;
var globalconfig bool bAugDisplayVisible;	
var globalconfig bool bDisplayAmmoByClip;	
var globalconfig bool bCompassVisible;
var globalconfig bool bCrosshairVisible;
var globalconfig bool bAutoReload;
var globalconfig bool bDisplayAllGoals;
var globalconfig bool bHUDShowAllAugs;				// TRUE = Always show Augs on HUD
var globalconfig int  UIBackground;					// 0 = Render 3D, 1 = Snapshot, 2 = Black
var globalconfig bool bDisplayCompletedGoals;
var globalconfig bool bShowAmmoDescriptions;
var globalconfig bool bConfirmSaveDeletes;
var globalconfig bool bConfirmNoteDeletes;
var globalconfig bool bAskedToTrain;

// Multiplayer Playerspecific options
var() globalconfig Name AugPrefs[9]; //List of aug preferences.

// Used to manage NPC Barks
var travel BarkManager barkManager;

// Color Theme Manager, used to manage all the pretty 
// colors the player gets to play with for the Menus
// and HUD windows.

var travel ColorThemeManager ThemeManager;
var globalconfig String MenuThemeName;
var globalconfig String HUDThemeName;

// Translucency settings for various UI Elements
var globalconfig Bool bHUDBordersVisible;
var globalconfig Bool bHUDBordersTranslucent;
var globalconfig Bool bHUDBackgroundTranslucent;
var globalconfig Bool bMenusTranslucent;

var localized String InventoryFull;
var localized String TooMuchAmmo;
var localized String TooHeavyToLift;
var localized String CannotLift;
var localized String NoRoomToLift;
var localized String CanCarryOnlyOne;
var localized String CannotDropHere;
var localized String HandsFull;
var localized String NoteAdded;
var localized String GoalAdded;
var localized String PrimaryGoalCompleted;
var localized String SecondaryGoalCompleted;
var localized String EnergyDepleted;
var localized String AddedNanoKey;
var localized String HealedPointsLabel;
var localized String HealedPointLabel;
var localized String SkillPointsAward;
var localized String QuickSaveGameTitle;
var localized String WeaponUnCloak;
var localized String TakenOverString;
var localized String	HeadString;
var localized String	TorsoString;
var localized String LegsString;
var localized String WithTheString;
var localized String WithString;
var localized String PoisonString;
var localized String BurnString;
var localized String NoneString;

var ShieldEffect DamageShield; //visual damage effect for multiplayer feedback
var float ShieldTimer; //for turning shield to fade.
enum EShieldStatus
{
   SS_Off,
   SS_Fade,
   SS_Strong
};

var EShieldStatus ShieldStatus;

var Pawn					myBurner;
var Pawn					myPoisoner;
var Actor				myProjKiller;
var Actor				myTurretKiller;
var Actor				myKiller;
var KillerProfile		killProfile;
var InvulnSphere		invulnSph;

// Conversation Invocation Methods
enum EInvokeMethod
{
	IM_Bump,
	IM_Frob,
	IM_Sight,
	IM_Radius,
	IM_Named,
	IM_Other
};

enum EMusicMode
{
	MUS_Ambient,
	MUS_Combat,
	MUS_Conversation,
	MUS_Outro,
	MUS_Dying
};

var EMusicMode musicMode;
var byte savedSection;		// last section playing before interrupt
var float musicCheckTimer;
var float musicChangeTimer;

// Used to keep track of # of saves
var travel int saveCount;
var travel Float saveTime;

// for getting at the debug system
var DebugInfo GlobalDebugObj;

// Set to TRUE if the player can see the quotes.  :)
var globalconfig bool bQuotesEnabled;

// DEUS_EX AMSD For propagating gametype
var GameInfo DXGame;
var float	 ServerTimeDiff;
var float	 ServerTimeLastRefresh;

// DEUS_EX AMSD For trying higher damage games
var float MPDamageMult;

// Nintendo immunity
var float	NintendoImmunityTime;
var float	NintendoImmunityTimeLeft;
var bool		bNintendoImmunity;
const			NintendoDelay = 6.0;

// For closing comptuers if the server quits
var Computers ActiveComputer;

// native Functions
native(1099) final function string GetDeusExVersion();
native(2100) final function ConBindEvents();
native(3001) final function name SetBoolFlagFromString(String flagNameString, bool bValue);
native(3002) final function ConHistory CreateHistoryObject();
native(3003) final function ConHistoryEvent CreateHistoryEvent();
native(3010) final function DeusExLog CreateLogObject();
native(3011) final function SaveGame(int saveIndex, optional String saveDesc);
native(3012) final function DeleteSaveGameFiles(optional String saveDirectory);
native(3013) final function GameDirectory CreateGameDirectoryObject();
native(3014) final function DataVaultImageNote CreateDataVaultImageNoteObject();
native(3015) final function DumpLocation CreateDumpLocationObject();
native(3016) final function UnloadTexture(Texture texture);
//native 3017 taken by particleiterator.

//
// network replication
//
replication
{
    // server to client
    reliable if ((Role == ROLE_Authority) && (bNetOwner))
        AugmentationSystem, SkillSystem, SkillPointsTotal, SkillPointsAvail, inHand, inHandPending, KeyRing, Energy, 
		  bSpyDroneActive, DXGame, bBuySkills, drugEffectTimer, killProfile;

    reliable if (Role == ROLE_Authority)
       ShieldStatus, RunSilentValue, aDrone, NintendoImmunityTimeLeft;
    
    // client to server
	reliable if (Role < ROLE_Authority)
		BarkManager, FrobTarget, AugPrefs, bCanLean, curLeanDist, prevLeanDist, 
		bInHandTransition, bForceDuck, FloorMaterial, WallMaterial, WallNormal, swimTimer, swimDuration;

	// Functions the client can call
	reliable if (Role < ROLE_Authority)
		DoFrob, ParseLeftClick, ParseRightClick, ReloadWeapon, PlaceItemInSlot, RemoveItemFromSlot, ClearInventorySlots,
      SetInvSlots, FindInventorySlot, ActivateBelt, DropItem, SetInHand, AugAdd, ExtinguishFire, CatchFire,
      AllEnergy, ClearPosition, ClearBelt, AddObjectToBelt, RemoveObjectFromBelt, TeamSay,
      KeypadRunUntriggers, KeypadRunEvents, KeypadToggleLocks, ReceiveFirstOptionSync, ReceiveSecondOptionSync,CreateDrone, MoveDrone,
      CloseComputerScreen, SetComputerHackTime, UpdateCameraRotation, ToggleCameraState,
      SetTurretTrackMode, SetTurretState, NewMultiplayerMatch, PopHealth, ServerUpdateLean, BuySkills, PutInHand,
      MakeCameraAlly, PunishDetection, ServerSetAutoReload, FailRootWindowCheck, FailConsoleCheck, ClientPossessed;

   // Unreliable functions the client can call
   unreliable if (Role < ROLE_Authority)
      MaintainEnergy, UpdateTranslucency;

   // Functions the server calls in client
   reliable if ((Role == ROLE_Authority) && (bNetOwner))
      UpdateAugmentationDisplayStatus, AddAugmentationDisplay, RemoveAugmentationDisplay, ClearAugmentationDisplay, ShowHud,
		ActivateKeyPadWindow, SetDamagePercent, SetServerTimeDiff, ClientTurnOffScores;

   reliable if (Role == ROLE_Authority)
      InvokeComputerScreen, ClientDeath, AddChargedDisplay, RemoveChargedDisplay, MultiplayerDeathMsg, MultiplayerNotifyMsg, 
      BuySkillSound, ShowMultiplayerWin, ForceDroneOff ,AddDamageDisplay, ClientSpawnHits, CloseThisComputer, ClientPlayAnimation, ClientSpawnProjectile, LocalLog,
	  VerifyRootWindow, VerifyConsole, ForceDisconnect;

}

// ----------------------------------------------------------------------
// PostBeginPlay()
//
// set up the augmentation and skill systems
// ----------------------------------------------------------------------

function PostBeginPlay()
{
	local DeusExLevelInfo info;
	local int levelInfoCount;

	Super.PostBeginPlay();

	// Check to make sure there's only *ONE* DeusExLevelInfo and 
	// go fucking *BOOM* if we find more than one.

	levelInfoCount = 0;
	foreach AllActors(class'DeusExLevelInfo', info)
		levelInfoCount++;

	Assert(levelInfoCount <= 1);
	
	// give us a shadow
   if (Level.Netmode == NM_Standalone)   
      CreateShadow();

	InitializeSubSystems();
   DXGame = Level.Game;
   ShieldStatus = SS_Off;
	ServerTimeLastRefresh = 0;

	// Safeguard so no cheats in multiplayer
	if ( Level.NetMode != NM_Standalone )
		bCheatsEnabled = False;
}

function ServerSetAutoReload( bool bAuto )
{
	bAutoReload = bAuto;
}

// ----------------------------------------------------------------------

function SetServerTimeDiff( float sTime )
{
	ServerTimeDiff = (sTime - Level.Timeseconds);
}

// ----------------------------------------------------------------------
// PostNetBeginPlay()
//
// Take care of the theme manager
// ----------------------------------------------------------------------

simulated function PostNetBeginPlay()
{
   Super.PostNetBeginPlay();

   if (Role == ROLE_SimulatedProxy)
   {
      DrawShield();
      CreatePlayerTracker();
		if ( NintendoImmunityTimeLeft > 0.0 )
			DrawInvulnShield();
      return;
   }

    //DEUS_EX AMSD In multiplayer, we need to do this for our local theme manager, since
    //PostBeginPlay isn't called to set these up, and the Thememanager can be local, it
    //doesn't have to sync with the server.
    if (ThemeManager == NONE)
    {
        CreateColorThemeManager();
        ThemeManager.SetOwner(self);
        ThemeManager.SetCurrentHUDColorTheme(ThemeManager.GetFirstTheme(1));		
        ThemeManager.SetCurrentMenuColorTheme(ThemeManager.GetFirstTheme(0)); 
        ThemeManager.SetMenuThemeByName(MenuThemeName);	 
        ThemeManager.SetHUDThemeByName(HUDThemeName);
        if (DeusExRootWindow(rootWindow) != None)
           DeusExRootWindow(rootWindow).ChangeStyle();        
    }
    ReceiveFirstOptionSync(AugPrefs[0], AugPrefs[1], AugPrefs[2], AugPrefs[3], AugPrefs[4]);
    ReceiveSecondOptionSync(AugPrefs[5], AugPrefs[6], AugPrefs[7], AugPrefs[8]);
    ShieldStatus = SS_Off;
	 bCheatsEnabled = False;

	 ServerSetAutoReload( bAutoReload );
}

// ----------------------------------------------------------------------
// InitializeSubSystems()
// ----------------------------------------------------------------------

function InitializeSubSystems()
{
	// Spawn the BarkManager
	if (BarkManager == None)
		BarkManager = Spawn(class'BarkManager', Self);

	// Spawn the Color Manager
	CreateColorThemeManager();
    ThemeManager.SetOwner(self);

	// install the augmentation system if not found
	if (AugmentationSystem == None)
	{
		AugmentationSystem = Spawn(class'AugmentationManager', Self);
		AugmentationSystem.CreateAugmentations(Self);
		AugmentationSystem.AddDefaultAugmentations();        
        AugmentationSystem.SetOwner(Self);       
	}
	else
	{
		AugmentationSystem.SetPlayer(Self);
        AugmentationSystem.SetOwner(Self);
	}

	// install the skill system if not found
	if (SkillSystem == None)
	{
		SkillSystem = Spawn(class'SkillManager', Self);
		SkillSystem.CreateSkills(Self);
	}
	else
	{
		SkillSystem.SetPlayer(Self);
	}

   if ((Level.Netmode == NM_Standalone) || (!bBeltIsMPInventory))
   {
      // Give the player a keyring
      CreateKeyRing();
   }
}

// ----------------------------------------------------------------------
// PostPostBeginPlay()
// ----------------------------------------------------------------------

function PostPostBeginPlay()
{
	Super.PostPostBeginPlay();

	// Bind any conversation events to this DeusExPlayer
	ConBindEvents();

	// Restore colors that the user selected (as opposed to those
	// stored in the savegame)
	ThemeManager.SetMenuThemeByName(MenuThemeName);
	ThemeManager.SetHUDThemeByName(HUDThemeName);

	if ((Level.NetMode != NM_Standalone) && ( killProfile == None ))
		killProfile = Spawn(class'KillerProfile', Self);
}

// ----------------------------------------------------------------------
// PreTravel() - Called when a ClientTravel is about to happen
// ----------------------------------------------------------------------

function PreTravel()
{
	// Set a flag designating that we're traveling,
	// so MissionScript can check and not call FirstFrame() for this map.
	
	flagBase.SetBool('PlayerTraveling', True, True, 0);

	SaveSkillPoints();

	if (dataLinkPlay != None)
		dataLinkPlay.AbortAndSaveHistory();

	// If the player is burning (Fire! Fire!), extinguish him
	// before the map transition.  This is done to fix stuff 
	// that's fucked up.
	ExtinguishFire();
}

// ----------------------------------------------------------------------
// TravelPostAccept()
// ----------------------------------------------------------------------

event TravelPostAccept()
{
	local DeusExLevelInfo info;
	local MissionScript scr;
	local bool bScriptRunning;
	local InterpolationPoint I;

	Super.TravelPostAccept();

	// reset the keyboard
	ResetKeyboard();

	info = GetLevelInfo();

	if (info != None)
	{
		// hack for the DX.dx logo/splash level
		if (info.MissionNumber == -2)
		{
			foreach AllActors(class 'InterpolationPoint', I, 'IntroCam')
			{
				if (I.Position == 1)
				{
					SetCollision(False, False, False);
					bCollideWorld = False;
					Target = I;
					SetPhysics(PHYS_Interpolating);
					PhysRate = 1.0;
					PhysAlpha = 0.0;
					bInterpolating = True;
					bStasis = False;
					ShowHud(False);
					PutInHand(None);
					GotoState('Interpolating');
					break;
				}
			}
			return;
		}

		// hack for the DXOnly.dx splash level
		if (info.MissionNumber == -1)
		{
			ShowHud(False);
			GotoState('Paralyzed');
			return;
		}
	}

	// Restore colors
	if (ThemeManager != None)
	{
		ThemeManager.SetMenuThemeByName(MenuThemeName);
		ThemeManager.SetHUDThemeByName(HUDThemeName);
	}

	// Make sure any charged pickups that were active 
	// before travelling are still active.
	RefreshChargedPickups();

	// Make sure the Skills and Augmentation systems 
	// are properly initialized and reset.

	RestoreSkillPoints();

	if (SkillSystem != None)
	{
		SkillSystem.SetPlayer(Self);
	}

	if (AugmentationSystem != None)
	{
		// set the player correctly
		AugmentationSystem.SetPlayer(Self);
		AugmentationSystem.RefreshAugDisplay();
	}

	// Nuke any existing conversation
	if (conPlay != None)
		conPlay.TerminateConversation();

	// Make sure any objects that care abou the PlayerSkin
	// are notified
	UpdatePlayerSkin();

	// If the player was carrying a decoration, 
	// call TravelPostAccept() so it can initialize itself
	if (CarriedDecoration != None)
		CarriedDecoration.TravelPostAccept();

	// If the player was carrying a decoration, make sure
	// it's placed back in his hand (since the location
	// info won't properly travel)
	PutCarriedDecorationInHand();

	// Reset FOV
	SetFOVAngle(Default.DesiredFOV);

	// If the player had a scope view up, make sure it's 
	// properly restore
	RestoreScopeView();

	// make sure the mission script has been spawned correctly
	if (info != None)
	{
		bScriptRunning = False;
		foreach AllActors(class'MissionScript', scr)
			bScriptRunning = True;

		if (!bScriptRunning)
			info.SpawnScript();
	}

	// make sure the player's eye height is correct
	BaseEyeHeight = CollisionHeight - (GetDefaultCollisionHeight() - Default.BaseEyeHeight);
}

// ----------------------------------------------------------------------
// Update Time Played
// ----------------------------------------------------------------------

final function UpdateTimePlayed(float deltaTime)
{
	saveTime += deltaTime;
}

// ----------------------------------------------------------------------
// RestoreScopeView()
// ----------------------------------------------------------------------

function RestoreScopeView()
{
	if (inHand != None)
	{
		if (inHand.IsA('Binoculars') && (inHand.bActive))
			Binoculars(inHand).RefreshScopeDisplay(Self, True);
		else if ((DeusExWeapon(inHand) != None) && (DeusExWeapon(inHand).bZoomed))
			DeusExWeapon(inHand).RefreshScopeDisplay(Self, True, True);
	}
}

// ----------------------------------------------------------------------
// RefreshChargedPickups()
// ----------------------------------------------------------------------

function RefreshChargedPickups()
{
	local ChargedPickup anItem;

	// Loop through all the ChargedPicksups and look for charged pickups
	// that are active.  If we find one, add to the user-interface.

	foreach AllActors(class'ChargedPickup', anItem)
	{
		if ((anItem.Owner == Self) && (anItem.IsActive()))
		{
			// Make sure tech goggles display is refreshed
			if (anItem.IsA('TechGoggles'))
				TechGoggles(anItem).UpdateHUDDisplay(Self);

			AddChargedDisplay(anItem);
		}
	}
}

// ----------------------------------------------------------------------
// UpdatePlayerSkin()
// ----------------------------------------------------------------------

function UpdatePlayerSkin()
{
	local PaulDenton paul;
	local PaulDentonCarcass paulCarcass;
	local JCDentonMaleCarcass jcCarcass;
	local JCDouble jc;

	// Paul Denton
	foreach AllActors(class'PaulDenton', paul)
		break;

	if (paul != None)
		paul.SetSkin(Self);

	// Paul Denton Carcass
	foreach AllActors(class'PaulDentonCarcass', paulCarcass)
		break;

	if (paulCarcass != None)
		paulCarcass.SetSkin(Self);

	// JC Denton Carcass
	foreach AllActors(class'JCDentonMaleCarcass', jcCarcass)
		break;

	if (jcCarcass != None)
		jcCarcass.SetSkin(Self);

	// JC's stunt double
	foreach AllActors(class'JCDouble', jc)
		break;

	if (jc != None)
		jc.SetSkin(Self);
}


// ----------------------------------------------------------------------
// GetLevelInfo()
// ----------------------------------------------------------------------

function DeusExLevelInfo GetLevelInfo()
{
	local DeusExLevelInfo info;

	foreach AllActors(class'DeusExLevelInfo', info)
		break;

	return info;
}

//
// If player chose to dual map the F keys
//
exec function DualmapF3() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(0); }
exec function DualmapF4() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(1); }
exec function DualmapF5() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(2); }
exec function DualmapF6() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(3); }
exec function DualmapF7() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(4); }
exec function DualmapF8() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(5); }
exec function DualmapF9() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(6); }
exec function DualmapF10() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(7); }
exec function DualmapF11() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(8); }
exec function DualmapF12() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(9); }

//
// Team Say
//
exec function TeamSay( string Msg )
{
	local Pawn P;
	local String str;

	if ( TeamDMGame(DXGame) == None )
	{
		Say(Msg);
		return;
	}

	str = PlayerReplicationInfo.PlayerName $ ": " $ Msg;

	if ( Role == ROLE_Authority )
		log( "TeamSay>" $ str );

	for( P=Level.PawnList; P!=None; P=P.nextPawn )
	{
		if( P.bIsPlayer && (P.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team) )
		{
			if ( P.IsA('DeusExPlayer') )
				DeusExPlayer(P).ClientMessage( str, 'TeamSay', true );
		}
	}
}

// ----------------------------------------------------------------------
// RestartLevel()
// ----------------------------------------------------------------------

exec function RestartLevel()
{
	ResetPlayer();
	Super.RestartLevel();
}

// ----------------------------------------------------------------------
// LoadGame()
// ----------------------------------------------------------------------

exec function LoadGame(int saveIndex)
{
	// Reset the FOV
	DesiredFOV = Default.DesiredFOV;

	DeusExRootWindow(rootWindow).ClearWindowStack();
	ClientTravel("?loadgame=" $ saveIndex, TRAVEL_Absolute, False);
}

// ----------------------------------------------------------------------
// QuickSave()
// ----------------------------------------------------------------------

exec function QuickSave()
{
	local DeusExLevelInfo info;

	info = GetLevelInfo();

	// Don't allow saving if:
	//
	// 1) The player is dead
	// 2) We're on the logo map
	// 4) We're interpolating (playing outtro)
	// 3) A datalink is playing
   // 4) We're in a multiplayer game

	if (((info != None) && (info.MissionNumber < 0)) || 
	   ((IsInState('Dying')) || (IsInState('Paralyzed')) || (IsInState('Interpolating'))) || 
	   (dataLinkPlay != None) || (Level.Netmode != NM_Standalone))
	{
	   return;
	}

	SaveGame(-1, QuickSaveGameTitle);
}

// ----------------------------------------------------------------------
// QuickLoad()
// ----------------------------------------------------------------------

exec function QuickLoad()
{
   //Don't allow in multiplayer.

   if (Level.Netmode != NM_Standalone)
      return;

	if (DeusExRootWindow(rootWindow) != None) 
		DeusExRootWindow(rootWindow).ConfirmQuickLoad();
}

// ----------------------------------------------------------------------
// QuickLoadConfirmed()
// ----------------------------------------------------------------------

function QuickLoadConfirmed()
{
   if (Level.Netmode != NM_Standalone)
      return;
	LoadGame(-1);
}

// ----------------------------------------------------------------------
// BuySkillSound()
// ----------------------------------------------------------------------

function BuySkillSound( int code )
{
	local Sound snd;

	switch( code )
	{
		case 0:
			snd = Sound'Menu_OK';
			break;
		case 1:
			snd = Sound'Menu_Cancel';
			break;
		case 2:
			snd = Sound'Menu_Focus';
			break;
		case 3:
			snd = Sound'Menu_BuySkills';
			break;
	}
	PlaySound( snd, SLOT_Interface, 0.75 );
}

// ----------------------------------------------------------------------
// StartNewGame()
//
// Starts a new game given the map passed in
// ----------------------------------------------------------------------

exec function StartNewGame(String startMap)
{
	if (DeusExRootWindow(rootWindow) != None)
		DeusExRootWindow(rootWindow).ClearWindowStack();

	// Set a flag designating that we're traveling,
	// so MissionScript can check and not call FirstFrame() for this map.
	flagBase.SetBool('PlayerTraveling', True, True, 0);

	SaveSkillPoints();
	ResetPlayer();
	DeleteSaveGameFiles();

	bStartingNewGame = True;

	// Send the player to the specified map!
	if (startMap == "")
		Level.Game.SendPlayer(Self, "01_NYC_UNATCOIsland");		// TODO: Must be stored somewhere!
	else
		Level.Game.SendPlayer(Self, startMap);
}

// ----------------------------------------------------------------------
// StartTrainingMission()
// ----------------------------------------------------------------------

function StartTrainingMission()
{
	if (DeusExRootWindow(rootWindow) != None)
		DeusExRootWindow(rootWindow).ClearWindowStack();

   // Make sure the player isn't asked to do this more than
	// once if prompted on the main menu.
	if (!bAskedToTrain)
	{
		bAskedToTrain = True;
		SaveConfig();
	}

   SkillSystem.ResetSkills();
	ResetPlayer(True);
	DeleteSaveGameFiles();
	bStartingNewGame = True;
	Level.Game.SendPlayer(Self, "00_Training");
}

// ----------------------------------------------------------------------
// ShowIntro()
// ----------------------------------------------------------------------

function ShowIntro(optional bool bStartNewGame)
{
	if (DeusExRootWindow(rootWindow) != None)
		DeusExRootWindow(rootWindow).ClearWindowStack();

	bStartNewGameAfterIntro = bStartNewGame;

	// Make sure all augmentations are OFF before going into the intro
	AugmentationSystem.DeactivateAll();

	// Reset the player
	Level.Game.SendPlayer(Self, "00_Intro");
}

// ----------------------------------------------------------------------
// ShowCredits()
// ----------------------------------------------------------------------

function ShowCredits(optional bool bLoadIntro)
{
	local DeusExRootWindow root;
	local CreditsWindow winCredits;

	root = DeusExRootWindow(rootWindow);

	if (root != None)
	{
		// Show the credits screen and force the game not to pause
		// if we're showing the credits after the endgame
		winCredits = CreditsWindow(root.InvokeMenuScreen(Class'CreditsWindow', bLoadIntro));
		winCredits.SetLoadIntro(bLoadIntro);
	}
}

// ----------------------------------------------------------------------
// StartListenGame()
// ----------------------------------------------------------------------

function StartListenGame(string options)
{
   local DeusExRootWindow root;

   root = DeusExRootWindow(rootWindow);

   if (root != None)
      root.ClearWindowStack();

   ConsoleCommand("start "$options$"?listen");
}

// ----------------------------------------------------------------------
// StartMultiplayerGame()
// ----------------------------------------------------------------------

function StartMultiplayerGame(string command)
{
   local DeusExRootWindow root;

   root = DeusExRootWindow(rootWindow);

   if (root != None)
      root.ClearWindowStack();

   ConsoleCommand(command);
}

// ----------------------------------------------------------------------
// NewMultiplayerMatch()
// ----------------------------------------------------------------------

function NewMultiplayerMatch()
{
	DeusExMPGame( DXGame ).RestartPlayer( Self );
	PlayerReplicationInfo.Score = 0;
	PlayerReplicationInfo.Deaths = 0;
	PlayerReplicationInfo.Streak = 0;
}

// ----------------------------------------------------------------------
// ShowMultiplayerWin()
// ----------------------------------------------------------------------

function ShowMultiplayerWin( String winnerName, int winningTeam, String Killer, String Killee, String Method )
{
	local HUDMultiplayer mpScr;
	local DeusExRootWindow root;

	if (( Player != None ) && ( Player.Console != None ))
		Player.Console.ClearMessages();

	root = DeusExRootWindow(rootWindow);

	if ( root != None )
	{
		mpScr = HUDMultiplayer(root.InvokeUIScreen(Class'HUDMultiplayer', True));
		root.MaskBackground(True);

		if ( mpScr != None )
		{
         mpScr.winnerName = winnerName;
			mpScr.winningTeam = winningTeam;
			mpScr.winKiller = Killer;
			mpScr.winKillee = Killee;
			mpScr.winMethod = Method;
		}
	}

   //Do cleanup
   if (PlayerIsClient())
   {
      if (AugmentationSystem != None)
         AugmentationSystem.DeactivateAll();
   }
}


// ----------------------------------------------------------------------
// ResetPlayer()
//
// Called when a new game is started. 
//
// 1) Erase all flags except those beginning with "SKTemp_"
// 2) Dumps inventory
// 3) Restore any other defaults
// ----------------------------------------------------------------------

function ResetPlayer(optional bool bTraining)
{
	local inventory anItem;
	local inventory nextItem;

	ResetPlayerToDefaults();

	// Reset Augmentations
	if (AugmentationSystem != None)
	{
		AugmentationSystem.ResetAugmentations();
		AugmentationSystem.Destroy();
		AugmentationSystem = None;
	}

	// Give the player a pistol and a prod
	if (!bTraining)
	{
		anItem = Spawn(class'WeaponPistol');
		anItem.Frob(Self, None);
		anItem.bInObjectBelt = True;
		anItem = Spawn(class'WeaponProd');
		anItem.Frob(Self, None);
		anItem.bInObjectBelt = True;
		anItem = Spawn(class'MedKit');
		anItem.Frob(Self, None);
		anItem.bInObjectBelt = True;
	}
}

// ----------------------------------------------------------------------
// ResetPlayerToDefaults()
//
// Resets all travel variables to their defaults
// ----------------------------------------------------------------------

function ResetPlayerToDefaults()
{
	local inventory anItem;
	local inventory nextItem;

   // reset the image linked list
	FirstImage = None;

	if (DeusExRootWindow(rootWindow) != None)
		DeusExRootWindow(rootWindow).ResetFlags();

	// Remove all the keys from the keyring before
	// it gets destroyed
	if (KeyRing != None)
	{
		KeyRing.RemoveAllKeys();
      if ((Role == ROLE_Authority) && (Level.NetMode != NM_Standalone))
      {
         KeyRing.ClientRemoveAllKeys();
      }
		KeyRing = None;
	}

	while(Inventory != None)
	{
		anItem = Inventory;
		DeleteInventory(anItem);
		anItem.Destroy();
	}

	// Clear object belt
	if (DeusExRootWindow(rootWindow) != None)
		DeusExRootWindow(rootWindow).hud.belt.ClearBelt();

	// clear the notes and the goals
	DeleteAllNotes();
	DeleteAllGoals();

	// Nuke the history
	ResetConversationHistory();

	// Other defaults
	Credits = Default.Credits;
	Energy  = Default.Energy;
	SkillPointsTotal = Default.SkillPointsTotal;
	SkillPointsAvail = Default.SkillPointsAvail;

	SetInHandPending(None);
	SetInHand(None);

	bInHandTransition = False;

	RestoreAllHealth();
	ClearLog();

	// Reset save count/time
	saveCount = 0;
	saveTime  = 0.0;

	// Reinitialize all subsystems we've just nuked
	InitializeSubSystems();

   // Give starting inventory.
   if (Level.Netmode != NM_Standalone)
	{
		NintendoImmunityEffect( True );
      GiveInitialInventory();
	}
}

// ----------------------------------------------------------------------
// CreateKeyRing()
// ----------------------------------------------------------------------

function CreateKeyRing()
{
	if (KeyRing == None)
	{
		KeyRing = Spawn(class'NanoKeyRing', Self);
		KeyRing.InitialState='Idle2';
		KeyRing.GiveTo(Self);
		KeyRing.SetBase(Self);
	}
}

// ----------------------------------------------------------------------
// DrugEffects()
// ----------------------------------------------------------------------

simulated function DrugEffects(float deltaTime)
{
	local float mult, fov;
	local Rotator rot;
	local DeusExRootWindow root;

	root = DeusExRootWindow(rootWindow);

	// random wandering and swaying when drugged
	if (drugEffectTimer > 0)
	{
		if ((root != None) && (root.hud != None))
		{
			if (root.hud.background == None)
			{
				root.hud.SetBackground(Texture'DrunkFX');
				root.hud.SetBackgroundSmoothing(True);
				root.hud.SetBackgroundStretching(True);
				root.hud.SetBackgroundStyle(DSTY_Modulated);
			}
		}

		mult = FClamp(drugEffectTimer / 10.0, 0.0, 3.0);
		rot.Pitch = 1024.0 * Cos(Level.TimeSeconds * mult) * deltaTime * mult;
		rot.Yaw = 1024.0 * Sin(Level.TimeSeconds * mult) * deltaTime * mult;
		rot.Roll = 0;

		rot.Pitch = FClamp(rot.Pitch, -4096, 4096);
		rot.Yaw = FClamp(rot.Yaw, -4096, 4096);

		ViewRotation += rot;

		if ( Level.NetMode == NM_Standalone )
		{
			fov = Default.DesiredFOV - drugEffectTimer + Rand(2);
			fov = FClamp(fov, 30, Default.DesiredFOV);
			DesiredFOV = fov;
		}
		else
			DesiredFOV = Default.DesiredFOV;

		drugEffectTimer -= deltaTime;
		if (drugEffectTimer < 0)
			drugEffectTimer = 0;
	}
	else
	{
		if ((root != None) && (root.hud != None))
		{
			if (root.hud.background != None)
			{
				root.hud.SetBackground(None);
				root.hud.SetBackgroundStyle(DSTY_Normal);
				DesiredFOV = Default.DesiredFOV;
			}
		}
	}
}

// ----------------------------------------------------------------------
// PlayMusic()
// ----------------------------------------------------------------------

function PlayMusic(String musicToPlay, optional int sectionToPlay)
{
	local Music LoadedMusic;
	local EMusicMode newMusicMode;

	if (musicToPlay != "")
	{
		LoadedMusic = Music(DynamicLoadObject(musicToPlay $ "." $ musicToPlay, class'Music'));

		if (LoadedMusic != None)
		{
			switch(sectionToPlay)
			{
				case 0:  newMusicMode = MUS_Ambient; break;
				case 1:  newMusicMode = MUS_Combat; break;
				case 2:  newMusicMode = MUS_Conversation; break;
				case 3:  newMusicMode = MUS_Outro; break;
				case 4:  newMusicMode = MUS_Dying; break;
				default: newMusicMode = MUS_Ambient; break;
			}

			ClientSetMusic(LoadedMusic, newMusicMode, 255, MTRAN_FastFade);
		}
	}
}

// ----------------------------------------------------------------------
// PlayMusicWindow()
//
// Displays the Load Map dialog
// ----------------------------------------------------------------------

exec function PlayMusicWindow()
{
	if (!bCheatsEnabled)
		return;

	InvokeUIScreen(Class'PlayMusicWindow');
}

// ----------------------------------------------------------------------
// UpdateDynamicMusic()
//
// Pattern definitions:
//   0 - Ambient 1
//   1 - Dying
//   2 - Ambient 2 (optional)
//   3 - Combat
//   4 - Conversation
//   5 - Outro
// ----------------------------------------------------------------------

function UpdateDynamicMusic(float deltaTime)
{
	local bool bCombat;
	local ScriptedPawn npc;
   local Pawn CurPawn;
	local DeusExLevelInfo info;

	if (Level.Song == None)
		return;

   // DEUS_EX AMSD In singleplayer, do the old thing.
   // In multiplayer, we can come out of dying.
   if (!PlayerIsClient())
   {
      if ((musicMode == MUS_Dying) || (musicMode == MUS_Outro))
         return;
   }
   else
   {
      if (musicMode == MUS_Outro)
         return;
   }
      

	musicCheckTimer += deltaTime;
	musicChangeTimer += deltaTime;

	if (IsInState('Interpolating'))
	{
		// don't mess with the music on any of the intro maps
		info = GetLevelInfo();
		if ((info != None) && (info.MissionNumber < 0))
		{
			musicMode = MUS_Outro;
			return;
		}

		if (musicMode != MUS_Outro)
		{
			ClientSetMusic(Level.Song, 5, 255, MTRAN_FastFade);
			musicMode = MUS_Outro;
		}
	}
	else if (IsInState('Conversation'))
	{
		if (musicMode != MUS_Conversation)
		{
			// save our place in the ambient track
			if (musicMode == MUS_Ambient)
				savedSection = SongSection;
			else
				savedSection = 255;

			ClientSetMusic(Level.Song, 4, 255, MTRAN_Fade);
			musicMode = MUS_Conversation;
		}
	}
	else if (IsInState('Dying'))
	{
		if (musicMode != MUS_Dying)
		{
			ClientSetMusic(Level.Song, 1, 255, MTRAN_Fade);
			musicMode = MUS_Dying;
		}
	}
	else
	{
		// only check for combat music every second
		if (musicCheckTimer >= 1.0)
		{
			musicCheckTimer = 0.0;
			bCombat = False;

			// check a 100 foot radius around me for combat
         // XXXDEUS_EX AMSD Slow Pawn Iterator
         //foreach RadiusActors(class'ScriptedPawn', npc, 1600)
         for (CurPawn = Level.PawnList; CurPawn != None; CurPawn = CurPawn.NextPawn)
         {
            npc = ScriptedPawn(CurPawn);
            if ((npc != None) && (VSize(npc.Location - Location) < (1600 + npc.CollisionRadius)))
            {
               if ((npc.GetStateName() == 'Attacking') && (npc.Enemy == Self))
               {
                  bCombat = True;
                  break;
               }
            }
         }

			if (bCombat)
			{
				musicChangeTimer = 0.0;

				if (musicMode != MUS_Combat)
				{
					// save our place in the ambient track
					if (musicMode == MUS_Ambient)
						savedSection = SongSection;
					else
						savedSection = 255;

					ClientSetMusic(Level.Song, 3, 255, MTRAN_FastFade);
					musicMode = MUS_Combat;
				}
			}
			else if (musicMode != MUS_Ambient)
			{
				// wait until we've been out of combat for 5 seconds before switching music
				if (musicChangeTimer >= 5.0)
				{
					// use the default ambient section for this map
					if (savedSection == 255)
						savedSection = Level.SongSection;

					// fade slower for combat transitions
					if (musicMode == MUS_Combat)
						ClientSetMusic(Level.Song, savedSection, 255, MTRAN_SlowFade);
					else
						ClientSetMusic(Level.Song, savedSection, 255, MTRAN_Fade);

					savedSection = 255;
					musicMode = MUS_Ambient;
					musicChangeTimer = 0.0;
				}
			}
		}
	}
}

// ----------------------------------------------------------------------
// MaintainEnergy()
// ----------------------------------------------------------------------

function MaintainEnergy(float deltaTime)
{
	local Float energyUse;
   local Float energyRegen;

	// make sure we can't continue to go negative if we take damage
	// after we're already out of energy
	if (Energy <= 0)
	{
		Energy = 0;
		EnergyDrain = 0;
		EnergyDrainTotal = 0;
	}

   energyUse = 0;

	// Don't waste time doing this if the player is dead or paralyzed
	if ((!IsInState('Dying')) && (!IsInState('Paralyzed')))
   {
      if (Energy > 0)
      {
         // Decrement energy used for augmentations
         energyUse = AugmentationSystem.CalcEnergyUse(deltaTime);
         
         Energy -= EnergyUse;
         
         // Calculate the energy drain due to EMP attacks
         if (EnergyDrain > 0)
         {
            energyUse = EnergyDrainTotal * deltaTime;
            Energy -= EnergyUse;
            EnergyDrain -= EnergyUse;
            if (EnergyDrain <= 0)
            {
               EnergyDrain = 0;
               EnergyDrainTotal = 0;
            }
         }
      }

      //Do check if energy is 0.  
      // If the player's energy drops to zero, deactivate 
      // all augmentations
      if (Energy <= 0)
      {
         //If we were using energy, then tell the client we're out.
         //Otherwise just make sure things are off.  If energy was
         //already 0, then energy use will still be 0, so we won't
         //spam.  DEUS_EX AMSD
         if (energyUse > 0)         
            ClientMessage(EnergyDepleted);
         Energy = 0;
         EnergyDrain = 0;
         EnergyDrainTotal = 0;         
         AugmentationSystem.DeactivateAll();
      }

      // If all augs are off, then start regenerating in multiplayer,
      // up to 25%.
      if ((energyUse == 0) && (Energy <= MaxRegenPoint) && (Level.NetMode != NM_Standalone))
      {
         energyRegen = RegenRate * deltaTime;
         Energy += energyRegen;
      }
	}
}
// ----------------------------------------------------------------------
// RefreshSystems()
// DEUS_EX AMSD For keeping multiplayer working in better shape
// ----------------------------------------------------------------------

simulated function RefreshSystems(float DeltaTime)
{
	local DeusExRootWindow root;

   if (Level.NetMode == NM_Standalone)
      return;

   if (Role == ROLE_Authority)
      return;

   if (LastRefreshTime < 0)
      LastRefreshTime = 0;

   LastRefreshTime = LastRefreshTime + DeltaTime;

   if (LastRefreshTime < 0.25)
      return;
    
   if (AugmentationSystem != None)   
      AugmentationSystem.RefreshAugDisplay();
   
   root = DeusExRootWindow(rootWindow);
   if (root != None)    
      root.RefreshDisplay(LastRefreshTime);

   RepairInventory();

   LastRefreshTime = 0;

}

function RepairInventory()
{
   local byte				LocalInvSlots[30];		// 5x6 grid of inventory slots
   local int i;
	local int slotsCol;
	local int slotsRow;
   local Inventory curInv;

   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
      return;

   //clean out our temp inventory.
   for (i = 0; i < 30; i++)
      LocalInvSlots[i] = 0;

   // go through our inventory and fill localinvslots
   if (Inventory != None)
   {
      for (curInv = Inventory; curInv != None; curInv = curInv.Inventory)
      {
         // Make sure this item is located in a valid position
         if (( curInv.invPosX != -1 ) && ( curInv.invPosY != -1 ))
         {
            // fill inventory slots
            for( slotsRow=0; slotsRow < curInv.invSlotsY; slotsRow++ )
               for ( slotsCol=0; slotsCol < curInv.invSlotsX; slotsCol++ )
                  LocalInvSlots[((slotsRow + curInv.invPosY) * maxInvCols) + (slotscol + curInv.invPosX)] = 1;
         }
      }
   }

   // verify that the 2 inventory grids match
   for (i = 0; i < 30; i++)
      if (LocalInvSlots[i] < invSlots[i]) //don't stuff slots, that can get handled elsewhere, just clear ones that need it
      {
         log("ERROR!!! Slot "$i$" should be "$LocalInvSlots[i]$", but isn't!!!!, repairing");
         invSlots[i] = LocalInvSlots[i];
      }

}

// ----------------------------------------------------------------------
// Bleed()
// 
// Let the blood flow
// ----------------------------------------------------------------------

function Bleed(float deltaTime)
{
	local float  dropPeriod;
	local float  adjustedRate;
	local vector bloodVector;

   if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
   {
      bleedrate = 0;
      dropCounter = 0;
      return;
   }

	// Copied from ScriptedPawn::Tick()
	bleedRate = FClamp(bleedRate, 0.0, 1.0);
	if (bleedRate > 0)
	{
		adjustedRate = (1.0-bleedRate)*1.0+0.1;  // max 10 drops per second
		dropPeriod = adjustedRate / FClamp(VSize(Velocity)/512.0, 0.05, 1.0);
		dropCounter += deltaTime;
		while (dropCounter >= dropPeriod)
		{
			bloodVector = vect(0,0,1)*CollisionHeight*0.5;  // so folks don't bleed from the crotch
			spawn(Class'BloodDrop',,,bloodVector+Location);
			dropCounter -= dropPeriod;
		}
		bleedRate -= deltaTime/clotPeriod;
	}
	if (bleedRate <= 0)
	{
		dropCounter = 0;
		bleedRate   = 0;
	}
}

// ----------------------------------------------------------------------
// UpdatePoison()
// 
// Get all woozy 'n' stuff
// ----------------------------------------------------------------------

function UpdatePoison(float deltaTime)
{
	if (Health <= 0)  // no more pain -- you're already dead!
		return;

	if (InConversation())  // kinda hacky...
		return;

	if (poisonCounter > 0)
	{
		poisonTimer += deltaTime;
		if (poisonTimer >= 2.0)  // pain every two seconds
		{
			poisonTimer = 0;
			poisonCounter--;
			TakeDamage(poisonDamage, myPoisoner, Location, vect(0,0,0), 'PoisonEffect');
		}
		if ((poisonCounter <= 0) || (Health <= 0))
			StopPoison();
	}
}

// ----------------------------------------------------------------------
// StartPoison()
// 
// Gakk!  We've been poisoned!
// ----------------------------------------------------------------------

function StartPoison( Pawn poisoner, int Damage )
{
	local float augLevel;

	if ( Level.NetMode != NM_Standalone )
	{
		// Don't do poison and drug effects if in multiplayer and AugEnviro is on
		augLevel = AugmentationSystem.GetAugLevelValue(class'AugEnviro');
		if ( augLevel != -1.0 )
			return;
	}

	myPoisoner = poisoner;

	if (Health <= 0)  // no more pain -- you're already dead!
		return;

	if (InConversation())  // kinda hacky...
		return;

	poisonCounter = 4;    // take damage no more than four times (over 8 seconds)
	poisonTimer   = 0;    // reset pain timer
	if (poisonDamage < Damage)  // set damage amount
		poisonDamage = Damage;

	drugEffectTimer += 4;  // make the player vomit for the next four seconds

	// In multiplayer, don't let the effect last longer than 30 seconds
	if ( Level.NetMode != NM_Standalone )
	{
		if ( drugEffectTimer > 30 )
			drugEffectTimer = 30;
	}
}

// ----------------------------------------------------------------------
// StopPoison()
// 
// Stop the pain
// ----------------------------------------------------------------------

function StopPoison()
{
	myPoisoner = None;
	poisonCounter = 0;
	poisonTimer   = 0;
	poisonDamage  = 0;
}

// ----------------------------------------------------------------------
// SpawnEMPSparks()
// 
// Spawn sparks for items affected by Warren's EMP Field
// ----------------------------------------------------------------------

function SpawnEMPSparks(Actor empActor, Rotator rot)
{
	local ParticleGenerator sparkGen;

	if ((empActor == None) || empActor.bDeleteMe)
		return;

	sparkGen = Spawn(class'ParticleGenerator', empActor,, empActor.Location, rot);
	if (sparkGen != None)
	{
		sparkGen.SetBase(empActor);
		sparkGen.LifeSpan = 3;
		sparkGen.particleTexture = Texture'Effects.Fire.SparkFX1';
		sparkGen.particleDrawScale = 0.1;
		sparkGen.bRandomEject = True;
		sparkGen.ejectSpeed = 100.0;
		sparkGen.bGravity = True;
		sparkGen.bParticlesUnlit = True;
		sparkGen.frequency = 1.0;
		sparkGen.riseRate = 10;
		sparkGen.spawnSound = Sound'Spark2';
	}
}

// ----------------------------------------------------------------------
// UpdateWarrenEMPField()
// 
// Update Warren's EMP field
// ----------------------------------------------------------------------

function UpdateWarrenEMPField(float deltaTime)
{
	local float          empRadius;
	local Robot          curRobot;
	local AlarmUnit      curAlarm;
	local AutoTurret     curTurret;
	local LaserTrigger   curLaser;
	local BeamTrigger    curBeam;
	local SecurityCamera curCamera;
	local int            option;

	if (bWarrenEMPField)
	{
		WarrenTimer -= deltaTime;
		if (WarrenTimer <= 0)
		{
			WarrenTimer = 0.15;

			empRadius = 600;
			if (WarrenSlot == 0)
			{
				foreach RadiusActors(Class'Robot', curRobot, empRadius)
				{
					if ((curRobot.LastRendered() < 2.0) && (curRobot.CrazedTimer <= 0) &&
					    (curRobot.EMPHitPoints > 0))
					{
						if (curRobot.GetPawnAllianceType(self) == ALLIANCE_Hostile)
							option = Rand(2);
						else
							option = 0;
						if (option == 0)
							curRobot.TakeDamage(curRobot.EMPHitPoints*2, self, curRobot.Location, vect(0,0,0), 'EMP');
						else
							curRobot.TakeDamage(100, self, curRobot.Location, vect(0,0,0), 'NanoVirus');
						SpawnEMPSparks(curRobot, Rotator(Location-curRobot.Location));
					}
				}
			}
			else if (WarrenSlot == 1)
			{
				foreach RadiusActors(Class'AlarmUnit', curAlarm, empRadius)
				{
					if ((curAlarm.LastRendered() < 2.0) && !curAlarm.bConfused)
					{
						curAlarm.TakeDamage(100, self, curAlarm.Location, vect(0,0,0), 'EMP');
						SpawnEMPSparks(curAlarm, curAlarm.Rotation);
					}
				}
			}
			else if (WarrenSlot == 2)
			{
				foreach RadiusActors(Class'AutoTurret', curTurret, empRadius)
				{
					if ((curTurret.LastRendered() < 2.0) && !curTurret.bConfused)
					{
						curTurret.TakeDamage(100, self, curTurret.Location, vect(0,0,0), 'EMP');
						SpawnEMPSparks(curTurret, Rotator(Location-curTurret.Location));
					}
				}
			}
			else if (WarrenSlot == 3)
			{
				foreach RadiusActors(Class'LaserTrigger', curLaser, empRadius)
				{
					if ((curLaser.LastRendered() < 2.0) && !curLaser.bConfused)
					{
						curLaser.TakeDamage(100, self, curLaser.Location, vect(0,0,0), 'EMP');
						SpawnEMPSparks(curLaser, curLaser.Rotation);
					}
				}
			}
			else if (WarrenSlot == 4)
			{
				foreach RadiusActors(Class'BeamTrigger', curBeam, empRadius)
				{
					if ((curBeam.LastRendered() < 2.0) && !curBeam.bConfused)
					{
						curBeam.TakeDamage(100, self, curBeam.Location, vect(0,0,0), 'EMP');
						SpawnEMPSparks(curBeam, curBeam.Rotation);
					}
				}
			}
			else if (WarrenSlot == 5)
			{
				foreach RadiusActors(Class'SecurityCamera', curCamera, empRadius)
				{
					if ((curCamera.LastRendered() < 2.0) && !curCamera.bConfused)
					{
						curCamera.TakeDamage(100, self, curCamera.Location, vect(0,0,0), 'EMP');
						SpawnEMPSparks(curCamera, Rotator(Location-curCamera.Location));
					}
				}
			}

			WarrenSlot++;
			if (WarrenSlot >= 6)
				WarrenSlot = 0;
		}
	}
}


// ----------------------------------------------------------------------
// UpdateTranslucency()
// DEUS_EX AMSD Try to make the player harder to see if he is in darkness.
// ----------------------------------------------------------------------

function UpdateTranslucency(float DeltaTime)
{
   local float DarkVis;
   local float CamoVis;
	local AdaptiveArmor armor;
   local bool bMakeTranslucent;
   local DeusExMPGame Game;
   
   // Don't do it in multiplayer.
   if (Level.NetMode == NM_Standalone)
      return;

   Game = DeusExMPGame(Level.Game);
   if (Game == None)
   {
      return;
   }

   bMakeTranslucent = false;

   //DarkVis = AIVisibility(TRUE);
   DarkVis = 1.0;

   CamoVis = 1.0;

   //Check cloaking.
	if (AugmentationSystem.GetAugLevelValue(class'AugCloak') != -1.0)
   {
      bMakeTranslucent = TRUE;
      CamoVis = Game.CloakEffect;
   }

   // If you have a weapon out, scale up the camo and turn off the cloak.
   // Adaptive armor leaves you completely invisible, but drains quickly.
   if ((inHand != None) && (inHand.IsA('DeusExWeapon')) && (CamoVis < 1.0))
   {
      CamoVis = 1.0;
      bMakeTranslucent=FALSE;
      ClientMessage(WeaponUnCloak);
      AugmentationSystem.FindAugmentation(class'AugCloak').Deactivate();
   }
   
   // go through the actor list looking for owned AdaptiveArmor
   // since they aren't in the inventory anymore after they are used
   if (UsingChargedPickup(class'AdaptiveArmor'))
      {
         CamoVis = CamoVis * Game.CloakEffect;
         bMakeTranslucent = TRUE;
      }

   ScaleGlow = Default.ScaleGlow * CamoVis * DarkVis;

   //Translucent is < 0.1, untranslucent if > 0.2, not same edge to prevent sharp breaks.
   if (bMakeTranslucent)
   {
      Style = STY_Translucent;
      if (Self.IsA('JCDentonMale'))
      {
         MultiSkins[6] = Texture'BlackMaskTex';
         MultiSkins[7] = Texture'BlackMaskTex';
      }
   }
   else if (Game.bDarkHiding)
   {
      if (CamoVis * DarkVis < Game.StartHiding)
         Style = STY_Translucent;
      if (CamoVis * DarkVis > Game.EndHiding)
         Style = Default.Style;
   }
   else if (!bMakeTranslucent)
   {
      if (Self.IsA('JCDentonMale'))
      {
         MultiSkins[6] = Default.MultiSkins[6];
         MultiSkins[7] = Default.MultiSkins[7];
      }
      Style = Default.Style;
   }
}

// ----------------------------------------------------------------------
// RestoreSkillPoints()
// 
// Restore skill point variables
// ----------------------------------------------------------------------

function RestoreSkillPoints()
{
	local name flagName;

	bSavingSkillsAugs = False;

	// Get the skill points available
	flagName = rootWindow.StringToName("SKTemp_SkillPointsAvail");
	if (flagBase.CheckFlag(flagName, FLAG_Int))
	{
		SkillPointsAvail = flagBase.GetInt(flagName);
		flagBase.DeleteFlag(flagName, FLAG_Int);
	}

	// Get the skill points total
	flagName = rootWindow.StringToName("SKTemp_SkillPointsTotal");
	if (flagBase.CheckFlag(flagName, FLAG_Int))
	{
		SkillPointsTotal = flagBase.GetInt(flagName);
		flagBase.DeleteFlag(flagName, FLAG_Int);
	}
}

// ----------------------------------------------------------------------
// SaveSkillPoints()
// 
// Saves out skill points, used when starting a new game
// ----------------------------------------------------------------------

function SaveSkillPoints()
{
	local name flagName;

	// Save/Restore must be done as atomic unit
	if (bSavingSkillsAugs)
		return;

	bSavingSkillsAugs = True;

	// Save the skill points available
	flagName = rootWindow.StringToName("SKTemp_SkillPointsAvail");
	flagBase.SetInt(flagName, SkillPointsAvail);

	// Save the skill points available
	flagName = rootWindow.StringToName("SKTemp_SkillPointsTotal");
	flagBase.SetInt(flagName, SkillPointsTotal);
}

// ----------------------------------------------------------------------
// AugAdd()
//
// Augmentation system functions
// exec functions for command line for demo
// ----------------------------------------------------------------------

exec function AugAdd(class<Augmentation> aWantedAug)
{
	local Augmentation anAug;

	if (!bCheatsEnabled)
		return;

	if (AugmentationSystem != None)
	{
		anAug = AugmentationSystem.GivePlayerAugmentation(aWantedAug);

		if (anAug == None)
			ClientMessage(GetItemName(String(aWantedAug)) $ " is not a valid augmentation!");
	}
}

// ----------------------------------------------------------------------
// ActivateAugmentation()
// ----------------------------------------------------------------------

exec function ActivateAugmentation(int num)
{
	local Augmentation anAug;
	local int count, wantedSlot, slotIndex;
	local bool bFound;

	if (RestrictInput())
		return;

	if (Energy == 0)
	{
		ClientMessage(EnergyDepleted);
		PlaySound(AugmentationSystem.FirstAug.DeactivateSound, SLOT_None);
		return;
	}

	if (AugmentationSystem != None)
		AugmentationSystem.ActivateAugByKey(num);
}

// ----------------------------------------------------------------------
// ActivateAllAugs()
// ----------------------------------------------------------------------

exec function ActivateAllAugs()
{
	if (AugmentationSystem != None)
		AugmentationSystem.ActivateAll();
}

// ----------------------------------------------------------------------
// DeactivateAllAugs()
// ----------------------------------------------------------------------

exec function DeactivateAllAugs()
{
	if (AugmentationSystem != None)
		AugmentationSystem.DeactivateAll();
}

// ----------------------------------------------------------------------
// SwitchAmmo()
// ----------------------------------------------------------------------

exec function SwitchAmmo()
{
	if (inHand.IsA('DeusExWeapon'))
		DeusExWeapon(inHand).CycleAmmo();	
}

// ----------------------------------------------------------------------
// RemoveInventoryType()
// ----------------------------------------------------------------------

function RemoveInventoryType(Class<Inventory> removeType)
{
	local Inventory item;

	item = FindInventoryType(removeType);

	if (item != None)
		DeleteInventory(item);
}

// ----------------------------------------------------------------------
// AddAugmentationDisplay()
// ----------------------------------------------------------------------

function AddAugmentationDisplay(Augmentation aug)
{
   //DEUS_EX AMSD Added none check here.
	if ((rootWindow != None) && (aug != None))
		DeusExRootWindow(rootWindow).hud.activeItems.AddIcon(aug.SmallIcon, aug);
}

// ----------------------------------------------------------------------
// RemoveAugmentationDisplay()
// ----------------------------------------------------------------------

function RemoveAugmentationDisplay(Augmentation aug)
{
	DeusExRootWindow(rootWindow).hud.activeItems.RemoveIcon(aug);
}

// ----------------------------------------------------------------------
// ClearAugmentationDisplay()
// ----------------------------------------------------------------------

function ClearAugmentationDisplay()
{
	DeusExRootWindow(rootWindow).hud.activeItems.ClearAugmentationDisplay();
}

// ----------------------------------------------------------------------
// UpdateAugmentationDisplayStatus()
// ----------------------------------------------------------------------

function UpdateAugmentationDisplayStatus(Augmentation aug)
{
	DeusExRootWindow(rootWindow).hud.activeItems.UpdateAugIconStatus(aug);
}

// ----------------------------------------------------------------------
// AddChargedDisplay()
// ----------------------------------------------------------------------

function AddChargedDisplay(ChargedPickup item)
{
   if ( (PlayerIsClient()) || (Level.NetMode == NM_Standalone) )	
      DeusExRootWindow(rootWindow).hud.activeItems.AddIcon(item.ChargedIcon, item);
}

// ----------------------------------------------------------------------
// RemoveChargedDisplay()
// ----------------------------------------------------------------------

function RemoveChargedDisplay(ChargedPickup item)
{
   if ( (PlayerIsClient()) || (Level.NetMode == NM_Standalone) )	
      DeusExRootWindow(rootWindow).hud.activeItems.RemoveIcon(item);
}

// ----------------------------------------------------------------------
// ActivateKeypadWindow()
// DEUS_EX AMSD Has to be here because player doesn't own keypad, so
// func rep doesn't work right.
// ----------------------------------------------------------------------
function ActivateKeypadWindow(Keypad KPad, bool bHacked)
{
   KPad.ActivateKeypadWindow(Self, bHacked);
}

function KeypadRunUntriggers(Keypad KPad)
{
   KPad.RunUntriggers(Self);
}

function KeypadRunEvents(Keypad KPad, bool bSuccess)
{
   KPad.RunEvents(Self, bSuccess);
}

function KeypadToggleLocks(Keypad KPad)
{
   KPad.ToggleLocks(Self);
}

// ----------------------------------------------------------------------
// Multiplayer computer functions
// ----------------------------------------------------------------------

//server->client (computer to frobber)
function InvokeComputerScreen(Computers computerToActivate, float CompHackTime, float ServerLevelTime)
{
   local NetworkTerminal termwindow;
   local DeusExRootWindow root;

   computerToActivate.LastHackTime = CompHackTime + (Level.TimeSeconds - ServerLevelTime);

   ActiveComputer = ComputerToActivate;

   //only allow for clients or standalone
   if ((Level.NetMode != NM_Standalone) && (!PlayerIsClient()))
   {
      ActiveComputer = None;
      CloseComputerScreen(computerToActivate);
      return;
   }

   root = DeusExRootWindow(rootWindow);
   if (root != None)
   {
      termwindow = NetworkTerminal(root.InvokeUIScreen(computerToActivate.terminalType, True));
      if (termwindow != None)
      {
			computerToActivate.termwindow = termwindow;
         termWindow.SetCompOwner(computerToActivate);
         // If multiplayer, start hacking if there are no users
         if ((Level.NetMode != NM_Standalone) && (!termWindow.bHacked) && (computerToActivate.NumUsers() == 0) && 
             (termWindow.winHack != None) && (termWindow.winHack.btnHack != None))
         {
            termWindow.winHack.StartHack();
            termWindow.winHack.btnHack.SetSensitivity(False);
            termWindow.FirstScreen=None;
         }
         termWindow.ShowFirstScreen();
      }
   }
   if ((termWindow == None)  || (root == None))
   {
      CloseComputerScreen(computerToActivate);
      ActiveComputer = None;
   }
}


// CloseThisComputer is for the client (used at the end of a mp match)

function CloseThisComputer( Computers comp )
{
	if ((comp != None) && ( comp.termwindow != None ))
		comp.termwindow.CloseScreen("EXIT");
}

//client->server (window to player)
function CloseComputerScreen(Computers computerToClose)
{
   computerToClose.CloseOut();
}

//client->server (window to player)
function SetComputerHackTime(Computers computerToSet, float HackTime, float ClientLevelTime)
{
   computerToSet.lastHackTime = HackTime + (Level.TimeSeconds - ClientLevelTime);
}

//client->server (window to player)
function UpdateCameraRotation(SecurityCamera camera, Rotator rot)
{
	camera.DesiredRotation = rot;
}

//client->server (window to player)
function ToggleCameraState(SecurityCamera cam, ElectronicDevices compOwner)
{
   if (cam.bActive)
   {
      cam.UnTrigger(compOwner, self);	
      cam.team = -1;
   }
   else            
   {
      MakeCameraAlly(cam);
      cam.Trigger(compOwner, self);
   }
         
   // Make sure the camera isn't in bStasis=True
   // so it responds to our every whim.
   cam.bStasis = False;         
}

//client->server (window to player)
function SetTurretState(AutoTurret turret, bool bActive, bool bDisabled)
{
   turret.bActive   = bActive;
   turret.bDisabled = bDisabled;
	turret.bComputerReset = False;
}

//client->server (window to player)
function SetTurretTrackMode(ComputerSecurity computer, AutoTurret turret, bool bTrackPlayers, bool bTrackPawns)
{
	local String str;

   turret.bTrackPlayersOnly = bTrackPlayers;
   turret.bTrackPawnsOnly   = bTrackPawns;
	turret.bComputerReset = False;

   //in multiplayer, behave differently
   //set the safe target to ourself.
   if (Level.NetMode != NM_Standalone)
   {
      //we abuse the names of the booleans here.
		turret.SetSafeTarget( Self );

		if (Role == ROLE_Authority)
		{
			if ( TeamDMGame(DXGame) != None )
			{
				computer.team = PlayerReplicationInfo.team;
				turret.team = PlayerReplicationInfo.Team;
				if ( !turret.bDisabled )
				{
					str = TakenOverString $ turret.titleString $ ".";
					TeamSay( str );
				}
			}
			else
			{
				computer.team = PlayerReplicationInfo.PlayerID;
				turret.team = PlayerReplicationInfo.PlayerID;
			}
		}
   }
}

//client->server (window to player)
function MakeCameraAlly(SecurityCamera camera)
{
   Camera.SafeTarget = Self;
   if (Level.Game.IsA('TeamDMGame'))   
      Camera.Team = PlayerReplicationInfo.Team;
   else
      Camera.Team = PlayerReplicationInfo.PlayerID;
}

//client->server (window to player)
function PunishDetection(int DamageAmount)
{
   if (DamageAmount > 0)
      TakeDamage(DamageAmount, None, vect(0,0,0), vect(0,0,0), 'EMP');	
}

// ----------------------------------------------------------------------
// AddDamageDisplay()
//
// Turn on the correct damage type icon on the HUD
// Note that these icons naturally fade out after a few seconds,
// so there is no need to turn them off
// ----------------------------------------------------------------------

function AddDamageDisplay(name damageType, vector hitOffset)
{
	DeusExRootWindow(rootWindow).hud.damageDisplay.AddIcon(damageType, hitOffset);
}

// ----------------------------------------------------------------------
// SetDamagePercent()
//
// Set the percentage amount of damage that's being absorbed
// ----------------------------------------------------------------------

function SetDamagePercent(float percent)
{
	DeusExRootWindow(rootWindow).hud.damageDisplay.SetPercent(percent);
}

// ----------------------------------------------------------------------
// default sound functions
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// PlayBodyThud()
//
// this is called by MESH NOTIFY
// ----------------------------------------------------------------------

function PlayBodyThud()													
{
	PlaySound(sound'BodyThud', SLOT_Interact);
}

// ----------------------------------------------------------------------
// GetWallMaterial()
//
// gets the name of the texture group that we are facing
// ----------------------------------------------------------------------

function name GetWallMaterial(out vector wallNormal)
{
	local vector EndTrace, HitLocation, HitNormal;
	local actor target;
	local int texFlags, grabDist;
	local name texName, texGroup;

	// if we are falling, then increase our grabbing distance
	if (Physics == PHYS_Falling)
		grabDist = 3.0;
	else
		grabDist = 1.5;

	// trace out in front of us
	EndTrace = Location + (Vector(Rotation) * CollisionRadius * grabDist);

 	foreach TraceTexture(class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, EndTrace)
	{
		if ((target == Level) || target.IsA('Mover'))
			break;
	}

	wallNormal = HitNormal;

	return texGroup;
}

// ----------------------------------------------------------------------
// GetFloorMaterial()
//
// gets the name of the texture group that we are standing on
// ----------------------------------------------------------------------

function name GetFloorMaterial()
{
	local vector EndTrace, HitLocation, HitNormal;
	local actor target;
	local int texFlags;
	local name texName, texGroup;

	// trace down to our feet
	EndTrace = Location - CollisionHeight * 2 * vect(0,0,1);

	foreach TraceTexture(class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, EndTrace)
	{
		if ((target == Level) || target.IsA('Mover'))
			break;
	}

	return texGroup;
}

// ----------------------------------------------------------------------
// PlayFootStep()
//
// plays footstep sounds based on the texture group
// yes, I know this looks nasty -- I'll have to figure out a cleaner 
// way to do this
// ----------------------------------------------------------------------

simulated function PlayFootStep()
{
	local Sound stepSound;
	local float rnd;
	local float speedFactor, massFactor;
	local float volume, pitch, range;
	local float radius, mult;
	local float volumeMultiplier;
	local DeusExPlayer pp;
	local bool bOtherPlayer;

	// Only do this on ourself, since this takes into account aug stealth and such
	if ( Level.NetMode != NM_StandAlone )
		pp = DeusExPlayer( GetPlayerPawn() );

	if ( pp != Self )
		bOtherPlayer = True;
	else
		bOtherPlayer = False;

	rnd = FRand();

	volumeMultiplier = 1.0;
	if (IsInState('PlayerSwimming') || (Physics == PHYS_Swimming))
	{
		volumeMultiplier = 0.5;
		if (rnd < 0.5)
			stepSound = Sound'Swimming';
		else
			stepSound = Sound'Treading';
	}
	else if (FootRegion.Zone.bWaterZone)
	{
		volumeMultiplier = 1.0;
		if (rnd < 0.33)
			stepSound = Sound'WaterStep1';
		else if (rnd < 0.66)
			stepSound = Sound'WaterStep2';
		else
			stepSound = Sound'WaterStep3';
	}
	else
	{
		switch(FloorMaterial)
		{
			case 'Textile':
			case 'Paper':
				volumeMultiplier = 0.7;
				if (rnd < 0.25)
					stepSound = Sound'CarpetStep1';
				else if (rnd < 0.5)
					stepSound = Sound'CarpetStep2';
				else if (rnd < 0.75)
					stepSound = Sound'CarpetStep3';
				else
					stepSound = Sound'CarpetStep4';
				break;

			case 'Foliage':
			case 'Earth':
				volumeMultiplier = 0.6;
				if (rnd < 0.25)
					stepSound = Sound'GrassStep1';
				else if (rnd < 0.5)
					stepSound = Sound'GrassStep2';
				else if (rnd < 0.75)
					stepSound = Sound'GrassStep3';
				else
					stepSound = Sound'GrassStep4';
				break;

			case 'Metal':
			case 'Ladder':
				volumeMultiplier = 1.0;
				if (rnd < 0.25)
					stepSound = Sound'MetalStep1';
				else if (rnd < 0.5)
					stepSound = Sound'MetalStep2';
				else if (rnd < 0.75)
					stepSound = Sound'MetalStep3';
				else
					stepSound = Sound'MetalStep4';
				break;

			case 'Ceramic':
			case 'Glass':
			case 'Tiles':
				volumeMultiplier = 0.7;
				if (rnd < 0.25)
					stepSound = Sound'TileStep1';
				else if (rnd < 0.5)
					stepSound = Sound'TileStep2';
				else if (rnd < 0.75)
					stepSound = Sound'TileStep3';
				else
					stepSound = Sound'TileStep4';
				break;

			case 'Wood':
				volumeMultiplier = 0.7;
				if (rnd < 0.25)
					stepSound = Sound'WoodStep1';
				else if (rnd < 0.5)
					stepSound = Sound'WoodStep2';
				else if (rnd < 0.75)
					stepSound = Sound'WoodStep3';
				else
					stepSound = Sound'WoodStep4';
				break;

			case 'Brick':
			case 'Concrete':
			case 'Stone':
			case 'Stucco':
			default:
				volumeMultiplier = 0.7;
				if (rnd < 0.25)
					stepSound = Sound'StoneStep1';
				else if (rnd < 0.5)
					stepSound = Sound'StoneStep2';
				else if (rnd < 0.75)
					stepSound = Sound'StoneStep3';
				else
					stepSound = Sound'StoneStep4';
				break;
		}
	}

	// compute sound volume, range and pitch, based on mass and speed
	if (IsInState('PlayerSwimming') || (Physics == PHYS_Swimming))
		speedFactor = WaterSpeed/180.0;
	else
		speedFactor = VSize(Velocity)/180.0;

	massFactor  = Mass/150.0;
	radius      = 375.0;
	volume      = (speedFactor+0.2) * massFactor;
	range       = radius * volume;
	pitch       = (volume+0.5);
	volume      = FClamp(volume, 0, 1.0) * 0.5;		// Hack to compensate for increased footstep volume.											
	range       = FClamp(range, 0.01, radius*4);
	pitch       = FClamp(pitch, 1.0, 1.5);

	// AugStealth decreases our footstep volume
	volume *= RunSilentValue;

	if ( Level.NetMode == NM_Standalone )
		PlaySound(stepSound, SLOT_Interact, volume, , range, pitch);
	else	// special case for multiplayer
	{
		if ( !bIsWalking )
		{
			// Tone down player's own footsteps
			if ( !bOtherPlayer )
			{
				volume *= 0.33;
				PlaySound(stepSound, SLOT_Interact, volume, , range, pitch);
			}
			else // Exagerate other players sounds (range slightly greater than distance you see with vision aug)
			{
				volume *= 2.0;
				range = (class'AugVision'.Default.mpAugValue * 1.2);
				volume = FClamp(volume, 0, 1.0);
				PlaySound(stepSound, SLOT_Interact, volume, , range, pitch);
			}
		}
	}
	AISendEvent('LoudNoise', EAITYPE_Audio, volume*volumeMultiplier, range*volumeMultiplier);
}

// ----------------------------------------------------------------------
// IsHighlighted()
//
// checks to see if we should highlight this actor
// ----------------------------------------------------------------------

function bool IsHighlighted(actor A)
{
	if (bBehindView)
		return False;

	if (A != None)
	{
		if (A.bDeleteMe || A.bHidden)
			return False;

		if (A.IsA('Pawn'))
		{
			if (!bNPCHighlighting)
				return False;
		}

		if (A.IsA('DeusExMover') && !DeusExMover(A).bHighlight)
			return False;
		else if (A.IsA('Mover') && !A.IsA('DeusExMover'))
			return False;
		else if (A.IsA('DeusExDecoration') && !DeusExDecoration(A).bHighlight)
			return False;
		else if (A.IsA('DeusExCarcass') && !DeusExCarcass(A).bHighlight)
			return False;
		else if (A.IsA('ThrownProjectile') && !ThrownProjectile(A).bHighlight)
			return False;
		else if (A.IsA('DeusExProjectile') && !DeusExProjectile(A).bStuck)
			return False;
		else if (A.IsA('ScriptedPawn') && !ScriptedPawn(A).bHighlight)
			return False;
	}

	return True;
}

// ----------------------------------------------------------------------
// IsFrobbable()
//
// is this actor frobbable?
// ----------------------------------------------------------------------

function bool IsFrobbable(actor A)
{
	if (!A.bHidden)
		if (A.IsA('Mover') || A.IsA('DeusExDecoration') || A.IsA('Inventory') ||
			A.IsA('ScriptedPawn') || A.IsA('DeusExCarcass') || A.IsA('DeusExProjectile'))
			return True;

	return False;
}

// ----------------------------------------------------------------------
// HighlightCenterObject()
//
// checks to see if an object can be frobbed, if so, then highlight it
// ----------------------------------------------------------------------

function HighlightCenterObject()
{
	local Actor target, smallestTarget;
	local Vector HitLoc, HitNormal, StartTrace, EndTrace;
	local DeusExRootWindow root;
	local float minSize;
	local bool bFirstTarget;

	if (IsInState('Dying'))
		return;

	root = DeusExRootWindow(rootWindow);

	// only do the trace every tenth of a second
	if (FrobTime >= 0.1)
	{
		// figure out how far ahead we should trace
		StartTrace = Location;
		EndTrace = Location + (Vector(ViewRotation) * MaxFrobDistance);

		// adjust for the eye height
		StartTrace.Z += BaseEyeHeight;
		EndTrace.Z += BaseEyeHeight;

		smallestTarget = None;
		minSize = 99999;
		bFirstTarget = True;

		// find the object that we are looking at
		// make sure we don't select the object that we're carrying
		// use the last traced object as the target...this will handle
		// smaller items under larger items for example
		// ScriptedPawns always have precedence, though
		foreach TraceActors(class'Actor', target, HitLoc, HitNormal, EndTrace, StartTrace)
		{
			if (IsFrobbable(target) && (target != CarriedDecoration))
			{
				if (target.IsA('ScriptedPawn'))
				{
					smallestTarget = target;
					break;
				}
				else if (target.IsA('Mover') && bFirstTarget)
				{
					smallestTarget = target;
					break;
				}
				else if (target.CollisionRadius < minSize)
				{
					minSize = target.CollisionRadius;
					smallestTarget = target;
					bFirstTarget = False;
				}
			}
		}
		FrobTarget = smallestTarget;

		// reset our frob timer
		FrobTime = 0;
	}
}

// ----------------------------------------------------------------------
// Landed()
//
// copied from Engine.PlayerPawn new landing code for Deus Ex
// zero damage if falling from 15 feet or less
// scaled damage from 15 to 60 feet
// death over 60 feet
// ----------------------------------------------------------------------

function Landed(vector HitNormal)
{
    local vector legLocation;
	local int augLevel;
	local float augReduce, dmg;

	//Note - physics changes type to PHYS_Walking by default for landed pawns
	PlayLanded(Velocity.Z);
	if (Velocity.Z < -1.4 * JumpZ)
	{
		MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));
		if ((Velocity.Z < -700) && (ReducedDamageType != 'All'))
			if ( Role == ROLE_Authority )
            {
				// check our jump augmentation and reduce falling damage if we have it
				// jump augmentation doesn't exist anymore - use Speed instaed
				// reduce an absolute amount of damage instead of a relative amount
				augReduce = 0;
				if (AugmentationSystem != None)
				{
					augLevel = AugmentationSystem.GetClassLevel(class'AugSpeed');
					if (augLevel >= 0)
						augReduce = 15 * (augLevel+1);
				}

				dmg = Max((-0.16 * (Velocity.Z + 700)) - augReduce, 0);
				legLocation = Location + vect(-1,0,-1);			// damage left leg
				TakeDamage(dmg, None, legLocation, vect(0,0,0), 'fell');

				legLocation = Location + vect(1,0,-1);			// damage right leg
				TakeDamage(dmg, None, legLocation, vect(0,0,0), 'fell');

				dmg = Max((-0.06 * (Velocity.Z + 700)) - augReduce, 0);
				legLocation = Location + vect(0,0,1);			// damage torso
				TakeDamage(dmg, None, legLocation, vect(0,0,0), 'fell');
            }
	}
	else if ( (Level.Game != None) && (Level.Game.Difficulty > 1) && (Velocity.Z > 0.5 * JumpZ) )
		MakeNoise(0.1 * Level.Game.Difficulty);				
	bJustLanded = true;
}

// ----------------------------------------------------------------------
// SupportActor()
//
// Copied directly from ScriptedPawn.uc
// Called when something lands on us
// ----------------------------------------------------------------------

function SupportActor(Actor standingActor)
{
	local vector newVelocity;
	local float  angle;
	local float  zVelocity;
	local float  baseMass;
	local float  standingMass;
	local vector damagePoint;
	local float  damage;

	zVelocity    = standingActor.Velocity.Z;
	standingMass = FMax(1, standingActor.Mass);
	baseMass     = FMax(1, Mass);
	damagePoint  = Location + vect(0,0,1)*(CollisionHeight-1);
	damage       = (1 - (standingMass/baseMass) * (zVelocity/100));

	// Have we been stomped?
	if ((zVelocity*standingMass < -7500) && (damage > 0))
		TakeDamage(damage, standingActor.Instigator, damagePoint, 0.2*standingActor.Velocity, 'stomped');

	// Bounce the actor off the player
	angle = FRand()*Pi*2;
	newVelocity.X = cos(angle);
	newVelocity.Y = sin(angle);
	newVelocity.Z = 0;
	newVelocity *= FRand()*25 + 25;
	newVelocity += standingActor.Velocity;
	newVelocity.Z = 50;
	standingActor.Velocity = newVelocity;
	standingActor.SetPhysics(PHYS_Falling);
}

// ----------------------------------------------------------------------
// SpawnCarcass()
//
// copied from Engine.PlayerPawn
// modified to let carcasses have inventories
// ----------------------------------------------------------------------

function Carcass SpawnCarcass()
{
	local DeusExCarcass carc;
	local Inventory item;
	local Vector loc;

	// don't spawn a carcass if we've been gibbed
	if (Health < -80)
      return None;

	carc = DeusExCarcass(Spawn(CarcassType));
	if (carc != None)
	{
		carc.Initfor(self);

		// move it down to the ground
		loc = Location;
		loc.z -= CollisionHeight;
		loc.z += carc.CollisionHeight;
		carc.SetLocation(loc);

		if (Player != None)
			carc.bPlayerCarcass = true;
		MoveTarget = carc; //for Player 3rd person views

		// give the carcass the player's inventory
		for (item=Inventory; item!=None; item=Inventory)
		{
			DeleteInventory(item);
			carc.AddInventory(item);
		}
	}

	return carc;
}

// ----------------------------------------------------------------------
// Reloading()
//
// Called when one of the player's weapons is reloading
// ----------------------------------------------------------------------

function Reloading(DeusExWeapon weapon, float reloadTime)
{
	if (!IsLeaning() && !bIsCrouching && (Physics != PHYS_Swimming) && !IsInState('Dying'))
		PlayAnim('Reload', 1.0 / reloadTime, 0.1);
}
function DoneReloading(DeusExWeapon weapon);

// ----------------------------------------------------------------------
// HealPlayer()
// ----------------------------------------------------------------------

function int HealPlayer(int baseHealPoints, optional Bool bUseMedicineSkill)
{
	local float mult;
	local int adjustedHealAmount, aha2, tempaha;
	local int origHealAmount;
	local float dividedHealAmount;

	if (bUseMedicineSkill)
		adjustedHealAmount = CalculateSkillHealAmount(baseHealPoints);
	else
		adjustedHealAmount = baseHealPoints;

	origHealAmount = adjustedHealAmount;

	if (adjustedHealAmount > 0)
	{
		if (bUseMedicineSkill)
			PlaySound(sound'MedicalHiss', SLOT_None,,, 256);

		// Heal by 3 regions via multiplayer game
		if (( Level.NetMode == NM_DedicatedServer ) || ( Level.NetMode == NM_ListenServer ))
		{
         // DEUS_EX AMSD If legs broken, heal them a little bit first
         if (HealthLegLeft == 0)
         {
            aha2 = adjustedHealAmount;
            if (aha2 >= 5)
               aha2 = 5;
            tempaha = aha2;
            adjustedHealAmount = adjustedHealAmount - aha2;
            HealPart(HealthLegLeft, aha2);
            HealPart(HealthLegRight,tempaha);
				mpMsgServerFlags = mpMsgServerFlags & (~MPSERVERFLAG_LostLegs);
         }
			HealPart(HealthHead, adjustedHealAmount);

			if ( adjustedHealAmount > 0 )
			{
				aha2 = adjustedHealAmount;
				HealPart(HealthTorso, aha2);
				aha2 = adjustedHealAmount;
				HealPart(HealthArmRight,aha2);
				HealPart(HealthArmLeft, adjustedHealAmount);
			}
			if ( adjustedHealAmount > 0 )
			{
				aha2 = adjustedHealAmount;
				HealPart(HealthLegRight, aha2);
				HealPart(HealthLegLeft, adjustedHealAmount);
			}
		}
		else
		{
			HealPart(HealthHead, adjustedHealAmount);
			HealPart(HealthTorso, adjustedHealAmount);
			HealPart(HealthLegRight, adjustedHealAmount);
			HealPart(HealthLegLeft, adjustedHealAmount);
			HealPart(HealthArmRight, adjustedHealAmount);
			HealPart(HealthArmLeft, adjustedHealAmount);
		}

		GenerateTotalHealth();

		adjustedHealAmount = origHealAmount - adjustedHealAmount;

		if (origHealAmount == baseHealPoints)
		{
			if (adjustedHealAmount == 1)
				ClientMessage(Sprintf(HealedPointLabel, adjustedHealAmount));
			else
				ClientMessage(Sprintf(HealedPointsLabel, adjustedHealAmount));
		}
		else
		{
			ClientMessage(Sprintf(HealedPointsLabel, adjustedHealAmount));
		}
	}

	return adjustedHealAmount;
}

// ----------------------------------------------------------------------
// ChargePlayer()
// ----------------------------------------------------------------------

function int ChargePlayer(int baseChargePoints)
{
	local int chargedPoints;

	chargedPoints = Min(EnergyMax - Int(Energy), baseChargePoints);

	Energy += chargedPoints;

	return chargedPoints;	
}

// ----------------------------------------------------------------------
// CalculateSkillHealAmount()
// ----------------------------------------------------------------------

function int CalculateSkillHealAmount(int baseHealPoints)
{
	local float mult;
	local int adjustedHealAmount;

	// check skill use
	if (SkillSystem != None)
	{
		mult = SkillSystem.GetSkillLevelValue(class'SkillMedicine');

		// apply the skill
		adjustedHealAmount = baseHealPoints * mult;
	}

	return adjustedHealAmount;
}

// ----------------------------------------------------------------------
// HealPart()
// ----------------------------------------------------------------------

function HealPart(out int points, out int amt)
{
	local int spill;

	points += amt;
	spill = points - 100;
	if (spill > 0)
		points = 100;
	else
		spill = 0;

	amt = spill;
}

// ----------------------------------------------------------------------
// HandleWalking()
//
// subclassed from PlayerPawn so we can control run/walk defaults
// ----------------------------------------------------------------------

function HandleWalking()
{
	Super.HandleWalking();

	if (bAlwaysRun)
		bIsWalking = (bRun != 0) || (bDuck != 0); 
	else
		bIsWalking = (bRun == 0) || (bDuck != 0); 

	// handle the toggle walk key
	if (bToggleWalk)
		bIsWalking = !bIsWalking;

	if (bToggleCrouch)
	{
		if (!bCrouchOn && !bWasCrouchOn && (bDuck != 0))
		{
			bCrouchOn = True;
		}
		else if (bCrouchOn && !bWasCrouchOn && (bDuck == 0))
		{
			bWasCrouchOn = True;
		}
		else if (bCrouchOn && bWasCrouchOn && (bDuck == 0) && (lastbDuck != 0))
		{
			bCrouchOn = False;
			bWasCrouchOn = False;
		}

		if (bCrouchOn)
		{
			bIsCrouching = True;
			bDuck = 1;
		}

		lastbDuck = bDuck;
	}
}

// ----------------------------------------------------------------------
// DoJump()
// 
// copied from Engine.PlayerPawn
// Modified to let you jump if you are carrying something rather light
// You can also jump if you are crouching, just at a much lower height
// ----------------------------------------------------------------------

function DoJump( optional float F )
{
	local DeusExWeapon w;
	local float scaleFactor, augLevel;

	if ((CarriedDecoration != None) && (CarriedDecoration.Mass > 20))
		return;
	else if (bForceDuck || IsLeaning())
		return;

	if (Physics == PHYS_Walking)
	{
		if ( Role == ROLE_Authority )
			PlaySound(JumpSound, SLOT_None, 1.5, true, 1200, 1.0 - 0.2*FRand() );
		if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
			MakeNoise(0.1 * Level.Game.Difficulty);
		PlayInAir();

		Velocity.Z = JumpZ;

		if ( Level.NetMode != NM_Standalone )
		{
         if (AugmentationSystem == None)
            augLevel = -1.0;
         else			
            augLevel = AugmentationSystem.GetAugLevelValue(class'AugSpeed');
			w = DeusExWeapon(InHand);
			if ((augLevel != -1.0) && ( w != None ) && ( w.Mass > 30.0))
			{
				scaleFactor = 1.0 - FClamp( ((w.Mass - 30.0)/55.0), 0.0, 0.5 );
				Velocity.Z *= scaleFactor;
			}
		}
		
		// reduce the jump velocity if you are crouching
//		if (bIsCrouching)
//			Velocity.Z *= 0.9;

		if ( Base != Level )
			Velocity.Z += Base.Velocity.Z;
		SetPhysics(PHYS_Falling);
		if ( bCountJumps && (Role == ROLE_Authority) )
			Inventory.OwnerJumped();
	}
}

function bool IsLeaning()
{
	return (curLeanDist != 0);
}

// ----------------------------------------------------------------------
// SetBasedPawnSize()
// ----------------------------------------------------------------------

function bool SetBasedPawnSize(float newRadius, float newHeight)
{
	local float  oldRadius, oldHeight;
	local bool   bSuccess;
	local vector centerDelta, lookDir, upDir;
	local float  deltaEyeHeight;
	local Decoration savedDeco;

	if (newRadius < 0)
		newRadius = 0;
	if (newHeight < 0)
		newHeight = 0;

	oldRadius = CollisionRadius;
	oldHeight = CollisionHeight;

	if ( Level.NetMode == NM_Standalone )
	{
		if ((oldRadius == newRadius) && (oldHeight == newHeight))
			return true;
	}

	centerDelta    = vect(0, 0, 1)*(newHeight-oldHeight);
	deltaEyeHeight = GetDefaultCollisionHeight() - Default.BaseEyeHeight;

	if ( Level.NetMode != NM_Standalone )
	{
		if ((oldRadius == newRadius) && (oldHeight == newHeight) && (BaseEyeHeight == newHeight - deltaEyeHeight))
			return true;
	}

	if (CarriedDecoration != None)
		savedDeco = CarriedDecoration;

	bSuccess = false;
	if ((newHeight <= CollisionHeight) && (newRadius <= CollisionRadius))  // shrink
	{
		SetCollisionSize(newRadius, newHeight);
		if (Move(centerDelta))
			bSuccess = true;
		else
			SetCollisionSize(oldRadius, oldHeight);
	}
	else
	{
		if (Move(centerDelta))
		{
			SetCollisionSize(newRadius, newHeight);
			bSuccess = true;
		}
	}

	if (bSuccess)
	{
		// make sure we don't lose our carried decoration
		if (savedDeco != None)
		{
			savedDeco.SetPhysics(PHYS_None);
			savedDeco.SetBase(Self);
			savedDeco.SetCollision(False, False, False);

			// reset the decoration's location
			lookDir = Vector(Rotation);
			lookDir.Z = 0;				
			upDir = vect(0,0,0);
			upDir.Z = CollisionHeight / 2;		// put it up near eye level
			savedDeco.SetLocation(Location + upDir + (0.5 * CollisionRadius + CarriedDecoration.CollisionRadius) * lookDir);
		}

//		PrePivotOffset  = vect(0, 0, 1)*(GetDefaultCollisionHeight()-newHeight);
		PrePivot        -= centerDelta;
//		DesiredPrePivot -= centerDelta;
		BaseEyeHeight   = newHeight - deltaEyeHeight;

		// Complaints that eye height doesn't seem like your crouching in multiplayer
		if (( Level.NetMode != NM_Standalone ) && (bIsCrouching || bForceDuck) )
			EyeHeight		-= (centerDelta.Z * 2.5);
		else
			EyeHeight		-= centerDelta.Z;
	}
	return (bSuccess);
}

// ----------------------------------------------------------------------
// ResetBasedPawnSize()
// ----------------------------------------------------------------------

function bool ResetBasedPawnSize()
{
	return SetBasedPawnSize(Default.CollisionRadius, GetDefaultCollisionHeight());
}

// ----------------------------------------------------------------------
// GetDefaultCollisionHeight()
// ----------------------------------------------------------------------

function float GetDefaultCollisionHeight()
{
	return (Default.CollisionHeight-4.5);
}

// ----------------------------------------------------------------------
// GetCurrentGroundSpeed()
// ----------------------------------------------------------------------

function float GetCurrentGroundSpeed()
{
	local float augValue, speed;

	// Remove this later and find who's causing this to Access None MB
	if ( AugmentationSystem == None )
		return 0;

   augValue = AugmentationSystem.GetAugLevelValue(class'AugSpeed');

	if (augValue == -1.0)
		augValue = 1.0;

	if (( Level.NetMode != NM_Standalone ) && Self.IsA('Human') )
		speed = Human(Self).mpGroundSpeed * augValue;
	else
		speed = Default.GroundSpeed * augValue;

	return speed;
}

// ----------------------------------------------------------------------
// CreateDrone
// ----------------------------------------------------------------------
function CreateDrone()
{
	local Vector loc;

	loc = (2.0 + class'SpyDrone'.Default.CollisionRadius + CollisionRadius) * Vector(ViewRotation);
	loc.Z = BaseEyeHeight;
	loc += Location;
	aDrone = Spawn(class'SpyDrone', Self,, loc, ViewRotation);
	if (aDrone != None)
	{
		aDrone.Speed = 3 * spyDroneLevelValue;
		aDrone.MaxSpeed = 3 * spyDroneLevelValue;
		aDrone.Damage = 5 * spyDroneLevelValue;
		aDrone.blastRadius = 8 * spyDroneLevelValue;
		// window construction now happens in Tick()
	}
}

// ----------------------------------------------------------------------
// MoveDrone
// ----------------------------------------------------------------------

simulated function MoveDrone( float DeltaTime, Vector loc )
{
	// if the wanted velocity is zero, apply drag so we slow down gradually
	if (VSize(loc) == 0)
   {
      aDrone.Velocity *= 0.9;
   }
	else
   {
      aDrone.Velocity += deltaTime * aDrone.MaxSpeed * loc;
   }

	// add slight bobbing
   // DEUS_EX AMSD Only do the bobbing in singleplayer, we want stationary drones stationary.
   if (Level.Netmode == NM_Standalone)	
      aDrone.Velocity += deltaTime * Sin(Level.TimeSeconds * 2.0) * vect(0,0,1);
}

function ServerUpdateLean( Vector desiredLoc )
{
	local Vector gndCheck, traceSize, HitNormal, HitLocation;
	local Actor HitActor, HitActorGnd;

	// First check to see if anything is in the way
	traceSize.X = CollisionRadius;
	traceSize.Y = CollisionRadius;
	traceSize.Z = CollisionHeight;
	HitActor = Trace( HitLocation, HitNormal, desiredLoc, Location, True, traceSize );

	// Make we don't lean off the edge of something
	if ( HitActor == None )	// Don't bother if we're going to fail to set anyway
	{
		gndCheck = desiredLoc - vect(0,0,1) * CollisionHeight;
		HitActorGnd = Trace( HitLocation, HitNormal, gndCheck, desiredLoc, True, traceSize );
	}

	if ( (HitActor == None) && (HitActorGnd != None) )
		SetLocation( desiredLoc );

//	SetRotation( rot );
}

// ----------------------------------------------------------------------
// state PlayerWalking
// ----------------------------------------------------------------------

state PlayerWalking
{
	// lets us affect the player's movement
	function ProcessMove ( float DeltaTime, vector newAccel, eDodgeDir DodgeMove, rotator DeltaRot)
	{
		local int newSpeed, defSpeed;
		local name mat;
		local vector HitLocation, HitNormal, checkpoint, downcheck;
		local Actor HitActor, HitActorDown;
		local bool bCantStandUp;
		local Vector loc, traceSize;
		local float alpha, maxLeanDist;
		local float legTotal, weapSkill;

		// if the spy drone augmentation is active
		if (bSpyDroneActive)
		{
			if ( aDrone != None ) 
			{
				// put away whatever is in our hand
				if (inHand != None)
					PutInHand(None);

				// make the drone's rotation match the player's view
				aDrone.SetRotation(ViewRotation);

				// move the drone
				loc = Normal((aUp * vect(0,0,1) + aForward * vect(1,0,0) + aStrafe * vect(0,1,0)) >> ViewRotation);

				// opportunity for client to translate movement to server
				MoveDrone( DeltaTime, loc );

				// freeze the player
				Velocity = vect(0,0,0);
			}
			return;
		}

		defSpeed = GetCurrentGroundSpeed();

      // crouching makes you two feet tall
		if (bIsCrouching || bForceDuck)
		{
			if ( Level.NetMode != NM_Standalone )
				SetBasedPawnSize(Default.CollisionRadius, 30.0);
			else
				SetBasedPawnSize(Default.CollisionRadius, 16);

			// check to see if we could stand up if we wanted to
			checkpoint = Location;
			// check normal standing height
			checkpoint.Z = checkpoint.Z - CollisionHeight + 2 * GetDefaultCollisionHeight();
			traceSize.X = CollisionRadius;
			traceSize.Y = CollisionRadius;
			traceSize.Z = 1;
			HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, True, traceSize);
			if (HitActor == None)
				bCantStandUp = False;
			else
				bCantStandUp = True;
		}
		else
		{
         // DEUS_EX AMSD Changed this to grab defspeed, because GetCurrentGroundSpeed takes 31k cycles to run.
			GroundSpeed = defSpeed;

			// make sure the collision height is fudged for the floor problem - CNN
			if (!IsLeaning())
			{
				ResetBasedPawnSize();
			}
		}

		if (bCantStandUp)
			bForceDuck = True;
		else
			bForceDuck = False;

		// if the player's legs are damaged, then reduce our speed accordingly
		newSpeed = defSpeed;

		if ( Level.NetMode == NM_Standalone )
		{
			if (HealthLegLeft < 1)
				newSpeed -= (defSpeed/2) * 0.25;
			else if (HealthLegLeft < 34)
				newSpeed -= (defSpeed/2) * 0.15;
			else if (HealthLegLeft < 67)
				newSpeed -= (defSpeed/2) * 0.10;

			if (HealthLegRight < 1)
				newSpeed -= (defSpeed/2) * 0.25;
			else if (HealthLegRight < 34)
				newSpeed -= (defSpeed/2) * 0.15;
			else if (HealthLegRight < 67)
				newSpeed -= (defSpeed/2) * 0.10;

			if (HealthTorso < 67)
				newSpeed -= (defSpeed/2) * 0.05;
		}

		// let the player pull themselves along with their hands even if both of
		// their legs are blown off
		if ((HealthLegLeft < 1) && (HealthLegRight < 1))
		{
			newSpeed = defSpeed * 0.8;
			bIsWalking = True;
			bForceDuck = True;
		}
		// make crouch speed faster than normal
		else if (bIsCrouching || bForceDuck)
		{
//			newSpeed = defSpeed * 1.8;		// DEUS_EX CNN - uncomment to speed up crouch
			bIsWalking = True;
		}

		// CNN - Took this out because it sucks ASS!
		// if the legs are seriously damaged, increase the head bob
		// (unless the player has turned it off)
/*		if (Bob > 0.0)
		{
			legTotal = (HealthLegLeft + HealthLegRight) / 2.0;
			if (legTotal < 50)
				Bob = Default.Bob * FClamp(0.05*(70 - legTotal), 1.0, 3.0);
			else
				Bob = Default.Bob;
		}
*/
		// slow the player down if he's carrying something heavy
		// Like a DEAD BODY!  AHHHHHH!!!
		if (CarriedDecoration != None)
		{
			newSpeed -= CarriedDecoration.Mass * 2;
		}
		// don't slow the player down if he's skilled at the corresponding weapon skill  
		else if ((DeusExWeapon(Weapon) != None) && (Weapon.Mass > 30) && (DeusExWeapon(Weapon).GetWeaponSkill() > -0.25) && (Level.NetMode==NM_Standalone))
		{
			bIsWalking = True;
			newSpeed = defSpeed;
		}
		else if ((inHand != None) && inHand.IsA('POVCorpse'))
		{
			newSpeed -= inHand.Mass * 3;
		}

		// Multiplayer movement adjusters
		if ( Level.NetMode != NM_Standalone )
		{
			if ( Weapon != None )
			{
				weapSkill = DeusExWeapon(Weapon).GetWeaponSkill();
				// Slow down heavy weapons in multiplayer
				if ((DeusExWeapon(Weapon) != None) && (Weapon.Mass > 30) )
				{
					newSpeed = defSpeed;
					newSpeed -= ((( Weapon.Mass - 30.0 ) / (class'WeaponGEPGun'.Default.Mass - 30.0 )) * (0.70 + weapSkill) * defSpeed );
				}
				// Slow turn rate of GEP gun in multiplayer to discourage using it as the most effective close quarters weapon
				if ((WeaponGEPGun(Weapon) != None) && (!WeaponGEPGun(Weapon).bZoomed))
					TurnRateAdjuster = FClamp( 0.20 + -(weapSkill*0.5), 0.25, 1.0 );
				else
					TurnRateAdjuster = 1.0;
			}
			else
				TurnRateAdjuster = 1.0;
		}

		// if we are moving really slow, force us to walking
		if ((newSpeed <= defSpeed / 3) && !bForceDuck)
		{
			bIsWalking = True;
			newSpeed = defSpeed;
		}

		// if we are moving backwards, we should move slower
      // DEUS_EX AMSD Turns out this wasn't working right in multiplayer, I have a fix
      // for it, but it would change all our balance.
		if ((aForward < 0) && (Level.NetMode == NM_Standalone))
			newSpeed *= 0.65;

		GroundSpeed = FMax(newSpeed, 100);

		// if we are moving or crouching, we can't lean
		// uncomment below line to disallow leaning during crouch

			if ((VSize(Velocity) < 10) && (aForward == 0))		// && !bIsCrouching && !bForceDuck)
				bCanLean = True;
			else
				bCanLean = False;

			// check leaning buttons (axis aExtra0 is used for leaning)
			maxLeanDist = 40;

			if (IsLeaning())
			{
				if ( PlayerIsClient() || (Level.NetMode == NM_Standalone) )
					ViewRotation.Roll = curLeanDist * 20;
			
				if (!bIsCrouching && !bForceDuck)
					SetBasedPawnSize(CollisionRadius, GetDefaultCollisionHeight() - Abs(curLeanDist) / 3.0);
			}
			if (bCanLean && (aExtra0 != 0))
			{
				// lean
				DropDecoration();		// drop the decoration that we are carrying
				if (AnimSequence != 'CrouchWalk')
					PlayCrawling();

				alpha = maxLeanDist * aExtra0 * 2.0 * DeltaTime;

				loc = vect(0,0,0);
				loc.Y = alpha;
				if (Abs(curLeanDist + alpha) < maxLeanDist)
				{
					// check to make sure the destination not blocked
					checkpoint = (loc >> Rotation) + Location;
					traceSize.X = CollisionRadius;
					traceSize.Y = CollisionRadius;
					traceSize.Z = CollisionHeight;
					HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, True, traceSize);

					// check down as well to make sure there's a floor there
					downcheck = checkpoint - vect(0,0,1) * CollisionHeight;
					HitActorDown = Trace(HitLocation, HitNormal, downcheck, checkpoint, True, traceSize);
					if ((HitActor == None) && (HitActorDown != None))
					{
						if ( PlayerIsClient() || (Level.NetMode == NM_Standalone))
						{
							SetLocation(checkpoint);
							ServerUpdateLean( checkpoint );
							curLeanDist += alpha;
						}
					}
				}
				else
				{
					if ( PlayerIsClient() || (Level.NetMode == NM_Standalone) )
						curLeanDist = aExtra0 * maxLeanDist;
				}
			}
			else if (IsLeaning())	//if (!bCanLean && IsLeaning())	// uncomment this to not hold down lean
			{
				// un-lean
				if (AnimSequence == 'CrouchWalk')
					PlayRising();

				if ( PlayerIsClient() || (Level.NetMode == NM_Standalone))
				{
					prevLeanDist = curLeanDist;
					alpha = FClamp(7.0 * DeltaTime, 0.001, 0.9);
					curLeanDist *= 1.0 - alpha;
					if (Abs(curLeanDist) < 1.0)
						curLeanDist = 0;
				}

				loc = vect(0,0,0);
				loc.Y = -(prevLeanDist - curLeanDist);

				// check to make sure the destination not blocked
				checkpoint = (loc >> Rotation) + Location;
				traceSize.X = CollisionRadius;
				traceSize.Y = CollisionRadius;
				traceSize.Z = CollisionHeight;
				HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, True, traceSize);

				// check down as well to make sure there's a floor there
				downcheck = checkpoint - vect(0,0,1) * CollisionHeight;
				HitActorDown = Trace(HitLocation, HitNormal, downcheck, checkpoint, True, traceSize);
				if ((HitActor == None) && (HitActorDown != None))
				{
					if ( PlayerIsClient() || (Level.NetMode == NM_Standalone))
					{
						SetLocation( checkpoint );
						ServerUpdateLean( checkpoint );
					}
				}
			}
		
		Super.ProcessMove(DeltaTime, newAccel, DodgeMove, DeltaRot);
	}

	function ZoneChange(ZoneInfo NewZone)
	{
		// if we jump into water, empty our hands
		if (NewZone.bWaterZone)
			DropDecoration();

		Super.ZoneChange(NewZone);
	}

	event PlayerTick(float deltaTime)
	{
        //DEUS_EX AMSD Additional updates
        //Because of replication delay, aug icons end up being a step behind generally.  So refresh them
        //every freaking tick.  
        RefreshSystems(deltaTime);

		DrugEffects(deltaTime);
		Bleed(deltaTime);
		HighlightCenterObject();


		UpdateDynamicMusic(deltaTime);
		UpdateWarrenEMPField(deltaTime);
      // DEUS_EX AMSD Move these funcions to a multiplayer tick
      // so that only that call gets propagated to the server.
      MultiplayerTick(deltaTime);
      // DEUS_EX AMSD For multiplayer...
		FrobTime += deltaTime;

		// save some texture info
		FloorMaterial = GetFloorMaterial();
		WallMaterial = GetWallMaterial(WallNormal);

		// Check if player has walked outside a first-person convo.
		CheckActiveConversationRadius();

		// Check if all the people involved in a conversation are 
		// still within a reasonable radius.
		CheckActorDistances();

		// handle poison
      //DEUS_EX AMSD Now handled in multiplayertick
		//UpdatePoison(deltaTime);

		// Update Time Played
		UpdateTimePlayed(deltaTime);

		Super.PlayerTick(deltaTime);
	}
}

// ----------------------------------------------------------------------
// state PlayerFlying
// ----------------------------------------------------------------------

state PlayerFlying
{
	function ZoneChange(ZoneInfo NewZone)
	{
		// if we jump into water, empty our hands
		if (NewZone.bWaterZone)
			DropDecoration();

		Super.ZoneChange(NewZone);
	}

	event PlayerTick(float deltaTime)
	{

        //DEUS_EX AMSD Additional updates
        //Because of replication delay, aug icons end up being a step behind generally.  So refresh them
        //every freaking tick.  
        RefreshSystems(deltaTime);

		DrugEffects(deltaTime);
		HighlightCenterObject();
		UpdateDynamicMusic(deltaTime);
      // DEUS_EX AMSD For multiplayer...
      MultiplayerTick(deltaTime);
		FrobTime += deltaTime;

		// Check if player has walked outside a first-person convo.
		CheckActiveConversationRadius();

		// Check if all the people involved in a conversation are 
		// still within a reasonable radius.
		CheckActorDistances();

		// Update Time Played
		UpdateTimePlayed(deltaTime);

		Super.PlayerTick(deltaTime);
	}
}

// ----------------------------------------------------------------------
// event HeadZoneChange
// ----------------------------------------------------------------------

event HeadZoneChange(ZoneInfo newHeadZone)
{
	local float mult, augLevel;
	
	// hack to get the zone's ambientsound working until Tim fixes it
	if (newHeadZone.AmbientSound != None)
		newHeadZone.SoundRadius = 255;
	if (HeadRegion.Zone.AmbientSound != None)
		HeadRegion.Zone.SoundRadius = 0;

	if (newHeadZone.bWaterZone && !HeadRegion.Zone.bWaterZone)
	{
		// make sure we're not crouching when we start swimming
		bIsCrouching = False;
		bCrouchOn = False;
		bWasCrouchOn = False;
		bDuck = 0;
		lastbDuck = 0;
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
		mult = SkillSystem.GetSkillLevelValue(class'SkillSwimming');
		swimDuration = UnderWaterTime * mult;
		swimTimer = swimDuration;
		if (( Level.NetMode != NM_Standalone ) && Self.IsA('Human') )
		{
			if ( AugmentationSystem != None )
				augLevel = AugmentationSystem.GetAugLevelValue(class'AugAqualung');
			if ( augLevel == -1.0 )
				WaterSpeed = Human(Self).Default.mpWaterSpeed * mult;
			else
				WaterSpeed = Human(Self).Default.mpWaterSpeed * 2.0 * mult;
		}
		else
			WaterSpeed = Default.WaterSpeed * mult;
	}

	Super.HeadZoneChange(newHeadZone);
}

// ----------------------------------------------------------------------
// state PlayerSwimming
// ----------------------------------------------------------------------

state PlayerSwimming
{
	function GrabDecoration()
	{
		// we can't grab decorations underwater
	}

	function ZoneChange(ZoneInfo NewZone)
	{
		// if we jump into water, empty our hands
		if (NewZone.bWaterZone)
		{
			DropDecoration();
			if (bOnFire)
				ExtinguishFire();
		}

		Super.ZoneChange(NewZone);
	}

	event PlayerTick(float deltaTime)
	{
		local vector loc;

        //DEUS_EX AMSD Additional updates
        //Because of replication delay, aug icons end up being a step behind generally.  So refresh them
        //every freaking tick.  
        RefreshSystems(deltaTime);

		DrugEffects(deltaTime);
		HighlightCenterObject();
		UpdateDynamicMusic(deltaTime);
      // DEUS_EX AMSD For multiplayer...
      MultiplayerTick(deltaTime);
		FrobTime += deltaTime;

		if (bOnFire)
			ExtinguishFire();

		// save some texture info
		FloorMaterial = GetFloorMaterial();
		WallMaterial = GetWallMaterial(WallNormal);

		// don't let the player run if swimming
		bIsWalking = True;

		// update our swimming info
		swimTimer -= deltaTime;
		swimTimer = FMax(0, swimTimer);

		if ( Role == ROLE_Authority )
		{
			if (swimTimer > 0)
				PainTime = swimTimer;
		}

		// Check if player has walked outside a first-person convo.
		CheckActiveConversationRadius();

		// Check if all the people involved in a conversation are 
		// still within a reasonable radius.
		CheckActorDistances();

		// Randomly spawn an air bubble every 0.2 seconds
		// Place them in front of the player's eyes
		swimBubbleTimer += deltaTime;
		if (swimBubbleTimer >= 0.2)
		{
			swimBubbleTimer = 0;
			if (FRand() < 0.4)
			{
				loc = Location + VRand() * 4;
				loc += Vector(ViewRotation) * CollisionRadius * 2;
				loc.Z += CollisionHeight * 0.9;
				Spawn(class'AirBubble', Self,, loc);
			}
		}

		// handle poison
      //DEUS_EX AMSD Now handled in multiplayertick
		//UpdatePoison(deltaTime);

		// Update Time Played
		UpdateTimePlayed(deltaTime);

		Super.PlayerTick(deltaTime);
	}

	function BeginState()
	{
		local float mult, augLevel;

		// set us to be two feet high
		SetBasedPawnSize(Default.CollisionRadius, 16);

		// get our skill info
		mult = SkillSystem.GetSkillLevelValue(class'SkillSwimming');
		swimDuration = UnderWaterTime * mult;
		swimTimer = swimDuration;
		swimBubbleTimer = 0;
		if (( Level.NetMode != NM_Standalone ) && Self.IsA('Human') )
		{
			if ( AugmentationSystem != None )
				augLevel = AugmentationSystem.GetAugLevelValue(class'AugAqualung');
			if ( augLevel == -1.0 )
				WaterSpeed = Human(Self).Default.mpWaterSpeed * mult;
			else
				WaterSpeed = Human(Self).Default.mpWaterSpeed * 2.0 * mult;
		}
		else
			WaterSpeed = Default.WaterSpeed * mult;

		Super.BeginState();
	}
}


// ----------------------------------------------------------------------
// state Dying
//
// make sure the death animation finishes
// ----------------------------------------------------------------------

state Dying
{
	ignores all;

	event PlayerTick(float deltaTime)
	{
      if (PlayerIsClient())      
         ClientDeath();
		UpdateDynamicMusic(deltaTime);

		Super.PlayerTick(deltaTime);
	}

	exec function Fire(optional float F)
	{
		if ( Level.NetMode != NM_Standalone )
        Super.Fire();
	}

	exec function ShowMainMenu()
	{
		// reduce the white glow when the menu is up
		if (InstantFog != vect(0,0,0))
		{
			InstantFog   = vect(0.1,0.1,0.1);
			InstantFlash = 0.01;

			// force an update
			ViewFlash(1.0);
		}

		Global.ShowMainMenu();
	}

	function BeginState()
	{
		FrobTime = Level.TimeSeconds;
		ShowHud(False);
      ClientDeath();
	}

   function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
	{
	}

	function PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
	{
		local vector ViewVect, HitLocation, HitNormal, whiteVec;
		local float ViewDist;
		local actor HitActor;
		local float time;

		ViewActor = Self;
		if (bHidden)
		{
			// spiral up and around carcass and fade to white in five seconds
			time = Level.TimeSeconds - FrobTime;

			if ( ((myKiller != None) && (killProfile != None) && (!killProfile.bKilledSelf)) || 
				  ((killProfile != None) && killProfile.bValid && (!killProfile.bKilledSelf)))
			{
				if ( killProfile.bValid && killProfile.bTurretKilled )
					ViewVect = killProfile.killerLoc - Location;
				else if ( killProfile.bValid && killProfile.bProximityKilled )
					ViewVect = killProfile.killerLoc - Location;
				else if (( !killProfile.bKilledSelf ) && ( myKiller != None ))
					ViewVect = myKiller.Location - Location;
				CameraLocation = Location;
				CameraRotation = Rotator(ViewVect);
			}
			else if (time < 8.0)
			{
				whiteVec.X = time / 16.0;
				whiteVec.Y = time / 16.0;
				whiteVec.Z = time / 16.0;
				CameraRotation.Pitch = -16384;
				CameraRotation.Yaw = (time * 8192.0) % 65536;
				ViewDist = 32 + time * 32;
				InstantFog = whiteVec;
				InstantFlash = 0.5;
				ViewFlash(1.0);
				// make sure we don't go through the ceiling
				ViewVect = vect(0,0,1);
				HitActor = Trace(HitLocation, HitNormal, Location + ViewDist * ViewVect, Location);
				if ( HitActor != None )
					CameraLocation = HitLocation;
				else
					CameraLocation = Location + ViewDist * ViewVect;
			}
			else
			{
				if  ( Level.NetMode != NM_Standalone )
				{
					// Don't fade to black in multiplayer
				}
				else
				{
					// then, fade out to black in four seconds and bring up
					// the main menu automatically
					whiteVec.X = FMax(0.5 - (time-8.0) / 8.0, -1.0);
					whiteVec.Y = FMax(0.5 - (time-8.0) / 8.0, -1.0);
					whiteVec.Z = FMax(0.5 - (time-8.0) / 8.0, -1.0);
					CameraRotation.Pitch = -16384;
					CameraRotation.Yaw = (time * 8192.0) % 65536;
					 ViewDist = 32 + 8.0 * 32;
					InstantFog = whiteVec;
					InstantFlash = whiteVec.X;
					ViewFlash(1.0);

					// start the splash screen after a bit
					// only if we don't have a menu open
					// DEUS_EX AMSD Don't do this in multiplayer!!!!
					if (Level.NetMode == NM_Standalone)
					{
						if (whiteVec == vect(-1.0,-1.0,-1.0))
							if ((MenuUIWindow(DeusExRootWindow(rootWindow).GetTopWindow()) == None) &&
								(ToolWindow(DeusExRootWindow(rootWindow).GetTopWindow()) == None))
								ConsoleCommand("OPEN DXONLY");
					}
				}
				// make sure we don't go through the ceiling
				ViewVect = vect(0,0,1);
				HitActor = Trace(HitLocation, HitNormal, Location + ViewDist * ViewVect, Location);
				if ( HitActor != None )
					CameraLocation = HitLocation;
				else
					CameraLocation = Location + ViewDist * ViewVect;
			}
		}
		else
		{
			// use FrobTime as the cool DeathCam timer
			FrobTime = Level.TimeSeconds;

			// make sure we don't go through the wall
		    ViewDist = 190;
			ViewVect = vect(1,0,0) >> Rotation;
			HitActor = Trace( HitLocation, HitNormal, 
					Location - ViewDist * vector(CameraRotation), Location, false, vect(12,12,2));
			if ( HitActor != None )
				CameraLocation = HitLocation;
			else
				CameraLocation = Location - ViewDist * ViewVect;
		}

		// don't fog view if we are "paused"
		if (DeusExRootWindow(rootWindow).bUIPaused)
		{
			InstantFog   = vect(0,0,0);
			InstantFlash = 0;
			ViewFlash(1.0);
		}
	}

Begin:
	// Dead players comes back to life with scope view, so this is here to prevent that
	if ( DeusExWeapon(inHand) != None )
	{
		DeusExWeapon(inHand).bZoomed = False;
		DeusExWeapon(inHand).RefreshScopeDisplay(Self, True, False);
	}

	if ( DeusExRootWindow(rootWindow).hud.augDisplay != None )
	{
		DeusExRootWindow(rootWindow).hud.augDisplay.bVisionActive = False;
		DeusExRootWindow(rootWindow).hud.augDisplay.activeCount = 0;
	}

	// Don't come back to life drugged or posioned
	poisonCounter		= 0; 
	poisonTimer			= 0;    
	drugEffectTimer	= 0;

	// Don't come back to life crouched
	bCrouchOn			= False;
	bWasCrouchOn		= False;
	bIsCrouching		= False;
	bForceDuck			= False;
	lastbDuck			= 0;
	bDuck					= 0;

	FrobTime = Level.TimeSeconds;
	bBehindView = True;
	Velocity = vect(0,0,0);
	Acceleration = vect(0,0,0);
	DesiredFOV = Default.DesiredFOV;
	FinishAnim();
	KillShadow();

   FlashTimer = 0;

	// hide us and spawn the carcass
	bHidden = True;
	SpawnCarcass();
   //DEUS_EX AMSD Players should not leave physical versions of themselves around :)
   if (Level.NetMode != NM_Standalone)
      HidePlayer();
}

// ----------------------------------------------------------------------
// state Interpolating
// ----------------------------------------------------------------------

state Interpolating
{
	ignores all;

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
	{
	}

	// check to see if we are done interpolating, if so, then travel to the next map
	event InterpolateEnd(Actor Other)
	{
		if (InterpolationPoint(Other).bEndOfPath)
			if (NextMap != "")
			{
				// DEUS_EX_DEMO
				//
				// If this is the demo, show the demo splash screen, which
				// will exit the game after the player presses a key/mouseclick
				if (NextMap == "02_NYC_BatteryPark")
					ShowDemoSplash();
				else
					Level.Game.SendPlayer(Self, NextMap);
			}
	}

	exec function Fire(optional float F)
	{
		local DeusExLevelInfo info;

		// only bring up the menu if we're not in a mission outro
		info = GetLevelInfo();
		if ((info != None) && (info.MissionNumber < 0))
			ShowMainMenu();
	}

	event PlayerTick(float deltaTime)
	{
		UpdateInHand();
		UpdateDynamicMusic(deltaTime);
		ShowHud(False);
	}

Begin:
	if (bOnFire)
		ExtinguishFire();

	bDetectable = False;

	// put away your weapon
	if (Weapon != None)
	{
		Weapon.bHideWeapon = True;
		Weapon = None;
		PutInHand(None);
	}

	// can't carry decorations across levels
	if (CarriedDecoration != None)
	{
		CarriedDecoration.Destroy();
		CarriedDecoration = None;
	}

	PlayAnim('Still');
}

// ----------------------------------------------------------------------
// state Paralyzed
// ----------------------------------------------------------------------

state Paralyzed
{
	ignores all;

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
	{
	}

	exec function Fire(optional float F)
	{
		ShowMainMenu();
	}

	event PlayerTick(float deltaTime)
	{
		UpdateInHand();
		ShowHud(False);
		ViewFlash(deltaTime);
	}

Begin:
	if (bOnFire)
		ExtinguishFire();

	bDetectable = False;

	// put away your weapon
	if (Weapon != None)
	{
		Weapon.bHideWeapon = True;
		Weapon = None;
		PutInHand(None);
	}

	// can't carry decorations across levels
	if (CarriedDecoration != None)
	{
		CarriedDecoration.Destroy();
		CarriedDecoration = None;
	}

	SetPhysics(PHYS_None);
	PlayAnim('Still');
	Stop;

Letterbox:
	if (bOnFire)
		ExtinguishFire();

	bDetectable = False;

	// put away your weapon
	if (Weapon != None)
	{
		Weapon.bHideWeapon = True;
		Weapon = None;
		PutInHand(None);
	}

	// can't carry decorations across levels
	if (CarriedDecoration != None)
	{
		CarriedDecoration.Destroy();
		CarriedDecoration = None;
	}

	SetPhysics(PHYS_None);
	PlayAnim('Still');
	if (rootWindow != None)
		rootWindow.NewChild(class'CinematicWindow');
}

// ----------------------------------------------------------------------
// RenderOverlays()
// render our in-hand object
// ----------------------------------------------------------------------

simulated event RenderOverlays( canvas Canvas )
{
   Super.RenderOverlays(Canvas);

	if (!IsInState('Interpolating') && !IsInState('Paralyzed'))
		if ((inHand != None) && (!inHand.IsA('Weapon')))
			inHand.RenderOverlays(Canvas);
}

// ----------------------------------------------------------------------
// RestrictInput()
//
// Are we in a state which doesn't allow certain exec functions?
// ----------------------------------------------------------------------

function bool RestrictInput()
{
	if (IsInState('Interpolating') || IsInState('Dying') || IsInState('Paralyzed'))
		return True;

	return False;
}


// ----------------------------------------------------------------------
// DroneExplode
// ----------------------------------------------------------------------
function DroneExplode()
{
	local AugDrone anAug;

	if (aDrone != None)
	{
		aDrone.Explode(aDrone.Location, vect(0,0,1));
      //DEUS_EX AMSD Don't blow up OTHER player drones...
      anAug = AugDrone(AugmentationSystem.FindAugmentation(class'AugDrone'));
		//foreach AllActors(class'AugDrone', anAug)			
      if (anAug != None)      
         anAug.Deactivate();
	}
}

// ----------------------------------------------------------------------
// BuySkills()
// ----------------------------------------------------------------------

exec function BuySkills()
{
	if ( Level.NetMode != NM_Standalone )
	{
		// First turn off scores if we're heading into skill menu
		if ( !bBuySkills )
			ClientTurnOffScores();

		bBuySkills = !bBuySkills;
		BuySkillSound( 2 );
	}
}

// ----------------------------------------------------------------------
// KillerProfile()
// ----------------------------------------------------------------------

exec function KillerProfile()
{
	bKillerProfile = !bKillerProfile;
}

// ----------------------------------------------------------------------
// ClientTurnOffScores()
// ----------------------------------------------------------------------
function ClientTurnOffScores()
{
	if ( bShowScores )
		bShowScores = False;
}

// ----------------------------------------------------------------------
/// ShowScores()
// ----------------------------------------------------------------------

exec function ShowScores()
{
	if ( bBuySkills && !bShowScores )
		BuySkills();

	bShowScores = !bShowScores;
}

// ----------------------------------------------------------------------
// ParseLeftClick()
// ----------------------------------------------------------------------

exec function ParseLeftClick()
{
	//
	// ParseLeftClick deals with things in your HAND
	//
	// Precedence:
	// - Detonate spy drone
	// - Fire (handled automatically by user.ini bindings)
	// - Use inHand
	//

	if (RestrictInput())
		return;

	// if the spy drone augmentation is active, blow it up
	if (bSpyDroneActive)
	{
		DroneExplode();
		return;
	}

	if ((inHand != None) && !bInHandTransition)
	{
		if (inHand.bActivatable)
			inHand.Activate();
		else if (FrobTarget != None)
		{
			// special case for using keys or lockpicks on doors
			if (FrobTarget.IsA('DeusExMover'))
				if (inHand.IsA('NanoKeyRing') || inHand.IsA('Lockpick'))
					DoFrob(Self, inHand);

			// special case for using multitools on hackable things
			if (FrobTarget.IsA('HackableDevices'))
			{
				if (inHand.IsA('Multitool'))
				{
					if (( Level.Netmode != NM_Standalone ) && (TeamDMGame(DXGame) != None) && FrobTarget.IsA('AutoTurretGun') && (AutoTurretGun(FrobTarget).team==PlayerReplicationInfo.team) )
					{
						MultiplayerNotifyMsg( MPMSG_TeamHackTurret );
						return;
					}
					else
						DoFrob(Self, inHand);
				}
			}
		}
	}
}

// ----------------------------------------------------------------------
// ParseRightClick()
// ----------------------------------------------------------------------

exec function ParseRightClick()
{
	//
	// ParseRightClick deals with things in the WORLD
	//
	// Precedence:
	// - Pickup highlighted Inventory
	// - Frob highlighted object
	// - Grab highlighted Decoration
	// - Put away (or drop if it's a deco) inHand
	//

	local AutoTurret turret;
	local int ViewIndex;
	local bool bPlayerOwnsIt;
   local Inventory oldFirstItem;
	local Inventory oldInHand;
	local Decoration oldCarriedDecoration;
	local Vector loc;

	if (RestrictInput())
		return;

   oldFirstItem = Inventory;
	oldInHand = inHand;
	oldCarriedDecoration = CarriedDecoration;

	if (FrobTarget != None)
		loc = FrobTarget.Location;

	if (FrobTarget != None)
	{
		// First check if this is a NanoKey, in which case we just
		// want to add it to the NanoKeyRing without disrupting
		// what the player is holding

		if (FrobTarget.IsA('NanoKey'))
		{
			PickupNanoKey(NanoKey(FrobTarget));
			FrobTarget.Destroy();
			FrobTarget = None;
			return;
		}
		else if (FrobTarget.IsA('Inventory'))
		{
			// If this is an item that can be stacked, check to see if 
			// we already have one, in which case we don't need to 
			// allocate more space in the inventory grid.
			// 
			// TODO: This logic may have to get more involved if/when 
			// we start allowing other types of objects to get stacked.

			if (HandleItemPickup(FrobTarget, True) == False)
				return;

			// if the frob succeeded, put it in the player's inventory
         //DEUS_EX AMSD ARGH! Because of the way respawning works, the item I pick up
         //is NOT the same as the frobtarget if I do a pickup.  So how do I tell that
         //I've successfully picked it up?  Well, if the first item in my inventory 
         //changed, I picked up a new item.
			if ( ((Level.NetMode == NM_Standalone) && (Inventory(FrobTarget).Owner == Self)) ||
              ((Level.NetMode != NM_Standalone) && (oldFirstItem != Inventory)) )
			{
            if (Level.NetMode == NM_Standalone)
               FindInventorySlot(Inventory(FrobTarget));
            else
               FindInventorySlot(Inventory);
				FrobTarget = None;
			}
		}
		else if (FrobTarget.IsA('Decoration') && Decoration(FrobTarget).bPushable)
		{
			GrabDecoration();
		}
		else
		{
			if (( Level.NetMode != NM_Standalone ) && ( TeamDMGame(DXGame) != None ))
			{
				if ( FrobTarget.IsA('LAM') || FrobTarget.IsA('GasGrenade') || FrobTarget.IsA('EMPGrenade'))
				{
					if ((ThrownProjectile(FrobTarget).team == PlayerReplicationInfo.team) && ( ThrownProjectile(FrobTarget).Owner != Self ))
					{
						if ( ThrownProjectile(FrobTarget).bDisabled )		// You can re-enable a grenade for a teammate
						{
							ThrownProjectile(FrobTarget).ReEnable();
							return;
						}
						MultiplayerNotifyMsg( MPMSG_TeamLAM );
						return;
					}
				}
				if ( FrobTarget.IsA('ComputerSecurity') && (PlayerReplicationInfo.team == ComputerSecurity(FrobTarget).team) )
				{
					// Let controlling player re-hack his/her own computer
					bPlayerOwnsIt = False;
					foreach AllActors(class'AutoTurret',turret)
					{
						for (ViewIndex = 0; ViewIndex < ArrayCount(ComputerSecurity(FrobTarget).Views); ViewIndex++)
						{
							if (ComputerSecurity(FrobTarget).Views[ViewIndex].turretTag == turret.Tag)
							{
								if (( turret.safeTarget == Self ) || ( turret.savedTarget == Self ))
								{
									bPlayerOwnsIt = True;
									break;
								}
							}
						}
					}
					if ( !bPlayerOwnsIt )
					{
						MultiplayerNotifyMsg( MPMSG_TeamComputer );
						return;
					}
				}
			}
			// otherwise, just frob it
			DoFrob(Self, None);
		}
	}
	else
	{
		// if there's no FrobTarget, put away an inventory item or drop a decoration
		// or drop the corpse
		if ((inHand != None) && inHand.IsA('POVCorpse'))
			DropItem();
		else
			PutInHand(None);
	}

	if ((oldInHand == None) && (inHand != None))
		PlayPickupAnim(loc);
	else if ((oldCarriedDecoration == None) && (CarriedDecoration != None))
		PlayPickupAnim(loc);
}

// ----------------------------------------------------------------------
// PlayPickupAnim()
// ----------------------------------------------------------------------

function PlayPickupAnim(Vector locPickup)
{
	if (Location.Z - locPickup.Z < 16)
		PlayAnim('PushButton',,0.1);
	else
		PlayAnim('Pickup',,0.1);
}

// ----------------------------------------------------------------------
// HandleItemPickup()
// ----------------------------------------------------------------------

function bool HandleItemPickup(Actor FrobTarget, optional bool bSearchOnly)
{
	local bool bCanPickup;
	local bool bSlotSearchNeeded;
	local Inventory foundItem;

	bSlotSearchNeeded = True;
	bCanPickup = True;

	// Special checks for objects that do not require phsyical inventory
	// in order to be picked up:
	// 
	// - NanoKeys
	// - DataVaultImages
	// - Credits

	if ((FrobTarget.IsA('DataVaultImage')) || (FrobTarget.IsA('NanoKey')) || (FrobTarget.IsA('Credits')))
	{
		bSlotSearchNeeded = False;
	}
	else if (FrobTarget.IsA('DeusExPickup'))
	{
		// If an object of this type already exists in the player's inventory *AND*
		// the object is stackable, then we don't need to search.

		if ((FindInventoryType(FrobTarget.Class) != None) && (DeusExPickup(FrobTarget).bCanHaveMultipleCopies))
			bSlotSearchNeeded = False;
	}
	else 
	{
		// If this isn't ammo or a weapon that we already have, 
		// check if there's enough room in the player's inventory
		// to hold this item.

		foundItem = GetWeaponOrAmmo(Inventory(FrobTarget));

		if (foundItem != None)
		{
			bSlotSearchNeeded = False;

			// if this is an ammo, and we're full of it, abort the pickup
			if (foundItem.IsA('Ammo'))
			{
				if (Ammo(foundItem).AmmoAmount >= Ammo(foundItem).MaxAmmo)
				{
					ClientMessage(TooMuchAmmo);
					bCanPickup = False;
				}
			}

			// If this is a grenade or LAM (what a pain in the ass) then also check
			// to make sure we don't have too many grenades already
			else if ((foundItem.IsA('WeaponEMPGrenade')) || 
			    (foundItem.IsA('WeaponGasGrenade')) || 
				(foundItem.IsA('WeaponNanoVirusGrenade')) || 
				(foundItem.IsA('WeaponLAM')))
			{
				if (DeusExWeapon(foundItem).AmmoType.AmmoAmount >= DeusExWeapon(foundItem).AmmoType.MaxAmmo)
				{
					ClientMessage(TooMuchAmmo);
					bCanPickup = False;
				}
			}


			// Otherwise, if this is a single-use weapon, prevent the player
			// from picking up

			else if (foundItem.IsA('Weapon'))
			{
				// If these fields are set as checked, then this is a 
				// single use weapon, and if we already have one in our 
				// inventory another cannot be picked up (puke). 

				bCanPickup = ! ( (Weapon(foundItem).ReloadCount == 0) && 
				                 (Weapon(foundItem).PickupAmmoCount == 0) && 
				                 (Weapon(foundItem).AmmoName != None) );

				if (!bCanPickup)
					ClientMessage(Sprintf(CanCarryOnlyOne, foundItem.itemName));

			}
		}
	}
	
	if (bSlotSearchNeeded && bCanPickup)
	{
		if (FindInventorySlot(Inventory(FrobTarget), bSearchOnly) == False)
		{
			ClientMessage(Sprintf(InventoryFull, Inventory(FrobTarget).itemName));
			bCanPickup = False;
			ServerConditionalNotifyMsg( MPMSG_DropItem );
		}
	}
	
	if (bCanPickup)
	{
		if ( (Level.NetMode != NM_Standalone) && (FrobTarget.IsA('DeusExWeapon') || FrobTarget.IsA('DeusExAmmo')) )
			PlaySound(sound'WeaponPickup', SLOT_Interact, 0.5+FRand()*0.25, , 256, 0.95+FRand()*0.1);
		DoFrob(Self, inHand);

		// This is bad. We need to reset the number so restocking works
		if ( Level.NetMode != NM_Standalone )
		{
			if ( FrobTarget.IsA('DeusExWeapon') && (DeusExWeapon(FrobTarget).PickupAmmoCount == 0) )
			{
				DeusExWeapon(FrobTarget).PickupAmmoCount = DeusExWeapon(FrobTarget).Default.mpPickupAmmoCount * 3;
			}
		}
	}

	return bCanPickup;
}

// ----------------------------------------------------------------------
// CreateNanoKeyInfo()
// ----------------------------------------------------------------------

function NanoKeyInfo CreateNanoKeyInfo()
{
	local NanoKeyInfo newKey;

	newKey = new(Self) Class'NanoKeyInfo';

	return newKey;
}

// ----------------------------------------------------------------------
// PickupNanoKey()
// 
// Picks up a NanoKey
//
// 1. Add KeyID to list of keys
// 2. Destroy NanoKey (since the user can't have it in his/her inventory)
// ----------------------------------------------------------------------

function PickupNanoKey(NanoKey newKey)
{
	KeyRing.GiveKey(newKey.KeyID, newKey.Description);
   //DEUS_EX AMSD In multiplayer, propagate the key to the client if the server
   if ((Role == ROLE_Authority) && (Level.NetMode != NM_Standalone))
   {
      KeyRing.GiveClientKey(newKey.KeyID, newKey.Description);
   }   
	ClientMessage(Sprintf(AddedNanoKey, newKey.Description));
}

// ----------------------------------------------------------------------
// RemoveNanoKey()
// ----------------------------------------------------------------------

exec function RemoveNanoKey(Name KeyToRemove)
{
	if (!bCheatsEnabled)
		return;

	KeyRing.RemoveKey(KeyToRemove);
   if ((Role == ROLE_Authority) && (Level.NetMode != NM_Standalone))
   {
      KeyRing.RemoveClientKey(KeyToRemove);
   }   
}

// ----------------------------------------------------------------------
// GiveNanoKey()
// ----------------------------------------------------------------------

exec function GiveNanoKey(Name newKeyID, String newDescription)
{
	if (!bCheatsEnabled)
		return;

	KeyRing.GiveKey(newKeyID, newDescription);
   //DEUS_EX AMSD In multiplayer, propagate the key to the client if the server
   if ((Role == ROLE_Authority) && (Level.NetMode != NM_Standalone))
   {
      KeyRing.GiveClientKey(newKeyID, newDescription);
   }

}

// ----------------------------------------------------------------------
// DoFrob()
// 
// Frob the target
// ----------------------------------------------------------------------

function DoFrob(Actor Frobber, Inventory frobWith)
{
	local DeusExRootWindow root;
	local Ammo ammo;
	local Inventory item;
	local Actor A;

	// make sure nothing is based on us if we're an inventory
	if (FrobTarget.IsA('Inventory'))
		foreach FrobTarget.BasedActors(class'Actor', A)
			A.SetBase(None);

	FrobTarget.Frob(Frobber, frobWith);

	// if the object destroyed itself, get out
	if (FrobTarget == None)
		return;

	// if the inventory item aborted it's own pickup, get out
	if (FrobTarget.IsA('Inventory') && (FrobTarget.Owner != Self))
		return;

	// alert NPCs that I'm messing with stuff
	if (FrobTarget.bOwned)
		AISendEvent('Futz', EAITYPE_Visual);

	// play an animation
	PlayPickupAnim(FrobTarget.Location);

	// set the base so the inventory follows us around correctly
	if (FrobTarget.IsA('Inventory'))
		FrobTarget.SetBase(Frobber);
}

// ----------------------------------------------------------------------
// PutInHand()
//
// put the object in the player's hand and draw it in front of the player
// ----------------------------------------------------------------------

exec function PutInHand(optional Inventory inv)
{
	if (RestrictInput())
		return;

	// can't put anything in hand if you're using a spy drone
	if ((inHand == None) && bSpyDroneActive)
		return;

	// can't do anything if you're carrying a corpse
	if ((inHand != None) && inHand.IsA('POVCorpse'))
		return;

	if (inv != None)
	{
		// can't put ammo in hand
		if (inv.IsA('Ammo'))
			return;

		// Can't put an active charged item in hand
		if ((inv.IsA('ChargedPickup')) && (ChargedPickup(inv).IsActive()))
			return;
	}

	if (CarriedDecoration != None)
		DropDecoration();

	SetInHandPending(inv);
}

// ----------------------------------------------------------------------
// UpdateBeltText()
// ----------------------------------------------------------------------

function UpdateBeltText(Inventory item)
{
	local DeusExRootWindow root;

	root = DeusExRootWindow(rootWindow);

	// Update object belt text
	if ((item.bInObjectBelt) && (root != None))
		root.hud.belt.UpdateObjectText(item.beltPos);		
}

// ----------------------------------------------------------------------
// UpdateAmmoBeltText()
//
// Loops through all the weapons in the player's inventory and updates
// the ammo for any that matches the ammo type passed in.
// ----------------------------------------------------------------------

function UpdateAmmoBeltText(Ammo ammo)
{
	local Inventory inv;

	inv = Inventory;
	while(inv != None)
	{
		if ((inv.IsA('DeusExWeapon')) && (DeusExWeapon(inv).AmmoType == ammo))
			UpdateBeltText(inv);

		inv = inv.Inventory;
	}
}

// ----------------------------------------------------------------------
// SetInHand()
// ----------------------------------------------------------------------

function SetInHand(Inventory newInHand)
{
	local DeusExRootWindow root;

	inHand = newInHand;

	// Notify the hud
	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.hud.belt.UpdateInHand();
}

// ----------------------------------------------------------------------
// SetInHandPending()
// ----------------------------------------------------------------------

function SetInHandPending(Inventory newInHandPending)
{
	local DeusExRootWindow root;

	if ( newInHandPending == None )
		ClientInHandPending = None;

	inHandPending = newInHandPending;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.hud.belt.UpdateInHand();
}

// ----------------------------------------------------------------------
// UpdateInHand()
//
// Called every frame
// Checks the state of inHandPending and deals with animation and crap
// 1. Check for pending item
// 2. Play down anim (and deactivate) for inHand and wait for it to finish
// 3. Assign inHandPending to inHand (and SelectedItem)
// 4. Play up anim for inHand
// ----------------------------------------------------------------------

function UpdateInHand()
{
	local bool bSwitch;

	//sync up clientinhandpending.
	if (inHandPending != inHand)
		ClientInHandPending = inHandPending;

   //DEUS_EX AMSD  Don't let clients do this.
   if (Role < ROLE_Authority)
      return;

	if (inHand != inHandPending)
	{
		bInHandTransition = True;
		bSwitch = False;
		if (inHand != None)
		{
			// turn it off if it is on
			if (inHand.bActive)
				inHand.Activate();

			if (inHand.IsA('SkilledTool'))
			{
				if (inHand.IsInState('Idle'))
            {
					SkilledTool(inHand).PutDown();
            }
				else if (inHand.IsInState('Idle2'))
            {
					bSwitch = True;
            }
			}
			else if (inHand.IsA('DeusExWeapon'))
			{
				if (inHand.IsInState('Idle') || inHand.IsInState('Reload'))
					DeusExWeapon(inHand).PutDown();
				else if (inHand.IsInState('DownWeapon') && (Weapon == None))
					bSwitch = True;
			}
			else
			{
				bSwitch = True;
			}
		}
		else
		{
			bSwitch = True;
		}

		// OK to actually switch?
		if (bSwitch)
		{
			SetInHand(inHandPending);
			SelectedItem = inHandPending;

			if (inHand != None)
			{
				if (inHand.IsA('SkilledTool'))
					SkilledTool(inHand).BringUp();
				else if (inHand.IsA('DeusExWeapon'))
					SwitchWeapon(DeusExWeapon(inHand).InventoryGroup);
			}
		}
	}
	else
	{
		bInHandTransition = False;

		// Added this code because it's now possible to reselect an in-hand
		// item while we're putting it down, so we need to bring it back up...

		if (inHand != None)
		{
			// if we put the item away, bring it back up
			if (inHand.IsA('SkilledTool'))
			{
				if (inHand.IsInState('Idle2'))
					SkilledTool(inHand).BringUp();
			}
			else if (inHand.IsA('DeusExWeapon'))
			{
				if (inHand.IsInState('DownWeapon') && (Weapon == None))
					SwitchWeapon(DeusExWeapon(inHand).InventoryGroup);
			}
		}

	}

	UpdateCarcassEvent();
}

// ----------------------------------------------------------------------
// UpdateCarcassEvent()
// 
// Small hack for sending carcass events
// ----------------------------------------------------------------------

function UpdateCarcassEvent()
{
	if ((inHand != None) && (inHand.IsA('POVCorpse')))
		AIStartEvent('Carcass', EAITYPE_Visual);
	else
		AIEndEvent('Carcass', EAITYPE_Visual);
}

// ----------------------------------------------------------------------
// IsEmptyItemSlot()
//
// Returns True if the item will fit in this slot
// ----------------------------------------------------------------------

function Bool IsEmptyItemSlot( Inventory anItem, int col, int row )
{
	local int slotsCol;
	local int slotsRow;
	local Bool bEmpty;

	if ( anItem == None )
		return False;

	// First make sure the item can fit horizontally
	// and vertically
	if (( col + anItem.invSlotsX > maxInvCols ) ||
		( row + anItem.invSlotsY > maxInvRows ))
			return False;

   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
      return True;

	// Now check this and the needed surrounding slots
	// to see if all the slots are empty

	bEmpty = True;
	for( slotsRow=0; slotsRow < anItem.invSlotsY; slotsRow++ )
	{
		for ( slotsCol=0; slotsCol < anItem.invSlotsX; slotsCol++ )
		{
			if ( invSlots[((slotsRow + row) * maxInvCols) + (slotsCol + col)] == 1 )
			{
				bEmpty = False;
				break;
			}
		}

		if ( !bEmpty )
			break;
	}

	return bEmpty;
}

// ----------------------------------------------------------------------
// IsEmptyItemSlotXY()
//
// Returns True if the item will fit in this slot
// ----------------------------------------------------------------------

function Bool IsEmptyItemSlotXY( int invSlotsX, int invSlotsY, int col, int row )
{
	local int slotsCol;
	local int slotsRow;
	local Bool bEmpty;

	// First make sure the item can fit horizontally
	// and vertically
	if (( col + invSlotsX > maxInvCols ) ||
		( row + invSlotsY > maxInvRows ))
			return False;

   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
      return True;

   // Now check this and the needed surrounding slots
	// to see if all the slots are empty

	bEmpty = True;
	for( slotsRow=0; slotsRow < invSlotsY; slotsRow++ )
	{
		for ( slotsCol=0; slotsCol < invSlotsX; slotsCol++ )
		{
			if ( invSlots[((slotsRow + row) * maxInvCols) + (slotsCol + col)] == 1 )
			{
				bEmpty = False;
				break;
			}
		}

		if ( !bEmpty )
			break;
	}

	return bEmpty;
}

// ----------------------------------------------------------------------
// SetInvSlots()
// ----------------------------------------------------------------------

function SetInvSlots( Inventory anItem, int newValue )
{
	local int slotsCol;
	local int slotsRow;

	if ( anItem == None )
		return;

	// Make sure this item is located in a valid position
	if (( anItem.invPosX != -1 ) && ( anItem.invPosY != -1 ))
	{
		// fill inventory slots
		for( slotsRow=0; slotsRow < anItem.invSlotsY; slotsRow++ )
			for ( slotsCol=0; slotsCol < anItem.invSlotsX; slotsCol++ )
				invSlots[((slotsRow + anItem.invPosY) * maxInvCols) + (slotsCol + anItem.invPosX)] = newValue;
	}
}

// ----------------------------------------------------------------------
// PlaceItemInSlot()
// ----------------------------------------------------------------------

function PlaceItemInSlot( Inventory anItem, int col, int row )
{
	// Save in the original Inventory item also
	anItem.invPosX = col;
	anItem.invPosY = row;

	SetInvSlots(anItem, 1);
}

// ----------------------------------------------------------------------
// RemoveItemFromSlot()
//
// Removes an inventory item from the inventory grid
// ----------------------------------------------------------------------

function RemoveItemFromSlot(Inventory anItem)
{
	if (anItem != None)
	{
		SetInvSlots(anItem, 0);
		anItem.invPosX = -1;
		anItem.invPosY = -1;
	}
}

// ----------------------------------------------------------------------
// ClearInventorySlots()
//
// Not for the foolhardy
// ----------------------------------------------------------------------

function ClearInventorySlots()
{
	local int slotIndex;

	for(slotIndex=0; slotIndex<arrayCount(invSlots); slotIndex++)
		invSlots[slotIndex] = 0;
}

// ----------------------------------------------------------------------
// FindInventorySlot()
//
// Searches through the inventory slot grid and attempts to find a 
// valid location for the item passed in.  Returns True if the item
// is placed, otherwise returns False.
// ----------------------------------------------------------------------

function Bool FindInventorySlot(Inventory anItem, optional Bool bSearchOnly)
{
	local bool bPositionFound;
	local int row;
	local int col;
	local int newSlotX;
	local int newSlotY;
   local int beltpos;
	local ammo foundAmmo;

	if (anItem == None)
		return False;
	
	// Special checks for objects that do not require phsyical inventory
	// in order to be picked up:
	// 
	// - NanoKeys
	// - DataVaultImages
	// - Credits
	// - Ammo

	if ((anItem.IsA('DataVaultImage')) || (anItem.IsA('NanoKey')) || (anItem.IsA('Credits')) || (anItem.IsA('Ammo')))
		return True;

   bPositionFound = False;
   // DEUS_EX AMSD In multiplayer, due to propagation delays, the inventory refreshers in the
   // personascreeninventory can keep bouncing items back and forth.  So just return true and
   // place the item where it already was.
   if ((anItem.invPosX != -1) && (anItem.invPosY != -1) && (Level.NetMode != NM_Standalone) && (!bSearchOnly))
   {
      SetInvSlots(anItem,1);
      log("Trying to place item "$anItem$" when already placed at "$anItem.invPosX$", "$anItem.invPosY$".");
      return True;
   }

	// Loop through all slots, looking for a fit
	for (row=0; row<maxInvRows; row++)
	{	
		if (row + anItem.invSlotsY > maxInvRows)
			break;

		// Make sure the item can fit vertically
		for(col=0; col<maxInvCols; col++)
		{
			if (IsEmptyItemSlot(anItem, col, row ))
			{
				bPositionFound = True;
				break;
			}
		}

		if (bPositionFound)
			break;
	}

   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
   {
      bPositionFound = False;
      beltpos = 0;
      if (DeusExRootWindow(rootWindow) != None)
      {
         for (beltpos = 0; beltpos < ArrayCount(DeusExRootWindow(rootWindow).hud.belt.objects); beltpos++)
         {
            if ( (DeusExRootWindow(rootWindow).hud.belt.objects[beltpos].item == None) && (anItem.TestMPBeltSpot(beltpos)) )
            {
               bPositionFound = True;
            }
         }
      }
      else
      {
         log("no belt to check");
      }
   }

   if ((bPositionFound) && (!bSearchOnly))
   {
		PlaceItemInSlot(anItem, col, row);
   }
   
	return bPositionFound;
}
				
// ----------------------------------------------------------------------
// FindInventorySlotXY()
//
// Searches for an available slot given the number of horizontal and
// vertical slots this item takes up.
// ----------------------------------------------------------------------

function Bool FindInventorySlotXY(int invSlotsX, int invSlotsY, out int newSlotX, out int newSlotY)
{
	local bool bPositionFound;
	local int row;
	local int col;

	bPositionFound = False;

	// Loop through all slots, looking for a fit
	for (row=0; row<maxInvRows; row++)
	{	
		if (row + invSlotsY > maxInvRows)
			break;

		// Make sure the item can fit vertically
		for(col=0; col<maxInvCols; col++)
		{
			if (IsEmptyItemSlotXY(invSlotsX, invSlotsY, col, row))
			{
				newSlotX = col;
				newSlotY = row;

				bPositionFound = True;
				break;
			}
		}

		if (bPositionFound)
			break;
	}

	return bPositionFound;
}

// ----------------------------------------------------------------------
// DumpInventoryGrid()
//
// Dumps the inventory grid to the log file.  Useful for debugging only.
// ----------------------------------------------------------------------

exec function DumpInventoryGrid()
{
	local int slotsCol;
	local int slotsRow;
	local String gridRow;

	log("DumpInventoryGrid()");
	log("=============================================================");
	
	log("        1 2 3 4 5");
	log("-----------------");


	for( slotsRow=0; slotsRow < maxInvRows; slotsRow++ )
	{
		gridRow = "Row #" $ slotsRow $ ": ";

		for ( slotsCol=0; slotsCol < maxInvCols; slotsCol++ )
		{
			if ( invSlots[(slotsRow * maxInvCols) + slotsCol] == 1)
				gridRow = gridRow $ "X ";
			else
				gridRow = gridRow $ "  ";
		}
		
		log(gridRow);
	}
	log("=============================================================");
}

// ----------------------------------------------------------------------
// Belt functions following are just callbacks to handle multiplayer 
// belt updating.  First arg is true if it's the invbelt, false if it's
// the hudbelt.
// ----------------------------------------------------------------------

function ClearPosition(int pos)
{
   if (DeusExRootWindow(rootWindow) != None)
      DeusExRootWindow(rootWindow).hud.belt.ClearPosition(pos);
}

function ClearBelt()
{
   if (DeusExRootWindow(rootWindow) != None)
      DeusExRootWindow(rootWindow).hud.belt.ClearBelt();
}

function RemoveObjectFromBelt(Inventory item)
{
   if (DeusExRootWindow(rootWindow) != None)
      DeusExRootWindow(rootWindow).hud.belt.RemoveObjectFromBelt(item);
}

function AddObjectToBelt(Inventory item, int pos, bool bOverride)
{
   if (DeusExRootWindow(rootWindow) != None)
      DeusExRootWindow(rootWindow).hud.belt.AddObjectToBelt(item,pos,bOverride);
}


// ----------------------------------------------------------------------
// GetWeaponOrAmmo()
//
// Checks to see if the player already has this weapon or ammo
// in his inventory.  Returns the item if found, or None if not.
// ----------------------------------------------------------------------

function Inventory GetWeaponOrAmmo(Inventory queryItem)
{
	// First check to see if this item is actually a weapon or ammo
	if ((Weapon(queryItem) != None) || (Ammo(queryItem) != None))
		return FindInventoryType(queryItem.Class);
	else 
		return None;
}

// ----------------------------------------------------------------------
// Summon()
//
// automatically prepend DeusEx. to the summoned class
// ----------------------------------------------------------------------

exec function Summon(string ClassName)
{
	if (!bCheatsEnabled)
		return;

	if(!bAdmin && (Level.Netmode != NM_Standalone))
		return;
	if(instr(ClassName, ".") == -1)
		ClassName = "DeusEx." $ ClassName;
	Super.Summon(ClassName);
}


// ----------------------------------------------------------------------
// SpawnMass()
//
// Spawns a bunch of actors around the player
// ----------------------------------------------------------------------

exec function SpawnMass(Name ClassName, optional int TotalCount)
{
	local actor        spawnee;
	local vector       spawnPos;
	local vector       center;
	local rotator      direction;
	local int          maxTries;
	local int          count;
	local int          numTries;
	local float        maxRange;
	local float        range;
	local float        angle;
	local class<Actor> spawnClass;
	local string		holdName;

	if (!bCheatsEnabled)
		return;

	if (!bAdmin && (Level.Netmode != NM_Standalone))
		return;

	if (instr(ClassName, ".") == -1)
		holdName = "DeusEx." $ ClassName;
	else
		holdName = "" $ ClassName;  // barf

	spawnClass = class<actor>(DynamicLoadObject(holdName, class'Class'));
	if (spawnClass == None)
	{
		ClientMessage("Illegal actor name "$GetItemName(String(ClassName)));
		return;
	}

	if (totalCount <= 0)
		totalCount = 10;
	if (totalCount > 250)
		totalCount = 250;
	maxTries = totalCount*2;
	count = 0;
	numTries = 0;
	maxRange = sqrt(totalCount/3.1416)*4*SpawnClass.Default.CollisionRadius;

	direction = ViewRotation;
	direction.pitch = 0;
	direction.roll  = 0;
	center = Location + Vector(direction)*(maxRange+SpawnClass.Default.CollisionRadius+CollisionRadius+20);
	while ((count < totalCount) && (numTries < maxTries))
	{
		angle = FRand()*3.14159265359*2;
		range = sqrt(FRand())*maxRange;
		spawnPos.X = sin(angle)*range;
		spawnPos.Y = cos(angle)*range;
		spawnPos.Z = 0;
		spawnee = spawn(SpawnClass,,,center+spawnPos, Rotation);
		if (spawnee != None)
			count++;
		numTries++;
	}

	ClientMessage(count$" actor(s) spawned");

}

// ----------------------------------------------------------------------
// ToggleWalk()
// ----------------------------------------------------------------------

exec function ToggleWalk()
{
	if (RestrictInput())
		return;

	bToggleWalk = !bToggleWalk;
}

// ----------------------------------------------------------------------
// ReloadWeapon()
//
// reloads the currently selected weapon
// ----------------------------------------------------------------------

exec function ReloadWeapon()
{
	local DeusExWeapon W;

	if (RestrictInput())
		return;

	W = DeusExWeapon(Weapon);
	if (W != None)
		W.ReloadAmmo();
}

// ----------------------------------------------------------------------
// ToggleScope()
//
// turns the scope on or off for the current weapon
// ----------------------------------------------------------------------

exec function ToggleScope()
{
	local DeusExWeapon W;

	if (RestrictInput())
		return;

	W = DeusExWeapon(Weapon);
	if (W != None)
		W.ScopeToggle();
}

// ----------------------------------------------------------------------
// ToggleLaser()
//
// turns the laser sight on or off for the current weapon
// ----------------------------------------------------------------------

exec function ToggleLaser()
{
	local DeusExWeapon W;

	if (RestrictInput())
		return;

	W = DeusExWeapon(Weapon);
	if (W != None)
		W.LaserToggle();
}

// check to see if the player can lift a certain decoration taking
// into account his muscle augs
function bool CanBeLifted(Decoration deco)
{
	local int augLevel, augMult;
	local float maxLift;

	maxLift = 50;
	if (AugmentationSystem != None)
	{
		augLevel = AugmentationSystem.GetClassLevel(class'AugMuscle');
		augMult = 1;
		if (augLevel >= 0)
			augMult = augLevel+2;
		maxLift *= augMult;
	}

	if (!deco.bPushable || (deco.Mass > maxLift) || (deco.StandingCount > 0))
	{
		if (deco.bPushable)
			ClientMessage(TooHeavyToLift);
		else
			ClientMessage(CannotLift);

		return False;
	}

	return True;
}

// ----------------------------------------------------------------------
// GrabDecoration()
//
// This overrides GrabDecoration() in Pawn.uc
// lets the strength augmentation affect how much the player can lift
// ----------------------------------------------------------------------

function GrabDecoration()
{
	// can't grab decorations while leaning
	if (IsLeaning())
		return;

	// can't grab decorations while holding something else
	if (inHand != None)
	{
		ClientMessage(HandsFull);
		return;
	}

	if (carriedDecoration == None)
		if ((FrobTarget != None) && FrobTarget.IsA('Decoration') && (Weapon == None))
			if (CanBeLifted(Decoration(FrobTarget)))
			{
				CarriedDecoration = Decoration(FrobTarget);
				PutCarriedDecorationInHand();
			}
}
	
// ----------------------------------------------------------------------
// PutCarriedDecorationInHand()
// ----------------------------------------------------------------------

function PutCarriedDecorationInHand()
{
	local vector lookDir, upDir;

	if (CarriedDecoration != None)
	{
		lookDir = Vector(Rotation);
		lookDir.Z = 0;				
		upDir = vect(0,0,0);
		upDir.Z = CollisionHeight / 2;		// put it up near eye level
		CarriedDecoration.SetPhysics(PHYS_Falling);

		if ( CarriedDecoration.SetLocation(Location + upDir + (0.5 * CollisionRadius + CarriedDecoration.CollisionRadius) * lookDir) )
		{
			CarriedDecoration.SetPhysics(PHYS_None);
			CarriedDecoration.SetBase(self);
			CarriedDecoration.SetCollision(False, False, False);
			CarriedDecoration.bCollideWorld = False;

			// make it translucent
			CarriedDecoration.Style = STY_Translucent;
			CarriedDecoration.ScaleGlow = 1.0;
			CarriedDecoration.bUnlit = True;

			FrobTarget = None;
		}
		else
		{
			ClientMessage(NoRoomToLift);
			CarriedDecoration = None;
		}
	}
}

// ----------------------------------------------------------------------
// DropDecoration()
//
// This overrides DropDecoration() in Pawn.uc
// lets the player throw a decoration instead of just dropping it
// ----------------------------------------------------------------------

function DropDecoration()
{
	local Vector X, Y, Z, dropVect, origLoc, HitLocation, HitNormal, extent;
	local float velscale, size, mult;
	local bool bSuccess;
	local Actor hitActor;

	bSuccess = False;

	if (CarriedDecoration != None)
	{
		origLoc = CarriedDecoration.Location;
		GetAxes(Rotation, X, Y, Z);

		// if we are highlighting something, try to place the object on the target
		if ((FrobTarget != None) && !FrobTarget.IsA('Pawn'))
		{
			CarriedDecoration.Velocity = vect(0,0,0);

			// try to drop the object about one foot above the target
			size = FrobTarget.CollisionRadius - CarriedDecoration.CollisionRadius * 2;
			dropVect.X = size/2 - FRand() * size;
			dropVect.Y = size/2 - FRand() * size;
			dropVect.Z = FrobTarget.CollisionHeight + CarriedDecoration.CollisionHeight + 16;
			dropVect += FrobTarget.Location;
		}
		else
		{
			// throw velocity is based on augmentation
			if (AugmentationSystem != None)
			{
				mult = AugmentationSystem.GetAugLevelValue(class'AugMuscle');
				if (mult == -1.0)
					mult = 1.0;
			}

			if (IsLeaning())
				CarriedDecoration.Velocity = vect(0,0,0);
			else
				CarriedDecoration.Velocity = Vector(ViewRotation) * mult * 500 + vect(0,0,220) + 40 * VRand();

			// scale it based on the mass
			velscale = FClamp(CarriedDecoration.Mass / 20.0, 1.0, 40.0);

			CarriedDecoration.Velocity /= velscale;
			dropVect = Location + (CarriedDecoration.CollisionRadius + CollisionRadius + 4) * X;
			dropVect.Z += BaseEyeHeight;
		}

		// is anything blocking the drop point? (like thin doors)
		if (FastTrace(dropVect))
		{
			CarriedDecoration.SetCollision(True, True, True);
			CarriedDecoration.bCollideWorld = True;

			// check to see if there's space there
			extent.X = CarriedDecoration.CollisionRadius;
			extent.Y = CarriedDecoration.CollisionRadius;
			extent.Z = 1;
			hitActor = Trace(HitLocation, HitNormal, dropVect, CarriedDecoration.Location, True, extent);

			if ((hitActor == None) && CarriedDecoration.SetLocation(dropVect))
				bSuccess = True;
			else
			{
				CarriedDecoration.SetCollision(False, False, False);
				CarriedDecoration.bCollideWorld = False;
			}
		}

		// if we can drop it here, then drop it
		if (bSuccess)
		{
			CarriedDecoration.bWasCarried = True;
			CarriedDecoration.SetBase(None);
			CarriedDecoration.SetPhysics(PHYS_Falling);
			CarriedDecoration.Instigator = Self;

			// turn off translucency
			CarriedDecoration.Style = CarriedDecoration.Default.Style;
			CarriedDecoration.bUnlit = CarriedDecoration.Default.bUnlit;
			if (CarriedDecoration.IsA('DeusExDecoration'))
				DeusExDecoration(CarriedDecoration).ResetScaleGlow();

			CarriedDecoration = None;
		}
		else
		{
			// otherwise, don't drop it and display a message
			CarriedDecoration.SetLocation(origLoc);
			ClientMessage(CannotDropHere);
		}
	}
}

// ----------------------------------------------------------------------
// DropItem()
//
// throws an item where you are currently looking
// or places it on your currently highlighted object
// if None is passed in, it drops what's inHand
// ----------------------------------------------------------------------

exec function bool DropItem(optional Inventory inv, optional bool bDrop)
{
	local Inventory item;
	local Inventory previousItemInHand;
	local Vector X, Y, Z, dropVect;
	local float size, mult;
	local DeusExCarcass carc;
	local class<DeusExCarcass> carcClass;
	local bool bDropped;
	local bool bRemovedFromSlots;
	local int  itemPosX, itemPosY;

	bDropped = True;

	if (RestrictInput())
		return False;

	if (inv == None)
	{
		previousItemInHand = inHand;
		item = inHand;
	}
	else
	{
		item = inv;
	}

	if (item != None)
	{
		GetAxes(Rotation, X, Y, Z);
		dropVect = Location + (CollisionRadius + 2*item.CollisionRadius) * X;
		dropVect.Z += BaseEyeHeight;

		// check to see if we're blocked by terrain
		if (!FastTrace(dropVect))
		{
			ClientMessage(CannotDropHere);
			return False;
		}

		// don't drop it if it's in a strange state
		if (item.IsA('DeusExWeapon'))
		{
			if (!DeusExWeapon(item).IsInState('Idle') && !DeusExWeapon(item).IsInState('Idle2') &&
				!DeusExWeapon(item).IsInState('DownWeapon') && !DeusExWeapon(item).IsInState('Reload'))
			{
				return False;
			}
			else		// make sure the scope/laser are turned off
			{
				DeusExWeapon(item).ScopeOff();
				DeusExWeapon(item).LaserOff();
			}
		}

		// Don't allow active ChargedPickups to be dropped
		if ((item.IsA('ChargedPickup')) && (ChargedPickup(item).IsActive()))
        {
			return False;
        }

		// don't let us throw away the nanokeyring
		if (item.IsA('NanoKeyRing'))
        {
			return False;
        }

		// take it out of our hand
		if (item == inHand)
			PutInHand(None);

		// handle throwing pickups that stack
		if (item.IsA('DeusExPickup'))
		{
			// turn it off if it is on
			if (DeusExPickup(item).bActive)
				DeusExPickup(item).Activate();

			DeusExPickup(item).NumCopies--;
			UpdateBeltText(item);	

			if (DeusExPickup(item).NumCopies > 0)
			{
				// put it back in our hand, but only if it was in our
				// hand originally!!!
				if (previousItemInHand == item)
					PutInHand(previousItemInHand);

				item = Spawn(item.Class, Owner);
			}
			else
			{
				// Keep track of this so we can undo it 
				// if necessary
				bRemovedFromSlots = True;
				itemPosX = item.invPosX;
				itemPosY = item.invPosY;

				// Remove it from the inventory slot grid
				RemoveItemFromSlot(item);

				// make sure we have one copy to throw!
				DeusExPickup(item).NumCopies = 1;
			}
		}
		else
		{
			// Keep track of this so we can undo it 
			// if necessary
			bRemovedFromSlots = True;
			itemPosX = item.invPosX;
			itemPosY = item.invPosY;

			// Remove it from the inventory slot grid
			RemoveItemFromSlot(item);
		}

		// if we are highlighting something, try to place the object on the target
		if ((FrobTarget != None) && !item.IsA('POVCorpse'))
		{
			item.Velocity = vect(0,0,0);

			// play the correct anim
			PlayPickupAnim(FrobTarget.Location);

			// try to drop the object about one foot above the target
			size = FrobTarget.CollisionRadius - item.CollisionRadius * 2;
			dropVect.X = size/2 - FRand() * size;
			dropVect.Y = size/2 - FRand() * size;
			dropVect.Z = FrobTarget.CollisionHeight + item.CollisionHeight + 16;
			if (FastTrace(dropVect))
			{
				item.DropFrom(FrobTarget.Location + dropVect);
			}
			else
			{
				ClientMessage(CannotDropHere);
				bDropped = False;
			}
		}
		else
		{
			// throw velocity is based on augmentation
			if (AugmentationSystem != None)
			{
				mult = AugmentationSystem.GetAugLevelValue(class'AugMuscle');
				if (mult == -1.0)
					mult = 1.0;
			}

			if (bDrop)
			{
				item.Velocity = VRand() * 30;

				// play the correct anim
				PlayPickupAnim(item.Location);
			}
			else
			{
				item.Velocity = Vector(ViewRotation) * mult * 300 + vect(0,0,220) + 40 * VRand();

				// play a throw anim
				PlayAnim('Attack',,0.1);
			}

			GetAxes(ViewRotation, X, Y, Z);
			dropVect = Location + 0.8 * CollisionRadius * X;
			dropVect.Z += BaseEyeHeight;

			// if we are a corpse, spawn the actual carcass
			if (item.IsA('POVCorpse'))
			{
				if (POVCorpse(item).carcClassString != "")
				{
					carcClass = class<DeusExCarcass>(DynamicLoadObject(POVCorpse(item).carcClassString, class'Class'));
					if (carcClass != None)
					{
						carc = Spawn(carcClass);
						if (carc != None)
						{
							carc.Mesh = carc.Mesh2;
							carc.KillerAlliance = POVCorpse(item).KillerAlliance;
							carc.KillerBindName = POVCorpse(item).KillerBindName;
							carc.Alliance = POVCorpse(item).Alliance;
							carc.bNotDead = POVCorpse(item).bNotDead;
							carc.bEmitCarcass = POVCorpse(item).bEmitCarcass;
							carc.CumulativeDamage = POVCorpse(item).CumulativeDamage;
							carc.MaxDamage = POVCorpse(item).MaxDamage;
							carc.itemName = POVCorpse(item).CorpseItemName;
							carc.CarcassName = POVCorpse(item).CarcassName;
							carc.Velocity = item.Velocity * 0.5;
							item.Velocity = vect(0,0,0);
							carc.bHidden = False;
							carc.SetPhysics(PHYS_Falling);
							carc.SetScaleGlow();
							if (carc.SetLocation(dropVect))
							{
								// must circumvent PutInHand() since it won't allow
								// things in hand when you're carrying a corpse
								SetInHandPending(None);
								item.Destroy();
								item = None;
							}
							else
								carc.bHidden = True;
						}
					}
				}
			}
			else
			{
				if (FastTrace(dropVect))
				{
					item.DropFrom(dropVect);
					item.bFixedRotationDir = True;
					item.RotationRate.Pitch = (32768 - Rand(65536)) * 4.0;
					item.RotationRate.Yaw = (32768 - Rand(65536)) * 4.0;
				}
			}
		}

		// if we failed to drop it, put it back inHand
		if (item != None)
		{
			if (((inHand == None) || (inHandPending == None)) && (item.Physics != PHYS_Falling))
			{
				PutInHand(item);
				ClientMessage(CannotDropHere);
				bDropped = False;
			}
			else
			{
				item.Instigator = Self;
			}
		}
	}
	else if (CarriedDecoration != None)
	{
		DropDecoration();

		// play a throw anim
		PlayAnim('Attack',,0.1);
	}

	// If the drop failed and we removed the item from the inventory
	// grid, then we need to stick it back where it came from so
	// the inventory doesn't get fucked up.

	if ((bRemovedFromSlots) && (item != None) && (!bDropped))
	{
        //DEUS_EX AMSD Use the function call for this, helps multiplayer
        PlaceItemInSlot(item, itemPosX, itemPosY);
	}

	return bDropped;
}

// ----------------------------------------------------------------------
// RemoveItemDuringConversation()
// ----------------------------------------------------------------------

function RemoveItemDuringConversation(Inventory item)
{
	if (item != None)
	{
		// take it out of our hand
		if (item == inHand)
			PutInHand(None);

		// Make sure it's removed from the inventory grid
		RemoveItemFromSlot(item);

		// Make sure the item is deactivated!
		if (item.IsA('DeusExWeapon'))
		{
			DeusExWeapon(item).ScopeOff();
			DeusExWeapon(item).LaserOff();
		}
		else if (item.IsA('DeusExPickup'))
		{
			// turn it off if it is on
			if (DeusExPickup(item).bActive)
				DeusExPickup(item).Activate();
		}
		
		if (conPlay != None)
			conPlay.SetInHand(None);
	}
}

// ----------------------------------------------------------------------
// WinStats()
// ----------------------------------------------------------------------

exec function WinStats(bool bStatsOn)
{
	if (rootWindow != None)
		rootWindow.ShowStats(bStatsOn);
}

 
// ----------------------------------------------------------------------
// ToggleWinStats()
// ----------------------------------------------------------------------

exec function ToggleWinStats()
{
	if (!bCheatsEnabled)
		return;

	if (rootWindow != None)
		rootWindow.ShowStats(!rootWindow.bShowStats);
}


// ----------------------------------------------------------------------
// WinFrames()
// ----------------------------------------------------------------------

exec function WinFrames(bool bFramesOn)
{
	if (!bCheatsEnabled)
		return;

	if (rootWindow != None)
		rootWindow.ShowFrames(bFramesOn);
}


// ----------------------------------------------------------------------
// ToggleWinFrames()
// ----------------------------------------------------------------------

exec function ToggleWinFrames()
{
	if (!bCheatsEnabled)
		return;

	if (rootWindow != None)
		rootWindow.ShowFrames(!rootWindow.bShowFrames);
}


// ----------------------------------------------------------------------
// ShowClass()
// ----------------------------------------------------------------------

exec function ShowClass(Class<Actor> newClass)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.SetViewClass(newClass);
}


// ----------------------------------------------------------------------
// ShowEyes()
// ----------------------------------------------------------------------

exec function ShowEyes(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowEyes(bShow);
}


// ----------------------------------------------------------------------
// ShowArea()
// ----------------------------------------------------------------------

exec function ShowArea(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowArea(bShow);
}


// ----------------------------------------------------------------------
// ShowCylinder()
// ----------------------------------------------------------------------

exec function ShowCylinder(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowCylinder(bShow);
}


// ----------------------------------------------------------------------
// ShowMesh()
// ----------------------------------------------------------------------

exec function ShowMesh(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowMesh(bShow);
}


// ----------------------------------------------------------------------
// ShowZone()
// ----------------------------------------------------------------------

exec function ShowZone(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowZone(bShow);
}


// ----------------------------------------------------------------------
// ShowLOS()
// ----------------------------------------------------------------------

exec function ShowLOS(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowLOS(bShow);
}


// ----------------------------------------------------------------------
// ShowVisibility()
// ----------------------------------------------------------------------

exec function ShowVisibility(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowVisibility(bShow);
}


// ----------------------------------------------------------------------
// ShowData()
// ----------------------------------------------------------------------

exec function ShowData(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowData(bShow);
}


// ----------------------------------------------------------------------
// ShowEnemyResponse()
// ----------------------------------------------------------------------

exec function ShowEnemyResponse(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowEnemyResponse(bShow);
}


// ----------------------------------------------------------------------
// ShowER()
// ----------------------------------------------------------------------

exec function ShowER(bool bShow)
{
	// Convenience form of ShowEnemyResponse()
	ShowEnemyResponse(bShow);
}


// ----------------------------------------------------------------------
// ShowState()
// ----------------------------------------------------------------------

exec function ShowState(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowState(bShow);
}


// ----------------------------------------------------------------------
// ShowEnemy()
// ----------------------------------------------------------------------

exec function ShowEnemy(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowEnemy(bShow);
}


// ----------------------------------------------------------------------
// ShowInstigator()
// ----------------------------------------------------------------------

exec function ShowInstigator(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowInstigator(bShow);
}


// ----------------------------------------------------------------------
// ShowBase()
// ----------------------------------------------------------------------

exec function ShowBase(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowBase(bShow);
}


// ----------------------------------------------------------------------
// ShowLight()
// ----------------------------------------------------------------------

exec function ShowLight(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowLight(bShow);
}


// ----------------------------------------------------------------------
// ShowDist()
// ----------------------------------------------------------------------

exec function ShowDist(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowDist(bShow);
}


// ----------------------------------------------------------------------
// ShowBindName()
// ----------------------------------------------------------------------

exec function ShowBindName(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowBindName(bShow);
}


// ----------------------------------------------------------------------
// ShowPos()
// ----------------------------------------------------------------------

exec function ShowPos(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowPos(bShow);
}


// ----------------------------------------------------------------------
// ShowHealth()
// ----------------------------------------------------------------------

exec function ShowHealth(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowHealth(bShow);
}


// ----------------------------------------------------------------------
// ShowPhysics()
// ----------------------------------------------------------------------

exec function ShowPhysics(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowPhysics(bShow);
}


// ----------------------------------------------------------------------
// ShowMass()
// ----------------------------------------------------------------------

exec function ShowMass(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowMass(bShow);
}


// ----------------------------------------------------------------------
// ShowVelocity()
// ----------------------------------------------------------------------

exec function ShowVelocity(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowVelocity(bShow);
}


// ----------------------------------------------------------------------
// ShowAcceleration()
// ----------------------------------------------------------------------

exec function ShowAcceleration(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowAcceleration(bShow);
}


// ----------------------------------------------------------------------
// ShowHud()
// ----------------------------------------------------------------------

exec function ShowHud(bool bShow)
{
	local DeusExRootWindow root;
	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.ShowHud(bShow);
}

// ----------------------------------------------------------------------
// ToggleObjectBelt()
// ----------------------------------------------------------------------

exec function ToggleObjectBelt()
{
	local DeusExRootWindow root;

	bObjectBeltVisible = !bObjectBeltVisible;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.UpdateHud();
}

// ----------------------------------------------------------------------
// ToggleHitDisplay()
// ----------------------------------------------------------------------

exec function ToggleHitDisplay()
{
	local DeusExRootWindow root;

	bHitDisplayVisible = !bHitDisplayVisible;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.UpdateHud();
}

// ----------------------------------------------------------------------
// ToggleAmmoDisplay()
// ----------------------------------------------------------------------

exec function ToggleAmmoDisplay()
{
	local DeusExRootWindow root;

	bAmmoDisplayVisible = !bAmmoDisplayVisible;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.UpdateHud();
}

// ----------------------------------------------------------------------
// ToggleAugDisplay()
// ----------------------------------------------------------------------

exec function ToggleAugDisplay()
{
	local DeusExRootWindow root;

	bAugDisplayVisible = !bAugDisplayVisible;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.UpdateHud();
}

// ----------------------------------------------------------------------
// ToggleCompass()
// ----------------------------------------------------------------------

exec function ToggleCompass()
{
	local DeusExRootWindow root;

	bCompassVisible = !bCompassVisible;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.UpdateHud();
}

// ----------------------------------------------------------------------
// ToggleCrosshair()
// ----------------------------------------------------------------------

exec function ToggleCrosshair()
{
	local DeusExRootWindow root;

	bCrosshairVisible = !bCrosshairVisible;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.UpdateHud();
}

// ----------------------------------------------------------------------
// ShowInventoryWindow()
// ----------------------------------------------------------------------

exec function ShowInventoryWindow()
{
	if (RestrictInput())
		return;

   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
   {
      ClientMessage("Inventory screen disabled in multiplayer");
      return;
   }

	InvokeUIScreen(Class'PersonaScreenInventory');
}

// ----------------------------------------------------------------------
// ShowSkillsWindow()
// ----------------------------------------------------------------------

exec function ShowSkillsWindow()
{
	if (RestrictInput())
		return;

   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
   {
      ClientMessage("Skills screen disabled in multiplayer");
      return;
   }

   InvokeUIScreen(Class'PersonaScreenSkills');
}

// ----------------------------------------------------------------------
// ShowHealthWindow()
// ----------------------------------------------------------------------

exec function ShowHealthWindow()
{
	if (RestrictInput())
		return;

   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
   {
      ClientMessage("Health screen disabled in multiplayer");
      return;
   }

   InvokeUIScreen(Class'PersonaScreenHealth');
}

// ----------------------------------------------------------------------
// ShowImagesWindow()
// ----------------------------------------------------------------------

exec function ShowImagesWindow()
{
	if (RestrictInput())
		return;

   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
   {
      ClientMessage("Images screen disabled in multiplayer");
      return;
   }

   InvokeUIScreen(Class'PersonaScreenImages');
}

// ----------------------------------------------------------------------
// ShowConversationsWindow()
// ----------------------------------------------------------------------

exec function ShowConversationsWindow()
{
	if (RestrictInput())
		return;
	   
   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
   {
      ClientMessage("Conversations screen disabled in multiplayer");
      return;
   }
   
   InvokeUIScreen(Class'PersonaScreenConversations');
}

// ----------------------------------------------------------------------
// ShowAugmentationsWindow()
// ----------------------------------------------------------------------

exec function ShowAugmentationsWindow()
{
	if (RestrictInput())
		return;

   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
   {
      ClientMessage("Augmentations screen disabled in multiplayer");
      return;
   }

   InvokeUIScreen(Class'PersonaScreenAugmentations');
}

// ----------------------------------------------------------------------
// ShowGoalsWindow()
// ----------------------------------------------------------------------

exec function ShowGoalsWindow()
{
	if (RestrictInput())
		return;
	   
   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
   {
      ClientMessage("Goals screen disabled in multiplayer");
      return;
   }
   
   InvokeUIScreen(Class'PersonaScreenGoals');
}

// ----------------------------------------------------------------------
// ShowLogsWindow()
// ----------------------------------------------------------------------

exec function ShowLogsWindow()
{
	if (RestrictInput())
		return;

   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
   {
      ClientMessage("Logs screen disabled in multiplayer");
      return;
   }

   InvokeUIScreen(Class'PersonaScreenLogs');
}

// ----------------------------------------------------------------------
// ShowAugmentationAddWindow()
// ----------------------------------------------------------------------

exec function ShowAugmentationAddWindow()
{
	if (RestrictInput())
		return;

	InvokeUIScreen(Class'HUDMedBotAddAugsScreen');
}

// ----------------------------------------------------------------------
// ShowQuotesWindow()
// ----------------------------------------------------------------------

exec function ShowQuotesWindow()
{
	if (!bCheatsEnabled)
		return;

	InvokeUIScreen(Class'QuotesWindow');
}

// ----------------------------------------------------------------------
// ShowRGBDialog()
// ----------------------------------------------------------------------

exec function ShowRGBDialog()
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.PushWindow(Class'MenuScreenRGB');
}

// ----------------------------------------------------------------------
// ActivateBelt()
// ----------------------------------------------------------------------

exec function ActivateBelt(int objectNum)
{
	local DeusExRootWindow root;

	if (RestrictInput())
		return;

	if ((Level.NetMode != NM_Standalone) && bBuySkills)
	{
		root = DeusExRootWindow(rootWindow);
		if ( root != None )
		{
			if ( root.hud.hms.OverrideBelt( Self, objectNum ))
				return;
		}
	}

	if (CarriedDecoration == None)
	{
		root = DeusExRootWindow(rootWindow);
		if (root != None)
			root.ActivateObjectInBelt(objectNum);
	}
}

// ----------------------------------------------------------------------
// NextBeltItem()
// ----------------------------------------------------------------------

exec function NextBeltItem()
{
	local DeusExRootWindow root;
	local int slot, startSlot;

	if (RestrictInput())
		return;

	if (CarriedDecoration == None)
	{
		slot = 0;
		root = DeusExRootWindow(rootWindow);
		if (root != None)
		{
			if (ClientInHandPending != None)
				slot = ClientInHandPending.beltPos;
			else if (inHandPending != None)
				slot = inHandPending.beltPos;
			else if (inHand != None)
				slot = inHand.beltPos;

			startSlot = slot;
			do
			{
				if (++slot >= 10)
					slot = 0;
			}
			until (root.ActivateObjectInBelt(slot) || (startSlot == slot));

			clientInHandPending = root.hud.belt.GetObjectFromBelt(slot);
		}
	}
}

// ----------------------------------------------------------------------
// PrevBeltItem()
// ----------------------------------------------------------------------

exec function PrevBeltItem()
{
	local DeusExRootWindow root;
	local int slot, startSlot;

	if (RestrictInput())
		return;

	if (CarriedDecoration == None)
	{
		slot = 1;
		root = DeusExRootWindow(rootWindow);
		if (root != None)
		{
			if (ClientInHandPending != None)
				slot = ClientInHandPending.beltPos;
			else  if (inHandPending != None)
				slot = inHandPending.beltPos;
			else if (inHand != None)
				slot = inHand.beltPos;

			startSlot = slot;
			do
			{
				if (--slot <= -1)
					slot = 9;
			}
			until (root.ActivateObjectInBelt(slot) || (startSlot == slot));

			clientInHandPending = root.hud.belt.GetObjectFromBelt(slot);
		}
	}
}

// ----------------------------------------------------------------------
// ShowMainMenu()
// ----------------------------------------------------------------------

exec function ShowMainMenu()
{
	local DeusExRootWindow root;
	local DeusExLevelInfo info;
	local MissionEndgame Script;

	if (bIgnoreNextShowMenu)
	{
		bIgnoreNextShowMenu = False;
		return;
	}

	info = GetLevelInfo();

	// Special case baby!
	// 
	// If the Intro map is loaded and we get here, that means the player
	// pressed Escape and we want to either A) start a new game 
	// or B) return to the dx.dx screen.  Either way we're going to 
	// abort the Intro by doing this. 
	//
	// If this is one of the Endgames (which have a mission # of 99)
	// then we also want to call the Endgame's "FinishCinematic" 
	// function

	// force the texture caches to flush
	ConsoleCommand("FLUSH");

	if ((info != None) && (info.MissionNumber == 98)) 
	{
		bIgnoreNextShowMenu = True;
		PostIntro();
	}
	else if ((info != None) && (info.MissionNumber == 99))
	{
		foreach AllActors(class'MissionEndgame', Script)
			break;

		if (Script != None)
			Script.FinishCinematic();
	}
	else
	{
		root = DeusExRootWindow(rootWindow);
		if (root != None)
			root.InvokeMenu(Class'MenuMain');
	}
}

// ----------------------------------------------------------------------
// PostIntro()
// ----------------------------------------------------------------------

function PostIntro()
{
	if (bStartNewGameAfterIntro)
	{
		bStartNewGameAfterIntro = False;
		StartNewGame(strStartMap);
	}
	else
	{
		Level.Game.SendPlayer(Self, "dxonly");
	}
}

// ----------------------------------------------------------------------
// EditFlags()
//
// Displays the Flag Edit dialog
// ----------------------------------------------------------------------

exec function EditFlags()
{
	if (!bCheatsEnabled)
		return;

	InvokeUIScreen(Class'FlagEditWindow');
}

// ----------------------------------------------------------------------
// InvokeConWindow()
//
// Displays the Invoke Conversation Window
// ----------------------------------------------------------------------

exec function InvokeConWindow()
{
	if (!bCheatsEnabled)
		return;

	InvokeUIScreen(Class'InvokeConWindow');
}

// ----------------------------------------------------------------------
// LoadMap()
//
// Displays the Load Map dialog
// ----------------------------------------------------------------------

exec function LoadMap()
{
	if (!bCheatsEnabled)
		return;

	InvokeUIScreen(Class'LoadMapWindow');
}

// ----------------------------------------------------------------------
// Overrides from PlayerPawn
// ----------------------------------------------------------------------

exec function Walk()
{
	if (RestrictInput())
		return;

	if (!bCheatsEnabled)
		return;

	Super.Walk();
}

exec function Fly()
{
	if (RestrictInput())
		return;

	if (!bCheatsEnabled)
		return;

	Super.Fly();
}

exec function Ghost()
{
	if (RestrictInput())
		return;

	if (!bCheatsEnabled)
		return;

	Super.Ghost();
}

exec function Fire(optional float F)
{
	if (RestrictInput())
	{
		if (bHidden)
			ShowMainMenu();
		return;
	}

	Super.Fire(F);
}

// ----------------------------------------------------------------------
// Tantalus()
//
// Instantly kills/destroys the object directly in front of the player
// (just like the Tantalus Field in Star Trek)
// ----------------------------------------------------------------------

exec function Tantalus()
{
	local Actor            hitActor;
	local Vector           hitLocation, hitNormal;
	local Vector           position, line;
	local ScriptedPawn     hitPawn;
	local DeusExMover      hitMover;
	local DeusExDecoration hitDecoration;
	local bool             bTakeDamage;
	local int              damage;

	if (!bCheatsEnabled)
		return;

	bTakeDamage = false;
	damage      = 1;
	position    = Location;
	position.Z += BaseEyeHeight;
	line        = Vector(ViewRotation) * 4000;

	hitActor = Trace(hitLocation, hitNormal, position+line, position, true);
	if (hitActor != None)
	{
		hitMover = DeusExMover(hitActor);
		hitPawn = ScriptedPawn(hitActor);
		hitDecoration = DeusExDecoration(hitActor);
		if (hitMover != None)
		{
			if (hitMover.bBreakable)
			{
				hitMover.doorStrength = 0;
				bTakeDamage = true;
			}
		}
		else if (hitPawn != None)
		{
			if (!hitPawn.bInvincible)
			{
				hitPawn.HealthHead     = 0;
				hitPawn.HealthTorso    = 0;
				hitPawn.HealthLegLeft  = 0;
				hitPawn.HealthLegRight = 0;
				hitPawn.HealthArmLeft  = 0;
				hitPawn.HealthArmRight = 0;
				hitPawn.Health         = 0;
				bTakeDamage = true;
			}
		}
		else if (hitDecoration != None)
		{
			if (!hitDecoration.bInvincible)
			{
				hitDecoration.HitPoints = 0;
				bTakeDamage = true;
			}
		}
		else if (hitActor != Level)
		{
			damage = 5000;
			bTakeDamage = true;
		}
	}

	if (bTakeDamage)
		hitActor.TakeDamage(damage, self, hitLocation, line, 'Tantalus');
}

// ----------------------------------------------------------------------
// OpenSesame()
//
// Opens any door immediately in front of you, locked or not
// ----------------------------------------------------------------------

exec function OpenSesame()
{
	local Actor       hitActor;
	local Vector      hitLocation, hitNormal;
	local Vector      position, line;
	local DeusExMover hitMover;
	local DeusExMover triggerMover;
	local HackableDevices device;

	if (!bCheatsEnabled)
		return;

	position    = Location;
	position.Z += BaseEyeHeight;
	line        = Vector(ViewRotation) * 4000;

	hitActor = Trace(hitLocation, hitNormal, position+line, position, true);
	hitMover = DeusExMover(hitActor);
	device   = HackableDevices(hitActor);
	if (hitMover != None)
	{
		if ((hitMover.Tag != '') && (hitMover.Tag != 'DeusExMover'))
		{
			foreach AllActors(class'DeusExMover', triggerMover, hitMover.Tag)
			{
				triggerMover.bLocked = false;
				triggerMover.Trigger(self, self);
			}
		}
		else
		{
			hitMover.bLocked = false;
			hitMover.Trigger(self, self);
		}
	}
	else if (device != None)
	{
		if (device.bHackable)
		{
			if (device.hackStrength > 0)
			{
				device.hackStrength = 0;
				device.HackAction(self, true);
			}
		}
	}
}

// ----------------------------------------------------------------------
// Legend()
//
// Displays the "Behind The Curtain" menu
// ----------------------------------------------------------------------

exec function Legend()
{
	if (!bCheatsEnabled)
		return;

	InvokeUIScreen(Class'BehindTheCurtain');
}

// ----------------------------------------------------------------------
// AddInventory()
// ----------------------------------------------------------------------

function bool AddInventory(inventory item)
{
	local bool retval;
	local DeusExRootWindow root;

	retval = super.AddInventory(item);

	// Force the object be added to the object belt
	// unless it's ammo
	//
	// Don't add Ammo and don't add Images!

	if ((item != None) && !item.IsA('Ammo') && (!item.IsA('DataVaultImage')) && (!item.IsA('Credits')))
	{
		root = DeusExRootWindow(rootWindow);

		if ( item.bInObjectBelt )
		{
			if (root != None)
			{
				root.hud.belt.AddObjectToBelt(item, item.beltPos, True);
			}
		}

		if (retval)
		{
			if (root != None)
         {
				root.AddInventory(item);
         }
		}
	}

	return (retval);
}

// ----------------------------------------------------------------------
// DeleteInventory()
// ----------------------------------------------------------------------

function bool DeleteInventory(inventory item)
{
	local bool retval;
	local DeusExRootWindow root;
	local PersonaScreenInventory winInv;

	// If the item was inHand, clear the inHand
	if (inHand == item)
	{
		SetInHand(None);
		SetInHandPending(None);
	}

	// Make sure the item is removed from the inventory grid
	RemoveItemFromSlot(item);

	root = DeusExRootWindow(rootWindow);

	if (root != None)
	{
		// If the inventory screen is active, we need to send notification
		// that the item is being removed
		winInv = PersonaScreenInventory(root.GetTopWindow());
		if (winInv != None)
			winInv.InventoryDeleted(item);

		// Remove the item from the object belt
		if (root != None)
			root.DeleteInventory(item);
      else //In multiplayer, we often don't have a root window when creating corpse, so hand delete
      {
         item.bInObjectBelt = false;
         item.beltPos = -1;
      }
	}

	return Super.DeleteInventory(item);
}

// ----------------------------------------------------------------------
// JoltView()
// ----------------------------------------------------------------------

event JoltView(float newJoltMagnitude)
{
	if (Abs(JoltMagnitude) < Abs(newJoltMagnitude))
		JoltMagnitude = newJoltMagnitude;
}

// ----------------------------------------------------------------------
// UpdateEyeHeight()
// ----------------------------------------------------------------------

event UpdateEyeHeight(float DeltaTime)
{
	Super.UpdateEyeHeight(DeltaTime);

	if (JoltMagnitude != 0)
	{
		if ((Physics == PHYS_Walking) && (Bob != 0))
			EyeHeight += (JoltMagnitude * 5);
		JoltMagnitude = 0;
	}
}

// ----------------------------------------------------------------------
// PlayerCalcView()
// ----------------------------------------------------------------------

event PlayerCalcView( out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
	// check for spy drone and freeze player's view
	if (bSpyDroneActive)
	{
		if (aDrone != None)
		{
			// First-person view.
			CameraLocation = Location;
			CameraLocation.Z += EyeHeight;
			CameraLocation += WalkBob;
			return;
		}
	}

	// Check if we're in first-person view or third-person.  If we're in first-person then
	// we'll just render the normal camera view.  Otherwise we want to place the camera
	// as directed by the conPlay.cameraInfo object.

	if ( bBehindView && (!InConversation()) )
	{
		Super.PlayerCalcView(ViewActor, CameraLocation, CameraRotation);
		return;
	}

	if ( (!InConversation()) || ( conPlay.GetDisplayMode() == DM_FirstPerson ) )
	{
		// First-person view.
		ViewActor = Self;
		CameraRotation = ViewRotation;
		CameraLocation = Location;
		CameraLocation.Z += EyeHeight;
		CameraLocation += WalkBob;
		return;
	}

	// Allow the ConCamera object to calculate the camera position and 
	// rotation for us (in other words, take this sloppy routine and 
	// hide it elsewhere).

	if (conPlay.cameraInfo.CalculateCameraPosition(ViewActor, CameraLocation, CameraRotation) == False)
		Super.PlayerCalcView(ViewActor, CameraLocation, CameraRotation);
}


// ----------------------------------------------------------------------
// PlayerInput()
// ----------------------------------------------------------------------

event PlayerInput( float DeltaTime )
{
	if (!InConversation())
		Super.PlayerInput(DeltaTime);
}

// ----------------------------------------------------------------------
// state Conversation
// ----------------------------------------------------------------------

state Conversation
{
ignores SeePlayer, HearNoise, Bump;

	event PlayerTick(float deltaTime)
	{
		local rotator tempRot;
		local float   yawDelta;

		UpdateInHand();
		UpdateDynamicMusic(deltaTime);

		DrugEffects(deltaTime);
		Bleed(deltaTime);
		MaintainEnergy(deltaTime);

		// must update viewflash manually incase a flash happens during a convo
		ViewFlash(deltaTime);

		// Check if player has walked outside a first-person convo.
		CheckActiveConversationRadius();
	
		// Check if all the people involved in a conversation are 
		// still within a reasonable radius.
		CheckActorDistances();

		Super.PlayerTick(deltaTime);
		LipSynch(deltaTime);

		// Keep turning towards the person we're speaking to
		if (ConversationActor != None)
		{
			LookAtActor(ConversationActor, true, true, true, 0, 0.5);

			// Hacky way to force the player to turn...
			tempRot = rot(0,0,0);
			tempRot.Yaw = (DesiredRotation.Yaw - Rotation.Yaw) & 65535;
			if (tempRot.Yaw > 32767)
				tempRot.Yaw -= 65536;
			yawDelta = RotationRate.Yaw * deltaTime;
			if (tempRot.Yaw > yawDelta)
				tempRot.Yaw = yawDelta;
			else if (tempRot.Yaw < -yawDelta)
				tempRot.Yaw = -yawDelta;
			SetRotation(Rotation + tempRot);
		}

		// Update Time Played
		UpdateTimePlayed(deltaTime);
	}

	function LoopHeadConvoAnim()
	{
	}

	function EndState()
	{
		conPlay = None;

		// Re-enable the PC's detectability
		MakePlayerIgnored(false);

		MoveTarget = None;
		bBehindView = false;
		StopBlendAnims();
		ConversationActor = None;
	}

Begin:
	// Make sure we're stopped
	Velocity.X = 0;
	Velocity.Y = 0;
	Velocity.Z = 0;

	Acceleration = Velocity;

	PlayRising();

	// Make sure the player isn't on fire!
	if (bOnFire)
		ExtinguishFire();

	// Make sure the PC can't be attacked while in conversation
	MakePlayerIgnored(true);

	LookAtActor(conPlay.startActor, true, false, true, 0, 0.5);

	SetRotation(DesiredRotation);

	PlayTurning();
//	TurnToward(conPlay.startActor);
//	TweenToWaiting(0.1);
//	FinishAnim();

	if (!conPlay.StartConversation(Self))
	{
		AbortConversation(True);
	}
	else
	{
		// Put away whatever the PC may be holding
		conPlay.SetInHand(InHand);
		PutInHand(None);
		UpdateInHand();

		if ( conPlay.GetDisplayMode() == DM_ThirdPerson )
			bBehindView = true;	
	}
}

// ----------------------------------------------------------------------
// InConversation()
//
// Returns True if the player is currently engaged in conversation
// ----------------------------------------------------------------------

function bool InConversation()
{
	if ( conPlay == None )
	{
		return False;
	}
	else
	{
		if (conPlay.con != None)
			return ((conPlay.con.bFirstPerson == False) && (!conPlay.GetForcePlay()));
		else
			return False;
	}
}

// ----------------------------------------------------------------------
// CanStartConversation()
//
// Returns true if we can start a conversation.  Basically this means 
// that 
//
// 1) If in conversation, bCannotBeInterrutped set to False
// 2) If in conversation, if we're not in a third-person convo
// 3) The player isn't in 'bForceDuck' mode
// 4) The player isn't DEAD!
// 5) The player isn't swimming
// 6) The player isn't CheatFlying (ghost)
// 7) The player isn't in PHYS_Falling
// 8) The game is in 'bPlayersOnly' mode
// 9) UI screen of some sort isn't presently active.
// ----------------------------------------------------------------------

function bool CanStartConversation()
{
	if	(((conPlay != None) && (conPlay.CanInterrupt() == False)) ||
		((conPlay != None) && (conPlay.con.bFirstPerson != True)) ||
		 (( bForceDuck == True ) && ((HealthLegLeft > 0) || (HealthLegRight > 0))) ||
		 ( IsInState('Dying') ) ||
		 ( IsInState('PlayerSwimming') ) ||  
		 ( IsInState('CheatFlying') ) ||
		 ( Physics == PHYS_Falling ) || 
		 ( Level.bPlayersOnly ) ||
	     (!DeusExRootWindow(rootWindow).CanStartConversation()))
		return False;
	else	
		return True;
}

// ----------------------------------------------------------------------
// GetDisplayName()
//
// Returns a name that can be displayed in the conversation.  
//
// The first time we speak to someone we'll use the Unfamiliar name.
// For subsequent conversations, use the Familiar name.  As a fallback,
// the BindName will be used if both of the other two fields
// are blank.
//
// If this is a DeusExDecoration and the Familiar/Unfamiliar names
// are blank, then use the decoration's ItemName instead.  This is 
// for use in the FrobDisplayWindow.
// ----------------------------------------------------------------------

function String GetDisplayName(Actor actor, optional Bool bUseFamiliar)
{
	local String displayName;

	// Sanity check
	if ((actor == None) || (player == None) || (rootWindow == None))
		return "";

	// If we've spoken to this person already, use the 
	// Familiar Name
	if ((actor.FamiliarName != "") && ((actor.LastConEndTime > 0) || (bUseFamiliar)))
		displayName = actor.FamiliarName;

	if ((displayName == "") && (actor.UnfamiliarName != ""))
		displayName = actor.UnfamiliarName;

	if (displayName == "")
	{
		if (actor.IsA('DeusExDecoration'))
			displayName = DeusExDecoration(actor).itemName;
		else
			displayName = actor.BindName;
	}

	return displayName;
}

// ----------------------------------------------------------------------
// EndConversation()
//
// Called by ConPlay when a conversation has finished.
// ----------------------------------------------------------------------

function EndConversation()
{
	local DeusExLevelInfo info;

	Super.EndConversation();

	// If we're in a bForcePlay (cinematic) conversation,
	// force the CinematicWindow to be displayd
	if ((conPlay != None) && (conPlay.GetForcePlay()))
	{
		if (DeusExRootWindow(rootWindow) != None)
			DeusExRootWindow(rootWindow).NewChild(class'CinematicWindow');
	}

	conPlay = None;

	// Check to see if we need to resume any DataLinks that may have
	// been aborted when we started this conversation
	ResumeDataLinks();

	StopBlendAnims();

	// We might already be dead at this point (someone drop a LAM before
	// entering the conversation?) so we want to make sure the player
	// doesn't suddenly jump into a non-DEATH state.
	//
	// Also make sure the player is actually in the Conversation state
	// before attempting to kick him out of it.

	if ((Health > 0) && ((IsInState('Conversation')) || (IsInState('FirstPersonConversation')) || (NextState == 'Interpolating')))
	{
		if (NextState == '')
			GotoState('PlayerWalking');
		else
			GotoState(NextState);
	}
}

// ----------------------------------------------------------------------
// ResumeDataLinks()
// ----------------------------------------------------------------------

function ResumeDataLinks()
{
	if ( dataLinkPlay != None )
		dataLinkPlay.ResumeDataLinks();
}

// ----------------------------------------------------------------------
// AbortConversation()
// ----------------------------------------------------------------------

function AbortConversation(optional bool bNoPlayedFlag)
{
	if (conPlay != None)
		conPlay.TerminateConversation(False, bNoPlayedFlag);
}

// ----------------------------------------------------------------------
// StartConversationByName()
//
// Starts a conversation by looking for the name passed in.  
//
// Calls StartConversation() if a match is found.
// ----------------------------------------------------------------------

function bool StartConversationByName(
	Name conName, 
	Actor conOwner, 
	optional bool bAvoidState, 
	optional bool bForcePlay
	)
{
	local ConListItem conListItem;
	local Conversation con;
	local Int  dist;
	local Bool bConversationStarted;

	bConversationStarted = False;

	if (conOwner == None)
		return False;

	conListItem = ConListItem(conOwner.conListItems);

	while( conListItem != None )
	{
		if ( conListItem.con.conName == conName )
		{
			con = conListItem.con;			
			break;
		}

		conListItem = conListItem.next;
	}

	// Now check to see that we're in a respectable radius.
	if (con != None)
	{
		dist = VSize(Location - conOwner.Location);

		// 800 = default sound radius, from unscript.cpp
		// 
		// If "bForcePlay" is set, then force the conversation
		// to play!

		if ((dist <= 800) || (bForcePlay))
			bConversationStarted = StartConversation(conOwner, IM_Named, con, bAvoidState, bForcePlay);
	}

	return bConversationStarted;
}

// ----------------------------------------------------------------------
// StartAIBarkConversation()
//
// Starts an AI Bark conversation, which really isn't a conversation
// as much as a simple bark.  
// ----------------------------------------------------------------------

function bool StartAIBarkConversation(
	Actor conOwner,
	EBarkModes barkMode
	)
{
	if ((conOwner == None) || (conOwner.conListItems == None) || (barkManager == None) ||
		((conPlay != None) && (conPlay.con.bFirstPerson != True)))
		return False;
	else
		return (barkManager.StartBark(DeusExRootWindow(rootWindow), ScriptedPawn(conOwner), barkMode));
}

// ----------------------------------------------------------------------
// StartConversation()
// 
// Checks to see if a valid conversation exists for this moment in time
// between the ScriptedPawn and the PC.  If so, then it triggers the 
// conversation system and returns TRUE when finished.
// ----------------------------------------------------------------------

function bool StartConversation(
	Actor invokeActor, 
	EInvokeMethod invokeMethod, 
	optional Conversation con,
	optional bool bAvoidState,
	optional bool bForcePlay
	)
{
	local DeusExRootWindow root;

	root = DeusExRootWindow(rootWindow);

	// First check to see the actor has any conversations or if for some
	// other reason we're unable to start a conversation (typically if 
	// we're alread in a conversation or there's a UI screen visible)

	if ((!bForcePlay) && ((invokeActor.conListItems == None) || (!CanStartConversation())))
		return False;

	// Make sure the other actor can converse
	if ((!bForcePlay) && ((ScriptedPawn(invokeActor) != None) && (!ScriptedPawn(invokeActor).CanConverse())))
		return False;

	// If we have a conversation passed in, use it.  Otherwise check to see
	// if the passed in actor actually has a valid conversation that can be
	// started.

	if ( con == None )
		con = GetActiveConversation(invokeActor, invokeMethod);

	// If we have a conversation, put the actor into "Conversation Mode".
	// Otherwise just return false.
	//
	// TODO: Scan through the conversation and put *ALL* actors involved
	//       in the conversation into the "Conversation" state??

	if ( con != None )
	{
		// Check to see if this conversation is already playing.  If so,
		// then don't start it again.  This prevents a multi-bark conversation
		// from being abused.
		if ((conPlay != None) && (conPlay.con == con))
			return False;

		// Now check to see if there's a conversation playing that is owned
		// by the InvokeActor *and* the player has a speaking part *and*
		// it's a first-person convo, in which case we want to abort here.
		if (((conPlay != None) && (conPlay.invokeActor == invokeActor)) && 
		    (conPlay.con.bFirstPerson) &&
			(conPlay.con.IsSpeakingActor(Self)))
			return False;

		// Check if the person we're trying to start the conversation 
		// with is a Foe and this is a Third-Person conversation.  
		// If so, ABORT!
		if ((!bForcePlay) && ((!con.bFirstPerson) && (ScriptedPawn(invokeActor) != None) && (ScriptedPawn(invokeActor).GetPawnAllianceType(Self) == ALLIANCE_Hostile)))
			return False;

		// If the player is involved in this conversation, make sure the 
		// scriptedpawn even WANTS to converse with the player.
		//
		// I have put a hack in here, if "con.bCanBeInterrupted" 
		// (which is no longer used as intended) is set, then don't 
		// call the ScriptedPawn::CanConverseWithPlayer() function

		if ((!bForcePlay) && ((con.IsSpeakingActor(Self)) && (!con.bCanBeInterrupted) && (ScriptedPawn(invokeActor) != None) && (!ScriptedPawn(invokeActor).CanConverseWithPlayer(Self))))
			return False;

		// Hack alert!  If this is a Bark conversation (as denoted by the 
		// conversation name, since we don't have a field in ConEdit), 
		// then force this conversation to be first-person
		if (Left(con.conName, Len(con.conOwnerName) + 5) == (con.conOwnerName $ "_Bark"))
			con.bFirstPerson = True;

		// Make sure the player isn't ducking.  If the player can't rise
		// to start a third-person conversation (blocked by geometry) then 
		// immediately abort the conversation, as this can create all 
		// sorts of complications (such as the player standing through
		// geometry!!)

		if ((!con.bFirstPerson) && (ResetBasedPawnSize() == False))
			return False;

		// If ConPlay exists, end the current conversation playing
		if (conPlay != None)
		{
			// If we're already playing a third-person conversation, don't interrupt with
			// another *radius* induced conversation (frobbing is okay, though).
			if ((conPlay.con != None) && (conPlay.con.bFirstPerson) && (invokeMethod == IM_Radius))
				return False;

			conPlay.InterruptConversation();
			conPlay.TerminateConversation();
		}

		// If this is a first-person conversation _and_ a DataLink is already
		// playing, then abort.  We don't want to give the user any more 
		// distractions while a DL is playing, since they're pretty important.
		if ( dataLinkPlay != None )
		{
			if (con.bFirstPerson)
				return False;
			else
				dataLinkPlay.AbortAndSaveHistory();
		}

		// Found an active conversation, so start it
		conPlay = Spawn(class'ConPlay');
		conPlay.SetStartActor(invokeActor);
		conPlay.SetConversation(con);
		conPlay.SetForcePlay(bForcePlay);
		conPlay.SetInitialRadius(VSize(Location - invokeActor.Location));

		// If this conversation was invoked with IM_Named, then save away
		// the current radius so we don't abort until we get outside 
		// of this radius + 100.
		if ((invokeMethod == IM_Named) || (invokeMethod == IM_Frob))
		{
			conPlay.SetOriginalRadius(con.radiusDistance);
			con.radiusDistance = VSize(invokeActor.Location - Location);
		}

		// If the invoking actor is a ScriptedPawn, then force this person 
		// into the conversation state
		if ((!bForcePlay) && (ScriptedPawn(invokeActor) != None ))
			ScriptedPawn(invokeActor).EnterConversationState(con.bFirstPerson, bAvoidState);

		// Do the same if this is a DeusExDecoration
		if ((!bForcePlay) && (DeusExDecoration(invokeActor) != None ))
			DeusExDecoration(invokeActor).EnterConversationState(con.bFirstPerson, bAvoidState);

		// If this is a third-person convo, we're pretty much going to 
		// pause the game.  If this is a first-person convo, then just 
		// keep on going..
		//
		// If this is a third-person convo *AND* 'bForcePlay' == True, 
		// then use first-person mode, as we're playing an intro/endgame
		// sequence and we can't have the player in the convo state (bad bad bad!)

		if ((!con.bFirstPerson) && (!bForcePlay))
		{
			GotoState('Conversation');
		}
		else
		{
			if (!conPlay.StartConversation(Self, invokeActor, bForcePlay))
			{
				AbortConversation(True);
			}
		}

		return True;
	}
	else
	{
		return False;
	}
}

// ----------------------------------------------------------------------
// GetActiveConversation()
//
// This routine searches all the conversations in this chain until it 
// finds one that is valid for this situation.  It returns the 
// conversation or None if none are found.
// ----------------------------------------------------------------------

function Conversation GetActiveConversation( Actor invokeActor, EInvokeMethod invokeMethod )
{
	local ConListItem conListItem;
	local Conversation con;
	local Name flagName;
	local bool bAbortConversation;

	// If we don't have a valid invokeActor or the flagbase
	// hasn't yet been initialized, immediately abort.
	if ((invokeActor == None) || (flagBase == None))
		return None;

	bAbortConversation = True;

	// Force there to be a one second minimum between conversations 
	// with the same NPC
	if ((invokeActor.LastConEndTime != 0) && 
		((Level.TimeSeconds - invokeActor.LastConEndTime) < 1.0))
		return None;

	// In a loop, go through the conversations, checking each.
	conListItem = ConListItem(invokeActor.ConListItems);

	while ( conListItem != None )
	{
		con = conListItem.con;

		bAbortConversation = False;

		// Ignore Bark conversations, as these are started manually
		// by the AI system.  Do this by checking to see if the first
		// part of the conversation name is in the form, 
		//
		// ConversationOwner_Bark

		if (Left(con.conName, Len(con.conOwnerName) + 5) == (con.conOwnerName $ "_Bark"))
			bAbortConversation = True;

		if (!bAbortConversation)
		{
			// Now check the invocation method to make sure
			// it matches what was passed in

			switch( invokeMethod )
			{
				// Removed Bump conversation starting functionality, all convos
				// must now be "Frobbed" to start (excepting Radius, of course).
				case IM_Bump:
				case IM_Frob:
					bAbortConversation = !(con.bInvokeFrob || con.bInvokeBump);
					break;

				case IM_Sight:
					bAbortConversation = !con.bInvokeSight;
					break;

				case IM_Radius:
					if ( con.bInvokeRadius )
					{
						// Calculate the distance between the player and the owner
						// and if the player is inside that radius, we've passed 
						// this check.

						bAbortConversation = !CheckConversationInvokeRadius(invokeActor, con);

						// First check to make sure that at least 10 seconds have passed
						// before playing a radius-induced conversation after a letterbox
						// conversation with the player
						//
						// Check:
						//  
						// 1.  Player finished letterbox convo in last 10 seconds
						// 2.  Conversation was with this NPC
						// 3.  This new radius conversation is with same NPC.

						if ((!bAbortConversation) && 
						    ((Level.TimeSeconds - lastThirdPersonConvoTime) < 10) && 
						    (lastThirdPersonConvoActor == invokeActor))
							bAbortConversation = True;

						// Now check if this conversation ended in the last ten seconds or so
						// We want to prevent the user from getting trapped inside the same 
						// radius conversation 
						
						if ((!bAbortConversation) && (con.lastPlayedTime > 0))
							bAbortConversation = ((Level.TimeSeconds - con.lastPlayedTime) < 10);

						// Now check to see if the player just ended a radius, third-person
						// conversation with this NPC in the last 5 seconds.  If so, punt, 
						// because we don't want these to chain together too quickly.

						if ((!bAbortConversation) &&
						    ((Level.TimeSeconds - lastFirstPersonConvoTime) < 5) && 
							(lastFirstPersonConvoActor == invokeActor))
							bAbortConversation = True;
					}
					else
					{
						bAbortConversation = True;
					}
					break;

				case IM_Other:
				default:
					break;
			}
		}

		// Now check to see if these two actors are too far apart on their Z
		// axis so we don't get conversations triggered when someone jumps on
		// someone else, or when actors are on two different levels.

		if (!bAbortConversation)
		{
			bAbortConversation = !CheckConversationHeightDifference(invokeActor, 20);

			// If the height check failed, look to see if the actor has a LOS view
			// to the player in which case we'll allow the conversation to continue
			
			if (bAbortConversation)
				bAbortConversation = !CanActorSeePlayer(invokeActor);
		}

		// Check if this conversation is only to be played once 
		if (( !bAbortConversation ) && ( con.bDisplayOnce ))
		{
			flagName = rootWindow.StringToName(con.conName $ "_Played");		
			bAbortConversation = (flagBase.GetBool(flagName) == True);
		}

		if ( !bAbortConversation )
		{
			// Then check to make sure all the flags that need to be
			// set are.

			bAbortConversation = !CheckFlagRefs(con.flagRefList);
		}

		if ( !bAbortConversation )
			break;
	
		conListItem = conListItem.next;
	}

	if (bAbortConversation)
		return None;
	else
		return con;
}

// ----------------------------------------------------------------------
// CheckConversationInvokeRadius()
//
// Returns True if this conversation can be invoked given the 
// invoking actor and the conversation passed in.
// ----------------------------------------------------------------------

function bool CheckConversationInvokeRadius(Actor invokeActor, Conversation con)
{
	local Int  invokeRadius;
	local Int  dist;

	dist = VSize(Location - invokeActor.Location);

	invokeRadius = Max(16, con.radiusDistance);

	return (dist <= invokeRadius);
}

// ----------------------------------------------------------------------
// CheckConversationHeightDifference()
//
// Checks to make sure the player and the invokeActor are fairly close
// to each other on the Z Plane.  Returns True if they are an 
// acceptable distance, otherwise returns False.
// ----------------------------------------------------------------------

function bool CheckConversationHeightDifference(Actor invokeActor, int heightOffset)
{
	local Int dist;

	dist = Abs(Location.Z - invokeActor.Location.Z) - Abs(Default.CollisionHeight - CollisionHeight);

	if (dist > (Abs(CollisionHeight - invokeActor.CollisionHeight) + heightOffset))
		return False;
	else
		return True;
}
	
// ----------------------------------------------------------------------
// CanActorSeePlayer()
// ----------------------------------------------------------------------

function bool CanActorSeePlayer(Actor invokeActor)
{
	return FastTrace(invokeActor.Location);
}

// ----------------------------------------------------------------------
// CheckActiveConversationRadius()
//
// If there's a first-person conversation active, checks to make sure 
// that the player has not walked far away from the conversation owner.
// If so, the conversation is aborted.
// ----------------------------------------------------------------------

function CheckActiveConversationRadius()
{
	local int checkRadius;

	// Ignore if conPlay.GetForcePlay() returns True

	if ((conPlay != None) && (!conPlay.GetForcePlay()) && (conPlay.ConversationStarted()) && (conPlay.displayMode == DM_FirstPerson) && (conPlay.StartActor != None))
	{
		// If this was invoked via a radius, then check to make sure the player doesn't 
		// exceed that radius plus 

		if (conPlay.con.bInvokeRadius) 
			checkRadius = conPlay.con.radiusDistance + 100;
		else
			checkRadius = 300;

		// Add the collisioncylinder since some objects are wider than others
		checkRadius += conPlay.StartActor.CollisionRadius;

		if (VSize(conPlay.startActor.Location - Location) > checkRadius)
		{
			// Abort the conversation
			conPlay.TerminateConversation(True);
		}
	}
}

// ----------------------------------------------------------------------
// CheckActorDistances()
//
// Checks to see how far all the actors are away from each other 
// to make sure the conversation should continue.
// ----------------------------------------------------------------------

function bool CheckActorDistances()
{
	if ((conPlay != None) && (!conPlay.GetForcePlay()) && (conPlay.ConversationStarted()) && (conPlay.displayMode == DM_ThirdPerson))
	{
		if (!conPlay.con.CheckActorDistances(Self))
			conPlay.TerminateConversation(True);
	}
}

// ----------------------------------------------------------------------
// CheckFlagRefs()
//
// Loops through the flagrefs passed in and sees if the current flag
// settings in the game match this set of flags.  Returns True if so,
// otherwise False.
// ----------------------------------------------------------------------

function bool CheckFlagRefs( ConFlagRef flagRef )
{
	local ConFlagRef currentRef;

	// Loop through our list of FlagRef's, checking the value of each.
	// If we hit a bad match, then we'll stop right away since there's
	// no point of continuing.

	currentRef = flagRef;

	while( currentRef != None )
	{
		if ( flagBase.GetBool(currentRef.flagName) != currentRef.value )
			return False;

		currentRef = currentRef.nextFlagRef;
	}
	
	// If we made it this far, then the flags check out.
	return True;
}

// ----------------------------------------------------------------------
// StartDataLinkTransmission()
//
// Locates and starts the DataLink passed in
// ----------------------------------------------------------------------

function Bool StartDataLinkTransmission(
	String datalinkName, 
	Optional DataLinkTrigger datalinkTrigger)
{
	local Conversation activeDataLink;
	local bool bDataLinkPlaySpawned;

	// Don't allow DataLinks to start if we're in PlayersOnly mode
	if ( Level.bPlayersOnly )
		return False;

	activeDataLink = GetActiveDataLink(datalinkName);

	if ( activeDataLink != None )
	{
		// Search to see if there's an active DataLinkPlay object 
		// before creating one

		if ( dataLinkPlay == None )
		{
			datalinkPlay = Spawn(class'DataLinkPlay');
			bDataLinkPlaySpawned = True;
		}

		// Call SetConversation(), which returns 
		if (datalinkPlay.SetConversation(activeDataLink))
		{
			datalinkPlay.SetTrigger(datalinkTrigger);

			if (datalinkPlay.StartConversation(Self))
			{
				return True;
			}
			else
			{
				// Datalink must already be playing, or in queue
				if (bDataLinkPlaySpawned)
				{
					datalinkPlay.Destroy();
					datalinkPlay = None;
				}
				
				return False;
			}
		}
		else
		{
			// Datalink must already be playing, or in queue
			if (bDataLinkPlaySpawned)
			{
				datalinkPlay.Destroy();
				datalinkPlay = None;
			}
			return False;
		}
	}
	else
	{
		return False;
	}
}

// ----------------------------------------------------------------------
// GetActiveDataLink()
// 
// Loops through the conversations belonging to the player and checks
// to see if the datalink conversation passed in can be found.  Also
// checks to the "PlayedOnce" flag to prevent datalink transmissions
// from playing more than one (unless intended).
// ----------------------------------------------------------------------

function Conversation GetActiveDataLink(String datalinkName)
{
	local Name flagName;
	local ConListItem conListItem;
	local Conversation con;
	local bool bAbortDataLink;
	local bool bDatalinkFound;
	local bool bDataLinkNameFound;

	// Abort immediately if the flagbase isn't yet initialized
	if ((flagBase == None) || (rootWindow == None))
		return None;

	conListItem = ConListItem(conListItems);

	// In a loop, go through the conversations, checking each.
	while ( conListItem != None )
	{
		con = conListItem.con;

		if ( Caps(datalinkName) == Caps(con.conName) )
		{
			// Now check if this DataLink is only to be played
			// once 

			bDataLinkNameFound = True;
			bAbortDataLink = False;

			if ( con.bDisplayOnce )
			{
				flagName = rootWindow.StringToName(con.conName $ "_Played");		
				bAbortDataLink = (flagBase.GetBool(flagName) == True);
			}

			// Check the flags for this DataLink
			if (( !bAbortDataLink ) && ( CheckFlagRefs( con.flagRefList ) == True ))
			{
				bDatalinkFound = True;
				break;
			}
		}
		conListItem = conListItem.next;
	}

	if (bDatalinkFound)
	{
		return con;
	}
	else
	{
		// Print a warning if this DL couldn't be found based on its name
		if (bDataLinkNameFound == False)
		{
			log("WARNING! INFOLINK NOT FOUND!! Name = " $ datalinkName);
			ClientMessage("WARNING! INFOLINK NOT FOUND!! Name = " $ datalinkName);
		}
		return None;
	}
}

// ----------------------------------------------------------------------
// AddNote()
//
// Adds a new note to the list of notes the player is carrying around.
// ----------------------------------------------------------------------

function DeusExNote AddNote( optional String strNote, optional Bool bUserNote, optional bool bShowInLog )
{
	local DeusExNote newNote;

	newNote = new(Self) Class'DeusExNote';

	newNote.text = strNote;
	newNote.SetUserNote( bUserNote );

	// Insert this new note at the top of the notes list
	if (FirstNote == None)
		LastNote  = newNote;
	else
		newNote.next = FirstNote;

	FirstNote = newNote;

	// Optionally show the note in the log
	if ( bShowInLog )
	{
		ClientMessage(NoteAdded);
		DeusExRootWindow(rootWindow).hud.msgLog.PlayLogSound(Sound'LogNoteAdded');
	}

	return newNote;
}

// ----------------------------------------------------------------------
// GetNote()
//
// Loops through the notes and searches for the TextTag passed in
// ----------------------------------------------------------------------

function DeusExNote GetNote(Name textTag)
{
	local DeusExNote note;

	note = FirstNote;
		
	while( note != None )
	{
		if (note.textTag == textTag)
			break;

		note = note.next;
	}

	return note;
}

// ----------------------------------------------------------------------
// DeleteNote()
//
// Deletes the specified note
// Returns True if the note successfully deleted
// ----------------------------------------------------------------------

function Bool DeleteNote( DeusExNote noteToDelete )
{
	local DeusExNote note;
	local DeusExNote previousNote;
	local Bool bNoteDeleted;

	bNoteDeleted = False;
	note = FirstNote;
	previousNote = None;

	while( note != None )
	{
		if ( note == noteToDelete )
		{
			if ( note == FirstNote )
				FirstNote = note.next;

			if ( note == LastNote )
				LastNote = previousNote;

			if ( previousNote != None )
				previousNote.next = note.next;

			note = None;
						
			bNoteDeleted = True;	
			break;
		}
		previousNote = note;
		note = note.next;
	}

	return bNoteDeleted;
}

// ----------------------------------------------------------------------
// DeleteAllNotes()
//
// Deletes *ALL* Notes
// ----------------------------------------------------------------------

function DeleteAllNotes()
{
	local DeusExNote note;
	local DeusExNote noteNext;

	note = FirstNote;

	while( note != None )
	{
		noteNext = note.next;
		DeleteNote(note);
		note = noteNext;
	}

	FirstNote = None;
	LastNote = None;
}

// ----------------------------------------------------------------------
// NoteAdd()
// ----------------------------------------------------------------------

exec function NoteAdd( String noteText, optional bool bUserNote )
{
	local DeusExNote newNote;

	newNote = AddNote( noteText );
	newNote.SetUserNote( bUserNote );
}

// ----------------------------------------------------------------------
// AddGoal()
//
// Adds a new goal to the list of goals the player is carrying around.
// ----------------------------------------------------------------------

function DeusExGoal AddGoal( Name goalName, bool bPrimaryGoal )
{	
	local DeusExGoal newGoal;

	// First check to see if this goal already exists.  If so, we'll just
	// return it.  Otherwise create a new goal

	newGoal = FindGoal( goalName );

	if ( newGoal == None )
	{
		newGoal = new(Self) Class'DeusExGoal';
		newGoal.SetName( goalName );

		// Insert goal at the Top so goals are displayed in 
		// Newest order first.
		if (FirstGoal == None)
			LastGoal  = newGoal;
		else
			newGoal.next = FirstGoal;

		FirstGoal    = newGoal;

		newGoal.SetPrimaryGoal( bPrimaryGoal );

		ClientMessage(GoalAdded);
		DeusExRootWindow(rootWindow).hud.msgLog.PlayLogSound(Sound'LogGoalAdded');
	}

	return newGoal;	
}

// ----------------------------------------------------------------------
// FindGoal()
// ----------------------------------------------------------------------

function DeusExGoal FindGoal( Name goalName )
{
	local DeusExGoal goal;

	goal = FirstGoal;

	while( goal != None )
	{
		if ( goalName == goal.goalName )
			break;

		goal = goal.next;
	}

	return goal;
}

// ----------------------------------------------------------------------
// GoalAdd()
//
// Adds a new goal to the list of goals the player is carrying around.
// ----------------------------------------------------------------------

exec function GoalAdd( Name goalName, String goalText, optional bool bPrimaryGoal )
{
	local DeusExGoal newGoal;

	if (!bCheatsEnabled)
		return;

	newGoal = AddGoal( goalName, bPrimaryGoal );
	newGoal.SetText( goalText );
}

// ----------------------------------------------------------------------
// GoalSetPrimary()
//
// Sets a goal as a Primary Goal
// ----------------------------------------------------------------------

exec function GoalSetPrimary( Name goalName, bool bPrimaryGoal )
{
	local DeusExGoal goal;

	if (!bCheatsEnabled)
		return;

	goal = FindGoal( goalName );

	if ( goal != None )
		goal.SetPrimaryGoal( bPrimaryGoal );
}

// ----------------------------------------------------------------------
// GoalCompleted()
//
// Looks up the goal and marks it as completed.
// ----------------------------------------------------------------------

function GoalCompleted( Name goalName )
{
	local DeusExGoal goal;

	// Loop through all the goals until we hit the one we're 
	// looking for.
	goal = FindGoal( goalName );

	if ( goal != None )
	{
		// Only mark a goal as completed once!
		if (!goal.IsCompleted())
		{
			goal.SetCompleted();
			DeusExRootWindow(rootWindow).hud.msgLog.PlayLogSound(Sound'LogGoalCompleted');

			// Let the player know
			if ( goal.bPrimaryGoal )
				ClientMessage(PrimaryGoalCompleted);
			else
				ClientMessage(SecondaryGoalCompleted);
		}
	}
}

// ----------------------------------------------------------------------
// DeleteGoal()
//
// Deletes the specified note
// Returns True if the note successfully deleted
// ----------------------------------------------------------------------

function Bool DeleteGoal( DeusExGoal goalToDelete )
{
	local DeusExGoal goal;
	local DeusExGoal previousGoal;
	local Bool bGoalDeleted;

	bGoalDeleted = False;
	goal = FirstGoal;
	previousGoal = None;

	while( goal != None )
	{
		if ( goal == goalToDelete )
		{
			if ( goal == FirstGoal )
				FirstGoal = goal.next;

			if ( goal == LastGoal )
				LastGoal = previousGoal;

			if ( previousGoal != None )
				previousGoal.next = goal.next;

			goal = None;
						
			bGoalDeleted = True;	
			break;
		}
		previousGoal = goal;
		goal = goal.next;
	}

	return bGoalDeleted;
}

// ----------------------------------------------------------------------
// DeleteAllGoals()
//
// Deletes *ALL* Goals
// ----------------------------------------------------------------------

function DeleteAllGoals()
{
	local DeusExGoal goal;
	local DeusExGoal goalNext;

	goal = FirstGoal;

	while( goal != None )
	{
		goalNext = goal.next;
		DeleteGoal(goal);
		goal = goalNext;
	}

	FirstGoal = None;
	LastGoal = None;
}

// ----------------------------------------------------------------------
// ResetGoals()
// 
// Called when progressing to the next mission.  Deletes all 
// completed Primary Goals as well as *ALL* Secondary Goals 
// (regardless of status)
// ----------------------------------------------------------------------

function ResetGoals()
{
	local DeusExGoal goal;
	local DeusExGoal goalNext;

	goal = FirstGoal;

	while( goal != None )
	{
		goalNext = goal.next;

		// Delete:
		// 1) Completed Primary Goals
		// 2) ALL Secondary Goals

		if ((!goal.IsPrimaryGoal()) || (goal.IsPrimaryGoal() && goal.IsCompleted()))
			DeleteGoal(goal);

		goal = goalNext;
	}
}

// ----------------------------------------------------------------------
// AddImage()
//
// Inserts a new image in the user's list of images.  First checks to 
// make sure the player doesn't already have the image.  If not, 
// sticks the image at the top of the list.
// ----------------------------------------------------------------------

function bool AddImage(DataVaultImage newImage)
{
	local DataVaultImage image;

	if (newImage == None)
		return False;

	// First make sure the player doesn't already have this image!!
	image = FirstImage;
	while(image != None)
	{
		if (newImage.imageDescription == image.imageDescription)
			return False;

		image = image.NextImage;
	}

	// If the player doesn't yet have an image, make this his
	// first image.  
	newImage.nextImage = FirstImage;
	newImage.prevImage = None;

	if (FirstImage != None)
		FirstImage.prevImage = newImage;

	FirstImage = newImage;

	return True;
}

// ----------------------------------------------------------------------
// AddLog()
//
// Adds a log message to our FirstLog linked list
// ----------------------------------------------------------------------

function DeusExLog AddLog(String logText)
{
	local DeusExLog newLog;

	newLog = CreateLogObject();
	newLog.SetLogText(logText);

	// Add this Note to the list of player Notes
	if ( FirstLog != None )
		LastLog.next = newLog;
	else
		FirstLog = newLog;

	LastLog = newLog;

	return newLog;
}

// ----------------------------------------------------------------------
// ClearLog()
//
// Removes log objects
// ----------------------------------------------------------------------

function ClearLog()
{
	local DeusExLog log;
	local DeusExLog nextLog;

	log = FirstLog;

	while( log != None )
	{
		nextLog = log.next;
		CriticalDelete(log);
		log = nextLog;
	}

	FirstLog = None;
	LastLog  = None;
}

// ----------------------------------------------------------------------
// SetLogTimeout()
// ----------------------------------------------------------------------

function SetLogTimeout(Float newLogTimeout)
{
	logTimeout = newLogTimeout;

	// Update the HUD Log Display
	if (DeusExRootWindow(rootWindow).hud != None)
		DeusExRootWindow(rootWindow).hud.msgLog.SetLogTimeout(newLogTimeout);
}

// ----------------------------------------------------------------------
// GetLogTimeout()
// ----------------------------------------------------------------------

function Float GetLogTimeout()
{
   if (Level.NetMode == NM_Standalone)	
      return logTimeout;
   else
      return (FMax(5.0,logTimeout));
}

// ----------------------------------------------------------------------
// SetMaxLogLines()
// ----------------------------------------------------------------------

function SetMaxLogLines(Byte newLogLines)
{
	maxLogLines = newLogLines;

	// Update the HUD Log Display
	if (DeusExRootWindow(rootWindow).hud != None)
		DeusExRootWindow(rootWindow).hud.msgLog.SetMaxLogLines(newLogLines);
}

// ----------------------------------------------------------------------
// GetMaxLogLines()
// ----------------------------------------------------------------------

function Byte GetMaxLogLines()
{
	return maxLogLines;
}

// ----------------------------------------------------------------------
// PopHealth() - This is used from the health screen (Medkits applied to body parts were not in sync with server)
// ----------------------------------------------------------------------

function PopHealth( float health0, float health1, float health2, float health3, float health4, float health5 )
{
	HealthHead     = health0;
	HealthTorso    = health1;
	HealthArmRight = health2;
	HealthArmLeft  = health3;
	HealthLegRight = health4;
	HealthLegLeft  = health5;
}

// ----------------------------------------------------------------------
// GenerateTotalHealth()
//
// this will calculate a weighted average of all of the body parts
// and put that value in the generic Health
// NOTE: head and torso are both critical
// ----------------------------------------------------------------------

function GenerateTotalHealth()
{
	local float ave, avecrit;

	ave = (HealthLegLeft + HealthLegRight + HealthArmLeft + HealthArmRight) / 4.0;

	if ((HealthHead <= 0) || (HealthTorso <= 0))
		avecrit = 0;
	else
		avecrit = (HealthHead + HealthTorso) / 2.0;

	if (avecrit == 0)
		Health = 0;
	else
		Health = (ave + avecrit) / 2.0;
}


// ----------------------------------------------------------------------
// MultiplayerDeathMsg()
// ----------------------------------------------------------------------
function MultiplayerDeathMsg( Pawn killer, bool killedSelf, bool valid, String killerName, String killerMethod )
{
	local MultiplayerMessageWin	mmw;
	local DeusExRootWindow			root;

	myKiller = killer;
	if ( killProfile != None )
	{
		killProfile.bKilledSelf = killedSelf;
		killProfile.bValid = valid;
	}
	root = DeusExRootWindow(rootWindow);
	if ( root != None )
	{
		mmw = MultiplayerMessageWin(root.InvokeUIScreen(Class'MultiplayerMessageWin', True));
		if ( mmw != None )
		{
			mmw.bKilled = true;
			mmw.killerName = killerName;
			mmw.killerMethod = killerMethod;
			mmw.bKilledSelf = killedSelf;
			mmw.bValidMethod = valid;
		}
	}
}

function ShowProgress()
{
	local MultiplayerMessageWin	mmw;
	local DeusExRootWindow			root;

	root = DeusExRootWindow(rootWindow);
   if (root != None)
	{
      if (root.GetTopWindow() != None)
         mmw = MultiplayerMessageWin(root.GetTopWindow());

      if ((mmw != None) && (mmw.bDisplayProgress == false))
      {
         mmw.Destroy();
         mmw = None;
      }
      if ( mmw == None )
      {
         mmw = MultiplayerMessageWin(root.InvokeUIScreen(Class'MultiplayerMessageWin', True));
         if ( mmw != None )
         {
            mmw.bKilled = false;
            mmw.bDisplayProgress = true;
            mmw.lockoutTime = Level.TimeSeconds + 0.2;
         }
      }
   }
}     

// ----------------------------------------------------------------------
// ServerConditionalNoitfyMsg
// ----------------------------------------------------------------------

function ServerConditionalNotifyMsg( int code, optional int param, optional string str )
{
	switch( code )
	{
		case MPMSG_FirstPoison:
			if ( (mpMsgServerFlags & MPSERVERFLAG_FirstPoison) == MPSERVERFLAG_FirstPoison )
				return;
			else
				mpMsgServerFlags = mpMsgServerFlags | MPSERVERFLAG_FirstPoison;
			break;
		case MPMSG_FirstBurn:
			if ( (mpMsgServerFlags & MPSERVERFLAG_FirstBurn) == MPSERVERFLAG_FirstBurn )
				return;
			else
				mpMsgServerFlags = mpMsgServerFlags | MPSERVERFLAG_FirstBurn;
			break;
		case MPMSG_TurretInv:
			if ( ( mpMsgServerFlags & MPSERVERFLAG_TurretInv ) == MPSERVERFLAG_TurretInv )
				return;
			else
				mpMsgServerFlags = mpMsgServerFlags | MPSERVERFLAG_TurretInv;
			break;
		case MPMSG_CameraInv:
			if ( ( mpMsgServerFlags & MPSERVERFLAG_CameraInv ) == MPSERVERFLAG_CameraInv )
				return;
			else
				mpMsgServerFlags = mpMsgServerFlags | MPSERVERFLAG_CameraInv;
			break;
		case MPMSG_LostLegs:
			if ( ( mpMsgServerFlags & MPSERVERFLAG_LostLegs) == MPSERVERFLAG_LostLegs )
				return;
			else
				mpMsgServerFlags = mpMsgServerFlags | MPSERVERFLAG_LostLegs;
			break;
		case MPMSG_DropItem:
			if ( ( mpMsgServerFlags & MPSERVERFLAG_DropItem) == MPSERVERFLAG_DropItem )
				return;
			else
				mpMsgServerFlags = mpMsgServerFlags | MPSERVERFLAG_DropItem;
			break;
		case MPMSG_NoCloakWeapon:
			if ( ( mpMsgServerFlags & MPSERVERFLAG_NoCloakWeapon) == MPSERVERFLAG_NoCloakWeapon )
				return;
			else
				mpMsgServerFlags = mpMsgServerFlags | MPSERVERFLAG_NoCloakWeapon;
			break;
	}
	// If we made it here we need to notify
	MultiplayerNotifyMsg( code, param, str );
}

// ----------------------------------------------------------------------
// MultiplayerNotifyMsg()
// ----------------------------------------------------------------------
function MultiplayerNotifyMsg( int code, optional int param, optional string str )
{
	if ( !bHelpMessages )
	{
		switch( code )
		{
			case MPMSG_TeamUnatco:
			case MPMSG_TeamNsf:
			case MPMSG_TeamHit:
			case MPMSG_TeamSpot:
			case MPMSG_FirstPoison:
			case MPMSG_FirstBurn:
			case MPMSG_TurretInv:
			case MPMSG_CameraInv:
			case MPMSG_LostLegs:
			case MPMSG_DropItem:
			case MPMSG_KilledTeammate:
			case MPMSG_TeamLAM:
			case MPMSG_TeamComputer:
			case MPMSG_NoCloakWeapon:
			case MPMSG_TeamHackTurret:
				return;		// Pass on these
			case MPMSG_CloseKills:
			case MPMSG_TimeNearEnd:
				break;		// Go ahead with these
		}
	}

	switch( code )
	{
		case MPMSG_TeamSpot:
			if ( (mpMsgFlags & MPFLAG_FirstSpot) == MPFLAG_FirstSpot )
				return;
			else
				mpMsgFlags = mpMsgFlags | MPFLAG_FirstSpot;
			break;
		case MPMSG_CloseKills:
			if ((param == 0) || (str ~= ""))
			{
				log("Warning: Passed bad params to multiplayer notify msg." );
				return;
			}
			mpMsgOptionalParam = param;
			mpMsgOptionalString = str;
			break;
		case MPMSG_TimeNearEnd:
			if ((param == 0) || (str ~= ""))
			{
				log("Warning: Passed bad params to multiplayer notify msg." );
				return;
			}
			mpMsgOptionalParam = param;
			mpMsgOptionalString = str;		
			break;
		case MPMSG_DropItem:
		case MPMSG_TeamUnatco:
		case MPMSG_TeamNsf:
			if (( DeusExRootWindow(rootWindow) != None ) && ( DeusExRootWindow(rootWindow).hud != None ) && (DeusExRootWindow(rootWindow).hud.augDisplay != None ))
				DeusExRootWindow(rootWindow).hud.augDisplay.RefreshMultiplayerKeys();
			break;
	}
	mpMsgCode = code;
  	mpMsgTime = Level.Timeseconds + mpMsgDelay;
	if (( code == MPMSG_TeamUnatco ) || ( code == MPMSG_TeamNsf ))
		mpMsgTime += 2.0;
}


//
// GetSkillInfoFromProjKiller
//
function GetSkillInfoFromProj( DeusExPlayer killer, Actor proj )
{
	local class<Skill> skillClass;

	if ( proj.IsA('GasGrenade') || proj.IsA('LAM') || proj.IsA('EMPGrenade') || proj.IsA('TearGas'))
		skillClass = class'SkillDemolition';
	else if ( proj.IsA('Rocket') || proj.IsA('RocketLAW') || proj.IsA('RocketWP') || proj.IsA('Fireball') || proj.IsA('PlasmaBolt'))
		skillClass = class'SkillWeaponHeavy';
	else if ( proj.IsA('Dart') || proj.IsA('DartFlare') || proj.IsA('DartPoison') || proj.IsA('Shuriken'))
		skillClass = class'SkillWeaponLowTech';
	else if ( proj.IsA('HECannister20mm') )
		skillClass = class'SkillWeaponRifle';
	else if ( proj.IsA('DeusExDecoration') )
	{
		killProfile.activeSkill = NoneString;
		killProfile.activeSkillLevel = 0;
		return;
	}
	if ( killer.SkillSystem != None )
	{
		killProfile.activeSkill = skillClass.Default.skillName;
		killProfile.activeSkillLevel = killer.SkillSystem.GetSkillLevel(skillClass);
	}
}

function GetWeaponName( DeusExWeapon w, out String name )
{
	if ( w != None )
	{
		if ( WeaponGEPGun(w) != None )
			name = WeaponGEPGun(w).shortName;
		else if ( WeaponLAM(w) != None )
			name = WeaponLAM(w).shortName;
		else
			name = w.itemName;
	}
	else
		name = NoneString;
}

//
// CreateKillerProfile
//
function CreateKillerProfile( Pawn killer, int damage, name damageType, String bodyPart )
{
	local DeusExPlayer pkiller;
	local DeusExProjectile proj;
	local DeusExDecoration decProj;
	local Augmentation anAug;
	local int augCnt;
	local DeusExWeapon w;
	local Skill askill;
	local String wShortString;

	if ( killProfile == None )
	{
		log("Warning:"$Self$" has a killProfile that is None!" );
		return;
	}
	else
		killProfile.Reset();

	pkiller = DeusExPlayer(killer);
	
	if ( pkiller != None )
	{
		killProfile.bValid = True;
		killProfile.name = pkiller.PlayerReplicationInfo.PlayerName;
		w = DeusExWeapon(pkiller.inHand);
		GetWeaponName( w, killProfile.activeWeapon );

		// What augs the killer was using
		if ( pkiller.AugmentationSystem != None )
		{
			killProfile.numActiveAugs = pkiller.AugmentationSystem.NumAugsActive();
			augCnt = 0;
			anAug = pkiller.AugmentationSystem.FirstAug;
			while ( anAug != None )
			{
				if ( anAug.bHasIt && anAug.bIsActive && !anAug.bAlwaysActive && (augCnt < ArrayCount(killProfile.activeAugs)))
				{
					killProfile.activeAugs[augCnt] = anAug.augmentationName;
					augCnt += 1;
				}
				anAug = anAug.next;
			}
		}
		else
			killProfile.numActiveAugs = 0;

		// My weapon and skill
		GetWeaponName( DeusExWeapon(inHand), killProfile.myActiveWeapon );
		if ( DeusExWeapon(inHand) != None )
		{
			if ( SkillSystem != None )
			{
				askill = SkillSystem.GetSkillFromClass(DeusExWeapon(inHand).GoverningSkill);
				killProfile.myActiveSkill = askill.skillName;
				killProfile.myActiveSkillLevel = askill.CurrentLevel;
			}
		}
		else
		{
			killProfile.myActiveWeapon = NoneString;
			killProfile.myActiveSkill = NoneString;
			killProfile.myActiveSkillLevel = 0;
		}
		// Fill in my own active augs
		if ( AugmentationSystem != None )
		{
			killProfile.myNumActiveAugs = AugmentationSystem.NumAugsActive();
			augCnt = 0;
			anAug = AugmentationSystem.FirstAug;
			while ( anAug != None )
			{
				if ( anAug.bHasIt && anAug.bIsActive && !anAug.bAlwaysActive && (augCnt < ArrayCount(killProfile.myActiveAugs)))
				{
					killProfile.myActiveAugs[augCnt] = anAug.augmentationName;
					augCnt += 1;
				}
				anAug = anAug.next;
			}
		}
		killProfile.streak = (pkiller.PlayerReplicationInfo.Streak + 1);
		killProfile.healthLow = pkiller.HealthLegLeft;
		killProfile.healthMid =  pkiller.HealthTorso;
		killProfile.healthHigh = pkiller.HealthHead;
		killProfile.remainingBio = pkiller.Energy;
		killProfile.damage = damage;
		killProfile.bodyLoc = bodyPart;
		killProfile.killerLoc = pkiller.Location;
	}
	else
	{
		killProfile.bValid = False;
		return;
	}

	killProfile.methodStr = NoneString;

	switch( damageType )
	{
		case 'AutoShot':
			killProfile.methodStr = WithTheString $ AutoTurret(myTurretKiller).titleString  $ "!";
			killProfile.bTurretKilled = True;
			killProfile.killerLoc = AutoTurret(myTurretKiller).Location;
			if ( pkiller.SkillSystem != None )
			{
				killProfile.activeSkill = class'SkillComputer'.Default.skillName;
				killProfile.activeSkillLevel = pkiller.SkillSystem.GetSkillLevel(class'SkillComputer');
			}
			break;
		case 'PoisonEffect':
			killProfile.methodStr = PoisonString $ "!";
			killProfile.bPoisonKilled = True;
			killProfile.activeSkill = NoneString;
			killProfile.activeSkillLevel = 0;
			break;
		case 'Burned':
		case 'Flamed':
			if (( WeaponPlasmaRifle(w) != None ) || ( WeaponFlamethrower(w) != None ))
			{
				// Use the weapon if it's still in hand
			}
			else
			{
				killProfile.methodStr = BurnString $ "!";
				killProfile.bBurnKilled = True;
				killProfile.activeSkill = NoneString;
				killProfile.activeSkillLevel = 0;
			}
			break;
	}
	if ( killProfile.methodStr ~= NoneString )
	{
		proj = DeusExProjectile(myProjKiller);
		decProj = DeusExDecoration(myProjKiller);

		if (( killer != None ) && (proj != None) && (!(proj.itemName ~= "")) )
		{
			if ( (LAM(myProjKiller) != None) && (LAM(myProjKiller).bProximityTriggered) )
			{
				killProfile.bProximityKilled = True;
				killProfile.killerLoc = LAM(myProjKiller).Location;
				killProfile.myActiveSkill = class'SkillDemolition'.Default.skillName;
				if ( SkillSystem != None )
					killProfile.myActiveSkillLevel = SkillSystem.GetSkillLevel(class'SkillDemolition');
				else
					killProfile.myActiveSkillLevel = 0;
			}
			else
				killProfile.bProjKilled = True;
			killProfile.methodStr = WithString $ proj.itemArticle $ " " $ proj.itemName $ "!";
			GetSkillInfoFromProj( pkiller, myProjKiller );
		}
		else if (( killer != None ) && ( decProj != None ) && (!(decProj.itemName ~= "" )) )
		{
			killProfile.methodStr = WithString $ decProj.itemArticle $ " " $ decProj.itemName $ "!";
			killProfile.bProjKilled = True;
			GetSkillInfoFromProj( pkiller, myProjKiller );
		}
		else if ((killer != None) && (w != None))
		{
			GetWeaponName( w, wShortString );
			killProfile.methodStr = WithString $ w.itemArticle $ " " $ wShortString $ "!";
			askill = pkiller.SkillSystem.GetSkillFromClass(w.GoverningSkill);
			killProfile.activeSkill = askill.skillName;
			killProfile.activeSkillLevel = askill.CurrentLevel;
		}
		else
			log("Warning: Failed to determine killer method killer:"$killer$" damage:"$damage$" damageType:"$damageType$" " );
	}
	// If we still failed dump this to log, and I'll see if there's a condition slipping through...
	if ( killProfile.methodStr ~= NoneString )
	{
		log("===>Warning: Failed to get killer method:"$Self$" damageType:"$damageType$" " );
		killProfile.bValid = False;
	}
}

// ----------------------------------------------------------------------
// TakeDamage()
// ----------------------------------------------------------------------

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
{
	local int actualDamage;
	local bool bAlreadyDead, bPlayAnim, bDamageGotReduced;
	local Vector offset, dst;
	local float headOffsetZ, headOffsetY, armOffset;
	local float origHealth, fdst;
	local DeusExLevelInfo info;
	local DeusExWeapon dxw;
	local String bodyString;
	local int MPHitLoc;

	if ( bNintendoImmunity )
		return;

	bodyString = "";
	origHealth = Health;

   if (Level.NetMode != NM_Standalone)
      Damage *= MPDamageMult;

	// use the hitlocation to determine where the pawn is hit
	// transform the worldspace hitlocation into objectspace
	// in objectspace, remember X is front to back
	// Y is side to side, and Z is top to bottom
	offset = (hitLocation - Location) << Rotation;

	// add a HUD icon for this damage type
	if ((damageType == 'Poison') || (damageType == 'PoisonEffect'))  // hack
		AddDamageDisplay('PoisonGas', offset);
	else
		AddDamageDisplay(damageType, offset);

	// nanovirus damage doesn't affect us
	if (damageType == 'NanoVirus')
		return;

	// handle poison
	if ((damageType == 'Poison') || ((Level.NetMode != NM_Standalone) && (damageType=='TearGas')) )
	{
		// Notify player if they're getting burned for the first time
		if ( Level.NetMode != NM_Standalone )
			ServerConditionalNotifyMsg( MPMSG_FirstPoison );

		StartPoison( instigatedBy, Damage );
	}

	// reduce our damage correctly
	if (ReducedDamageType == damageType)
		actualDamage = float(actualDamage) * (1.0 - ReducedDamagePct);

	// check for augs or inventory items
	bDamageGotReduced = DXReduceDamage(Damage, damageType, hitLocation, actualDamage, False);

   // DEUS_EX AMSD Multiplayer shield
   if (Level.NetMode != NM_Standalone)
      if (bDamageGotReduced)
      {
         ShieldStatus = SS_Strong;
         ShieldTimer = 1.0;
      }

	if (ReducedDamageType == 'All') //God mode
		actualDamage = 0;

	// Multiplayer only code
	if ( Level.NetMode != NM_Standalone )
	{
		if ( ( instigatedBy != None ) && (instigatedBy.IsA('DeusExPlayer')) )
		{
			// Special case the sniper rifle
			if ((DeusExPlayer(instigatedBy).Weapon != None) && ( DeusExPlayer(instigatedBy).Weapon.class == class'WeaponRifle' ))
			{
				dxw = DeusExWeapon(DeusExPlayer(instigatedBy).Weapon);
				if ( (dxw != None ) && ( !dxw.bZoomed ))
					actualDamage *= WeaponRifle(dxw).mpNoScopeMult; // Reduce damage if we're not using the scope
			}
			if ( (TeamDMGame(DXGame) != None) && (TeamDMGame(DXGame).ArePlayersAllied(DeusExPlayer(instigatedBy),Self)) )
			{
				// Don't notify if the player hurts themselves
				if ( DeusExPlayer(instigatedBy) != Self )
				{
					actualDamage *= TeamDMGame(DXGame).fFriendlyFireMult;
					if (( damageType != 'TearGas' ) && ( damageType != 'PoisonEffect' ))
						DeusExPlayer(instigatedBy).MultiplayerNotifyMsg( MPMSG_TeamHit );
				}
			}

		}
	}

	// EMP attacks drain BE energy
	if (damageType == 'EMP')
	{
		EnergyDrain += actualDamage;
		EnergyDrainTotal += actualDamage;
		PlayTakeHitSound(actualDamage, damageType, 1);
		return;
	}

	bPlayAnim = True;

	// if we're burning, don't play a hit anim when taking burning damage
	if (damageType == 'Burned')
		bPlayAnim = False;

	if (Physics == PHYS_None)
		SetMovementPhysics();
	if (Physics == PHYS_Walking)
		momentum.Z = 0.4 * VSize(momentum);
	if ( instigatedBy == self )
		momentum *= 0.6;
	momentum = momentum/Mass;
	//	AddVelocity( momentum ); 	// doesn't do anything anyway

	// calculate our hit extents
	headOffsetZ = CollisionHeight * 0.78;
	headOffsetY = CollisionRadius * 0.35;
	armOffset = CollisionRadius * 0.35;

	// We decided to just have 3 hit locations in multiplayer MBCODE
	if (( Level.NetMode == NM_DedicatedServer ) || ( Level.NetMode == NM_ListenServer ))
	{
		MPHitLoc = GetMPHitLocation(HitLocation);

		if (MPHitLoc == 0)
			return;
		else if (MPHitLoc == 1 )
		{
			// MP Headshot is 2x damage
			// narrow the head region
			actualDamage *= 2;
			HealthHead -= actualDamage;
			bodyString = HeadString;
			if (bPlayAnim)
				PlayAnim('HitHead', , 0.1);
		}
		else if ((MPHitLoc == 3) || (MPHitLoc == 4))	// Leg region
		{
			HealthLegRight -= actualDamage;
			HealthLegLeft -= actualDamage;

			if (MPHitLoc == 4)
			{
				if (bPlayAnim)
					PlayAnim('HitLegRight', , 0.1);
			}
			else if (MPHitLoc == 3)
			{
				if (bPlayAnim)
					PlayAnim('HitLegLeft', , 0.1);
			}
			// Since the legs are in sync only bleed up damage from one leg (otherwise it's double damage)
			if (HealthLegLeft < 0)
			{
				HealthArmRight += HealthLegLeft;
				HealthTorso += HealthLegLeft;
				HealthArmLeft += HealthLegLeft;
				bodyString = TorsoString;
				HealthLegLeft = 0;
				HealthLegRight = 0;
			}
		}
		else // arms and torso now one region
		{
			HealthArmLeft -= actualDamage;
			HealthTorso -= actualDamage;
			HealthArmRight -= actualDamage;

			bodyString = TorsoString;

			if (MPHitLoc == 6)
			{
				if (bPlayAnim)
					PlayAnim('HitArmRight', , 0.1);
			}
			else if (MPHitLoc == 5)
			{
				if (bPlayAnim)
					PlayAnim('HitArmLeft', , 0.1);
			}
			else
			{
				if (bPlayAnim)
					PlayAnim('HitTorso', , 0.1);
			}
		}
	}
	else // Normal damage code path for single player
	{
		if (offset.z > headOffsetZ)		// head
		{
			// narrow the head region
			if ((Abs(offset.x) < headOffsetY) || (Abs(offset.y) < headOffsetY))
			{
				HealthHead -= actualDamage * 2;
				if (bPlayAnim)
					PlayAnim('HitHead', , 0.1);
			}
		}
		else if (offset.z < 0.0)	// legs
		{
			if (offset.y > 0.0)
			{
				HealthLegRight -= actualDamage;
				if (bPlayAnim)
					PlayAnim('HitLegRight', , 0.1);
			}
			else
			{
				HealthLegLeft -= actualDamage;
				if (bPlayAnim)
					PlayAnim('HitLegLeft', , 0.1);
			}

 			// if this part is already dead, damage the adjacent part
			if ((HealthLegRight < 0) && (HealthLegLeft > 0))
			{
				HealthLegLeft += HealthLegRight;
				HealthLegRight = 0;
			}
			else if ((HealthLegLeft < 0) && (HealthLegRight > 0))
			{
				HealthLegRight += HealthLegLeft;
				HealthLegLeft = 0;
			}

			if (HealthLegLeft < 0)
			{
				HealthTorso += HealthLegLeft;
				HealthLegLeft = 0;
			}
			if (HealthLegRight < 0)
			{
				HealthTorso += HealthLegRight;
				HealthLegRight = 0;
			}
		}
		else						// arms and torso
		{
			if (offset.y > armOffset)
			{
				HealthArmRight -= actualDamage;
				if (bPlayAnim)
					PlayAnim('HitArmRight', , 0.1);
			}
			else if (offset.y < -armOffset)
			{
				HealthArmLeft -= actualDamage;
				if (bPlayAnim)
					PlayAnim('HitArmLeft', , 0.1);
			}
			else
			{
				HealthTorso -= actualDamage * 2;
				if (bPlayAnim)
					PlayAnim('HitTorso', , 0.1);
			}

			// if this part is already dead, damage the adjacent part
			if (HealthArmLeft < 0)
			{
				HealthTorso += HealthArmLeft;
				HealthArmLeft = 0;
			}
			if (HealthArmRight < 0)
			{
				HealthTorso += HealthArmRight;
				HealthArmRight = 0;
			}
		}
	}

	// check for a back hit and play the correct anim
	if ((offset.x < 0.0) && bPlayAnim)
	{
		if (offset.z > headOffsetZ)		// head from the back
		{
			// narrow the head region
			if ((Abs(offset.x) < headOffsetY) || (Abs(offset.y) < headOffsetY))
				PlayAnim('HitHeadBack', , 0.1);
		}
		else
			PlayAnim('HitTorsoBack', , 0.1);
	}

	// check for a water hit
	if (Region.Zone.bWaterZone)
	{
		if ((offset.x < 0.0) && bPlayAnim)
			PlayAnim('WaterHitTorsoBack',,0.1);
		else
			PlayAnim('WaterHitTorso',,0.1);
	}

	GenerateTotalHealth();

	if ((damageType != 'Stunned') && (damageType != 'TearGas') && (damageType != 'HalonGas') &&
	    (damageType != 'PoisonGas') && (damageType != 'Radiation') && (damageType != 'EMP') &&
	    (damageType != 'NanoVirus') && (damageType != 'Drowned') && (damageType != 'KnockedOut'))
		bleedRate += (origHealth-Health)/30.0;  // 30 points of damage = bleed profusely

	if (CarriedDecoration != None)
		DropDecoration();

	// don't let the player die in the training mission
	info = GetLevelInfo();
	if ((info != None) && (info.MissionNumber == 0))
	{
		if (Health <= 0)
		{
			HealthTorso = FMax(HealthTorso, 10);
			HealthHead = FMax(HealthHead, 10);
			GenerateTotalHealth();
		}
	}

	if (Health > 0)
	{
		if ((Level.NetMode != NM_Standalone) && (HealthLegLeft==0) && (HealthLegRight==0))
			ServerConditionalNotifyMsg( MPMSG_LostLegs );

		if (instigatedBy != None)
			damageAttitudeTo(instigatedBy);
		PlayDXTakeDamageHit(actualDamage, hitLocation, damageType, momentum, bDamageGotReduced);
		AISendEvent('Distress', EAITYPE_Visual);
	}
	else
	{
		NextState = '';
		PlayDeathHit(actualDamage, hitLocation, damageType, momentum);
		if ( Level.NetMode != NM_Standalone )
			CreateKillerProfile( instigatedBy, actualDamage, damageType, bodyString );
		if ( actualDamage > mass )
			Health = -1 * actualDamage;
		Enemy = instigatedBy;
		Died(instigatedBy, damageType, HitLocation);
		return;
	}
	MakeNoise(1.0); 

	if ((DamageType == 'Flamed') && !bOnFire)
	{
		// Notify player if they're getting burned for the first time
		if ( Level.NetMode != NM_Standalone )
			ServerConditionalNotifyMsg( MPMSG_FirstBurn );

		CatchFire( instigatedBy );
	}
	myProjKiller = None;
}

// ----------------------------------------------------------------------
// GetMPHitLocation()
// Returns 1 for head, 2 for torso, 3 for left leg, 4 for right leg, 5 for
// left arm, 6 for right arm, 0 for nothing.
// ----------------------------------------------------------------------
simulated function int GetMPHitLocation(Vector HitLocation)
{
	local float HeadOffsetZ;
	local float HeadOffsetY;
	local float ArmOffset;
	local vector Offset;

	offset = (hitLocation - Location) << Rotation;

	// calculate our hit extents
	headOffsetZ = CollisionHeight * 0.78;
	headOffsetY = CollisionRadius * 0.35;
	armOffset = CollisionRadius * 0.35;
	
	if (offset.z > headOffsetZ )
	{
		// narrow the head region
		if ((Abs(offset.x) < headOffsetY) || (Abs(offset.y) < headOffsetY))
		{
			// Headshot, return 1;
			return 1;
		}
		else
		{
			return 0;
		}
	}
	else if (offset.z < 0.0)	// Leg region
	{		
		if (offset.y > 0.0)
		{
			//right leg
			return 4;
		}
		else
		{
			//left leg
			return 3;
		}
	}
	else // arms and torso now one region
	{
		if (offset.y > armOffset)
		{
			return 6;
		}
		else if (offset.y < -armOffset)
		{
			return 5;
		}
		else
		{
			return 2;
		}
	}
	return 0;
}

// ----------------------------------------------------------------------
// DXReduceDamage()
//
// Calculates reduced damage from augmentations and from inventory items
// Also calculates a scalar damage reduction based on the mission number
// ----------------------------------------------------------------------
function bool DXReduceDamage(int Damage, name damageType, vector hitLocation, out int adjustedDamage, bool bCheckOnly)
{
	local float newDamage;
	local float augLevel, skillLevel;
	local float pct;
	local HazMatSuit suit;
	local BallisticArmor armor;
	local bool bReduced;

	bReduced = False;
	newDamage = Float(Damage);

	if ((damageType == 'TearGas') || (damageType == 'PoisonGas') || (damageType == 'Radiation') ||
		(damageType == 'HalonGas')  || (damageType == 'PoisonEffect') || (damageType == 'Poison'))
	{
		if (AugmentationSystem != None)
			augLevel = AugmentationSystem.GetAugLevelValue(class'AugEnviro');

		if (augLevel >= 0.0)
			newDamage *= augLevel;

		// get rid of poison if we're maxed out
		if (newDamage ~= 0.0)
		{
			StopPoison();
			drugEffectTimer -= 4;	// stop the drunk effect
			if (drugEffectTimer < 0)
				drugEffectTimer = 0;
		}

		// go through the actor list looking for owned HazMatSuits
		// since they aren't in the inventory anymore after they are used


      //foreach AllActors(class'HazMatSuit', suit)
//			if ((suit.Owner == Self) && suit.bActive)
      if (UsingChargedPickup(class'HazMatSuit'))
			{
				skillLevel = SkillSystem.GetSkillLevelValue(class'SkillEnviro');
				newDamage *= 0.75 * skillLevel;
			}
	}

	if ((damageType == 'Shot') || (damageType == 'Sabot') || (damageType == 'Exploded') || (damageType == 'AutoShot'))
	{
		// go through the actor list looking for owned BallisticArmor
		// since they aren't in the inventory anymore after they are used
      if (UsingChargedPickup(class'BallisticArmor'))
			{
				skillLevel = SkillSystem.GetSkillLevelValue(class'SkillEnviro');
				newDamage *= 0.5 * skillLevel;
			}
	}

	if (damageType == 'HalonGas')
	{
		if (bOnFire && !bCheckOnly)
			ExtinguishFire();
	}

	if ((damageType == 'Shot') || (damageType == 'AutoShot'))
	{
		if (AugmentationSystem != None)
			augLevel = AugmentationSystem.GetAugLevelValue(class'AugBallistic');

		if (augLevel >= 0.0)
			newDamage *= augLevel;
	}

	if (damageType == 'EMP')
	{
		if (AugmentationSystem != None)
			augLevel = AugmentationSystem.GetAugLevelValue(class'AugEMP');

		if (augLevel >= 0.0)
			newDamage *= augLevel;
	}

	if ((damageType == 'Burned') || (damageType == 'Flamed') ||
		(damageType == 'Exploded') || (damageType == 'Shocked'))
	{
		if (AugmentationSystem != None)
			augLevel = AugmentationSystem.GetAugLevelValue(class'AugShield');

		if (augLevel >= 0.0)
			newDamage *= augLevel;
	}

	if (newDamage < Damage)
	{
		if (!bCheckOnly)
		{
			pct = 1.0 - (newDamage / Float(Damage));
			SetDamagePercent(pct);
			ClientFlash(0.01, vect(0, 0, 50));
		}
		bReduced = True;
	}
	else
	{
		if (!bCheckOnly)
			SetDamagePercent(0.0);
	}


	//
	// Reduce or increase the damage based on the combat difficulty setting
	//
	if ((damageType == 'Shot') || (damageType == 'AutoShot'))
	{
		newDamage *= CombatDifficulty;

		// always take at least one point of damage
		if ((newDamage <= 1) && (Damage > 0))
			newDamage = 1;
	}

	adjustedDamage = Int(newDamage);

	return bReduced;
}

// ----------------------------------------------------------------------
// Died()
//
// Checks to see if a conversation is playing when the PC dies.
// If so, nukes it.
// ----------------------------------------------------------------------

function Died(pawn Killer, name damageType, vector HitLocation)
{
	if (conPlay != None)
		conPlay.TerminateConversation();

	if (bOnFire)
		ExtinguishFire();

	if (AugmentationSystem != None)
		AugmentationSystem.DeactivateAll();

   if ((Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer))
      ClientDeath();

	Super.Died(Killer, damageType, HitLocation);
}

// ----------------------------------------------------------------------
// ClientDeath()
// 
// Does client side cleanup on death.
// ----------------------------------------------------------------------

function ClientDeath()
{   
   if (!PlayerIsClient())
      return;

   FlashTimer = 0;

	// Reset skill notification
	DeusExRootWindow(rootWindow).hud.hms.bNotifySkills = False;

   DeusExRootWindow(rootWindow).hud.activeItems.winItemsContainer.RemoveAllIcons();
   DeusExRootWindow(rootWindow).hud.belt.ClearBelt();

	// This should get rid of the scope death problem in multiplayer
	if (( DeusExRootWindow(rootWindow).scopeView != None ) && DeusExRootWindow(rootWindow).scopeView.bViewVisible )
	   DeusExRootWindow(rootWindow).scopeView.DeactivateView();

	if ( DeusExRootWindow(rootWindow).hud.augDisplay != None )
	{
		DeusExRootWindow(rootWindow).hud.augDisplay.bVisionActive = False;
		DeusExRootWindow(rootWindow).hud.augDisplay.activeCount = 0;
	}

	if ( bOnFire )
		ExtinguishFire();

	// Don't come back to life drugged or posioned
	poisonCounter		= 0;
	poisonTimer			= 0;
	drugEffectTimer	= 0;

	// Don't come back to life crouched
	bCrouchOn			= False;
	bWasCrouchOn		= False;
	bIsCrouching		= False;
	bForceDuck			= False;
	lastbDuck			= 0;
	bDuck					= 0;

	// No messages carry over
	mpMsgCode = 0;
	mpMsgTime = 0;

   bleedrate = 0;
   dropCounter = 0;

}

// ----------------------------------------------------------------------
// Timer()
//
// continually burn and do damage
// ----------------------------------------------------------------------

function Timer()
{
	local int damage;

	if (!InConversation() && bOnFire)
	{
		if ( Level.NetMode != NM_Standalone )
			damage = Class'WeaponFlamethrower'.Default.mpBurnDamage;
		else
			damage = Class'WeaponFlamethrower'.Default.BurnDamage;
		TakeDamage(damage, myBurner, Location, vect(0,0,0), 'Burned');

		if (HealthTorso <= 0)
		{
			TakeDamage(10, myBurner, Location, vect(0,0,0), 'Burned');
			ExtinguishFire();
		}
	}
}

// ----------------------------------------------------------------------
// CatchFire()
// ----------------------------------------------------------------------

function CatchFire( Pawn burner )
{
	local Fire f;
	local int i;
	local vector loc;

	myBurner = burner;

	burnTimer = 0;

   if (bOnFire || Region.Zone.bWaterZone)
		return;

	bOnFire = True;
	burnTimer = 0;

	for (i=0; i<8; i++)
	{
		loc.X = 0.5*CollisionRadius * (1.0-2.0*FRand());
		loc.Y = 0.5*CollisionRadius * (1.0-2.0*FRand());
		loc.Z = 0.6*CollisionHeight * (1.0-2.0*FRand());
		loc += Location;

      // DEUS_EX AMSD reduce the number of smoke particles in multiplayer
      // by creating smokeless fire (better for server propagation).
      if ((Level.NetMode == NM_Standalone) || (i <= 0))		
         f = Spawn(class'Fire', Self,, loc);
      else
         f = Spawn(class'SmokelessFire', Self,, loc);

		if (f != None)
		{
			f.DrawScale = 0.5*FRand() + 1.0;

         //DEUS_EX AMSD Reduce the penalty in multiplayer
         if (Level.NetMode != NM_Standalone)
            f.DrawScale = f.DrawScale * 0.5;

			// turn off the sound and lights for all but the first one
			if (i > 0)
			{
				f.AmbientSound = None;
				f.LightType = LT_None;
			}

			// turn on/off extra fire and smoke
         // MP already only generates a little.
			if ((FRand() < 0.5) && (Level.NetMode == NM_Standalone))
				f.smokeGen.Destroy();
			if ((FRand() < 0.5) && (Level.NetMode == NM_Standalone))
				f.AddFire();
		}
	}

	// set the burn timer
	SetTimer(1.0, True);
}

// ----------------------------------------------------------------------
// ExtinguishFire()
// ----------------------------------------------------------------------

function ExtinguishFire()
{
	local Fire f;

	bOnFire = False;
	burnTimer = 0;
	SetTimer(0, False);

	foreach BasedActors(class'Fire', f)
		f.Destroy();
}

// ----------------------------------------------------------------------
// SpawnBlood()
// ----------------------------------------------------------------------

function SpawnBlood(Vector HitLocation, float Damage)
{
	local int i;

   if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
   {
      return;
   }

	spawn(class'BloodSpurt',,,HitLocation);
	spawn(class'BloodDrop',,,HitLocation);
	for (i=0; i<int(Damage); i+=10)
		spawn(class'BloodDrop',,,HitLocation);
}

// ----------------------------------------------------------------------
// PlayDXTakeDamageHit()
// DEUS_EX AMSD Created as a separate function to avoid extra calls to
// DXReduceDamage, which is slow in multiplayer
// ----------------------------------------------------------------------
function PlayDXTakeDamageHit(float Damage, vector HitLocation, name damageType, vector Momentum, bool DamageReduced)
{
	local float rnd;

   PlayHit(Damage,HitLocation,damageType,Momentum);

	// if we actually took the full damage, flash the screen and play the sound
   // DEUS_EX AMSD DXReduceDamage is slow.  Pass in the result from earlier.
	if (!DamageReduced) 
	{
		if ( (damage > 0) || (ReducedDamageType == 'All') )
		{
			// No client flash on plasma bolts in multiplayer
			if (( Level.NetMode != NM_Standalone ) && ( myProjKiller != None ) && (PlasmaBolt(myProjKiller)!=None) )
			{
			}
			else
			{
				rnd = FClamp(Damage, 20, 100);
				if (damageType == 'Burned')
					ClientFlash(rnd * 0.002, vect(200,100,100));
				else if (damageType == 'Flamed')
					ClientFlash(rnd * 0.002, vect(200,100,100));
				else if (damageType == 'Radiation')
					ClientFlash(rnd * 0.002, vect(100,100,0));
				else if (damageType == 'PoisonGas')
					ClientFlash(rnd * 0.002, vect(50,150,0));
				else if (damageType == 'TearGas')
					ClientFlash(rnd * 0.002, vect(150,150,0));
				else if (damageType == 'Drowned')
					ClientFlash(rnd * 0.002, vect(0,100,200));
				else if (damageType == 'EMP')
					ClientFlash(rnd * 0.002, vect(0,200,200));
				else 
					ClientFlash(rnd * 0.002, vect(50,0,0));
			}
			ShakeView(0.15 + 0.002 * Damage, Damage * 30, 0.3 * Damage); 
		}
	}
}

// ----------------------------------------------------------------------
// PlayHit()
// ----------------------------------------------------------------------

function PlayHit(float Damage, vector HitLocation, name damageType, vector Momentum)
{
	if ((Damage > 0) && (damageType == 'Shot') || (damageType == 'Exploded') || (damageType == 'AutoShot'))
		SpawnBlood(HitLocation, Damage);

	PlayTakeHitSound(Damage, damageType, 1);
}

// ----------------------------------------------------------------------
// PlayDeathHit()
// ----------------------------------------------------------------------

function PlayDeathHit(float Damage, vector HitLocation, name damageType, vector Momentum)
{
	PlayDying(damageType, HitLocation);
}

// ----------------------------------------------------------------------
// SkillPointsAdd()
// ----------------------------------------------------------------------

function SkillPointsAdd(int numPoints)
{
	if (numPoints > 0)
	{
		SkillPointsAvail += numPoints;
		SkillPointsTotal += numPoints;

		if ((DeusExRootWindow(rootWindow) != None) &&
		    (DeusExRootWindow(rootWindow).hud != None) && 
			(DeusExRootWindow(rootWindow).hud.msgLog != None))
		{
			ClientMessage(Sprintf(SkillPointsAward, numPoints));
			DeusExRootWindow(rootWindow).hud.msgLog.PlayLogSound(Sound'LogSkillPoints');
		}
	}
}

// ----------------------------------------------------------------------
// MakePlayerIgnored()
// ----------------------------------------------------------------------

function MakePlayerIgnored(bool bNewIgnore)
{
	bIgnore = bNewIgnore;
	// to restore original behavior, uncomment the next line
	//bDetectable = !bNewIgnore;
}

// ----------------------------------------------------------------------
// CalculatePlayerVisibility()
// ----------------------------------------------------------------------

function float CalculatePlayerVisibility(ScriptedPawn P)
{
	local float vis;
	local AdaptiveArmor armor;

	vis = 1.0;
	if ((P != None) && (AugmentationSystem != None))
	{
		if (P.IsA('Robot'))
		{
			// if the aug is on, give the player full invisibility
			if (AugmentationSystem.GetAugLevelValue(class'AugRadarTrans') != -1.0)
				vis = 0.0;
		}
		else
		{
			// if the aug is on, give the player full invisibility
			if (AugmentationSystem.GetAugLevelValue(class'AugCloak') != -1.0)
				vis = 0.0;
		}

		// go through the actor list looking for owned AdaptiveArmor
		// since they aren't in the inventory anymore after they are used

      if (UsingChargedPickup(class'AdaptiveArmor'))
			{
				vis = 0.0;
			}
	}

	return vis;
}

// ----------------------------------------------------------------------
// ClientFlash()
//
// copied from Engine.PlayerPawn
// modified to add the new flash to the current flash
// ----------------------------------------------------------------------
// MBCODE: changed to simulated so that player can experience flash client side
// DEUS_EX AMSD: Added so we can change the flash time duration.
simulated function ClientFlash( float scale, vector fog)
{
	DesiredFlashScale += scale;
	DesiredFlashFog += 0.001 * fog;
}

function IncreaseClientFlashLength(float NewFlashTime)
{
   FlashTimer = FMax(NewFlashTime,FlashTimer);
}

// ----------------------------------------------------------------------
// ViewFlash()
// modified so that flash doesn't always go away in exactly half a second.
// ---------------------------------------------------------------------
function ViewFlash(float DeltaTime)
{
	local float delta;
	local vector goalFog;
	local float goalscale, ReductionFactor;

   ReductionFactor = 2;

   if (FlashTimer > 0)
   {
      if (FlashTimer < Deltatime)
      {
         FlashTimer = 0;
      }
      else
      {
         ReductionFactor = 0;
         FlashTimer -= Deltatime;
      }
   }

   if ( bNoFlash )
	{
		InstantFlash = 0;
		InstantFog = vect(0,0,0);
	}

	delta = FMin(0.1, DeltaTime);
	goalScale = 1 + DesiredFlashScale + ConstantGlowScale + HeadRegion.Zone.ViewFlash.X; 
	goalFog = DesiredFlashFog + ConstantGlowFog + HeadRegion.Zone.ViewFog;
	DesiredFlashScale -= DesiredFlashScale * ReductionFactor * delta;  
	DesiredFlashFog -= DesiredFlashFog * ReductionFactor * delta;
	FlashScale.X += (goalScale - FlashScale.X + InstantFlash) * 10 * delta;
	FlashFog += (goalFog - FlashFog + InstantFog) * 10 * delta;
	InstantFlash = 0;
	InstantFog = vect(0,0,0);

	if ( FlashScale.X > 0.981 )
		FlashScale.X = 1;
	FlashScale = FlashScale.X * vect(1,1,1);

	if ( FlashFog.X < 0.019 )
		FlashFog.X = 0;
	if ( FlashFog.Y < 0.019 )
		FlashFog.Y = 0;
	if ( FlashFog.Z < 0.019 )
		FlashFog.Z = 0;
}
// ----------------------------------------------------------------------
// ViewModelAdd()
//
// lets an artist (or whoever) view a model and play animations on it
// from within the game
// ----------------------------------------------------------------------

exec function ViewModelAdd(int num, string ClassName)
{
	local class<actor> ViewModelClass;
	local rotator newrot;
	local vector loc;

	if (!bCheatsEnabled)
		return;

	if(instr(ClassName, ".") == -1)
		ClassName = "DeusEx." $ ClassName;

	if ((num >= 0) && (num <= 8))
	{
		if (num > 0)
			num--;

		if (ViewModelActor[num] == None)
		{
			ViewModelClass = class<actor>(DynamicLoadObject(ClassName, class'Class'));
			if (ViewModelClass != None)
			{
				newrot = Rotation;
				newrot.Roll = 0;
				newrot.Pitch = 0;
				loc = Location + (ViewModelClass.Default.CollisionRadius + CollisionRadius + 32) * Vector(newrot);
				loc.Z += ViewModelClass.Default.CollisionHeight;
				ViewModelActor[num] = Spawn(ViewModelClass,,, loc, newrot);
				if (ViewModelActor[num] != None)
					ViewModelActor[num].SetPhysics(PHYS_None);
				if (ScriptedPawn(ViewModelActor[num]) != None)
					ViewModelActor[num].GotoState('Paralyzed');
			}
		}
		else
			ClientMessage("There is already a ViewModel in that slot!");
	}
}

// ----------------------------------------------------------------------
// ViewModelDestroy()
//
// destroys the current ViewModel
// ----------------------------------------------------------------------

exec function ViewModelDestroy(int num)
{
	local int i;

	if (!bCheatsEnabled)
		return;

	if ((num >= 0) && (num <= 8))
	{
		if (num == 0)
		{
			for (i=0; i<8; i++)
				if (ViewModelActor[i] != None)
				{
					ViewModelActor[i].Destroy();
					ViewModelActor[i] = None;
				}
		}
		else
		{
			i = num - 1;
			if (ViewModelActor[i] != None)
			{
				ViewModelActor[i].Destroy();
				ViewModelActor[i] = None;
			}
		}
	}
}

// ----------------------------------------------------------------------
// ViewModelPlay()
//
// plays an animation on the current ViewModel
// ----------------------------------------------------------------------

exec function ViewModelPlay(int num, name anim, optional float fps)
{
	local int i;

	if (!bCheatsEnabled)
		return;

	if ((num >= 0) && (num <= 8))
	{
		if (num == 0)
		{
			for (i=0; i<8; i++)
				if (ViewModelActor[i] != None)
				{
					if (fps == 0)
						fps = 1.0;
					ViewModelActor[i].PlayAnim(anim, fps);
				}
		}
		else
		{
			i = num - 1;
			if (ViewModelActor[i] != None)
			{
				if (fps == 0)
					fps = 1.0;
				ViewModelActor[i].PlayAnim(anim, fps);
			}
		}
	}
}

// ----------------------------------------------------------------------
// ViewModelLoop()
//
// loops an animation on the current ViewModel
// ----------------------------------------------------------------------

exec function ViewModelLoop(int num, name anim, optional float fps)
{
	local int i;

	if (!bCheatsEnabled)
		return;

	if ((num >= 0) && (num <= 8))
	{
		if (num == 0)
		{
			for (i=0; i<8; i++)
				if (ViewModelActor[i] != None)
				{
					if (fps == 0)
						fps = 1.0;
					ViewModelActor[i].LoopAnim(anim, fps);
				}
		}
		else
		{
			i = num - 1;
			if (ViewModelActor[i] != None)
			{
				if (fps == 0)
					fps = 1.0;
				ViewModelActor[i].LoopAnim(anim, fps);
			}
		}
	}
}

// ----------------------------------------------------------------------
// ViewModelBlendPlay()
//
// plays a blended animation on the current ViewModel
// ----------------------------------------------------------------------

exec function ViewModelBlendPlay(int num, name anim, optional float fps, optional int slot)
{
	local int i;

	if (!bCheatsEnabled)
		return;

	if ((num >= 0) && (num <= 8))
	{
		if (num == 0)
		{
			for (i=0; i<8; i++)
				if (ViewModelActor[i] != None)
				{
					if (fps == 0)
						fps = 1.0;
					ViewModelActor[i].PlayBlendAnim(anim, fps, , slot);
				}
		}
		else
		{
			i = num - 1;
			if (ViewModelActor[i] != None)
			{
				if (fps == 0)
					fps = 1.0;
				ViewModelActor[i].PlayBlendAnim(anim, fps, , slot);
			}
		}
	}
}

// ----------------------------------------------------------------------
// ViewModelBlendStop()
//
// stops the blended animation on the current ViewModel
// ----------------------------------------------------------------------

exec function ViewModelBlendStop(int num)
{
	local int i;

	if (!bCheatsEnabled)
		return;

	if ((num >= 0) && (num <= 8))
	{
		if (num == 0)
		{
			for (i=0; i<8; i++)
				if (ViewModelActor[i] != None)
					ViewModelActor[i].StopBlendAnims();
		}
		else
		{
			i = num - 1;
			if (ViewModelActor[i] != None)
				ViewModelActor[i].StopBlendAnims();
		}
	}
}

exec function ViewModelGiveWeapon(int num, string weaponClass)
{
	local class<Actor> NewClass;
	local Actor obj;
	local int i;
	local ScriptedPawn pawn;

	if (!bCheatsEnabled)
		return;

	if (instr(weaponClass, ".") == -1)
		weaponClass = "DeusEx." $ weaponClass;

	if ((num >= 0) && (num <= 8))
	{
		NewClass = class<Actor>(DynamicLoadObject(weaponClass, class'Class'));

		if (NewClass != None)
		{
			obj = Spawn(NewClass,,, Location + (CollisionRadius+NewClass.Default.CollisionRadius+30) * Vector(Rotation) + vect(0,0,1) * 15);
			if ((obj != None) && obj.IsA('DeusExWeapon'))
			{
				if (num == 0)
				{
					for (i=0; i<8; i++)
					{
						pawn = ScriptedPawn(ViewModelActor[i]);
						if (pawn != None)
						{
							DeusExWeapon(obj).GiveTo(pawn);
							obj.SetBase(pawn);
							pawn.Weapon = DeusExWeapon(obj);
							pawn.PendingWeapon = DeusExWeapon(obj);
						}
					}
				}
				else
				{
					i = num - 1;
					pawn = ScriptedPawn(ViewModelActor[i]);
					if (pawn != None)
					{
						DeusExWeapon(obj).GiveTo(pawn);
						obj.SetBase(pawn);
						pawn.Weapon = DeusExWeapon(obj);
						pawn.PendingWeapon = DeusExWeapon(obj);
					}
				}
			}
			else
			{
				if (obj != None)
					obj.Destroy();
			}
		}
	}
}

// ----------------------------------------------------------------------
// aliases to ViewModel functions
// ----------------------------------------------------------------------

exec function VMA(int num, string ClassName)
{
	ViewModelAdd(num, ClassName);
}

exec function VMD(int num)
{
	ViewModelDestroy(num);
}

exec function VMP(int num, name anim, optional float fps)
{
	ViewModelPlay(num, anim, fps);
}

exec function VML(int num, name anim, optional float fps)
{
	ViewModelLoop(num, anim, fps);
}

exec function VMBP(int num, name anim, optional float fps, optional int slot)
{
	ViewModelBlendPlay(num, anim, fps, slot);
}

exec function VMBS(int num)
{
	ViewModelBlendStop(num);
}

exec function VMGW(int num, string weaponClass)
{
	ViewModelGiveWeapon(num, weaponClass);
}

// ----------------------------------------------------------------------
// Cheat functions
//
// ----------------------------------------------------------------------
// AllHealth()
// ----------------------------------------------------------------------

exec function AllHealth()
{
	if (!bCheatsEnabled)
		return;

	RestoreAllHealth();
}

// ----------------------------------------------------------------------
// RestoreAllHealth()
// ----------------------------------------------------------------------

function RestoreAllHealth()
{
	HealthHead = default.HealthHead;
	HealthTorso = default.HealthTorso;
	HealthLegLeft = default.HealthLegLeft;
	HealthLegRight = default.HealthLegRight;
	HealthArmLeft = default.HealthArmLeft;
	HealthArmRight = default.HealthArmRight;
	Health = default.Health;
}

// ----------------------------------------------------------------------
// DamagePart()
// ----------------------------------------------------------------------

exec function DamagePart(int partIndex, optional int amount)
{
	if (!bCheatsEnabled)
		return;

	if (amount == 0)
		amount = 1000;

	switch(partIndex)
	{
		case 0:		// head
			HealthHead -= Min(HealthHead, amount);
			break;

		case 1:		// torso
			HealthTorso -= Min(HealthTorso, amount);
			break;

		case 2:		// left arm
			HealthArmLeft -= Min(HealthArmLeft, amount);
			break;

		case 3:		// right arm
			HealthArmRight -= Min(HealthArmRight, amount);
			break;

		case 4:		// left leg
			HealthLegLeft -= Min(HealthLegLeft, amount);
			break;

		case 5:		// right leg
			HealthLegRight -= Min(HealthLegRight, amount);
			break;
	}
}

// ----------------------------------------------------------------------
// DamageAll()
// ----------------------------------------------------------------------

exec function DamageAll(optional int amount)
{
	if (!bCheatsEnabled)
		return;

	if (amount == 0)
		amount = 1000;

	HealthHead     -= Min(HealthHead, amount);
	HealthTorso    -= Min(HealthTorso, amount);
	HealthArmLeft  -= Min(HealthArmLeft, amount);
	HealthArmRight -= Min(HealthArmRight, amount);
	HealthLegLeft  -= Min(HealthLegLeft, amount);
	HealthLegRight -= Min(HealthLegRight, amount);
}

// ----------------------------------------------------------------------
// AllEnergy()
// ----------------------------------------------------------------------

exec function AllEnergy()
{
	if (!bCheatsEnabled)
		return;

	Energy = default.Energy;
}

// ----------------------------------------------------------------------
// AllCredits()
// ----------------------------------------------------------------------

exec function AllCredits()
{
	if (!bCheatsEnabled)
		return;

	Credits = 100000;
}

// ---------------------------------------------------------------------
// AllSkills()
// ----------------------------------------------------------------------

exec function AllSkills()
{
	if (!bCheatsEnabled)
		return;

	AllSkillPoints();
	SkillSystem.AddAllSkills();
}

// ----------------------------------------------------------------------
// AllSkillPoints()
// ----------------------------------------------------------------------

exec function AllSkillPoints()
{
	if (!bCheatsEnabled)
		return;

	SkillPointsTotal = 115900;
	SkillPointsAvail = 115900;
}

// ----------------------------------------------------------------------
// AllAugs()
// ----------------------------------------------------------------------

exec function AllAugs()
{
	local Augmentation anAug;
	local int i;
	
	if (!bCheatsEnabled)
		return;

	if (AugmentationSystem != None)
	{
		AugmentationSystem.AddAllAugs();
		AugmentationSystem.SetAllAugsToMaxLevel();
	}
}

// ----------------------------------------------------------------------
// AllWeapons()
// ----------------------------------------------------------------------

exec function AllWeapons()
{
	local Vector loc;

	if (!bCheatsEnabled)
		return;

	loc = Location + 2 * CollisionRadius * Vector(ViewRotation);

	Spawn(class'WeaponAssaultGun',,, loc);
	Spawn(class'WeaponAssaultShotgun',,, loc);
	Spawn(class'WeaponBaton',,, loc);
	Spawn(class'WeaponCombatKnife',,, loc);
	Spawn(class'WeaponCrowbar',,, loc);
	Spawn(class'WeaponEMPGrenade',,, loc);
	Spawn(class'WeaponFlamethrower',,, loc);
	Spawn(class'WeaponGasGrenade',,, loc);
	Spawn(class'WeaponGEPGun',,, loc);
	Spawn(class'WeaponHideAGun',,, loc);
	Spawn(class'WeaponLAM',,, loc);
	Spawn(class'WeaponLAW',,, loc);
	Spawn(class'WeaponMiniCrossbow',,, loc);
	Spawn(class'WeaponNanoSword',,, loc);
	Spawn(class'WeaponNanoVirusGrenade',,, loc);
	Spawn(class'WeaponPepperGun',,, loc);
	Spawn(class'WeaponPistol',,, loc);
	Spawn(class'WeaponPlasmaRifle',,, loc);
	Spawn(class'WeaponProd',,, loc);
	Spawn(class'WeaponRifle',,, loc);
	Spawn(class'WeaponSawedOffShotgun',,, loc);
	Spawn(class'WeaponShuriken',,, loc);
	Spawn(class'WeaponStealthPistol',,, loc);
	Spawn(class'WeaponSword',,, loc);
}

// ----------------------------------------------------------------------
// AllImages()
// ----------------------------------------------------------------------

exec function AllImages()
{
	local Vector loc;
	local Inventory item;

	if (!bCheatsEnabled)
		return;

	item = Spawn(class'Image01_GunFireSensor');
	item.Frob(Self, None);
	item = Spawn(class'Image01_LibertyIsland');
	item.Frob(Self, None);
	item = Spawn(class'Image01_TerroristCommander');
	item.Frob(Self, None);
	item = Spawn(class'Image02_Ambrosia_Flyer');
	item.Frob(Self, None);
	item = Spawn(class'Image02_NYC_Warehouse');
	item.Frob(Self, None);
	item = Spawn(class'Image02_BobPage_ManOfYear');
	item.Frob(Self, None);
	item = Spawn(class'Image03_747Diagram');
	item.Frob(Self, None);
	item = Spawn(class'Image03_NYC_Airfield');
	item.Frob(Self, None);
	item = Spawn(class'Image03_WaltonSimons');
	item.Frob(Self, None);
	item = Spawn(class'Image04_NSFHeadquarters');
	item.Frob(Self, None);
	item = Spawn(class'Image04_UNATCONotice');
	item.Frob(Self, None);
	item = Spawn(class'Image05_GreaselDisection');
	item.Frob(Self, None);
	item = Spawn(class'Image05_NYC_MJ12Lab');
	item.Frob(Self, None);
	item = Spawn(class'Image06_HK_Market');
	item.Frob(Self, None);
	item = Spawn(class'Image06_HK_MJ12Helipad');
	item.Frob(Self, None);
	item = Spawn(class'Image06_HK_MJ12Lab');
	item.Frob(Self, None);
	item = Spawn(class'Image06_HK_Versalife');
	item.Frob(Self, None);
	item = Spawn(class'Image06_HK_WanChai');
	item.Frob(Self, None);
	item = Spawn(class'Image08_JoeGreenMIBMJ12');
	item.Frob(Self, None);
	item = Spawn(class'Image09_NYC_Ship_Bottom');
	item.Frob(Self, None);
	item = Spawn(class'Image09_NYC_Ship_Top');
	item.Frob(Self, None);
	item = Spawn(class'Image10_Paris_Catacombs');
	item.Frob(Self, None);
	item = Spawn(class'Image10_Paris_CatacombsTunnels');
	item.Frob(Self, None);
	item = Spawn(class'Image10_Paris_Metro');
	item.Frob(Self, None);
	item = Spawn(class'Image11_Paris_Cathedral');
	item.Frob(Self, None);
	item = Spawn(class'Image11_Paris_CathedralEntrance');
	item.Frob(Self, None);
	item = Spawn(class'Image12_Vandenberg_Command');
	item.Frob(Self, None);
	item = Spawn(class'Image12_Vandenberg_Sub');
	item.Frob(Self, None);
	item = Spawn(class'Image12_Tiffany_HostagePic');
	item.Frob(Self, None);
	item = Spawn(class'Image14_OceanLab');
	item.Frob(Self, None);
	item = Spawn(class'Image14_Schematic');
	item.Frob(Self, None);
	item = Spawn(class'Image15_Area51Bunker');
	item.Frob(Self, None);
	item = Spawn(class'Image15_GrayDisection');
	item.Frob(Self, None);
	item = Spawn(class'Image15_BlueFusionDevice');
	item.Frob(Self, None);
	item = Spawn(class'Image15_Area51_Sector3');
	item.Frob(Self, None);
	item = Spawn(class'Image15_Area51_Sector4');
	item.Frob(Self, None);
}

// ----------------------------------------------------------------------
// Trig()
// ----------------------------------------------------------------------

exec function Trig(name ev)
{
	local Actor A;

	if (!bCheatsEnabled)
		return;

	if (ev != '')
		foreach AllActors(class'Actor', A, ev)
			A.Trigger(Self, Self);
}

// ----------------------------------------------------------------------
// UnTrig()
// ----------------------------------------------------------------------

exec function UnTrig(name ev)
{
	local Actor A;

	if (!bCheatsEnabled)
		return;

	if (ev != '')
		foreach AllActors(class'Actor', A, ev)
			A.UnTrigger(Self, Self);
}

// ----------------------------------------------------------------------
// SetState()
// ----------------------------------------------------------------------

exec function SetState(name state)
{
	local ScriptedPawn P;
	local Actor hitActor;
	local vector loc, line, HitLocation, hitNormal;

	if (!bCheatsEnabled)
		return;

	loc = Location;
	loc.Z += BaseEyeHeight;
	line = Vector(ViewRotation) * 2000;

	hitActor = Trace(hitLocation, hitNormal, loc+line, loc, true);
	P = ScriptedPawn(hitActor);
	if (P != None)
	{
		P.GotoState(state);
		ClientMessage("Setting "$P.BindName$" to the "$state$" state");
	}
}

// ----------------------------------------------------------------------
// DXDumpInfo()
//
// Dumps the following player information to the log file
// - inventory (with item counts)
// - health (as %)
// - energy (as %)
// - credits
// - skill points (avail and max)
// - skills
// - augmentations
// ----------------------------------------------------------------------

exec function DXDumpInfo()
{
	local DumpLocation dumploc;
	local DeusExLevelInfo info;
	local string userName, mapName, strCopies;
	local Inventory item, nextItem;
	local DeusExWeapon W;
	local Skill skill;
	local Augmentation aug;
	local bool bHasAugs;

	dumploc = CreateDumpLocationObject();
	if (dumploc != None)
	{
		userName = dumploc.GetCurrentUser();
		CriticalDelete(dumploc);
	}

	if (userName == "")
		userName = "NO USERNAME";

	mapName = "NO MAPNAME";
	foreach AllActors(class'DeusExLevelInfo', info)
		mapName = info.MapName;

	log("");
	log("**** DXDumpInfo - User: "$userName$" - Map: "$mapName$" ****");
	log("");
	log("  Inventory:");

	if (Inventory != None)
	{
		item = Inventory;
		do
		{
			nextItem = item.Inventory;

			if (item.bDisplayableInv || item.IsA('Ammo'))
			{
				W = DeusExWeapon(item);
				if ((W != None) && W.bHandToHand && (W.ProjectileClass != None))
					strCopies = " ("$W.AmmoType.AmmoAmount$" rds)";
				else if (item.IsA('Ammo') && (Ammo(item).PickupViewMesh != Mesh'TestBox'))
					strCopies = " ("$Ammo(item).AmmoAmount$" rds)";
				else if (item.IsA('Pickup') && (Pickup(item).NumCopies > 1))
					strCopies = " ("$Pickup(item).NumCopies$")";
				else
					strCopies = "";

				log("    "$item.GetItemName(String(item.Class))$strCopies);
			}
			item = nextItem;
		}
		until (item == None);
	}
	else
		log("    Empty");

	GenerateTotalHealth();
	log("");
	log("  Health:");
	log("    Overall   - "$Health$"%");
	log("    Head      - "$HealthHead$"%");
	log("    Torso     - "$HealthTorso$"%");
	log("    Left arm  - "$HealthArmLeft$"%");
	log("    Right arm - "$HealthArmRight$"%");
	log("    Left leg  - "$HealthLegLeft$"%");
	log("    Right leg - "$HealthLegRight$"%");

	log("");
	log("  BioElectric Energy:");
	log("    "$Int(Energy)$"%");

	log("");
	log("  Credits:");
	log("    "$Credits);

	log("");
	log("  Skill Points:");
	log("    Available    - "$SkillPointsAvail);
	log("    Total Earned - "$SkillPointsTotal);

	log("");
	log("  Skills:");
	if (SkillSystem != None)
	{
		skill = SkillSystem.FirstSkill;
		while (skill != None)
		{
			if (skill.SkillName != "")
				log("    "$skill.SkillName$" - "$skill.skillLevelStrings[skill.CurrentLevel]);

			skill = skill.next;
		}
	}

	bHasAugs = False;
	log("");
	log("  Augmentations:");
	if (AugmentationSystem != None)
	{
		aug = AugmentationSystem.FirstAug;
		while (aug != None)
		{
			if (aug.bHasIt && (aug.AugmentationLocation != LOC_Default) && (aug.AugmentationName != ""))
			{
				bHasAugs = True;
				log("    "$aug.AugmentationName$" - Location: "$aug.AugLocsText[aug.AugmentationLocation]$" - Level: "$aug.CurrentLevel+1);
			}

			aug = aug.next;
		}
	}

	if (!bHasAugs)
		log("    None");

	log("");
	log("**** DXDumpInfo - END ****");
	log("");

	ClientMessage("Info dumped for user "$userName);
}


// ----------------------------------------------------------------------
// InvokeUIScreen()
//
// Calls DeusExRootWindow::InvokeUIScreen(), but first make sure 
// a modifier (Alt, Shift, Ctrl) key isn't being held down.
// ----------------------------------------------------------------------

function InvokeUIScreen(Class<DeusExBaseWindow> windowClass)
{
	local DeusExRootWindow root;
	root = DeusExRootWindow(rootWindow);
	if (root != None)
	{
		if ( root.IsKeyDown( IK_Alt ) || root.IsKeyDown( IK_Shift ) || root.IsKeyDown( IK_Ctrl ))
			return;

		root.InvokeUIScreen(windowClass);
	}
}

// ----------------------------------------------------------------------
// ResetConversationHistory()
//
// Clears any conversation history, used primarily when starting a 
// new game or travelling to new missions
// ----------------------------------------------------------------------

function ResetConversationHistory()
{
	if (conHistory != None)
	{
		CriticalDelete(conHistory);
		conHistory = None;
	}
}

// ======================================================================
// ======================================================================
// COLOR THEME MANAGER FUNCTIONS
// ======================================================================
// ======================================================================

// ----------------------------------------------------------------------
// CreateThemeManager()
// ----------------------------------------------------------------------

function CreateColorThemeManager()
{
	if (ThemeManager == None)
	{
		ThemeManager = Spawn(Class'ColorThemeManager', Self);

		// Add all default themes.

		// Menus
		ThemeManager.AddTheme(Class'ColorThemeMenu_Default');
		ThemeManager.AddTheme(Class'ColorThemeMenu_BlueAndGold');
		ThemeManager.AddTheme(Class'ColorThemeMenu_CoolGreen');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Cops');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Cyan');
		ThemeManager.AddTheme(Class'ColorThemeMenu_DesertStorm');
		ThemeManager.AddTheme(Class'ColorThemeMenu_DriedBlood');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Dusk');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Earth');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Green');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Grey');
		ThemeManager.AddTheme(Class'ColorThemeMenu_IonStorm');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Lava');
		ThemeManager.AddTheme(Class'ColorThemeMenu_NightVision');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Ninja');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Olive');
		ThemeManager.AddTheme(Class'ColorThemeMenu_PaleGreen');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Pastel');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Plasma');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Primaries');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Purple');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Red');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Seawater');
		ThemeManager.AddTheme(Class'ColorThemeMenu_SoylentGreen');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Starlight');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Steel');
		ThemeManager.AddTheme(Class'ColorThemeMenu_SteelGreen');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Superhero');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Terminator');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Violet');

		// HUD
		ThemeManager.AddTheme(Class'ColorThemeHUD_Default');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Amber');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Cops');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Cyan');
		ThemeManager.AddTheme(Class'ColorThemeHUD_DarkBlue');
		ThemeManager.AddTheme(Class'ColorThemeHUD_DesertStorm');
		ThemeManager.AddTheme(Class'ColorThemeHUD_DriedBlood');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Dusk');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Grey');
		ThemeManager.AddTheme(Class'ColorThemeHUD_IonStorm');
		ThemeManager.AddTheme(Class'ColorThemeHUD_NightVision');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Ninja');
		ThemeManager.AddTheme(Class'ColorThemeHUD_PaleGreen');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Pastel');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Plasma');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Primaries');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Purple');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Red');
		ThemeManager.AddTheme(Class'ColorThemeHUD_SoylentGreen');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Starlight');
		ThemeManager.AddTheme(Class'ColorThemeHUD_SteelGreen');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Superhero');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Terminator');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Violet');
	}
}

// ----------------------------------------------------------------------
// NextHUDColorTheme()
// 
// Cycles to the next available HUD color theme and squirts out 
// a "StylesChanged" event.
// ----------------------------------------------------------------------

exec function NextHUDColorTheme()
{
	if (ThemeManager != None)
	{
		ThemeManager.NextHUDColorTheme();
		DeusExRootWindow(rootWindow).ChangeStyle();
	}
}

// ----------------------------------------------------------------------
// Cycles to the next available Menu color theme and squirts out 
// a "StylesChanged" event.
// ----------------------------------------------------------------------

exec function NextMenuColorTheme()
{
	if (ThemeManager != None)
	{
		ThemeManager.NextMenuColorTheme();
		DeusExRootWindow(rootWindow).ChangeStyle();
	}
}

// ----------------------------------------------------------------------
// SetHUDBordersVisible()
// ----------------------------------------------------------------------

exec function SetHUDBordersVisible(bool bVisible)
{
	bHUDBordersVisible = bVisible;
}

// ----------------------------------------------------------------------
// GetHUDBordersVisible()
// ----------------------------------------------------------------------

function bool GetHUDBordersVisible()
{
	return bHUDBordersVisible;
}

// ----------------------------------------------------------------------
// SetHUDBorderTranslucency()
// ----------------------------------------------------------------------

exec function SetHUDBorderTranslucency(bool bNewTranslucency)
{
	bHUDBordersTranslucent = bNewTranslucency;
}

// ----------------------------------------------------------------------
// GetHUDBorderTranslucency()
// ----------------------------------------------------------------------

function bool GetHUDBorderTranslucency()
{
	return bHUDBordersTranslucent;
}

// ----------------------------------------------------------------------
// SetHUDBackgroundTranslucency()
// ----------------------------------------------------------------------

exec function SetHUDBackgroundTranslucency(bool bNewTranslucency)
{
	bHUDBackgroundTranslucent = bNewTranslucency;
}

// ----------------------------------------------------------------------
// GetHUDBackgroundTranslucency()
// ----------------------------------------------------------------------

function bool GetHUDBackgroundTranslucency()
{
	return bHUDBackgroundTranslucent;
}

// ----------------------------------------------------------------------
// SetMenuTranslucency()
// ----------------------------------------------------------------------

exec function SetMenuTranslucency(bool bNewTranslucency)
{
	bMenusTranslucent = bNewTranslucency;
}

// ----------------------------------------------------------------------
// GetMenuTranslucency()
// ----------------------------------------------------------------------

function bool GetMenuTranslucency()
{
	return bMenusTranslucent;
}

// ----------------------------------------------------------------------
// DebugInfo test functions
// ----------------------------------------------------------------------

exec function DebugCommand(string teststr)
{
	if (!bCheatsEnabled)
		return;

	if (GlobalDebugObj == None)
		GlobalDebugObj = new(Self) class'DebugInfo';

	if (GlobalDebugObj != None)
		GlobalDebugObj.Command(teststr);
}

exec function SetDebug(name cmd, name val)
{
	if (!bCheatsEnabled)
		return;

	if (GlobalDebugObj == None)
		GlobalDebugObj = new(Self) class'DebugInfo';

	Log("Want to setting Debug String " $ cmd $ " to " $ val);

	if (GlobalDebugObj != None)
		GlobalDebugObj.SetString(String(cmd),String(val));
}

exec function GetDebug(name cmd)
{
	local string temp;

	if (!bCheatsEnabled)
		return;

	if (GlobalDebugObj == None)
		GlobalDebugObj = new(Self) class'DebugInfo';

	if (GlobalDebugObj != None)
	{
		temp=GlobalDebugObj.GetString(String(cmd));
		Log("Debug String " $ cmd $ " has value " $ temp);
	}
}

exec function LogMsg(string msg)
{
	Log(msg);
}

simulated event Destroyed()
{
	if (GlobalDebugObj != None)
		CriticalDelete(GlobalDebugObj);

   ClearAugmentationDisplay();

   if (Role == ROLE_Authority)   
      CloseThisComputer(ActiveComputer);
   ActiveComputer = None;

	Super.Destroyed();
}

// ----------------------------------------------------------------------
// Actor Location and Movement commands
// ----------------------------------------------------------------------

exec function MoveActor(int xPos, int yPos, int zPos)
{
	local Actor            hitActor;
	local Vector           hitLocation, hitNormal;
	local Vector           position, line, newPos;

	if (!bCheatsEnabled)
		return;

	position    = Location;
	position.Z += BaseEyeHeight;
	line        = Vector(ViewRotation) * 4000;

	hitActor = Trace(hitLocation, hitNormal, position+line, position, true);
	if (hitActor != None)
	{
		newPos.x=xPos;
		newPos.y=yPos;
		newPos.z=zPos;
		// hitPawn = ScriptedPawn(hitActor);
		Log( "Trying to move " $ hitActor.Name $ " from " $ hitActor.Location $ " to " $ newPos);
		hitActor.SetLocation(newPos);
		Log( "Ended up at " $ hitActor.Location );
	}
}

exec function WhereActor(optional int Me)
{
	local Actor            hitActor;
	local Vector           hitLocation, hitNormal;
	local Vector           position, line, newPos;

	if (!bCheatsEnabled)
		return;

	if (Me==1)
		hitActor=self;
	else
	{
		position    = Location;
		position.Z += BaseEyeHeight;
		line        = Vector(ViewRotation) * 4000;
		hitActor    = Trace(hitLocation, hitNormal, position+line, position, true);
	}
	if (hitActor != None)
	{
		Log( hitActor.Name $ " is at " $ hitActor.Location );
		BroadcastMessage( hitActor.Name $ " is at " $ hitActor.Location );
	}
}

// ----------------------------------------------------------------------
// Easter egg functions
// ----------------------------------------------------------------------

function Matrix()
{
	if (Sprite == None)
	{
		Sprite = Texture(DynamicLoadObject("Extras.Matrix_A00", class'Texture'));
		ConsoleCommand("RMODE 6");
	}
	else
	{
		Sprite = None;
		ConsoleCommand("RMODE 5");
	}
}

exec function IAmWarren()
{
	if (!bCheatsEnabled)
		return;

	if (!bWarrenEMPField)
	{
		bWarrenEMPField = true;
		WarrenTimer = 0;
		WarrenSlot  = 0;
		ClientMessage("Warren's EMP Field activated");  // worry about localization?
	}
	else
	{
		bWarrenEMPField = false;
		ClientMessage("Warren's EMP Field deactivated");  // worry about localization?
	}
}

// ----------------------------------------------------------------------
// UsingChargedPickup
// ----------------------------------------------------------------------

function bool UsingChargedPickup(class<ChargedPickup> itemclass)
{
   local inventory CurrentItem;
   local bool bFound;

   bFound = false;
   
   for (CurrentItem = Inventory; ((CurrentItem != None) && (!bFound)); CurrentItem = CurrentItem.inventory)
   {
      if ((CurrentItem.class == itemclass) && (CurrentItem.bActive))
         bFound = true;
   }

   return bFound;
}

// ----------------------------------------------------------------------
// MultiplayerSpecificFunctions
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// ReceiveFirstOptionSync()
// DEUS_EX AMSD I have to enumerate every 2#%#@%Ing argument???
// ----------------------------------------------------------------------

function ReceiveFirstOptionSync ( Name PrefZero, Name PrefOne, Name PrefTwo, Name PrefThree, Name PrefFour)
{
   local int i;
   local Name AugPriority[5];

   if (bFirstOptionsSynced == true)
   {
      return;
   }

   AugPriority[0] = PrefZero;
   AugPriority[1] = PrefOne;
   AugPriority[2] = PrefTwo;
   AugPriority[3] = PrefThree;
   AugPriority[4] = PrefFour;

   for (i = 0; ((i < ArrayCount(AugPrefs)) && (i < ArrayCount(AugPriority))); i++)
   {   
      AugPrefs[i] = AugPriority[i];
   }
   bFirstOptionsSynced = true;

   if (Role == ROLE_Authority)
   {
      if ((DeusExMPGame(Level.Game) != None) && (bSecondOptionsSynced))
      {
         DeusExMPGame(Level.Game).SetupAbilities(self);
      }
   }
}

// ----------------------------------------------------------------------
// ReceiveSecondOptionSync()
// DEUS_EX AMSD I have to enumerate every 2#%#@%Ing argument???
// ----------------------------------------------------------------------

function ReceiveSecondOptionSync ( Name PrefFive, Name PrefSix, Name PrefSeven, Name PrefEight)
{
   local int i;
   local Name AugPriority[9];

   if (bSecondOptionsSynced == true)
   {
      return;
   }

   AugPriority[5] = PrefFive;
   AugPriority[6] = PrefSix;
   AugPriority[7] = PrefSeven;
   AugPriority[8] = PrefEight;

   for (i = 5; ((i < ArrayCount(AugPrefs)) && (i < ArrayCount(AugPriority))); i++)
   {   
      AugPrefs[i] = AugPriority[i];
   }
   bSecondOptionsSynced = true;

   if (Role == ROLE_Authority)
   {
      if ((DeusExMPGame(Level.Game) != None) && (bFirstOptionsSynced))
      {
         DeusExMPGame(Level.Game).SetupAbilities(self);
      }
   }
}

// ----------------------------------------------------------------------
// ClientPlayAnimation
// ----------------------------------------------------------------------

simulated function ClientPlayAnimation( Actor src, Name anim, float rate, bool bLoop )
{
	if ( src != None )
	{
			//		if ( bLoop )
			//			src.LoopAnim(anim, ,rate);
			//		else
			src.PlayAnim(anim, ,rate);
	}
}

// ----------------------------------------------------------------------
// ClientSpawnProjectile
// ----------------------------------------------------------------------

simulated function ClientSpawnProjectile( class<projectile> ProjClass, Actor owner, Vector Start, Rotator AdjustedAim )
{
	local DeusExProjectile proj;

	proj = DeusExProjectile(Spawn(ProjClass, Owner,, Start, AdjustedAim));
	if ( proj != None )
	{
		proj.RemoteRole = ROLE_None;
		proj.Damage = 0;
	}
}

// ----------------------------------------------------------------------
// ClientSpawnHits
// ----------------------------------------------------------------------

simulated function ClientSpawnHits( bool bPenetrating, bool bHandToHand, Vector HitLocation, Vector HitNormal, Actor Other, float Damage)
{
   local TraceHitSpawner hitspawner;

   if (bPenetrating)
   {
      if (bHandToHand)
      {
         hitspawner = Spawn(class'TraceHitHandSpawner',Other,,HitLocation,Rotator(HitNormal));
      }
      else
      {
         hitspawner = Spawn(class'TraceHitSpawner',Other,,HitLocation,Rotator(HitNormal));
			hitspawner.HitDamage = Damage;
      }
   }
   else
   {
      if (bHandToHand)
      {
         hitspawner = Spawn(class'TraceHitHandNonPenSpawner',Other,,HitLocation,Rotator(HitNormal));
      }
      else
      {
         hitspawner = Spawn(class'TraceHitNonPenSpawner',Other,,HitLocation,Rotator(HitNormal));
      }
   }
   if (hitSpawner != None)
      hitspawner.HitDamage = Damage;
}

// ----------------------------------------------------------------------
// NintendoImmunityEffect()
// ----------------------------------------------------------------------
function NintendoImmunityEffect( bool on )
{
	bNintendoImmunity = on;

	if (bNintendoImmunity)
	{
 		NintendoImmunityTime = Level.Timeseconds + NintendoDelay;
		NintendoImmunityTimeLeft = NintendoDelay;
	}
	else
		NintendoImmunityTimeLeft = 0.0;
}

// ----------------------------------------------------------------------
// GetAugPriority()
// Returns -1 if the player has the aug.
// Returns 0-8 (0 being higher priority) for the aug priority.
// If the player doesn't list the aug as a priority, returns the first
// unoccupied slot num (9 if all are filled).
// ----------------------------------------------------------------------
function int GetAugPriority( Augmentation AugToCheck)
{   
   local Name AugName;
   local int PriorityIndex;
   
   AugName = AugToCheck.Class.Name;

   if (AugToCheck.bHasIt)
      return -1;

   for (PriorityIndex = 0; PriorityIndex < ArrayCount(AugPrefs); PriorityIndex++)
   {
      if (AugPrefs[PriorityIndex] == AugName)
      {
         return PriorityIndex;
      }
      if (AugPrefs[PriorityIndex] == '')
      {
         return PriorityIndex;
      }
   }

   return PriorityIndex;   
}

// ----------------------------------------------------------------------
// GrantAugs()
// Grants augs in order of priority.
// Sadly, we do this on the client because propagation of requested augs
// takes so long.  
// ----------------------------------------------------------------------
function GrantAugs(int NumAugs)
{
   local Augmentation CurrentAug;
   local int PriorityIndex;
   local int AugsLeft;
	
   if (Role < ROLE_Authority)
      return;
   AugsLeft = NumAugs;

   for (PriorityIndex = 0; PriorityIndex < ArrayCount(AugPrefs); PriorityIndex++)
   {
      if (AugsLeft <= 0)
      {
         return;
      }
      if (AugPrefs[PriorityIndex] == '')
      {
         return;
      }
      for (CurrentAug = AugmentationSystem.FirstAug; CurrentAug != None; CurrentAug = CurrentAug.next)
      {
         if ((CurrentAug.Class.Name == AugPrefs[PriorityIndex]) && (CurrentAug.bHasIt == False))
         {
	         AugmentationSystem.GivePlayerAugmentation(CurrentAug.Class);
				// Max out aug
				if (CurrentAug.bHasIt)
					CurrentAug.CurrentLevel = CurrentAug.MaxLevel;
            AugsLeft = AugsLeft - 1;
         }
      }
   }
}

// ------------------------------------------------------------------------
// GiveInitialInventory()
// ------------------------------------------------------------------------

function GiveInitialInventory()
{
   local Inventory anItem;

   // Give the player a pistol.

   // spawn it.
   if ((!Level.Game.IsA('DeusExMPGame')) || (DeusExMPGame(Level.Game).bStartWithPistol))
   {
      anItem = Spawn(class'WeaponPistol');
      // "frob" it for pickup.  This will spawn a copy and give copy to player.
      anItem.Frob(Self,None);
      // Set it to be in belt (it will be the first inventory item)
      inventory.bInObjectBelt = True;
      // destroy original.
      anItem.Destroy();
      
      // Give some starting ammo.
      anItem = Spawn(class'Ammo10mm');
      DeusExAmmo(anItem).AmmoAmount=50;
      anItem.Frob(Self,None);
      anItem.Destroy();
   }

   // Give the player a medkit.
   anItem = Spawn(class'MedKit');
   anItem.Frob(Self,None);
   inventory.bInObjectBelt = True;
   anItem.Destroy();

	// Give them a lockpick and a multitool so they can make choices with skills
	// when they come across electronics and locks
	anItem = Spawn(class'Lockpick');
	anItem.Frob(Self,None);
	inventory.bInObjectBelt = True;
	anItem.Destroy();

   anItem = Spawn(class'Multitool');
	anItem.Frob(Self,None);
	inventory.bInObjectBelt = True;
	anItem.Destroy();
}

// ----------------------------------------------------------------------
// MultiplayerTick()
// Not the greatest name, handles single player ticks as well.  Basically
// anything tick style stuff that should be propagated to the server gets
// propagated as this one function call.
// ----------------------------------------------------------------------
function MultiplayerTick(float DeltaTime)
{
	local int burnTime;
	local float augLevel;

   Super.MultiplayerTick(DeltaTime);

   //If we've just put away items, reset this.
   if ((LastInHand != InHand) && (Level.Netmode == NM_Client) && (inHand == None))
   {
	   ClientInHandPending = None;
   }

   LastInHand = InHand;
   
   if ((PlayerIsClient()) || (Level.NetMode == NM_ListenServer))
   {
      if ((ShieldStatus != SS_Off) && (DamageShield == None))
         DrawShield();
		if ( (NintendoImmunityTimeLeft > 0.0) && ( InvulnSph == None ))
			DrawInvulnShield();
      if (Style != STY_Translucent)
         CreateShadow();
      else
         KillShadow();
   }

   if (Role < ROLE_Authority)
      return;

   UpdateInHand();

   UpdatePoison(DeltaTime);
   
   if (lastRefreshTime < 0)
      lastRefreshTime = 0;

   lastRefreshTime = lastRefreshTime + DeltaTime;

	if (bOnFire)
	{
		if ( Level.NetMode != NM_Standalone )
			burnTime = Class'WeaponFlamethrower'.Default.mpBurnTime;
		else
			burnTime = Class'WeaponFlamethrower'.Default.BurnTime;
		burnTimer += deltaTime;
		if (burnTimer >= burnTime)
			ExtinguishFire();
	}
  
   if (lastRefreshTime < 0.25)
      return;

   if (ShieldTimer > 0)
      ShieldTimer = ShieldTimer - lastRefreshTime;

   if (ShieldStatus == SS_Fade)
      ShieldStatus = SS_Off;

   if (ShieldTimer <= 0)
   {
      if (ShieldStatus == SS_Strong)
         ShieldStatus = SS_Fade;
   }

	// If we have a drone active (post-death etc) and we're not using the aug, kill it off
	augLevel = AugmentationSystem.GetAugLevelValue(class'AugDrone');
	if (( aDrone != None ) && (augLevel == -1.0))
		aDrone.TakeDamage(100, None, aDrone.Location, vect(0,0,0), 'EMP');

	if ( Level.Timeseconds > ServerTimeLastRefresh )
	{
		SetServerTimeDiff( Level.Timeseconds );
		ServerTimeLastRefresh = Level.Timeseconds + 10.0;
	}
	
   MaintainEnergy(lastRefreshTime);
   UpdateTranslucency(lastRefreshTime);
	if ( bNintendoImmunity )
	{
		NintendoImmunityTimeLeft = NintendoImmunityTime - Level.Timeseconds;
		if ( Level.Timeseconds > NintendoImmunityTime )
			NintendoImmunityEffect( False );
	}
   RepairInventory();
   lastRefreshTime = 0;
}

// ----------------------------------------------------------------------

function ForceDroneOff()
{
	local AugDrone anAug;

   anAug = AugDrone(AugmentationSystem.FindAugmentation(class'AugDrone'));
	//foreach AllActors(class'AugDrone', anAug)			
   if (anAug != None)      
      anAug.Deactivate();
}

// ----------------------------------------------------------------------
// PlayerIsListenClient()
// Returns True if the current player is the "client" playing ON the
// listen server.
// ----------------------------------------------------------------------
function bool PlayerIsListenClient()
{
   return ((GetPlayerPawn() == Self) && (Level.NetMode == NM_ListenServer)); 
}

// ----------------------------------------------------------------------
// PlayerIsRemoteClient()
// Returns true if this player is the main player of this remote client
// -----------------------------------------------------------------------
function bool PlayerIsRemoteClient()
{
   return ((Level.NetMode == NM_Client) && (Role == ROLE_AutonomousProxy));
}

// ----------------------------------------------------------------------
// PlayerIsClient()
// Returns true if the current player is the "client" playing ON the
// listen server OR a remote client
// ----------------------------------------------------------------------
function bool PlayerIsClient()
{
   return (PlayerIsListenClient() || PlayerIsRemoteClient());
}

// ----------------------------------------------------------------------
// DrawShield()
// ----------------------------------------------------------------------
simulated function DrawShield()
{
	local ShieldEffect shield;

   if (DamageShield != None)
   {
      return;
   }

	shield = Spawn(class'ShieldEffect', Self,, Location, Rotation);
	if (shield != None)
   {
		shield.SetBase(Self);
      shield.RemoteRole = ROLE_None;
      shield.AttachedPlayer = Self;
   }

   DamageShield = shield;
}

// ----------------------------------------------------------------------
// DrawInvulnShield()
// ----------------------------------------------------------------------
simulated function DrawInvulnShield()
{
	if (( InvulnSph != None ) || (Level.NetMode == NM_Standalone))
		return;

	InvulnSph = Spawn(class'InvulnSphere', Self, , Location, Rotation );
	if ( InvulnSph != None )
	{
		InvulnSph.SetBase( Self );
		InvulnSph.RemoteRole = ROLE_None;
		InvulnSph.AttachedPlayer = Self;
		InvulnSph.LifeSpan = NintendoImmunityTimeLeft;
	}
}

// ----------------------------------------------------------------------
// CreatePlayerTracker()
// ----------------------------------------------------------------------
simulated function CreatePlayerTracker()
{
   local MPPlayerTrack PlayerTracker;

   PlayerTracker = Spawn(class'MPPlayerTrack');  
   PlayerTracker.AttachedPlayer = Self;
}

// ----------------------------------------------------------------------
// DisconnectPlayer()
// ----------------------------------------------------------------------
exec function DisconnectPlayer()
{
   if (DeusExRootWindow(rootWindow) != None)
		DeusExRootWindow(rootWindow).ClearWindowStack();
   
   if (PlayerIsRemoteClient())
      ConsoleCommand("disconnect");
   
   if (PlayerIsListenClient())
      ConsoleCommand("start dx.dx");
}

exec function ShowPlayerPawnList()
{
   local pawn curpawn;

   for (curpawn = level.pawnlist; curpawn != none; curpawn = curpawn.nextpawn)
      log("======>Pawn is "$curpawn);
}

// ----------------------------------------------------------------------
// KillShadow
// ----------------------------------------------------------------------
simulated function KillShadow()
{
   if (Shadow != None)
      Shadow.Destroy();
   Shadow = None;
}

// ----------------------------------------------------------------------
// CreateShadow
// ----------------------------------------------------------------------
simulated function CreateShadow()
{
   if (Shadow == None)
   {
      Shadow = Spawn(class'Shadow', Self,, Location-vect(0,0,1)*CollisionHeight, rot(16384,0,0));
      if (Shadow != None)
      {
         Shadow.RemoteRole = ROLE_None;
      }
   }
}

// ----------------------------------------------------------------------
// LocalLog
// ----------------------------------------------------------------------
function LocalLog(String S)
{
	if (( Player != None ) && ( Player.Console != None ))
		Player.Console.AddString(S);
}

// ----------------------------------------------------------------------
// ShowDemoSplash()
// ----------------------------------------------------------------------
function ShowDemoSplash()
{
	local DeusExRootWindow root;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.PushWindow(Class'DemoSplashWindow');
}

// ----------------------------------------------------------------------
// VerifyConsole()
// Verifies that console is Engine.Console.  If you want something different,
// override this in a subclassed player class.
// ----------------------------------------------------------------------

function VerifyConsole(Class<Console> ConsoleClass)
{
	local bool bCheckPassed;
	
	bCheckPassed = True;

	if (Player.Console == None)
		bCheckPassed = False;
	else if (Player.Console.Class != ConsoleClass)
		bCheckPassed = False;

	if (bCheckPassed == False)
		FailConsoleCheck();
}

// ----------------------------------------------------------------------
// VerifyRootWindow()
// Verifies that the root window is the right kind of root window, since
// it can be changed in the ini
// ----------------------------------------------------------------------
function VerifyRootWindow(Class<DeusExRootWindow> WindowClass)
{
	local bool bCheckPassed;
	
	bCheckPassed = True;

	if (RootWindow == None)
		bCheckPassed = False;
	else if (RootWindow.Class != WindowClass)
		bCheckPassed = False;

	if (bCheckPassed == False)
		FailRootWindowCheck();
}

// ----------------------------------------------------------------------
// FailRootWindowCheck()
// ----------------------------------------------------------------------
function FailRootWindowCheck()
{
	if (Level.Game.IsA('DeusExGameInfo'))
		DeusExGameInfo(Level.Game).FailRootWindowCheck(Self);
}

// ----------------------------------------------------------------------
// FailConsoleCheck()
// ----------------------------------------------------------------------
function FailConsoleCheck()
{
	if (Level.Game.IsA('DeusExGameInfo'))
		DeusExGameInfo(Level.Game).FailConsoleCheck(Self);
}

// ----------------------------------------------------------------------
// Possess()
// ----------------------------------------------------------------------
event Possess()
{
	Super.Possess();

	if (Level.Netmode == NM_Client)
	{
		ClientPossessed();
	}
}

// ----------------------------------------------------------------------
// ClientPossessed()
// ----------------------------------------------------------------------
function ClientPossessed()
{
	if (Level.Game.IsA('DeusExGameInfo'))
		DeusExGameInfo(Level.Game).ClientPlayerPossessed(Self);
}

// ----------------------------------------------------------------------
// ForceDisconnect
// ----------------------------------------------------------------------
function ForceDisconnect(string Message)
{
	player.Console.AddString(Message);
	DisconnectPlayer();
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     TruePlayerName="JC Denton"
     CombatDifficulty=1.000000
     SkillPointsTotal=5000
     SkillPointsAvail=5000
     Credits=500
     Energy=100.000000
     EnergyMax=100.000000
     MaxRegenPoint=25.000000
     RegenRate=1.500000
     MaxFrobDistance=112.000000
     maxInvRows=6
     maxInvCols=5
     bBeltIsMPInventory=True
     RunSilentValue=1.000000
     ClotPeriod=30.000000
     strStartMap="01_NYC_UNATCOIsland"
     bObjectNames=True
     bNPCHighlighting=True
     bSubtitles=True
     bAlwaysRun=True
     logTimeout=3.000000
     maxLogLines=4
     bHelpMessages=True
     bObjectBeltVisible=True
     bHitDisplayVisible=True
     bAmmoDisplayVisible=True
     bAugDisplayVisible=True
     bDisplayAmmoByClip=True
     bCompassVisible=True
     bCrosshairVisible=True
     bAutoReload=True
     bDisplayAllGoals=True
     bHUDShowAllAugs=True
     bShowAmmoDescriptions=True
     bConfirmSaveDeletes=True
     bConfirmNoteDeletes=True
     AugPrefs(0)=AugVision
     AugPrefs(1)=AugHealing
     AugPrefs(2)=AugSpeed
     AugPrefs(3)=AugDefense
     AugPrefs(4)=AugBallistic
     AugPrefs(5)=AugShield
     AugPrefs(6)=AugEMP
     AugPrefs(7)=AugStealth
     AugPrefs(8)=AugAqualung
     MenuThemeName="Default"
     HUDThemeName="Default"
     bHUDBordersVisible=True
     bHUDBordersTranslucent=True
     bHUDBackgroundTranslucent=True
     bMenusTranslucent=True
     InventoryFull="You don't have enough room in your inventory to pick up the %s"
     TooMuchAmmo="You already have enough of that type of ammo"
     TooHeavyToLift="It's too heavy to lift"
     CannotLift="You can't lift that"
     NoRoomToLift="There's no room to lift that"
     CanCarryOnlyOne="You can only carry one %s"
     CannotDropHere="Can't drop that here"
     HandsFull="Your hands are full"
     NoteAdded="Note Received - Check DataVault For Details"
     GoalAdded="Goal Received - Check DataVault For Details"
     PrimaryGoalCompleted="Primary Goal Completed"
     SecondaryGoalCompleted="Secondary Goal Completed"
     EnergyDepleted="Bio-electric energy reserves depleted"
     AddedNanoKey="%s added to Nano Key Ring"
     HealedPointsLabel="Healed %d points"
     HealedPointLabel="Healed %d point"
     SkillPointsAward="%d skill points awarded"
     QuickSaveGameTitle="Quick Save"
     WeaponUnCloak="Weapon drawn... Uncloaking"
     TakenOverString="I've taken over the "
     HeadString="Head"
     TorsoString="Torso"
     LegsString="Legs"
     WithTheString=" with the "
     WithString=" with "
     PoisonString=" with deadly poison"
     BurnString=" with excessive burning"
     NoneString="None"
     MPDamageMult=1.000000
     bCanStrafe=True
     MeleeRange=50.000000
     AccelRate=2048.000000
     FovAngle=75.000000
     Intelligence=BRAINS_HUMAN
     AngularResolution=0.500000
     Alliance=Player
     DrawType=DT_Mesh
     SoundVolume=64
     RotationRate=(Pitch=3072,Yaw=65000,Roll=2048)
     BindName="JCDenton"
     FamiliarName="JC Denton"
     UnfamiliarName="JC Denton"
}
