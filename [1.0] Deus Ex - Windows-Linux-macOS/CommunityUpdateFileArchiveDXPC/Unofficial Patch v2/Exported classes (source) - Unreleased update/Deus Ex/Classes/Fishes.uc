//=============================================================================
// Fishes.
//=============================================================================
class Fishes extends Animal
	abstract;

var   float leaderTimer;
var   float forwardTimer;
var   float bumpTimer;
var   float abortTimer;
var   float breatheTimer;
var() bool  bFlock;
var() bool  bStayHorizontal;


function PostBeginPlay()
{
	Super.PostBeginPlay();

	ResetLeaderTimer();
	forwardTimer = -1;
	bumpTimer    = 0;
	abortTimer   = -1;
	breatheTimer = 0;
}

function ResetLeaderTimer()
{
	leaderTimer = FRand()*10.0+5;
}

function ResetForwardTimer()
{
	forwardTimer = FRand()*10.0+2;
}

function bool IsNearHome(vector position)
{
	local bool          bNear;
	local PawnGenerator genOwner;

	bNear = true;
	if (bUseHome)
	{
		genOwner = PawnGenerator(Owner);
		if (genOwner == None)
		{
			if (VSize(HomeLoc-((position-Location)+genOwner.FlockCenter)) > HomeExtent)
				bNear = false;
		}
		else
		{
			if (VSize(HomeLoc-position) > HomeExtent)
				bNear = false;
		}
	}

	return bNear;
}


function ReactToInjury(Pawn instigatedBy, Name damageType, EHitLocation hitPos) {}

state Wandering
{
	event HitWall(vector HitNormal, actor HitWall)
	{
		local rotator dir;
		local float   elasticity;
		local float   minVel, maxHVel;
		local vector  tempVect;

		if (Physics == PHYS_Swimming)
		{
			if (bumpTimer > 0)
				return;
			bumpTimer = 0.5;

			if (bStayHorizontal)
				HitNormal = Normal(HitNormal*vect(1,1,0));
			elasticity = 1.0;
			Velocity = elasticity*((Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity);
			dir = Rotator(Velocity);
			if (bStayHorizontal)
				dir.Pitch = 0;
			SetRotation(dir);
			DesiredRotation = dir;
			Acceleration = Vector(dir)*AccelRate;
		}
		else
		{
			elasticity = 0.3;
			Velocity = elasticity*((Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity);
			minVel  = 100;
			maxHVel = 20;
			Velocity += VRand()*5 * vect(1,1,0);
			tempVect = Velocity * vect(1,1,0);
			if (VSize(tempVect) > maxHVel)
				Velocity = Normal(tempVect)*maxHVel + vect(0,0,1)*Velocity.Z;
			if (VSize(Velocity) < minVel)
				Velocity = Normal(Velocity)*minVel*(FRand()*0.2+1);
			dir = Rotator(VRand());
			SetRotation(dir);
			DesiredRotation = dir;
		}
		forwardTimer = -1;
		GotoState('Wandering', 'Moving');
	}

	function FootZoneChange(ZoneInfo newZone)
	{
		local Rotator newRotation;
		if (newZone.bWaterZone && !FootRegion.Zone.bWaterZone)
		{
			if (!bStayHorizontal)
			{
				newRotation = Rotation;
				newRotation.Pitch = -1500;
				SetRotation(newRotation);
				DesiredRotation = newRotation;
				leaderTimer = 1.0;
				GotoState('Wandering', 'Moving');
			}
		}
		Super.ZoneChange(newZone);
	}

	function Tick(float deltatime)
	{
		Super.Tick(deltatime);
		leaderTimer  -= deltaTime;
		forwardTimer -= deltaTime;
		bumpTimer    -= deltaTime;
		if (leaderTimer < -2.0)
			ResetLeaderTimer();
		if (bumpTimer < 0)
			bumpTimer = 0;
		if (abortTimer >= 0)
			abortTimer += deltaTime;
		if (abortTimer > 8.0)
		{
			abortTimer = -1;
			GotoState('Wandering', 'Moving');
		}
		if (Region.Zone.bWaterZone)
			breatheTimer = 0;
		else
		{
			breatheTimer += deltaTime;
			if (breatheTimer > 8)
			{
				TakeDamage(5, None, Location, vect(0,0,0), 'Drowned');
				breatheTimer = 6;
			}
		}
	}

	function vector PickDirection(bool bForward)
	{
		local Actor         nearbyActor;
		local Fishes        nearbyFish;
		local PawnGenerator genOwner;
		local vector        cumVector;
		local rotator       rot;
		local float         dist;
		local vector        centerVector;

		if (bForward || IsNearHome(Location))
			cumVector = Velocity;
		else
			cumVector = (homeLoc - Location)*20;
		if ((leaderTimer > 0) && !bForward && bFlock)
		{
			genOwner = PawnGenerator(Owner);
			if (genOwner == None)
			{
				foreach RadiusActors(Class, nearbyActor, 300)
				{
					nearbyFish = Fishes(nearbyActor);
					if ((nearbyFish != None) && (nearbyFish != self) && nearbyFish.bFlock &&
					    (PawnGenerator(nearbyFish.Owner) == None))
						cumVector += nearbyFish.Velocity;
				}
			}
			else
			{
				cumVector += genOwner.SumVelocities - Velocity;
				centerVector = (genOwner.FlockCenter - Location);
				dist = VSize(centerVector);
				if ((dist > genOwner.Radius) && (dist < genOwner.Radius*4))
					cumVector += centerVector*2;
			}
		}
		if (cumVector == vect(0,0,0))
			cumVector = Vector(Rotation);
		rot = Rotator(cumVector);
		if (bStayHorizontal)
			rot.Pitch = 0;
		if (!bForward)
		{
			if ((leaderTimer > 1.2) && bFlock)
			{
				rot.Yaw += Rand(8192)-4096;
				if (!bStayHorizontal)
					rot.Pitch += Rand(3000)-1500;
			}
			return vector(rot)*200+Location;
		}
		else
			return vector(rot)*50+Location;
	}

	function BeginState()
	{
		Super.BeginState();
		BlockReactions();
		abortTimer = -1;
	}

	function EndState()
	{
		Super.EndState();
		bBounce = False;
	}

Begin:
	bBounce = True;
	destPoint = None;
	MoveTo(Location+Vector(Rotation)*(CollisionRadius+5), 1);

Init:
	bAcceptBump = false;
	TweenToWalking(0.15);
	WaitForLanding();
	FinishAnim();

Wander:
	PlayWalking();

Moving:
	abortTimer = 0;
	if (forwardTimer < 0)
	{
		MoveTo(PickDirection(true), 1);
		ResetForwardTimer();
	}
	else
		TurnTo(PickDirection(false));
	abortTimer = -1;
	Sleep(0.0);
	Goto('Moving');

ContinueWander:
ContinueFromDoor:
	PlayWalking();
	Goto('Wander');
}


function PlayWalking()
{
	LoopAnimPivot('Swim');
}
function TweenToWalking(float tweentime)
{
	TweenAnimPivot('Swim', tweentime);
}


// Approximately five million stubbed out functions...
function PlayRunningAndFiring() {}
function TweenToShoot(float tweentime) {}
function PlayShoot() {}
function TweenToAttack(float tweentime) {}
function PlayAttack() {}
function PlayPanicRunning() {}
function PlaySittingDown() {}
function PlaySitting() {}
function PlayStandingUp() {}
function PlayRubbingEyesStart() {}
function PlayRubbingEyes() {}
function PlayRubbingEyesEnd() {}
function PlayStunned() {}
function PlayFalling() {}
function PlayLanded(float impactVel) {}
function PlayDuck() {}
function PlayRising() {}
function PlayCrawling() {}
function PlayPushing() {}
function PlayFiring() {}
function PlayTakingHit(EHitLocation hitPos) {}

function PlayTurning() {}
function TweenToRunning(float tweentime) {}
function PlayRunning() {}
function TweenToWaiting(float tweentime) {}
function PlayWaiting() {}
function TweenToSwimming(float tweentime) {}
function PlaySwimming() {}

defaultproperties
{
     bFlock=True
     WalkingSpeed=1.000000
     bHasShadow=False
     bHighlight=False
     bSpawnBubbles=False
     bCanWalk=False
     bCanSwim=True
     GroundSpeed=100.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     MaxStepHeight=1.000000
     MinHitWall=0.000000
     BaseEyeHeight=1.000000
     UnderWaterTime=99999.000000
     Physics=PHYS_Swimming
     DrawType=DT_Mesh
     Mesh=LodMesh'DeusExCharacters.Fish'
     CollisionRadius=7.760000
     CollisionHeight=3.890000
     bBlockActors=False
     bBlockPlayers=False
     bBounce=True
     Mass=1.000000
     Buoyancy=1.000000
     RotationRate=(Pitch=6000,Yaw=25000)
     BindName="Fishes"
}
