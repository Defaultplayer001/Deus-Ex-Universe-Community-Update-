//=============================================================================
// Rat.
//=============================================================================
class Rat extends Animal;

var(AI) float MinLightLevel;
var(AI) float MaxLightLevel;
var(AI) float ReactionTime;
var(AI) float MaxWaitTime;
var float     ComputedSpeed;
var float     LastAgitation;
var float     CurrentAgitation;

var float time;

function bool ShouldBeStartled(Pawn startler)
{
	local float speed;
	local float time;
	local float dist;
	local float dist2;
	local bool  bPh33r;

	bPh33r = false;
	if (startler != None)
	{
		speed = VSize(startler.Velocity);
		if (speed >= 20)
		{
			dist = VSize(Location - startler.Location);
			time = dist/speed;
			if (time <= 3.0)
			{
				dist2 = VSize(Location - (startler.Location+startler.Velocity*time));
				if (dist2 < speed*1.5)
					bPh33r = true;
			}
		}
	}

	return bPh33r;
}


function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	time += deltaTime;

	// check for random noises
	if (time > 1.0)
	{
		time = 0;
		if (FRand() < 0.05)
			PlaySound(sound'RatSqueak2', SLOT_None);
	}
}

// ----------------------------------------------------------------------
// state Wandering
// ----------------------------------------------------------------------

// Ripped right out of ScriptedPawn and modified -- need to make this generic?
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

	function BeginState()
	{
		Super.BeginState();
	}

	function EndState()
	{
		Super.EndState();
	}

	function PickDestination()
	{
		local float   magnitude;
		local int     iterations;
		local bool    bSuccess;
		local Rotator rot;

		MoveTarget = None;
		destPoint  = None;
		iterations = 4;  // try up to 4 different directions
		while (iterations > 0)
		{
			// How far will we go?
			magnitude = (170*FRand()+80) * (FRand()*0.2+0.9); // 80-250, +/-10%

			// Choose our destination, based on whether we have a home base
			if (!bUseHome)
				bSuccess = AIPickRandomDestination(40, magnitude, 0, 0, 0, 0, 1,
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

Begin:
	destPoint = None;

GoHome:
	bAcceptBump = false;
	TweenToWalking(0.15);
	WaitForLanding();
	FinishAnim();
	PlayWalking();

Wander:
	PickDestination();

Moving:
	// Move from pathnode to pathnode until we get where we're going
	PlayWalking();
	MoveTo(destLoc, GetWalkingSpeed());

Pausing:
	if (FRand() < 0.35)
		Goto('Wander');

	Acceleration = vect(0, 0, 0);
	PlayTurning();

	// Turn in the direction dictated by the WanderPoint, if there is one
	Enable('AnimEnd');
	TweenToWaiting(0.2);
	bAcceptBump = True;
	PlayScanningSound();
	sleepTime = FRand()*1+0.75;
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

defaultproperties
{
     MinLightLevel=0.030000
     MaxLightLevel=0.080000
     ReactionTime=0.500000
     MaxWaitTime=10.000000
     bFleeBigPawns=True
     Restlessness=0.900000
     Wanderlust=0.200000
     MinHealth=2.000000
     CarcassType=Class'DeusEx.RatCarcass'
     WalkingSpeed=0.360000
     GroundSpeed=250.000000
     WaterSpeed=24.000000
     AirSpeed=150.000000
     AccelRate=500.000000
     JumpZ=0.000000
     MaxStepHeight=8.000000
     BaseEyeHeight=1.000000
     Health=5
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Fear
     HitSound1=Sound'DeusExSounds.Animal.RatSqueak1'
     HitSound2=Sound'DeusExSounds.Animal.RatSqueak3'
     Die=Sound'DeusExSounds.Animal.RatDie'
     HealthHead=5
     HealthTorso=5
     HealthLegLeft=5
     HealthLegRight=5
     HealthArmLeft=5
     HealthArmRight=5
     Alliance=Rat
     DrawType=DT_Mesh
     Mesh=LodMesh'DeusExCharacters.Rat'
     CollisionRadius=16.000000
     CollisionHeight=3.500000
     bBlockActors=False
     Mass=2.000000
     Buoyancy=2.000000
     RotationRate=(Yaw=65530)
     BindName="Rat"
     FamiliarName="Rat"
     UnfamiliarName="Rat"
}
