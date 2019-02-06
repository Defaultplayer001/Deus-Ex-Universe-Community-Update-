//=============================================================================
// ProjectileGenerator.
//=============================================================================
class ProjectileGenerator extends Effects;

var() float Frequency;               // what's the chance of spewing an actor every checkTime seconds
var() float EjectSpeed;              // how fast do the actors get ejected
var() class<actor> ProjectileClass;  // class to project
var() float ProjectileLifeSpan;      // how long each projectile lives
var() bool bTriggered;               // start by triggering?
var() float SpewTime;                // how long do I spew after I am triggered?
var() bool bRandomEject;             // random eject velocity vector
var() float CheckTime;               // how often should I spit out particles?
var() sound SpawnSound;              // sound to play when spawned
var() float SpawnSoundRadius;        // radius of sound
var() bool bAmbientSound;            // play the ambient sound?
var() int NumPerSpawn;               // number of particles to spawn per puff
var() name AttachTag;                // attach us to this actor
var() bool bSpewUnseen;              // spew stuff when players can't see us
var() float WaitTime;                // amount of time between bursts
var() bool bOnlyOnce;				// fire projectiles one time only
var() bool bInitiallyOn;			// if triggered, start on instead of off
var bool bSpewing;					// am I spewing?
var bool bFrozen;					// are we out of the player's sight?
var float period;
var float time;

function Trigger(Actor Other, Pawn EventInstigator)
{
	Super.Trigger(Other, EventInstigator);

	// if we are spewing, turn us off
	if (bSpewing)
	{
		bSpewing = False;
		period = 0;
		time   = 0;
		if (bAmbientSound && (AmbientSound != None))
			SoundVolume = 0;
	}
	else if (!bOnlyOnce)     // otherwise, turn us on
	{
		bSpewing = True;
		period = 0;
		time   = 0;
		if (bAmbientSound && (AmbientSound != None))
			SoundVolume = 255;
	}
}

simulated function Tick(float deltaTime)
{
	local int    i, j;
	local int    count;
	local actor  spawnee;
	local float  speed;
	local float  timeVal;
	local vector dir;

	Super.Tick(deltaTime);

	// If the owner that I'm attached to is dead, kill me
	if ((attachTag != '') && (Owner == None))
		Destroy();

	// Update timers
	time += deltaTime;
	period += deltaTime;

	// If we're spewing and it's time to stop, stop
	if (bSpewing)
	{
		if (SpewTime > 0)
		{
			if (period >= SpewTime)
			{
				period = 0;
				time   = 0;
				bSpewing = False;
			}
		}
		else
			period = 0;
	}

	// If we're not spewing and it's time to start, start
	else if (!bOnlyOnce)
	{
		if (WaitTime > 0)
		{
			if (period >= WaitTime)
			{
				period = 0;
				time   = 0;
				bSpewing = True;
			}
		}
		else
			period = 0;
	}

	// CNN - remove optimizaions to fix strange behavior of PlayerCanSeeMe()
/*
	// Should we freeze the spewage?
	if (bSpewUnseen)
		bFrozen = False;
	else if (PlayerCanSeeMe())
		bFrozen = False;
	else
		bFrozen = True;
*/
	// Are we spewing?
	if (!bSpewing || bFrozen)
		return;

	// Is it time to start spewing?
	if (time >= CheckTime)
	{
		// How many projectiles must we spew?
		if (CheckTime > 0)
		{
			count = int(time/CheckTime);
			time = time - count*CheckTime;
		}
		else
		{
			count = 1;
			time  = 0;
		}
		timeVal = time;

		// Sanity check
		if (count > 5)
			count = 5;

		// If frequency < 1, make spewage random
		if (FRand() <= frequency)
		{
			if (spawnSound != None)
				PlaySound(spawnSound, SLOT_Misc,,, SpawnSoundRadius);

			// Spawn an appropriate number of projectiles
			for (i=0; i<count; i++)  // Number of spews for this tick
			{
				for (j=0; j<numPerSpawn; j++)  // Number of spawns per spew
				{
					// Wayyy down upon the spawnee river...
					spawnee = spawn(ProjectileClass, Owner);
					if (spawnee != None)
					{
						if (bRandomEject)
							dir = VRand();
						else
							dir = vector(Rotation);

						speed = EjectSpeed;
						if (bRandomEject)
							speed *= FRand();

						spawnee.SetRotation(rotator(dir));
						spawnee.Velocity = speed*dir;
						spawnee.Acceleration = dir;
						spawnee.SetLocation(spawnee.Velocity*timeVal+Location);

						if (ProjectileLifeSpan > 0)
							spawnee.LifeSpan = ProjectileLifeSpan;
					}
				}
				timeVal += CheckTime;
			}
		}
	}

}

function PostBeginPlay()
{
	local Actor A;

	Super.PostBeginPlay();

	if (bTriggered && !bInitiallyOn)
		bSpewing = False;

	// Attach us to the actor that was tagged
	if (attachTag != '')
		foreach AllActors(class'Actor', A, attachTag)
			if (A != None)
			{
				SetOwner(A);
				SetBase(A);
			}
}

defaultproperties
{
     Frequency=1.000000
     ejectSpeed=300.000000
     ProjectileClass=Class'DeusEx.Fireball'
     checkTime=0.250000
     SpawnSoundRadius=1024.000000
     numPerSpawn=1
     bInitiallyOn=True
     bSpewing=True
     bHidden=True
     bDirectional=True
     DrawType=DT_Sprite
     Texture=Texture'Engine.S_Inventory'
     CollisionRadius=40.000000
     CollisionHeight=40.000000
}
