//=============================================================================
// Bird.
//=============================================================================
class Bird extends Animal
	abstract;

var     name         WaitAnim;
var(AI) float        LikesFlying;
var     float        lastCheck;
var     float        stuck;
var     float        hitTimer;
var     float        fright;
var     float        initialRate;


function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, 
                    Vector momentum, name damageType)
{
	if ((DamageType == 'EMP') || (DamageType == 'NanoVirus'))
		return;

	if (!bInvincible)
		Health -= Damage;

	HealthHead     = Health;
	HealthTorso    = Health;
	HealthArmLeft  = Health;
	HealthArmRight = Health;
	HealthLegLeft  = Health;
	HealthLegRight = Health;

	if (Health > 0)
	{
		MakeFrightened();
		GotoState('Flying');
		//PlayHit(actualDamage, hitLocation, damageType, momentum.z);
	}
	else
	{
		ClearNextState();
		//PlayDeathHit(actualDamage, hitLocation, damageType);
		Enemy = instigatedBy;
		Died(instigatedBy, damageType, HitLocation);
	}
}


function TweenToWaiting(float tweentime)
{
	if (FRand() >= 0.5)
		WaitAnim = 'Idle1';
	else
		WaitAnim = 'Idle2';
	TweenAnim(WaitAnim, tweentime);
}

function PlayWaiting()
{
	LoopAnim(WaitAnim);
}

function PlayFlying()
{
	LoopAnim('Fly', 1.0, 0.1);
	initialRate = AnimRate;
}

function BeginPlay()
{
	Super.BeginPlay();
	AIClearEventCallback('WeaponFire');
}

function MakeFrightened()
{
	fright = (cowardice*99)+1;
}

function FleeFromPawn(Pawn fleePawn)
{
	MakeFrightened();
	if (GetStateName() != 'Flying')
		GotoState('Flying');
}

function Tick(float deltaSeconds)
{
	Super.Tick(deltaSeconds);

	if (fright > 0)
	{
		fright -= deltaSeconds;
		if (fright < 0)
			fright = 0;
	}
}

state Wandering
{
	function BeginState()
	{
		Super.BeginState();
		AISetEventCallback('LoudNoise', 'HeardNoise');
	}

	function EndState()
	{
		Super.EndState();
		AIClearEventCallback('LoudNoise');
	}

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
	{
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);

		if ((DamageType == 'EMP') || (DamageType == 'NanoVirus'))
			return;

		if ( health <= 0 )
			return;
		enemy = instigatedBy;
		if ( Enemy != None )
			LastSeenPos = Enemy.Location;
		//SetNextState('Flying', 'Begin');
		//GotoState('TakingHit');
		MakeFrightened();
		GotoState('Flying');
	}

	function PickDestination()
	{
		local int   iterations;
		local float magnitude;

		magnitude  = (wanderlust*300+100) * (FRand()*0.2+0.9); // 100-400, +/-10%
		iterations = 5;  // try up to 5 different directions

		if (!AIPickRandomDestination(30, magnitude, 0, 0, 0, 0, iterations, FRand()*0.4+0.35, destLoc))
			destLoc = Location;
	}

	function HeardNoise(Name eventName, EAIEventState state, XAIParams params)
	{
		FleeFromPawn(Pawn(params.bestActor));
	}

	function Tick(float deltaSeconds)
	{
		Super.Tick(deltaSeconds);

		lastCheck += deltaSeconds;
		if (lastCheck > 0.5)
		{
			lastCheck = 0;
			if (FRand() < 0.1)
			{
				if (IsA('Pigeon'))  // hack!
					PlaySound(Sound'PigeonCoo', SLOT_Misc);
				else if (IsA('Seagull'))  // hack!
					PlaySound(Sound'SeagullCry', SLOT_Misc);
			}
		}
	}
}


state Flying
{
	simulated function HitWall(vector HitNormal, actor Wall)
	{
		local Vector  newVector;
		local Rotator newRotator;

		if (hitTimer > 0)
			return;

		hitTimer = 0.5;
		Disable('HitWall');

		newVector    = (Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity;
		newRotator   = Rotator(newVector);

		SetRotation(newRotator);
		DesiredRotation = newRotator;

		Acceleration = vect(0, 0, 0);
		Velocity     = newVector;
		if (VSize(Velocity) < 0.01)
			Velocity = Vector(Rotation);

		destLoc = Location + 80*Velocity/VSize(Velocity);
		GotoState('Flying', 'KeepGoing');
	}

	function Tick(float deltaSeconds)
	{
		local float rate;

		Global.Tick(deltaSeconds);

		if (hitTimer > 0)
		{
			hitTimer -= deltaSeconds;
			if (hitTimer < 0)
			{
				hitTimer = 0;
				Enable('HitWall');
			}
		}
		stuck += deltaSeconds;

		if (Physics == PHYS_Flying)
		{
			rate = FClamp(Acceleration.Z+250, 0, 500)/500 + 0.5;
			AnimRate = initialRate*rate;
		}
		else if (Physics == PHYS_Falling)
			AnimRate = initialRate*0.1;
	}

	function HeardNoise(Name eventName, EAIEventState state, XAIParams params)
	{
		MakeFrightened();
	}

	function bool ReadyToLand()
	{
		local Pawn fearPawn;

		fearPawn = FrightenedByPawn();
		if (fearPawn != None)
		{
			MakeFrightened();
			return false;
		}
		else if (fright > 0)
			return false;
		else if (FRand() <= LikesFlying)
			return false;
		else
			return true;
	}

	function CheckStuck()
	{
		if (stuck > 10.0)
			GotoState('Flying', 'Drop');
	}

	function bool CheckDestination(vector dest, out float magnitude, float minDist)
	{
		local bool retval;
		local float dist;

		retval = False;
		dist = magnitude;
		while (dist > minDist)
		{
			if (PointReachable(Location+(dest*dist)))
				break;
			dist *= 0.5;
		}
		if (dist > minDist)
		{
			magnitude = dist;
			retval    = True;
		}

		return (retval);
	}

	function PickDestination()
	{
		local vector dest;
		local float  magnitude;
		local int    iterations;
		local bool   bValid;

		iterations = 4;
		while (iterations > 0)
		{
			//magnitude = 800+(FRand()*100-50);
			magnitude = 1200+(FRand()*200-100);
			dest = VRand();
			bValid = CheckDestination(dest, magnitude, 100);
			if (!bValid && (dest.Z != 0))
			{
				dest.Z = -dest.Z;
				bValid = CheckDestination(dest, magnitude, 100);
			}
			if (bValid)
				break;

			iterations--;
		}
		if (iterations > 0)
		{
			destLoc = Location + (dest*magnitude);
			stuck = 0;
		}
		else
		{
			if (VSize(Velocity) > 0.001)
				destLoc = 40*Velocity/VSize(Velocity);
			else
				destLoc = Velocity;
			if (stuck > 5.0)
				destLoc += VRand()*((stuck-5.0)*3.0);
			destLoc += Location;
		}
	}

	function PickInitialDestination()
	{
		local vector  dest;
		local rotator rot;
		local float   magnitude;

		//magnitude = 200 + (FRand()*50-25);
		magnitude = 300 + (FRand()*100-50);
		rot.yaw = Rotation.yaw;
		//rot.pitch = 8192+(Rand(6000)-3000);
		rot.pitch = 10000+(Rand(6000)-3000);
		rot.roll = 0;
		dest = Vector(rot);
		if (CheckDestination(dest, magnitude, 20))
			destLoc = Location + (dest*magnitude);
		else
			destLoc = Location + vect(0, 0, 100);
	}

	function bool PickFinalDestination()
	{
		local vector dest;
		local Actor  landActor;
		local vector hitLoc;
		local vector hitNorm;
		local vector endPoint;
		local vector startPoint;
		local int    iterations;
		local bool   retval;

		retval = False;

		iterations = 3;
		while (iterations > 0)
		{
			startPoint = VRand()*100 + Location;
			startPoint.Z = Location.Z;
			endPoint = startPoint;
			endPoint.Z -= 1000;
			foreach TraceActors(Class'Actor', landActor, hitLoc, hitNorm, endPoint, startPoint)
			{
				if (landActor == Level)
				{
					hitLoc.Z += CollisionHeight+5;
					if (PointReachable(hitLoc))
						break;
				}
				else
				{
					landActor = None;
					break;
				}
			}
			if (landActor != None)
			{
				break;
			}
			iterations--;
		}

		if (iterations > 0)
		{
			destLoc = hitLoc;
			retval  = True;
		}

		return (retval);
	}

	function BeginState()
	{
		SetPhysics(PHYS_Flying);
		Enable('HitWall');
		stuck       = 0;
		hitTimer    = 0;
		AISetEventCallback('LoudNoise', 'HeardNoise');
		if (IsA('Pigeon'))
			PlaySound(Sound'PigeonFly', SLOT_Misc);
		else if (IsA('Seagull'))
			PlaySound(Sound'SeagullFly', SLOT_Misc);
		SetCollision(true, false, false);
	}

	function EndState()
	{
		SetCollision(true, true, true);
		SetPhysics(PHYS_Falling);
		Enable('HitWall');
		AIClearEventCallback('LoudNoise');
	}

Begin:
	PlayFlying();

StartFlying:
	PickInitialDestination();
	MoveTo(destLoc);

Fly:
	if (ReadyToLand())
		Goto('Land');
	PickDestination();

KeepGoing:
	CheckStuck();
	MoveTo(destLoc);
	Goto('Fly');

Land:
	if (!PickFinalDestination())
	{
		PickDestination();
		Goto('KeepGoing');
	}
	MoveTo(destLoc);
	SetPhysics(PHYS_Falling);
	WaitForLanding();
	Acceleration = vect(0, 0, 0);
	GotoState('Wandering');

Drop:
	DesiredRotation.pitch = -16384;
	SetPhysics(PHYS_Falling);
	Sleep(0.5);
	SetPhysics(PHYS_Flying);
	Goto('Fly');
}


// Kind of a hack, but...
state Fleeing
{
ignores all;
begin:
	GotoState('Flying');
}

state Attacking
{
ignores all;
begin:
	Sleep(0.5);
	GotoState('Wandering');
}

defaultproperties
{
     WaitAnim=Idle1
     LikesFlying=0.250000
     bFleeBigPawns=True
     Restlessness=1.000000
     Wanderlust=0.050000
     Cowardice=0.200000
     bCanFly=True
     MaxStepHeight=2.000000
}
