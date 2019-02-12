//=============================================================================
// Karkian.
//=============================================================================
class Karkian extends Animal;

// fake a charge attack using bump
function Bump(actor Other)
{
	local DeusExWeapon dxWeapon;
	local DeusExPlayer dxPlayer;
	local float        damage;

	Super.Bump(Other);

	if (IsInState('Attacking') && (Other != None) && (Other == Enemy))
	{
		// damage both of the player's legs if the karkian "charges"
		// just use Shot damage since we don't have a special damage type for charged
		// impart a lot of momentum, also
		if (VSize(Velocity) > 100)
		{
			dxWeapon = DeusExWeapon(Weapon);
			if ((dxWeapon != None) && dxWeapon.IsA('WeaponKarkianBump') && (FireTimer <= 0))
			{
				FireTimer = DeusExWeapon(Weapon).AIFireDelay;
				damage = VSize(Velocity) / 5;
				Other.TakeDamage(damage, Self, Other.Location+vect(1,1,-1), 100*Velocity, 'Shot');
				Other.TakeDamage(damage, Self, Other.Location+vect(-1,-1,-1), 100*Velocity, 'Shot');
				dxPlayer = DeusExPlayer(Other);
				if (dxPlayer != None)
					dxPlayer.ShakeView(0.15 + 0.002*damage*2, damage*30*2, 0.3*damage*2);
			}
		}
	}
}


function ComputeFallDirection(float totalTime, int numFrames,
                              out vector moveDir, out float stopTime)
{
	// Determine direction, and how long to slide
	if ((AnimSequence == 'DeathFront') || (AnimSequence == 'DeathBack'))
	{
		moveDir = Vector(DesiredRotation-rot(0,16384,0)) * Default.CollisionRadius*1.2;
		stopTime = totalTime*0.7;
	}
}

function bool FilterDamageType(Pawn instigatedBy, Vector hitLocation,
                               Vector offset, Name damageType)
{
	if ((damageType == 'TearGas') || (damageType == 'HalonGas') || (damageType == 'PoisonGas'))
		return false;
	else
		return Super.FilterDamageType(instigatedBy, hitLocation, offset, damageType);
}

function GotoDisabledState(name damageType, EHitLocation hitPos)
{
	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	else if ((damageType == 'TearGas') || (damageType == 'HalonGas'))
		GotoNextState();
	else if (damageType == 'Stunned')
		GotoNextState();
	else if (CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
}

function ReactToInjury(Pawn instigatedBy, Name damageType, EHitLocation hitPos)
{
	Super.ReactToInjury(instigatedBy, damageType, hitPos);
	aggressiveTimer = 10;
}


function vector GetSwimPivot()
{
	// THIS IS A HIDEOUS, UGLY, MASSIVELY EVIL HACK!!!!
	return (vect(0,0,1)*CollisionHeight*1.5);
}

function TweenToAttack(float tweentime)
{
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('Tread', tweentime, GetSwimPivot());
	else
		TweenAnimPivot('Attack', tweentime);
}

function PlayAttack()
{
	PlayAnimPivot('Attack');
}

function PlayPanicRunning()
{
	PlayRunning();
}

function PlayTurning()
{
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',,,, GetSwimPivot());
	else
		LoopAnimPivot('Walk', 0.1);
}

function TweenToWalking(float tweentime)
{
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('Tread', tweentime, GetSwimPivot());
	else
		TweenAnimPivot('Walk', tweentime);
}

function PlayWalking()
{
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',,,, GetSwimPivot());
	else
		LoopAnimPivot('Walk', , 0.15);
}

function TweenToRunning(float tweentime)
{
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('Tread', tweentime, GetSwimPivot());
	else
		LoopAnimPivot('Run',, tweentime);
}

function PlayRunning()
{
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',,,, GetSwimPivot());
	else
		LoopAnimPivot('Run');
}
function TweenToWaiting(float tweentime)
{
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('Tread', tweentime, GetSwimPivot());
	else
		TweenAnimPivot('BreatheLight', tweentime);
}
function PlayWaiting()
{
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',,,, GetSwimPivot());
	else
		LoopAnimPivot('BreatheLight', , 0.3);
}

function bool PlayRoar()
{
	if (Region.Zone.bWaterZone)
		return false;
	else
	{
		PlayAnimPivot('Roar');
		return true;
	}

}

function PlayPauseWhenEating()
{
	PlayRoar();
}

function bool PlayBeginAttack()
{
	if (FRand() < 0.4)
		return PlayRoar();
	else
		return false;
}

function PlayRoarSound()
{
	PlaySound(Sound'KarkianIdle2', SLOT_Pain, 1.0,,, RandomPitch());
}

function vector GetChompPosition()
{
	return (Location+Vector(Rotation)*CollisionRadius - vect(0,0,1)*CollisionHeight*0.5);
}



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
			case HITLOC_TorsoFront:
			case HITLOC_LeftArmFront:
			case HITLOC_RightArmFront:
			case HITLOC_LeftLegFront:
			case HITLOC_RightLegFront:
				animName = 'HitFront';
				break;

			case HITLOC_HeadBack:
			case HITLOC_TorsoBack:
			case HITLOC_LeftArmBack:
			case HITLOC_RightArmBack:
			case HITLOC_LeftLegBack:
			case HITLOC_RightLegBack:
				animName = 'HitBack';
				break;
		}
		pivot = vect(0,0,0);
	}

	if (animName != '')
		PlayAnimPivot(animName, , 0.1, pivot);
}

// sound functions
function PlayEatingSound()
{
	PlaySound(sound'KarkianEat', SLOT_None,,, 384);
}

function PlayIdleSound()
{
	PlaySound(sound'KarkianIdle', SLOT_None);
}

function PlayScanningSound()
{
	if (FRand() < 0.3)
		PlaySound(sound'KarkianIdle', SLOT_None);
}

function PlayTargetAcquiredSound()
{
	PlaySound(sound'KarkianAlert', SLOT_None);
}

function PlayCriticalDamageSound()
{
	PlaySound(sound'KarkianFlee', SLOT_None);
}

defaultproperties
{
     bPlayDying=True
     FoodClass=Class'DeusEx.DeusExCarcass'
     bPauseWhenEating=True
     bMessyEater=True
     bFoodOverridesAttack=True
     MinHealth=50.000000
     CarcassType=Class'DeusEx.KarkianCarcass'
     WalkingSpeed=0.200000
     bCanBleed=True
     bShowPain=False
     ShadowScale=1.000000
     InitialAlliances(0)=(AllianceName=Greasel,AllianceLevel=1.000000,bPermanent=True)
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponKarkianBite')
     InitialInventory(1)=(Inventory=Class'DeusEx.WeaponKarkianBump')
     WalkSound=Sound'DeusExSounds.Animal.KarkianFootstep'
     bSpawnBubbles=False
     bCanSwim=True
     bCanGlide=False
     GroundSpeed=400.000000
     WaterSpeed=110.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     BaseEyeHeight=12.500000
     Health=400
     UnderWaterTime=99999.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'DeusExSounds.Animal.KarkianPainSmall'
     HitSound2=Sound'DeusExSounds.Animal.KarkianPainLarge'
     Die=Sound'DeusExSounds.Animal.KarkianDeath'
     Alliance=Karkian
     DrawType=DT_Mesh
     Mesh=LodMesh'DeusExCharacters.Karkian'
     CollisionRadius=54.000000
     CollisionHeight=37.099998
     Mass=500.000000
     Buoyancy=500.000000
     RotationRate=(Yaw=30000)
     BindName="Karkian"
     FamiliarName="Karkian"
     UnfamiliarName="Karkian"
}
