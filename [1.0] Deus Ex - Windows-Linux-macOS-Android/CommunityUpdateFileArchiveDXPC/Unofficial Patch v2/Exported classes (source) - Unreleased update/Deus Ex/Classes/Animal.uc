//=============================================================================
// Animal.
//=============================================================================
class Animal extends ScriptedPawn
	abstract;

var bool          bPlayDying;

var float         FoodTimer;
var int           FoodIndex;
var Actor         Food;
var Class<Actor>  FoodClass;
var int           FoodDamage;
var int           FoodHealth;
var bool          bBefriendFoodGiver;
var bool          bPauseWhenEating;
var bool          bMessyEater;
var bool          bFleeBigPawns;
var Actor         BestFood;
var float         BestDist;

var float         fleePawnTimer;
var float         aggressiveTimer;
var float         checkAggTimer;
var bool          bFoodOverridesAttack;


function float ModifyDamage(int Damage, Pawn instigatedBy, Vector hitLocation,
                            Vector offset, Name damageType)
{
	local float actualDamage;

	actualDamage = Super.ModifyDamage(Damage, instigatedBy, hitLocation, offset, damageType);

	if (damageType == 'Stunned')
		actualDamage = 0;

	return actualDamage;
}

function GotoDisabledState(name damageType, EHitLocation hitPos)
{
	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	else if ((damageType == 'TearGas') || (damageType == 'HalonGas'))
		GotoState('Fleeing');
	else if (damageType == 'Stunned')
		GotoState('Fleeing');
	else if (CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
}


function EHitLocation HandleDamage(int Damage, Vector hitLocation, Vector offset, name damageType)
{
	local EHitLocation hitPos;

	hitPos = HITLOC_None;

	if (offset.X < 0.0)
		hitPos = HITLOC_TorsoBack;
	else
		hitPos = HITLOC_TorsoFront;

	if (!bInvincible)
		Health -= Damage;

	return hitPos;

}


function ComputeFallDirection(float totalTime, int numFrames,
                              out vector moveDir, out float stopTime)
{
}


function Pawn FrightenedByPawn()
{
	local pawn  candidate;
	local bool  bCheck;
	local Pawn  fearPawn;

	fearPawn = None;
	if ((!bFleeBigPawns) || (!bBlockActors && !bBlockPlayers))
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
	if (startler != None)
	{
		speed = VSize(startler.Velocity);
		if (speed >= 20)
		{
			dist = VSize(Location - startler.Location);
			time = dist/speed;
			if (time <= 2.0)
			{
				dist2 = VSize(Location - (startler.Location+startler.Velocity*time));
				if (dist2 < speed*0.6)
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


function vector GetSwimPivot()
{
	// THIS IS A HIDEOUS, UGLY, MASSIVELY EVIL HACK!!!!
	return (vect(0,0,0));
}


state Fleeing
{
	function PickDestination()
	{
		local int     iterations;
		local float   magnitude;
		local rotator rot1;

		iterations = 4;
		magnitude  = 400*(FRand()*0.4+0.8);  // 400, +/-20%
		rot1       = Rotator(Location-Enemy.Location);
		if (!AIPickRandomDestination(100, magnitude, rot1.Yaw, 0.6, rot1.Pitch, 0.6, iterations,
		                             FRand()*0.4+0.35, destLoc))
			destLoc = Location;  // we give up
	}
}

state Wandering
{
	function PickDestination()
	{
		local int   iterations;
		local float magnitude;

		magnitude  = (wanderlust*300+100) * (FRand()*0.2+0.9); // 100-400, +/-10%
		iterations = 5;  // try up to 5 different directions

		if (!AIPickRandomDestination(30, magnitude, 0, 0, 0, 0, iterations, FRand()*0.4+0.35, destLoc))
			destLoc = Location;
	}

	function Tick(float deltaSeconds)
	{
		local pawn fearPawn;

		Global.Tick(deltaSeconds);

		fleePawnTimer += deltaSeconds;
		if (fleePawnTimer > 0.5)
		{
			fleePawnTimer = 0;
			fearPawn = FrightenedByPawn();
			if (fearPawn != None)
				FleeFromPawn(fearPawn);
		}
	}
}


state RubbingEyes
{
Begin:
	GotoState('Fleeing');
}



function PlayIdleSound()  {}
function PlaySearchingSound()  {}
function PlayScanningSound()  {}
function PlayTargetAcquiredSound()  {}
function PlayTargetLostSound()  {}
function PlayGoingForAlarmSound()  {}
function PlayOutOfAmmoSound()  {}
function PlayCriticalDamageSound()  {}
function PlayAreaSecureSound()  {}




// Approximately five million stubbed out functions...
function PlayRunningAndFiring() {}
function TweenToShoot(float tweentime) {}
function PlayShoot() {}
function TweenToAttack(float tweentime) {}
function PlayAttack() {}
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
function PlayCowerBegin() {}
function PlayCowering() {}
function PlayCowerEnd() {}


function PlayPanicRunning()
{
	PlayRunning();
}
function PlayTurning()
{
	LoopAnimPivot('Walk', 0.1);
}
function TweenToWalking(float tweentime)
{
	TweenAnimPivot('Walk', tweentime);
}
function PlayWalking()
{
	LoopAnimPivot('Walk', , 0.15);
}
function TweenToRunning(float tweentime)
{
	LoopAnimPivot('Run',, tweentime);
}
function PlayRunning()
{
	LoopAnimPivot('Run');
}
function TweenToWaiting(float tweentime)
{
	TweenAnimPivot('BreatheLight', tweentime);
}
function PlayWaiting()
{
	LoopAnimPivot('BreatheLight', , 0.3);
}
function TweenToSwimming(float tweentime)
{
	TweenAnimPivot('Swim', tweentime, GetSwimPivot());
}
function PlaySwimming()
{
	LoopAnimPivot('Swim', , , , GetSwimPivot());
}


function PlayDying(name damageType, vector hitLoc)
{
	local Vector X, Y, Z;
	local float dotp;

	if (bPlayDying)
	{
		GetAxes(Rotation, X, Y, Z);
		dotp = (Location - HitLoc) dot X;

		// die from the correct side
		if (dotp < 0.0)		// shot from the front, fall back
			PlayAnimPivot('DeathBack',, 0.1);
		else				// shot from the back, fall front
			PlayAnimPivot('DeathFront',, 0.1);
	}

	PlayDyingSound();
}



function PlayPauseWhenEating()
{
}

function PlayStartEating()
{
	PlayAnimPivot('EatBegin');
}

function PlayEating()
{
	PlayAnimPivot('Eat', 1.3, 0.2);
}

function PlayStopEating()
{
	PlayAnimPivot('EatEnd');
}

function PlayEatingSound()
{
}


function float GetMaxDistance(Actor foodActor)
{
	return (foodActor.CollisionRadius+CollisionRadius);
}


function bool IsInRange(Actor foodActor)
{
	return (VSize(foodActor.Location-Location) <= GetMaxDistance(foodActor)+20);
}


function bool GetFeedSpot(Actor foodActor, out vector feedSpot)
{
	local rotator rot;

	if (IsInRange(foodActor))
	{
		feedSpot = Location;
		return true;
	}
	else
	{
		rot = Rotator(foodActor.Location - Location);
		return AIDirectionReachable(foodActor.Location, rot.Yaw, rot.Pitch,
		                            0, GetMaxDistance(foodActor), feedSpot);
	}
}

function bool IsValidFood(Actor foodActor)
{
	if (foodActor == None)
		return false;
	else if (foodActor.bDeleteMe)
		return false;
	else if (foodActor.Region.Zone.bWaterZone)
		return false;
	else if ((foodActor.Physics == PHYS_Swimming) || (foodActor.Physics == PHYS_Falling))
		return false;
	else if (!ClassIsChildOf(foodActor.Class, FoodClass))
		return false;
	else
		return true;
}


function bool InterestedInFood()
{
	if (((GetStateName() == 'Wandering') || (GetStateName() == 'Standing') || (GetStateName() == 'Patrolling')) &&
	    (LastRendered() < 10.0))
		return true;
	else if (bFoodOverridesAttack && ((GetStateName() == 'Attacking') || (GetStateName() == 'Seeking')) && (aggressiveTimer <= 0))
		return true;
	else
		return false;
}


function SpewBlood(vector Position)
{
	spawn(class'BloodSpurt', , , Position);
	spawn(class'BloodDrop', , , Position);
	if (FRand() < 0.5)
		spawn(class'BloodDrop', , , Position);
}

function Chomp()
{
	Munch(Food);  // mmm... finger-lickin' good!
}

function vector GetChompPosition()
{
	return (Location+Vector(Rotation)*CollisionRadius);
}

function Munch(Actor foodActor)
{
	if (IsValidFood(foodActor) && IsInRange(Food))
	{
		foodActor.TakeDamage(FoodDamage, self, foodActor.Location, vect(0,0,0), 'Munch');  // finger-lickin' good!
		if (bMessyEater)
			SpewBlood(GetChompPosition());
		Health += FoodHealth;
		if (Health > Default.Health)
			Health = Default.Health;
	}
}

function bool ShouldFlee()
{
	return (Health <= MinHealth);
}

function bool ShouldDropWeapon()
{
	return false;
}

function Tick(float deltaSeconds)
{
	local Actor  curFood;
	local int    lastIndex;
	local float  dist;
	local vector tempVect;

	Super.Tick(deltaSeconds);

	if (checkAggTimer > 0)
	{
		checkAggTimer -= deltaSeconds;
		if (checkAggTimer < 0)
			checkAggTimer = 0;
	}

	if (aggressiveTimer > 0)
	{
		aggressiveTimer -= deltaSeconds;
		if (aggressiveTimer < 0)
			aggressiveTimer = 0;
	}

	if ((FoodClass != None) && InterestedInFood())
	{
		FoodTimer += deltaSeconds;
		if (FoodTimer > 0.5)
		{
			FoodTimer = 0;
			lastIndex = FoodIndex;
			foreach CycleActors(FoodClass, curFood, FoodIndex)
			{
				if (IsValidFood(curFood))
				{
					dist = VSize(curFood.Location - Location);
					if ((dist < 400) || ((dist < 800) && (AICanSee(curFood, , false, true, false, false) > 0.0)))
					{
						if ((BestFood == None) || (dist < BestDist))
						{
							if (GetFeedSpot(curFood, tempVect))
							{
								BestDist  = dist;
								BestFood  = curFood;
								FoodIndex = 0;
							}
							break;
						}
					}
				}
			}
			if (lastIndex >= FoodIndex)  // have we cycled through all actors?
			{
				if (BestFood != None)
				{
					if (bBefriendFoodGiver && (BestFood.Instigator != None))
						DecreaseAgitation(BestFood.Instigator, 2);
					Food = BestFood;
					SetState('Eating');
				}
				BestFood = None;
			}
		}
	}
	else
		FoodTimer = 0;

}


state Eating
{
	function SetFall()
	{
		StartFalling('Eating', 'ContinueEat');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		CheckOpenDoor(HitNormal, Wall);
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function Tick(float deltaSeconds)
	{
		Super.Tick(deltaSeconds);

		if (bFoodOverridesAttack && (checkAggTimer <= 0))
		{
			checkAggTimer = 0.3;
			if (aggressiveTimer > 0)
				ResetReactions();
			else
				BlockReactions();
		}
	}

	function BeginState()
	{
		StandUp();
		SetEnemy(None, EnemyLastSeen, true);
		Disable('AnimEnd');
		SetDistress(false);
		if (!bFoodOverridesAttack)
			ResetReactions();
		else if (aggressiveTimer > 0)
			ResetReactions();
		else
			BlockReactions();
	}

	function EndState()
	{
		ResetReactions();
		Food     = None;
		BestFood = None;
	}

Begin:
	destPoint = None;
	Acceleration = vect(0,0,0);

GoToFood:
	WaitForLanding();
	if (!IsValidFood(Food))
		FollowOrders();
	if (!GetFeedSpot(Food, destLoc))
		FollowOrders();
	PlayRunning();
	MoveTo(destLoc, MaxDesiredSpeed);
	if (!IsInRange(Food))
		Goto('GoToFood');

TurnToFood:
	Acceleration = vect(0,0,0);
	PlayTurning();
	TurnToward(Food);
	if (!bPauseWhenEating || (FRand() >= 0.4))
		Goto('StartEating');

PauseEating:
	PlayPauseWhenEating();
	FinishAnim();

StartEating:
	if (!IsValidFood(Food))
		FollowOrders();
	if (!IsInRange(Food))
		Goto('GoToFood');
	PlayStartEating();
	FinishAnim();

Eat:
	if (!IsValidFood(Food))
		Goto('StopEating');
	if (!IsInRange(Food))
		Goto('StopEating');
	PlayEatingSound();
	PlayEating();
	if (bAnimNotify)
		FinishAnim();
	else
	{
		FinishAnim();
		Munch(Food);
	}
	if (!bPauseWhenEating || (FRand() > 0.1))
		Goto('Eat');

StopEating:
	PlayStopEating();
	FinishAnim();
	if (IsValidFood(Food))
	{
		if (!IsInRange(Food))
			Goto('GoToFood');
		else
			Goto('PauseEating');
	}

ContinueEat:
ContinueFromDoor:
	FollowOrders();
}

defaultproperties
{
     FoodDamage=10
     FoodHealth=3
     maxRange=512.000000
     MinHealth=5.000000
     bCanBleed=False
     bCanSit=False
     bAvoidAim=False
     bAvoidHarm=False
     bHateShot=False
     bReactProjectiles=False
     bFearIndirectInjury=True
     bEmitDistress=False
     RaiseAlarm=RAISEALARM_Never
     MaxProvocations=0
     SurprisePeriod=0.000000
     ShadowScale=0.500000
     walkAnimMult=1.000000
     bCanStrafe=False
     bCanSwim=False
     bCanOpenDoors=False
     bIsHuman=False
     bCanGlide=True
     Health=10
     VisibilityThreshold=0.006000
     BindName="Animal"
}
