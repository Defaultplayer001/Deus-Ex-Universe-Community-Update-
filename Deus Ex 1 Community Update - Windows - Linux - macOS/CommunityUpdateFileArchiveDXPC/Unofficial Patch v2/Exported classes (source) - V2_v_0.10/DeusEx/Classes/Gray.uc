//=============================================================================
// Gray.
//=============================================================================
class Gray extends Animal;

#exec OBJ LOAD FILE=Ambient

var float damageRadius;
var float damageInterval;
var float damageAmount;
var float damageTime;

// check every damageInterval seconds and damage any player near the gray
function Tick(float deltaTime)
{
	local DeusExPlayer player;

	damageTime += deltaTime;

	if (damageTime >= damageInterval)
	{
		damageTime = 0;
		foreach VisibleActors(class'DeusExPlayer', player, damageRadius)
			if (player != None)
				player.TakeDamage(damageAmount, Self, player.Location, vect(0,0,0), 'Radiation');
	}

	Super.Tick(deltaTime);
}

function ComputeFallDirection(float totalTime, int numFrames,
                              out vector moveDir, out float stopTime)
{
	// Determine direction, and how long to slide
	if (AnimSequence == 'DeathFront')
	{
		moveDir = Vector(DesiredRotation) * Default.CollisionRadius*2.0;
		stopTime = totalTime*0.7;
	}
	else if (AnimSequence == 'DeathBack')
	{
		moveDir = -Vector(DesiredRotation) * Default.CollisionRadius*1.8;
		stopTime = totalTime*0.65;
	}
}

function bool FilterDamageType(Pawn instigatedBy, Vector hitLocation,
                               Vector offset, Name damageType)
{
	// Grays aren't affected by radiation or fire or gas
	if ((damageType == 'Radiation') || (damageType == 'Flamed') || (damageType == 'Burned'))
		return false;
	else if ((damageType == 'TearGas') || (damageType == 'HalonGas') || (damageType == 'PoisonGas'))
		return false;
	else
		return Super.FilterDamageType(instigatedBy, hitLocation, offset, damageType);
}

function GotoDisabledState(name damageType, EHitLocation hitPos)
{
	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	else if (damageType == 'Stunned')
		GotoNextState();
	else if (CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
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
	if ((Weapon != None) && Weapon.IsA('WeaponGraySpit'))
		PlayAnimPivot('Shoot');
	else
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
function PlayIdleSound()
{
	if (FRand() < 0.5)
		PlaySound(sound'GrayIdle', SLOT_None);
	else
		PlaySound(sound'GrayIdle2', SLOT_None);
}

function PlayScanningSound()
{
	if (FRand() < 0.3)
	{
		if (FRand() < 0.5)
			PlaySound(sound'GrayIdle', SLOT_None);
		else
			PlaySound(sound'GrayIdle2', SLOT_None);
	}
}

function PlayTargetAcquiredSound()
{
	PlaySound(sound'GrayAlert', SLOT_None);
}

function PlayCriticalDamageSound()
{
	PlaySound(sound'GrayFlee', SLOT_None);
}

defaultproperties
{
     DamageRadius=256.000000
     damageInterval=1.000000
     DamageAmount=10.000000
     bPlayDying=True
     MinHealth=10.000000
     CarcassType=Class'DeusEx.GrayCarcass'
     WalkingSpeed=0.280000
     bCanBleed=True
     CloseCombatMult=0.500000
     ShadowScale=0.750000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponGraySwipe')
     InitialInventory(1)=(Inventory=Class'DeusEx.WeaponGraySpit')
     InitialInventory(2)=(Inventory=Class'DeusEx.AmmoGraySpit',Count=9999)
     WalkSound=Sound'DeusExSounds.Animal.GrayFootstep'
     GroundSpeed=350.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     BaseEyeHeight=25.000000
     Health=50
     ReducedDamageType=Radiation
     ReducedDamagePct=1.000000
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'DeusExSounds.Animal.GrayPainSmall'
     HitSound2=Sound'DeusExSounds.Animal.GrayPainLarge'
     Die=Sound'DeusExSounds.Animal.GrayDeath'
     Alliance=Gray
     DrawType=DT_Mesh
     Mesh=LodMesh'DeusExCharacters.Gray'
     AmbientGlow=12
     SoundRadius=14
     SoundVolume=255
     AmbientSound=Sound'Ambient.Ambient.GeigerLoop'
     CollisionRadius=28.540001
     CollisionHeight=36.000000
     LightType=LT_Steady
     LightBrightness=32
     LightHue=96
     LightSaturation=128
     LightRadius=5
     Mass=120.000000
     Buoyancy=97.000000
     BindName="Gray"
     FamiliarName="Gray"
     UnfamiliarName="Gray"
}
