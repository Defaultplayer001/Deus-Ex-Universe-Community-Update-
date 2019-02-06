//=============================================================================
// PawnGenerator.
//=============================================================================
class PawnGenerator extends Effects
	abstract;

struct PawnTypes  {
	var() int                 Count;
	var   int                 CurCount;
	var() Class<ScriptedPawn> PawnClass;
};

struct PawnData  {
	var bool                bValid;
	var ScriptedPawn        Pawn;
	var Class<ScriptedPawn> PawnClass;
};

var   PawnTypes      PawnClasses[8];   // All classes that will be generated
var() Name           Orders;           // Orders for generated pawns
var() Name           OrderTag;         // Order tag for generated pawns
var() Name           Alliance;         // Alliance for generated pawns
var() bool           bGeneratorIsHome; // True if this generator should act as a home base
var() float          PawnHomeExtent;   // Extent of the home area; 0 means the extent is the same as the radius
var() float          ActiveArea;       // Maximum player distance from generator
var() float          Radius;           // Radius in which to spawn pawns
var() bool           bTriggered;       // True if this generator will be triggered
var() int            MaxCount;         // Maximum number of pawns in existence at any one time

var(Special) bool    bPawnsTransient;  // True if pawns should disappear when out of range
var(Special) bool    bRandomCount;     // If True, number of generated pawns will be random
var(Special) bool    bRandomTypes;     // If True, pawn classes will be randomized (with correct distribution)
var(Special) bool    bRepopulate;      // True if generator will spawn pawns forever
var          bool    bLOSCheck;        // True if we should check LOS if pawns are transient (OBSOLESCENT!)

var(Special) float   Focus;            // 0=pawns will face random directions; 1=pawns will face
                                       // same direction as pawn generator

var   int            PawnCount;        // Current number of pawns in existence
var   int            PoolCount;        // Total number of pawns that will EVER be generated
var   PawnData       Pawns[32];        // All pawns currently in existence
var   GeneratorScout Scout;            // Scout pawn used to place pawns
var   bool           bActive;          // True if this generator is active
var   float          TryTimer;         // Timer used to generate pawns
var   vector         GroundLocation;   // Starting point
var   bool           bDying;           // True if no more pawns should be generated
var   bool           bScoutInit;       // True if the scout has been initialized

var   vector         LastGenLocation;  // Last location
var   rotator        LastGenRotation;  // Last rotation

var   vector         SumVelocities;    // Cumulative velocities of all pawns; used for flocking
var   vector         FlockCenter;      // Rough average center point of a flock
var   float          VelocityTimer;    // Timer for checking velocities
var   vector         RandomVelocity;   // Random velocity for turns
var   float          TurnPeriod;       // Amount of time to add a "turn" velocity
var   float          CoastPeriod;      // Amount of time to coast without adding velocity
var   float          CoastTimer;       // Timer for adding random velocities
var   float          StatusTimer;      // Should we do a StatusUpdate this frame


// ----------------------------------------------------------------------
// PostBeginPlay()
// ----------------------------------------------------------------------

function PostBeginPlay()
{
	local int i;
	local int count;

	Super.PostBeginPlay();

	// Make sure we have pawns to generate
	count = 0;
	for (i=0; i<ArrayCount(PawnClasses); i++)
		if ((PawnClasses[i].PawnClass != None) && (PawnClasses[i].Count > 0))
			count += PawnClasses[i].Count;
	if (count <= 0)
	{
		Destroy();
		return;
	}

	// Check the maximum number of pawns in existence
	if (MaxCount <= 0)
		MaxCount = count;
	else if (MaxCount >= ArrayCount(Pawns))
		MaxCount = ArrayCount(Pawns);

	// Compute random count
	if (bRandomCount)
		PoolCount = Rand(count) + 1;
	else
		PoolCount = count;

	// Look for the ground location of this generator
	ComputeGroundLocation();

	// Initialize home base stuff
	SetAllHome();

	// Set up triggering
	if (bTriggered)
		bActive = False;
	else
		bActive = True;

	// Set up timer
	TryTimer = 0.25+FRand()*0.75;

}


// ----------------------------------------------------------------------
// Destroyed()
// ----------------------------------------------------------------------

function Destroyed()
{
	local int i;

	// Destroy our scout pawn
	if (IsPawnValid(Scout))
	{
		Scout.Destroy();
		Scout = None;
	}

	// Destroy all our pawns
	for (i=0; i<ArrayCount(Pawns); i++)
	{
		if (Pawns[i].bValid)
		{
			if (IsPawnValid(Pawns[i].Pawn))
				Pawns[i].Pawn.Destroy();
			InvalidatePawn(i);
		}
	}

	Super.Destroyed();

}


// ----------------------------------------------------------------------
// Burst()
// ----------------------------------------------------------------------

function Burst(optional int count)
{
	local int  i;
	local bool bProcess;

	if (count == 0)
		count = MaxCount-PawnCount;

	// Spawn a scout for bursting
	SpawnScout();

	// Make sure we're not wasting our time
	bStasis  = true;
	bProcess = !IsActorUnnecessary(self);
	bStasis  = false;

	// If not, generate a bunch of pawns
	if (bProcess)
		for (i=0; i<count; i++)
			GeneratePawn(true);

}


// ----------------------------------------------------------------------
// StopGenerator()
// ----------------------------------------------------------------------

function StopGenerator()
{
	// Set the dying flag, and free all pawns to move away
	if (!bDying)
	{
		bDying = True;
		SetAllHome();
	}
}


// ----------------------------------------------------------------------
// ComputeGroundLocation()
// ----------------------------------------------------------------------

function ComputeGroundLocation()
{
	local actor  HitActor;
	local vector HitLocation, HitNormal;
	local vector EndTrace;

	// Look for the ground location of this generator
	EndTrace    = Location;
	EndTrace.Z -= 200;
	if (Trace(HitLocation, HitNormal, EndTrace, Location, false) != None)
		GroundLocation    = HitLocation;
	else
	{
		GroundLocation    = Location;
		GroundLocation.Z -= CollisionHeight;
	}

}


// ----------------------------------------------------------------------
// SetPawnHome()
// ----------------------------------------------------------------------

function SetPawnHome(ScriptedPawn setPawn)
{
	local float    homeDist;
	local vector   homePos;
	local EPhysics pawnPhysics;

	if (bGeneratorIsHome && IsPawnValid(setPawn))
	{
		if (!bDying)
		{
			if (PawnHomeExtent > 0.0)
				homeDist = PawnHomeExtent;
			else
				homeDist = Radius;
			pawnPhysics = GetClassPhysics(setPawn.Class);
			if (pawnPhysics == PHYS_Walking)
				homePos = GroundLocation+vect(0,0,1)*CollisionHeight;
			else
				homePos = Location;
			setPawn.SetHomeBase(homePos, Rotation, homeDist);
		}
		else
			setPawn.ClearHomeBase();
	}
}


// ----------------------------------------------------------------------
// SetAllHome()
// ----------------------------------------------------------------------

function SetAllHome()
{
	local int i;

	for (i=0; i<ArrayCount(Pawns); i++)
		if ((Pawns[i].bValid) && (Pawns[i].Pawn != None))
			SetPawnHome(Pawns[i].Pawn);

	LastGenLocation = Location;
	LastGenRotation = Rotation;
}



// ----------------------------------------------------------------------
// Trigger()
// ----------------------------------------------------------------------

function Trigger(Actor Other, Pawn EventInstigator)
{

	Super.Trigger(Other, EventInstigator);

	// Make this puppy active
	bActive = True;

}


// ----------------------------------------------------------------------
// SpawnScout()
// ----------------------------------------------------------------------

function bool SpawnScout()
{
	// Spawn a scout for pawn generation
	if (!bScoutInit)
	{
		bScoutInit = true;

		Scout = Spawn(Class'GeneratorScout', , , Location);
		if (Scout != None)
		{
			Scout.SetCollision(false, false, false);
			Scout.SetPhysics(PHYS_Flying);
			Scout.Health = 100;
		}
	}

	// Return TRUE if we have a scout
	return (Scout != None);
}


// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

simulated function Tick(float deltaTime)
{
	local Class<ScriptedPawn> PawnClass;

	Super.Tick(deltaTime);

	// Make sure we have a scout
	if (!SpawnScout())
	{
		Destroy();
		return;
	}

	// Destroy dead or transient pawns
	StatusTimer += deltaTime;
	if (StatusTimer > 1.0)
	{
		CheckPawnStatus();
		StatusTimer = 0;
	}

	// If no pawns are left, and we're dying, destroy ourselves
	if (bDying && (PawnCount <= 0))
	{
		Destroy();
		return;
	}

	// Update cumulative velocities for flocking
	if (PawnCount > 0)   // don't bother doing this if we have no pawns
		UpdateSumVelocities(deltaTime);

	// Reset home base positions for all pawns if we've moved
	if ((LastGenLocation != Location) || (LastGenRotation != Rotation))
	{
		ComputeGroundLocation();
		SetAllHome();
	}

	// Should we try to generate new pawns?
	if (bActive && !bDying)
	{
		if (TryTimer >= 0)  // always go down
			TryTimer -= deltaTime;
		if (TryTimer < 0)
		{
			if (!IsActorUnnecessary(self))
			{
				GeneratePawn();   // actually generate a Pawn
				TryTimer = 0.25;
			}
			else
				TryTimer = 0;
		}
	}
}


// ----------------------------------------------------------------------
// GenerateRandomVelocity()
// ----------------------------------------------------------------------

function vector GenerateRandomVelocity()
{
	// Overridden in subclasses
	return (vect(0,0,0));
}


// ----------------------------------------------------------------------
// GenerateCoastPeriod()
// ----------------------------------------------------------------------

function float GenerateCoastPeriod()
{
	// Overridden in subclasses
	return (CoastPeriod);
}


// ----------------------------------------------------------------------
// IsPawnValid()
// ----------------------------------------------------------------------

function bool IsPawnValid(Pawn testPawn, optional bool bCheckHealth)
{
	local bool bValid;

	// Is this a valid pawn?
	if (testPawn == None)
		bValid = false;
	else if (testPawn.bDeleteMe)
		bValid = false;
	else if (bCheckHealth && (testPawn.Health <= 0))
		bValid = false;
	else
		bValid = true;

	return (bValid);

}


// ----------------------------------------------------------------------
// InvalidatePawn()
// ----------------------------------------------------------------------

function InvalidatePawn(int slot)
{
	if (Pawns[slot].bValid)
	{
		Pawns[slot].bValid    = false;
		Pawns[slot].Pawn      = None;
		Pawns[slot].PawnClass = None;
		PawnCount--;
	}
}


// ----------------------------------------------------------------------
// IsActorUnnecessary()
// ----------------------------------------------------------------------

function bool IsActorUnnecessary(Actor testActor)
{
	// Is this actor in a place we don't care about?
	return (testActor.DistanceFromPlayer >= ActiveArea);
}


// ----------------------------------------------------------------------
// PlayerCanSeeActor()
// ----------------------------------------------------------------------

function bool PlayerCanSeeActor(Actor testActor, bool bCreating)
{
	local bool bCanSee;
	local DeusExPlayer P;

	// Return True if the player can see this actor
	bCanSee = false;
	if (bCreating)
	{
	    //DEUS_EX AMSD In multiplayer, we really want, "Can any player see this actor?"
		//So iterate over the actors.
        //In single player, iter is slow, so just call GetPlayerPawn.
        if (Level.NetMode != NM_Standalone)
        {
            foreach AllActors(class'DeusExPlayer',P)
            {
                if (P.AICanSee(testActor, 1.0, false, false, true, true) > 0.0)
                    bCanSee = true;
            }
        }
        else
        {
            if (GetPlayerPawn().AICanSee(testActor, 1.0, false, false, true, true) > 0.0)
                bCanSee = true;
        }
	}
	else
	{
		if (testActor.LastRendered() <= 5.0)
			bCanSee = true;
	}

	return (bCanSee);
}


// ----------------------------------------------------------------------
// FindUsedPawnClass()
// ----------------------------------------------------------------------

function bool FindUsedPawnClass(Class<ScriptedPawn> PawnClass, out int classNum)
{
	local int i;

	// Find a pawn class that's been used
	for (i=0; i<ArrayCount(PawnClasses); i++)
		if ((PawnClasses[i].PawnClass == PawnClass) && (PawnClasses[i].CurCount > 0))
			break;
	if (i < ArrayCount(PawnClasses))
	{
		classNum = i;
		return true;
	}
	else
		return false;
}


// ----------------------------------------------------------------------
// PickRandomClass()
// ----------------------------------------------------------------------

function bool PickRandomClass(out int classNum)
{
	local int i;
	local int count;
	local int randNum;

	// Count the number of class slots available
	count = 0;
	for (i=0; i<ArrayCount(PawnClasses); i++)
		if (PawnClasses[i].PawnClass != None)
			count += (PawnClasses[i].Count - PawnClasses[i].CurCount);

	// Randomly pick one of the slots; this scheme maintains class distribution
	classNum = -1;
	if (count > 0)
	{
		randNum  = Rand(count) + 1;
		for (i=0; i<ArrayCount(PawnClasses); i++)
		{
			if (PawnClasses[i].PawnClass != None)
			{
				randNum -= (PawnClasses[i].Count - PawnClasses[i].CurCount);
				if (randNum <= 0)
				{
					classNum = i;
					break;
				}
			}
		}
	}

	// Return True if we succeeded
	if ((classNum < 0) || (classNum >= ArrayCount(PawnClasses)))
		return false;
	else
		return true;
}


// ----------------------------------------------------------------------
// CheckPawnStatus()
// ----------------------------------------------------------------------

function CheckPawnStatus()
{
	local int i;
	local int classNum;

	// When the scout dies, so do we
	if (!IsPawnValid(Scout))
	{
		Destroy();
		return;
	}

	// Don't do any work if there are no pawns...
	if (PawnCount > 0)
	{
		// Check every pawn in our care...
		for (i=0; i<ArrayCount(Pawns); i++)
		{
			if (Pawns[i].bValid)
			{
				if (!IsPawnValid(Pawns[i].Pawn, true))  // pawn has been destroyed
				{
					if (bRepopulate)
					{
						if (!bRandomTypes)
							if (FindUsedPawnClass(Pawns[i].PawnClass, classNum))
								PawnClasses[classNum].CurCount--;
					}
					InvalidatePawn(i);
				}
				else if (bPawnsTransient)  // pawn is transient -- kill it?
				{
					if (IsActorUnnecessary(Pawns[i].Pawn) && !PlayerCanSeeActor(Pawns[i].Pawn, false))
					{
						if (!bRandomTypes)
							if (FindUsedPawnClass(Pawns[i].PawnClass, classNum))
								PawnClasses[classNum].CurCount--;
						if (!bRepopulate)
							PoolCount++;
						Pawns[i].Pawn.Destroy();
						InvalidatePawn(i);
					}
				}
			}
		}
	}
}


// ----------------------------------------------------------------------
// UpdateSumVelocities()
// ----------------------------------------------------------------------

function UpdateSumVelocities(float deltaTime)
{
	local int   i;
	local int   count;
	local float newCoastTimer;
	local float checkPeriod;

	checkPeriod = 0.5;  // update every 1/2 second

	VelocityTimer += deltaTime;
	if (VelocityTimer >= checkPeriod)
	{
		SumVelocities = vect(0,0,0);
		FlockCenter   = vect(0,0,0);
		count         = 0;
		for (i=0; i<ArrayCount(Pawns); i++)
		{
			if ((Pawns[i].bValid) && (Pawns[i].Pawn != None))
			{
				count++;
				SumVelocities += Pawns[i].Pawn.Velocity;
				FlockCenter   += Pawns[i].Pawn.Location;
			}
		}

		if (count > 0)
			FlockCenter /= count;
		else
			FlockCenter = Location;

		newCoastTimer = CoastTimer - VelocityTimer;
		if (newCoastTimer < -TurnPeriod)  // start to coast
		{
			newCoastTimer = GenerateCoastPeriod();
			RandomVelocity = vect(0,0,0);
		}
		else if ((CoastTimer >= 0) && (newCoastTimer < 0))
			RandomVelocity = GenerateRandomVelocity();
		CoastTimer = newCoastTimer;

		SumVelocities += RandomVelocity;

		VelocityTimer = 0;
	}

}


// ----------------------------------------------------------------------
// GetClassPhysics()
// ----------------------------------------------------------------------

function EPhysics GetClassPhysics(Class<Pawn> PawnClass)
{
	local EPhysics newPhysics;

	newPhysics = PawnClass.Default.Physics;
	if ((newPhysics == PHYS_None) || (newPhysics == PHYS_Falling))
		newPhysics = PHYS_Walking;

	return (newPhysics);
}


// ----------------------------------------------------------------------
// GeneratePawn()
// ----------------------------------------------------------------------

function GeneratePawn(optional bool bBurst)
{
	local int          classNum;
	local float        dist;
	local vector       startLocation;
	local vector       destination;
	local vector       HitLocation, HitNormal;
	local ScriptedPawn spawnee;
	local rotator      randRot;
	local bool         bCanSee;
	local bool         bActorUnnecessary;
	local bool         bSuccess;
	local int          i;
	local EPhysics     newPhysics;
	local Class<Actor> entryActor;
	local Sound        entrySound;
	local bool         bSpawn;

	bSuccess = false;
	spawnee  = None;

	// No spawn for you!
	if (bDying || (PawnCount >= MaxCount) || (PoolCount <= 0) || (Scout == None))
		return;

	// Pick a class...
	if (PickRandomClass(classNum))
	{
		// Set up our center point...
		newPhysics = GetClassPhysics(PawnClasses[classNum].PawnClass);
		if (newPhysics == PHYS_Walking)
			startLocation = GroundLocation+vect(0,0,1)*(PawnClasses[classNum].PawnClass.Default.CollisionHeight);
		else
			startLocation = Location;
		bSpawn = false;

		// Move the scout to the center point
		Scout.bCollideWorld = false;
		Scout.SetCollisionSize(5, 5);
		Scout.SetLocation(startLocation);
		Scout.SetCollisionSize(PawnClasses[classNum].PawnClass.Default.CollisionRadius,
			                    PawnClasses[classNum].PawnClass.Default.CollisionHeight);
		Scout.SetPhysics(newPhysics);
		Scout.bCollideWorld = true;

		// If this is business as usual, find a random location for the pawn...
		if (!bBurst)
		{
			// Pick a random scout location
			dist = sqrt(FRand())*Radius;
			if (dist < PawnClasses[classNum].PawnClass.Default.CollisionRadius*2+1)
				dist = PawnClasses[classNum].PawnClass.Default.CollisionRadius*2+1;
			if (Scout.AIPickRandomDestination(0, dist, 0, 0, 0, 0, 2, 1.0, destination))
			{
				// Got a location, but can the player see it?
				Scout.SetLocation(destination);
				Scout.bHidden = false;
				Scout.bDetectable = true;
				bCanSee = PlayerCanSeeActor(Scout, true);
				bActorUnnecessary = IsActorUnnecessary(Scout);
				Scout.bHidden = true;
				Scout.bDetectable = false;

				// This is a good spot...
				if (!bCanSee && !bActorUnnecessary)
					bSpawn = true;
			}
		}

		// Otherwise, just use the center point
		else
		{
			destination = startLocation;
			bSpawn      = true;
		}

		// Do we have a good location?
		if (bSpawn)
		{
			// Look for an open slot in our pawn list
			for (i=0; i<ArrayCount(Pawns); i++)
				if (!Pawns[i].bValid)
					break;
			if (i < ArrayCount(Pawns))
			{
				// Finally, try spawning the actual pawn
				randRot = RandomBiasedRotation(Rotation.Yaw, focus, Rotation.Pitch, focus);
				if (newPhysics == PHYS_Walking)
					randRot.Pitch = 0;
				entryActor = Scout.FootRegion.Zone.EntryActor;  // MAJOR hack!!!
				entrySound = Scout.FootRegion.Zone.EntrySound;
				Scout.FootRegion.Zone.EntryActor = None;
				Scout.FootRegion.Zone.EntrySound = None;
				spawnee = Spawn(PawnClasses[classNum].PawnClass, self, , destination, randRot);
				Scout.FootRegion.Zone.EntryActor = entryActor;
				Scout.FootRegion.Zone.EntrySound = entrySound;
				if (spawnee != None)
				{
					// We are golden!  Initialize the pawn and add it to our list
					spawnee.InitializePawn();
					spawnee.SetMovementPhysics();
					spawnee.bTransient = false;
					SetPawnHome(spawnee);
					spawnee.SetAlliance(Alliance);
					spawnee.SetOrders(Orders, OrderTag, true);
					spawnee.SetLocation(destination);
					bSuccess = true;
					Pawns[i].bValid    = true;
					Pawns[i].Pawn      = spawnee;
					Pawns[i].PawnClass = PawnClasses[classNum].PawnClass;
					PawnCount++;
					if (!bRandomTypes)
						PawnClasses[classNum].CurCount++;
					if (!bRepopulate)
						PoolCount--;
				}
			}
		}
	}
}

defaultproperties
{
     PawnClasses(0)=(Count=1)
     PawnClasses(1)=(Count=1)
     PawnClasses(2)=(Count=1)
     PawnClasses(3)=(Count=1)
     PawnClasses(4)=(Count=1)
     PawnClasses(5)=(Count=1)
     PawnClasses(6)=(Count=1)
     PawnClasses(7)=(Count=1)
     Orders=Wandering
     ActiveArea=2000.000000
     Radius=600.000000
     bLOSCheck=True
     TurnPeriod=0.800000
     CoastPeriod=8.000000
     bHidden=True
     bDirectional=True
     DrawType=DT_Sprite
     Texture=Texture'Engine.S_Inventory'
     CollisionRadius=10.000000
     CollisionHeight=6.000000
}
