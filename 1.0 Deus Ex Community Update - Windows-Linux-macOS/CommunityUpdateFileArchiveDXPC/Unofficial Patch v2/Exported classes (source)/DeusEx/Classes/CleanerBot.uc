//=============================================================================
// CleanerBot.
//=============================================================================
class CleanerBot extends Robot;

var float blotchTimer;
var float fleePawnTimer;

enum ECleanDirection  {
	CLEANDIR_North,
	CLEANDIR_South,
	CLEANDIR_East,
	CLEANDIR_West
};

var ECleanDirection minorDir;
var ECleanDirection majorDir;


function Tick(float deltaSeconds)
{
	local pawn        fearPawn;
	local DeusExDecal blotch;
	local float       deltaXY, deltaZ;

	Super.Tick(deltaSeconds);

	fleePawnTimer += deltaSeconds;
	if (fleePawnTimer > 0.5)
	{
		fleePawnTimer = 0;
		fearPawn = FrightenedByPawn();
		if (fearPawn != None)
			FleeFromPawn(fearPawn);
	}

	blotchTimer += deltaSeconds;
	if (blotchTimer > 0.3)
	{
		blotchTimer = 0;
		foreach RadiusActors(Class'DeusExDecal', blotch, CollisionRadius*2)
		{
			deltaXY = VSize((blotch.Location-Location)*vect(1,1,0));
			deltaZ  = blotch.Location.Z - Location.Z;
			if ((deltaXY <= CollisionRadius*1.2) && (deltaZ < 0) && (deltaZ > -(CollisionHeight+10)))
				blotch.Destroy();
		}
	}
}



// hack -- copied from Animal.uc
function Pawn FrightenedByPawn()
{
	local pawn  candidate;
	local bool  bCheck;
	local Pawn  fearPawn;

	fearPawn = None;
	if (!bBlockActors && !bBlockPlayers)
		return fearPawn;

	foreach RadiusActors(Class'Pawn', candidate, 500)
	{
		bCheck = false;
		if (!ClassIsChildOf(candidate.Class, Class))
		{
			if (candidate.bBlockActors)
			{
				if (bBlockActors && !candidate.bIsPlayer)
					bCheck = true;
				else if (bBlockPlayers && candidate.bIsPlayer)
					bCheck = true;
			}
		}

		if (bCheck)
		{
			if ((candidate.MaxStepHeight < CollisionHeight*1.5) && (candidate.CollisionHeight*0.5 <= CollisionHeight))
				bCheck = false;
		}

		if (bCheck)
		{
			if (ShouldBeStartled(candidate))
			{
				fearPawn = candidate;
				break;
			}
		}
	}

	return fearPawn;
}


function bool ShouldBeStartled(Pawn startler)
{
	local float speed;
	local float time;
	local float dist;
	local float dist2;
	local bool  bPh33r;

	bPh33r = false;
	if (IsValidEnemy(startler, False))
	{
		speed = VSize(startler.Velocity);
		if (speed >= 20)
		{
			dist = VSize(Location - startler.Location);
			time = dist/speed;
			if (time <= 2.0)
			{
				dist2 = VSize(Location - (startler.Location+startler.Velocity*time));
				if (dist2 < speed*0.8)
					bPh33r = true;
			}
		}
	}

	return bPh33r;
}

function FleeFromPawn(Pawn fleePawn)
{
	SetEnemy(fleePawn, , true);
	GotoState('AvoidingPawn');
}


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

	function rotator RotationDir(ECleanDirection cleanDir)
	{
		local rotator rot;

		rot = rot(0,0,0);
		if      (cleanDir == CLEANDIR_North)
			rot.Yaw = 0;
		else if (cleanDir == CLEANDIR_South)
			rot.Yaw = 32768;
		else if (cleanDir == CLEANDIR_East)
			rot.Yaw = 16384;
		else if (cleanDir == CLEANDIR_West)
			rot.Yaw = 49152;

		return (rot);
	}

	function ECleanDirection GetReverseDirection(ECleanDirection cleanDir)
	{
		if      (cleanDir == CLEANDIR_North)
			cleanDir = CLEANDIR_South;
		else if (cleanDir == CLEANDIR_South)
			cleanDir = CLEANDIR_North;
		else if (cleanDir == CLEANDIR_East)
			cleanDir = CLEANDIR_West;
		else if (cleanDir == CLEANDIR_West)
			cleanDir = CLEANDIR_East;

		return (cleanDir);
	}

	function PickDestination()
	{
		local Rotator rot;
		local float   minorMagnitude, majorMagnitude;
		local float   minDist;

		MoveTarget = None;
		destPoint  = None;

		minorMagnitude = 256;
		majorMagnitude = CollisionRadius*2;
		minDist        = 24;

		rot = RotationDir(minorDir);
		if (!AIDirectionReachable(Location, rot.Yaw, rot.Pitch,
		                          minDist, minorMagnitude, destLoc))
		{
			minorDir = GetReverseDirection(minorDir);
			rot = RotationDir(majorDir);
			if (!AIDirectionReachable(Location, rot.Yaw, rot.Pitch,
			                          minDist, majorMagnitude, destLoc))
			{
				majorDir = GetReverseDirection(majorDir);
				rot = RotationDir(minorDir);
				if (!AIDirectionReachable(Location, rot.Yaw, rot.Pitch,
				                          minDist, minorMagnitude, destLoc))
				{
					minorDir = GetReverseDirection(minorDir);
					rot = RotationDir(majorDir);
					if (!AIDirectionReachable(Location, rot.Yaw, rot.Pitch,
					                          minDist, majorMagnitude, destLoc))
					{
						majorDir = GetReverseDirection(majorDir);
						destLoc = Location;  // give up
					}
				}
			}
		}
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
	if (destLoc == Location)
		Sleep(1.0);
	Goto('Wander');

ContinueWander:
ContinueFromDoor:
	FinishAnim();
	PlayWalking();
	Goto('Wander');
}

defaultproperties
{
     majorDir=CLEANDIR_East
     EMPHitPoints=20
     WalkingSpeed=0.200000
     GroundSpeed=300.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     Health=20
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     DrawType=DT_Mesh
     Mesh=LodMesh'DeusExCharacters.CleanerBot'
     SoundRadius=16
     SoundVolume=128
     AmbientSound=Sound'DeusExSounds.Robot.CleanerBotMove'
     CollisionRadius=18.000000
     CollisionHeight=11.210000
     Mass=70.000000
     Buoyancy=97.000000
     RotationRate=(Yaw=100000)
     BindName="CleanerBot"
     FamiliarName="Cleaner Bot"
     UnfamiliarName="Cleaner Bot"
}
