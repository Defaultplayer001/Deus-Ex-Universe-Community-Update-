//=============================================================================
// ScriptedPawn.
//=============================================================================
class ScriptedPawn expands Pawn
	abstract
	native;

// ----------------------------------------------------------------------
// Enumerations

enum EDestinationType  {
	DEST_Failure,
	DEST_NewLocation,
	DEST_SameLocation
};


enum EAllianceType  {
	ALLIANCE_Friendly,
	ALLIANCE_Neutral,
	ALLIANCE_Hostile
};


enum ERaiseAlarmType  {
	RAISEALARM_BeforeAttacking,
	RAISEALARM_BeforeFleeing,
	RAISEALARM_Never
};


enum ESeekType  {
	SEEKTYPE_None,
	SEEKTYPE_Sound,
	SEEKTYPE_Sight,
	SEEKTYPE_Guess,
	SEEKTYPE_Carcass
};


enum EHitLocation  {
	HITLOC_None,
	HITLOC_HeadFront,
	HITLOC_HeadBack,
	HITLOC_TorsoFront,
	HITLOC_TorsoBack,
	HITLOC_LeftLegFront,
	HITLOC_LeftLegBack,
	HITLOC_RightLegFront,
	HITLOC_RightLegBack,
	HITLOC_LeftArmFront,
	HITLOC_LeftArmBack,
	HITLOC_RightArmFront,
	HITLOC_RightArmBack
};


enum ETurning  {
	TURNING_None,
	TURNING_Left,
	TURNING_Right
};


// ----------------------------------------------------------------------
// Structures

struct WanderCandidates  {
	var WanderPoint point;
	var Actor       waypoint;
	var float       dist;
};

struct FleeCandidates  {
	var HidePoint point;
	var Actor     waypoint;
	var Vector    location;
	var float     score;
	var float     dist;
};

struct NearbyProjectile  {
	var DeusExProjectile projectile;
	var vector           location;
	var float            dist;
	var float            range;
};

struct NearbyProjectileList  {
	var NearbyProjectile list[8];
	var vector           center;
};


struct InitialAllianceInfo  {
	var() Name  AllianceName;
	var() float AllianceLevel;
	var() bool  bPermanent;
};

struct AllianceInfoEx  {
	var Name  AllianceName;
	var float AllianceLevel;
	var float AgitationLevel;
	var bool  bPermanent;
};

struct InventoryItem  {
	var() class<Inventory> Inventory;
	var() int              Count;
};


// ----------------------------------------------------------------------
// Variables

var WanderPoint      lastPoints[2];
var float            Restlessness;  // 0-1
var float            Wanderlust;    // 0-1
var float            Cowardice;     // 0-1

var(Combat) float    BaseAccuracy;  // 0-1 or thereabouts
var(Combat) float    MaxRange;
var(Combat) float    MinRange;
var(Combat) float    MinHealth;

var(AI) float    RandomWandering;  // 0-1

var float       sleepTime;
var Actor       destPoint;
var Vector      destLoc;
var Vector      useLoc;
var Rotator     useRot;
var float       seekDistance;  // OBSOLETE
var int         SeekLevel;
var ESeekType   SeekType;
var Pawn        SeekPawn;
var float       CarcassTimer;
var float       CarcassHateTimer;  // OBSOLETE
var float       CarcassCheckTimer;
var name        PotentialEnemyAlliance;
var float       PotentialEnemyTimer;
var float       BeamCheckTimer;
var bool        bSeekPostCombat;
var bool        bSeekLocation;
var bool        bInterruptSeek;
var bool        bAlliancesChanged;         // set to True whenever someone changes AlliancesEx[i].AllianceLevel to indicate we must do alliance updating
var bool        bNoNegativeAlliances;      // True means we know all alliances are currently +, allows us to skip CheckEnemyPresence's slow part

var bool        bSitAnywhere;

var bool        bSitInterpolation;
var bool        bStandInterpolation;
var float       remainingSitTime;
var float       remainingStandTime;
var vector      StandRate;
var float       ReloadTimer;
var bool        bReadyToReload;

var(Pawn) class<carcass> CarcassType;		// mesh to use when killed from the front

// Advanced AI attributes.
var(Orders) name	Orders;         // orders a creature is carrying out 
                                  // will be initial state, plus creature will attempt
                                  // to return to this state
var(Orders) name  OrderTag;       // tag of object referred to by orders
var(Orders) name  HomeTag;        // tag of object to use as home base
var(Orders) float HomeExtent;     // extent of home base
var         actor OrderActor;     // object referred to by orders (if applicable)
var         name  NextAnim;       // used in states with multiple, sequenced animations	
var         float WalkingSpeed;   // 0-1

var(Combat)	float ProjectileSpeed;
var         name  LastPainAnim;
var         float LastPainTime;

var         vector DesiredPrePivot;
var         float  PrePivotTime;
var         vector PrePivotOffset;

var     bool        bCanBleed;      // true if an NPC can bleed
var     float       BleedRate;      // how profusely the NPC is bleeding; 0-1
var     float       DropCounter;    // internal; used in tick()
var()   float       ClotPeriod;     // seconds it takes bleedRate to go from 1 to 0

var     bool        bAcceptBump;    // ugly hack
var     bool        bCanFire;       // true if pawn is capable of shooting asynchronously
var(AI) bool        bKeepWeaponDrawn;  // true if pawn should always keep weapon drawn
var(AI) bool        bShowPain;      // true if pawn should play pain animations
var(AI) bool        bCanSit;        // true if pawn can sit
var(AI) bool        bAlwaysPatrol;  // true if stasis should be disabled during patrols
var(AI) bool        bPlayIdle;      // true if pawn should fidget while he's standing
var(AI) bool        bLeaveAfterFleeing;  // true if pawn should disappear after fleeing
var(AI) bool        bLikesNeutral;  // true if pawn should treat neutrals as friendlies
var(AI) bool        bUseFirstSeatOnly;   // true if only the nearest chair should be used for 
var(AI) bool        bCower;         // true if fearful pawns should cower instead of fleeing

var     HomeBase    HomeActor;      // home base
var     Vector      HomeLoc;        // location of home base
var     Vector      HomeRot;        // rotation of home base
var     bool        bUseHome;       // true if home base should be used

var     bool        bInterruptState; // true if the state can be interrupted
var     bool        bCanConverse;    // true if the pawn can converse

var()   bool        bImportant;      // true if this pawn is game-critical
var()   bool        bInvincible;     // true if this pawn cannot be killed

var     bool        bInitialized;    // true if this pawn has been initialized

var(Combat) bool    bAvoidAim;      // avoid enemy's line of fire
var(Combat) bool    bAimForHead;    // aim for the enemy's head
var(Combat) bool    bDefendHome;    // defend the home base
var         bool    bCanCrouch;     // whether we should crouch when firing
var         bool    bSeekCover;     // seek cover
var         bool    bSprint;        // sprint in random directions
var(Combat) bool    bUseFallbackWeapons;  // use fallback weapons even when others are available
var         float   AvoidAccuracy;  // how well we avoid enemy's line of fire; 0-1
var         bool    bAvoidHarm;     // avoid painful projectiles, gas clouds, etc.
var         float   HarmAccuracy;   // how well we avoid harm; 0-1
var         float   CrouchRate;     // how often the NPC crouches, if bCrouch enabled; 0-1
var         float   SprintRate;     // how often the NPC randomly sprints if bSprint enabled; 0-1
var         float   CloseCombatMult;  // multiplier for how often the NPC sprints in close combat; 0-1

// If a stimulation is enabled, it causes an NPC to hate the stimulator
//var(Stimuli) bool   bHateFutz;
var(Stimuli) bool   bHateHacking;  // new
var(Stimuli) bool   bHateWeapon;
var(Stimuli) bool   bHateShot;
var(Stimuli) bool   bHateInjury;
var(Stimuli) bool   bHateIndirectInjury;  // new
//var(Stimuli) bool   bHateGore;
var(Stimuli) bool   bHateCarcass;  // new
var(Stimuli) bool   bHateDistress;
//var(Stimuli) bool   bHateProjectiles;

// If a reaction is enabled, the NPC will react appropriately to a stimulation
var(Reactions) bool bReactFutz;  // new
var(Reactions) bool bReactPresence;         // React to the presence of an enemy (attacking)
var(Reactions) bool bReactLoudNoise;        // Seek the source of a loud noise (seeking)
var(Reactions) bool bReactAlarm;            // Seek the source of an alarm (seeking)
var(Reactions) bool bReactShot;             // React to a gunshot fired by an enemy (attacking)
//var(Reactions) bool bReactGore;             // React to gore appropriately (seeking)
var(Reactions) bool bReactCarcass;          // React to gore appropriately (seeking)
var(Reactions) bool bReactDistress;         // React to distress appropriately (attacking)
var(Reactions) bool bReactProjectiles;      // React to harmful projectiles appropriately

// If a fear is enabled, the NPC will run away from the stimulator
var(Fears) bool     bFearHacking;           // Run away from a hacker
var(Fears) bool     bFearWeapon;            // Run away from a person holding a weapon
var(Fears) bool     bFearShot;              // Run away from a person who fires a shot
var(Fears) bool     bFearInjury;            // Run away from a person who causes injury
var(Fears) bool     bFearIndirectInjury;    // Run away from a person who causes indirect injury
var(Fears) bool     bFearCarcass;           // Run away from a carcass
var(Fears) bool     bFearDistress;          // Run away from a person causing distress
var(Fears) bool     bFearAlarm;             // Run away from the source of an alarm
var(Fears) bool     bFearProjectiles;       // Run away from a projectile

var(AI) bool        bEmitDistress;          // TRUE if NPC should emit distress

var(AI) ERaiseAlarmType RaiseAlarm;         // When to raise an alarm

var     bool        bLookingForEnemy;             // TRUE if we're actually looking for enemies
var     bool        bLookingForLoudNoise;         // TRUE if we're listening for loud noises
var     bool        bLookingForAlarm;             // TRUE if we're listening for alarms
var     bool        bLookingForDistress;          // TRUE if we're looking for signs of distress
var     bool        bLookingForProjectiles;       // TRUE if we're looking for projectiles that can harm us
var     bool        bLookingForFutz;              // TRUE if we're looking for people futzing with stuff
var     bool        bLookingForHacking;           // TRUE if we're looking for people hacking stuff
var     bool        bLookingForShot;              // TRUE if we're listening for gunshots
var     bool        bLookingForWeapon;            // TRUE if we're looking for drawn weapons
var     bool        bLookingForCarcass;           // TRUE if we're looking for carcass events
var     bool        bLookingForInjury;            // TRUE if we're looking for injury events
var     bool        bLookingForIndirectInjury;    // TRUE if we're looking for secondary injury events

var     bool        bFacingTarget;          // True if pawn is facing its target
var(Combat) bool    bMustFaceTarget;        // True if an NPC must face his target to fire
var(Combat) float   FireAngle;              // TOTAL angle (in degrees) in which a pawn may fire if bMustFaceTarget is false
var(Combat) float   FireElevation;          // Max elevation distance required to attack (0=elevation doesn't matter)

var(AI) int         MaxProvocations;
var     float       AgitationSustainTime;
var     float       AgitationDecayRate;
var     float       AgitationTimer;
var     float       AgitationCheckTimer;
var     float       PlayerAgitationTimer;  // hack

var     float       FearSustainTime;
var     float       FearDecayRate;
var     float       FearTimer;
var     float       FearLevel;

var     float       EnemyReadiness;
var     float       ReactionLevel;
var     float       SurprisePeriod;
var     float       SightPercentage;
var     float       CycleTimer;
var     float       CyclePeriod;
var     float       CycleCumulative;
var     Pawn        CycleCandidate;
var     float       CycleDistance;

var     AlarmUnit   AlarmActor;

var     float       AlarmTimer;
var     float       WeaponTimer;
var     float       FireTimer;
var     float       SpecialTimer;
var     float       CrouchTimer;
var     float       BackpedalTimer;

var     bool        bHasShadow;
var     float       ShadowScale;

var     bool        bDisappear;

var     bool        bInTransientState;  // true if the NPC is in a 3rd-tier (transient) state, like TakeHit

var(Alliances) InitialAllianceInfo InitialAlliances[8];
var            AllianceInfoEx      AlliancesEx[16];
var            bool                bReverseAlliances;

var(Pawn) float     BaseAssHeight;

var(AI)   float     EnemyTimeout;
var       float     CheckPeriod;
var       float     EnemyLastSeen;
var       int       SeatSlot;
var       Seat      SeatActor;
var       int       CycleIndex;
var       int       BodyIndex;
var       bool      bRunningStealthy;
var       bool      bPausing;
var       bool      bStaring;
var       bool      bAttacking;
var       bool      bDistressed;
var       bool      bStunned;
var       bool      bSitting;
var       bool      bDancing;
var       bool      bCrouching;

var       bool      bCanTurnHead;

var(AI)   bool      bTickVisibleOnly;   // Temporary?
var()     bool      bInWorld;
var       vector    WorldPosition;
var       bool      bWorldCollideActors;
var       bool      bWorldBlockActors;
var       bool      bWorldBlockPlayers;

var()     bool      bHighlight;         // should this object not highlight when focused?

var(AI)   bool      bHokeyPokey;

var       bool      bConvEndState;

var(Inventory) InventoryItem InitialInventory[8];  // Initial inventory items carried by the pawn

var Bool bConversationEndedNormally;
var Bool bInConversation;
var Actor ConversationActor;						// Actor currently speaking to or speaking to us

var() sound WalkSound;
var float swimBubbleTimer;
var bool  bSpawnBubbles;

var      bool     bUseSecondaryAttack;

var      bool     bWalkAround;
var      bool     bClearedObstacle;
var      bool     bEnableCheckDest;
var      ETurning TurnDirection;
var      ETurning NextDirection;
var      Actor    ActorAvoiding;
var      float    AvoidWallTimer;
var      float    AvoidBumpTimer;
var      float    ObstacleTimer;
var      vector   LastDestLoc;
var      vector   LastDestPoint;
var      int      DestAttempts;

var      float    DeathTimer;
var      float    EnemyTimer;
var      float    TakeHitTimer;

var      name     ConvOrders;
var      name     ConvOrderTag;

var      float    BurnPeriod;

var      float    FutzTimer;

var      float    DistressTimer;

var      vector   SeatLocation;
var      Seat     SeatHack;
var      bool     bSeatLocationValid;
var      bool     bSeatHackUsed;

var      bool     bBurnedToDeath;

var      bool     bHasCloak;
var      bool     bCloakOn;
var      int      CloakThreshold;
var      float    CloakEMPTimer;

var      float    poisonTimer;      // time remaining before next poison TakeDamage
var      int      poisonCounter;    // number of poison TakeDamages remaining
var      int      poisonDamage;     // damage taken from poison effect
var      Pawn     Poisoner;         // person who initiated PoisonEffect damage

var      Name     Carcasses[4];     // list of carcasses seen
var      int      NumCarcasses;     // number of carcasses seen

var      float    walkAnimMult;
var      float    runAnimMult;

native(2102) final function ConBindEvents();

native(2105) final function bool IsValidEnemy(Pawn TestEnemy, optional bool bCheckAlliance);
native(2106) final function EAllianceType GetAllianceType(Name AllianceName);
native(2107) final function EAllianceType GetPawnAllianceType(Pawn QueryPawn);

native(2108) final function bool HaveSeenCarcass(Name CarcassName);
native(2109) final function AddCarcass(Name CarcassName);

// ----------------------------------------------------------------------
// PreBeginPlay()
// ----------------------------------------------------------------------

function PreBeginPlay()
{
	local float saveBaseEyeHeight;

	// TODO:
	//
	// Okay, we need to save the base eye height right now becase it's
	// obliterated in Pawn.uc with the following:
	//
	//  EyeHeight = 0.8 * CollisionHeight; //FIXME - if all baseeyeheights set right, use them
	//  BaseEyeHeight = EyeHeight;
	//
	// This must be fixed after ECTS.

	saveBaseEyeHeight = BaseEyeHeight;

	Super.PreBeginPlay();

	BaseEyeHeight = saveBaseEyeHeight;

	// create our shadow
	CreateShadow();

	// Set our alliance
	SetAlliance(Alliance);

	// Set up callbacks
	UpdateReactionCallbacks();
}


// ----------------------------------------------------------------------
// PostBeginPlay()
// ----------------------------------------------------------------------

function PostBeginPlay()
{
	Super.PostBeginPlay();

	// Set up pain timer
	if (Region.Zone.bPainZone || HeadRegion.Zone.bPainZone ||
	    FootRegion.Zone.bPainZone)
		PainTime = 5.0;
	else if (HeadRegion.Zone.bWaterZone)
		PainTime = UnderWaterTime;

	// Handle holograms
	if ((Style != STY_Masked) && (Style != STY_Normal))
	{
		SetSkinStyle(Style, None);
		SetCollision(false, false, false);
		KillShadow();
		bHasShadow = False;
	}
}


// ----------------------------------------------------------------------
// PostPostBeginPlay()
// ----------------------------------------------------------------------

function PostPostBeginPlay()
{
	Super.PostPostBeginPlay();

	// Bind any conversation events to this ScriptedPawn
	ConBindEvents();
}


// ----------------------------------------------------------------------
// Destroyed()
// ----------------------------------------------------------------------

simulated function Destroyed()
{
	local DeusExPlayer player;

	// Pass a message to conPlay, if it exists in the player, that 
	// this pawn has been destroyed.  This is used to prevent 
	// bad things from happening in converseations.

	player = DeusExPlayer(GetPlayerPawn());

	if ((player != None) && (player.conPlay != None))
		player.conPlay.ActorDestroyed(Self);

	Super.Destroyed();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// GENERAL UTILITIES
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// InitializePawn()
// ----------------------------------------------------------------------

function InitializePawn()
{
	if (!bInitialized)
	{
		InitializeInventory();
		InitializeAlliances();
		InitializeHomeBase();

		BlockReactions();

		if (Alliance != '')
			ChangeAlly(Alliance, 1.0, true);

		if (!bInWorld)
		{
			// tricky
			bInWorld = true;
			LeaveWorld();
		}

		// hack!
		animTimer[1] = 20.0;
		PlayTurnHead(LOOK_Forward, 1.0, 0.0001);

		bInitialized = true;
	}
}


// ----------------------------------------------------------------------
// InitializeInventory()
// ----------------------------------------------------------------------

function InitializeInventory()
{
	local int       i, j;
	local Inventory inv;
	local Weapon    weapons[8];
	local int       weaponCount;
	local Weapon    firstWeapon;

	// Add initial inventory items
	weaponCount = 0;
	for (i=0; i<8; i++)
	{
		if ((InitialInventory[i].Inventory != None) && (InitialInventory[i].Count > 0))
		{
			firstWeapon = None;
			for (j=0; j<InitialInventory[i].Count; j++)
			{
				inv = None;
				if (Class<Ammo>(InitialInventory[i].Inventory) != None)
				{
					inv = FindInventoryType(InitialInventory[i].Inventory);
					if (inv != None)
						Ammo(inv).AmmoAmount += Class<Ammo>(InitialInventory[i].Inventory).default.AmmoAmount;
				}
				if (inv == None)
				{
					inv = spawn(InitialInventory[i].Inventory, self);
					if (inv != None)
					{
						inv.InitialState='Idle2';
						inv.GiveTo(Self);
						inv.SetBase(Self);
						if ((firstWeapon == None) && (Weapon(inv) != None))
							firstWeapon = Weapon(inv);
					}
				}
			}
			if (firstWeapon != None)
				weapons[WeaponCount++] = firstWeapon;
		}
	}
	for (i=0; i<weaponCount; i++)
	{
		if ((weapons[i].AmmoType == None) && (weapons[i].AmmoName != None) &&
			(weapons[i].AmmoName != Class'AmmoNone'))
		{
			weapons[i].AmmoType = Ammo(FindInventoryType(weapons[i].AmmoName));
			if (weapons[i].AmmoType == None)
			{
				weapons[i].AmmoType = spawn(weapons[i].AmmoName);
				weapons[i].AmmoType.InitialState='Idle2';
				weapons[i].AmmoType.GiveTo(Self);
				weapons[i].AmmoType.SetBase(Self);
			}
		}
	}

	SetupWeapon(false);

}


// ----------------------------------------------------------------------
// InitializeAlliances()
// ----------------------------------------------------------------------

function InitializeAlliances()
{
	local int i;

	for (i=0; i<8; i++)
		if (InitialAlliances[i].AllianceName != '')
			ChangeAlly(InitialAlliances[i].AllianceName,
			           InitialAlliances[i].AllianceLevel,
			           InitialAlliances[i].bPermanent);

}


// ----------------------------------------------------------------------
// InitializeHomeBase()
// ----------------------------------------------------------------------

function InitializeHomeBase()
{
	if (!bUseHome)
	{
		HomeActor = None;
		HomeLoc   = Location;
		HomeRot   = vector(Rotation);
		if (HomeTag == 'Start')
			bUseHome = true;
		else
		{
			HomeActor = HomeBase(FindTaggedActor(HomeTag, , Class'HomeBase'));
			if (HomeActor != None)
			{
				HomeLoc    = HomeActor.Location;
				HomeRot    = vector(HomeActor.Rotation);
				HomeExtent = HomeActor.Extent;
				bUseHome   = true;
			}
		}
		HomeRot *= 100;
	}
}


// ----------------------------------------------------------------------
// AddInitialInventory()
// ----------------------------------------------------------------------

function bool AddInitialInventory(class<Inventory> newInventory,
                                  optional int newCount)
{
	local int i;

	if (newCount == 0)
		newCount = 1;

	for (i=0; i<8; i++)
		if ((InitialInventory[i].Inventory == None) &&
		    (InitialInventory[i].Count <= 0))
			break;

	if (i < 8)
	{
		InitialInventory[i].Inventory = newInventory;
		InitialInventory[i].Count = newCount;
		return true;
	}
	else
		return false;
}


// ----------------------------------------------------------------------
// SetEnemy()
// ----------------------------------------------------------------------

function bool SetEnemy(Pawn newEnemy, optional float newSeenTime,
                       optional bool bForce)
{
	if (bForce || IsValidEnemy(newEnemy))
	{
		if (newEnemy != Enemy)
			EnemyTimer = 0;
		Enemy         = newEnemy;
		EnemyLastSeen = newSeenTime;

		return True;
	}
	else
		return False;
}


// ----------------------------------------------------------------------
// SetState()
// ----------------------------------------------------------------------

function SetState(Name stateName, optional Name labelName)
{
	if (bInterruptState)
		GotoState(stateName, labelName);
	else
		SetNextState(stateName, labelName);
}


// ----------------------------------------------------------------------
// SetNextState()
// ----------------------------------------------------------------------

function SetNextState(name newState, optional name newLabel)
{
	if (!bInTransientState || !HasNextState())
	{
		if ((newState != 'Conversation') && (newState != 'FirstPersonConversation'))
		{
			NextState = newState;
			NextLabel = newLabel;
		}
	}
}


// ----------------------------------------------------------------------
// ClearNextState()
// ----------------------------------------------------------------------

function ClearNextState()
{
	NextState = '';
	NextLabel = '';
}


// ----------------------------------------------------------------------
// HasNextState()
// ----------------------------------------------------------------------

function bool HasNextState()
{
	if ((NextState == '') || (NextState == GetStateName()))
		return false;
	else
		return true;
}


// ----------------------------------------------------------------------
// GotoNextState()
// ----------------------------------------------------------------------

function GotoNextState()
{
	local bool bSuccess;
	local name oldState, oldLabel;

	if (HasNextState())
	{
		oldState = NextState;
		oldLabel = NextLabel;
		if (oldLabel == '')
			oldLabel = 'Begin';

		ClearNextState();

		GotoState(oldState, oldLabel);
	}
	else
		ClearNextState();
}


// ----------------------------------------------------------------------
// SetOrders()
// ----------------------------------------------------------------------

function SetOrders(Name orderName, optional Name newOrderTag, optional bool bImmediate)
{
	local bool bHostile;
	local Pawn orderEnemy;

	switch (orderName)
	{
		case 'Attacking':
		case 'Fleeing':
		case 'Alerting':
		case 'Seeking':
			bHostile = true;
			break;
		default:
			bHostile = false;
			break;
	}

	if (!bHostile)
	{
		bSeatHackUsed = false;  // hack!
		Orders   = orderName;
		OrderTag = newOrderTag;

		if (bImmediate)
			FollowOrders(true);
	}
	else
	{
		ReactionLevel = 1.0;
		orderEnemy = Pawn(FindTaggedActor(newOrderTag, false, Class'Pawn'));
		if (orderEnemy != None)
		{
			ChangeAlly(orderEnemy.Alliance, -1, true);
			if (SetEnemy(orderEnemy))
				SetState(orderName);
		}
	}

}


// ----------------------------------------------------------------------
// SetHomeBase()
// ----------------------------------------------------------------------

function SetHomeBase(vector baseLocation, optional rotator baseRotator, optional float baseExtent)
{
	local vector vectRot;

	if (baseExtent == 0)
		baseExtent = 800;

	HomeTag    = '';
	HomeActor  = None;
	HomeLoc    = baseLocation;
	HomeRot    = vector(baseRotator)*100;
	HomeExtent = baseExtent;
	bUseHome   = true;
}


// ----------------------------------------------------------------------
// ClearHomeBase()
// ----------------------------------------------------------------------

function ClearHomeBase()
{
	HomeTag  = '';
	bUseHome = false;
}


// ----------------------------------------------------------------------
// IsSeatValid()
// ----------------------------------------------------------------------

function bool IsSeatValid(Actor checkActor)
{
	local PlayerPawn player;
	local Seat       checkSeat;

	checkSeat = Seat(checkActor);
	if (checkSeat == None)
		return false;
	else if (checkSeat.bDeleteMe)
		return false;
	else if (!bSitAnywhere && (VSize(checkSeat.Location-checkSeat.InitialPosition) > 70))
		return false;
	else
	{
		player = GetPlayerPawn();
		if (player != None)
		{
			if (player.CarriedDecoration == checkSeat)
				return false;
		}
		return true;
	}
}


// ----------------------------------------------------------------------
// SetDistress()
// ----------------------------------------------------------------------

function SetDistress(bool bDistress)
{
	bDistressed = bDistress;
	if (bDistress && bEmitDistress)
		AIStartEvent('Distress', EAITYPE_Visual);
	else
		AIEndEvent('Distress', EAITYPE_Visual);
}


// ----------------------------------------------------------------------
// SetDistressTimer()
// ----------------------------------------------------------------------

function SetDistressTimer()
{
	DistressTimer = 0;
}


// ----------------------------------------------------------------------
// SetSeekLocation()
// ----------------------------------------------------------------------

function SetSeekLocation(Pawn seekCandidate, vector newLocation, ESeekType newSeekType, optional bool bNewPostCombat)
{
	SetEnemy(None, 0, true);
	SeekPawn      = seekCandidate;
	LastSeenPos   = newLocation;
	bSeekLocation = True;
	SeekType      = newSeekType;
	if (newSeekType == SEEKTYPE_Carcass)
		CarcassTimer      = 120.0;
	if (newSeekType == SEEKTYPE_Sight)
		SeekLevel = Max(SeekLevel, 1);
	else
		SeekLevel = Max(SeekLevel, 3);
	if (bNewPostCombat)
		bSeekPostCombat = true;
}


// ----------------------------------------------------------------------
// GetCarcassData()
// ----------------------------------------------------------------------

function bool GetCarcassData(actor sender, out Name killer, out Name alliance,
                             out Name CarcassName, optional bool bCheckName)
{
	local DeusExPlayer  dxPlayer;
	local DeusExCarcass carcass;
	local POVCorpse     corpseItem;
	local bool          bCares;
	local bool          bValid;

	alliance = '';
	killer   = '';

	bValid   = false;
	dxPlayer = DeusExPlayer(sender);
	carcass  = DeusExCarcass(sender);
	if (dxPlayer != None)
	{
		corpseItem = POVCorpse(dxPlayer.inHand);
		if (corpseItem != None)
		{
			if (corpseItem.bEmitCarcass)
			{
				alliance    = corpseItem.Alliance;
				killer      = corpseItem.KillerAlliance;
				CarcassName = corpseItem.CarcassName;
				bValid      = true;
			}
		}
	}
	else if (carcass != None)
	{
		if (carcass.bEmitCarcass)
		{
			alliance    = carcass.Alliance;
			killer      = carcass.KillerAlliance;
			CarcassName = carcass.CarcassName;
			bValid      = true;
		}
	}

	bCares = false;
	if (bValid && (!bCheckName || !HaveSeenCarcass(CarcassName)))
	{
		if (bFearCarcass)
			bCares = true;
		else
		{
			if (GetAllianceType(alliance) == ALLIANCE_Friendly)
			{
				if (bHateCarcass)
					bCares = true;
				else if (bReactCarcass)
				{
					if (GetAllianceType(killer) == ALLIANCE_Hostile)
						bCares = true;
				}
			}
		}
	}

	return bCares;
}


// ----------------------------------------------------------------------
// ReactToFutz()
// ----------------------------------------------------------------------

function ReactToFutz()
{
	if (bLookingForFutz && bReactFutz && (FutzTimer <= 0) && !bDistressed)
	{
		FutzTimer = 2.0;
		PlayFutzSound();
	}
}


// ----------------------------------------------------------------------
// ReactToProjectiles()
// ----------------------------------------------------------------------

function ReactToProjectiles(Actor projectileActor)
{
	local DeusExProjectile dxProjectile;
	local Pawn             instigator;

	if ((bFearProjectiles || bReactProjectiles) && bLookingForProjectiles)
	{
		dxProjectile = DeusExProjectile(projectileActor);
		if ((dxProjectile == None) || IsProjectileDangerous(dxProjectile))
		{
			instigator = Pawn(projectileActor);
			if (instigator == None)
				instigator = projectileActor.Instigator;
			if (instigator != None)
			{
				if (bFearProjectiles)
					IncreaseFear(instigator, 2.0);
				if (SetEnemy(instigator))
				{
					SetDistressTimer();
					HandleEnemy();
				}
				else if (bFearProjectiles && IsFearful())
				{
					SetDistressTimer();
					SetEnemy(instigator, , true);
					GotoState('Fleeing');
				}
				else if (bAvoidHarm)
					SetState('AvoidingProjectiles');
			}
		}
	}
}


// ----------------------------------------------------------------------
// InstigatorToPawn()
// ----------------------------------------------------------------------

function Pawn InstigatorToPawn(Actor eventActor)
{
	local Pawn pawnActor;

	if (Inventory(eventActor) != None)
	{
		if (Inventory(eventActor).Owner != None)
			eventActor = Inventory(eventActor).Owner;
	}
	else if (DeusExDecoration(eventActor) != None)
		eventActor = GetPlayerPawn();
	else if (DeusExProjectile(eventActor) != None)
		eventActor = eventActor.Instigator;

	pawnActor = Pawn(eventActor);
	if (pawnActor == self)
		pawnActor = None;

	return pawnActor;

}


// ----------------------------------------------------------------------
// EnableShadow()
// ----------------------------------------------------------------------

function EnableShadow(bool bEnable)
{
	if (Shadow != None)
	{
		if (bEnable)
			Shadow.AttachDecal(32,vect(0.1,0.1,0));
		else
			Shadow.DetachDecal();
	}
}


// ----------------------------------------------------------------------
// CreateShadow()
// ----------------------------------------------------------------------

function CreateShadow()
{
	if (bHasShadow && bInWorld)
		if (Shadow == None)
			Shadow = Spawn(class'Shadow', Self,, Location-vect(0,0,1)*CollisionHeight, rot(16384,0,0));
}


// ----------------------------------------------------------------------
// KillShadow()
// ----------------------------------------------------------------------

function KillShadow()
{
	if (Shadow != None)
	{
		Shadow.Destroy();
		Shadow = None;
	}
}


// ----------------------------------------------------------------------
// EnterWorld()
// ----------------------------------------------------------------------

function EnterWorld()
{
	PutInWorld(true);
}


// ----------------------------------------------------------------------
// LeaveWorld()
// ----------------------------------------------------------------------

function LeaveWorld()
{
	PutInWorld(false);
}


// ----------------------------------------------------------------------
// PutInWorld()
// ----------------------------------------------------------------------

function PutInWorld(bool bEnter)
{
	if (bInWorld && !bEnter)
	{
		bInWorld            = false;
		GotoState('Idle');
		bHidden             = true;
		bDetectable         = false;
		WorldPosition       = Location;
		bWorldCollideActors = bCollideActors;
		bWorldBlockActors   = bBlockActors;
		bWorldBlockPlayers  = bBlockPlayers;
		SetCollision(false, false, false);
		bCollideWorld       = false;
		SetPhysics(PHYS_None);
		KillShadow();
		SetLocation(Location+vect(0,0,20000));  // move it out of the way
	}
	else if (!bInWorld && bEnter)
	{
		bInWorld    = true;
		bHidden     = Default.bHidden;
		bDetectable = Default.bDetectable;
		SetLocation(WorldPosition);
		SetCollision(bWorldCollideActors, bWorldBlockActors, bWorldBlockPlayers);
		bCollideWorld = Default.bCollideWorld;
		SetMovementPhysics();
		CreateShadow();
		FollowOrders();
	}
}


// ----------------------------------------------------------------------
// MakePawnIgnored()
// ----------------------------------------------------------------------

function MakePawnIgnored(bool bNewIgnore)
{
	if (bNewIgnore)
	{
		bIgnore = bNewIgnore;
		// to restore original behavior, uncomment the next line
		//bDetectable = !bNewIgnore;
	}
	else
	{
		bIgnore = Default.bIgnore;
		// to restore original behavior, uncomment the next line
		//bDetectable = Default.bDetectable;
	}

}


// ----------------------------------------------------------------------
// EnableCollision() [for sitting state]
// ----------------------------------------------------------------------

function EnableCollision(bool bSet)
{
	EnableShadow(bSet);

	if (bSet)
		SetCollision(Default.bCollideActors, Default.bBlockActors, Default.bBlockPlayers);
	else
		SetCollision(True, False, True);
}


// ----------------------------------------------------------------------
// SetBasedPawnSize()
// ----------------------------------------------------------------------

function bool SetBasedPawnSize(float newRadius, float newHeight)
{
	local float  oldRadius, oldHeight;
	local bool   bSuccess;
	local vector centerDelta;
	local float  deltaEyeHeight;

	if (newRadius < 0)
		newRadius = 0;
	if (newHeight < 0)
		newHeight = 0;

	oldRadius = CollisionRadius;
	oldHeight = CollisionHeight;

	if ((oldRadius == newRadius) && (oldHeight == newHeight))
		return true;

	centerDelta    = vect(0, 0, 1)*(newHeight-oldHeight);
	deltaEyeHeight = GetDefaultCollisionHeight() - Default.BaseEyeHeight;

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
		PrePivotOffset  = vect(0, 0, 1)*(GetDefaultCollisionHeight()-newHeight);
		PrePivot        -= centerDelta;
		DesiredPrePivot -= centerDelta;
		BaseEyeHeight   = newHeight - deltaEyeHeight;
	}

	return (bSuccess);
}


// ----------------------------------------------------------------------
// ResetBasedPawnSize()
// ----------------------------------------------------------------------

function ResetBasedPawnSize()
{
	SetBasedPawnSize(Default.CollisionRadius, GetDefaultCollisionHeight());
}


// ----------------------------------------------------------------------
// GetDefaultCollisionHeight()
// ----------------------------------------------------------------------

function float GetDefaultCollisionHeight()
{
	return (Default.CollisionHeight-4.5);
}


// ----------------------------------------------------------------------
// GetCrouchHeight()
// ----------------------------------------------------------------------

function float GetCrouchHeight()
{
	return (Default.CollisionHeight*0.65);
}


// ----------------------------------------------------------------------
// GetSitHeight()
// ----------------------------------------------------------------------

function float GetSitHeight()
{
	return (GetDefaultCollisionHeight()+(BaseAssHeight*0.5));
}


// ----------------------------------------------------------------------
// IsPointInCylinder()
// ----------------------------------------------------------------------

function bool IsPointInCylinder(Actor cylinder, Vector point,
                                optional float extraRadius, optional float extraHeight)
{
	local bool  bPointInCylinder;
	local float tempX, tempY, tempRad;

	tempX    = cylinder.Location.X - point.X;
	tempX   *= tempX;
	tempY    = cylinder.Location.Y - point.Y;
	tempY   *= tempY;
	tempRad  = cylinder.CollisionRadius + extraRadius;
	tempRad *= tempRad;

	bPointInCylinder = false;
	if (tempX+tempY < tempRad)
		if (Abs(cylinder.Location.Z - point.Z) < (cylinder.CollisionHeight+extraHeight))
			bPointInCylinder = true;

	return (bPointInCylinder);
}


// ----------------------------------------------------------------------
// StartFalling()
// ----------------------------------------------------------------------

function StartFalling(Name resumeState, optional Name resumeLabel)
{
	SetNextState(resumeState, resumeLabel);
	GotoState('FallingState'); 
}


// ----------------------------------------------------------------------
// GetNextWaypoint()
// ----------------------------------------------------------------------

function Actor GetNextWaypoint(Actor destination)
{
	local Actor moveTarget;

	if (destination == None)
		moveTarget = None;
	else if (ActorReachable(destination))
		moveTarget = destination;
	else
		moveTarget = FindPathToward(destination);

	return (moveTarget);
}


// ----------------------------------------------------------------------
// GetNextVector()
// ----------------------------------------------------------------------

function bool GetNextVector(Actor destination, out vector outVect)
{
	local bool    bValid;
	local rotator rot;
	local float   dist;
	local float   maxDist;

	bValid = true;
	if (destination != None)
	{
		maxDist = 64;
		rot     = Rotator(destination.Location - Location);
		dist    = VSize(destination.Location - Location);
		if (dist < maxDist)
			outVect = destination.Location;
		else if (!AIDirectionReachable(Location, rot.Yaw, rot.Pitch,
		                               0, maxDist, outVect))
			bValid = false;
	}
	else
		bValid = false;

	return (bValid);
}


// ----------------------------------------------------------------------
// FindOrderActor()
// ----------------------------------------------------------------------

function FindOrderActor()
{
	if (Orders == 'Attacking')
		OrderActor = FindTaggedActor(OrderTag, true, Class'Pawn');
	else
		OrderActor = FindTaggedActor(OrderTag);
}


// ----------------------------------------------------------------------
// FindTaggedActor()
// ----------------------------------------------------------------------

function Actor FindTaggedActor(Name actorTag, optional bool bRandom, optional Class<Actor> tagClass)
{
	local float dist;
	local float bestDist;
	local actor bestActor;
	local actor tempActor;

	bestActor = None;
	bestDist  = 1000000;

	if (tagClass == None)
		tagClass = Class'Actor';

	// if no tag, then assume the player is the target
	if (actorTag == '')
		bestActor = GetPlayerPawn();
	else
	{
		foreach AllActors(tagClass, tempActor, actorTag)
		{
			if (tempActor != self)
			{
				dist = VSize(tempActor.Location - Location);
				if (bRandom)
					dist *= FRand()*0.6+0.7;  // +/- 30%
				if ((bestActor == None) || (dist < bestDist))
				{
					bestActor = tempActor;
					bestDist  = dist;
				}
			}
		}
	}

	return bestActor;
}


// ----------------------------------------------------------------------
// HandleEnemy()
// ----------------------------------------------------------------------

function HandleEnemy()
{
	SetState('HandlingEnemy', 'Begin');
}


// ----------------------------------------------------------------------
// HandleSighting()
// ----------------------------------------------------------------------

function HandleSighting(Pawn pawnSighted)
{
	SetSeekLocation(pawnSighted, pawnSighted.Location, SEEKTYPE_Sight);
	GotoState('Seeking');
}


// ----------------------------------------------------------------------
// FollowOrders()
// ----------------------------------------------------------------------

function FollowOrders(optional bool bDefer)
{
	local bool bSetEnemy;
	local bool bUseOrderActor;

	if (Orders != '')
	{
		if ((Orders == 'Fleeing') || (Orders == 'Attacking'))
		{
			bSetEnemy      = true;
			bUseOrderActor = true;
		}
		else if ((Orders == 'WaitingFor') || (Orders == 'GoingTo') ||
		         (Orders == 'RunningTo') || (Orders == 'Following') ||
		         (Orders == 'Sitting') || (Orders == 'Shadowing') ||
		         (Orders == 'DebugFollowing') || (Orders == 'DebugPathfinding'))
		{
			bSetEnemy      = false;
			bUseOrderActor = true;
		}
		else
		{
			bSetEnemy      = false;
			bUseOrderActor = false;
		}
		if (bUseOrderActor)
		{
			FindOrderActor();
			if (bSetEnemy)
				SetEnemy(Pawn(OrderActor), 0, true);
		}
		if (bDefer)  // hack
			SetState(Orders);
		else
			GotoState(Orders);
	}
	else
	{
		if (bDefer)
			SetState('Wandering');
		else
			GotoState('Wandering');
	}
}


// ----------------------------------------------------------------------
// ResetConvOrders()
// ----------------------------------------------------------------------

function ResetConvOrders()
{
	ConvOrders   = '';
	ConvOrderTag = '';
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
	local float limbDamage, headDamage, torsoDamage;

	if (!bInvincible)
	{
		// Scoring works as follows:
		// Disabling the head (100 points damage) will kill you.
		// Disabling the torso (100 points damage) will kill you.
		// Disabling 2 1/2 limbs (250 points damage) will kill you.
		// Combinations can also do you in -- 50 points damage to the head
		// and 125 points damage to the limbs, for example.

		// Note that this formula can produce numbers less than zero, so we'll clamp our
		// health value...

		// Compute total limb damage
		limbDamage  = 0;
		if (Default.HealthLegLeft > 0)
			limbDamage += float(Default.HealthLegLeft-HealthLegLeft)/Default.HealthLegLeft;
		if (Default.HealthLegRight > 0)
			limbDamage += float(Default.HealthLegRight-HealthLegRight)/Default.HealthLegRight;
		if (Default.HealthArmLeft > 0)
			limbDamage += float(Default.HealthArmLeft-HealthArmLeft)/Default.HealthArmLeft;
		if (Default.HealthArmRight > 0)
			limbDamage += float(Default.HealthArmRight-HealthArmRight)/Default.HealthArmRight;
		limbDamage *= 0.4;  // 2 1/2 limbs disabled == death

		// Compute total head damage
		headDamage  = 0;
		if (Default.HealthHead > 0)
			headDamage  = float(Default.HealthHead-HealthHead)/Default.HealthHead;

		// Compute total torso damage
		torsoDamage = 0;
		if (Default.HealthTorso > 0)
			torsoDamage = float(Default.HealthTorso-HealthTorso)/Default.HealthTorso;

		// Compute total health, relative to original health level
		Health = FClamp(Default.Health - ((limbDamage+headDamage+torsoDamage)*Default.Health), 0.0, Default.Health);
	}
	else
	{
		// Pawn is invincible - reset health to defaults
		HealthHead     = Default.HealthHead;
		HealthTorso    = Default.HealthTorso;
		HealthArmLeft  = Default.HealthArmLeft;
		HealthArmRight = Default.HealthArmRight;
		HealthLegLeft  = Default.HealthLegLeft;
		HealthLegRight = Default.HealthLegRight;
		Health         = Default.Health;
	}
}


// ----------------------------------------------------------------------
// UpdatePoison()
// ----------------------------------------------------------------------

function UpdatePoison(float deltaTime)
{
	if ((Health <= 0) || bDeleteMe)  // no more pain -- you're already dead!
		return;

	if (poisonCounter > 0)
	{
		poisonTimer += deltaTime;
		if (poisonTimer >= 2.0)  // pain every two seconds
		{
			poisonTimer = 0;
			poisonCounter--;
			TakeDamage(poisonDamage, Poisoner, Location, vect(0,0,0), 'PoisonEffect');
		}
		if ((poisonCounter <= 0) || (Health <= 0) || bDeleteMe)
			StopPoison();
	}
}


// ----------------------------------------------------------------------
// StartPoison()
// ----------------------------------------------------------------------

function StartPoison(int Damage, Pawn newPoisoner)
{
	if ((Health <= 0) || bDeleteMe)  // no more pain -- you're already dead!
		return;

	poisonCounter = 8;    // take damage no more than eight times (over 16 seconds)
	poisonTimer   = 0;    // reset pain timer
	Poisoner      = newPoisoner;
	if (poisonDamage < Damage)  // set damage amount
		poisonDamage = Damage;
}


// ----------------------------------------------------------------------
// StopPoison()
// ----------------------------------------------------------------------

function StopPoison()
{
	poisonCounter = 0;
	poisonTimer   = 0;
	poisonDamage  = 0;
	Poisoner      = None;
}


// ----------------------------------------------------------------------
// HasEnemyTimedOut()
// ----------------------------------------------------------------------

function bool HasEnemyTimedOut()
{
	if (EnemyTimeout > 0)
	{
		if (EnemyLastSeen > EnemyTimeout)
			return true;
		else
			return false;
	}
	else
		return false;
}


// ----------------------------------------------------------------------
// UpdateActorVisibility()
// ----------------------------------------------------------------------

function UpdateActorVisibility(actor seeActor, float deltaSeconds,
                               float checkTime, bool bCheckDir)
{
	local bool bCanSee;

	CheckPeriod += deltaSeconds;
	if (CheckPeriod >= checkTime)
	{
		CheckPeriod = 0.0;
		if (seeActor != None)
			bCanSee = (AICanSee(seeActor, ComputeActorVisibility(seeActor), false, bCheckDir, true, true) > 0);
		else
			bCanSee = false;
		if (bCanSee)
			EnemyLastSeen = 0;
		else if (EnemyLastSeen <= 0)
			EnemyLastSeen = 0.01;
	}
	if (EnemyLastSeen > 0)
		EnemyLastSeen += deltaSeconds;
}


// ----------------------------------------------------------------------
// ComputeActorVisibility()
// ----------------------------------------------------------------------

function float ComputeActorVisibility(actor seeActor)
{
	local float visibility;

	if (seeActor.IsA('DeusExPlayer'))
		visibility = DeusExPlayer(seeActor).CalculatePlayerVisibility(self);
	else
		visibility = 1.0;

	return (visibility);
}


// ----------------------------------------------------------------------
// UpdateReactionLevel() [internal use only]
// ----------------------------------------------------------------------

function UpdateReactionLevel(bool bRise, float deltaSeconds)
{
	local float surpriseTime;

	// Handle surprise levels...
	if (bRise)
	{
		if (ReactionLevel < 1.0)
		{
			surpriseTime = SurprisePeriod;
			if (surpriseTime <= 0)
				surpriseTime = 0.00000001;
			ReactionLevel += deltaSeconds/surpriseTime;
			if (ReactionLevel > 1.0)
				ReactionLevel = 1.0;
		}
	}
	else
	{
		if (ReactionLevel > 0.0)
		{
			surpriseTime = 7.0;
			ReactionLevel -= deltaSeconds/surpriseTime;
			if (ReactionLevel <= 0.0)
				ReactionLevel = 0.0;
		}
	}
}


// ----------------------------------------------------------------------
// CheckCycle() [internal use only]
// ----------------------------------------------------------------------

function Pawn CheckCycle()
{
	local float attackPeriod;
	local float maxAttackPeriod;
	local float sustainPeriod;
	local float decayPeriod;
	local float minCutoff;
	local Pawn  cycleEnemy;

	attackPeriod    = 0.5;
	maxAttackPeriod = 4.5;
	sustainPeriod   = 3.0;
	decayPeriod     = 4.0;

	minCutoff = attackPeriod/maxAttackPeriod;

	cycleEnemy = None;

	if (CycleCumulative <= 0)  // no enemies seen during this cycle
	{
		CycleTimer -= CyclePeriod;
		if (CycleTimer <= 0)
		{
			CycleTimer = 0;
			EnemyReadiness -= CyclePeriod/decayPeriod;
			if (EnemyReadiness < 0)
				EnemyReadiness = 0;
		}
	}
	else  // I saw somebody!
	{
		CycleTimer = sustainPeriod;
		CycleCumulative *= 2;  // hack
		if (CycleCumulative < minCutoff)
			CycleCumulative = minCutoff;
		else if (CycleCumulative > 1.0)
			CycleCumulative = 1.0;
		EnemyReadiness += CycleCumulative*CyclePeriod/attackPeriod;
		if (EnemyReadiness >= 1.0)
		{
			EnemyReadiness = 1.0;
			if (IsValidEnemy(CycleCandidate))
				cycleEnemy = CycleCandidate;
		}
		else if (EnemyReadiness >= SightPercentage)
			if (IsValidEnemy(CycleCandidate))
				HandleSighting(CycleCandidate);
	}
	CycleCumulative = 0;
	CyclePeriod     = 0;
	CycleCandidate  = None;
	CycleDistance   = 0;

	return (cycleEnemy);

}


// ----------------------------------------------------------------------
// CheckEnemyPresence()
// ----------------------------------------------------------------------

function bool CheckEnemyPresence(float deltaSeconds,
                                 bool bCheckPlayer, bool bCheckOther)
{
	local int          i;
	local int          count;
	local int          checked;
	local Pawn         candidate;
	local float        candidateDist;
	local DeusExPlayer playerCandidate;
	local bool         bCanSee;
	local int          lastCycle;
	local float        visibility;
	local Pawn         cycleEnemy;
	local bool         bValid;
	local bool         bPlayer;
	local float        surpriseTime;
	local bool         bValidEnemy;
	local bool         bPotentialEnemy;
	local bool         bCheck;

	bValid  = false;
	bCanSee = false;
	if (bReactPresence && bLookingForEnemy && !bNoNegativeAlliances)
	{
		if (PotentialEnemyAlliance != '')
			bCheck = true;
		else
		{
			for (i=0; i<16; i++)
				if ((AlliancesEx[i].AllianceLevel < 0) || (AlliancesEx[i].AgitationLevel >= 1.0))
					break;
			if (i < 16)
				bCheck = true;
		}

		if (bCheck)
		{
			bValid       = true;
			CyclePeriod += deltaSeconds;
			count        = 0;
			checked      = 0;
			lastCycle    = CycleIndex;
			foreach CycleActors(Class'Pawn', candidate, CycleIndex)
			{
				bValidEnemy = IsValidEnemy(candidate);
				if (!bValidEnemy && (PotentialEnemyTimer > 0))
					if (PotentialEnemyAlliance == candidate.Alliance)
						bPotentialEnemy = true;
				if (bValidEnemy || bPotentialEnemy)
				{
					count++;
					bPlayer = candidate.IsA('PlayerPawn');
					if ((bPlayer && bCheckPlayer) || (!bPlayer && bCheckOther))
					{
						visibility = AICanSee(candidate, ComputeActorVisibility(candidate), true, true, true, true);
						if (visibility > 0)
						{
							if (bPotentialEnemy)  // We can see the potential enemy; ergo, we hate him
							{
								IncreaseAgitation(candidate, 1.0);
								PotentialEnemyAlliance = '';
								PotentialEnemyTimer    = 0;
								bValidEnemy = IsValidEnemy(candidate);
							}
							if (bValidEnemy)
							{
								visibility += VisibilityThreshold;
								candidateDist = VSize(Location-candidate.Location);
								if ((CycleCandidate == None) || (CycleDistance > candidateDist))
								{
									CycleCandidate = candidate;
									CycleDistance  = candidateDist;
								}
								if (!bPlayer)
									CycleCumulative += 100000;  // a bit of a hack...
								else
									CycleCumulative += visibility;
							}
						}
					}
					if (count >= 1)
						break;
				}
				checked++;
				if (checked > 20)  // hacky hardcoded number
					break;
			}
			if (lastCycle >= CycleIndex)  // have we cycled through all actors?
			{
				cycleEnemy = CheckCycle();
				if (cycleEnemy != None)
				{
					SetDistressTimer();
					SetEnemy(cycleEnemy, 0, true);
					bCanSee = true;
				}
			}
		}
		else
			bNoNegativeAlliances = True;
	}

	// Handle surprise levels...
	UpdateReactionLevel((EnemyReadiness>0)||(GetStateName()=='Seeking')||bDistressed, deltaSeconds);

	if (!bValid)
	{
		CycleCumulative = 0;
		CyclePeriod     = 0;
		CycleCandidate  = None;
		CycleDistance   = 0;
		CycleTimer      = 0;
	}

	return (bCanSee);

}


// ----------------------------------------------------------------------
// CheckBeamPresence
// ----------------------------------------------------------------------

function bool CheckBeamPresence(float deltaSeconds)
{
	local DeusExPlayer player;
	local Beam         beamActor;
	local bool         bReactToBeam;

	if (bReactPresence && bLookingForEnemy && (BeamCheckTimer <= 0) && (LastRendered() < 5.0))
	{
		BeamCheckTimer = 1.0;
		player = DeusExPlayer(GetPlayerPawn());
		if (player != None)
		{
			bReactToBeam = false;
			if (IsValidEnemy(player))
			{
				foreach RadiusActors(Class'Beam', beamActor, 1200)
				{
					if ((beamActor.Owner == player) && (beamActor.LightType != LT_None) && (beamActor.LightBrightness > 32))
					{
						if (VSize(beamActor.Location - Location) < (beamActor.LightRadius+1)*25)
							bReactToBeam = true;
						else
						{
							if (AICanSee(beamActor, , false, true, false, false) > 0)
							{
								if (FastTrace(beamActor.Location, Location+vect(0,0,1)*BaseEyeHeight))
									bReactToBeam = true;
							}
						}
					}
					if (bReactToBeam)
						break;
				}
			}
			if (bReactToBeam)
				HandleSighting(player);
		}
	}
}


// ----------------------------------------------------------------------
// CheckCarcassPresence()
// ----------------------------------------------------------------------

function bool CheckCarcassPresence(float deltaSeconds)
{
	local Actor         carcass;
	local Name          CarcassName;
	local int           lastCycle;
	local DeusExCarcass body;
	local DeusExPlayer  player;
	local float         visibility;
	local Name          KillerAlliance;
	local Name          killedAlliance;
	local Pawn          killer;
	local Pawn          bestKiller;
	local float         dist;
	local float         bestDist;
	local float         maxCarcassDist;
	local int           maxCarcassCount;

	if (bFearCarcass && !bHateCarcass && !bReactCarcass)  // Major hack!
		maxCarcassCount = 1;
	else
		maxCarcassCount = ArrayCount(Carcasses);

	//if ((bHateCarcass || bReactCarcass || bFearCarcass) && bLookingForCarcass && (CarcassTimer <= 0))
	if ((bHateCarcass || bReactCarcass || bFearCarcass) && (NumCarcasses < maxCarcassCount))
	{
		maxCarcassDist = 1200;
		if (CarcassCheckTimer <= 0)
		{
			CarcassCheckTimer = 0.1;
			carcass           = None;
			lastCycle         = BodyIndex;
			foreach CycleActors(Class'DeusExCarcass', body, BodyIndex)
			{
				if (body.Physics != PHYS_Falling)
				{
					if (VSize(body.Location-Location) < maxCarcassDist)
					{
						if (GetCarcassData(body, KillerAlliance, killedAlliance, CarcassName, true))
						{
							visibility = AICanSee(body, ComputeActorVisibility(body), true, true, true, true);
							if (visibility > 0)
								carcass = body;
							break;
						}
					}
				}
			}
			if (lastCycle >= BodyIndex)
			{
				if (carcass == None)
				{
					player = DeusExPlayer(GetPlayerPawn());
					if (player != None)
					{
						if (VSize(player.Location-Location) < maxCarcassDist)
						{
							if (GetCarcassData(player, KillerAlliance, killedAlliance, CarcassName, true))
							{
								visibility = AICanSee(player, ComputeActorVisibility(player), true, true, true, true);
								if (visibility > 0)
									carcass = player;
							}
						}
					}
				}
			}
			if (carcass != None)
			{
				CarcassTimer = 120;
				AddCarcass(CarcassName);
				if (bLookingForCarcass)
				{
					if (KillerAlliance == 'Player')
						killer = GetPlayerPawn();
					else
					{
						bestKiller = None;
						bestDist   = 0;
						foreach AllActors(Class'Pawn', killer)  // hack
						{
							if (killer.Alliance == KillerAlliance)
							{
								dist = VSize(killer.Location - Location);
								if ((bestKiller == None) || (bestDist > dist))
								{
									bestKiller = killer;
									bestDist   = dist;
								}
							}
						}
						killer = bestKiller;
					}
					if (bHateCarcass)
					{
						PotentialEnemyAlliance = KillerAlliance;
						PotentialEnemyTimer    = 15.0;
						bNoNegativeAlliances   = false;
					}
					if (bFearCarcass)
						IncreaseFear(killer, 2.0);

					if (bFearCarcass && IsFearful() && !IsValidEnemy(killer))
					{
						SetDistressTimer();
						SetEnemy(killer, , true);
						GotoState('Fleeing');
					}
					else
					{
						SetDistressTimer();
						SetSeekLocation(killer, carcass.Location, SEEKTYPE_Carcass);
						HandleEnemy();
					}
				}
			}
		}
	}

}


// ----------------------------------------------------------------------
// AddProjectileToList()
// ----------------------------------------------------------------------

function AddProjectileToList(out NearbyProjectileList projList,
                             DeusExProjectile proj, vector projPos,
                             float dist, float range)
{
	local int   count;
	local int   pos;
	local int   bestPos;
	local float worstDist;

	bestPos   = -1;
	worstDist = dist;
	pos       = 0;
	while (pos < ArrayCount(projList.list))
	{
		if (projList.list[pos].projectile == None)
		{
			bestPos = pos;
			break;  // short-circuit loop
		}
		else
		{
			if (worstDist < projList.list[pos].dist)
			{
				worstDist = projList.list[pos].dist;
				bestPos   = pos;
			}
		}

		pos++;
	}

	if (bestPos >= 0)
	{
		projList.list[bestPos].projectile = proj;
		projList.list[bestPos].location   = projPos;
		projList.list[bestPos].dist       = dist;
		projList.list[bestPos].range      = range;
	}

}


// ----------------------------------------------------------------------
// IsProjectileDangerous()
// ----------------------------------------------------------------------

function bool IsProjectileDangerous(DeusExProjectile projectile)
{
	local bool bEvil;

	if (projectile.IsA('Cloud'))
		bEvil = true;
	else if (projectile.IsA('ThrownProjectile'))
	{
		if (projectile.IsA('SpyBot'))
			bEvil = false;
		else if ((ThrownProjectile(projectile) != None) && (ThrownProjectile(projectile).bProximityTriggered))
			bEvil = false;
		else
			bEvil = true;
	}
	else
		bEvil = false;

	return (bEvil);

}


// ----------------------------------------------------------------------
// GetProjectileList()
// ----------------------------------------------------------------------

function int GetProjectileList(out NearbyProjectileList projList, vector Location)
{
	local float            dist;
	local int              count;
	local DeusExProjectile curProj;
	local ThrownProjectile throwProj;
	local Cloud            cloudProj;
	local vector           HitNormal, HitLocation;
	local vector           extent;
	local vector           traceEnd;
	local Actor            hitActor;
	local float            range;
	local vector           pos;
	local float            time;
	local float            maxTime;
	local float            elasticity;
	local int              i;
	local bool             bValid;

	for (i=0; i<ArrayCount(projList.list); i++)
		projList.list[i].projectile = None;
	projList.center = Location;

	maxTime = 2.0;
	foreach RadiusActors(Class'DeusExProjectile', curProj, 1000)
	{
		if (IsProjectileDangerous(curProj))
		{
			throwProj = ThrownProjectile(curProj);
			cloudProj = Cloud(curProj);
			extent   = vect(1,1,0)*curProj.CollisionRadius;
			extent.Z = curProj.CollisionHeight;

			range    = VSize(extent);
			if (curProj.bExplodes)
				if (range < curProj.blastRadius)
					range = curProj.blastRadius;
			if (cloudProj != None)
				if (range < cloudProj.cloudRadius)
					range = cloudProj.cloudRadius;
			range += CollisionRadius+60;

			if (throwProj != None)
				elasticity = throwProj.Elasticity;
			else
				elasticity = 0.2;

			bValid = true;
			if (throwProj != None)
				if (throwProj.bProximityTriggered)  // HACK!!!
					bValid = false;

			if (((curProj.Physics == PHYS_Falling) || (curProj.Physics == PHYS_Projectile) || (curProj.Physics == PHYS_None)) &&
			    bValid)
			{
				pos = curProj.Location;
				dist = VSize(Location - curProj.Location);
				AddProjectileToList(projList, curProj, pos, dist, range);
				if (curProj.Physics == PHYS_Projectile)
				{
					traceEnd = curProj.Location + curProj.Velocity*maxTime;
					hitActor = Trace(HitLocation, HitNormal, traceEnd, curProj.Location, true, extent);
					if (hitActor == None)
						pos = traceEnd;
					else
						pos = HitLocation;
					dist = VSize(Location - pos);
					AddProjectileToList(projList, curProj, pos, dist, range);
				}
				else if (curProj.Physics == PHYS_Falling)
				{
					time = ParabolicTrace(pos, curProj.Velocity, curProj.Location, true, extent, maxTime,
					                      elasticity, curProj.bBounce, 60);
					if (time > 0)
					{
						dist = VSize(Location - pos);
						AddProjectileToList(projList, curProj, pos, dist, range);
					}
				}
			}
		}
	}

	count = 0;
	for (i=0; i<ArrayCount(projList.list); i++)
		if (projList.list[i].projectile != None)
			count++;

	return (count);

}


// ----------------------------------------------------------------------
// IsLocationDangerous()
// ----------------------------------------------------------------------

function bool IsLocationDangerous(NearbyProjectileList projList,
                                  vector Location)
{
	local bool  bDanger;
	local int   i;
	local float dist;

	bDanger = false;
	for (i=0; i<ArrayCount(projList.list); i++)
	{
		if (projList.list[i].projectile == None)
			break;
		if (projList.center == Location)
			dist = projList.list[i].dist;
		else
			dist = VSize(projList.list[i].location - Location);
		if (dist < projList.list[i].range)
		{
			bDanger = true;
			break;
		}
	}

	return (bDanger);

}


// ----------------------------------------------------------------------
// ComputeAwayVector()
// ----------------------------------------------------------------------

function vector ComputeAwayVector(NearbyProjectileList projList)
{
	local vector          awayVect;
	local vector          tempVect;
	local rotator         tempRot;
	local int             i;
	local float           dist;
	local int             yaw;
	local int             absYaw;
	local int             bestYaw;
	local NavigationPoint navPoint;
	local NavigationPoint bestPoint;
	local float           segmentDist;

	segmentDist = GroundSpeed*0.5;

	awayVect = vect(0, 0, 0);
	for (i=0; i<ArrayCount(projList.list); i++)
	{
		if ((projList.list[i].projectile != None) &&
		    (projList.list[i].dist < projList.list[i].range))
		{
			tempVect = projList.list[i].location - projList.center;
			if (projList.list[i].dist > 0)
				tempVect /= projList.list[i].dist;
			else
				tempVect = VRand();
			awayVect -= tempVect;
		}
	}

	if (awayVect != vect(0, 0, 0))
	{
		awayVect += Normal(Velocity*vect(1,1,0))*0.9;  // bias to direction already running
		yaw = Rotator(awayVect).Yaw;
		bestPoint = None;
		foreach ReachablePathnodes(Class'NavigationPoint', navPoint, None, dist)
		{
			tempRot = Rotator(navPoint.Location - Location);
			absYaw = (tempRot.Yaw - Yaw) & 65535;
			if (absYaw > 32767)
				absYaw -= 65536;
			absYaw = Abs(absYaw);
			if ((bestPoint == None) || (bestYaw > absYaw))
			{
				bestPoint = navPoint;
				bestYaw = absYaw;
			}
		}
		if (bestPoint != None)
			awayVect = bestPoint.Location-Location;
		else
		{
			tempRot = Rotator(awayVect);
			tempRot.Pitch += Rand(7282)-3641;   // +/- 20 degrees
			tempRot.Yaw   += Rand(7282)-3641;   // +/- 20 degrees
			awayVect = Vector(tempRot)*segmentDist;
		}
	}
	else
		awayVect = VRand()*segmentDist;

	return (awayVect);

}


// ----------------------------------------------------------------------
// SetupWeapon()
// ----------------------------------------------------------------------

function SetupWeapon(bool bDrawWeapon, optional bool bForce)
{
	if (bKeepWeaponDrawn && !bForce)
		bDrawWeapon = true;

	if (ShouldDropWeapon())
		DropWeapon();
	else if (bDrawWeapon)
	{
//		if (Weapon == None)
		SwitchToBestWeapon();
	}
	else
		SetWeapon(None);
}


// ----------------------------------------------------------------------
// DropWeapon()
// ----------------------------------------------------------------------

function DropWeapon()
{
	local DeusExWeapon dxWeapon;
	local Weapon       oldWeapon;

	if (Weapon != None)
	{
		dxWeapon = DeusExWeapon(Weapon);
		if ((dxWeapon == None) || !dxWeapon.bNativeAttack)
		{
			oldWeapon = Weapon;
			SetWeapon(None);
			oldWeapon.DropFrom(Location);
		}
	}
}


// ----------------------------------------------------------------------
// SetWeapon()
// ----------------------------------------------------------------------

function SetWeapon(Weapon newWeapon)
{
	if (Weapon == newWeapon)
	{
		if (Weapon != None)
		{
			if (Weapon.IsInState('DownWeapon'))
				Weapon.BringUp();
			Weapon.SetDefaultDisplayProperties();
		}
		if (Inventory != None)
			Inventory.ChangedWeapon();
		PendingWeapon = None;
		return;
	}

	PlayWeaponSwitch(newWeapon);
	if (Weapon != None)
	{
		Weapon.SetDefaultDisplayProperties();
		Weapon.PutDown();
	}

	Weapon = newWeapon;
	if (Inventory != None)
		Inventory.ChangedWeapon();
	if (Weapon != None)
		Weapon.BringUp();

	PendingWeapon = None;
}


// ----------------------------------------------------------------------
// ReactToInjury()
// ----------------------------------------------------------------------

function ReactToInjury(Pawn instigatedBy, Name damageType, EHitLocation hitPos)
{
	local Name currentState;
	local bool bHateThisInjury;
	local bool bFearThisInjury;

	if ((health > 0) && (instigatedBy != None) && (bLookingForInjury || bLookingForIndirectInjury))
	{
		currentState = GetStateName();

		bHateThisInjury = ShouldReactToInjuryType(damageType, bHateInjury, bHateIndirectInjury);
		bFearThisInjury = ShouldReactToInjuryType(damageType, bFearInjury, bFearIndirectInjury);

		if (bHateThisInjury)
			IncreaseAgitation(instigatedBy);
		if (bFearThisInjury)
			IncreaseFear(instigatedBy, 2.0);

		if (SetEnemy(instigatedBy))
		{
			SetDistressTimer();
			SetNextState('HandlingEnemy');
		}
		else if (bFearThisInjury && IsFearful())
		{
			SetDistressTimer();
			SetEnemy(instigatedBy, , true);
			SetNextState('Fleeing');
		}
		else
		{
//			if (instigatedBy.bIsPlayer)
//				ReactToFutz();
			SetNextState(currentState);
		}
		GotoDisabledState(damageType, hitPos);
	}
}


// ----------------------------------------------------------------------
// TakeHit()
// ----------------------------------------------------------------------

function TakeHit(EHitLocation hitPos)
{
	if (hitPos != HITLOC_None)
	{
		PlayTakingHit(hitPos);
		GotoState('TakingHit');
	}
	else
		GotoNextState();
}


// ----------------------------------------------------------------------
// ComputeFallDirection()
// ----------------------------------------------------------------------

function ComputeFallDirection(float totalTime, int numFrames,
                              out vector moveDir, out float stopTime)
{
	// Determine direction, and how long to slide
	if (AnimSequence == 'DeathFront')
	{
		moveDir = Vector(DesiredRotation) * Default.CollisionRadius*0.75;
		if (numFrames > 5)
			stopTime = totalTime * ((numFrames-5)/float(numFrames));
		else
			stopTime = totalTime * 0.5;
	}
	else if (AnimSequence == 'DeathBack')
	{
		moveDir = -Vector(DesiredRotation) * Default.CollisionRadius*0.75;
		if (numFrames > 5)
			stopTime = totalTime * ((numFrames-5)/float(numFrames));
		else
			stopTime = totalTime * 0.9;
	}
}


// ----------------------------------------------------------------------
// WillTakeStompDamage()
// ----------------------------------------------------------------------

function bool WillTakeStompDamage(Actor stomper)
{
	return true;
}


// ----------------------------------------------------------------------
// DrawShield()
// ----------------------------------------------------------------------

function DrawShield()
{
	local EllipseEffect shield;

	shield = Spawn(class'EllipseEffect', Self,, Location, Rotation);
	if (shield != None)
		shield.SetBase(Self);
}


// ----------------------------------------------------------------------
// StandUp()
// ----------------------------------------------------------------------

function StandUp(optional bool bInstant)
{
	local vector placeToStand;

	if (bSitting)
	{
		bSitInterpolation = false;
		bSitting          = false;

		EnableCollision(true);
		SetBase(None);
		SetPhysics(PHYS_Falling);
		ResetBasedPawnSize();

		if (!bInstant && (SeatActor != None) && IsOverlapping(SeatActor))
		{
			bStandInterpolation = true;
			remainingStandTime  = 0.3;
			StandRate = (Vector(SeatActor.Rotation+Rot(0, -16384, 0))*CollisionRadius) /
			            remainingStandTime;
		}
		else
			StopStanding();
	}

	if (SeatActor != None)
	{
		if (SeatActor.sittingActor[seatSlot] == self)
			SeatActor.sittingActor[seatSlot] = None;
		SeatActor = None;
	}

	if (bDancing)
		bDancing = false;
}


// ----------------------------------------------------------------------
// StopStanding()
// ----------------------------------------------------------------------

function StopStanding()
{
	if (bStandInterpolation)
	{
		bStandInterpolation = false;
		remainingStandTime  = 0;
		if (Physics == PHYS_Flying)
			SetPhysics(PHYS_Falling);
	}

}


// ----------------------------------------------------------------------
// UpdateStanding()
// ----------------------------------------------------------------------

function UpdateStanding(float deltaSeconds)
{
	local float  delta;
	local vector newPos;

	if (bStandInterpolation)
	{
		if ((Physics == PHYS_Walking) && (Acceleration != vect(0,0,0)))  // the bastard's walking now
			StopStanding();
		else
		{
			if ((deltaSeconds < remainingStandTime) && (remainingStandTime > 0))
			{
				delta = deltaSeconds;
				remainingStandTime -= deltaSeconds;
			}
			else
			{
				delta = remainingStandTime;
				StopStanding();
			}
			newPos = StandRate*delta;
			Move(newPos);
		}
	}
}


// ----------------------------------------------------------------------
// JumpOutOfWater()
// ----------------------------------------------------------------------

function JumpOutOfWater(vector jumpDir)
{
	Falling();
	Velocity = jumpDir * WaterSpeed;
	Acceleration = jumpDir * AccelRate;
	velocity.Z = 380; //set here so physics uses this for remainder of tick
	PlayFalling();
	bUpAndOut = true;
}


// ----------------------------------------------------------------------
// SupportActor()
//
// Modified from DeusExDecoration.uc
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

	standingMass = FMax(1, standingActor.Mass);
	baseMass     = FMax(1, Mass);
	if ((Physics == PHYS_Swimming) && Region.Zone.bWaterZone)
	{
		newVelocity = standingActor.Velocity;
		newVelocity *= 0.5*standingMass/baseMass;
		AddVelocity(newVelocity);
	}
	else
	{
		zVelocity    = standingActor.Velocity.Z;
		damagePoint  = Location + vect(0,0,1)*(CollisionHeight-1);
		damage       = (1 - (standingMass/baseMass) * (zVelocity/100));

		// Have we been stomped?
		if ((zVelocity*standingMass < -7500) && (damage > 0) && WillTakeStompDamage(standingActor))
			TakeDamage(damage, standingActor.Instigator, damagePoint, 0.2*standingActor.Velocity, 'stomped');
	}

	// Bounce the actor off the pawn
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
// ----------------------------------------------------------------------

function Carcass SpawnCarcass()
{
	local DeusExCarcass carc;
	local vector loc;
	local Inventory item, nextItem;
	local FleshFragment chunk;
	local int i;
	local float size;

	// if we really got blown up good, gib us and don't display a carcass
	if ((Health < -100) && !IsA('Robot'))
	{
		size = (CollisionRadius + CollisionHeight) / 2;
		if (size > 10.0)
		{
			for (i=0; i<size/4.0; i++)
			{
				loc.X = (1-2*FRand()) * CollisionRadius;
				loc.Y = (1-2*FRand()) * CollisionRadius;
				loc.Z = (1-2*FRand()) * CollisionHeight;
				loc += Location;
				chunk = spawn(class'FleshFragment', None,, loc);
				if (chunk != None)
				{
					chunk.DrawScale = size / 25;
					chunk.SetCollisionSize(chunk.CollisionRadius / chunk.DrawScale, chunk.CollisionHeight / chunk.DrawScale);
					chunk.bFixedRotationDir = True;
					chunk.RotationRate = RotRand(False);
				}
			}
		}

		return None;
	}

	// spawn the carcass
	carc = DeusExCarcass(Spawn(CarcassType));

	if ( carc != None )
	{
		if (bStunned)
			carc.bNotDead = True;

		carc.Initfor(self);

		// move it down to the floor
		loc = Location;
		loc.z -= Default.CollisionHeight;
		loc.z += carc.Default.CollisionHeight;
		carc.SetLocation(loc);
		carc.Velocity = Velocity;
		carc.Acceleration = Acceleration;

		// give the carcass the pawn's inventory if we aren't an animal or robot
		if (!IsA('Animal') && !IsA('Robot'))
		{
			if (Inventory != None)
			{
				do
				{
					item = Inventory;
					nextItem = item.Inventory;
					DeleteInventory(item);
					if ((DeusExWeapon(item) != None) && (DeusExWeapon(item).bNativeAttack))
						item.Destroy();
					else
						carc.AddInventory(item);
					item = nextItem;
				}
				until (item == None);
			}
		}
	}

	return carc;
}


// ----------------------------------------------------------------------
// FilterDamageType()
// ----------------------------------------------------------------------

function bool FilterDamageType(Pawn instigatedBy, Vector hitLocation,
                               Vector offset, Name damageType)
{
	// Special cases for certain damage types
	if (damageType == 'HalonGas')
		if (bOnFire)
			ExtinguishFire();

	if (damageType == 'EMP')
	{
		CloakEMPTimer += 10;  // hack - replace with skill-based value
		if (CloakEMPTimer > 20)
			CloakEMPTimer = 20;
		EnableCloak(bCloakOn);
		return false;
	}

	return true;

}


// ----------------------------------------------------------------------
// ModifyDamage()
// ----------------------------------------------------------------------

function float ModifyDamage(int Damage, Pawn instigatedBy, Vector hitLocation,
                            Vector offset, Name damageType)
{
	local int   actualDamage;
	local float headOffsetZ, headOffsetY, armOffset;

	actualDamage = Damage;

	// calculate our hit extents
	headOffsetZ = CollisionHeight * 0.7;
	headOffsetY = CollisionRadius * 0.3;
	armOffset   = CollisionRadius * 0.35;

	// if the pawn is stunned, damage is 4X
	if (bStunned)
		actualDamage *= 4;

	// if the pawn is hit from behind at point-blank range, he is killed instantly
	else if (offset.x < 0)
		if ((instigatedBy != None) && (VSize(instigatedBy.Location - Location) < 64))
			actualDamage  *= 10;

	actualDamage = Level.Game.ReduceDamage(actualDamage, DamageType, self, instigatedBy);

	if (ReducedDamageType == 'All') //God mode
		actualDamage = 0;
	else if (Inventory != None) //then check if carrying armor
		actualDamage = Inventory.ReduceDamage(actualDamage, DamageType, HitLocation);

	// gas, EMP and nanovirus do no damage
	if (damageType == 'TearGas' || damageType == 'EMP' || damageType == 'NanoVirus')
		actualDamage = 0;

	return actualDamage;

}


// ----------------------------------------------------------------------
// ShieldDamage()
// ----------------------------------------------------------------------

function float ShieldDamage(Name damageType)
{
	return 1.0;
}


// ----------------------------------------------------------------------
// ImpartMomentum()
// ----------------------------------------------------------------------

function ImpartMomentum(Vector momentum, Pawn instigatedBy)
{
	if (Physics == PHYS_None)
		SetMovementPhysics();
	if (Physics == PHYS_Walking)
		momentum.Z = 0.4 * VSize(momentum);
	if ( instigatedBy == self )
		momentum *= 0.6;
	momentum = momentum/Mass;
	AddVelocity( momentum ); 
}


// ----------------------------------------------------------------------
// AddVelocity()
// ----------------------------------------------------------------------

function AddVelocity(Vector momentum)
{
	if (VSize(momentum) > 0.001)
		Super.AddVelocity(momentum);
}


// ----------------------------------------------------------------------
// CanShowPain()
// ----------------------------------------------------------------------

function bool CanShowPain()
{
	if (bShowPain && (TakeHitTimer <= 0))
		return true;
	else
		return false;
}


// ----------------------------------------------------------------------
// IsPrimaryDamageType()
// ----------------------------------------------------------------------

function bool IsPrimaryDamageType(name damageType)
{
	local bool bPrimary;

	switch (damageType)
	{
		case 'Exploded':
		case 'TearGas':
		case 'HalonGas':
		case 'PoisonGas':
		case 'PoisonEffect':
		case 'Radiation':
		case 'EMP':
		case 'Drowned':
		case 'NanoVirus':
			bPrimary = false;
			break;

		case 'Stunned':
		case 'KnockedOut':
		case 'Burned':
		case 'Flamed':
		case 'Poison':
		case 'Shot':
		case 'Sabot':
		default:
			bPrimary = true;
			break;
	}

	return (bPrimary);
}


// ----------------------------------------------------------------------
// ShouldReactToInjuryType()
// ----------------------------------------------------------------------

function bool ShouldReactToInjuryType(name damageType,
                                      bool bHatePrimary, bool bHateSecondary)
{
	local bool bIsPrimary;

	bIsPrimary = IsPrimaryDamageType(damageType);
	if ((bHatePrimary && bIsPrimary) || (bHateSecondary && !bIsPrimary))
		return true;
	else
		return false;
}


// ----------------------------------------------------------------------
// HandleDamage()
// ----------------------------------------------------------------------

function EHitLocation HandleDamage(int actualDamage, Vector hitLocation, Vector offset, name damageType)
{
	local EHitLocation hitPos;
	local float        headOffsetZ, headOffsetY, armOffset;

	// calculate our hit extents
	headOffsetZ = CollisionHeight * 0.7;
	headOffsetY = CollisionRadius * 0.3;
	armOffset   = CollisionRadius * 0.35;

	hitPos = HITLOC_None;

	if (actualDamage > 0)
	{
		//== Y|y: Kinda hacky, but we don't want to actually damage invincible pawns, just play the animations
		if(bInvincible)
			actualDamage = 0;

		if (offset.z > headOffsetZ)		// head
		{
			// narrow the head region
			if ((Abs(offset.x) < headOffsetY) || (Abs(offset.y) < headOffsetY))
			{
				// don't allow headshots with stunning weapons
				if ((damageType == 'Stunned') || (damageType == 'KnockedOut'))
					HealthHead -= actualDamage;
				else
					HealthHead -= actualDamage * 8;
				if (offset.x < 0.0)
					hitPos = HITLOC_HeadBack;
				else
					hitPos = HITLOC_HeadFront;
			}
			else  // sides of head treated as torso
			{
				HealthTorso -= actualDamage * 2;
				if (offset.x < 0.0)
					hitPos = HITLOC_TorsoBack;
				else
					hitPos = HITLOC_TorsoFront;
			}
		}
		else if (offset.z < 0.0)	// legs
		{
			if (offset.y > 0.0)
			{
				HealthLegRight -= actualDamage * 2;
				if (offset.x < 0.0)
					hitPos = HITLOC_RightLegBack;
				else
					hitPos = HITLOC_RightLegFront;
			}
			else
			{
				HealthLegLeft -= actualDamage * 2;
				if (offset.x < 0.0)
					hitPos = HITLOC_LeftLegBack;
				else
					hitPos = HITLOC_LeftLegFront;
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
				HealthArmRight -= actualDamage * 2;
				if (offset.x < 0.0)
					hitPos = HITLOC_RightArmBack;
				else
					hitPos = HITLOC_RightArmFront;
			}
			else if (offset.y < -armOffset)
			{
				HealthArmLeft -= actualDamage * 2;
				if (offset.x < 0.0)
					hitPos = HITLOC_LeftArmBack;
				else
					hitPos = HITLOC_LeftArmFront;
			}
			else
			{
				HealthTorso -= actualDamage * 2;
				if (offset.x < 0.0)
					hitPos = HITLOC_TorsoBack;
				else
					hitPos = HITLOC_TorsoFront;
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

	GenerateTotalHealth();

	return hitPos;

}


// ----------------------------------------------------------------------
// TakeDamageBase()
// ----------------------------------------------------------------------

function TakeDamageBase(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType,
                        bool bPlayAnim)
{
	local int          actualDamage;
	local Vector       offset;
	local float        origHealth;
	local EHitLocation hitPos;
	local float        shieldMult;

	// use the hitlocation to determine where the pawn is hit
	// transform the worldspace hitlocation into objectspace
	// in objectspace, remember X is front to back
	// Y is side to side, and Z is top to bottom
	offset = (hitLocation - Location) << Rotation;

	if (!CanShowPain())
		bPlayAnim = false;

	// Prevent injury if the NPC is intangible
	if (!bBlockActors && !bBlockPlayers && !bCollideActors)
		return;

	// No damage + no damage type = no reaction
	if ((Damage <= 0) && (damageType == 'None'))
		return;

	// Block certain damage types; perform special ops on others
	if (!FilterDamageType(instigatedBy, hitLocation, offset, damageType))
		return;

	// Impart momentum
	ImpartMomentum(momentum, instigatedBy);

	actualDamage = ModifyDamage(Damage, instigatedBy, hitLocation, offset, damageType);

	if (actualDamage > 0)
	{
		shieldMult = ShieldDamage(damageType);
		if (shieldMult > 0)
			actualDamage = Max(int(actualDamage*shieldMult), 1);
		else
			actualDamage = 0;
		if (shieldMult < 1.0)
			DrawShield();
	}

	origHealth = Health;

	hitPos = HandleDamage(actualDamage, hitLocation, offset, damageType);
	if (!bPlayAnim || (actualDamage <= 0))
		hitPos = HITLOC_None;

	if (bCanBleed)
		if ((damageType != 'Stunned') && (damageType != 'TearGas') && (damageType != 'HalonGas') &&
		    (damageType != 'PoisonGas') && (damageType != 'Radiation') && (damageType != 'EMP') &&
		    (damageType != 'NanoVirus') && (damageType != 'Drowned') && (damageType != 'KnockedOut') &&
		    (damageType != 'Poison') && (damageType != 'PoisonEffect'))
			bleedRate += (origHealth-Health)/(0.3*Default.Health);  // 1/3 of default health = bleed profusely

	if (CarriedDecoration != None)
		DropDecoration();

	if ((actualDamage > 0) && (damageType == 'Poison'))
		StartPoison(Damage, instigatedBy);

	if (Health <= 0)
	{
		ClearNextState();
		//PlayDeathHit(actualDamage, hitLocation, damageType);
		if ( actualDamage > mass )
			Health = -1 * actualDamage;
		SetEnemy(instigatedBy, 0, true);

		// gib us if we get blown up
		if (DamageType == 'Exploded')
			Health = -10000;
		else
			Health = -1;

		Died(instigatedBy, damageType, HitLocation);

		if ((DamageType == 'Flamed') || (DamageType == 'Burned'))
		{
			bBurnedToDeath = true;
			ScaleGlow *= 0.1;  // blacken the corpse
		}
		else
			bBurnedToDeath = false;

		return;
	}

	// play a hit sound
	if (DamageType != 'Stunned')
		PlayTakeHitSound(actualDamage, damageType, 1);

	if ((DamageType == 'Flamed') && !bOnFire)
		CatchFire();

	ReactToInjury(instigatedBy, damageType, hitPos);
}


// ----------------------------------------------------------------------
// IsNearHome()
// ----------------------------------------------------------------------

function bool IsNearHome(vector position)
{
	local bool bNear;

	bNear = true;
	if (bUseHome)
	{
		if (VSize(HomeLoc-position) <= HomeExtent)
		{
			if (!FastTrace(position, HomeLoc))
				bNear = false;
		}
		else
			bNear = false;
	}

	return bNear;
}


// ----------------------------------------------------------------------
// IsDoor()
// ----------------------------------------------------------------------

function bool IsDoor(Actor door, optional bool bWarn)
{
	local bool        bIsDoor;
	local DeusExMover dxMover;

	bIsDoor = false;

	dxMover = DeusExMover(door);
	if (dxMover != None)
	{
		if (dxMover.NumKeys > 1)
		{
			if (dxMover.bIsDoor)
				bIsDoor = true;
			/*
			else if (bWarn)  // hack for now
				log("WARNING: NPC "$self$" trying to use door "$dxMover$", but bIsDoor flag is False");
			*/
		}
	}

	return bIsDoor;
}


// ----------------------------------------------------------------------
// CheckOpenDoor()
// ----------------------------------------------------------------------

function CheckOpenDoor(vector HitNormal, actor Door, optional name Label)
{
	local DeusExMover dxMover;

	dxMover = DeusExMover(Door);
	if (dxMover != None)
	{
		if (bCanOpenDoors && !IsDoor(dxMover) && dxMover.bBreakable)  // break glass we walk into
		{
			dxMover.TakeDamage(200, self, dxMover.Location, Velocity, 'Shot');
			return;
		}

		if (dxMover.bInterpolating && (dxMover.MoverEncroachType == ME_IgnoreWhenEncroach))
			return;

		if (bCanOpenDoors && bInterruptState && !bInTransientState && IsDoor(dxMover, true))
		{
			if (Label == '')
				Label = 'Begin';
			if (GetStateName() != 'OpeningDoor')
				SetNextState(GetStateName(), 'ContinueFromDoor');
			Target = Door;
			destLoc = HitNormal;
			GotoState('OpeningDoor', 'BeginHitNormal');
		}
		else if ((Acceleration != vect(0,0,0)) && (Physics == PHYS_Walking) &&
		         (TurnDirection == TURNING_None))
			Destination = Location;
	}
}


// ----------------------------------------------------------------------
// EncroachedBy()
// ----------------------------------------------------------------------

event EncroachedBy( actor Other )
{
	// overridden so indestructable NPCs aren't InstaGibbed by stupid movement code
}


// ----------------------------------------------------------------------
// EncroachedByMover()
// ----------------------------------------------------------------------

function EncroachedByMover(Mover encroacher)
{
	local DeusExMover dxMover;

	dxMover = DeusExMover(encroacher);
	if (dxMover != None)
		if (!dxMover.bInterpolating && IsDoor(dxMover))
			FrobDoor(dxMover);
}


// ----------------------------------------------------------------------
// FrobDoor()
// ----------------------------------------------------------------------

function bool FrobDoor(actor Target)
{
	local DeusExMover      dxMover;
	local DeusExMover      triggerMover;
	local DeusExDecoration trigger;
	local float            dist;
	local DeusExDecoration bestTrigger;
	local float            bestDist;
	local bool             bDone;

	bDone = false;

	dxMover = DeusExMover(Target);
	if (dxMover != None)
	{
		bestTrigger = None;
		bestDist    = 10000;
		foreach AllActors(Class'DeusExDecoration', trigger)
		{
			if (dxMover.Tag == trigger.Event)
			{
				dist = VSize(Location - trigger.Location);
				if ((bestTrigger == None) || (bestDist > dist))
				{
					bestTrigger = trigger;
					bestDist    = dist;
				}
			}
		}
		if (bestTrigger != None)
		{
			foreach AllActors(Class'DeusExMover', triggerMover, dxMover.Tag)
				triggerMover.Trigger(bestTrigger, self);
			bDone = true;
		}
		else if (dxMover.bFrobbable)
		{
			if ((dxMover.WaitingPawn == None) ||
			    (dxMover.WaitingPawn == self))
			{
				dxMover.Frob(self, None);
				bDone = true;
			}
		}

		if (bDone)
			dxMover.WaitingPawn = self;
	}
	return bDone;

}


// ----------------------------------------------------------------------
// GotoDisabledState()
// ----------------------------------------------------------------------

function GotoDisabledState(name damageType, EHitLocation hitPos)
{
	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	else if ((damageType == 'TearGas') || (damageType == 'HalonGas'))
		GotoState('RubbingEyes');
	else if (damageType == 'Stunned')
		GotoState('Stunned');
	else if (CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
}


// ----------------------------------------------------------------------
// PlayAnimPivot()
// ----------------------------------------------------------------------

function PlayAnimPivot(name Sequence, optional float Rate, optional float TweenTime,
                       optional vector NewPrePivot)
{
	if (Rate == 0)
		Rate = 1.0;
	if (TweenTime == 0)
		TweenTime = 0.1;
	PlayAnim(Sequence, Rate, TweenTime);
	PrePivotTime    = TweenTime;
	DesiredPrePivot = NewPrePivot + PrePivotOffset;
	if (PrePivotTime <= 0)
		PrePivot = DesiredPrePivot;
}


// ----------------------------------------------------------------------
// LoopAnimPivot()
// ----------------------------------------------------------------------

function LoopAnimPivot(name Sequence, optional float Rate, optional float TweenTime, optional float MinRate,
                       optional vector NewPrePivot)
{
	if (Rate == 0)
		Rate = 1.0;
	if (TweenTime == 0)
		TweenTime = 0.1;
	LoopAnim(Sequence, Rate, TweenTime, MinRate);
	PrePivotTime    = TweenTime;
	DesiredPrePivot = NewPrePivot + PrePivotOffset;
	if (PrePivotTime <= 0)
		PrePivot = DesiredPrePivot;
}


// ----------------------------------------------------------------------
// TweenAnimPivot()
// ----------------------------------------------------------------------

function TweenAnimPivot(name Sequence, float TweenTime,
                        optional vector NewPrePivot)
{
	if (TweenTime == 0)
		TweenTime = 0.1;
	TweenAnim(Sequence, TweenTime);
	PrePivotTime    = TweenTime;
	DesiredPrePivot = NewPrePivot + PrePivotOffset;
	if (PrePivotTime <= 0)
		PrePivot = DesiredPrePivot;
}


// ----------------------------------------------------------------------
// HasTwoHandedWeapon()
// ----------------------------------------------------------------------

function Bool HasTwoHandedWeapon()
{
	if ((Weapon != None) && (Weapon.Mass >= 30))
		return True;
	else
		return False;
}


// ----------------------------------------------------------------------
// GetStyleTexture()
// ----------------------------------------------------------------------

function Texture GetStyleTexture(ERenderStyle newStyle, texture oldTex, optional texture newTex)
{
	local texture defaultTex;

	if      (newStyle == STY_Translucent)
		defaultTex = Texture'BlackMaskTex';
	else if (newStyle == STY_Modulated)
		defaultTex = Texture'GrayMaskTex';
	else if (newStyle == STY_Masked)
		defaultTex = Texture'PinkMaskTex';
	else
		defaultTex = Texture'BlackMaskTex';

	if (oldTex == None)
		return defaultTex;
	else if (oldTex == Texture'BlackMaskTex')
		return Texture'BlackMaskTex';  // hack
	else if (oldTex == Texture'GrayMaskTex')
		return defaultTex;
	else if (oldTex == Texture'PinkMaskTex')
		return defaultTex;
	else if (newTex != None)
		return newTex;
	else
		return oldTex;

}


// ----------------------------------------------------------------------
// SetSkinStyle()
// ----------------------------------------------------------------------

function SetSkinStyle(ERenderStyle newStyle, optional texture newTex, optional float newScaleGlow)
{
	local int     i;
	local texture curSkin;
	local texture oldSkin;

	if (newScaleGlow == 0)
		newScaleGlow = ScaleGlow;

	oldSkin = Skin;
	for (i=0; i<8; i++)
	{
		curSkin = GetMeshTexture(i);
		MultiSkins[i] = GetStyleTexture(newStyle, curSkin, newTex);
	}
	Skin      = GetStyleTexture(newStyle, Skin, newTex);
	ScaleGlow = newScaleGlow;
	Style     = newStyle;
}


// ----------------------------------------------------------------------
// ResetSkinStyle()
// ----------------------------------------------------------------------

function ResetSkinStyle()
{
	local int i;

	for (i=0; i<8; i++)
		MultiSkins[i] = Default.MultiSkins[i];
	Skin      = Default.Skin;
	ScaleGlow = Default.ScaleGlow;
	Style     = Default.Style;
}


// ----------------------------------------------------------------------
// EnableCloak()
// ----------------------------------------------------------------------

function EnableCloak(bool bEnable)  // beware! called from C++
{
	if (!bHasCloak || (CloakEMPTimer > 0) || (Health <= 0) || bOnFire)
		bEnable = false;

	if (bEnable && !bCloakOn)
	{
		SetSkinStyle(STY_Translucent, Texture'WhiteStatic', 0.05);
		KillShadow();
		bCloakOn = bEnable;
	}
	else if (!bEnable && bCloakOn)
	{
		ResetSkinStyle();
		CreateShadow();
		bCloakOn = bEnable;
	}
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// SOUND FUNCTIONS
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// PlayBodyThud()
// ----------------------------------------------------------------------

function PlayBodyThud()
{
	PlaySound(sound'BodyThud', SLOT_Interact);
}


// ----------------------------------------------------------------------
// RandomPitch()
//
// Repetitive sound pitch randomizer to help make some sounds
// sound less monotonous
// ----------------------------------------------------------------------

function float RandomPitch()
{
	return (1.1 - 0.2*FRand());
}


// ----------------------------------------------------------------------
// Gasp()
// ----------------------------------------------------------------------

function Gasp()
{
	PlaySound(sound'MaleGasp', SLOT_Pain,,,, RandomPitch());
}


// ----------------------------------------------------------------------
// PlayDyingSound()
// ----------------------------------------------------------------------

function PlayDyingSound()
{
	SetDistressTimer();
	PlaySound(Die, SLOT_Pain,,,, RandomPitch());
	AISendEvent('LoudNoise', EAITYPE_Audio);
	if (bEmitDistress)
		AISendEvent('Distress', EAITYPE_Audio);
}


// ----------------------------------------------------------------------
// PlayIdleSound()
// ----------------------------------------------------------------------

function PlayIdleSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if (dxPlayer != None)
		dxPlayer.StartAIBarkConversation(self, BM_Idle);
}


// ----------------------------------------------------------------------
// PlayScanningSound()
// ----------------------------------------------------------------------

function PlayScanningSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if (dxPlayer != None)
		dxPlayer.StartAIBarkConversation(self, BM_Scanning);
}


// ----------------------------------------------------------------------
// PlayPreAttackSearchingSound()
// ----------------------------------------------------------------------

function PlayPreAttackSearchingSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (SeekPawn == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_PreAttackSearching);
}


// ----------------------------------------------------------------------
// PlayPreAttackSightingSound()
// ----------------------------------------------------------------------

function PlayPreAttackSightingSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (SeekPawn == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_PreAttackSighting);
}


// ----------------------------------------------------------------------
// PlayPostAttackSearchingSound()
// ----------------------------------------------------------------------

function PlayPostAttackSearchingSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (SeekPawn == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_PostAttackSearching);
}


// ----------------------------------------------------------------------
// PlayTargetAcquiredSound()
// ----------------------------------------------------------------------

function PlayTargetAcquiredSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (Enemy == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_TargetAcquired);
}


// ----------------------------------------------------------------------
// PlayTargetLostSound()
// ----------------------------------------------------------------------

function PlayTargetLostSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (SeekPawn == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_TargetLost);
}


// ----------------------------------------------------------------------
// PlaySearchGiveUpSound()
// ----------------------------------------------------------------------

function PlaySearchGiveUpSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (SeekPawn == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_SearchGiveUp);
}


// ----------------------------------------------------------------------
// PlayNewTargetSound()
// ----------------------------------------------------------------------

function PlayNewTargetSound()
{
	// someday...
}


// ----------------------------------------------------------------------
// PlayGoingForAlarmSound()
// ----------------------------------------------------------------------

function PlayGoingForAlarmSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (Enemy == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_GoingForAlarm);
}


// ----------------------------------------------------------------------
// PlayOutOfAmmoSound()
// ----------------------------------------------------------------------

function PlayOutOfAmmoSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if (dxPlayer != None)
		dxPlayer.StartAIBarkConversation(self, BM_OutOfAmmo);
}


// ----------------------------------------------------------------------
// PlayCriticalDamageSound()
// ----------------------------------------------------------------------

function PlayCriticalDamageSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (Enemy == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_CriticalDamage);
}


// ----------------------------------------------------------------------
// PlayAreaSecureSound()
// ----------------------------------------------------------------------

function PlayAreaSecureSound()
{
	local DeusExPlayer dxPlayer;

	// Should we do a player check here?

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (Enemy == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_AreaSecure);
}


// ----------------------------------------------------------------------
// PlayFutzSound()
// ----------------------------------------------------------------------

function PlayFutzSound()
{
	local DeusExPlayer dxPlayer;
	local Name         conName;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if (dxPlayer != None)
	{
		if (dxPlayer.barkManager != None)
		{
			conName = dxPlayer.barkManager.BuildBarkName(self, BM_Futz);
			dxPlayer.StartConversationByName(conName, self, !bInterruptState);
		}
//		dxPlayer.StartAIBarkConversation(self, BM_Futz);
	}
}


// ----------------------------------------------------------------------
// PlayOnFireSound()
// ----------------------------------------------------------------------

function PlayOnFireSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if (dxPlayer != None)
		dxPlayer.StartAIBarkConversation(self, BM_OnFire);
}


// ----------------------------------------------------------------------
// PlayTearGasSound()
// ----------------------------------------------------------------------

function PlayTearGasSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if (dxPlayer != None)
		dxPlayer.StartAIBarkConversation(self, BM_TearGas);
}


// ----------------------------------------------------------------------
// PlayCarcassSound()
// ----------------------------------------------------------------------

function PlayCarcassSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (SeekPawn == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_Gore);
}


// ----------------------------------------------------------------------
// PlaySurpriseSound()
// ----------------------------------------------------------------------

function PlaySurpriseSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (Enemy == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_Surprise);
}


// ----------------------------------------------------------------------
// PlayAllianceHostileSound()
// ----------------------------------------------------------------------

function PlayAllianceHostileSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (Enemy == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_AllianceHostile);
}


// ----------------------------------------------------------------------
// PlayAllianceFriendlySound()
// ----------------------------------------------------------------------

function PlayAllianceFriendlySound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (Enemy == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_AllianceFriendly);
}


// ----------------------------------------------------------------------
// PlayTakeHitSound()
// ----------------------------------------------------------------------

function PlayTakeHitSound(int Damage, name damageType, int Mult)
{
	local Sound hitSound;
	local float volume;

	if (Level.TimeSeconds - LastPainSound < 0.25)
		return;
	if (Damage <= 0)
		return;

	LastPainSound = Level.TimeSeconds;

	if (Damage <= 30)
		hitSound = HitSound1;
	else
		hitSound = HitSound2;
	volume = FMax(Mult*TransientSoundVolume, Mult*2.0);

	SetDistressTimer();
	PlaySound(hitSound, SLOT_Pain, volume,,, RandomPitch());
	if ((hitSound != None) && bEmitDistress)
		AISendEvent('Distress', EAITYPE_Audio, volume);
}


// ----------------------------------------------------------------------
// GetFloorMaterial()
//
// Gets the name of the texture group that we are standing on
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
// Plays footstep sounds based on the texture group
// (yes, I know this looks nasty -- I'll have to figure out a cleaner way to do this)
// ----------------------------------------------------------------------

function PlayFootStep()
{
	local Sound stepSound;
	local float rnd;
	local name mat;
	local float speedFactor, massFactor;
	local float volume, pitch, range;
	local float radius, maxRadius;
	local float volumeMultiplier;

	local DeusExPlayer dxPlayer;
	local float shakeRadius, shakeMagnitude;
	local float playerDist;

	rnd = FRand();
	mat = GetFloorMaterial();

	volumeMultiplier = 1.0;
	if (WalkSound == None)
	{
		if (FootRegion.Zone.bWaterZone)
		{
			if (rnd < 0.33)
				stepSound = Sound'WaterStep1';
			else if (rnd < 0.66)
				stepSound = Sound'WaterStep2';
			else
				stepSound = Sound'WaterStep3';
		}
		else
		{
			switch(mat)
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
	}
	else
		stepSound = WalkSound;

	// compute sound volume, range and pitch, based on mass and speed
	speedFactor = VSize(Velocity)/120.0;
	massFactor  = Mass/150.0;
	radius      = 768.0;
	maxRadius   = 2048.0;
//	volume      = (speedFactor+0.2)*massFactor;
//	volume      = (speedFactor+0.7)*massFactor;
	volume      = massFactor*1.5;
	range       = radius * volume;
	pitch       = (volume+0.5);
	volume      = 1.0;
	range       = FClamp(range, 0.01, maxRadius);
	pitch       = FClamp(pitch, 1.0, 1.5);

	// play the sound and send an AI event
	PlaySound(stepSound, SLOT_Interact, volume, , range, pitch);
	AISendEvent('LoudNoise', EAITYPE_Audio, volume*volumeMultiplier, range*volumeMultiplier);

	// Shake the camera when heavy things tread
	if (Mass > 400)
	{
		dxPlayer = DeusExPlayer(GetPlayerPawn());
		if (dxPlayer != None)
		{
			playerDist = DistanceFromPlayer;
			shakeRadius = FClamp((Mass-400)/600, 0, 1.0) * (range*0.5);
			shakeMagnitude = FClamp((Mass-400)/1600, 0, 1.0);
			shakeMagnitude = FClamp(1.0-(playerDist/shakeRadius), 0, 1.0) * shakeMagnitude;
			if (shakeMagnitude > 0)
				dxPlayer.JoltView(shakeMagnitude);
		}
	}
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// ANIMATION CALLS
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// GetSwimPivot()
// ----------------------------------------------------------------------

function vector GetSwimPivot()
{
	// THIS IS A HIDEOUS, UGLY, MASSIVELY EVIL HACK!!!!
	return (vect(0,0,1)*CollisionHeight*0.65);
}


// ----------------------------------------------------------------------
// GetWalkingSpeed()
// ----------------------------------------------------------------------

function float GetWalkingSpeed()
{
	if (Physics == PHYS_Swimming)
		return MaxDesiredSpeed;
	else
		return WalkingSpeed;
}


// ----------------------------------------------------------------------
// PlayTurnHead()
// ----------------------------------------------------------------------

function bool PlayTurnHead(ELookDirection newLookDir, float rate, float tweentime)
{
	if (bCanTurnHead)
	{
		if (Super.PlayTurnHead(newLookDir, rate, tweentime))
		{
			AIAddViewRotation = rot(0,0,0); // default
			switch (newLookDir)
			{
				case LOOK_Left:
					AIAddViewRotation = rot(0,-5461,0);  // 30 degrees left
					break;
				case LOOK_Right:
					AIAddViewRotation = rot(0,5461,0);   // 30 degrees right
					break;
				case LOOK_Up:
					AIAddViewRotation = rot(5461,0,0);   // 30 degrees up
					break;
				case LOOK_Down:
					AIAddViewRotation = rot(-5461,0,0);  // 30 degrees down
					break;

				case LOOK_Forward:
					AIAddViewRotation = rot(0,0,0);      // 0 degrees
					break;
			}
		}
		else
			return false;
	}
	else
		return false;
}


// ----------------------------------------------------------------------
// PlayRunningAndFiring()
// ----------------------------------------------------------------------

function PlayRunningAndFiring()
{
	local DeusExWeapon W;
	local vector       v1, v2;
	local float        dotp;

	bIsWalking = FALSE;

	W = DeusExWeapon(Weapon);

	if (W != None)
	{
		if (Region.Zone.bWaterZone)
		{
			if (W.bHandToHand)
				LoopAnimPivot('Tread',,0.1,,GetSwimPivot());
			else
				LoopAnimPivot('TreadShoot',,0.1,,GetSwimPivot());
		}
		else
		{
			if (W.bHandToHand)
				LoopAnimPivot('Run',runAnimMult,0.1);
			else
			{
				v1 = Normal((Enemy.Location - Location)*vect(1,1,0));
				if (destPoint != None)
					v2 = Normal((destPoint.Location - Location)*vect(1,1,0));
				else
					v2 = Normal((destLoc - Location)*vect(1,1,0));
				dotp = Abs(v1 dot v2);
				if (dotp < 0.70710678)  // running sideways
				{
					if (HasTwoHandedWeapon())
						LoopAnimPivot('Strafe2H',runAnimMult,0.1);
					else
						LoopAnimPivot('Strafe',runAnimMult,0.1);
				}
				else
				{
					if (HasTwoHandedWeapon())
						LoopAnimPivot('RunShoot2H',runAnimMult,0.1);
					else
						LoopAnimPivot('RunShoot',runAnimMult,0.1);
				}
			}
		}
	}
}


// ----------------------------------------------------------------------
// PlayReloadBegin()
// ----------------------------------------------------------------------

function PlayReloadBegin()
{
	PlayAnimPivot('ReloadBegin',, 0.1);
}


// ----------------------------------------------------------------------
// PlayReload()
// ----------------------------------------------------------------------

function PlayReload()
{
	LoopAnimPivot('Reload',,0.2);
}


// ----------------------------------------------------------------------
// PlayReloadEnd()
// ----------------------------------------------------------------------

function PlayReloadEnd()
{
	PlayAnimPivot('ReloadEnd',, 0.1);
}


// ----------------------------------------------------------------------
// TweenToShoot()
// ----------------------------------------------------------------------

function TweenToShoot(float tweentime)
{
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('TreadShoot', tweentime, GetSwimPivot());
	else if (!bCrouching)
	{
		if (!IsWeaponReloading())
		{
			if (HasTwoHandedWeapon())
				TweenAnimPivot('Shoot2H', tweentime);
			else
				TweenAnimPivot('Shoot', tweentime);
		}
		else
			PlayReload();
	}
}


// ----------------------------------------------------------------------
// PlayShoot()
// ----------------------------------------------------------------------

function PlayShoot()
{
	if (Region.Zone.bWaterZone)
		PlayAnimPivot('TreadShoot', , 0, GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())
			PlayAnimPivot('Shoot2H', , 0);
		else
			PlayAnimPivot('Shoot', , 0);
	}
}


// ----------------------------------------------------------------------
// TweenToCrouchShoot()
// ----------------------------------------------------------------------

function TweenToCrouchShoot(float tweentime)
{
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('TreadShoot', tweentime, GetSwimPivot());
	else
		TweenAnimPivot('CrouchShoot', tweentime);
}


// ----------------------------------------------------------------------
// PlayCrouchShoot()
// ----------------------------------------------------------------------

function PlayCrouchShoot()
{
	if (Region.Zone.bWaterZone)
		PlayAnimPivot('TreadShoot', , 0, GetSwimPivot());
	else
		PlayAnimPivot('CrouchShoot', , 0);
}


// ----------------------------------------------------------------------
// TweenToAttack()
// ----------------------------------------------------------------------

function TweenToAttack(float tweentime)
{
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('Tread', tweentime, GetSwimPivot());
	else
	{
		if (bUseSecondaryAttack)
			TweenAnimPivot('AttackSide', tweentime);
		else
			TweenAnimPivot('Attack', tweentime);
	}
}


// ----------------------------------------------------------------------
// PlayAttack()
// ----------------------------------------------------------------------

function PlayAttack()
{
	if (Region.Zone.bWaterZone)
		PlayAnimPivot('Tread',,,GetSwimPivot());
	else
	{
		if (bUseSecondaryAttack)
			PlayAnimPivot('AttackSide');
		else
			PlayAnimPivot('Attack');
	}
}


// ----------------------------------------------------------------------
// PlayTurning()
// ----------------------------------------------------------------------

function PlayTurning()
{
//	ClientMessage("PlayTurning()");
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread', , , , GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())
			TweenAnimPivot('Walk2H', 0.1);
		else
			TweenAnimPivot('Walk', 0.1);
	}
}


// ----------------------------------------------------------------------
// TweenToWalking()
// ----------------------------------------------------------------------

function TweenToWalking(float tweentime)
{
//	ClientMessage("TweenToWalking()");
	bIsWalking = True;
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('Tread', tweentime, GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())
			TweenAnimPivot('Walk2H', tweentime);
		else
			TweenAnimPivot('Walk', tweentime);
	}
}


// ----------------------------------------------------------------------
// PlayWalking()
// ----------------------------------------------------------------------

function PlayWalking()
{
//	ClientMessage("PlayWalking()");
	bIsWalking = True;
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread', , 0.15, , GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())
			LoopAnimPivot('Walk2H',walkAnimMult, 0.15);
		else
			LoopAnimPivot('Walk',walkAnimMult, 0.15);
	}
}


// ----------------------------------------------------------------------
// TweenToRunning()
// ----------------------------------------------------------------------

function TweenToRunning(float tweentime)
{
//	ClientMessage("TweenToRunning()");
	bIsWalking = False;
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',, tweentime,, GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())
			LoopAnimPivot('RunShoot2H', runAnimMult, tweentime);
		else
			LoopAnimPivot('Run', runAnimMult, tweentime);
	}
}


// ----------------------------------------------------------------------
// PlayRunning()
// ----------------------------------------------------------------------

function PlayRunning()
{
//	ClientMessage("PlayRunning()");
	bIsWalking = False;
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',,,,GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())
			LoopAnimPivot('RunShoot2H', runAnimMult);
		else
			LoopAnimPivot('Run', runAnimMult);
	}
}


// ----------------------------------------------------------------------
// PlayPanicRunning()
// ----------------------------------------------------------------------

function PlayPanicRunning()
{
//	ClientMessage("PlayPanicRunning()");
	bIsWalking = False;
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',,,,GetSwimPivot());
	else
		LoopAnimPivot('Panic', runAnimMult);
}


// ----------------------------------------------------------------------
// TweenToWaiting()
// ----------------------------------------------------------------------

function TweenToWaiting(float tweentime)
{
//	ClientMessage("TweenToWaiting()");
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('Tread', tweentime, GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())
			TweenAnimPivot('BreatheLight2H', tweentime);
		else
			TweenAnimPivot('BreatheLight', tweentime);
	}
}


// ----------------------------------------------------------------------
// PlayWaiting()
// ----------------------------------------------------------------------

function PlayWaiting()
{
//	ClientMessage("PlayWaiting()");
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread', , 0.3, , GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())
			LoopAnimPivot('BreatheLight2H', , 0.3);
		else
			LoopAnimPivot('BreatheLight', , 0.3);
	}
}


// ----------------------------------------------------------------------
// PlayIdle()
// ----------------------------------------------------------------------

function PlayIdle()
{
//	ClientMessage("PlayIdle()");
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread', , 0.3, , GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())
			PlayAnimPivot('Idle12H', , 0.3);
		else
			PlayAnimPivot('Idle1', , 0.3);
	}
}


// ----------------------------------------------------------------------
// PlayDancing()
// ----------------------------------------------------------------------

function PlayDancing()
{
//	ClientMessage("PlayDancing()");
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread', , 0.3, , GetSwimPivot());
	else
		LoopAnimPivot('Dance', FRand()*0.2+0.9, 0.3);
}


// ----------------------------------------------------------------------
// PlaySittingDown()
// ----------------------------------------------------------------------

function PlaySittingDown()
{
//	ClientMessage("PlaySittingDown()");
	PlayAnimPivot('SitBegin', , 0.15);
}


// ----------------------------------------------------------------------
// PlaySitting()
// ----------------------------------------------------------------------

function PlaySitting()
{
//	ClientMessage("PlaySitting()");
	LoopAnimPivot('SitBreathe', , 0.15);
}


// ----------------------------------------------------------------------
// PlayStandingUp()
// ----------------------------------------------------------------------

function PlayStandingUp()
{
//	ClientMessage("PlayStandingUp()");
	PlayAnimPivot('SitStand', , 0.15);
}


// ----------------------------------------------------------------------
// PlayRubbingEyesStart()
// ----------------------------------------------------------------------

function PlayRubbingEyesStart()
{
//	ClientMessage("PlayRubbingEyesStart()");
	PlayAnimPivot('RubEyesStart', , 0.15);
}


// ----------------------------------------------------------------------
// PlayRubbingEyes()
// ----------------------------------------------------------------------

function PlayRubbingEyes()
{
//	ClientMessage("PlayRubbingEyes()");
	LoopAnimPivot('RubEyes');
}


// ----------------------------------------------------------------------
// PlayRubbingEyesEnd()
// ----------------------------------------------------------------------

function PlayRubbingEyesEnd()
{
//	ClientMessage("PlayRubbingEyesEnd()");
	PlayAnimPivot('RubEyesStop');
}


// ----------------------------------------------------------------------
// PlayCowerBegin()
// ----------------------------------------------------------------------

function PlayCowerBegin()
{
//	ClientMessage("PlayCowerBegin()");
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',,,,GetSwimPivot());
	else
		PlayAnimPivot('CowerBegin');
}


// ----------------------------------------------------------------------
// PlayCowering()
// ----------------------------------------------------------------------

function PlayCowering()
{
//	ClientMessage("PlayCowering()");
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',,,,GetSwimPivot());
	else
		LoopAnimPivot('CowerStill');
}


// ----------------------------------------------------------------------
// PlayCowerEnd()
// ----------------------------------------------------------------------

function PlayCowerEnd()
{
//	ClientMessage("PlayCowerEnd()");
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',,,,GetSwimPivot());
	else
		PlayAnimPivot('CowerEnd');
}


// ----------------------------------------------------------------------
// PlayStunned()
// ----------------------------------------------------------------------

function PlayStunned()
{
//	ClientMessage("PlayStunned()");
	LoopAnimPivot('Shocked');
}


// ----------------------------------------------------------------------
// TweenToSwimming()
// ----------------------------------------------------------------------

function TweenToSwimming(float tweentime)
{
//	ClientMessage("TweenToSwimming()");
	TweenAnimPivot('Tread', tweentime, GetSwimPivot());
}


// ----------------------------------------------------------------------
// PlaySwimming()
// ----------------------------------------------------------------------

function PlaySwimming()
{
//	ClientMessage("PlaySwimming()");
	LoopAnimPivot('Tread', , , , GetSwimPivot());
}


// ----------------------------------------------------------------------
// PlayFalling()
// ----------------------------------------------------------------------

function PlayFalling()
{
//	ClientMessage("PlayFalling()");
	PlayAnimPivot('Jump', 3, 0.1);
}


// ----------------------------------------------------------------------
// PlayLanded()
// ----------------------------------------------------------------------

function PlayLanded(float impactVel)
{
//	ClientMessage("PlayLanded()");
	bIsWalking = True;
	if (impactVel < -12*CollisionHeight)
		PlayAnimPivot('Land');
}


// ----------------------------------------------------------------------
// PlayDuck()
// ----------------------------------------------------------------------

function PlayDuck()
{
//	ClientMessage("PlayDuck()");
	TweenAnimPivot('CrouchWalk', 0.25);
//	PlayAnimPivot('Crouch');
}


// ----------------------------------------------------------------------
// PlayRising()
// ----------------------------------------------------------------------

function PlayRising()
{
//	ClientMessage("PlayRising()");
	PlayAnimPivot('Stand');
}


// ----------------------------------------------------------------------
// PlayCrawling()
// ----------------------------------------------------------------------

function PlayCrawling()
{
//	ClientMessage("PlayCrawling()");
	LoopAnimPivot('CrouchWalk');
}


// ----------------------------------------------------------------------
// PlayPushing()
// ----------------------------------------------------------------------

function PlayPushing()
{
//	ClientMessage("PlayPushing()");
	PlayAnimPivot('PushButton', , 0.15);
}


// ----------------------------------------------------------------------
// PlayBeginAttack()
// ----------------------------------------------------------------------

function bool PlayBeginAttack()
{
	return false;
}


// ----------------------------------------------------------------------
// PlayFiring()
// ----------------------------------------------------------------------

/*
function PlayFiring()
{
	local DeusExWeapon W;

//	ClientMessage("PlayFiring()");

	W = DeusExWeapon(Weapon);

	if (W != None)
	{
		if (W.bHandToHand)
		{
			PlayAnimPivot('Attack',,0.1);
		}
		else
		{
			if (W.bAutomatic)
			{
				if (HasTwoHandedWeapon())
					LoopAnimPivot('Shoot2H',,0.1);
				else
					LoopAnimPivot('Shoot',,0.1);
			}
			else
			{
				if (HasTwoHandedWeapon())
					PlayAnimPivot('Shoot2H',,0.1);
				else
					PlayAnimPivot('Shoot',,0.1);
			}
		}
	}
}
*/


// ----------------------------------------------------------------------
// PlayTakingHit()
// ----------------------------------------------------------------------

function PlayTakingHit(EHitLocation hitPos)
{
	local vector pivot;
	local name   animName;

	animName = '';
	if (!Region.Zone.bWaterZone)
	{
		switch (hitPos)
		{
			case HITLOC_HeadFront:
				animName = 'HitHead';
				break;
			case HITLOC_TorsoFront:
				animName = 'HitTorso';
				break;
			case HITLOC_LeftArmFront:
				animName = 'HitArmLeft';
				break;
			case HITLOC_RightArmFront:
				animName = 'HitArmRight';
				break;

			case HITLOC_HeadBack:
				animName = 'HitHeadBack';
				break;
			case HITLOC_TorsoBack:
			case HITLOC_LeftArmBack:
			case HITLOC_RightArmBack:
				animName = 'HitTorsoBack';
				break;

			case HITLOC_LeftLegFront:
			case HITLOC_LeftLegBack:
				animName = 'HitLegLeft';
				break;

			case HITLOC_RightLegFront:
			case HITLOC_RightLegBack:
				animName = 'HitLegRight';
				break;
		}
		pivot = vect(0,0,0);
	}
	else
	{
		switch (hitPos)
		{
			case HITLOC_HeadFront:
			case HITLOC_TorsoFront:
			case HITLOC_LeftLegFront:
			case HITLOC_RightLegFront:
			case HITLOC_LeftArmFront:
			case HITLOC_RightArmFront:
				animName = 'WaterHitTorso';
				break;

			case HITLOC_HeadBack:
			case HITLOC_TorsoBack:
			case HITLOC_LeftLegBack:
			case HITLOC_RightLegBack:
			case HITLOC_LeftArmBack:
			case HITLOC_RightArmBack:
				animName = 'WaterHitTorsoBack';
				break;
		}
		pivot = GetSwimPivot();
	}

	if (animName != '')
		PlayAnimPivot(animName, , 0.1, pivot);

}


// ----------------------------------------------------------------------
// PlayWeaponSwitch()
// ----------------------------------------------------------------------

function PlayWeaponSwitch(Weapon newWeapon)
{
//	ClientMessage("PlayWeaponSwitch()");
}


// ----------------------------------------------------------------------
// PlayDying()
// ----------------------------------------------------------------------

function PlayDying(name damageType, vector hitLoc)
{
	local Vector X, Y, Z;
	local float dotp;

//	ClientMessage("PlayDying()");
	if (Region.Zone.bWaterZone)
		PlayAnimPivot('WaterDeath',, 0.1);
	else if (bSitting)  // if sitting, always fall forward
		PlayAnimPivot('DeathFront',, 0.1);
	else
	{
		GetAxes(Rotation, X, Y, Z);
		dotp = (Location - HitLoc) dot X;

		// die from the correct side
		if (dotp < 0.0)		// shot from the front, fall back
			PlayAnimPivot('DeathBack',, 0.1);
		else				// shot from the back, fall front
			PlayAnimPivot('DeathFront',, 0.1);
	}

	// don't scream if we are stunned
	if ((damageType == 'Stunned') || (damageType == 'KnockedOut') ||
	    (damageType == 'Poison') || (damageType == 'PoisonEffect'))
	{
		bStunned = True;
		if (bIsFemale)
			PlaySound(Sound'FemaleUnconscious', SLOT_Pain,,,, RandomPitch());
		else
			PlaySound(Sound'MaleUnconscious', SLOT_Pain,,,, RandomPitch());
	}
	else
	{
		bStunned = False;
		PlayDyingSound();
	}
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// FIRE ROUTINES
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// CatchFire()
// ----------------------------------------------------------------------

function CatchFire()
{
	local Fire f;
	local int i;
	local vector loc;

	if (bOnFire || Region.Zone.bWaterZone || (BurnPeriod <= 0) || bInvincible)
		return;

	bOnFire = True;
	burnTimer = 0;

	EnableCloak(false);

	for (i=0; i<8; i++)
	{
		loc.X = 0.5*CollisionRadius * (1.0-2.0*FRand());
		loc.Y = 0.5*CollisionRadius * (1.0-2.0*FRand());
		loc.Z = 0.6*CollisionHeight * (1.0-2.0*FRand());
		loc += Location;
		f = Spawn(class'Fire', Self,, loc);
		if (f != None)
		{
			f.DrawScale = 0.5*FRand() + 1.0;

			// turn off the sound and lights for all but the first one
			if (i > 0)
			{
				f.AmbientSound = None;
				f.LightType = LT_None;
			}

			// turn on/off extra fire and smoke
			if (FRand() < 0.5)
				f.smokeGen.Destroy();
			if (FRand() < 0.5)
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
// UpdateFire()
// ----------------------------------------------------------------------

function UpdateFire()
{
	// continually burn and do damage
	HealthTorso -= 5;
	GenerateTotalHealth();
	if (Health <= 0)
	{
		TakeDamage(10, None, Location, vect(0,0,0), 'Burned');
		ExtinguishFire();
	}
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// CONVERSATION FUNCTIONS
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// CanConverse()
// ----------------------------------------------------------------------

function bool CanConverse()
{
	// Return True if this NPC is in a conversable state
	return (bCanConverse && bInterruptState && ((Physics == PHYS_Walking) || (Physics == PHYS_Flying)));
}


// ----------------------------------------------------------------------
// CanConverseWithPlayer()
// ----------------------------------------------------------------------

function bool CanConverseWithPlayer(DeusExPlayer dxPlayer)
{
	local name alliance1, alliance2, carcname;  // temp vars

	if (GetPawnAllianceType(dxPlayer) == ALLIANCE_Hostile)
		return false;
	else if ((GetStateName() == 'Fleeing') && (Enemy != dxPlayer) && (IsValidEnemy(Enemy, false)))  // hack
		return false;
	else if (GetCarcassData(dxPlayer, alliance1, alliance2, carcname))
		return false;
	else
		return true;
}


// ----------------------------------------------------------------------
// EndConversation()
// ----------------------------------------------------------------------

function EndConversation()
{
	Super.EndConversation();

	if ((GetStateName() == 'Conversation') || (GetStateName() == 'FirstPersonConversation'))
	{
		bConversationEndedNormally = True;

		if (!bConvEndState)
			FollowOrders();
	}

	bInConversation = False;
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// STIMULI AND AGITATION ROUTINES
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// LoudNoiseScore()
// ----------------------------------------------------------------------

function float LoudNoiseScore(actor receiver, actor sender, float score)
{
	local Pawn pawnSender;

	// Cull events received from friends
	pawnSender = Pawn(sender);
	if (pawnSender == None)
		pawnSender = sender.Instigator;
	if (pawnSender == None)
		score = 0;
	else if (!IsValidEnemy(pawnSender))
		score = 0;

	return score;
}


// ----------------------------------------------------------------------
// WeaponDrawnScore()
// ----------------------------------------------------------------------

function float WeaponDrawnScore(actor receiver, actor sender, float score)
{
	local Pawn pawnSender;

	// Cull events received from enemies
	pawnSender = Pawn(sender);
	if (pawnSender == None)
		pawnSender = Pawn(sender.Owner);
	if (pawnSender == None)
		pawnSender = sender.Instigator;
	if (pawnSender == None)
		score = 0;
	else if (IsValidEnemy(pawnSender))
		score = 0;

	return score;
}


// ----------------------------------------------------------------------
// DistressScore()
// ----------------------------------------------------------------------

function float DistressScore(actor receiver, actor sender, float score)
{
	local ScriptedPawn scriptedSender;
	local Pawn         pawnSender;

	// Cull events received from enemies
	sender         = InstigatorToPawn(sender);  // hack
	pawnSender     = Pawn(sender);
	scriptedSender = ScriptedPawn(sender);
	if (pawnSender == None)
		score = 0;
	else if ((GetPawnAllianceType(pawnSender) != ALLIANCE_Friendly) && !bFearDistress)
		score = 0;
	else if ((scriptedSender != None) && !scriptedSender.bDistressed)
		score = 0;

	return score;
}


// ----------------------------------------------------------------------
// UpdateReactionCallbacks()
// ----------------------------------------------------------------------

function UpdateReactionCallbacks()
{
	if (bReactFutz && bLookingForFutz)
		AISetEventCallback('Futz', 'HandleFutz', , true, true, false, true);
	else
		AIClearEventCallback('Futz');

	if ((bHateHacking || bFearHacking) && bLookingForHacking)
		AISetEventCallback('MegaFutz', 'HandleHacking', , true, true, true, true);
	else
		AIClearEventCallback('MegaFutz');

	if ((bHateWeapon || bFearWeapon) && bLookingForWeapon)
		AISetEventCallback('WeaponDrawn', 'HandleWeapon', 'WeaponDrawnScore', true, true, false, true);
	else
		AIClearEventCallback('WeaponDrawn');

	if ((bReactShot || bFearShot || bHateShot) && bLookingForShot)
		AISetEventCallback('WeaponFire', 'HandleShot', , true, true, false, true);
	else
		AIClearEventCallback('WeaponFire');

/*
	if ((bHateCarcass || bReactCarcass || bFearCarcass) && bLookingForCarcass)
		AISetEventCallback('Carcass', 'HandleCarcass', 'CarcassScore', true, true, false, true);
	else
		AIClearEventCallback('Carcass');
*/

	if (bReactLoudNoise && bLookingForLoudNoise)
		AISetEventCallback('LoudNoise', 'HandleLoudNoise', 'LoudNoiseScore');
	else
		AIClearEventCallback('LoudNoise');

	if ((bReactAlarm || bFearAlarm) && bLookingForAlarm)
		AISetEventCallback('Alarm', 'HandleAlarm');
	else
		AIClearEventCallback('Alarm');

	if ((bHateDistress || bReactDistress || bFearDistress) && bLookingForDistress)
		AISetEventCallback('Distress', 'HandleDistress', 'DistressScore', true, true, false, true);
	else
		AIClearEventCallback('Distress');

	if ((bFearProjectiles || bReactProjectiles) && bLookingForProjectiles)
		AISetEventCallback('Projectile', 'HandleProjectiles', , false, true, false, true);
	else
		AIClearEventCallback('Projectile');
}


// ----------------------------------------------------------------------
// SetReactions()
// ----------------------------------------------------------------------

function SetReactions(bool bEnemy, bool bLoudNoise, bool bAlarm, bool bDistress,
                      bool bProjectile, bool bFutz, bool bHacking, bool bShot, bool bWeapon, bool bCarcass,
                      bool bInjury, bool bIndirectInjury)
{
	bLookingForEnemy          = bEnemy;
	bLookingForLoudNoise      = bLoudNoise;
	bLookingForAlarm          = bAlarm;
	bLookingForDistress       = bDistress;
	bLookingForProjectiles    = bProjectile;
	bLookingForFutz           = bFutz;
	bLookingForHacking        = bHacking;
	bLookingForShot           = bShot;
	bLookingForWeapon         = bWeapon;
	bLookingForCarcass        = bCarcass;
	bLookingForInjury         = bInjury;
	bLookingForIndirectInjury = bIndirectInjury;

	UpdateReactionCallbacks();

}


// ----------------------------------------------------------------------
// BlockReactions()
// ----------------------------------------------------------------------

function BlockReactions(optional bool bBlockInjury)
{
	SetReactions(false, false, false, false, false, false, false, false, false, false, !bBlockInjury, !bBlockInjury);
}


// ----------------------------------------------------------------------
// ResetReactions()
// ----------------------------------------------------------------------

function ResetReactions()
{
	SetReactions(true, true, true, true, true, true, true, true, true, true, true, true);
}


// ----------------------------------------------------------------------
// HandleFutz()
// ----------------------------------------------------------------------

function HandleFutz(Name event, EAIEventState state, XAIParams params)
{
	// React

	if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
		ReactToFutz();  // only players can futz
}


// ----------------------------------------------------------------------
// HandleHacking()
// ----------------------------------------------------------------------

function HandleHacking(Name event, EAIEventState state, XAIParams params)
{
	// Fear, Hate

	local Pawn pawnActor;

	if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
	{
		pawnActor = GetPlayerPawn();
		if (pawnActor != None)
		{
			if (bHateHacking)
				IncreaseAgitation(pawnActor, 1.0);
			if (bFearHacking)
				IncreaseFear(pawnActor, 0.51);
			if (SetEnemy(pawnActor))
			{
				SetDistressTimer();
				HandleEnemy();
			}
			else if (bFearHacking && IsFearful())
			{
				SetDistressTimer();
				SetEnemy(pawnActor, , true);
				GotoState('Fleeing');
			}
			else  // only players can hack
				ReactToFutz();
		}
	}
}


// ----------------------------------------------------------------------
// HandleWeapon()
// ----------------------------------------------------------------------

function HandleWeapon(Name event, EAIEventState state, XAIParams params)
{
	// Fear, Hate

	local Pawn pawnActor;

	if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
	{
		pawnActor = InstigatorToPawn(params.bestActor);
		if (pawnActor != None)
		{
			if (bHateWeapon)
				IncreaseAgitation(pawnActor);
			if (bFearWeapon)
				IncreaseFear(pawnActor, 1.0);

			// Let presence checking handle enemy sighting

			if (!IsValidEnemy(pawnActor))
			{
				if (bFearWeapon && IsFearful())
				{
					SetDistressTimer();
					SetEnemy(pawnActor, , true);
					GotoState('Fleeing');
				}
				else if (pawnActor.bIsPlayer)
					ReactToFutz();
			}
		}
	}
}


// ----------------------------------------------------------------------
// HandleShot()
// ----------------------------------------------------------------------

function HandleShot(Name event, EAIEventState state, XAIParams params)
{
	// React, Fear, Hate

	local Pawn pawnActor;

	if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
	{
		pawnActor = InstigatorToPawn(params.bestActor);
		if (pawnActor != None)
		{
			if (bHateShot)
				IncreaseAgitation(pawnActor);
			if (bFearShot)
				IncreaseFear(pawnActor, 1.0);
			if (SetEnemy(pawnActor))
			{
				SetDistressTimer();
				HandleEnemy();
			}
			else if (bFearShot && IsFearful())
			{
				SetDistressTimer();
				SetEnemy(pawnActor, , true);
				GotoState('Fleeing');
			}
			else if (pawnActor.bIsPlayer)
				ReactToFutz();
		}
	}
}


// ----------------------------------------------------------------------
// HandleLoudNoise()
// ----------------------------------------------------------------------

function HandleLoudNoise(Name event, EAIEventState state, XAIParams params)
{
	// React

	local Actor bestActor;
	local Pawn  instigator;

	if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
	{
		bestActor = params.bestActor;
		if (bestActor != None)
		{
			instigator = Pawn(bestActor);
			if (instigator == None)
				instigator = bestActor.Instigator;
			if (instigator != None)
			{
				if (IsValidEnemy(instigator))
				{
					SetSeekLocation(instigator, bestActor.Location, SEEKTYPE_Sound);
					HandleEnemy();
				}
			}
		}
	}
}


// ----------------------------------------------------------------------
// HandleProjectiles()
// ----------------------------------------------------------------------

function HandleProjectiles(Name event, EAIEventState state, XAIParams params)
{
	// React, Fear

	local DeusExProjectile dxProjectile;

	if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
		if (params.bestActor != None)
			ReactToProjectiles(params.bestActor);
}


// ----------------------------------------------------------------------
// HandleAlarm()
// ----------------------------------------------------------------------

function HandleAlarm(Name event, EAIEventState state, XAIParams params)
{
	// React, Fear

	local AlarmUnit      alarm;
	local LaserTrigger   laser;
	local SecurityCamera camera;
	local Computers      computer;
	local Pawn           alarmInstigator;
	local vector         alarmLocation;

	if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
	{
		alarmInstigator = None;
		alarm    = AlarmUnit(params.bestActor);
		laser    = LaserTrigger(params.bestActor);
		camera   = SecurityCamera(params.bestActor);
		computer = Computers(params.bestActor);
		if (alarm != None)
		{
			alarmInstigator = alarm.alarmInstigator;
			alarmLocation   = alarm.alarmLocation;
		}
		else if (laser != None)
		{
			alarmInstigator = Pawn(laser.triggerActor);
			if (alarmInstigator == None)
				alarmInstigator = laser.triggerActor.Instigator;
			alarmLocation   = laser.actorLocation;
		}
		else if (camera != None)
		{
			alarmInstigator = GetPlayerPawn();  // player is implicit for cameras
			alarmLocation   = camera.playerLocation;
		}
		else if (computer != None)
		{
			alarmInstigator = GetPlayerPawn();  // player is implicit for computers
			alarmLocation   = computer.Location;
		}

		if (bFearAlarm)
		{
			IncreaseFear(alarmInstigator, 2.0);
			if (IsFearful())
			{
				SetDistressTimer();
				SetEnemy(alarmInstigator, , true);
				GotoState('Fleeing');
			}
		}

		if (alarmInstigator != None)
		{
			if (alarmInstigator.Health > 0)
			{
				if (IsValidEnemy(alarmInstigator))
				{
					AlarmTimer = 120;
					SetDistressTimer();
					SetSeekLocation(alarmInstigator, alarmLocation, SEEKTYPE_Sound);
					HandleEnemy();
				}
			}
		}
	}
}


// ----------------------------------------------------------------------
// HandleDistress()
// ----------------------------------------------------------------------

function HandleDistress(Name event, EAIEventState state, XAIParams params)
{
	// React, Fear, Hate

	local float        seeTime;
	local Pawn         distressee;
	local DeusExPlayer distresseePlayer;
	local ScriptedPawn distresseePawn;
	local Pawn         distressor;
	local DeusExPlayer distressorPlayer;
	local ScriptedPawn distressorPawn;
	local bool         bDistresseeValid;
	local bool         bDistressorValid;
	local float        distressVal;
	local name         stateName;
	local bool         bAttacking;
	local bool         bFleeing;

	bAttacking = false;
	seeTime    = 0;

	if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
	{
		distressee = InstigatorToPawn(params.bestActor);
		if (distressee != None)
		{
			if (bFearDistress)
				IncreaseFear(distressee.Enemy, 1.0);
			bDistresseeValid = false;
			bDistressorValid = false;
			distresseePlayer = DeusExPlayer(distressee);
			distresseePawn   = ScriptedPawn(distressee);
			if (GetPawnAllianceType(distressee) == ALLIANCE_Friendly)
			{
				if (distresseePawn != None)
				{
					if (distresseePawn.bDistressed && (distresseePawn.EnemyLastSeen <= EnemyTimeout))
					{
						bDistresseeValid = true;
						seeTime          = distresseePawn.EnemyLastSeen;
					}
				}
				else if (distresseePlayer != None)
					bDistresseeValid = true;
			}
			if (bDistresseeValid)
			{
				distressor       = distressee.Enemy;
				distressorPlayer = DeusExPlayer(distressor);
				distressorPawn   = ScriptedPawn(distressor);
				if (distressorPawn != None)
				{
					if (bHateDistress || (distressorPawn.GetPawnAllianceType(distressee) == ALLIANCE_Hostile))
						bDistressorValid = true;
				}
				else if (distresseePawn != None)
				{
					if (bHateDistress || (distresseePawn.GetPawnAllianceType(distressor) == ALLIANCE_Hostile))
						bDistressorValid = true;
				}

				// Finally, react
				if (bDistressorValid)
				{
					if (bHateDistress)
						IncreaseAgitation(distressor, 1.0);
					if (SetEnemy(distressor, seeTime))
					{
						SetDistressTimer();
						HandleEnemy();
						bAttacking = true;
					}
				}
				// BOOGER! Make NPCs react by seeking if distressor isn't an enemy?
			}

			if (!bAttacking && bFearDistress)
			{
				distressVal = 0;
				bFleeing    = false;
				if (distresseePawn != None)
				{
					stateName = distresseePawn.GetStateName();
					if (stateName == 'Fleeing')  // hack -- to prevent infinite fleeing
					{
						if (distresseePawn.DistressTimer >= 0)
						{
							if (FearSustainTime - distresseePawn.DistressTimer >= 1)
							{
								IncreaseFear(distressee.Enemy, 1.0, distresseePawn.DistressTimer);
								distressVal = distresseePawn.DistressTimer;
								bFleeing    = true;
							}
						}
					}
					else
					{
						IncreaseFear(distressee.Enemy, 1.0);
						bFleeing = true;
					}
				}
				else
				{
					IncreaseFear(distressee.Enemy, 1.0);
					bFleeing = true;
				}
				if (bFleeing && IsFearful())
				{
					if ((DistressTimer > distressVal) || (DistressTimer < 0))
						DistressTimer = distressVal;
					SetEnemy(distressee.Enemy, , true);
					GotoState('Fleeing');
				}
			}
		}
	}
}


// ----------------------------------------------------------------------
// IncreaseFear()
// ----------------------------------------------------------------------

function IncreaseFear(Actor actorInstigator, float addedFearLevel,
                      optional float newFearTimer)
{
	local DeusExPlayer player;
	local Pawn         instigator;

	instigator = InstigatorToPawn(actorInstigator);
	if (instigator != None)
	{
		if (FearTimer < (FearSustainTime-newFearTimer))
			FearTimer = FearSustainTime-newFearTimer;
		if (FearTimer > 0)
		{
			if (addedFearLevel > 0)
			{
				FearLevel += addedFearLevel;
				if (FearLevel > 1.0)
					FearLevel = 1.0;
			}
		}
	}
}


// ----------------------------------------------------------------------
// IncreaseAgitation()
// ----------------------------------------------------------------------

function IncreaseAgitation(Actor actorInstigator, optional float AgitationLevel)
{
	local Pawn  instigator;
	local float minLevel;

	instigator = InstigatorToPawn(actorInstigator);
	if (instigator != None)
	{
		AgitationTimer = AgitationSustainTime;
		if (AgitationCheckTimer <= 0)
		{
			AgitationCheckTimer = 1.5;  // hardcoded for now
			if (AgitationLevel == 0)
			{
				if (MaxProvocations < 0)
					MaxProvocations = 0;
				AgitationLevel = 1.0/(MaxProvocations+1);
			}
			if (AgitationLevel > 0)
			{
				bAlliancesChanged    = True;
				bNoNegativeAlliances = False;
				AgitateAlliance(instigator.Alliance, AgitationLevel);
			}
		}
	}

}


// ----------------------------------------------------------------------
// DecreaseAgitation()
// ----------------------------------------------------------------------

function DecreaseAgitation(Actor actorInstigator, float AgitationLevel)
{
	local float        newLevel;
	local DeusExPlayer player;
	local Pawn         instigator;

	player = DeusExPlayer(GetPlayerPawn());

	if (Inventory(actorInstigator) != None)
	{
		if (Inventory(actorInstigator).Owner != None)
			actorInstigator = Inventory(actorInstigator).Owner;
	}
	else if (DeusExDecoration(actorInstigator) != None)
		actorInstigator = player;

	instigator = Pawn(actorInstigator);
	if ((instigator == None) || (instigator == self))
		return;

	AgitationTimer  = AgitationSustainTime;
	if (AgitationLevel > 0)
	{
		bAlliancesChanged    = True;
		bNoNegativeAlliances = False;
		AgitateAlliance(instigator.Alliance, -AgitationLevel);
	}

}


// ----------------------------------------------------------------------
// UpdateAgitation()
// ----------------------------------------------------------------------

function UpdateAgitation(float deltaSeconds)
{
	local float mult;
	local float decrement;
	local int   i;

	if (AgitationCheckTimer > 0)
	{
		AgitationCheckTimer -= deltaSeconds;
		if (AgitationCheckTimer < 0)
			AgitationCheckTimer = 0;
	}

	decrement = 0;
	if (AgitationTimer > 0)
	{
		if (AgitationTimer < deltaSeconds)
		{
			mult = 1.0 - (AgitationTimer/deltaSeconds);
			AgitationTimer = 0;
			decrement = mult * (AgitationDecayRate*deltaSeconds);
		}
		else
			AgitationTimer -= deltaSeconds;
	}
	else
		decrement = AgitationDecayRate*deltaSeconds;

	if (bAlliancesChanged && (decrement > 0))
	{
		bAlliancesChanged = False;
		for (i=15; i>=0; i--)
		{
			if ((AlliancesEx[i].AllianceName != '') && (!AlliancesEx[i].bPermanent))
			{
				if (AlliancesEx[i].AgitationLevel > 0)
				{
					bAlliancesChanged = true;
					AlliancesEx[i].AgitationLevel -= decrement;
					if (AlliancesEx[i].AgitationLevel < 0)
						AlliancesEx[i].AgitationLevel = 0;
				}
			}
		}
	}
}


// ----------------------------------------------------------------------
// UpdateFear()
// ----------------------------------------------------------------------

function UpdateFear(float deltaSeconds)
{
	local float mult;
	local float decrement;
	local int   i;

	decrement = 0;
	if (FearTimer > 0)
	{
		if (FearTimer < deltaSeconds)
		{
			mult = 1.0 - (FearTimer/deltaSeconds);
			FearTimer = 0;
			decrement = mult * (FearDecayRate*deltaSeconds);
		}
		else
			FearTimer -= deltaSeconds;
	}
	else
		decrement = FearDecayRate*deltaSeconds;

	if ((decrement > 0) && (FearLevel > 0))
	{
		FearLevel -= decrement;
		if (FearLevel < 0)
			FearLevel = 0;
	}
}


// ----------------------------------------------------------------------
// IsFearful()
// ----------------------------------------------------------------------

function bool IsFearful()
{
	if (FearLevel >= 1.0)
		return true;
	else
		return false;
}


// ----------------------------------------------------------------------
// ShouldBeStartled()  [stub function, overridden by subclasses]
// ----------------------------------------------------------------------

function bool ShouldBeStartled(Pawn startler)
{
	return false;
}


// ----------------------------------------------------------------------
// ShouldPlayTurn()
// ----------------------------------------------------------------------

function bool ShouldPlayTurn(vector lookdir)
{
	local Rotator rot;

	rot = Rotator(lookdir);
	rot.Yaw = (rot.Yaw - Rotation.Yaw) & 65535;
	if (rot.Yaw > 32767)
		rot.Yaw = 65536 - rot.Yaw;  // negate
	if (rot.Yaw > 4096)
		return true;
	else
		return false;
}


// ----------------------------------------------------------------------
// ShouldPlayWalk()
// ----------------------------------------------------------------------

function bool ShouldPlayWalk(vector movedir)
{
	local vector diff;

	if (Physics == PHYS_Falling)
		return true;
	else if (Physics == PHYS_Walking)
	{
		diff = (movedir - Location) * vect(1,1,0);
		if (VSize(diff) < 16)
			return false;
		else
			return true;
	}
	else if (VSize(movedir-Location) < 16)
		return false;
	else
		return true;
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// ALLIANCE ROUTINES
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// SetAlliance()
// ----------------------------------------------------------------------

function SetAlliance(Name newAlliance)
{
	Alliance = newAlliance;
}


// ----------------------------------------------------------------------
// ChangeAlly()
// ----------------------------------------------------------------------

function ChangeAlly(Name newAlly, optional float allyLevel, optional bool bPermanent, optional bool bHonorPermanence)
{
	local int i;

	// Members of the same alliance will ALWAYS be friendly to each other
	if (newAlly == Alliance)
	{
		allyLevel  = 1;
		bPermanent = true;
	}

	if (bHonorPermanence)
	{
		for (i=0; i<16; i++)
			if (AlliancesEx[i].AllianceName == newAlly)
				if (AlliancesEx[i].bPermanent)
					break;
		if (i < 16)
			return;
	}

	if (allyLevel < -1)
		allyLevel = -1;
	if (allyLevel > 1)
		allyLevel = 1;

	for (i=0; i<16; i++)
		if ((AlliancesEx[i].AllianceName == newAlly) || (AlliancesEx[i].AllianceName == ''))
			break;

	if (i >= 16)
		for (i=15; i>0; i--)
			AlliancesEx[i] = AlliancesEx[i-1];

	AlliancesEx[i].AllianceName         = newAlly;
	AlliancesEx[i].AllianceLevel        = allyLevel;
	AlliancesEx[i].AgitationLevel       = 0;
	AlliancesEx[i].bPermanent           = bPermanent;

	bAlliancesChanged    = True;
	bNoNegativeAlliances = False;
}


// ----------------------------------------------------------------------
// AgitateAlliance()
// ----------------------------------------------------------------------

function AgitateAlliance(Name newEnemy, float agitation)
{
	local int   i;
	local float oldLevel;
	local float newLevel;

	if (newEnemy != '')
	{
		for (i=0; i<16; i++)
			if ((AlliancesEx[i].AllianceName == newEnemy) || (AlliancesEx[i].AllianceName == ''))
				break;

		if (i < 16)
		{
			if ((AlliancesEx[i].AllianceName == '') || !(AlliancesEx[i].bPermanent))
			{
				if (AlliancesEx[i].AllianceName == '')
					AlliancesEx[i].AllianceLevel = 0;
				oldLevel = AlliancesEx[i].AgitationLevel;
				newLevel = oldLevel + agitation;
				if (newLevel > 1.0)
					newLevel = 1.0;
				AlliancesEx[i].AllianceName   = newEnemy;
				AlliancesEx[i].AgitationLevel = newLevel;
				if ((newEnemy == 'Player') && (oldLevel < 1.0) && (newLevel >= 1.0))  // hack
					PlayerAgitationTimer = 2.0;
				bAlliancesChanged = True;
			}
		}
	}
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// ATTACKING FUNCTIONS
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// AISafeToShoot()
// ----------------------------------------------------------------------

function bool AISafeToShoot(out Actor hitActor, vector traceEnd, vector traceStart,
                            optional vector extent, optional bool bIgnoreLevel)
{
	local Actor            traceActor;
	local Vector           hitLocation;
	local Vector           hitNormal;
	local Pawn             tracePawn;
	local DeusExDecoration traceDecoration;
	local DeusExMover      traceMover;
	local bool             bSafe;

	// Future improvement:
	// Ideally, this should use the ammo type to determine how many shots
	// it will take to destroy an obstruction, and call it unsafe if it takes
	// more than x shots.  Also, if the ammo is explosive, and the
	// obstruction is too close, it should never be safe...

	bSafe    = true;
	hitActor = None;

	foreach TraceActors(Class'Actor', traceActor, hitLocation, hitNormal,
	                    traceEnd, traceStart, extent)
	{
		if (hitActor == None)
			hitActor = traceActor;
		if (traceActor == Level)
		{
			if (!bIgnoreLevel)
				bSafe = false;
			break;
		}
		tracePawn = Pawn(traceActor);
		if (tracePawn != None)
		{
			if (tracePawn != self)
			{
				if (GetPawnAllianceType(tracePawn) == ALLIANCE_Friendly)
					bSafe = false;
				break;
			}
		}
		traceDecoration = DeusExDecoration(traceActor);
		if (traceDecoration != None)
		{
			if (traceDecoration.bExplosive || traceDecoration.bInvincible)
			{
				bSafe = false;
				break;
			}
			if ((traceDecoration.HitPoints > 20) || (traceDecoration.minDamageThreshold > 4))  // hack
			{
				bSafe = false;
				break;
			}
		}
		traceMover = DeusExMover(traceActor);
		if (traceMover != None)
		{
			if (!traceMover.bBreakable)
			{
				bSafe = false;
				break;
			}
			else if ((traceMover.doorStrength > 0.2) || (traceMover.minDamageThreshold > 8))  // hack
			{
				bSafe = false;
				break;
			}
			else  // hack
				break;
		}
		if (Inventory(traceActor) != None)
		{
			bSafe = false;
			break;
		}
	}

	return (bSafe);
}


// ----------------------------------------------------------------------
// ComputeThrowAngles()
// ----------------------------------------------------------------------

function bool ComputeThrowAngles(vector traceEnd, vector traceStart,
                                 float speed,
                                 out Rotator angle1, out Rotator angle2)
{
	local float   deltaX, deltaY;
	local float   x, y;
	local float   tanAngle1, tanAngle2;
	local float   A, B, C;
	local float   m, n;
	local float   sqrtTerm;
	local float   gravity;
	local float   traceYaw;
	local bool    bValid;

	bValid = false;

	// Reduce our problem to two dimensions
	deltaX = traceEnd.X - traceStart.X;
	deltaY = traceEnd.Y - traceStart.Y;
	x = sqrt(deltaX*deltaX + deltaY*deltaY);
	y = traceEnd.Z - traceStart.Z;

	gravity = -Region.Zone.ZoneGravity.Z;
	if ((x > 0) && (gravity > 0))
	{
		A = -gravity*x*x;
		B = 2*speed*speed*x;
		C = -gravity*x*x - 2*y*speed*speed;

		sqrtTerm = B*B - 4*A*C;
		if (sqrtTerm >= 0)
		{
			m = -B/(2*A);
			n = sqrt(sqrtTerm)/(2*A);

			tanAngle1 = atan(m+n);
			tanAngle2 = atan(m-n);

			angle1 = Rotator(traceEnd - traceStart);
			angle2 = angle1;
			angle1.Pitch = tanAngle1*32768/Pi;
			angle2.Pitch = tanAngle2*32768/Pi;

			bValid = true;
		}
	}

	return bValid;
}


// ----------------------------------------------------------------------
// AISafeToThrow()
// ----------------------------------------------------------------------

function bool AISafeToThrow(vector traceEnd, vector traceStart,
                            float throwAccuracy,
                            optional vector extent)
{
	local float                   time1, time2, tempTime;
	local vector                  pos1,  pos2,  tempPos;
	local rotator                 rot1,  rot2,  tempRot;
	local rotator                 bestAngle;
	local bool                    bSafe;
	local DeusExWeapon            dxWeapon;
	local Class<ThrownProjectile> throwClass;

	// Someday, we should check for nearby friendlies within the blast radius
	// before throwing...

	// Sanity checks
	throwClass = None;
	dxWeapon = DeusExWeapon(Weapon);
	if (dxWeapon != None)
		throwClass = Class<ThrownProjectile>(dxWeapon.ProjectileClass);
	if (throwClass == None)
		return false;

	if (extent == vect(0,0,0))
	{
		extent = vect(1,1,0) * throwClass.Default.CollisionRadius;
		extent.Z = throwClass.Default.CollisionHeight;
	}

	if (throwAccuracy < 0.01)
		throwAccuracy = 0.01;

	bSafe = false;
	if (ComputeThrowAngles(traceEnd, traceStart, dxWeapon.ProjectileSpeed, rot1, rot2))
	{
		time1 = ParabolicTrace(pos1, Vector(rot1)*dxWeapon.ProjectileSpeed, traceStart,
		                       true, extent, 5.0,
		                       throwClass.Default.Elasticity, throwClass.Default.bBounce,
		                       60, throwAccuracy);
		time2 = ParabolicTrace(pos2, Vector(rot2)*dxWeapon.ProjectileSpeed, traceStart,
		                       true, extent, 5.0,
		                       throwClass.Default.Elasticity, throwClass.Default.bBounce,
		                       60, throwAccuracy);
		if ((time1 > 0) || (time2 > 0))
		{
			if ((time1 > time2) && (time2 > 0))
			{
				tempTime = time1;
				time1    = time2;
				time2    = tempTime;
				tempPos  = pos1;
				pos1     = pos2;
				pos2     = tempPos;
				tempRot  = rot1;
				rot1     = rot2;
				rot2     = tempRot;
			}
			if (VSize(pos1-traceEnd) <= throwClass.Default.blastRadius)
			{
				if (FastTrace(traceEnd, pos1))
				{
					if ((VSize(pos1-Location) > throwClass.Default.blastRadius*0.5) ||
					    !FastTrace(Location, pos1))
					{
						bestAngle = rot1;
						bSafe     = true;
					}
				}
			}
		}
		if (!bSafe && (time2 > 0))
		{
			if (VSize(pos2-traceEnd) <= throwClass.Default.blastRadius)
			{
				if (FastTrace(traceEnd, pos2))
				{
					if ((VSize(pos2-Location) > throwClass.Default.blastRadius*0.5) ||
					    !FastTrace(Location, pos2))
					{
						bestAngle = rot2;
						bSafe     = true;
					}
				}
			}
		}

	}

	if (bSafe)
		ViewRotation = bestAngle;

	return (bSafe);

}


// ----------------------------------------------------------------------
// AICanShoot()
// ----------------------------------------------------------------------

function bool AICanShoot(pawn target, bool bLeadTarget, bool bCheckReadiness,
                         optional float throwAccuracy, optional bool bDiscountMinRange)
{
	local DeusExWeapon dxWeapon;
	local Vector X, Y, Z;
	local Vector projStart, projEnd;
	local float  tempMinRange, tempMaxRange;
	local float  temp;
	local float  dist;
	local float  extraDist;
	local actor  hitActor;
	local Vector hitLocation, hitNormal;
	local Vector extent;
	local bool   bIsThrown;
	local float  elevation;
	local bool   bSafe;

	if (target == None)
		return false;
	if (target.bIgnore)
		return false;

	dxWeapon = DeusExWeapon(Weapon);
	if (dxWeapon == None)
		return false;
	if (bCheckReadiness && !dxWeapon.bReadyToFire)
		return false;

	if (dxWeapon.ReloadCount > 0)
	{
		if (dxWeapon.AmmoType == None)
			return false;
		if (dxWeapon.AmmoType.AmmoAmount <= 0)
			return false;
	}
	if (FireElevation > 0)
	{
		elevation = FireElevation + (CollisionHeight+target.CollisionHeight);
		if (elevation < 10)
			elevation = 10;
		if (Abs(Location.Z-target.Location.Z) > elevation)
			return false;
	}
	bIsThrown = IsThrownWeapon(dxWeapon);

	extraDist = target.CollisionRadius;
	//extraDist = 0;

	GetPawnWeaponRanges(self, tempMinRange, tempMaxRange, temp);

	if (bDiscountMinRange)
		tempMinRange = 0;

	if (tempMinRange >= tempMaxRange)
		return false;

	ViewRotation = Rotation;
	GetAxes(ViewRotation, X, Y, Z);
	projStart = dxWeapon.ComputeProjectileStart(X, Y, Z);
	if (bLeadTarget && !dxWeapon.bInstantHit && (dxWeapon.ProjectileSpeed > 0))
	{
		if (bIsThrown)
		{
			// compute target's position 1.5 seconds in the future
			projEnd = target.Location + (target.Velocity*1.5);
		}
		else
		{
			// projEnd = target.Location + (target.Velocity*dist/dxWeapon.ProjectileSpeed);
			if (!ComputeTargetLead(target, projStart, dxWeapon.ProjectileSpeed,
			                       5.0, projEnd))
				return false;
		}
	}
	else
		projEnd = target.Location;

	if (bIsThrown)
		projEnd += vect(0,0,-1)*(target.CollisionHeight-5);

	dist = VSize(projEnd - Location);
	if (dist < 0)
		dist = 0;

	if ((dist < tempMinRange) || (dist-extraDist > tempMaxRange))
		return false;

	if (!bIsThrown)
	{
		bSafe = FastTrace(target.Location, projStart);
		if (!bSafe && target.bIsPlayer)  // players only... hack
		{
			projEnd += vect(0,0,1)*target.BaseEyeHeight;
			bSafe = FastTrace(target.Location + vect(0,0,1)*target.BaseEyeHeight, projStart);
		}
		if (!bSafe)
			return false;
	}

	if (dxWeapon.bInstantHit)
		return (AISafeToShoot(hitActor, projEnd, projStart, , true));
	else
	{
		extent.X = dxWeapon.ProjectileClass.default.CollisionRadius;
		extent.Y = dxWeapon.ProjectileClass.default.CollisionRadius;
		extent.Z = dxWeapon.ProjectileClass.default.CollisionHeight;
		if (bIsThrown && (throwAccuracy > 0))
			return (AISafeToThrow(projEnd, projStart, throwAccuracy,
			                      extent));
		else
			return (AISafeToShoot(hitActor, projEnd, projStart, extent*3));
	}
}


// ----------------------------------------------------------------------
// ComputeTargetLead()
// ----------------------------------------------------------------------

function bool ComputeTargetLead(pawn target, vector projectileStart,
                                float projectileSpeed,
                                float maxTime,
                                out Vector hitPos)
{
	local vector targetLoc;
	local vector targetVel;
	local float  termA, termB, termC;
	local float  temp;
	local float  base, range;
	local float  time1, time2;
	local bool   bSuccess;

	bSuccess = true;

	targetLoc = target.Location - projectileStart;
	targetVel = target.Velocity;
	if (target.Physics == PHYS_Falling)
		targetVel.Z = 0;

	// Given a target position and velocity, and a projectile speed,
	// compute the position at which a projectile will hit the
	// target if the target continues at its current velocity

	// (Warning: messy computations follow.  I can't believe I remembered
	// enough algebra to figure this out on my own... :)

	termA = targetVel.X*targetVel.X +
	        targetVel.Y*targetVel.Y +
	        targetVel.Z*targetVel.Z -
	        projectileSpeed*projectileSpeed;
	termB = 2*targetLoc.X*targetVel.X +
	        2*targetLoc.Y*targetVel.Y +
	        2*targetLoc.Z*targetVel.Z;
	termC = targetLoc.X*targetLoc.X +
	        targetLoc.Y*targetLoc.Y +
	        targetLoc.Z*targetLoc.Z;

	if ((termA < 0.000001) && (termA > -0.000001))  // avoid divide-by-zero errors...
		termA = 0.000001;  // fudge a little when velocities are equal
	temp = termB*termB - 4*termA*termC;
	if (temp < 0)
		bSuccess = false;

	if (bSuccess)
	{
		base = -termB/(2*termA);
		range = sqrt(temp)/(2*termA);
		time1 = base+range;
		time2 = base-range;
		if ((time1 > time2) || (time1 < 0))  // best time first
			time1 = time2;
		if ((time1 < 0) || (time1 >= maxTime))
			bSuccess = false;
	}

	if (bSuccess)
		hitPos = target.Location + target.Velocity*time1;

	return (bSuccess);

}


// ----------------------------------------------------------------------
// GetPawnWeaponRanges()
// ----------------------------------------------------------------------

function GetPawnWeaponRanges(Pawn other, out float minRange,
                             out float maxAccurateRange, out float maxRange)
{
	local DeusExWeapon            pawnWeapon;
	local Class<DeusExProjectile> projectileClass;

	pawnWeapon = DeusExWeapon(other.Weapon);
	if (pawnWeapon != None)
	{
		pawnWeapon.GetWeaponRanges(minRange, maxAccurateRange, maxRange);
		if (IsThrownWeapon(pawnWeapon))  // hack
			minRange = 0;
	}
	else
	{
		minRange         = 0;
		maxAccurateRange = other.CollisionRadius;
		maxRange         = maxAccurateRange;
	}

	if (maxAccurateRange > maxRange)
		maxAccurateRange = maxRange;
	if (minRange > maxRange)
		minRange = maxRange;

}


// ----------------------------------------------------------------------
// GetWeaponBestRange()
// ----------------------------------------------------------------------

function GetWeaponBestRange(DeusExWeapon dxWeapon, out float bestRangeMin,
                            out float bestRangeMax)
{
	local float temp;
	local float minRange,   maxRange;
	local float AIMinRange, AIMaxRange;

	if (dxWeapon != None)
	{
		dxWeapon.GetWeaponRanges(minRange, maxRange, temp);
		if (IsThrownWeapon(dxWeapon))  // hack
			minRange = 0;
		AIMinRange = dxWeapon.AIMinRange;
		AIMaxRange = dxWeapon.AIMaxRange;

		if ((AIMinRange > 0) && (AIMinRange >= minRange) && (AIMinRange <= maxRange))
			bestRangeMin = AIMinRange;
		else
			bestRangeMin = minRange;
		if ((AIMaxRange > 0) && (AIMaxRange >= minRange) && (AIMaxRange <= maxRange))
			bestRangeMax = AIMaxRange;
		else
			bestRangeMax = maxRange;

		if (bestRangeMin > bestRangeMax)
			bestRangeMin = bestRangeMax;
	}
	else
	{
		bestRangeMin = 0;
		bestRangeMax = 0;
	}
}


// ----------------------------------------------------------------------
// ReadyForNewEnemy()
// ----------------------------------------------------------------------

function bool ReadyForNewEnemy()
{
	if ((Enemy == None) || (EnemyTimer > 5.0))
		return True;
	else
		return False;
}


// ----------------------------------------------------------------------
// CheckEnemyParams()  [internal use only]
// ----------------------------------------------------------------------

function CheckEnemyParams(Pawn checkPawn,
                          out Pawn bestPawn, out int bestThreatLevel, out float bestDist)
{
	local ScriptedPawn sPawn;
	local bool         bReplace;
	local float        dist;
	local int          threatLevel;
	local bool         bValid;

	bValid = IsValidEnemy(checkPawn);
	if (bValid && (Enemy != checkPawn))
	{
		// Honor cloaking, radar transparency, and other augs if this guy isn't our current enemy
		if (ComputeActorVisibility(checkPawn) < 0.1)
			bValid = false;
	}

	if (bValid)
	{
		sPawn = ScriptedPawn(checkPawn);

		dist = VSize(checkPawn.Location - Location);
		if (checkPawn.IsA('Robot'))
			dist *= 0.5;  // arbitrary
		if (Enemy == checkPawn)
			dist *= 0.75;  // arbitrary

		if (sPawn != None)
		{
			if (sPawn.bAttacking)
			{
				if (sPawn.Enemy == self)
					threatLevel = 2;
				else
					threatLevel = 1;
			}
			else if (sPawn.GetStateName() == 'Alerting')
				threatLevel = 3;
			else if ((sPawn.GetStateName() == 'Fleeing') || (sPawn.GetStateName() == 'Burning'))
				threatLevel = 0;
			else if (sPawn.Weapon != None)
				threatLevel = 1;
			else
				threatLevel = 0;
		}
		else  // player
		{
			if (checkPawn.Weapon != None)
				threatLevel = 2;
			else
				threatLevel = 1;
		}

		bReplace = false;
		if (bestPawn == None)
			bReplace = true;
		else if (bestThreatLevel < threatLevel)
			bReplace = true;
		else if (bestDist > dist)
			bReplace = true;

		if (bReplace)
		{
			if ((Enemy == checkPawn) || (AICanSee(checkPawn, , false, false, true, true) > 0))
			{
				bestPawn        = checkPawn;
				bestThreatLevel = threatLevel;
				bestDist        = dist;
			}
		}
	}

}


// ----------------------------------------------------------------------
// FindBestEnemy()
// ----------------------------------------------------------------------

function FindBestEnemy(bool bIgnoreCurrentEnemy)
{
	local Pawn  nextPawn;
	local Pawn  bestPawn;
	local float bestDist;
	local int   bestThreatLevel;
	local float newSeenTime;

	bestPawn        = None;
	bestDist        = 0;
	bestThreatLevel = 0;

	if (!bIgnoreCurrentEnemy && (Enemy != None))
		CheckEnemyParams(Enemy, bestPawn, bestThreatLevel, bestDist);
	foreach RadiusActors(Class'Pawn', nextPawn, 2000)  // arbitrary
		if (enemy != nextPawn)
			CheckEnemyParams(nextPawn, bestPawn, bestThreatLevel, bestDist);

	if (bestPawn != Enemy)
		newSeenTime = 0;
	else
		newSeenTime = EnemyLastSeen;

	SetEnemy(bestPawn, newSeenTime, true);

	EnemyTimer = 0;
}


// ----------------------------------------------------------------------
// ShouldStrafe()
// ----------------------------------------------------------------------

function bool ShouldStrafe()
{
	// This may be overridden from subclasses
	//return (AICanSee(enemy, 1.0, false, true, true, true) > 0);
	return (AICanShoot(enemy, false, false, 0.025, true));
}


// ----------------------------------------------------------------------
// ShouldFlee()
// ----------------------------------------------------------------------

function bool ShouldFlee()
{
	// This may be overridden from subclasses
	if (MinHealth > 0)
	{
		if (Health <= MinHealth)
			return true;
		else if (HealthArmLeft <= 0)
			return true;
		else if (HealthArmRight <= 0)
			return true;
		else if (HealthLegLeft <= 0)
			return true;
		else if (HealthLegRight <= 0)
			return true;
		else
			return false;
	}
	else
		return false;
}


// ----------------------------------------------------------------------
// ShouldDropWeapon()
// ----------------------------------------------------------------------

function bool ShouldDropWeapon()
{
	if (((HealthArmLeft <= 0) || (HealthArmRight <= 0)) && (Health > 0))
		return true;
	else
		return false;
}


// ----------------------------------------------------------------------
// TryLocation()
// ----------------------------------------------------------------------

function bool TryLocation(out vector position, optional float minDist, optional bool bTraceActors,
                          optional NearbyProjectileList projList)
{
	local float   magnitude;
	local vector  normalPos;
	local Rotator rot;
	local float   dist;
	local bool    bSuccess;

	normalPos = position-Location;
	magnitude = VSize(normalPos);
	if (minDist > magnitude)
		minDist = magnitude;
	rot = Rotator(position-Location);
	bSuccess = AIDirectionReachable(Location, rot.Yaw, rot.Pitch, minDist, magnitude, position);

	if (bSuccess)
	{
		if (bDefendHome && !IsNearHome(position))
			bSuccess = false;
		else if (bAvoidHarm && IsLocationDangerous(projList, position))
			bSuccess = false;
	}

	return (bSuccess);
}


// ----------------------------------------------------------------------
// ComputeBestFiringPosition()
// ----------------------------------------------------------------------

function EDestinationType ComputeBestFiringPosition(out vector newPosition)
{
	local float            selfMinRange, selfMaxRange;
	local float            enemyMinRange, enemyMaxRange;
	local float            temp;
	local float            dist;
	local float            innerRange[2], outerRange[2];
	local Rotator          relativeRotation;
	local float            hAngle, vAngle;
	local int              acrossDist;
	local float            awayDist;
	local float            extraDist;
	local float            fudgeMargin;
	local int              angle;
	local float            maxDist;
	local float            distDelta;
	local bool             bInnerValid, bOuterValid;
	local vector           tryVector;
	local EDestinationType destType;
	local float            moveMult;
	local float            reloadMult;
	local float            minArea;
	local float            minDist;
	local float            range;
	local float            margin;

	local NearbyProjectileList projList;
	local vector               projVector;
	local bool                 bUseProjVector;

	local rotator              sprintRot;
	local vector               sprintVect;
	local bool                 bUseSprint;

	destType = DEST_Failure;

	extraDist   = enemy.CollisionRadius*0.5;
	fudgeMargin = 100;
	minArea     = 35;

	GetPawnWeaponRanges(self, selfMinRange, selfMaxRange, temp);
	GetPawnWeaponRanges(enemy, enemyMinRange, temp, enemyMaxRange);

	if (selfMaxRange > 1200)
		selfMaxRange = 1200;
	if (enemyMaxRange > 1200)
		enemyMaxRange = 1200;

	// hack, to prevent non-strafing NPCs from trying to back up
	if (!bCanStrafe)
		selfMinRange  = 0;

	minDist = enemy.CollisionRadius + CollisionRadius - (extraDist+1);
	if (selfMinRange < minDist)
		selfMinRange = minDist;
	if (selfMinRange < MinRange)
		selfMinRange = MinRange;
	if (selfMaxRange > MaxRange)
		selfMaxRange = MaxRange;

	dist = VSize(enemy.Location-Location);

	innerRange[0] = selfMinRange;
	innerRange[1] = selfMaxRange;
	outerRange[0] = selfMinRange;
	outerRange[1] = selfMaxRange;

	// hack, to prevent non-strafing NPCs from trying to back up

	if (selfMaxRange > enemyMinRange)
		innerRange[1] = enemyMinRange;
	if ((selfMinRange < enemyMaxRange) && bCanStrafe)  // hack, to prevent non-strafing NPCs from trying to back up
		outerRange[0] = enemyMaxRange;

	range = outerRange[1]-outerRange[0];
	if (range < minArea)
	{
		outerRange[0] = 0;
		outerRange[1] = 0;
	}
	range = innerRange[1]-innerRange[0];
	if (range < minArea)
	{
		innerRange[0] = outerRange[0];
		innerRange[1] = outerRange[1];
		outerRange[0] = 0;
		outerRange[1] = 0;
	}

	// If the enemy can reach us through our entire weapon range, just use the range
	if ((innerRange[0] >= innerRange[1]) && (outerRange[0] >= outerRange[1]))
	{
		innerRange[0] = selfMinRange;
		innerRange[1] = selfMaxRange;
	}

	innerRange[0] += extraDist;
	innerRange[1] += extraDist;
	outerRange[0] += extraDist;
	outerRange[1] += extraDist;

	if (innerRange[0] >= innerRange[1])
		bInnerValid = false;
	else
		bInnerValid = true;
	if (outerRange[0] >= outerRange[1])
		bOuterValid = false;
	else
		bOuterValid = true;

	if (!bInnerValid)
	{
		// ugly
		newPosition = Location;
//		return DEST_SameLocation;
		return destType;
	}

	relativeRotation = Rotator(Location - enemy.Location);

	hAngle = (relativeRotation.Yaw - enemy.Rotation.Yaw) & 65535;
	if (hAngle > 32767)
		hAngle -= 65536;
	// ignore vertical angle for now

	awayDist   = dist;
	acrossDist = 0;
	maxDist    = GroundSpeed*0.6;  // distance covered in 6/10 second

	if (bInnerValid)
	{
		margin = (innerRange[1]-innerRange[0]) * 0.5;
		if (margin > fudgeMargin)
			margin = fudgeMargin;
		if (awayDist < innerRange[0])
			awayDist = innerRange[0]+margin;
		else if (awayDist > innerRange[1])
			awayDist = innerRange[1]-margin;
	}
	if (bOuterValid)
	{
		margin = (outerRange[1]-outerRange[0]) * 0.5;
		if (margin > fudgeMargin)
			margin = fudgeMargin;
		if (awayDist > outerRange[1])
			awayDist = outerRange[1]-margin;
	}

	if (awayDist > dist+maxDist)
		awayDist = dist+maxDist;
	if (awayDist < dist-maxDist)
		awayDist = dist-maxDist;

	// Used to determine whether NPCs should sprint/avoid aim
	moveMult = 1.0;
	if ((dist <= 180) && enemy.bIsPlayer && (enemy.Weapon != None) && (enemyMaxRange < 180))
		moveMult = CloseCombatMult;

	if (bAvoidAim && !enemy.bIgnore && (FRand() <= AvoidAccuracy*moveMult))
	{
		if ((awayDist < enemyMaxRange+maxDist+50) && (awayDist < 800) && (Enemy.Weapon != None))
		{
			if (dist > 0)
				angle = int(atan(CollisionRadius*2.0/dist)*32768/Pi);
			else
				angle = 16384;

			if ((hAngle >= -angle) && (hAngle <= angle))
			{
				if (hAngle < 0)
					acrossDist = (-angle-hAngle)-128;
				else
					acrossDist = (angle-hAngle)+128;
				if (Rand(20) == 0)
					acrossDist = -acrossDist;
			}
		}
	}

// projList is implicitly initialized to null...

	bUseProjVector = false;
	if (bAvoidHarm && (FRand() <= HarmAccuracy))
	{
		if (GetProjectileList(projList, Location) > 0)
		{
			if (IsLocationDangerous(projList, Location))
			{
				projVector = ComputeAwayVector(projList);
				bUseProjVector = true;
			}
		}
	}

	reloadMult = 1.0;
	if (IsWeaponReloading() && Enemy.bIsPlayer)
		reloadMult = 0.5;

	bUseSprint = false;
	if (!bUseProjVector && bSprint && bCanStrafe && !enemy.bIgnore && (FRand() <= SprintRate*0.5*moveMult*reloadMult))
	{
		if (bOuterValid || (innerRange[1] > 100))  // sprint on long-range weapons only
		{
			sprintRot = Rotator(enemy.Location - Location);
			if (Rand(2) == 1)
				sprintRot.Yaw += 16384;
			else
				sprintRot.Yaw += 49152;
			sprintRot = RandomBiasedRotation(sprintRot.Yaw, 0.5, 0, 0);
			sprintRot.Pitch = 0;
			sprintVect = Vector(sprintRot)*GroundSpeed*(FRand()+0.5);
			bUseSprint = true;
		}
	}

	if ((acrossDist != 0) || (awayDist != dist) || bUseProjVector || bUseSprint)
	{
		if (Rand(40) != 0)
		{
			if ((destType == DEST_Failure) && bUseProjVector)
			{
				tryVector = projVector + Location;
				if (TryLocation(tryVector, CollisionRadius+16))
					destType = DEST_NewLocation;
			}
			if ((destType == DEST_Failure) && (acrossDist != 0) && (awayDist != dist))
			{
				tryVector = Vector(relativeRotation+(rot(0, 1, 0)*acrossDist))*awayDist + enemy.Location;
				if (TryLocation(tryVector, CollisionRadius+16, , projList))
					destType = DEST_NewLocation;
			}
			if ((destType == DEST_Failure) && (awayDist != dist))
			{
				tryVector = Vector(relativeRotation)*awayDist + enemy.Location;
				if (TryLocation(tryVector, CollisionRadius+16, , projList))
					destType = DEST_NewLocation;
			}
			if ((destType == DEST_Failure) && (acrossDist != 0))
			{
				tryVector = Vector(relativeRotation+(rot(0, 1, 0)*acrossDist))*dist + enemy.Location;
				if (TryLocation(tryVector, CollisionRadius+16, , projList))
					destType = DEST_NewLocation;
			}
			if ((destType == DEST_Failure) && bUseSprint)
			{
				tryVector = sprintVect + Location;
				if (TryLocation(tryVector, CollisionRadius+16))
					destType = DEST_NewLocation;
			}
		}
		if (destType == DEST_Failure)
		{
			if ((moveMult >= 0.5) || (FRand() <= moveMult))
			{
				if (AIPickRandomDestination(CollisionRadius+16, maxDist,
				                            relativeRotation.Yaw+32768, 0.6, -relativeRotation.Pitch, 0.6, 2,
				                            0.9, tryVector))
					if (!bDefendHome || IsNearHome(tryVector))
						if (!bAvoidHarm || !IsLocationDangerous(projList, tryVector))
							destType = DEST_NewLocation;
			}
			else
				destType = DEST_SameLocation;
		}
		if (destType != DEST_Failure)
			newPosition = tryVector;
	}
	else
		destType = DEST_SameLocation;

	return destType;
}


// ----------------------------------------------------------------------
// SetAttackAngle()
//
// Sets the angle from which an asynchronous attack will occur
// (hack needed for DeusExWeapon)
// ----------------------------------------------------------------------

function SetAttackAngle()
{
	local bool bCanShoot;

	bCanShoot = false;
	if (Enemy != None)
		if (AICanShoot(Enemy, true, false, 0.025))
			bCanShoot = true;

	if (!bCanShoot)
		ViewRotation = Rotation;
}


// ----------------------------------------------------------------------
// AdjustAim()
//
// Adjust the aim at target
// ----------------------------------------------------------------------

function rotator AdjustAim(float projSpeed, vector projStart, int aimerror, bool leadTarget, bool warnTarget)
{
	local rotator     FireRotation;
	local vector      FireSpot;
	local actor       HitActor;
	local vector      HitLocation, HitNormal;
	local vector      vectorArray[3];
	local vector      tempVector;
	local int         i;
	local int         swap;
	local Rotator     rot;
	local bool        bIsThrown;
	local DeusExMover dxMover;
	local actor       Target;  // evil fix -- STM

	bIsThrown = IsThrownWeapon(DeusExWeapon(Weapon));

// took this line out for evil fix...
//	if ( Target == None )

	Target = Enemy;
	if ( Target == None )
		return Rotation;
	if ( !Target.IsA('Pawn') )
		return rotator(Target.Location - Location);

	FireSpot = Target.Location;
	if (leadTarget && (projSpeed > 0))
	{
		if (bIsThrown)
		{
			// compute target's position 1.5 seconds in the future
			FireSpot = target.Location + (target.Velocity*1.5);
		}
		else
		{
			//FireSpot += (Target.Velocity * VSize(Target.Location - ProjStart)/projSpeed);
			ComputeTargetLead(Pawn(Target), ProjStart, projSpeed, 20.0, FireSpot);
		}
	}

	if (bIsThrown)
	{
		vectorArray[0] = FireSpot - vect(0,0,1)*(Target.CollisionHeight-5);  // floor
		vectorArray[1] = vectorArray[0] + Vector(rot(0,1,0)*Rand(65536))*CollisionRadius*1.2;
		vectorArray[2] = vectorArray[0] + Vector(rot(0,1,0)*Rand(65536))*CollisionRadius*1.2;

		for (i=0; i<3; i++)
		{
			if (AISafeToThrow(vectorArray[i], ProjStart, 0.025))
				break;
		}
		if (i < 3)
		{
			FireSpot = vectorArray[i];
			FireRotation = ViewRotation;
		}
		else
			FireRotation = Rotator(FireSpot - ProjStart);
	}
	else
	{
		dxMover = DeusExMover(Target.Base);
		if ((dxMover != None) && dxMover.bBreakable)
		{
			tempVector = Normal((Location-Target.Location)*vect(1,1,0))*(Target.CollisionRadius*1.01) -
			             vect(0,0,1)*(Target.CollisionHeight*1.01);
			vectorArray[0] = FireSpot + tempVector;
		}
		else if (bAimForHead)
			vectorArray[0] = FireSpot + vect(0,0,1)*(Target.CollisionHeight*0.85);    // head
		else
			vectorArray[0] = FireSpot + vect(0,0,1)*((FRand()*2-1)*Target.CollisionHeight);
		vectorArray[1] = FireSpot + vect(0,0,1)*((FRand()*2-1)*Target.CollisionHeight);
		vectorArray[2] = FireSpot + vect(0,0,1)*((FRand()*2-1)*Target.CollisionHeight);

		for (i=0; i<3; i++)
		{
			if (AISafeToShoot(HitActor, vectorArray[i], ProjStart))
				break;
		}
		if (i < 3)
			FireSpot = vectorArray[i];

		FireRotation = Rotator(FireSpot - ProjStart);
	}

	if (warnTarget && Pawn(Target) != None) 
		Pawn(Target).WarnTarget(self, projSpeed, vector(FireRotation)); 

	FireRotation.Yaw = FireRotation.Yaw & 65535;
	if ( (Abs(FireRotation.Yaw - (Rotation.Yaw & 65535)) > 8192)
		&& (Abs(FireRotation.Yaw - (Rotation.Yaw & 65535)) < 57343) )
	{
		if ( (FireRotation.Yaw > Rotation.Yaw + 32768) || 
			((FireRotation.Yaw < Rotation.Yaw) && (FireRotation.Yaw > Rotation.Yaw - 32768)) )
			FireRotation.Yaw = Rotation.Yaw - 8192;
		else
			FireRotation.Yaw = Rotation.Yaw + 8192;
	}
	viewRotation = FireRotation;			
	return FireRotation;
}


// ----------------------------------------------------------------------
// IsThrownWeapon()
// ----------------------------------------------------------------------

function bool IsThrownWeapon(DeusExWeapon testWeapon)
{
	local Class<ThrownProjectile> throwClass;
	local bool                    bIsThrown;

	bIsThrown = false;
	if (testWeapon != None)
	{
		if (!testWeapon.bInstantHit)
		{
			throwClass = class<ThrownProjectile>(testWeapon.ProjectileClass);
			if (throwClass != None)
				bIsThrown = true;
		}
	}

	return bIsThrown;

}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// CALLBACKS AND OVERRIDDEN FUNCTIONS
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	local float        dropPeriod;
	local float        adjustedRate;
	local DeusExPlayer player;
	local name         stateName;
	local vector       loc;
	local bool         bDoLowPriority;
	local bool         bCheckOther;
	local bool         bCheckPlayer;

	player = DeusExPlayer(GetPlayerPawn());

	bDoLowPriority = true;
	bCheckPlayer   = true;
	bCheckOther    = true;
	if (bTickVisibleOnly)
	{
		if (DistanceFromPlayer > 1200)
			bDoLowPriority = false;
		if (DistanceFromPlayer > 2500)
			bCheckPlayer = false;
		if ((DistanceFromPlayer > 600) && (LastRendered() >= 5.0))
			bCheckOther = false;
	}

/*
	if (bDisappear && (InStasis() || (LastRendered() > 5.0)))
	{
		Destroy();
		return;
	}

	if (PrePivotTime > 0)
	{
		if (deltaTime < PrePivotTime)
		{
			PrePivot = PrePivot + (DesiredPrePivot-PrePivot)*deltaTime/PrePivotTime;
			PrePivotTime -= deltaTime;
		}
		else
		{
			PrePivot = DesiredPrePivot;
			PrePivotTime = 0;
		}
	}

	if (bDoLowPriority)
		Super.Tick(deltaTime);

	UpdateAgitation(deltaTime);
	UpdateFear(deltaTime);

	AlarmTimer -= deltaTime;
	if (AlarmTimer < 0)
		AlarmTimer = 0;

	if (Weapon != None)
		WeaponTimer += deltaTime;
	else if (WeaponTimer != 0)
		WeaponTimer = 0;

	if ((ReloadTimer > 0) && (Weapon != None))
		ReloadTimer -= deltaTime;
	else
		ReloadTimer = 0;

	if (AvoidWallTimer > 0)
	{
		AvoidWallTimer -= deltaTime;
		if (AvoidWallTimer < 0)
			AvoidWallTimer = 0;
	}

	if (AvoidBumpTimer > 0)
	{
		AvoidBumpTimer -= deltaTime;
		if (AvoidBumpTimer < 0)
			AvoidBumpTimer = 0;
	}

	if (CloakEMPTimer > 0)
	{
		CloakEMPTimer -= deltaTime;
		if (CloakEMPTimer < 0)
			CloakEMPTimer = 0;
	}

	if (TakeHitTimer > 0)
	{
		TakeHitTimer -= deltaTime;
		if (TakeHitTimer < 0)
			TakeHitTimer = 0;
	}

	if (CarcassCheckTimer > 0)
	{
		CarcassCheckTimer -= deltaTime;
		if (CarcassCheckTimer < 0)
			CarcassCheckTimer = 0;
	}

	if (PotentialEnemyTimer > 0)
	{
		PotentialEnemyTimer -= deltaTime;
		if (PotentialEnemyTimer <= 0)
		{
			PotentialEnemyTimer    = 0;
			PotentialEnemyAlliance = '';
		}
	}

	if (BeamCheckTimer > 0)
	{
		BeamCheckTimer -= deltaTime;
		if (BeamCheckTimer < 0)
			BeamCheckTimer = 0;
	}

	if (FutzTimer > 0)
	{
		FutzTimer -= deltaTime;
		if (FutzTimer < 0)
			FutzTimer = 0;
	}

	if (PlayerAgitationTimer > 0)
	{
		PlayerAgitationTimer -= deltaTime;
		if (PlayerAgitationTimer < 0)
			PlayerAgitationTimer = 0;
	}

	if (DistressTimer >= 0)
	{
		DistressTimer += deltaTime;
		if (DistressTimer > FearSustainTime)
			DistressTimer = -1;
	}

	if (bHasCloak)
		EnableCloak(Health <= CloakThreshold);

	if (bAdvancedTactics)
	{
		if ((Acceleration == vect(0,0,0)) || (Physics != PHYS_Walking) ||
		    (TurnDirection == TURNING_None))
		{
			bAdvancedTactics = false;
			if (TurnDirection != TURNING_None)
				MoveTimer -= 4.0;
			ActorAvoiding    = None;
			NextDirection    = TURNING_None;
			TurnDirection    = TURNING_None;
			bClearedObstacle = true;
			ObstacleTimer    = 0;
		}
	}

	if (bOnFire)
	{
		burnTimer += deltaTime;
		if (burnTimer >= BurnPeriod)
			ExtinguishFire();
	}

	if (bDoLowPriority)
	{
		if ((bleedRate > 0) && bCanBleed)
		{
			adjustedRate = (1.0-FClamp(bleedRate, 0.0, 1.0))*1.0+0.1;  // max 10 drops per second
			dropPeriod = adjustedRate / FClamp(VSize(Velocity)/512.0, 0.05, 1.0);
			dropCounter += deltaTime;
			while (dropCounter >= dropPeriod)
			{
				SpurtBlood();
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
*/

	if (bStandInterpolation)
		UpdateStanding(deltaTime);

	// this is UGLY!
	if (bOnFire && (health > 0))
	{
		stateName = GetStateName();
		if ((stateName != 'Burning') && (stateName != 'TakingHit') && (stateName != 'RubbingEyes'))
			GotoState('Burning');
	}
	else
	{
		if (bDoLowPriority)
		{
			// Don't allow radius-based convos to interupt other conversations!
			if ((player != None) && (GetStateName() != 'Conversation') && (GetStateName() != 'FirstPersonConversation'))
				player.StartConversation(Self, IM_Radius);
		}

		if (CheckEnemyPresence(deltaTime, bCheckPlayer, bCheckOther))
			HandleEnemy();
		else
		{
			CheckBeamPresence(deltaTime);
			if (bDoLowPriority || LastRendered() < 5.0)
				CheckCarcassPresence(deltaTime);  // hacky -- may change state!
		}
	}

	// Randomly spawn an air bubble every 0.2 seconds if we're underwater
	if (HeadRegion.Zone.bWaterZone && bSpawnBubbles && bDoLowPriority)
	{
		swimBubbleTimer += deltaTime;
		if (swimBubbleTimer >= 0.2)
		{
			swimBubbleTimer = 0;
			if (FRand() < 0.4)
			{
				loc = Location + VRand() * 4;
				loc.Z += CollisionHeight * 0.9;
				Spawn(class'AirBubble', Self,, loc);
			}
		}
	}

	// Handle poison damage
	UpdatePoison(deltaTime);
}


// ----------------------------------------------------------------------
// SpurtBlood()
// ----------------------------------------------------------------------

function SpurtBlood()
{
	local vector bloodVector;

	bloodVector = vect(0,0,1)*CollisionHeight*0.5;  // so folks don't bleed from the crotch
	spawn(Class'BloodDrop',,,bloodVector+Location);
}


// ----------------------------------------------------------------------
// TakeDamage()
// ----------------------------------------------------------------------

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
{
	TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, true);
}


// ----------------------------------------------------------------------
// Timer()
// ----------------------------------------------------------------------

function Timer()
{
	UpdateFire();
}


// ----------------------------------------------------------------------
// ZoneChange()
// ----------------------------------------------------------------------

function ZoneChange(ZoneInfo newZone)
{
	local vector jumpDir;

	if (!bInWorld)
		return;

	if (newZone.bWaterZone)
	{
		EnableShadow(false);
		if (!bCanSwim)
			MoveTimer = -1.0;
		else if (Physics != PHYS_Swimming)
		{
			if (bOnFire)
				ExtinguishFire();

			PlaySwimming();
			setPhysics(PHYS_Swimming);
		}
		swimBubbleTimer = 0;
	}
	else if (Physics == PHYS_Swimming)
	{
		EnableShadow(true);
		if ( bCanFly )
			 SetPhysics(PHYS_Flying); 
		else
		{ 
			SetPhysics(PHYS_Falling);
			if ( bCanWalk && (Abs(Acceleration.X) + Abs(Acceleration.Y) > 0) && CheckWaterJump(jumpDir) )
				JumpOutOfWater(jumpDir);
		}
	}
}


// ----------------------------------------------------------------------
// BaseChange()
// ----------------------------------------------------------------------

singular function BaseChange()
{
	Super.BaseChange();

	if (bSitting && !IsSeatValid(SeatActor))
	{
		StandUp();
		if (GetStateName() == 'Sitting')
			GotoState('Sitting', 'Begin');
	}
}


// ----------------------------------------------------------------------
// PainTimer()
// ----------------------------------------------------------------------

event PainTimer()
{
	local float       depth;
	local PointRegion painRegion;

	if ((Health <= 0) || (Level.NetMode == NM_Client))
		return;

	painRegion = HeadRegion;
	if (!painRegion.Zone.bPainZone || (painRegion.Zone.DamageType == ReducedDamageType))
		painRegion = Region;
	if (!painRegion.Zone.bPainZone || (painRegion.Zone.DamageType == ReducedDamageType))
		painRegion = FootRegion;

	if (painRegion.Zone.bPainZone && (painRegion.Zone.DamageType != ReducedDamageType))
	{
		depth = 0;
		if (FootRegion.Zone.bPainZone)
			depth += 0.3;
		if (Region.Zone.bPainZone)
			depth += 0.3;
		if (HeadRegion.Zone.bPainZone)
			depth += 0.4;

		if (painRegion.Zone.DamagePerSec > 0)
			TakeDamage(int(float(painRegion.Zone.DamagePerSec) * depth), None, Location, vect(0,0,0), painRegion.Zone.DamageType);
		// took out healing for NPCs -- we don't use healing zones anyway
		/*
		else if ( Health < Default.Health )
			Health = Min(Default.Health, Health - depth * FootRegion.Zone.DamagePerSec);
		*/

		if (Health > 0)
			PainTime = 1.0;
	}
	else if (HeadRegion.Zone.bWaterZone && (UnderWaterTime > 0))
	{
		TakeDamage(5, None, Location, vect(0,0,0), 'Drowned');
		if (Health > 0)
			PainTime = 2.0;
	}
}

// ----------------------------------------------------------------------
// CheckWaterJump()
// ----------------------------------------------------------------------

function bool CheckWaterJump(out vector WallNormal)
{
	local actor HitActor;
	local vector HitLocation, HitNormal, checkpoint, start, checkNorm, Extent;

	if (CarriedDecoration != None)
		return false;
	checkpoint = vector(Rotation);
	checkpoint.Z = 0.0;
	checkNorm = Normal(checkpoint);
	checkPoint = Location + CollisionRadius * checkNorm;
	Extent = CollisionRadius * vect(1,1,0);
	Extent.Z = CollisionHeight;
	HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, false, Extent);
	if ( (HitActor != None) && (Pawn(HitActor) == None) )
	{
		WallNormal = -1 * HitNormal;
		start = Location;
		start.Z += 1.1 * MaxStepHeight + CollisionHeight;
		checkPoint = start + 2 * CollisionRadius * checkNorm;
		HitActor = Trace(HitLocation, HitNormal, checkpoint, start, true, Extent);
		if (HitActor == None)
			return true;
	}

	return false;
}


// ----------------------------------------------------------------------
// SetMovementPhysics()
// ----------------------------------------------------------------------

function SetMovementPhysics()
{
	// re-implement SetMovementPhysics() in subclass for flying and swimming creatures
	if (Physics == PHYS_Falling)
		return;

	if (Region.Zone.bWaterZone && bCanSwim)
		SetPhysics(PHYS_Swimming);
	else if (Default.Physics == PHYS_None)
		SetPhysics(PHYS_Walking);
	else
		SetPhysics(Default.Physics);
}


// ----------------------------------------------------------------------
// PreSetMovement()
// ----------------------------------------------------------------------

function PreSetMovement()
{
	// Copied from Pawn.uc and overridden so Pawn doesn't erase our walking/swimming/flying physics
	if (JumpZ > 0)
		bCanJump = true;
	// No, no, no!!!
	/*
	bCanWalk = true;
	bCanSwim = false;
	bCanFly = false;
	MinHitWall = -0.6;
	if (Intelligence > BRAINS_Reptile)
		bCanOpenDoors = true;
	if (Intelligence == BRAINS_Human)
		bCanDoSpecial = true;
	*/
}


// ----------------------------------------------------------------------
// ChangedWeapon()
// ----------------------------------------------------------------------

function ChangedWeapon()
{
	// do nothing
}


// ----------------------------------------------------------------------
// SwitchToBestWeapon()
// ----------------------------------------------------------------------

function bool SwitchToBestWeapon()
{
	local Inventory    inv;
	local DeusExWeapon curWeapon;
	local float        score;
	local DeusExWeapon dxWeapon;
	local DeusExWeapon bestWeapon;
	local float        bestScore;
	local int          fallbackLevel;
	local int          curFallbackLevel;
	local bool         bBlockSpecial;
	local bool         bValid;
	local bool         bWinner;
	local float        minRange, accRange;
	local float        range, centerRange;
	local float        cutoffRange;
	local float        enemyRange;
	local float        minEnemy, accEnemy, maxEnemy;
	local ScriptedPawn enemyPawn;
	local Robot        enemyRobot;
	local DeusExPlayer enemyPlayer;
	local float        enemyRadius;
	local bool         bEnemySet;
	local int          loopCount, i;  // hack - check for infinite inventory
	local Inventory    loopInv;       // hack - check for infinite inventory

	if (ShouldDropWeapon())
	{
		DropWeapon();
		return false;
	}

	bBlockSpecial = false;
	dxWeapon = DeusExWeapon(Weapon);
	if (dxWeapon != None)
	{
		if (dxWeapon.AITimeLimit > 0)
		{
			if (SpecialTimer <= 0)
			{
				bBlockSpecial = true;
				FireTimer = dxWeapon.AIFireDelay;
			}
		}
	}

	bestWeapon      = None;
	bestScore       = 0;
	fallbackLevel   = 0;
	inv             = Inventory;

	bEnemySet   = false;
	minEnemy    = 0;
	accEnemy    = 0;
	enemyRange  = 400;  // default
	enemyRadius = 0;
	enemyPawn   = None;
	enemyRobot  = None;
	if (Enemy != None)
	{
		bEnemySet   = true;
		enemyRange  = VSize(Enemy.Location - Location);
		enemyRadius = Enemy.CollisionRadius;
		if (DeusExWeapon(Enemy.Weapon) != None)
			DeusExWeapon(Enemy.Weapon).GetWeaponRanges(minEnemy, accEnemy, maxEnemy);
		enemyPawn   = ScriptedPawn(Enemy);
		enemyRobot  = Robot(Enemy);
		enemyPlayer = DeusExPlayer(Enemy);
	}

	loopCount = 0;
	while (inv != None)
	{
		// THIS IS A MAJOR HACK!!!
		loopCount++;
		if (loopCount == 9999)
		{
			log("********** RUNAWAY LOOP IN SWITCHTOBESTWEAPON ("$self$") **********");
			loopInv = Inventory;
			i = 0;
			while (loopInv != None)
			{
				i++;
				if (i > 300)
					break;
				log("   Inventory "$i$" - "$loopInv);
				loopInv = loopInv.Inventory;
			}
		}

		curWeapon = DeusExWeapon(inv);
		if (curWeapon != None)
		{
			bValid = true;
			if (curWeapon.ReloadCount > 0)
			{
				if (curWeapon.AmmoType == None)
					bValid = false;
				else if (curWeapon.AmmoType.AmmoAmount < 1)
					bValid = false;
			}

			// Ensure we can actually use this weapon here
			if (bValid)
			{
				// lifted from DeusExWeapon...
				if ((curWeapon.EnviroEffective == ENVEFF_Air) || (curWeapon.EnviroEffective == ENVEFF_Vacuum) ||
				    (curWeapon.EnviroEffective == ENVEFF_AirVacuum))
					if (curWeapon.Region.Zone.bWaterZone)
						bValid = false;
			}

			if (bValid)
			{
				GetWeaponBestRange(curWeapon, minRange, accRange);
				cutoffRange = minRange+(CollisionRadius+enemyRadius);
				range = (accRange - minRange) * 0.5;
				centerRange = minRange + range;
				if (range < 50)
					range = 50;
				if (enemyRange < centerRange)
					score = (centerRange - enemyRange)/range;
				else
					score = (enemyRange - centerRange)/range;
				if ((minRange >= minEnemy) && (accRange <= accEnemy))
					score += 0.5;  // arbitrary
				if ((cutoffRange >= enemyRange-CollisionRadius) && (cutoffRange >= 256)) // do not use long-range weapons on short-range targets
					score += 10000;

				curFallbackLevel = 3;
				if (curWeapon.bFallbackWeapon && !bUseFallbackWeapons)
					curFallbackLevel = 2;
				if (!bEnemySet && !curWeapon.bUseAsDrawnWeapon)
					curFallbackLevel = 1;
				if ((curWeapon.AIFireDelay > 0) && (FireTimer > 0))
					curFallbackLevel = 0;
				if (bBlockSpecial && (curWeapon.AITimeLimit > 0) && (SpecialTimer <= 0))
					curFallbackLevel = 0;

				// Adjust score based on opponent and damage type.
				// All damage types are listed here, even the ones that aren't used by weapons... :)
				// (hacky...)

				switch (curWeapon.WeaponDamageType())
				{
					case 'Exploded':
						// Massive explosions are always good
						score -= 0.2;
						break;

					case 'Stunned':
						if (enemyPawn != None)
						{
							if (enemyPawn.bStunned)
								score += 1000;
							else
								score -= 1.5;
						}
						if (enemyPlayer != None)
							score += 10;
						break;

					case 'TearGas':
						if (enemyPawn != None)
						{
							if (enemyPawn.bStunned)
								//score += 1000;
								bValid = false;
							else
								score -= 5.0;
						}
						if (enemyRobot != None)
							//score += 10000;
							bValid = false;
						break;

					case 'HalonGas':
						if (enemyPawn != None)
						{
							if (enemyPawn.bStunned)
								//score += 1000;
								bValid = false;
							else if (enemyPawn.bOnFire)
								//score += 10000;
								bValid = false;
							else
								score -= 3.0;
						}
						if (enemyRobot != None)
							//score += 10000;
							bValid = false;
						break;

					case 'PoisonGas':
					case 'Poison':
					case 'PoisonEffect':
					case 'Radiation':
						if (enemyRobot != None)
							//score += 10000;
							bValid = false;
						break;

					case 'Burned':
					case 'Flamed':
					case 'Shot':
						if (enemyRobot != None)
							score += 0.5;
						break;

					case 'Sabot':
						if (enemyRobot != None)
							score -= 0.5;
						break;

					case 'EMP':
					case 'NanoVirus':
						if (enemyRobot != None)
							score -= 5.0;
						else if (enemyPlayer != None)
							score += 5.0;
						else
							//score += 10000;
							bValid = false;
						break;

					case 'Drowned':
					default:
						break;
				}

				// Special case for current weapon
				if ((curWeapon == Weapon) && (WeaponTimer < 10.0))
				{
					// If we last changed weapons less than five seconds ago,
					// keep this weapon
					if (WeaponTimer < 5.0)
						score = -10;

					// If between five and ten seconds, use a sliding scale
					else
						score -= (10.0 - WeaponTimer)/5.0;
				}

				// Throw a little randomness into the computation...
				else
				{
					score += FRand()*0.1 - 0.05;
					if (score < 0)
						score = 0;
				}

				if (bValid)
				{
					// ugly
					if (bestWeapon == None)
						bWinner = true;
					else if (curFallbackLevel > fallbackLevel)
						bWinner = true;
					else if (curFallbackLevel < fallbackLevel)
						bWinner = false;
					else if (bestScore > score)
						bWinner = true;
					else
						bWinner = false;
					if (bWinner)
					{
						bestScore     = score;
						bestWeapon    = curWeapon;
						fallbackLevel = curFallbackLevel;
					}
				}
			}
		}
		inv = inv.Inventory;
	}

	// If we're changing weapons, reset the weapon timers
	if (Weapon != bestWeapon)
	{
		if (!bEnemySet)
			WeaponTimer = 10;  // hack
		else
			WeaponTimer = 0;
		if (bestWeapon != None)
			if (bestWeapon.AITimeLimit > 0)
				SpecialTimer = bestWeapon.AITimeLimit;
		ReloadTimer = 0;
	}

	SetWeapon(bestWeapon);

	return false;
}


// ----------------------------------------------------------------------
// LoopBaseConvoAnim()
// ----------------------------------------------------------------------

function LoopBaseConvoAnim()
{
	// Special case for sitting
	if (bSitting)
	{
		if (!IsAnimating())
			PlaySitting();
	}

	// Special case for dancing
	else if (bDancing)
	{
		if (!IsAnimating())
			PlayDancing();
	}

	// Otherwise, just do the usual shit
	else
		Super.LoopBaseConvoAnim();

}


// ----------------------------------------------------------------------
// BackOff()
// ----------------------------------------------------------------------

function BackOff()
{
	SetNextState(GetStateName(), 'ContinueFromDoor');  // MASSIVE hackage
	SetState('BackingOff');
}


// ----------------------------------------------------------------------
// CheckDestLoc()
// ----------------------------------------------------------------------

function CheckDestLoc(vector newDestLoc, optional bool bPathnode)
{
	if (VSize(newDestLoc-LastDestLoc) <= 16)  // too close
		DestAttempts++;
	else if (!IsPointInCylinder(self, newDestLoc))
		DestAttempts++;
	else if (bPathnode && (VSize(newDestLoc-LastDestPoint) <= 16))  // too close
		DestAttempts++;
	else
		DestAttempts = 0;
	LastDestLoc = newDestLoc;
	if (bPathnode && (DestAttempts == 0))
		LastDestPoint = newDestLoc;

	if (bEnableCheckDest && (DestAttempts >= 4))
		BackOff();
}


// ----------------------------------------------------------------------
// ResetDestLoc()
// ----------------------------------------------------------------------

function ResetDestLoc()
{
	DestAttempts  = 0;
	LastDestLoc   = vect(9999,9999,9999);  // hack
	LastDestPoint = LastDestLoc;
}


// ----------------------------------------------------------------------
// EnableCheckDestLoc()
// ----------------------------------------------------------------------

function EnableCheckDestLoc(bool bEnable)
{
//	if (bEnableCheckDest && !bEnable)
		ResetDestLoc();
	bEnableCheckDest = bEnable;
}


// ----------------------------------------------------------------------
// HandleTurn()
// ----------------------------------------------------------------------

function bool HandleTurn(actor Other)
{
	local bool             bHandle;
	local bool             bHackState;
	local DeusExDecoration dxDecoration;
	local ScriptedPawn     scrPawn;

	// THIS ENTIRE SECTION IS A MASSIVE HACK TO GET AROUND PATHFINDING PROBLEMS
	// WHEN AN OBSTACLE COMPLETELY BLOCKS AN NPC'S PATH...

	bHandle    = true;
	bHackState = false;
	if (bEnableCheckDest)
	{
		if (DestAttempts >= 2)
		{
			dxDecoration = DeusExDecoration(Other);
			scrPawn      = ScriptedPawn(Other);
			if (dxDecoration != None)
			{
				if (!dxDecoration.bInvincible && !dxDecoration.bExplosive)
				{
					dxDecoration.HitPoints = 0;
					dxDecoration.TakeDamage(1, self, dxDecoration.Location, vect(0,0,0), 'Kick');
					bHandle = false;
				}
				else if (DestAttempts >= 3)
				{
					bHackState = true;
					bHandle    = false;
				}
			}
			else if (scrPawn != None)
			{
				if (DestAttempts >= 3)
				{
					if (scrPawn.GetStateName() != 'BackingOff')
					{
						bHackState = true;
						bHandle    = false;
					}
				}
			}
		}

		if (bHackState)
			BackOff();
	}

	return (bHandle);
}


// ----------------------------------------------------------------------
// Bump()
// ----------------------------------------------------------------------

function Bump(actor Other)
{
	local Rotator      rot1, rot2;
	local int          yaw;
	local ScriptedPawn avoidPawn;
	local DeusExPlayer dxPlayer;
	local bool         bTurn;

	// Handle futzing and projectiles
	if (Other.Physics == PHYS_Falling)
	{
		if (DeusExProjectile(Other) != None)
			ReactToProjectiles(Other);
		else
		{
			dxPlayer = DeusExPlayer(Other.Instigator);
			if ((Other != dxPlayer) && (dxPlayer != None))
				ReactToFutz();
		}
	}
	
	// Have we walked into another (non-level) actor?
	bTurn = false;
	if ((Physics == PHYS_Walking) && (Acceleration != vect(0,0,0)) && bWalkAround && (Other != Level) && !Other.IsA('Mover'))
		if ((TurnDirection == TURNING_None) || (AvoidBumpTimer <= 0))
			if (HandleTurn(Other))
				bTurn = true;

	// Turn away from the actor
	if (bTurn)
	{
		// If we're not already turning, start
		if (TurnDirection == TURNING_None)
		{
			// Give ourselves a little extra time
			MoveTimer += 4.0;

			rot1 = Rotator(Other.Location-Location);  // direction of object being bumped
			rot2 = Rotator(Acceleration);  // direction we wish to go
			yaw  = (rot2.Yaw - rot1.Yaw) & 65535;
			if (yaw > 32767)
				yaw -= 65536;

			// Depending on the angle we bump the actor, turn left or right
			if (yaw < 0)
			{
				TurnDirection = TURNING_Left;
				NextDirection = TURNING_Right;
			}
			else
			{
				TurnDirection = TURNING_Right;
				NextDirection = TURNING_Left;
			}
			bClearedObstacle = false;

			// Enable AlterDestination()
			bAdvancedTactics = true;
		}

		// Ignore multiple bumps in a row
		// BOOGER! Ignore same bump actor?
		if (AvoidBumpTimer <= 0)
		{
			AvoidBumpTimer   = 0.2;
			ActorAvoiding    = Other;
			bClearedObstacle = false;

			avoidPawn = ScriptedPawn(ActorAvoiding);

			// Avoid pairing off
			if (avoidPawn != None)
			{
				if ((avoidPawn.Acceleration != vect(0,0,0)) && (avoidPawn.Physics == PHYS_Walking) &&
				    (avoidPawn.TurnDirection != TURNING_None) && (avoidPawn.ActorAvoiding == self))
				{
					if ((avoidPawn.TurnDirection == TURNING_Left) && (TurnDirection == TURNING_Right))
					{
						TurnDirection = TURNING_Left;
						if (NextDirection != TURNING_None)
							NextDirection = TURNING_Right;
					}
					else if ((avoidPawn.TurnDirection == TURNING_Right) && (TurnDirection == TURNING_Left))
					{
						TurnDirection = TURNING_Right;
						if (NextDirection != TURNING_None)
							NextDirection = TURNING_Left;
					}
				}
			}
		}
	}
}


// ----------------------------------------------------------------------
// HitWall()
// ----------------------------------------------------------------------

function HitWall(vector HitLocation, Actor hitActor)
{
	local ScriptedPawn avoidPawn;

	// We only care about HitWall as it pertains to level geometry
	if (hitActor != Level)
		return;

	// Are we walking?
	if ((Physics == PHYS_Walking) && (Acceleration != vect(0,0,0)) && bWalkAround &&
	    (AvoidWallTimer <= 0))
	{
		// Are we turning?
		if (TurnDirection != TURNING_None)
		{
			AvoidWallTimer = 1.0;

			// About face
			TurnDirection    = NextDirection;
			NextDirection    = TURNING_None;
			bClearedObstacle = false;

			// Avoid pairing off
			avoidPawn = ScriptedPawn(ActorAvoiding);
			if (avoidPawn != None)
			{
				if ((avoidPawn.Acceleration != vect(0,0,0)) && (avoidPawn.Physics == PHYS_Walking) &&
				    (avoidPawn.TurnDirection != TURNING_None) && (avoidPawn.ActorAvoiding == self))
				{
					if ((avoidPawn.TurnDirection == TURNING_Left) && (TurnDirection == TURNING_Right))
						TurnDirection = TURNING_None;
					else if ((avoidPawn.TurnDirection == TURNING_Right) && (TurnDirection == TURNING_Left))
						TurnDirection = TURNING_None;
				}
			}

			// Stopped turning?  Shut down
			if (TurnDirection == TURNING_None)
			{
				ActorAvoiding = None;
				bAdvancedTactics = false;
				MoveTimer -= 4.0;
				ObstacleTimer = 0;
			}
		}
	}
}


// ----------------------------------------------------------------------
// AlterDestination()
// ----------------------------------------------------------------------

function AlterDestination()
{
	local Rotator  dir;
	local int      avoidYaw;
	local int      destYaw;
	local int      moveYaw;
	local int      angle;
	local bool     bPointInCylinder;
	local float    dist1, dist2;
	local bool     bAround;
	local vector   tempVect;
	local ETurning oldTurnDir;

	oldTurnDir = TurnDirection;

	// Sanity check -- are we done walking around the actor?
	if (TurnDirection != TURNING_None)
	{
		if (!bWalkAround)
			TurnDirection = TURNING_None;
		else if (bClearedObstacle)
			TurnDirection = TURNING_None;
		else if (ActorAvoiding == None)
			TurnDirection = TURNING_None;
		else if (ActorAvoiding.bDeleteMe)
			TurnDirection = TURNING_None;
		else if (!IsPointInCylinder(ActorAvoiding, Location,
		                            CollisionRadius*2, CollisionHeight*2))
			TurnDirection = TURNING_None;
	}

	// Are we still turning?
	if (TurnDirection != TURNING_None)
	{
		bAround = false;

		// Is our destination point inside the actor we're walking around?
		bPointInCylinder = IsPointInCylinder(ActorAvoiding, Destination,
		                                     CollisionRadius-8, CollisionHeight-8);
		if (bPointInCylinder)
		{
			dist1 = VSize((Location - ActorAvoiding.Location)*vect(1,1,0));
			dist2 = VSize((Location - Destination)*vect(1,1,0));

			// Are we on the right side of the actor?
			if (dist1 > dist2)
			{
				// Just make a beeline, if possible
				tempVect = Destination - ActorAvoiding.Location;
				tempVect.Z = 0;
				tempVect = Normal(tempVect) * (ActorAvoiding.CollisionRadius + CollisionRadius);
				if (tempVect == vect(0,0,0))
					Destination = Location;
				else
				{
					tempVect += ActorAvoiding.Location;
					tempVect.Z = Destination.Z;
					Destination = tempVect;
				}
			}
			else
				bAround = true;
		}
		else
			bAround = true;

		// We have a valid destination -- continue to walk around
		if (bAround)
		{
			// Determine the destination-self-obstacle angle
			dir      = Rotator(ActorAvoiding.Location-Location);
			avoidYaw = dir.Yaw;
			dir      = Rotator(Destination-Location);
			destYaw  = dir.Yaw;

			if (TurnDirection == TURNING_Left)
				angle = (avoidYaw - destYaw) & 65535;
			else
				angle = (destYaw - avoidYaw) & 65535;
			if (angle < 0)
				angle += 65536;

			// If the angle is between 90 and 180 degrees, we've cleared the obstacle
			if (bPointInCylinder || (angle < 16384) || (angle > 32768))  // haven't cleared the actor yet
			{
				if (TurnDirection == TURNING_Left)
					moveYaw = avoidYaw - 16384;
				else
					moveYaw = avoidYaw + 16384;
				Destination = Location + Vector(rot(0,1,0)*moveYaw)*400;
			}
			else  // cleared the actor -- move on
				TurnDirection = TURNING_None;
		}
	}

	if (TurnDirection == TURNING_None)
	{
		if (ObstacleTimer > 0)
		{
			TurnDirection = oldTurnDir;
			bClearedObstacle = true;
		}
	}
	else
		ObstacleTimer = 1.5;

	// Reset if done turning
	if (TurnDirection == TURNING_None)
	{
		NextDirection    = TURNING_None;
		ActorAvoiding    = None;
		bAdvancedTactics = false;
		ObstacleTimer    = 0;
		bClearedObstacle = true;

		if (oldTurnDir != TURNING_None)
			MoveTimer -= 4.0;
	}
}


// ----------------------------------------------------------------------
// Frob()
// ----------------------------------------------------------------------

function Frob(Actor Frobber, Inventory frobWith)
{
	Super.Frob(Frobber, frobWith);

	// Check to see if the Frobber is the player.  If so, then
	// check to see if we need to start a conversation.

	if (DeusExPlayer(Frobber) != None)
	{
		if (DeusExPlayer(Frobber).StartConversation(Self, IM_Frob))
		{
			ConversationActor = Pawn(Frobber);
			return;
		}
	}
}


// ----------------------------------------------------------------------
// StopBlendAnims()
// ----------------------------------------------------------------------

function StopBlendAnims()
{
	AIAddViewRotation = rot(0, 0, 0);
	Super.StopBlendAnims();
	PlayTurnHead(LOOK_Forward, 1.0, 1.0);
}


// ----------------------------------------------------------------------
// Falling()
// ----------------------------------------------------------------------

singular function Falling()
{
	if (bCanFly)
	{
		SetPhysics(PHYS_Flying);
		return;
	}
	// SetPhysics(PHYS_Falling); //note - done by default in physics
 	if (health > 0)
		SetFall();
}


// ----------------------------------------------------------------------
// SetFall()
// ----------------------------------------------------------------------

function SetFall()
{
	GotoState('FallingState');
}


// ----------------------------------------------------------------------
// LongFall()
// ----------------------------------------------------------------------

function LongFall()
{
	SetFall();
	GotoState('FallingState', 'LongFall');
}


// ----------------------------------------------------------------------
// HearNoise()
// ----------------------------------------------------------------------

function HearNoise(float Loudness, Actor NoiseMaker)
{
	// Do nothing
}


// ----------------------------------------------------------------------
// SeePlayer()
// ----------------------------------------------------------------------

function SeePlayer(Actor SeenPlayer)
{
	// Do nothing
}


// ----------------------------------------------------------------------
// Trigger()
// ----------------------------------------------------------------------

function Trigger( actor Other, pawn EventInstigator )
{
	// Do nothing
}


// ----------------------------------------------------------------------
// Reloading()
// ----------------------------------------------------------------------

function Reloading(DeusExWeapon reloadWeapon, float reloadTime)
{
	if (reloadWeapon == Weapon)
		ReloadTimer = reloadTime;
}


// ----------------------------------------------------------------------
// DoneReloading()
// ----------------------------------------------------------------------

function DoneReloading(DeusExWeapon reloadWeapon)
{
	if (reloadWeapon == Weapon)
		ReloadTimer = 0;
}


// ----------------------------------------------------------------------
// IsWeaponReloading()
// ----------------------------------------------------------------------

function bool IsWeaponReloading()
{
	return (ReloadTimer >= 0.3);
}


// ----------------------------------------------------------------------
// HandToHandAttack()
// ----------------------------------------------------------------------

function HandToHandAttack()
{
	local DeusExWeapon dxWeapon;

	dxWeapon = DeusExWeapon(Weapon);
	if (dxWeapon != None)
		dxWeapon.OwnerHandToHandAttack();
}


// ----------------------------------------------------------------------
// Killed()
// ----------------------------------------------------------------------

function Killed(pawn Killer, pawn Other, name damageType)
{
	if ((Enemy == Other) && (Other != None) && !Other.bIsPlayer)
		Enemy = None;
}


// ----------------------------------------------------------------------
// Died()
// ----------------------------------------------------------------------

function Died(pawn Killer, name damageType, vector HitLocation)
{
	local DeusExPlayer player;
	local name flagName;

	// Set a flag when NPCs die so we can possibly check it later
	player = DeusExPlayer(GetPlayerPawn());

	ExtinguishFire();

	// set the instigator to be the killer
	Instigator = Killer;

	if (player != None)
	{
		// Abort any conversation we may have been having with the NPC
		if (bInConversation)
			player.AbortConversation();

		// Abort any barks we may have been playing
		if (player.BarkManager != None)
			player.BarkManager.ScriptedPawnDied(Self);
	}

	Super.Died(Killer, damageType, HitLocation);  // bStunned is set here

	if (player != None)
	{
		if (bImportant)
		{
			flagName = player.rootWindow.StringToName(BindName$"_Dead");
			player.flagBase.SetBool(flagName, True);

			// make sure the flag never expires
			player.flagBase.SetExpiration(flagName, FLAG_Bool, 0);

			if (bStunned)
			{
				flagName = player.rootWindow.StringToName(BindName$"_Unconscious");
				player.flagBase.SetBool(flagName, True);

				// make sure the flag never expires
				player.flagBase.SetExpiration(flagName, FLAG_Bool, 0);
			}
		}
	}
}



// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// STATES
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// state StartUp
//
// Initial state
// ----------------------------------------------------------------------

auto state StartUp
{
	function BeginState()
	{
		bInterruptState = true;
		bCanConverse = false;

		SetMovementPhysics(); 
		if (Physics == PHYS_Walking)
			SetPhysics(PHYS_Falling);

		bStasis = False;
		SetDistress(false);
		BlockReactions();
		ResetDestLoc();
	}

	function EndState()
	{
		bCanConverse = true;
		bStasis = True;
		ResetReactions();
	}

	function Tick(float deltaSeconds)
	{
		Global.Tick(deltaSeconds);
		if (LastRendered() <= 1.0)
		{
			PlayWaiting();
			InitializePawn();
			FollowOrders();
		}
	}

Begin:
	InitializePawn();

	Sleep(FRand()+0.2);
	WaitForLanding();

Start:
	FollowOrders();
}


// ----------------------------------------------------------------------
// state Paralyzed
//
// Do nothing -- ignore all
// (this state lets ViewModel work correctly)
// ----------------------------------------------------------------------

state Paralyzed
{
	ignores bump, frob, reacttoinjury;
	function BeginState()
	{
		StandUp();
		BlockReactions(true);
		bCanConverse = False;
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}
	function EndState()
	{
		ResetReactions();
		bCanConverse = True;
	}

Begin:
	Acceleration=vect(0,0,0);
	PlayAnimPivot('Still');
}


// ----------------------------------------------------------------------
// state Idle
//
// Do nothing
// ----------------------------------------------------------------------

state Idle
{
	ignores bump, frob, reacttoinjury;
	function BeginState()
	{
		StandUp();
		BlockReactions(true);
		bCanConverse = False;
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}
	function EndState()
	{
		ResetReactions();
		bCanConverse = True;
	}

Begin:
	Acceleration=vect(0,0,0);
	DesiredRotation=Rotation;
	PlayAnimPivot('Still');

Idle:
}


// ----------------------------------------------------------------------
// state Conversation
//
// Just sit here until the conversation is over
// ----------------------------------------------------------------------

state Conversation
{
	function Tick(float deltaTime)
	{
		Global.Tick(deltaTime);

		LipSynch(deltaTime);

		// Keep turning towards the person we're speaking to
		if (ConversationActor != None)
		{
			if (bSitting)
			{
				if (SeatActor != None)
					LookAtActor(ConversationActor, true, true, true, 0, 0.5, SeatActor.Rotation.Yaw+49152, 5461);
				else
					LookAtActor(ConversationActor, false, true, true, 0, 0.5);
			}
			else
				LookAtActor(ConversationActor, true, true, true, 0, 0.5);
		}
	}

	function LoopHeadConvoAnim()
	{
	}

	function SetOrders(Name orderName, optional Name newOrderTag, optional bool bImmediate)
	{
		local DeusExPlayer dxPlayer;

		dxPlayer = DeusExPlayer(GetPlayerPawn());
		if (dxPlayer != None)
			if (dxPlayer.ConPlay != None)
				if (dxPlayer.ConPlay.GetForcePlay())
				{
					Global.SetOrders(orderName, newOrderTag, bImmediate);
					return;
				}

		ConvOrders   = orderName;
		ConvOrderTag = newOrderTag;
	}

	function FollowOrders(optional bool bDefer)
	{
		local name tempConvOrders, tempConvOrderTag;

		// hack
		tempConvOrders   = ConvOrders;
		tempConvOrderTag = ConvOrderTag;
		ResetConvOrders();  // must do this before calling SetOrders(), or recursion will result

		if (tempConvOrders != '')
			Global.SetOrders(tempConvOrders, tempConvOrderTag, true);
		else
			Global.FollowOrders(bDefer);
	}

	function BeginState()
	{
		local DeusExPlayer dxPlayer;
		local bool         bBlock;

		ResetConvOrders();
		EnableCheckDestLoc(false);

		bBlock = True;
		dxPlayer = DeusExPlayer(GetPlayerPawn());
		if (dxPlayer != None)
			if (dxPlayer.ConPlay != None)
				if (dxPlayer.ConPlay.CanInterrupt())
					bBlock = False;

		bInterruptState = True;
		if (bBlock)
		{
			bCanConverse = False;
			MakePawnIgnored(true);
			BlockReactions(true);
		}
		else
		{
			bCanConverse = True;
			MakePawnIgnored(true);
			BlockReactions(false);
		}

		// Check if the current state is "WaitingFor", "RunningTo" or "GoingTo", in which case
		// we want the orders to be 'Standing' after the conversation is over.  UNLESS the 
		// ScriptedPawn was going somewhere else (OrderTag != '')

		if (((Orders == 'WaitingFor') || (Orders == 'RunningTo') || (Orders == 'GoingTo')) && (OrderTag == ''))
			SetOrders('Standing');

		bConversationEndedNormally = False;
		bInConversation = True;
		bStasis = False;
		SetDistress(false);
		SeekPawn = None;
	}

	function EndState()
	{
		local DeusExPlayer player;
		local bool         bForcePlay;

		bForcePlay = false;
		player = DeusExPlayer(GetPlayerPawn());
		if (player != None)
			if (player.conPlay != None)
				bForcePlay = player.conPlay.GetForcePlay();

		bConvEndState = true;
		if (!bForcePlay && (bConversationEndedNormally != True))
			player.AbortConversation();
		bConvEndState = false;
		ResetConvOrders();

		StopBlendAnims();
		bInterruptState = true;
		bCanConverse    = True;
		MakePawnIgnored(false);
		ResetReactions();
		bStasis = True;
		ConversationActor = None;
	}

Begin:

	Acceleration = vect(0,0,0);

	DesiredRotation.Pitch = 0;
	if (!bSitting && !bDancing)
		PlayWaiting();

	// we are now idle
}


// ----------------------------------------------------------------------
// state FirstPersonConversation
//
// Just sit here until the conversation is over
// ----------------------------------------------------------------------

state FirstPersonConversation
{
	function Tick(float deltaTime)
	{
		Global.Tick(deltaTime);

		LipSynch(deltaTime);

		// Keep turning towards the person we're speaking to
		if (ConversationActor != None)
		{
			if (bSitting)
			{
				if (SeatActor != None)
					LookAtActor(ConversationActor, true, true, true, 0, 1.0, SeatActor.Rotation.Yaw+49152, 5461);
				else
					LookAtActor(ConversationActor, false, true, true, 0, 1.0);
			}
			else
				LookAtActor(ConversationActor, true, true, true, 0, 1.0);
		}
	}

	function LoopHeadConvoAnim()
	{
	}

	function SetOrders(Name orderName, optional Name newOrderTag, optional bool bImmediate)
	{
		ConvOrders   = orderName;
		ConvOrderTag = newOrderTag;
	}

	function FollowOrders(optional bool bDefer)
	{
		local name tempConvOrders, tempConvOrderTag;

		// hack
		tempConvOrders   = ConvOrders;
		tempConvOrderTag = ConvOrderTag;
		ResetConvOrders();  // must do this before calling SetOrders(), or recursion will result

		if (tempConvOrders != '')
			Global.SetOrders(tempConvOrders, tempConvOrderTag, true);
		else
			Global.FollowOrders(bDefer);
	}

	function BeginState()
	{
		local DeusExPlayer dxPlayer;
		local bool         bBlock;

		ResetConvOrders();
		EnableCheckDestLoc(false);

		dxPlayer = DeusExPlayer(GetPlayerPawn());
		/*
		bBlock = True;
		if (dxPlayer != None)
			if (dxPlayer.ConPlay != None)
				if (dxPlayer.ConPlay.CanInterrupt())
					bBlock = False;
		*/

		// 1st-person conversations will no longer block;
		// left old code in here in case people change their minds :)

		bBlock = false;

		bInterruptState = True;
		if (bBlock)
		{
			bCanConverse = False;
			MakePawnIgnored(true);
			BlockReactions(true);
		}
		else
		{
			bCanConverse = True;
			MakePawnIgnored(false);
			if ((dxPlayer != None) && (dxPlayer.conPlay != None) &&
			    dxPlayer.conPlay.con.IsSpeakingActor(dxPlayer))
				SetReactions(false, false, false, false, true, false, false, true, false, false, true, true);
			else
				ResetReactions();
		}

		bConversationEndedNormally = False;
		bInConversation = True;
		bStasis = False;
		SetDistress(false);
		SeekPawn = None;
	}

	function EndState()
	{
		local DeusExPlayer player;

		bConvEndState = true;
		if (bConversationEndedNormally != True)
		{
			player = DeusExPlayer(GetPlayerPawn());
			player.AbortConversation();
		}
		bConvEndState = false;
		ResetConvOrders();

		StopBlendAnims();
		bInterruptState = true;
		bCanConverse    = True;
		MakePawnIgnored(false);
		ResetReactions();
		bStasis = True;
		ConversationActor = None;
	}

Begin:

	Acceleration = vect(0,0,0);

	DesiredRotation.Pitch = 0;
	if (!bSitting && !bDancing)
		PlayWaiting();

	// we are now idle
}


// ----------------------------------------------------------------------
// EnterConversationState()
// ----------------------------------------------------------------------

function EnterConversationState(bool bFirstPerson, optional bool bAvoidState)
{
	// First check to see if we're already in a conversation state, 
	// in which case we'll abort immediately

	if ((GetStateName() == 'Conversation') || (GetStateName() == 'FirstPersonConversation'))
		return;

	SetNextState(GetStateName(), 'Begin');

	// If bAvoidState is set, then we don't want to jump into the conversaton state
	// for the ScriptedPawn, because bad things might happen otherwise.

	if (!bAvoidState)
	{
		if (bFirstPerson)
			GotoState('FirstPersonConversation');
		else
			GotoState('Conversation');
	}
}


// ----------------------------------------------------------------------
// state Standing
//
// Just kinda stand there and do nothing.
// (similar to Wandering, except the pawn doesn't actually move)
// ----------------------------------------------------------------------

state Standing
{
	ignores EnemyNotVisible;

	function SetFall()
	{
		StartFalling('Standing', 'ContinueStand');
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function Tick(float deltaSeconds)
	{
		animTimer[1] += deltaSeconds;
		Global.Tick(deltaSeconds);
	}

	function BeginState()
	{
		StandUp();
		SetEnemy(None, EnemyLastSeen, true);
		Disable('AnimEnd');
		bCanJump = false;

		bStasis = False;

		SetupWeapon(false);
		SetDistress(false);
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bAcceptBump = True;

		if (JumpZ > 0)
			bCanJump = true;
		bStasis = True;

		StopBlendAnims();
	}

Begin:
	WaitForLanding();
	if (!bUseHome)
		Goto('StartStand');

MoveToBase:
	if (!IsPointInCylinder(self, HomeLoc, 16-CollisionRadius))
	{
		EnableCheckDestLoc(true);
		while (true)
		{
			if (PointReachable(HomeLoc))
			{
				if (ShouldPlayWalk(HomeLoc))
					PlayWalking();
				MoveTo(HomeLoc, GetWalkingSpeed());
				CheckDestLoc(HomeLoc);
				break;
			}
			else
			{
				MoveTarget = FindPathTo(HomeLoc);
				if (MoveTarget != None)
				{
					if (ShouldPlayWalk(MoveTarget.Location))
						PlayWalking();
					MoveToward(MoveTarget, GetWalkingSpeed());
					CheckDestLoc(MoveTarget.Location, true);
				}
				else
					break;
			}
		}
		EnableCheckDestLoc(false);
	}
	TurnTo(Location+HomeRot);

StartStand:
	Acceleration=vect(0,0,0);
	Goto('Stand');

ContinueFromDoor:
	Goto('MoveToBase');

Stand:
ContinueStand:
	// nil
	bStasis = True;

	PlayWaiting();
	if (!bPlayIdle)
		Goto('DoNothing');
	Sleep(FRand()*14+8);

Fidget:
	if (FRand() < 0.5)
	{
		PlayIdle();
		FinishAnim();
	}
	else
	{
		if (FRand() > 0.5)
		{
			PlayTurnHead(LOOK_Up, 1.0, 1.0);
			Sleep(2.0);
			PlayTurnHead(LOOK_Forward, 1.0, 1.0);
			Sleep(0.5);
		}
		else if (FRand() > 0.5)
		{
			PlayTurnHead(LOOK_Left, 1.0, 1.0);
			Sleep(1.5);
			PlayTurnHead(LOOK_Forward, 1.0, 1.0);
			Sleep(0.9);
			PlayTurnHead(LOOK_Right, 1.0, 1.0);
			Sleep(1.2);
			PlayTurnHead(LOOK_Forward, 1.0, 1.0);
			Sleep(0.5);
		}
		else
		{
			PlayTurnHead(LOOK_Right, 1.0, 1.0);
			Sleep(1.5);
			PlayTurnHead(LOOK_Forward, 1.0, 1.0);
			Sleep(0.9);
			PlayTurnHead(LOOK_Left, 1.0, 1.0);
			Sleep(1.2);
			PlayTurnHead(LOOK_Forward, 1.0, 1.0);
			Sleep(0.5);
		}
	}
	if (FRand() < 0.3)
		PlayIdleSound();
	Goto('Stand');

DoNothing:
	// nil
}


// ----------------------------------------------------------------------
// state Dancing
//
// Dance in place.
// (Most of this code was ripped from Standing)
// ----------------------------------------------------------------------

state Dancing
{
	ignores EnemyNotVisible;

	function SetFall()
	{
		StartFalling('Dancing', 'ContinueDance');
	}

	function AnimEnd()
	{
		PlayDancing();
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function BeginState()
	{
		if (bSitting && !bDancing)
			StandUp();
		SetEnemy(None, EnemyLastSeen, true);
		Disable('AnimEnd');
		bCanJump = false;

		bStasis = False;

		SetupWeapon(false);
		SetDistress(false);
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bAcceptBump = True;

		if (JumpZ > 0)
			bCanJump = true;
		bStasis = True;

		StopBlendAnims();
	}

Begin:
	WaitForLanding();
	if (bDancing)
	{
		if (bUseHome)
			TurnTo(Location+HomeRot);
		Goto('StartDance');
	}
	if (!bUseHome)
		Goto('StartDance');

MoveToBase:
	if (!IsPointInCylinder(self, HomeLoc, 16-CollisionRadius))
	{
		EnableCheckDestLoc(true);
		while (true)
		{
			if (PointReachable(HomeLoc))
			{
				if (ShouldPlayWalk(HomeLoc))
					PlayWalking();
				MoveTo(HomeLoc, GetWalkingSpeed());
				CheckDestLoc(HomeLoc);
				break;
			}
			else
			{
				MoveTarget = FindPathTo(HomeLoc);
				if (MoveTarget != None)
				{
					if (ShouldPlayWalk(MoveTarget.Location))
						PlayWalking();
					MoveToward(MoveTarget, GetWalkingSpeed());
					CheckDestLoc(MoveTarget.Location, true);
				}
				else
					break;
			}
		}
		EnableCheckDestLoc(false);
	}
	TurnTo(Location+HomeRot);

StartDance:
	Acceleration=vect(0,0,0);
	Goto('Dance');

ContinueFromDoor:
	Goto('MoveToBase');

Dance:
ContinueDance:
	// nil
	bDancing = True;
	PlayDancing();
	bStasis = True;
	if (!bHokeyPokey)
		Goto('DoNothing');

Spin:
	Sleep(FRand()*5+5);
	useRot = DesiredRotation;
	if (FRand() > 0.5)
	{
		TurnTo(Location+1000*vector(useRot+rot(0,16384,0)));
		TurnTo(Location+1000*vector(useRot+rot(0,32768,0)));
		TurnTo(Location+1000*vector(useRot+rot(0,49152,0)));
	}
	else
	{
		TurnTo(Location+1000*vector(useRot+rot(0,49152,0)));
		TurnTo(Location+1000*vector(useRot+rot(0,32768,0)));
		TurnTo(Location+1000*vector(useRot+rot(0,16384,0)));
	}
	TurnTo(Location+1000*vector(useRot));
	Goto('Spin');

DoNothing:
	// nil
}


// ----------------------------------------------------------------------
// state Sitting
//
// Just kinda sit there and do nothing.
// (doubles as a shitting state)
// ----------------------------------------------------------------------

state Sitting
{
	ignores EnemyNotVisible;

	function SetFall()
	{
		StartFalling('Sitting', 'ContinueSit');
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		if (!bAcceptBump)
			NextDirection = TURNING_None;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function bool HandleTurn(Actor Other)
	{
		if (Other == SeatActor)
			return true;
		else
			return Global.HandleTurn(Other);
	}

	function Bump(actor bumper)
	{
		// If we hit our chair, move to the right place
		if ((bumper == SeatActor) && bAcceptBump)
		{
			bAcceptBump = false;
			GotoState('Sitting', 'CircleToFront');
		}

		// Handle conversations, if need be
		else
			Global.Bump(bumper);
	}

	function Tick(float deltaSeconds)
	{
		local vector endPos;
		local vector newPos;
		local float  delta;

		Global.Tick(deltaSeconds);

		if (bSitInterpolation && (SeatActor != None))
		{
			endPos = SitPosition(SeatActor, SeatSlot);
			if ((deltaSeconds < remainingSitTime) && (remainingSitTime > 0))
			{
				delta = deltaSeconds/remainingSitTime;
				newPos = (endPos-Location)*delta + Location;
				remainingSitTime -= deltaSeconds;
			}
			else
			{
				remainingSitTime = 0;
				bSitInterpolation = false;
				newPos = endPos;
				Acceleration = vect(0,0,0);
				Velocity = vect(0,0,0);
				SetBase(SeatActor);
				bSitting = true;
			}
			SetLocation(newPos);
			DesiredRotation = SeatActor.Rotation+Rot(0, -16384, 0);
		}
	}

	function Vector SitPosition(Seat seatActor, int slot)
	{
		local float newAssHeight;

		newAssHeight = GetDefaultCollisionHeight() + BaseAssHeight;
		newAssHeight = -(CollisionHeight - newAssHeight);

		return ((seatActor.sitPoint[slot]>>seatActor.Rotation)+seatActor.Location+(vect(0,0,-1)*newAssHeight));
	}

	function vector GetDestinationPosition(Seat seatActor, optional float extraDist)
	{
		local Rotator seatRot;
		local Vector  destPos;

		if (seatActor == None)
			return (Location);

		seatRot = seatActor.Rotation + Rot(0, -16384, 0);
		seatRot.Pitch = 0;
		destPos = seatActor.Location;
		destPos += vect(0,0,1)*(CollisionHeight-seatActor.CollisionHeight);
		destPos += Vector(seatRot)*(seatActor.CollisionRadius+CollisionRadius+extraDist);

		return (destPos);
	}

	function bool IsIntersectingSeat()
	{
		local bool   bIntersect;
		local vector testVector;

		bIntersect = false;
		if (SeatActor != None)
			bIntersect = IsOverlapping(SeatActor);

		return (bIntersect);
	}

	function int FindBestSlot(Seat seatActor, out float slotDist)
	{
		local int   bestSlot;
		local float dist;
		local float bestDist;
		local int   i;

		bestSlot = -1;
		bestDist = 100;
		if (!seatActor.Region.Zone.bWaterZone)
		{
			for (i=0; i<seatActor.numSitPoints; i++)
			{
				if (seatActor.sittingActor[i] == None)
				{
					dist = VSize(SitPosition(seatActor, i) - Location);
					if ((bestSlot < 0) || (bestDist > dist))
					{
						bestDist = dist;
						bestSlot = i;
					}
				}
			}
		}

		slotDist = bestDist;

		return (bestSlot);
	}

	function FindBestSeat()
	{
		local Seat  curSeat;
		local Seat  bestSeat;
		local float curDist;
		local float bestDist;
		local int   curSlot;
		local int   bestSlot;
		local bool  bTry;

		if (bUseFirstSeatOnly && bSeatHackUsed)
		{
			bestSeat = SeatHack;  // use the seat hack
			bestSlot = -1;
			if (!IsSeatValid(bestSeat))
				bestSeat = None;
			else
			{
				if (GetNextWaypoint(bestSeat) == None)
					bestSeat = None;
				else
				{
					bestSlot = FindBestSlot(bestSeat, curDist);
					if (bestSlot < 0)
						bestSeat = None;
				}
			}
		}
		else
		{
			bestSeat = Seat(OrderActor);  // try the ordered seat first
			if (bestSeat != None)
			{
				if (!IsSeatValid(OrderActor))
					bestSeat = None;
				else
				{
					if (GetNextWaypoint(bestSeat) == None)
						bestSeat = None;
					else
					{
						bestSlot = FindBestSlot(bestSeat, curDist);
						if (bestSlot < 0)
							bestSeat = None;
					}
				}
			}
			if (bestSeat == None)
			{
				bestDist = 10001;
				bestSlot = -1;
				foreach RadiusActors(Class'Seat', curSeat, 10000)
				{
					if (IsSeatValid(curSeat))
					{
						curSlot = FindBestSlot(curSeat, curDist);
						if (curSlot >= 0)
						{
							if (bestDist > curDist)
							{
								if (GetNextWaypoint(curSeat) != None)
								{
									bestDist = curDist;
									bestSeat = curSeat;
									bestSlot = curSlot;
								}
							}
						}
					}
				}
			}
		}

		if (bestSeat != None)
		{
			bestSeat.sittingActor[bestSlot] = self;
			SeatLocation       = bestSeat.Location;
			bSeatLocationValid = true;
		}
		else
			bSeatLocationValid = false;

		if (bUseFirstSeatOnly && !bSeatHackUsed)
		{
			SeatHack      = bestSeat;
			bSeatHackUsed = true;
		}

		SeatActor = bestSeat;
		SeatSlot  = bestSlot;
	}

	function FollowSeatFallbackOrders()
	{
		FindBestSeat();
		if (IsSeatValid(SeatActor))
			GotoState('Sitting', 'Begin');
		else
			GotoState('Wandering');
	}

	function BeginState()
	{
		SetEnemy(None, EnemyLastSeen, true);
		Disable('AnimEnd');
		bCanJump = false;

		bAcceptBump = True;

		if (SeatActor == None)
			FindBestSeat();

		bSitInterpolation = false;

		bStasis = False;

		SetupWeapon(false);
		SetDistress(false);
		SeekPawn = None;
		EnableCheckDestLoc(true);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		if (!bSitting)
			StandUp();

		bAcceptBump = True;

		if (JumpZ > 0)
			bCanJump = true;

		bSitInterpolation = false;

		bStasis = True;
	}

Begin:
	WaitForLanding();
	if (!IsSeatValid(SeatActor))
		FollowSeatFallbackOrders();
	if (!bSitting)
		WaitForLanding();
	else
	{
		TurnTo(Vector(SeatActor.Rotation+Rot(0, -16384, 0))*100+Location);
		Goto('ContinueSitting');
	}

MoveToSeat:
	if (IsIntersectingSeat())
		Goto('MoveToPosition');
	bAcceptBump = true;
	while (true)
	{
		if (!IsSeatValid(SeatActor))
			FollowSeatFallbackOrders();
		destLoc = GetDestinationPosition(SeatActor);
		if (PointReachable(destLoc))
		{
			if (ShouldPlayWalk(destLoc))
				PlayWalking();
			MoveTo(destLoc, GetWalkingSpeed());
			CheckDestLoc(destLoc);

			if (IsPointInCylinder(self, GetDestinationPosition(SeatActor), 16, 16))
			{
				bAcceptBump = false;
				Goto('MoveToPosition');
				break;
			}
		}
		else
		{
			MoveTarget = GetNextWaypoint(SeatActor);
			if (MoveTarget != None)
			{
				if (ShouldPlayWalk(MoveTarget.Location))
					PlayWalking();
				MoveToward(MoveTarget, GetWalkingSpeed());
				CheckDestLoc(MoveTarget.Location, true);
			}
			else
				break;
		}
	}

CircleToFront:
	bAcceptBump = false;
	if (!IsSeatValid(SeatActor))
		FollowSeatFallbackOrders();
	if (ShouldPlayWalk(GetDestinationPosition(SeatActor, 16)))
		PlayWalking();
	MoveTo(GetDestinationPosition(SeatActor, 16), GetWalkingSpeed());

MoveToPosition:
	if (!IsSeatValid(SeatActor))
		FollowSeatFallbackOrders();
	bSitting = true;
	EnableCollision(false);
	Acceleration=vect(0,0,0);

Sit:
	Acceleration=vect(0,0,0);
	Velocity=vect(0,0,0);
	if (!IsSeatValid(SeatActor))
		FollowSeatFallbackOrders();
	remainingSitTime = 0.8;
	PlaySittingDown();
	SetBasedPawnSize(CollisionRadius, GetSitHeight());
	SetPhysics(PHYS_Flying);
	StopStanding();
	bSitInterpolation = true;
	while (bSitInterpolation)
		Sleep(0);
	FinishAnim();
	Goto('ContinueSitting');

ContinueFromDoor:
	Goto('MoveToSeat');

ContinueSitting:
	if (!IsSeatValid(SeatActor))
		FollowSeatFallbackOrders();
	SetBasedPawnSize(CollisionRadius, GetSitHeight());
	SetCollision(Default.bCollideActors, Default.bBlockActors, Default.bBlockPlayers);
	PlaySitting();
	bStasis  = True;
	// nil

}


// ----------------------------------------------------------------------
// state HandlingEnemy
//
// Fight-or-flight state
// ----------------------------------------------------------------------

state HandlingEnemy
{
	function BeginState()
	{
		if (Enemy == None)
			GotoState('Seeking');
		else if (RaiseAlarm == RAISEALARM_BeforeAttacking)
			GotoState('Alerting');
		else
			GotoState('Attacking');
	}

Begin:

}

// ----------------------------------------------------------------------
// state Wandering
//
// Meander from place to place, occasionally gazing into the middle
// distance.
// ----------------------------------------------------------------------

state Wandering
{
	ignores EnemyNotVisible;

	function SetFall()
	{
		StartFalling('Wandering', 'ContinueWander');
	}

	function Bump(actor bumper)
	{
		if (bAcceptBump)
		{
			// If we get bumped by another actor while we wait, start wandering again
			bAcceptBump = False;
			Disable('AnimEnd');
			GotoState('Wandering', 'Wander');
		}

		// Handle conversations, if need be
		Global.Bump(bumper);
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function bool GoHome()
	{
		if (bUseHome && !IsNearHome(Location))
		{
			destLoc   = HomeLoc;
			destPoint = None;
			if (PointReachable(destLoc))
				return true;
			else
			{
				MoveTarget = FindPathTo(destLoc);
				if (MoveTarget != None)
					return true;
				else
					return false;
			}
		}
		else
			return false;
	}

	function PickDestination()
	{
		local WanderCandidates candidates[5];
		local int              candidateCount;
		local int              maxCandidates;
		local int              maxLastPoints;

		local WanderPoint curPoint;
		local Actor       wayPoint;
		local int         i;
		local int         openSlot;
		local float       maxDist;
		local float       dist;
		local float       angle;
		local float       magnitude;
		local int         iterations;
		local bool        bSuccess;
		local Rotator     rot;

		maxCandidates = 4;  // must be <= size of candidates[] array
		maxLastPoints = 2;  // must be <= size of lastPoints[] array

		for (i=0; i<maxCandidates; i++)
			candidates[i].dist = 100000;
		candidateCount = 0;

		// A certain percentage of the time, we want to angle off to a random direction...
		if ((RandomWandering < 1) && (FRand() > RandomWandering))
		{
			// Fill the candidate table
			foreach RadiusActors(Class'WanderPoint', curPoint, 3000*wanderlust+1000)  // 1000-4000
			{
				// Make sure we haven't been here recently
				for (i=0; i<maxLastPoints; i++)
				{
					if (lastPoints[i] == curPoint)
						break;
				}

				if (i >= maxLastPoints)
				{
					// Can we get there from here?
					wayPoint = GetNextWaypoint(curPoint);

					if ((wayPoint != None) && !IsNearHome(curPoint.Location))
						wayPoint = None;

					// Yep
					if (wayPoint != None)
					{
						// Find an empty slot for this candidate
						openSlot = -1;
						dist     = VSize(curPoint.location - location);
						maxDist  = dist;

						// This candidate will only replace more distant candidates...
						for (i=0; i<maxCandidates; i++)
						{
							if (maxDist < candidates[i].dist)
							{
								maxDist  = candidates[i].dist;
								openSlot = i;
							}
						}

						// Put the candidate in the (unsorted) list
						if (openSlot >= 0)
						{
							candidates[openSlot].point    = curPoint;
							candidates[openSlot].waypoint = wayPoint;
							candidates[openSlot].dist     = dist;
							if (candidateCount < maxCandidates)
								candidateCount++;
						}
					}
				}
			}
		}

		// Shift our list of recently visited points
		for (i=maxLastPoints-1; i>0; i--)
			lastPoints[i] = lastPoints[i-1];
		lastPoints[0] = None;

		// Do we have a list of candidates?
		if (candidateCount > 0)
		{
			// Pick a candidate at random
			i = Rand(candidateCount);
			curPoint = candidates[i].point;
			wayPoint = candidates[i].waypoint;
			lastPoints[0] = curPoint;
			MoveTarget    = wayPoint;
			destPoint     = curPoint;
		}

		// No candidates -- find a random place to go
		else
		{
			MoveTarget = None;
			destPoint  = None;
			iterations = 6;  // try up to 6 different directions
			while (iterations > 0)
			{
				// How far will we go?
				magnitude = (wanderlust*400+200) * (FRand()*0.2+0.9); // 200-600, +/-10%

				// Choose our destination, based on whether we have a home base
				if (!bUseHome)
					bSuccess = AIPickRandomDestination(100, magnitude, 0, 0, 0, 0, 1,
					                                   FRand()*0.4+0.35, destLoc);
				else
				{
					if (magnitude > HomeExtent)
						magnitude = HomeExtent*(FRand()*0.2+0.9);
					rot = Rotator(HomeLoc-Location);
					bSuccess = AIPickRandomDestination(50, magnitude, rot.Yaw, 0.25, rot.Pitch, 0.25, 1,
					                                   FRand()*0.4+0.35, destLoc);
				}

				// Success?  Break out of the iteration loop
				if (bSuccess)
					if (IsNearHome(destLoc))
						break;

				// We failed -- try again
				iterations--;
			}

			// If we got a destination, go there
			if (iterations <= 0)
				destLoc = Location;
		}
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function BeginState()
	{
		StandUp();
		SetEnemy(None, EnemyLastSeen, true);
		Disable('AnimEnd');
		bCanJump = false;
		SetupWeapon(false);
		SetDistress(false);
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		local int i;
		bAcceptBump = True;

		EnableCheckDestLoc(false);

		// Clear out our list of last visited points
		for (i=0; i<ArrayCount(lastPoints); i++)
			lastPoints[i] = None;

		if (JumpZ > 0)
			bCanJump = true;
	}

Begin:
	destPoint = None;

GoHome:
	bAcceptBump = false;
	WaitForLanding();
	if (!GoHome())
		Goto('WanderInternal');

MoveHome:
	EnableCheckDestLoc(true);
	while (true)
	{
		if (PointReachable(destLoc))
		{
			if (ShouldPlayWalk(destLoc))
				PlayWalking();
			MoveTo(destLoc, GetWalkingSpeed());
			CheckDestLoc(destLoc);
			break;
		}
		else
		{
			MoveTarget = FindPathTo(destLoc);
			if (MoveTarget != None)
			{
				if (ShouldPlayWalk(MoveTarget.Location))
					PlayWalking();
				MoveToward(MoveTarget, GetWalkingSpeed());
				CheckDestLoc(MoveTarget.Location, true);
			}
			else
				break;
		}
	}
	EnableCheckDestLoc(false);
	Goto('Pausing');

Wander:
	WaitForLanding();
WanderInternal:
	PickDestination();

Moving:
	// Move from pathnode to pathnode until we get where we're going
	// (ooooold code -- no longer used)
	if (destPoint != None)
	{
		if (ShouldPlayWalk(MoveTarget.Location))
			PlayWalking();
		MoveToward(MoveTarget, GetWalkingSpeed());
		while ((MoveTarget != None) && (MoveTarget != destPoint))
		{
			MoveTarget = FindPathToward(destPoint);
			if (MoveTarget != None)
			{
				if (ShouldPlayWalk(MoveTarget.Location))
					PlayWalking();
				MoveToward(MoveTarget, GetWalkingSpeed());
			}
		}
	}
	else if (destLoc != Location)
	{
		if (ShouldPlayWalk(destLoc))
			PlayWalking();
		MoveTo(destLoc, GetWalkingSpeed());
	}
	else
		Sleep(0.5);

Pausing:
	Acceleration = vect(0, 0, 0);

	// Turn in the direction dictated by the WanderPoint, if there is one
	sleepTime = 6.0;
	if (WanderPoint(destPoint) != None)
	{
		if (WanderPoint(destPoint).gazeItem != None)
		{
			TurnToward(WanderPoint(destPoint).gazeItem);
			sleepTime = WanderPoint(destPoint).gazeDuration;
		}
		else if (WanderPoint(destPoint).gazeDirection != vect(0, 0, 0))
			TurnTo(Location + WanderPoint(destPoint).gazeDirection);
	}
	Enable('AnimEnd');
	TweenToWaiting(0.2);
	bAcceptBump = True;
	PlayScanningSound();
	sleepTime *= (-0.9*restlessness) + 1;
	Sleep(sleepTime);
	Disable('AnimEnd');
	bAcceptBump = False;
	FinishAnim();
	Goto('Wander');

ContinueWander:
ContinueFromDoor:
	FinishAnim();
	PlayWalking();
	Goto('Wander');
}


// ----------------------------------------------------------------------
// state Leaving
//
// Just like Patrolling, but make the pawn transient.
// ----------------------------------------------------------------------

State Leaving
{
	function BeginState()
	{
		bTransient = True;  // this pawn will be destroyed when it gets out of range
		bDisappear = True;
		GotoState('Patrolling');
	}

Begin:
	// shouldn't ever reach this point
}


// ----------------------------------------------------------------------
// state Patrolling
//
// Move from point to point in a predescribed pattern.
// ----------------------------------------------------------------------

State Patrolling
{
	function SetFall()
	{
		StartFalling('Patrolling', 'ContinuePatrol');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}
	
	function AnimEnd()
	{
		PlayWaiting();
	}

	function PatrolPoint PickStartPoint()
	{
		local NavigationPoint nav;
		local PatrolPoint     curNav;
		local float           curDist;
		local PatrolPoint     closestNav;
		local float           closestDist;

		nav = Level.NavigationPointList;
		while (nav != None)
		{
			nav.visitedWeight = 0;
			nav = nav.nextNavigationPoint;
		}

		closestNav  = None;
		closestDist = 100000;
		nav = Level.NavigationPointList;
		while (nav != None)
		{
			curNav = PatrolPoint(nav);
			if ((curNav != None) && (curNav.Tag == OrderTag))
			{
				while (curNav != None)
				{
					if (curNav.visitedWeight != 0)  // been here before
						break;
					curDist = VSize(Location - curNav.Location);
					if ((closestNav == None) || (closestDist > curDist))
					{
						closestNav  = curNav;
						closestDist = curDist;
					}
					curNav.visitedWeight = 1;
					curNav = curNav.NextPatrolPoint;
				}
			}
			nav = nav.nextNavigationPoint;
		}

		return (closestNav);
	}

	function PickDestination()
	{
		if (PatrolPoint(destPoint) != None)
			destPoint = PatrolPoint(destPoint).NextPatrolPoint;
		else
			destPoint = PickStartPoint();
		if (destPoint == None)  // can't go anywhere...
			GotoState('Standing');
	}

	function BeginState()
	{
		StandUp();
		SetEnemy(None, EnemyLastSeen, true);
		Disable('AnimEnd');
		SetupWeapon(false);
		SetDistress(false);
		bStasis = false;
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		Enable('AnimEnd');
		bStasis = true;
	}

Begin:
	destPoint = None;

Patrol:
	//Disable('Bump');
	WaitForLanding();
	PickDestination();

Moving:
	// Move from pathnode to pathnode until we get where we're going
	if (destPoint != None)
	{
		if (!IsPointInCylinder(self, destPoint.Location, 16-CollisionRadius))
		{
			EnableCheckDestLoc(true);
			MoveTarget = FindPathToward(destPoint);
			while (MoveTarget != None)
			{
				if (ShouldPlayWalk(MoveTarget.Location))
					PlayWalking();
				MoveToward(MoveTarget, GetWalkingSpeed());
				CheckDestLoc(MoveTarget.Location, true);
				if (MoveTarget == destPoint)
					break;
				MoveTarget = FindPathToward(destPoint);
			}
			EnableCheckDestLoc(false);
		}
	}
	else
		Goto('Patrol');

Pausing:
	if (!bAlwaysPatrol)
		bStasis = true;
	Acceleration = vect(0, 0, 0);

	// Turn in the direction dictated by the WanderPoint, or a random direction
	if (PatrolPoint(destPoint) != None)
	{
		if ((PatrolPoint(destPoint).pausetime > 0) || (PatrolPoint(destPoint).NextPatrolPoint == None))
		{
			if (ShouldPlayTurn(Location + PatrolPoint(destPoint).lookdir))
				PlayTurning();
			TurnTo(Location + PatrolPoint(destPoint).lookdir);
			Enable('AnimEnd');
			TweenToWaiting(0.2);
			PlayScanningSound();
			//Enable('Bump');
			sleepTime = PatrolPoint(destPoint).pausetime * ((-0.9*restlessness) + 1);
			Sleep(sleepTime);
			Disable('AnimEnd');
			//Disable('Bump');
			FinishAnim();
		}
	}
	Goto('Patrol');

ContinuePatrol:
ContinueFromDoor:
	FinishAnim();
	PlayWalking();
	Goto('Moving');

}


// ----------------------------------------------------------------------
// state Seeking
//
// Look for enemies in the area
// ----------------------------------------------------------------------

State Seeking
{
	function SetFall()
	{
		StartFalling('Seeking', 'ContinueSeek');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function bool GetNextLocation(out vector nextLoc)
	{
		local float   dist;
		local rotator rotation;
		local bool    bDone;
		local float   seekDistance;
		local Actor   hitActor;
		local vector  HitLocation, HitNormal;
		local vector  diffVect;
		local bool    bLOS;

		if (bSeekLocation)
		{
			if (SeekType == SEEKTYPE_Guess)
				seekDistance = (200+FClamp(GroundSpeed*EnemyLastSeen*0.5, 0, 1000));
			else
				seekDistance = 300;
		}
		else
			seekDistance = 60;

		dist  = VSize(Location-destLoc);
		bDone = false;
		bLOS  = false;

		if (dist < seekDistance)
		{
			bLOS = true;
			foreach TraceVisibleActors(Class'Actor', hitActor, hitLocation, hitNormal,
			                           destLoc, Location+vect(0,0,1)*BaseEyeHeight)
			{
				if (hitActor != self)
				{
					if (hitActor == Level)
						bLOS = false;
					else if (IsPointInCylinder(hitActor, destLoc, 16, 16))
						break;
					else if (hitActor.bBlockSight && !hitActor.bHidden)
						bLOS = false;
				}
				if (!bLOS)
					break;
			}
		}

		if (!bLOS)
		{
			if (PointReachable(destLoc))
			{
				rotation = Rotator(destLoc - Location);
				if (seekDistance == 0)
					nextLoc = destLoc;
				else if (!AIDirectionReachable(destLoc, rotation.Yaw, rotation.Pitch, 0, seekDistance, nextLoc))
					bDone = true;
				if (!bDone && bDefendHome && !IsNearHome(nextLoc))
					bDone = true;
				if (!bDone)  // hack, because Unreal's movement code SUCKS
				{
					diffVect = nextLoc - Location;
					if (Physics == PHYS_Walking)
						diffVect *= vect(1,1,0);
					if (VSize(diffVect) < 20)
						bDone = true;
					else if (IsPointInCylinder(self, nextLoc, 10, 10))
						bDone = true;
				}
			}
			else
			{
				MoveTarget = FindPathTo(destLoc);
				if (MoveTarget == None)
					bDone = true;
				else if (bDefendHome && !IsNearHome(MoveTarget.Location))
					bDone = true;
				else
					nextLoc = MoveTarget.Location;
			}
		}
		else
			bDone = true;

		return (!bDone);
	}

	function bool PickDestination()
	{
		local bool bValid;

		bValid = false;
		if (/*(EnemyLastSeen <= 25.0) &&*/ (SeekLevel > 0))
		{
			if (bSeekLocation)
			{
				bValid  = true;
				destLoc = LastSeenPos;
			}
			else
			{
				bValid = AIPickRandomDestination(130, 250, 0, 0, 0, 0, 2, 1.0, destLoc);
				if (!bValid)
				{
					bValid  = true;
					destLoc = Location + VRand()*50;
				}
				else
					destLoc += vect(0,0,1)*BaseEyeHeight;
			}
		}

		return (bValid);
	}

	function NavigationPoint GetOvershootDestination(float randomness, optional float focus)
	{
		local NavigationPoint navPoint, bestPoint;
		local float           distance;
		local float           score, bestScore;
		local int             yaw;
		local rotator         rot;
		local float           yawCutoff;

		if (focus <= 0)
			focus = 0.6;

		yawCutoff = int(32768*focus);
		bestPoint = None;
		bestScore = 0;

		foreach ReachablePathnodes(Class'NavigationPoint', navPoint, None, distance)
		{
			if (distance < 1)
				distance = 1;
			rot = Rotator(navPoint.Location-Location);
			yaw = rot.Yaw + (16384*randomness);
			yaw = (yaw-Rotation.Yaw) & 0xFFFF;
			if (yaw > 32767)
				yaw  -= 65536;
			yaw = abs(yaw);
			if (yaw <= yawCutoff)
			{
				score = yaw/distance;
				if ((bestPoint == None) || (score < bestScore))
				{
					bestPoint = navPoint;
					bestScore = score;
				}
			}
		}

		return bestPoint;
	}

	function Tick(float deltaSeconds)
	{
		animTimer[1] += deltaSeconds;
		Global.Tick(deltaSeconds);
		UpdateActorVisibility(Enemy, deltaSeconds, 1.0, true);
	}

	function HandleLoudNoise(Name event, EAIEventState state, XAIParams params)
	{
		local Actor bestActor;
		local Pawn  instigator;

		if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
		{
			bestActor = params.bestActor;
			if ((bestActor != None) && (EnemyLastSeen > 2.0))
			{
				instigator = Pawn(bestActor);
				if (instigator == None)
					instigator = bestActor.Instigator;
				if (instigator != None)
				{
					if (IsValidEnemy(instigator))
					{
						SetSeekLocation(instigator, bestActor.Location, SEEKTYPE_Sound);
						destLoc = LastSeenPos;
						if (bInterruptSeek)
							GotoState('Seeking', 'GoToLocation');
					}
				}
			}
		}
	}

	function HandleSighting(Pawn pawnSighted)
	{
		if ((EnemyLastSeen > 2.0) && IsValidEnemy(pawnSighted))
		{
			SetSeekLocation(pawnSighted, pawnSighted.Location, SEEKTYPE_Sight);
			destLoc = LastSeenPos;
			if (bInterruptSeek)
				GotoState('Seeking', 'GoToLocation');
		}
	}

	function BeginState()
	{
		StandUp();
		Disable('AnimEnd');
		destLoc = LastSeenPos;
		SetReactions(true, true, false, true, true, true, true, true, true, false, true, true);
		bCanConverse = False;
		bStasis = False;
		SetupWeapon(true);
		SetDistress(false);
		bInterruptSeek = false;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		Enable('AnimEnd');
		ResetReactions();
		bCanConverse = True;
		bStasis = True;
		StopBlendAnims();
		SeekLevel = 0;
	}

Begin:
	WaitForLanding();
	PlayWaiting();
	if ((Weapon != None) && bKeepWeaponDrawn && (Weapon.CockingSound != None) && !bSeekPostCombat)
		PlaySound(Weapon.CockingSound, SLOT_None,,, 1024);
	Acceleration = vect(0,0,0);
	if (!PickDestination())
		Goto('DoneSeek');

GoToLocation:
	bInterruptSeek = true;
	Acceleration = vect(0,0,0);

	if ((DeusExWeapon(Weapon) != None) && DeusExWeapon(Weapon).CanReload() && !Weapon.IsInState('Reload'))
		DeusExWeapon(Weapon).ReloadAmmo();

	if (bSeekPostCombat)
		PlayPostAttackSearchingSound();
	else if (SeekType == SEEKTYPE_Sound)
		PlayPreAttackSearchingSound();
	else if (SeekType == SEEKTYPE_Sight)
	{
		if (ReactionLevel > 0.5)
			PlayPreAttackSightingSound();
	}
	else if ((SeekType == SEEKTYPE_Carcass) && bSeekLocation)
		PlayCarcassSound();

	StopBlendAnims();

	if ((SeekType == SEEKTYPE_Sight) && bSeekLocation)
		Goto('TurnToLocation');

	EnableCheckDestLoc(true);
	while (GetNextLocation(useLoc))
	{
		if (ShouldPlayWalk(useLoc))
			PlayRunning();
		MoveTo(useLoc, MaxDesiredSpeed);
		CheckDestLoc(useLoc);
	}
	EnableCheckDestLoc(false);

	if ((SeekType == SEEKTYPE_Guess) && bSeekLocation)
	{
		MoveTarget = GetOvershootDestination(0.5);
		if (MoveTarget != None)
		{
			if (ShouldPlayWalk(MoveTarget.Location))
				PlayRunning();
			MoveToward(MoveTarget, MaxDesiredSpeed);
		}

		if (AIPickRandomDestination(CollisionRadius*2, 200+FRand()*200, Rotation.Yaw, 0.75, Rotation.Pitch, 0.75, 2,
		                            0.4, useLoc))
		{
			if (ShouldPlayWalk(useLoc))
				PlayRunning();
			MoveTo(useLoc, MaxDesiredSpeed);
		}
	}

TurnToLocation:
	Acceleration = vect(0,0,0);
	PlayTurning();
	if ((SeekType == SEEKTYPE_Guess) && bSeekLocation)
		destLoc = Location + Vector(Rotation+(rot(0,1,0)*(Rand(16384)-8192)))*1000;
	if (bCanTurnHead)
	{
		Sleep(0);  // needed to turn head
		LookAtVector(destLoc, true, false, true);
		TurnTo(Vector(DesiredRotation)*1000+Location);
	}
	else
		TurnTo(destLoc);
	bSeekLocation = false;
	bInterruptSeek = false;

	PlayWaiting();
	Sleep(FRand()*1.5+3.0);

LookAround:
	if (bCanTurnHead)
	{
		if (FRand() < 0.5)
		{
			if (!bSeekLocation)
			{
				PlayTurnHead(LOOK_Left, 1.0, 1.0);
				Sleep(1.0);
			}
			if (!bSeekLocation)
			{
				PlayTurnHead(LOOK_Forward, 1.0, 1.0);
				Sleep(0.5);
			}
			if (!bSeekLocation)
			{
				PlayTurnHead(LOOK_Right, 1.0, 1.0);
				Sleep(1.0);
			}
		}
		else
		{
			if (!bSeekLocation)
			{
				PlayTurnHead(LOOK_Right, 1.0, 1.0);
				Sleep(1.0);
			}
			if (!bSeekLocation)
			{
				PlayTurnHead(LOOK_Forward, 1.0, 1.0);
				Sleep(0.5);
			}
			if (!bSeekLocation)
			{
				PlayTurnHead(LOOK_Left, 1.0, 1.0);
				Sleep(1.0);
			}
		}
		PlayTurnHead(LOOK_Forward, 1.0, 1.0);
		Sleep(0.5);
		StopBlendAnims();
	}
	else
	{
		if (!bSeekLocation)
			Sleep(1.0);
	}

FindAnotherPlace:
	SeekLevel--;
	if (PickDestination())
		Goto('GoToLocation');

DoneSeek:
	if (bSeekPostCombat)
		PlayTargetLostSound();
	else
		PlaySearchGiveUpSound();
	bSeekPostCombat = false;
	SeekPawn = None;
	if (Orders != 'Seeking')
		FollowOrders();
	else
		GotoState('Wandering');

ContinueSeek:
ContinueFromDoor:
	FinishAnim();
	Goto('FindAnotherPlace');

}


// ----------------------------------------------------------------------
// state Fleeing
//
// Run like a bat outta hell away from an actor.
// ----------------------------------------------------------------------

State Fleeing
{
	function ReactToInjury(Pawn instigatedBy, Name damageType, EHitLocation hitPos)
	{
		local Name currentState;
		local Pawn oldEnemy;
		local name newLabel;
		local bool bHateThisInjury;
		local bool bFearThisInjury;
		local bool bAttack;

		if ((health > 0) && (bLookingForInjury || bLookingForIndirectInjury))
		{
			currentState = GetStateName();

			bHateThisInjury = ShouldReactToInjuryType(damageType, bHateInjury, bHateIndirectInjury);
			bFearThisInjury = ShouldReactToInjuryType(damageType, bFearInjury, bFearIndirectInjury);

			if (bHateThisInjury)
				IncreaseAgitation(instigatedBy);
			if (bFearThisInjury)
				IncreaseFear(instigatedBy, 2.0);

			oldEnemy = Enemy;

			bAttack = false;
			if (SetEnemy(instigatedBy))
			{
				if (!ShouldFlee())
				{
					SwitchToBestWeapon();
					if (Weapon != None)
						bAttack = true;
				}
			}
			else
				SetEnemy(instigatedBy, , true);

			if (bAttack)
			{
				SetDistressTimer();
				SetNextState('HandlingEnemy');
			}
			else
			{
				SetDistressTimer();
				if (oldEnemy != Enemy)
					newLabel = 'Begin';
				else
					newLabel = 'ContinueFlee';
				SetNextState('Fleeing', newLabel);
			}
			GotoDisabledState(damageType, hitPos);
		}
	}

	function SetFall()
	{
		StartFalling('Fleeing', 'ContinueFlee');
	}

	function FinishFleeing()
	{
		if (bLeaveAfterFleeing)
			GotoState('Wandering');
		else
			FollowOrders();
	}

	function bool InSeat(out vector newLoc)  // hack
	{
		local Seat curSeat;
		local bool bSeat;

		bSeat = false;
		foreach RadiusActors(Class'Seat', curSeat, 200)
		{
			if (IsOverlapping(curSeat))
			{
				bSeat = true;
				newLoc = curSeat.Location + vector(curSeat.Rotation+Rot(0, -16384, 0))*(CollisionRadius+curSeat.CollisionRadius+20);
				break;
			}
		}

		return (bSeat);
	}

	function Tick(float deltaSeconds)
	{
		UpdateActorVisibility(Enemy, deltaSeconds, 1.0, false);
		if (IsValidEnemy(Enemy))
		{
			if (EnemyLastSeen > FearSustainTime)
				FinishFleeing();
		}
		else if (!IsValidEnemy(Enemy, false))
			FinishFleeing();
		else if (!IsFearful())
			FinishFleeing();
		Global.Tick(deltaSeconds);
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}
	
	function AnimEnd()
	{
		PlayWaiting();
	}

	function PickDestination()
	{
		local HidePoint      hidePoint;
		local Actor          waypoint;
		local float          dist;
		local float          score;
		local Vector         vector1, vector2;
		local Rotator        rotator1;
		local float          tmpDist;

		local float          bestDist;
		local float          bestScore;

		local FleeCandidates candidates[5];
		local int            candidateCount;
		local int            maxCandidates;

		local float          maxDist;
		local int            openSlot;
		local float          maxScore;
		local int            i;
		local bool           bReplace;

		local float          angle;
		local float          magnitude;
		local int            iterations;

		local NearbyProjectileList projList;
		local bool                 bSuccess;

		maxCandidates  = 3;  // must be <= size of candidates[] arrays
		maxDist        = 10000;

		// Initialize the list of candidates
		for (i=0; i<maxCandidates; i++)
		{
			candidates[i].score = -1;
			candidates[i].dist  = maxDist+1;
		}
		candidateCount = 0;

		MoveTarget = None;
		destPoint  = None;

		if (bAvoidHarm)
		{
			GetProjectileList(projList, Location);
			if (IsLocationDangerous(projList, Location))
			{
				vector1 = ComputeAwayVector(projList);
				rotator1 = Rotator(vector1);
				if (AIDirectionReachable(Location, rotator1.Yaw, rotator1.Pitch, CollisionRadius+24, VSize(vector1), destLoc))
					return;   // eck -- hack!!!
			}
		}

		if (Enemy != None)
		{
			foreach RadiusActors(Class'HidePoint', hidePoint, maxDist)
			{
				// Can the boogeyman see our hiding spot?
				if (!enemy.LineOfSightTo(hidePoint))
				{
					// More importantly, can we REACH our hiding spot?
					waypoint = GetNextWaypoint(hidePoint);
					if (waypoint != None)
					{
						// How far is it to the hiding place?
						dist = VSize(hidePoint.Location - Location);

						// Determine vectors to the waypoint and our enemy
						vector1 = enemy.Location - Location;
						vector2 = waypoint.Location - Location;

						// Strip out magnitudes from the vectors
						tmpDist = VSize(vector1);
						if (tmpDist > 0)
							vector1 /= tmpDist;
						tmpDist = VSize(vector2);
						if (tmpDist > 0)
							vector2 /= tmpDist;

						// Add them
						vector1 += vector2;

						// Compute a score (a function of angle)
						score = VSize(vector1);
						score = 4-(score*score);

						// Find an empty slot for this candidate
						openSlot  = -1;
						bestScore = score;
						bestDist  = dist;

						for (i=0; i<maxCandidates; i++)
						{
							// Can we replace the candidate in this slot?
							if (bestScore > candidates[i].score)
								bReplace = TRUE;
							else if ((bestScore == candidates[i].score) &&
							         (bestDist < candidates[i].dist))
								bReplace = TRUE;
							else
								bReplace = FALSE;
							if (bReplace)
							{
								bestScore = candidates[i].score;
								bestDist  = candidates[i].dist;
								openSlot = i;
							}
						}

						// We found an open slot -- put our candidate here
						if (openSlot >= 0)
						{
							candidates[openSlot].point    = hidePoint;
							candidates[openSlot].waypoint = waypoint;
							candidates[openSlot].location = waypoint.Location;
							candidates[openSlot].score    = score;
							candidates[openSlot].dist     = dist;
							if (candidateCount < maxCandidates)
								candidateCount++;
						}
					}
				}
			}

			// Any candidates?
			if (candidateCount > 0)
			{
				// Find a random candidate
				// (candidates moving AWAY from the enemy have a higher
				// probability of being chosen than candidates moving
				// TOWARDS the enemy)

				maxScore = 0;
				for (i=0; i<candidateCount; i++)
					maxScore += candidates[i].score;
				score = FRand() * maxScore;
				for (i=0; i<candidateCount; i++)
				{
					score -= candidates[i].score;
					if (score <= 0)
						break;
				}
				destPoint  = candidates[i].point;
				MoveTarget = candidates[i].waypoint;
				destLoc    = candidates[i].location;
			}
			else
			{
				iterations = 4;
				magnitude = 400*(FRand()*0.4+0.8);  // 400, +/-20%
				rotator1 = Rotator(Location-Enemy.Location);
				if (!AIPickRandomDestination(100, magnitude, rotator1.Yaw, 0.6, rotator1.Pitch, 0.6, iterations,
				                             FRand()*0.4+0.35, destLoc))
					destLoc = Location+(VRand()*1200);  // we give up
			}
		}
		else
			destLoc = Location+(VRand()*1200);  // we give up
	}

	function BeginState()
	{
		StandUp();
		Disable('AnimEnd');
		//Disable('Bump');
		BlockReactions();
		if (!bCower)
			bCanConverse = False;
		bStasis = False;
		SetupWeapon(false, true);
		SetDistress(true);
		EnemyReadiness = 1.0;
		//ReactionLevel  = 1.0;
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		Enable('AnimEnd');
		//Enable('Bump');
		ResetReactions();
		if (!bCower)
			bCanConverse = True;
		bStasis = True;
	}

Begin:
	//EnemyLastSeen = 0;
	destPoint = None;

Surprise:
	if ((1.0-ReactionLevel)*SurprisePeriod < 0.25)
		Goto('Flee');
	Acceleration=vect(0,0,0);
	PlaySurpriseSound();
	PlayWaiting();
	Sleep(FRand()*0.5);
	if (Enemy != None)
		TurnToward(Enemy);
	if (bCower)
		Goto('Flee');
	Sleep(FRand()*0.5+0.5);

Flee:
	if (bLeaveAfterFleeing)
	{
		bTransient = true;
		bDisappear = true;
	}
	if (bCower)
		Goto('Cower');
	WaitForLanding();
	PickDestination();

Moving:
	Sleep(0.0);

	if (enemy == None)
	{
		Acceleration = vect(0,0,0);
		PlayWaiting();
		Sleep(2.0);
		FinishFleeing();
	}

	// Move from pathnode to pathnode until we get where we're going
	if (destPoint != None)
	{
		EnableCheckDestLoc(true);
		while (MoveTarget != None)
		{
			if (ShouldPlayWalk(MoveTarget.Location))
				PlayRunning();
			MoveToward(MoveTarget, MaxDesiredSpeed);
			CheckDestLoc(MoveTarget.Location, true);
			if (enemy.bDetectable && enemy.AICanSee(destPoint, 1.0, false, false, false, true) > 0)
			{
				PickDestination();
				EnableCheckDestLoc(false);
				Goto('Moving');
			}
			if (MoveTarget == destPoint)
				break;
			MoveTarget = FindPathToward(destPoint);
		}
		EnableCheckDestLoc(false);
	}
	else if (PointReachable(destLoc))
	{
		if (ShouldPlayWalk(destLoc))
			PlayRunning();
		MoveTo(destLoc, MaxDesiredSpeed);
		if (enemy.bDetectable && enemy.AICanSee(Self, 1.0, false, false, true, true) > 0)
		{
			PickDestination();
			Goto('Moving');
		}
	}
	else
	{
		PickDestination();
		Goto('Moving');
	}

Pausing:
	Acceleration = vect(0,0,0);

	if (enemy != None)
	{
		if (HidePoint(destPoint) != None)
		{
			if (ShouldPlayTurn(Location + HidePoint(destPoint).faceDirection))
				PlayTurning();
			TurnTo(Location + HidePoint(destPoint).faceDirection);
		}
		Enable('AnimEnd');
		TweenToWaiting(0.2);
		while (AICanSee(enemy, 1.0, false, false, true, true) <= 0)
			Sleep(0.25);
		Disable('AnimEnd');
		FinishAnim();
	}

	Goto('Flee');

Cower:
	if (!InSeat(useLoc))
		Goto('CowerContinue');

	PlayRunning();
	MoveTo(useLoc, MaxDesiredSpeed);

CowerContinue:
	Acceleration = vect(0,0,0);
	PlayCowerBegin();
	FinishAnim();
	PlayCowering();

	// behavior 3 - cower and occasionally make short runs
	while (true)
	{
		Sleep(FRand()*3+6);

		PlayCowerEnd();
		FinishAnim();
		if (AIPickRandomDestination(60, 150, 0, 0, 0, 0,
		                            2, FRand()*0.3+0.6, useLoc))
		{
			if (ShouldPlayWalk(useLoc))
				PlayRunning();
			MoveTo(useLoc, MaxDesiredSpeed);
		}
		PlayCowerBegin();
		FinishAnim();
		PlayCowering();
	}

	/* behavior 2 - cower forever
	// don't stop cowering
	while (true)
		Sleep(1.0);
	*/

	/* behavior 1 - cower only when enemy watching
	if (enemy != None)
	{
		while (AICanSee(enemy, 1.0, false, false, true, true) > 0)
			Sleep(0.25);
	}
	PlayCowerEnd();
	FinishAnim();
	Goto('Pausing');
	*/

ContinueFlee:
ContinueFromDoor:
	FinishAnim();
	PlayRunning();
	if (bCower)
		Goto('Cower');
	else
		Goto('Moving');

}


// ----------------------------------------------------------------------
// state Attacking
//
// Kill!  Kill!  Kill!  Kill!
// ----------------------------------------------------------------------

State Attacking
{
	function ReactToInjury(Pawn instigatedBy, Name damageType, EHitLocation hitPos)
	{
		local Pawn oldEnemy;
		local bool bHateThisInjury;
		local bool bFearThisInjury;

		if ((health > 0) && (bLookingForInjury || bLookingForIndirectInjury))
		{
			oldEnemy = Enemy;

			bHateThisInjury = ShouldReactToInjuryType(damageType, bHateInjury, bHateIndirectInjury);
			bFearThisInjury = ShouldReactToInjuryType(damageType, bFearInjury, bFearIndirectInjury);

			if (bHateThisInjury)
				IncreaseAgitation(instigatedBy, 1.0);
			if (bFearThisInjury)
				IncreaseFear(instigatedBy, 2.0);

			if (ReadyForNewEnemy())
				SetEnemy(instigatedBy);

			if (ShouldFlee())
			{
				SetDistressTimer();
				PlayCriticalDamageSound();
				if (RaiseAlarm == RAISEALARM_BeforeFleeing)
					SetNextState('Alerting');
				else
					SetNextState('Fleeing');
			}
			else
			{
				SetDistressTimer();
				if (oldEnemy != Enemy)
					PlayNewTargetSound();
				SetNextState('Attacking', 'ContinueAttack');
			}
			GotoDisabledState(damageType, hitPos);
		}
	}

	function SetFall()
	{
		StartFalling('Attacking', 'ContinueAttack');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function Reloading(DeusExWeapon reloadWeapon, float reloadTime)
	{
		Global.Reloading(reloadWeapon, reloadTime);
		if (bReadyToReload)
			if (IsWeaponReloading())
				if (!IsHandToHand())
					TweenToShoot(0);
	}

	function EDestinationType PickDestination()
	{
		local vector               distVect;
		local vector               tempVect;
		local rotator              enemyDir;
		local float                magnitude;
		local float                calcMagnitude;
		local int                  iterations;
		local EDestinationType     destType;
		local NearbyProjectileList projList;

		destPoint = None;
		destLoc   = vect(0, 0, 0);
		destType  = DEST_Failure;

		if (enemy == None)
			return (destType);

		if (bCrouching && (CrouchTimer > 0))
			destType = DEST_SameLocation;

		if (destType == DEST_Failure)
		{
			if (AICanShoot(enemy, true, false, 0.025) || ActorReachable(enemy))
			{
				destType = ComputeBestFiringPosition(tempVect);
				if (destType == DEST_NewLocation)
					destLoc = tempVect;
			}
		}

		if (destType == DEST_Failure)
		{
			MoveTarget = FindPathToward(enemy);
			if (MoveTarget != None)
			{
				if (!bDefendHome || IsNearHome(MoveTarget.Location))
				{
					if (bAvoidHarm)
						GetProjectileList(projList, MoveTarget.Location);
					if (!bAvoidHarm || !IsLocationDangerous(projList, MoveTarget.Location))
					{
						destPoint = MoveTarget;
						destType  = DEST_NewLocation;
					}
				}
			}
		}

		// Default behavior, so they don't just stand there...
		if (destType == DEST_Failure)
		{
			enemyDir = Rotator(Enemy.Location - Location);
			if (AIPickRandomDestination(60, 150,
			                            enemyDir.Yaw, 0.5, enemyDir.Pitch, 0.5, 
			                            2, FRand()*0.4+0.35, tempVect))
			{
				if (!bDefendHome || IsNearHome(tempVect))
				{
					destType = DEST_NewLocation;
					destLoc  = tempVect;
				}
			}
		}

		return (destType);
	}

	function bool FireIfClearShot()
	{
		local DeusExWeapon dxWeapon;

		dxWeapon = DeusExWeapon(Weapon);
		if (dxWeapon != None)
		{
			if ((dxWeapon.AIFireDelay > 0) && (FireTimer > 0))
				return false;
			else if (AICanShoot(enemy, true, true, 0.025))
			{
				Weapon.Fire(0);
				FireTimer = dxWeapon.AIFireDelay;
				return true;
			}
			else
				return false;
		}
		else
			return false;
	}

	function CheckAttack(bool bPlaySound)
	{
		local bool bCriticalDamage;
		local bool bOutOfAmmo;
		local Pawn oldEnemy;
		local bool bAllianceSwitch;

		oldEnemy = enemy;

		bAllianceSwitch = false;
		if (!IsValidEnemy(enemy))
		{
			if (IsValidEnemy(enemy, false))
				bAllianceSwitch = true;
			SetEnemy(None, 0, true);
		}

		if (enemy == None)
		{
			if (Orders == 'Attacking')
			{
				FindOrderActor();
				SetEnemy(Pawn(OrderActor), 0, true);
			}
		}
		if (ReadyForNewEnemy())
			FindBestEnemy(false);
		if (enemy == None)
		{
			Enemy = oldEnemy;  // hack
			if (bPlaySound)
			{
				if (bAllianceSwitch)
					PlayAllianceFriendlySound();
				else
					PlayAreaSecureSound();
			}
			Enemy = None;
			if (Orders != 'Attacking')
				FollowOrders();
			else
				GotoState('Wandering');
			return;
		}

		SwitchToBestWeapon();
		if (bCrouching && (CrouchTimer <= 0) && !ShouldCrouch())
		{
			EndCrouch();
			TweenToShoot(0.15);
		}
		bCriticalDamage = False;
		bOutOfAmmo      = False;
		if (ShouldFlee())
			bCriticalDamage = True;
		else if (Weapon == None)
			bOutOfAmmo = True;
		else if (Weapon.ReloadCount > 0)
		{
			if (Weapon.AmmoType == None)
				bOutOfAmmo = True;
			else if (Weapon.AmmoType.AmmoAmount < 1)
				bOutOfAmmo = True;
		}
		if (bCriticalDamage || bOutOfAmmo)
		{
			if (bPlaySound)
			{
				if (bCriticalDamage)
					PlayCriticalDamageSound();
				else if (bOutOfAmmo)
					PlayOutOfAmmoSound();
			}
			if (RaiseAlarm == RAISEALARM_BeforeFleeing)
				GotoState('Alerting');
			else
				GotoState('Fleeing');
		}
		else if (bPlaySound && (oldEnemy != Enemy))
			PlayNewTargetSound();
	}

	function Tick(float deltaSeconds)
	{
		local bool   bCanSee;
		local float  yaw;
		local vector lastLocation;
		local Pawn   lastEnemy;
		local float  surpriseTime;

		Global.Tick(deltaSeconds);
		if (CrouchTimer > 0)
		{
			CrouchTimer -= deltaSeconds;
			if (CrouchTimer < 0)
				CrouchTimer = 0;
		}
		EnemyTimer += deltaSeconds;
		UpdateActorVisibility(Enemy, deltaSeconds, 1.0, false);
		if ((Enemy != None) && HasEnemyTimedOut())
		{
			lastLocation = Enemy.Location;
			lastEnemy    = Enemy;
			FindBestEnemy(true);
			if (Enemy == None)
			{
				SetSeekLocation(lastEnemy, lastLocation, SEEKTYPE_Guess, true);
				GotoState('Seeking');
			}
		}
		else if (bCanFire && (Enemy != None))
		{
			ViewRotation = Rotator(Enemy.Location-Location);
			if (bFacingTarget)
				FireIfClearShot();
			else if (!bMustFaceTarget)
			{
				yaw = (ViewRotation.Yaw-Rotation.Yaw) & 0xFFFF;
				if (yaw >= 32768)
					yaw -= 65536;
				yaw = Abs(yaw)*360/32768;  // 0-180 x 2
				if (yaw <= FireAngle)
					FireIfClearShot();
			}
		}
		//UpdateReactionLevel(true, deltaSeconds);
	}

	function bool IsHandToHand()
	{
		if (Weapon != None)
		{
			if (DeusExWeapon(Weapon) != None)
			{
				if (DeusExWeapon(Weapon).bHandToHand)
					return true;
				else
					return false;
			}
			else
				return false;
		}
		else
			return false;
	}

	function bool ReadyForWeapon()
	{
		local bool bReady;

		bReady = false;
		if (DeusExWeapon(weapon) != None)
		{
			if (DeusExWeapon(weapon).bReadyToFire)
				if (!IsWeaponReloading())
					bReady = true;
		}
		if (!bReady)
			if (enemy == None)
				bReady = true;
		if (!bReady)
			if (!AICanShoot(enemy, true, false, 0.025))
				bReady = true;

		return (bReady);
	}

	function bool ShouldCrouch()
	{
		if (bCanCrouch && !Region.Zone.bWaterZone && !IsHandToHand() &&
		    ((enemy != None) && (VSize(enemy.Location-Location) > 300)) &&
		    ((DeusExWeapon(Weapon) == None) || DeusExWeapon(Weapon).bUseWhileCrouched))
			return true;
		else
			return false;
	}

	function StartCrouch()
	{
		if (!bCrouching)
		{
			bCrouching = true;
			SetBasedPawnSize(CollisionRadius, GetCrouchHeight());
			CrouchTimer = 1.0+FRand()*0.5;
		}
	}

	function EndCrouch()
	{
		if (bCrouching)
		{
			bCrouching = false;
			ResetBasedPawnSize();
		}
	}

	function BeginState()
	{
		StandUp();

		// hack
		if (MaxRange < MinRange+10)
			MaxRange = MinRange+10;
		bCanFire      = false;
		bFacingTarget = false;

		SwitchToBestWeapon();

		//EnemyLastSeen = 0;
		BlockReactions();
		bCanConverse = False;
		bAttacking = True;
		bStasis = False;
		SetDistress(true);

		CrouchTimer = 0;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bCanFire      = false;
		bFacingTarget = false;

		ResetReactions();
		bCanConverse = True;
		bAttacking = False;
		bStasis = True;
		bReadyToReload = false;

		EndCrouch();
	}

Begin:
	if (Enemy == None)
		GotoState('Seeking');
	//EnemyLastSeen = 0;
	CheckAttack(false);

Surprise:
	if ((1.0-ReactionLevel)*SurprisePeriod < 0.25)
		Goto('BeginAttack');
	Acceleration=vect(0,0,0);
	PlaySurpriseSound();
	PlayWaiting();
	while (ReactionLevel < 1.0)
	{
		TurnToward(Enemy);
		Sleep(0);
	}

BeginAttack:
	EnemyReadiness = 1.0;
	ReactionLevel  = 1.0;
	if (PlayerAgitationTimer > 0)
		PlayAllianceHostileSound();
	else
		PlayTargetAcquiredSound();
	if (PlayBeginAttack())
	{
		Acceleration = vect(0,0,0);
		TurnToward(enemy);
		FinishAnim();
	}

RunToRange:
	bCanFire       = false;
	bFacingTarget  = false;
	bReadyToReload = false;
	EndCrouch();
	if (Physics == PHYS_Falling)
		TweenToRunning(0.05);
	WaitForLanding();
	if (!IsWeaponReloading() || bCrouching)
	{
		if (ShouldPlayTurn(Enemy.Location))
			PlayTurning();
		TurnToward(enemy);
	}
	else
		Sleep(0);
	bCanFire = true;
	while (PickDestination() == DEST_NewLocation)
	{
		if (bCanStrafe && ShouldStrafe())
		{
			PlayRunningAndFiring();
			if (destPoint != None)
				StrafeFacing(destPoint.Location, enemy);
			else
				StrafeFacing(destLoc, enemy);
			bFacingTarget = true;
		}
		else
		{
			bFacingTarget = false;
			PlayRunning();
			if (destPoint != None)
				MoveToward(destPoint, MaxDesiredSpeed);
			else
				MoveTo(destLoc, MaxDesiredSpeed);
		}
		CheckAttack(true);
	}

Fire:
	bCanFire      = false;
	bFacingTarget = false;
	Acceleration = vect(0, 0, 0);

	SwitchToBestWeapon();
	if (FRand() > 0.5)
		bUseSecondaryAttack = true;
	else
		bUseSecondaryAttack = false;
	if (IsHandToHand())
		TweenToAttack(0.15);
	else if (ShouldCrouch() && (FRand() < CrouchRate))
	{
		TweenToCrouchShoot(0.15);
		FinishAnim();
		StartCrouch();
	}
	else
		TweenToShoot(0.15);
	if (!IsWeaponReloading() || bCrouching)
		TurnToward(enemy);
	FinishAnim();
	bReadyToReload = true;

ContinueFire:
	while (!ReadyForWeapon())
	{
		if (PickDestination() != DEST_SameLocation)
			Goto('RunToRange');
		CheckAttack(true);
		if (!IsWeaponReloading() || bCrouching)
			TurnToward(enemy);
		else
			Sleep(0);
	}
	CheckAttack(true);
	if (!FireIfClearShot())
		Goto('ContinueAttack');
	bReadyToReload = false;
	if (bCrouching)
		PlayCrouchShoot();
	else if (IsHandToHand())
		PlayAttack();
	else
		PlayShoot();
	FinishAnim();
	if (FRand() > 0.5)
		bUseSecondaryAttack = true;
	else
		bUseSecondaryAttack = false;
	bReadyToReload = true;
	if (!IsHandToHand())
	{
		if (bCrouching)
			TweenToCrouchShoot(0);
		else
			TweenToShoot(0);
	}
	CheckAttack(true);
	if (PickDestination() != DEST_NewLocation)
	{
		if (!IsWeaponReloading() || bCrouching)
			TurnToward(enemy);
		else
			Sleep(0);
		Goto('ContinueFire');
	}
	Goto('RunToRange');

ContinueAttack:
ContinueFromDoor:
	CheckAttack(true);
	if (PickDestination() != DEST_NewLocation)
		Goto('Fire');
	else
		Goto('RunToRange');

}


// ----------------------------------------------------------------------
// state Alerting
//
// Warn other NPCs that an enemy is about
// ----------------------------------------------------------------------

State Alerting
{
	function SetFall()
	{
		StartFalling('Alerting', 'ContinueAlert');
	}

	function Tick(float deltaSeconds)
	{
		Global.Tick(deltaSeconds);
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function Bump(actor bumper)
	{
		if (bAcceptBump)
		{
			if (bumper == AlarmActor)
			{
				bAcceptBump = False;
				GotoState('Alerting', 'SoundAlarm');
			}
		}

		// Handle conversations, if need be
		Global.Bump(bumper);
	}

	function bool IsAlarmReady(Actor actorAlarm)
	{
		local bool      bReady;
		local AlarmUnit alarm;

		bReady = false;
		alarm = AlarmUnit(actorAlarm);
		if ((alarm != None) && !alarm.bDeleteMe)
			if (!alarm.bActive)
				if ((alarm.associatedPawn == None) ||
				    (alarm.associatedPawn == self))
					bReady = true;

		return bReady;
	}

	function TriggerAlarm()
	{
		if ((AlarmActor != None) && !AlarmActor.bDeleteMe)
		{
			if (AlarmActor.hackStrength > 0)  // make sure the alarm hasn't been hacked
				AlarmActor.Trigger(self, Enemy);
		}
	}

	function bool IsAlarmInRange(AlarmUnit alarm)
	{
		local bool bInRange;

		bInRange = false;
		if ((alarm != None) && !alarm.bDeleteMe)
			if ((VSize((alarm.Location-Location)*vect(1,1,0)) <
			     (CollisionRadius+alarm.CollisionRadius+24)) &&
			    (Abs(alarm.Location.Z-Location.Z) < (CollisionHeight+alarm.CollisionHeight)))
				bInRange = true;

		return (bInRange);
	}

	function vector FindAlarmPosition(Actor alarm)
	{
		local vector alarmPos;

		alarmPos = alarm.Location;
		alarmPos += vector(alarm.Rotation.Yaw*rot(0,1,0))*(CollisionRadius+alarm.CollisionRadius);

		return (alarmPos);
	}

	function bool GetNextAlarmPoint(AlarmUnit alarm)
	{
		local vector alarmPoint;
		local bool   bValid;

		destPoint = None;
		destLoc   = vect(0,0,0);
		bValid    = false;

		if ((alarm != None) && !alarm.bDeleteMe)
		{
			alarmPoint = FindAlarmPosition(alarm);
			if (PointReachable(alarmPoint))
			{
				destLoc = alarmPoint;
				bValid = true;
			}
			else
			{
				MoveTarget = FindPathTo(alarmPoint);
				if (MoveTarget != None)
				{
					destPoint = MoveTarget;
					bValid = true;
				}
			}
		}

		return (bValid);
	}

	function AlarmUnit FindTarget()
	{
		local ScriptedPawn pawnAlly;
		local AlarmUnit    alarm;
		local float        dist;
		local AlarmUnit    bestAlarm;
		local float        bestDist;

		bestAlarm = None;

		// Do we have any allies on this level?
		foreach AllActors(Class'ScriptedPawn', pawnAlly)
			if (GetPawnAllianceType(pawnAlly) == ALLIANCE_Friendly)
				break;

		// Yes, so look for an alarm box that isn't active...
		if (pawnAlly != None)
		{
			foreach RadiusActors(Class'AlarmUnit', alarm, 2400)
			{
				if (GetAllianceType(alarm.Alliance) != ALLIANCE_Hostile)
				{
					dist = VSize((Location-alarm.Location)*vect(1,1,2));  // use squished sphere
					if ((bestAlarm == None) || (dist < bestDist))
					{
						bestAlarm = alarm;
						bestDist  = dist;
					}
				}
			}

			// Is the nearest alarm already going off?  And can we reach it?
			if (!IsAlarmReady(bestAlarm) || !GetNextAlarmPoint(bestAlarm))
				bestAlarm = None;
		}

		// Return our target alarm box
		return (bestAlarm);
	}

	function bool PickDestination()
	{
		local bool      bDest;
		local AlarmUnit alarm;

		// Init
		destPoint = None;
		destLoc   = vect(0, 0, 0);
		bDest     = false;

		// Find an alarm we can trigger
		alarm = FindTarget();
		if (alarm != None)
		{
			// Find a way to get there
			AlarmActor = alarm;
			alarm.associatedPawn = self;
			bDest = true;  // if alarm != none, we've already computed the route to the alarm
		}

		// Return TRUE if we were successful
		return (bDest);
	}

	function BeginState()
	{
		StandUp();
		//Disable('AnimEnd');
		bAcceptBump = False;
		bCanConverse = False;
		AlarmActor = None;
		bStasis = False;
		BlockReactions();
		SetupWeapon(false);
		SetDistress(false);
		EnemyReadiness = 1.0;
		ReactionLevel  = 1.0;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		ResetReactions();
		bAcceptBump = False;
		//Enable('AnimEnd');
		bCanConverse = True;
		if (AlarmActor != None)
			if (AlarmActor.associatedPawn == self)
				AlarmActor.associatedPawn = None;
		AlarmActor = None;
		bStasis = True;
	}

Begin:
	if (Enemy == None)
		GotoState('Seeking');
	//EnemyLastSeen = 0;
	destPoint = None;
	if (RaiseAlarm == RAISEALARM_Never)
		GotoState('Fleeing');
	if (AlarmTimer > 0)
		PlayGoingForAlarmSound();

Alert:
	if (AlarmTimer > 0)
		Goto('Done');

	WaitForLanding();
	if (!PickDestination())
		Goto('Done');

Moving:
	// Can we go somewhere?
	bAcceptBump = True;
	EnableCheckDestLoc(true);
	while (true)
	{
		if (destPoint != None)
		{
			if (ShouldPlayWalk(MoveTarget.Location))
				PlayRunning();
			MoveToward(MoveTarget, MaxDesiredSpeed);
			CheckDestLoc(MoveTarget.Location, true);
		}
		else
		{
			if (ShouldPlayWalk(destLoc))
				PlayRunning();
			MoveTo(destLoc, MaxDesiredSpeed);
			CheckDestLoc(destLoc);
		}
		if (IsAlarmInRange(AlarmActor))
			break;
		else if (!GetNextAlarmPoint(AlarmActor))
			break;
	}
	EnableCheckDestLoc(false);

SoundAlarm:
	Acceleration=vect(0,0,0);
	bAcceptBump = False;
	if (IsAlarmInRange(AlarmActor))
	{
		TurnToward(AlarmActor);
		PlayPushing();
		FinishAnim();
		TriggerAlarm();
	}

Done:
	bAcceptBump = False;
	if (RaiseAlarm == RAISEALARM_BeforeAttacking)
		GotoState('Attacking');
	else
		GotoState('Fleeing');

ContinueAlert:
ContinueFromDoor:
	Goto('Alert');

}


// ----------------------------------------------------------------------
// state Shadowing
//
// Quietly tail another character
// ----------------------------------------------------------------------

State Shadowing
{
	function SetFall()
	{
		StartFalling('Shadowing', 'ContinueShadow');
	}

	function Tick(float deltaSeconds)
	{
		local bool  bMove;
		local float deltaValue;

		Global.Tick(deltaSeconds);

		deltaValue = deltaSeconds;

		// If we're running, and we can see our target, STOP RUNNING!
		if (bRunningStealthy)
		{
			UpdateActorVisibility(orderActor, deltaValue, 0.0, false);
			deltaValue = 0;
			if (EnemyLastSeen <= 0)
			{
				bRunningStealthy = False;
				PlayWalking();
				DesiredSpeed = GetWalkingSpeed();
			}
		}

		// Are we stopped?
		if (bPausing)
		{
			// Can we see our target?
			bMove = False;
			UpdateActorVisibility(orderActor, deltaValue, 0.5, false);
			deltaValue = 0;

			// No -- move toward him!
			if (EnemyLastSeen > 0.5)
				bMove = True;

			// We can see him, and we're staring...
			else if (bStaring)
			{
				// ...can he see us staring at him?
				if ((Pawn(orderActor) != None) &&
				    (Pawn(orderActor).AICanSee(self, , false, true, false, false) > 0))
					bMove = True;  // Time to look inconspicuous
			}

			// Move if we need to
			if (bMove)
			{
				if (bStaring)
					GotoState('Shadowing', 'StopStaring');
				else
					GotoState('Shadowing', 'StopPausing');
				bPausing = False;
				bStaring = False;
			}
		}
	}

	function Bump(actor bumper)
	{
		if (bAcceptBump)
		{
			// If we get bumped by another actor while we wait, start wandering again
			bAcceptBump = False;
			bPausing = False;
			bStaring = False;
			Disable('AnimEnd');
			GotoState('Shadowing', 'Shadow');
		}

		// Handle conversations, if need be
		Global.Bump(bumper);
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function float DistanceToTarget()
	{
		return (VSize(Location-orderActor.Location));
	}

	function bool PickDestination()
	{
		local Actor   destActor;
		local Vector  distVect;
		local Rotator relativeRotation;
		local float   magnitude;
		local float   minDist;
		local float   maxDist;
		local float   bestDist;
		local bool    bDest;
		local float   dist;

		// Init
		destPoint = None;
		destLoc   = vect(0, 0, 0);

		// Conveniences
		destActor = orderActor;
		minDist   = 400;
		maxDist   = 700;
		bestDist  = (maxDist+minDist)*0.5;

		distVect  = Location - destActor.Location;
		magnitude = VSize(distVect);

		bDest = False;

		// Can we see the target?
		if (AICanSee(destActor, , false, false, false, true) > 0)
		{
			relativeRotation = Rotator(distVect);

			// How far will we go?
			dist = (wanderlust*300+150) * (FRand()*0.2+0.9); // 150-450, +/-10%

			// Move around inconspicuously, like we're just wandering
			if (magnitude < minDist)  // too close -- move away
				bDest = AIPickRandomDestination(100, dist,
				                                relativeRotation.Yaw, 0.8, relativeRotation.Pitch, 0.8,
				                                3, FRand()*0.4+0.35, destLoc);

			else if (magnitude < maxDist)  // just right -- move normally
				bDest = AIPickRandomDestination(100, dist,
				                                relativeRotation.Yaw+32768, 0, -relativeRotation.Pitch, 0,
				                                2, FRand()*0.4+0.35, destLoc);

			else  // too far -- move closer
				bDest = AIPickRandomDestination(100, dist,
				                                relativeRotation.Yaw+32768, 0.8, -relativeRotation.Pitch, 0.8,
				                                3, FRand()*0.4+0.35, destLoc);
		}

		// Nope -- find a path towards him
		else
		{
			MoveTarget = FindPathToward(destActor);
			if (MoveTarget != None)
			{
				if (!MoveTarget.Region.Zone.bWaterZone && (MoveTarget.Physics != PHYS_Falling))
				{
					destPoint = MoveTarget;
					bDest = True;
				}
			}
		}

		// Return TRUE if we found a place to go
		return (bDest);

	}

	function BeginState()
	{
		StandUp();
		Disable('AnimEnd');
		bRunningStealthy = False;
		bPausing = False;
		bStaring = False;
		bStasis = False;
		SetupWeapon(false);
		SetDistress(false);
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bAcceptBump = False;
		Enable('AnimEnd');
		bRunningStealthy = False;
		bPausing = False;
		bStaring = False;
		bStasis = True;
	}

Begin:
	EnemyLastSeen = 0;
	destPoint = None;

Shadow:
	WaitForLanding();

Moving:
	Sleep(0.0);

	// Can we go somewhere?
	if (PickDestination())
	{
		// Are we going to a navigation point?
		if (destPoint != None)
		{
			if (MoveTarget != None)
			{
				// Run if we're too far away, and we can't see our target
				if ((DistanceToTarget() > 900) &&
				    (AICanSee(orderActor, , false, true, true, true) <= 0))
				{
					bRunningStealthy = True;
					if (ShouldPlayWalk(MoveTarget.Location))
						PlayRunning();
					MoveToward(MoveTarget, MaxDesiredSpeed);
				}

				// Otherwise, walk nonchalantly
				else
				{
					bRunningStealthy = False;
					if (ShouldPlayWalk(MoveTarget.Location))
						PlayWalking();
					MoveToward(MoveTarget, GetWalkingSpeed());
				}
			}
		}

		// No pathnode, so walk to a point
		else
		{
			bRunningStealthy = False;
			if (ShouldPlayWalk(destLoc))
				PlayWalking();
			MoveTo(destLoc, GetWalkingSpeed());
		}
	}

	// Can we see the target?  If not, keep walking
	if (AICanSee(orderActor, , false, false, false, true) <= 0)
		Goto('Moving');

Pausing:
	// Stop
	bRunningStealthy = False;
	Acceleration = vect(0, 0, 0);

	// Can the target see us?  If not, stare!
	if (orderActor.IsA('Pawn') && Pawn(orderActor).AICanSee(self, , false, true, false, false) <= 0)
		Goto('Staring');

	// Stop normally
	sleepTime = 6.0;
	Enable('AnimEnd');
	TweenToWaiting(0.2);
	bAcceptBump = True;
	sleepTime *= (-0.9*restlessness) + 1;
	bStaring = False;
	bPausing = True;
	Sleep(sleepTime);

StopPausing:
	// Time to move again
	bPausing = False;
	bStaring = False;
	Disable('AnimEnd');
	bAcceptBump = False;
	FinishAnim();
	Goto('Shadow');

Staring:
	// Stare at the target
	PlayTurning();
	TurnToward(orderActor);

	Enable('AnimEnd');
	TweenToWaiting(0.2);

	// Don't move 'til he looks at us
	bAcceptBump = True;
	bStaring = True;
	bPausing = True;
	while (true)
	{
		PlayTurning();
		TurnToward(orderActor);
		TweenToWaiting(0.2);
		Sleep(0.25);
	}

StopStaring:
	// He's looking, or we can't see him -- time to move
	bPausing = False;
	bStaring = False;
	Disable('AnimEnd');
	bAcceptBump = False;
	FinishAnim();
	Goto('Shadow');

ContinueShadow:
ContinueFromDoor:
	FinishAnim();
	PlayRunning();
	Goto('Moving');
}


// ----------------------------------------------------------------------
// state Following
//
// Follow an actor
// ----------------------------------------------------------------------

state Following
{
	function SetFall()
	{
		StartFalling('Following', 'ContinueFollow');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function Tick(float deltaSeconds)
	{
		Global.Tick(deltaSeconds);

		if (BackpedalTimer >= 0)
			BackpedalTimer += deltaSeconds;

		animTimer[1] += deltaSeconds;
		if ((Physics == PHYS_Walking) && (orderActor != None))
		{
			if (Acceleration == vect(0,0,0))
				LookAtActor(orderActor, true, true, true, 0, 0.25);
			else
				PlayTurnHead(LOOK_Forward, 1.0, 0.25);
		}
	}

	function bool PickDestination()
	{
		local float   dist;
		local float   extra;
		local float   distMax;
		local int     dir;
		local rotator rot;
		local bool    bSuccess;

		bSuccess = false;
		destPoint = None;
		destLoc   = vect(0, 0, 0);
		extra = orderActor.CollisionRadius + CollisionRadius;
		dist = VSize(orderActor.Location - Location);
		dist -= extra;
		if (dist < 0)
			dist = 0;

		if ((dist > 180) || (AICanSee(orderActor, , false, false, false, true) <= 0))
		{
			if (ActorReachable(orderActor))
			{
				rot = Rotator(orderActor.Location - Location);
				distMax = (dist-180)+45;
				if (distMax > 80)
					distMax = 80;
				bSuccess = AIDirectionReachable(Location, rot.Yaw, rot.Pitch, 0, distMax, destLoc);
			}
			else
			{
				MoveTarget = FindPathToward(orderActor);
				if (MoveTarget != None)
				{
					destPoint = MoveTarget;
					bSuccess = true;
				}
			}
			BackpedalTimer = -1;
		}
		else if (dist < 60)
		{
			if (BackpedalTimer < 0)
				BackpedalTimer = 0;
			if (BackpedalTimer > 1.0)  // give the player enough time to converse, if he wants to
			{
				rot = Rotator(Location - orderActor.Location);
				bSuccess = AIDirectionReachable(orderActor.Location, rot.Yaw, rot.Pitch, 60+extra, 120+extra, destLoc);
			}
		}
		else
			BackpedalTimer = -1;

		return (bSuccess);
	}

	function BeginState()
	{
		StandUp();
		//Disable('AnimEnd');
		bStasis = False;
		SetupWeapon(false);
		SetDistress(false);
		BackpedalTimer = -1;
		SeekPawn = None;
		EnableCheckDestLoc(true);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bAcceptBump = False;
		//Enable('AnimEnd');
		bStasis = True;
		StopBlendAnims();
	}

Begin:
	Acceleration = vect(0, 0, 0);
	destPoint = None;
	if (orderActor == None)
		GotoState('Standing');

	if (!PickDestination())
		Goto('Wait');

Follow:
	if (destPoint != None)
	{
		if (MoveTarget != None)
		{
			if (ShouldPlayWalk(MoveTarget.Location))
				PlayRunning();
			MoveToward(MoveTarget, MaxDesiredSpeed);
			CheckDestLoc(MoveTarget.Location, true);
		}
		else
			Sleep(0.0);  // this shouldn't happen
	}
	else
	{
		if (ShouldPlayWalk(destLoc))
			PlayRunning();
		MoveTo(destLoc, MaxDesiredSpeed);
		CheckDestLoc(destLoc);
	}
	if (PickDestination())
		Goto('Follow');

Wait:
	//PlayTurning();
	//TurnToward(orderActor);
	PlayWaiting();

WaitLoop:
	Acceleration=vect(0,0,0);
	Sleep(0.0);
	if (!PickDestination())
		Goto('WaitLoop');
	else
		Goto('Follow');

ContinueFollow:
ContinueFromDoor:
	Acceleration=vect(0,0,0);
	if (PickDestination())
		Goto('Follow');
	else
		Goto('Wait');

}


// ----------------------------------------------------------------------
// state WaitingFor
//
// Wait for a pawn to become visible, then move to it
// ----------------------------------------------------------------------

state WaitingFor
{
	function SetFall()
	{
		StartFalling('WaitingFor', 'ContinueFollow');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function Bump(actor bumper)
	{
		// If we hit the guy we're going to, end the state
		if (bumper == OrderActor)
			GotoState('WaitingFor', 'Done');

		// Handle conversations, if need be
		Global.Bump(bumper);
	}

	function Touch(actor toucher)
	{
		// If we hit the guy we're going to, end the state
		if (toucher == OrderActor)
			GotoState('WaitingFor', 'Done');

		// Handle conversations, if need be
		Global.Touch(toucher);
	}

	function BeginState()
	{
		StandUp();
		//BlockReactions();
		SetupWeapon(false);
		SetDistress(false);
		bStasis = True;
		SeekPawn = None;
		EnableCheckDestLoc(true);
	}
	function EndState()
	{
		EnableCheckDestLoc(false);
		//ResetReactions();
		bStasis = True;
	}

Begin:
	Acceleration = vect(0, 0, 0);
	if (orderActor == None)
		GotoState('Idle');
	PlayWaiting();

Wait:
	Sleep(1.0);
	if (AICanSee(orderActor, 1.0, false, true, false, true) <= 0)
		Goto('Wait');
	bStasis = False;

Follow:
	if (IsOverlapping(orderActor))
		Goto('Done');
	MoveTarget = GetNextWaypoint(orderActor);
	if ((MoveTarget != None) && (!MoveTarget.Region.Zone.bWaterZone) &&
	    (MoveTarget.Physics != PHYS_Falling))
	{
		if ((MoveTarget == orderActor) && MoveTarget.IsA('Pawn'))
		{
			if (GetNextVector(orderActor, useLoc))
			{
				if (ShouldPlayWalk(useLoc))
					PlayRunning();
				MoveTo(useLoc, MaxDesiredSpeed);
				CheckDestLoc(useLoc);
			}
			else
				Goto('Pause');
		}
		else
		{
			if (ShouldPlayWalk(MoveTarget.Location))
				PlayRunning();
			MoveToward(MoveTarget, MaxDesiredSpeed);
			CheckDestLoc(MoveTarget.Location, true);
		}
		if (IsOverlapping(orderActor))
			Goto('Done');
		else
			Goto('Follow');
	}

Pause:
	Acceleration = vect(0, 0, 0);
	TurnToward(orderActor);
	PlayWaiting();
	Sleep(1.0);
	Goto('Follow');

Done:
	GotoState('Standing');

ContinueFollow:
ContinueFromDoor:
	PlayRunning();
	Goto('Follow');
}


// ----------------------------------------------------------------------
// state GoingTo
//
// Move to an actor.
// ----------------------------------------------------------------------

state GoingTo
{
	function SetFall()
	{
		StartFalling('GoingTo', 'ContinueGo');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function Bump(actor bumper)
	{
		// If we hit the guy we're going to, end the state
		if (bumper == OrderActor)
			GotoState('GoingTo', 'Done');

		// Handle conversations, if need be
		Global.Bump(bumper);
	}

	function Touch(actor toucher)
	{
		// If we hit the guy we're going to, end the state
		if (toucher == OrderActor)
			GotoState('GoingTo', 'Done');

		// Handle conversations, if need be
		Global.Touch(toucher);
	}

	function BeginState()
	{
		StandUp();
		//BlockReactions();
		SetupWeapon(false);
		SetDistress(false);
		bStasis = False;
		SeekPawn = None;
		EnableCheckDestLoc(true);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		//ResetReactions();
		bStasis = True;
	}

Begin:
	Acceleration = vect(0, 0, 0);
	if (orderActor == None)
		Goto('Done');

Follow:
	if (IsOverlapping(orderActor))
		Goto('Done');
	MoveTarget = GetNextWaypoint(orderActor);
	if ((MoveTarget != None) && (!MoveTarget.Region.Zone.bWaterZone) &&
	    (MoveTarget.Physics != PHYS_Falling))
	{
		if ((MoveTarget == orderActor) && MoveTarget.IsA('Pawn'))
		{
			if (GetNextVector(orderActor, useLoc))
			{
				if (ShouldPlayWalk(useLoc))
					PlayWalking();
				MoveTo(useLoc, GetWalkingSpeed());
				CheckDestLoc(useLoc);
			}
			else
				Goto('Pause');
		}
		else
		{
			if (ShouldPlayWalk(MoveTarget.Location))
				PlayWalking();
			MoveToward(MoveTarget, GetWalkingSpeed());
			CheckDestLoc(MoveTarget.Location, true);
		}
		if (IsOverlapping(orderActor))
			Goto('Done');
		else
			Goto('Follow');
	}

Pause:
	Acceleration = vect(0, 0, 0);
	TurnToward(orderActor);
	PlayWaiting();
	Sleep(1.0);
	Goto('Follow');

Done:
	if (orderActor.IsA('PatrolPoint'))
		TurnTo(Location + PatrolPoint(orderActor).lookdir);
	GotoState('Standing');

ContinueGo:
ContinueFromDoor:
	PlayWalking();
	Goto('Follow');
}


// ----------------------------------------------------------------------
// state RunningTo
//
// Move to an actor really fast.
// ----------------------------------------------------------------------

state RunningTo
{
	function SetFall()
	{
		StartFalling('RunningTo', 'ContinueRun');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function Bump(actor bumper)
	{
		// If we hit the guy we're going to, end the state
		if (bumper == OrderActor)
			GotoState('RunningTo', 'Done');

		// Handle conversations, if need be
		Global.Bump(bumper);
	}

	function Touch(actor toucher)
	{
		// If we hit the guy we're going to, end the state
		if (toucher == OrderActor)
			GotoState('RunningTo', 'Done');

		// Handle conversations, if need be
		Global.Touch(toucher);
	}

	function BeginState()
	{
		StandUp();
		//BlockReactions();
		SetupWeapon(false);
		SetDistress(false);
		bStasis = False;
		SeekPawn = None;
		EnableCheckDestLoc(true);
	}
	function EndState()
	{
		EnableCheckDestLoc(false);
		//ResetReactions();
		bStasis = True;
	}

Begin:
	Acceleration = vect(0, 0, 0);
	if (orderActor == None)
		Goto('Done');

Follow:
	if (IsOverlapping(orderActor))
		Goto('Done');
	MoveTarget = GetNextWaypoint(orderActor);
	if ((MoveTarget != None) && (!MoveTarget.Region.Zone.bWaterZone) &&
	    (MoveTarget.Physics != PHYS_Falling))
	{
		if ((MoveTarget == orderActor) && MoveTarget.IsA('Pawn'))
		{
			if (GetNextVector(orderActor, useLoc))
			{
				if (ShouldPlayWalk(useLoc))
					PlayRunning();
				MoveTo(useLoc, MaxDesiredSpeed);
				CheckDestLoc(useLoc);
			}
			else
				Goto('Pause');
		}
		else
		{
			if (ShouldPlayWalk(MoveTarget.Location))
				PlayRunning();
			MoveToward(MoveTarget, MaxDesiredSpeed);
			CheckDestLoc(MoveTarget.Location, true);
		}
		if (IsOverlapping(orderActor))
			Goto('Done');
		else
			Goto('Follow');
	}

Pause:
	Acceleration = vect(0, 0, 0);
	TurnToward(orderActor);
	PlayWaiting();
	Sleep(1.0);
	Goto('Follow');

Done:
	if (orderActor.IsA('PatrolPoint'))
		TurnTo(Location + PatrolPoint(orderActor).lookdir);
	GotoState('Standing');

ContinueRun:
ContinueFromDoor:
	PlayRunning();
	Goto('Follow');
}


// ----------------------------------------------------------------------
// state DebugFollowing
//
// Following state used for pathnode testing
// ----------------------------------------------------------------------

state DebugFollowing
{
	function SetFall()
	{
		StartFalling('DebugFollowing', 'ContinueRun');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function BeginState()
	{
		StandUp();
		BlockReactions();
		SetupWeapon(false);
		SetDistress(false);
		bStasis = false;
		EnableCheckDestLoc(false);
	}
	function EndState()
	{
		EnableCheckDestLoc(false);
		ResetReactions();
		bStasis = true;
	}

Begin:
	Acceleration = vect(0, 0, 0);
	if (orderActor == None)
		Goto('Done');

Follow:
	MoveTarget = GetNextWaypoint(orderActor);
	if (MoveTarget != None)
	{
		if (ShouldPlayWalk(MoveTarget.Location))
			PlayRunning();
		MoveToward(MoveTarget, 1.0);
		Goto('Follow');
	}

Pause:
	Acceleration = vect(0, 0, 0);
	TurnToward(orderActor);
	PlayWaiting();
	Sleep(1.0);
	Goto('Follow');

Done:
	if (HasNextState())
		GotoNextState();
	else
		GotoState('Standing');

ContinueRun:
ContinueFromDoor:
	PlayRunning();
	Goto('Follow');
}


// ----------------------------------------------------------------------
// state DebugPathfinding
//
// Following state used for pathnode testing
// ----------------------------------------------------------------------

state DebugPathfinding
{
	function SetFall()
	{
		StartFalling('DebugPathfinding', 'ContinueRun');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function BeginState()
	{
		StandUp();
		BlockReactions();
		SetupWeapon(false);
		SetDistress(false);
		bStasis = false;
		EnableCheckDestLoc(false);
	}
	function EndState()
	{
		EnableCheckDestLoc(false);
		ResetReactions();
		bStasis = true;
	}

Begin:
	Acceleration = vect(0, 0, 0);
	if (orderActor == None)
		Goto('Done');

Follow:
	MoveTarget = FindPathToward(orderActor);
	if (MoveTarget != None)
	{
		if (ShouldPlayWalk(MoveTarget.Location))
			PlayRunning();
		MoveToward(MoveTarget, 1.0);
		Goto('Follow');
	}

Pause:
	Acceleration = vect(0, 0, 0);
	TurnToward(orderActor);
	PlayWaiting();
	Sleep(1.0);
	Goto('Follow');

Done:
	if (HasNextState())
		GotoNextState();
	else
		GotoState('Standing');

ContinueRun:
ContinueFromDoor:
	PlayRunning();
	Goto('Follow');
}


// ----------------------------------------------------------------------
// state Burning
//
// Whoa-oh-oh, I'm on fire.
// ----------------------------------------------------------------------

state Burning
{
	function ReactToInjury(Pawn instigatedBy, Name damageType, EHitLocation hitPos)
	{
		local name newLabel;

		if (health > 0)
		{
			if (enemy != instigatedBy)
			{
				SetEnemy(instigatedBy);
				newLabel = 'NewEnemy';
			}
			else
				newLabel = 'ContinueBurn';

			if ( Enemy != None )
				LastSeenPos = Enemy.Location;
			SetNextState('Burning', newLabel);
			if ((damageType != 'TearGas') && (damageType != 'HalonGas') && (damageType != 'Stunned'))
				GotoDisabledState(damageType, hitPos);
		}
	}

	function SetFall()
	{
		StartFalling('Burning', 'ContinueBurn');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function PickDestination()
	{
		local float           magnitude;
		local float           distribution;
		local int             yaw, pitch;
		local Rotator         rotator1;
		local NavigationPoint nav;
		local float           dist;
		local NavigationPoint bestNav;
		local float           bestDist;

		destPoint = None;
		bestNav   = None;
		bestDist  = 2000;   // max distance to water

		// Seek out water
		if (bCanSwim)
		{
			nav = Level.NavigationPointList;
			while (nav != None)
			{
				if (nav.Region.Zone.bWaterZone)
				{
					dist = VSize(Location - nav.Location);
					if (dist < bestDist)
					{
						bestNav  = nav;
						bestDist = dist;
					}
				}
				nav = nav.nextNavigationPoint;
			}
		}

		if (bestNav != None)
		{
			// It'd be nice if we could traverse all pathnodes and figure out their
			// distances...  unfortunately, it's too slow.  :(

			MoveTarget = FindPathToward(bestNav);
			if (MoveTarget != None)
			{
				destPoint = bestNav;
				destLoc   = bestNav.Location;
			}
		}

		// Can't get to water -- run willy-nilly
		if (destPoint == None)
		{
			if (Enemy == None)
			{
				yaw = 0;
				pitch = 0;
				distribution = 0;
			}
			else
			{
				rotator1 = Rotator(Location-Enemy.Location);
				yaw = rotator1.Yaw;
				pitch = rotator1.Pitch;
				distribution = 0.5;
			}

			magnitude = 300*(FRand()*0.4+0.8);  // 400, +/-20%
			if (!AIPickRandomDestination(100, magnitude, yaw, distribution, pitch, distribution, 4,
			                             FRand()*0.4+0.35, destLoc))
				destLoc = Location+(VRand()*200);  // we give up
		}
	}

	function BeginState()
	{
		StandUp();
		BlockReactions();
		bCanConverse = False;
		SetupWeapon(false, true);
		bStasis = False;
		SetDistress(true);
		EnemyLastSeen = 0;
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		ResetReactions();
		bCanConverse = True;
		bStasis = True;
	}

Begin:
	if (!bOnFire)
		Goto('Done');
	PlayOnFireSound();

NewEnemy:
	Acceleration = vect(0, 0, 0);

Run:
	if (!bOnFire)
		Goto('Done');
	PlayPanicRunning();
	PickDestination();
	if (destPoint != None)
	{
		MoveToward(MoveTarget, MaxDesiredSpeed);
		while ((MoveTarget != None) && (MoveTarget != destPoint))
		{
			MoveTarget = FindPathToward(destPoint);
			if (MoveTarget != None)
				MoveToward(MoveTarget, MaxDesiredSpeed);
		}
	}
	else
		MoveTo(destLoc, MaxDesiredSpeed);
	Goto('Run');

Done:
	if (IsValidEnemy(Enemy))
		HandleEnemy();
	else
		FollowOrders();

ContinueBurn:
ContinueFromDoor:
	Goto('Run');
}


// ----------------------------------------------------------------------
// state AvoidingProjectiles
//
// Run away from a projectile.
// ----------------------------------------------------------------------

state AvoidingProjectiles
{
	ignores EnemyNotVisible;

	function SetFall()
	{
		StartFalling('RunningTo', 'ContinueRun');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function PickDestination(bool bGotoWatch)
	{
		local NearbyProjectileList projList;
		local bool                 bMove;
		local vector               projVector;
		local rotator              projRot;
		local int                  i;
		local int                  bestSlot;
		local float                bestDist;

		destLoc   = vect(0,0,0);
		destPoint = None;
		bMove = false;

		if (GetProjectileList(projList, Location) > 0)
		{
			if (IsLocationDangerous(projList, Location))
			{
				projVector = ComputeAwayVector(projList);
				projRot    = Rotator(projVector);
				if (AIDirectionReachable(Location, projRot.Yaw, projRot.Pitch, CollisionRadius+24, VSize(projVector), destLoc))
				{
					useLoc = Location + vect(0,0,1)*BaseEyeHeight;  // hack
					bMove = true;
				}
			}
		}

		if (bMove)
			GotoState('AvoidingProjectiles', 'RunAway');
		else if (bGotoWatch)
			GotoState('AvoidingProjectiles', 'Watch');
	}

	function BeginState()
	{
		StandUp();
		Disable('AnimEnd');
		bCanJump = false;
		SetReactions(true, true, true, true, false, true, true, true, true, true, true, true);
		bStasis = False;
		useLoc = Location + vect(0,0,1)*BaseEyeHeight + Vector(Rotation);
		bCanConverse = False;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		if (JumpZ > 0)
			bCanJump = true;
		ResetReactions();
		bStasis = True;
		bCanConverse = True;
	}

Begin:
	Acceleration = vect(0,0,0);
	PickDestination(true);

RunAway:
	PlayTurnHead(LOOK_Forward, 1.0, 0.0001);
	if (ShouldPlayWalk(destLoc))
		PlayRunning();
	MoveTo(destLoc, MaxDesiredSpeed);
	PickDestination(true);

Watch:
	Acceleration = vect(0,0,0);
	PlayWaiting();
	LookAtVector(useLoc, true, false, true);
	TurnTo(Vector(DesiredRotation)*1000+Location);
	sleepTime = 3.0;
	while (sleepTime > 0)
	{
		sleepTime -= 0.5;
		Sleep(0.5);
		PickDestination(false);
	}

Done:
	if (Orders != 'AvoidingProjectiles')
		FollowOrders();
	else
		GotoState('Wandering');

ContinueRun:
ContinueFromDoor:
	PickDestination(false);
	Goto('Done');

}


// ----------------------------------------------------------------------
// state AvoidingPawn
//
// Run away from an onrushing pawn (used for small, dumb critters only).
// ----------------------------------------------------------------------

state AvoidingPawn
{
	ignores EnemyNotVisible;

	function SetFall()
	{
		StartFalling('AvoidingPawn', 'ContinueAvoid');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function PickDestination()
	{
		local int     iterations;
		local float   magnitude;
		local rotator rot;
		local float   speed;
		local float   time;
		local vector  newPos;
		local float   minDist;

		minDist = 20;
		speed = VSize(Enemy.Velocity);
		if (speed == 0)
			time = 1;
		else
			time  = VSize(Location - Enemy.Location)/speed;
		newPos = Enemy.Location + Enemy.Velocity*(time*0.98);

		magnitude  = 100*(FRand()*0.2+0.9);  // 120, +/-10%
		rot        = Rotator(Location-newPos);
		iterations = 2;
		if (!AIDirectionReachable(Location, rot.Yaw, rot.Pitch, minDist, magnitude, destLoc))
		{
			rot = Rotator(Location - Enemy.Location);
			if (!AIDirectionReachable(Location, rot.Yaw, rot.Pitch, minDist, magnitude, destLoc))
			{
				if (speed > 0)
					rot = Rotator(Enemy.Velocity);
				else
					rot = Enemy.Rotation;
				if (!AIDirectionReachable(Location, rot.Yaw, rot.Pitch, minDist, magnitude, destLoc))
				{
					rot.Yaw   = -rot.Yaw;
					rot.Pitch = -rot.Pitch;
					if (!AIDirectionReachable(Location, rot.Yaw, rot.Pitch, minDist, magnitude, destLoc))
						destLoc = Location;  // we give up
				}
			}
		}
	}

	function BeginState()
	{
		StandUp();
		bCanJump = false;
		bStasis = False;
		SetupWeapon(false);
		SetDistress(false);
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bAcceptBump = True;
		if (JumpZ > 0)
			bCanJump = true;
		bStasis = True;
	}

Begin:
	if (!ShouldBeStartled(Enemy))
		Goto('Done');
	Goto('Avoid');

ContinueFromDoor:
	Goto('Avoid');

Avoid:
ContinueAvoid:
	if (!ShouldBeStartled(Enemy))
		Goto('Done');
	PickDestination();
	if (destLoc == Location)
		Goto('Pause');
	if (ShouldPlayWalk(destLoc))
		PlayRunning();
	MoveTo(destLoc, MaxDesiredSpeed);
	Goto('Avoid');

Pause:
	PlayWaiting();
	Sleep(0.0);
	Goto('Avoid');

Done:
	if (Orders != 'AvoidingPawn')
		FollowOrders();
	else
		GotoState('Wandering');
}


// ----------------------------------------------------------------------
// state BackingOff
//
// Hack state used to back off when the NPC gets stuck.
// ----------------------------------------------------------------------

state BackingOff
{
	ignores EnemyNotVisible;

	function SetFall()
	{
		StartFalling('BackingOff', 'ContinueRun');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function bool PickDestination()
	{
		local bool    bSuccess;
		local float   magnitude;
		local rotator rot;

		magnitude = 300;

		rot = Rotator(Destination-Location);
		bSuccess = AIPickRandomDestination(64, magnitude, rot.Yaw+32768, 0.8, -rot.Pitch, 0.8, 3,
		                                   0.9, useLoc);

		return bSuccess;
	}

	function bool HandleTurn(Actor Other)
	{
		GotoState('BackingOff', 'Pause');
		return false;
	}

	function BeginState()
	{
		StandUp();
		BlockReactions();
		bStasis = False;
		bInTransientState = True;
		EnableCheckDestLoc(false);
		bCanJump = false;
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		if (JumpZ > 0)
			bCanJump = true;
		ResetReactions();
		bStasis = True;
		bInTransientState = false;
	}

Begin:
	useRot = Rotation;
	if (!PickDestination())
		Goto('Pause');
	Acceleration = vect(0,0,0);

MoveAway:
	if (ShouldPlayWalk(useLoc))
		PlayRunning();
	MoveTo(useLoc, MaxDesiredSpeed);

Pause:
	Acceleration = vect(0,0,0);
	PlayWaiting();
	Sleep(FRand()*2+2);

Done:
	if (HasNextState())
		GotoNextState();
	else
		FollowOrders();  // THIS IS BAD!!!

ContinueRun:
ContinueFromDoor:
	Goto('Done');

}


// ----------------------------------------------------------------------
// state OpeningDoor
//
// Open a door.
// ----------------------------------------------------------------------

state OpeningDoor
{
	ignores EnemyNotVisible;

	function SetFall()
	{
		StartFalling(NextState, NextLabel);
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		if (Target == Wall)
			CheckOpenDoor(HitNormal, Wall);
	}

	function bool DoorEncroaches()
	{
		local bool        bEncroaches;
		local DeusExMover dxMover;

		bEncroaches = true;
		dxMover = DeusExMover(Target);
		if (dxMover != None)
		{
			if (IsDoor(dxMover) && (dxMover.MoverEncroachType == ME_IgnoreWhenEncroach))
				bEncroaches = false;
		}

		return bEncroaches;
	}

	function FindBackupPoint()
	{
		local vector hitNorm;
		local rotator rot;
		local vector center;
		local vector area;
		local vector relPos;
		local float  distX, distY;
		local float  dist;

		hitNorm = Normal(destLoc);
		rot = Rotator(hitNorm);
		DeusExMover(Target).ComputeMovementArea(center, area);
		area.X += CollisionRadius + 30;
		area.Y += CollisionRadius + 30;
		//area.Z += CollisionHeight + 30;
		relPos = Location - center;
		if ((relPos.X < area.X) && (relPos.X > -area.X) &&
		    (relPos.Y < area.Y) && (relPos.Y > -area.Y))
		{
			// hack
			if (hitNorm.Y == 0)
				hitNorm.Y = 0.00000001;
			if (hitNorm.X == 0)
				hitNorm.X = 0.00000001;
			if (hitNorm.X > 0)
				distX = (area.X - relPos.X)/hitNorm.X;
			else
				distX = (-area.X - relPos.X)/hitNorm.X;
			if (hitNorm.Y > 0)
				distY = (area.Y - relPos.Y)/hitNorm.Y;
			else
				distY = (-area.Y - relPos.Y)/hitNorm.Y;
			dist = FMin(distX, distY);
			if (dist < 45)
				dist = 45;
			else if (dist > 700)
				dist = 700;  // sanity check
			if (!AIDirectionReachable(Location, rot.Yaw, rot.Pitch, 40, dist, destLoc))
				destLoc = Location;
		}
		else
			destLoc = Location;
	}

	function vector FocusDirection()
	{
		return (Vector(Rotation)*30+Location);
	}

	function StopWaiting()
	{
		GotoState('OpeningDoor', 'DoorOpened');
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function BeginState()
	{
		StandUp();
		Disable('AnimEnd');
		bCanJump = false;
		BlockReactions();
		bStasis = False;
		bInTransientState = True;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bAcceptBump = True;

		if (JumpZ > 0)
			bCanJump = true;

		ResetReactions();
		bStasis = True;
		bInTransientState = false;
	}

Begin:
	destLoc = vect(0,0,0);

BeginHitNormal:
	Acceleration = vect(0,0,0);
	FindBackupPoint();

	if (!DoorEncroaches())
		if (!FrobDoor(Target))
			Goto('DoorOpened');	
	PlayRunning();
	StrafeTo(destLoc, FocusDirection());
	if (DoorEncroaches())
		if (!FrobDoor(Target))
			Goto('DoorOpened');
	PlayWaiting();
	Sleep(5.0);

DoorOpened:
	if (HasNextState())
		GotoNextState();
	else
		FollowOrders();  // THIS IS BAD!!!

}


// ----------------------------------------------------------------------
// state TakingHit
//
// React to a hit.
// ----------------------------------------------------------------------

state TakingHit
{
	ignores seeplayer, hearnoise, bump, hitwall, reacttoinjury;

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, 
	                    Vector momentum, name damageType)
	{
		TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, false);
	}

	function Landed(vector HitNormal)
	{
		if (Velocity.Z < -1.4 * JumpZ)
			MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));
		bJustLanded = true;
	}

	function BeginState()
	{
		StandUp();
		LastPainTime = Level.TimeSeconds;
		LastPainAnim = AnimSequence;
		bInterruptState = false;
		BlockReactions();
		bCanConverse = False;
		bStasis = False;
		SetDistress(true);
		TakeHitTimer = 2.0;
		EnemyReadiness = 1.0;
		ReactionLevel  = 1.0;
		bInTransientState = true;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bInterruptState = true;
		ResetReactions();
		bCanConverse = True;
		bStasis = True;
		bInTransientState = false;
	}
		
Begin:
	Acceleration = vect(0, 0, 0);
	FinishAnim();
	if ( (Physics == PHYS_Falling) && !Region.Zone.bWaterZone )
	{
		Acceleration = vect(0,0,0);
		GotoState('FallingState', 'Ducking');
	}
	else if (HasNextState())
		GotoNextState();
	else
		GotoState('Wandering');
}


// ----------------------------------------------------------------------
// state RubbingEyes
//
// React to evil things like pepper spray.
// ----------------------------------------------------------------------

state RubbingEyes
{
	ignores seeplayer, hearnoise, bump, hitwall;

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
	{
		TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, false);
	}

	function ReactToInjury(Pawn instigatedBy, Name damageType, EHitLocation hitPos)
	{
		if ((damageType != 'TearGas') && (damageType != 'HalonGas') && (damageType != 'Stunned'))
			Global.ReactToInjury(instigatedBy, damageType, hitPos);
	}

	function SetFall()
	{
		StartFalling(NextState, NextLabel);
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function BeginState()
	{
		StandUp();
		Disable('AnimEnd');
//		LastPainTime = Level.TimeSeconds;
//		LastPainAnim = AnimSequence;
		bInterruptState = false;
		BlockReactions();
		bCanConverse = False;
		bStasis = False;
		SetupWeapon(false, true);
		SetDistress(true);
		bStunned = True;
		bInTransientState = true;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bInterruptState = true;
		ResetReactions();
		bCanConverse = True;
		bStasis = True;
		if (Health > 0)
			bStunned = False;
		bInTransientState = false;
	}

Begin:
	Acceleration = vect(0, 0, 0);
	PlayTearGasSound();

RubEyes:
	PlayRubbingEyesStart();
	FinishAnim();
	PlayRubbingEyes();
	Sleep(15);
	PlayRubbingEyesEnd();
	FinishAnim();
	if (HasNextState())
		GotoNextState();
	else
		GotoState('Wandering');
}


// ----------------------------------------------------------------------
// state Stunned
//
// React to being stunned.
// ----------------------------------------------------------------------

state Stunned
{
	ignores seeplayer, hearnoise, bump, hitwall;

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
	{
		TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, false);
	}

	function ReactToInjury(Pawn instigatedBy, Name damageType, EHitLocation hitPos)
	{
		if ((damageType != 'TearGas') && (damageType != 'HalonGas') && (damageType != 'Stunned'))
			Global.ReactToInjury(instigatedBy, damageType, hitPos);
	}

	function SetFall()
	{
		StartFalling(NextState, NextLabel);
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function BeginState()
	{
		StandUp();
		Disable('AnimEnd');
		bInterruptState = false;
		BlockReactions();
		bCanConverse = False;
		bStasis = False;
		SetupWeapon(false);
		SetDistress(true);
		bStunned = True;
		bInTransientState = true;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bInterruptState = true;
		ResetReactions();
		bCanConverse = True;
		bStasis = True;

		// if we're dead, don't reset the flag
		if (Health > 0)
			bStunned = False;
		bInTransientState = false;
	}

Begin:
	Acceleration = vect(0, 0, 0);
	PlayStunned();
	Sleep(15);
	if (HasNextState())
		GotoNextState();
	else
		GotoState('Wandering');
}


// ----------------------------------------------------------------------
// state Dying
//
// Why does the Unreal Dying state suck?
// ----------------------------------------------------------------------

state Dying
{
	ignores SeePlayer, EnemyNotVisible, HearNoise, KilledBy, Trigger, Bump, HitWall, HeadZoneChange, FootZoneChange, Falling, WarnTarget, Died, Timer, TakeDamage;  // Y|y: removed ZoneChange

	//== Y|y: Total HACK, but the WaitForLanding() function doesn't check for water, so we have to force the carcass spawn
	function ZoneChange(ZoneInfo newZone)
	{	
		if (newZone.bWaterZone)
		{
			ExtinguishFire();
			MoveFallingBody();
		
			DesiredRotation.Pitch = 0;
			DesiredRotation.Roll  = 0;
		
			SetWeapon(None);
		
			bHidden = True;
		
			Acceleration = vect(0,0,0);
			SpawnCarcass();
			Destroy();
		}
	}

	event Landed(vector HitNormal)
	{
		SetPhysics(PHYS_Walking);
	}

	function Tick(float deltaSeconds)
	{
		Global.Tick(deltaSeconds);

		if (DeathTimer > 0)
		{
			DeathTimer -= deltaSeconds;
			if ((DeathTimer <= 0) && (Physics == PHYS_Walking))
				Acceleration = vect(0,0,0);
		}
	}

	function MoveFallingBody()
	{
		local Vector moveDir;
		local float  totalTime;
		local float  speed;
		local float  stopTime;
		local int    numFrames;

		if ((AnimRate > 0) && !IsA('Robot'))
		{
			totalTime = 1.0/AnimRate;  // determine how long the anim lasts
			numFrames = int((1.0/(1.0-AnimLast))+0.1);  // count frames (hack)

			// defaults
			moveDir   = vect(0,0,0);
			stopTime  = 0.01;

			ComputeFallDirection(totalTime, numFrames, moveDir, stopTime);

			speed = VSize(moveDir)/stopTime;  // compute speed

			// Set variables necessary for movement when walking
			if (moveDir == vect(0,0,0))
				Acceleration = vect(0,0,0);
			else
				Acceleration = Normal(moveDir)*AccelRate;
			GroundSpeed  = speed;
			DesiredSpeed = 1.0;
			bIsWalking   = false;
			DeathTimer   = stopTime;
		}
		else
			Acceleration = vect(0,0,0);
	}

	function BeginState()
	{
		EnableCheckDestLoc(false);
		StandUp();

		// don't do that stupid timer thing in Pawn.uc
		AIClearEventCallback('Futz');
		AIClearEventCallback('MegaFutz');
		AIClearEventCallback('Player');
		AIClearEventCallback('WeaponDrawn');
		AIClearEventCallback('LoudNoise');
		AIClearEventCallback('WeaponFire');
		AIClearEventCallback('Carcass');
		AIClearEventCallback('Distress');

		bInterruptState = false;
		BlockReactions(true);
		bCanConverse = False;
		bStasis = False;
		SetDistress(true);
		DeathTimer = 0;
	}

Begin:
	WaitForLanding();
	MoveFallingBody();

	DesiredRotation.Pitch = 0;
	DesiredRotation.Roll  = 0;

	// if we don't gib, then wait for the animation to finish
	if ((Health > -100) && !IsA('Robot'))
		FinishAnim();

	SetWeapon(None);

	bHidden = True;

	Acceleration = vect(0,0,0);
	SpawnCarcass();
	Destroy();
}


// ----------------------------------------------------------------------
// state FallingState
//
// Fall!
// ----------------------------------------------------------------------

state FallingState 
{
	ignores Bump, Hitwall, WarnTarget, ReactToInjury;

	function ZoneChange(ZoneInfo newZone)
	{
		Global.ZoneChange(newZone);
		if (newZone.bWaterZone)
			GotoState('FallingState', 'Splash');
	}

	//choose a jump velocity
	function AdjustJump()
	{
		local float velZ;
		local vector FullVel;

		velZ = Velocity.Z;
		FullVel = Normal(Velocity) * GroundSpeed;

		If (Location.Z > Destination.Z + CollisionHeight + 2 * MaxStepHeight)
		{
			Velocity = FullVel;
			Velocity.Z = velZ;
			Velocity = EAdjustJump();
			Velocity.Z = 0;
			if ( VSize(Velocity) < 0.9 * GroundSpeed )
			{
				Velocity.Z = velZ;
				return;
			}
		}

		Velocity = FullVel;
		Velocity.Z = JumpZ + velZ;
		Velocity = EAdjustJump();
	}

	singular function BaseChange()
	{
		local float minJumpZ;

		Global.BaseChange();

		if (Physics == PHYS_Walking)
		{
			minJumpZ = FMax(JumpZ, 150.0);
			bJustLanded = true;
			if (Health > 0)
			{
				if ((Velocity.Z < -0.8 * minJumpZ) || bUpAndOut)
					GotoState('FallingState', 'Landed');
				else if (Velocity.Z < -0.8 * JumpZ)
					GotoState('FallingState', 'FastLanded');
				else
					GotoState('FallingState', 'Done');
			}
		}
	}

	function Landed(vector HitNormal)
	{
		local float landVol, minJumpZ;
		local vector legLocation;

		minJumpZ = FMax(JumpZ, 150.0);

		if ( (Velocity.Z < -0.8 * minJumpZ) || bUpAndOut)
		{
			PlayLanded(Velocity.Z);
			if (Velocity.Z < -700)
			{
				legLocation = Location + vect(-1,0,-1);			// damage left leg
				TakeDamage(-0.14 * (Velocity.Z + 700), Self, legLocation, vect(0,0,0), 'fell');
				legLocation = Location + vect(1,0,-1);			// damage right leg
				TakeDamage(-0.14 * (Velocity.Z + 700), Self, legLocation, vect(0,0,0), 'fell');
				legLocation = Location + vect(0,0,1);			// damage torso
				TakeDamage(-0.04 * (Velocity.Z + 700), Self, legLocation, vect(0,0,0), 'fell');
			}
			landVol = Velocity.Z/JumpZ;
			landVol = 0.005 * Mass * FMin(5, landVol * landVol);
			if ( !FootRegion.Zone.bWaterZone )
				PlaySound(Land, SLOT_Interact, FMin(20, landVol));
		}
		else if ( Velocity.Z < -0.8 * JumpZ )
			PlayLanded(Velocity.Z);
	}

	function SetFall()
	{
		if (!bUpAndOut)
			GotoState('FallingState');
	}

	function BeginState()
	{
		StandUp();
		if (Enemy == None)
			Disable('EnemyNotVisible');
		else
		{
			Disable('HearNoise');
			Disable('SeePlayer');
		}
		bInterruptState = false;
		bCanConverse = False;
		bStasis = False;
		bInTransientState = true;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bUpAndOut = false;
		bInterruptState = true;
		bCanConverse = True;
		bStasis = True;
		bInTransientState = false;
	}

LongFall:
	if ( bCanFly )
	{
		SetPhysics(PHYS_Flying);
		Goto('Done');
	}
	Sleep(0.7);
	PlayFalling();
	if ( Velocity.Z > -150 ) //stuck
	{
		SetPhysics(PHYS_Falling);
		if ( Enemy != None )
			Velocity = groundspeed * normal(Enemy.Location - Location);
		else
			Velocity = groundspeed * VRand();

		Velocity.Z = FMax(JumpZ, 250);
	}
	Goto('LongFall');

FastLanded:
	FinishAnim();
	TweenToWaiting(0.15);
	Goto('Done');

Landed:
	if ( !bIsPlayer ) //bots act like players
		Acceleration = vect(0,0,0);
	FinishAnim();
	TweenToWaiting(0.2);
	if ( !bIsPlayer )
		Sleep(0.08);

Done:
	bUpAndOut = false;
	if (HasNextState())
		GotoNextState();
	else
		GotoState('Wandering');

Splash:
	bUpAndOut = false;
	FinishAnim();
	if (HasNextState())
		GotoNextState();
	else
		GotoState('Wandering');

Begin:
	if (Enemy == None)
		Disable('EnemyNotVisible');
	else
	{
		Disable('HearNoise');
		Disable('SeePlayer');
	}
	if (bUpAndOut) //water jump
	{
		if ( !bIsPlayer ) 
		{
			DesiredRotation = Rotation;
			DesiredRotation.Pitch = 0;
			Velocity.Z = 440; 
		}
	}
	else
	{	
		if (Region.Zone.bWaterZone)
		{
			SetPhysics(PHYS_Swimming);
			GotoNextState();
		}	
		if ( !bJumpOffPawn )
			AdjustJump();
		else
			bJumpOffPawn = false;

PlayFall:
		PlayFalling();
		FinishAnim();
	}
	
	if (Physics != PHYS_Falling)
		Goto('Done');
	Sleep(2.0);
	Goto('LongFall');

Ducking:
		
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// OBSOLETE
// ----------------------------------------------------------------------

function PlayHit(float Damage, vector HitLocation, name damageType, vector Momentum)
{
	log("ERROR - PlayHit should not be called!");
}

function PlayHitAnim(vector HitLocation, float Damage)
{
	log("ERROR - PlayHitAnim should not be called!");
} 

function PlayDeathHit(float Damage, vector HitLocation, name damageType, vector Momentum)
{
	log("ERROR - PlayDeathHit should not be called!");
}

function PlayChallenge()
{
	log("ERROR - PlayChallenge should not be called!");
}

function JumpOffPawn()
{
	/*
	Velocity += (60 + CollisionRadius) * VRand();
	Velocity.Z = 180 + CollisionHeight;
	SetPhysics(PHYS_Falling);
	bJumpOffPawn = true;
	SetFall();
	*/
	//log("ERROR - JumpOffPawn should not be called!");
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     Restlessness=0.500000
     Wanderlust=0.500000
     Cowardice=0.500000
     maxRange=4000.000000
     MinHealth=30.000000
     RandomWandering=1.000000
     bAlliancesChanged=True
     Orders=Wandering
     HomeExtent=800.000000
     WalkingSpeed=0.400000
     bCanBleed=True
     ClotPeriod=30.000000
     bShowPain=True
     bCanSit=True
     bLikesNeutral=True
     bUseFirstSeatOnly=True
     bCanConverse=True
     bAvoidAim=True
     AvoidAccuracy=0.400000
     bAvoidHarm=True
     HarmAccuracy=0.800000
     CloseCombatMult=0.300000
     bHateShot=True
     bHateInjury=True
     bReactPresence=True
     bReactProjectiles=True
     bEmitDistress=True
     RaiseAlarm=RAISEALARM_BeforeFleeing
     bMustFaceTarget=True
     FireAngle=360.000000
     MaxProvocations=1
     AgitationSustainTime=30.000000
     AgitationDecayRate=0.050000
     FearSustainTime=25.000000
     FearDecayRate=0.500000
     SurprisePeriod=2.000000
     SightPercentage=0.500000
     bHasShadow=True
     ShadowScale=1.000000
     BaseAssHeight=-26.000000
     EnemyTimeout=4.000000
     bTickVisibleOnly=True
     bInWorld=True
     bHighlight=True
     bHokeyPokey=True
     InitialInventory(0)=(Count=1)
     InitialInventory(1)=(Count=1)
     InitialInventory(2)=(Count=1)
     InitialInventory(3)=(Count=1)
     InitialInventory(4)=(Count=1)
     InitialInventory(5)=(Count=1)
     InitialInventory(6)=(Count=1)
     InitialInventory(7)=(Count=1)
     bSpawnBubbles=True
     bWalkAround=True
     BurnPeriod=30.000000
     DistressTimer=-1.000000
     CloakThreshold=50
     walkAnimMult=0.700000
     runAnimMult=1.000000
     bCanStrafe=True
     bCanWalk=True
     bCanSwim=True
     bCanOpenDoors=True
     bIsHuman=True
     bCanGlide=False
     AirSpeed=320.000000
     AccelRate=200.000000
     JumpZ=120.000000
     MinHitWall=9999999827968.000000
     HearingThreshold=0.150000
     Skill=2.000000
     AIHorizontalFov=160.000000
     AspectRatio=2.300000
     bForceStasis=True
     BindName="ScriptedPawn"
     FamiliarName="DEFAULT FAMILIAR NAME - REPORT THIS AS A BUG"
     UnfamiliarName="DEFAULT UNFAMILIAR NAME - REPORT THIS AS A BUG"
}
