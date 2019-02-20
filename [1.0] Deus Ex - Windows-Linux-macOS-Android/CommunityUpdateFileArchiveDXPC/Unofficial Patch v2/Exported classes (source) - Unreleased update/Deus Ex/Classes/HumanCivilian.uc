//=============================================================================
// HumanCivilian.
//=============================================================================
class HumanCivilian extends ScriptedPawn
	abstract;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	// Eventually, these will all be unique sounds per NPC specified in
	// the defaultproperties

	// change the sounds for chicks
	if (bIsFemale)
	{
		HitSound1 = Sound'FemalePainMedium';
		HitSound2 = Sound'FemalePainLarge';
		Die = Sound'FemaleDeath';
	}

	// change the sounds for kids
	if (IsA('ChildMale') || IsA('ChildMale2'))
	{
		HitSound1 = Sound'ChildPainMedium';
		HitSound2 = Sound'ChildPainLarge';
		Die = Sound'ChildDeath';
	}
}

function bool WillTakeStompDamage(actor stomper)
{
	// This blows chunks!
	if (stomper.IsA('PlayerPawn') && (GetPawnAllianceType(Pawn(stomper)) != ALLIANCE_Hostile))
		return false;
	else
		return true;
}

defaultproperties
{
     BaseAccuracy=1.200000
     maxRange=400.000000
     MinHealth=40.000000
     bPlayIdle=True
     bAvoidAim=False
     bReactProjectiles=False
     bFearShot=True
     bFearIndirectInjury=True
     bFearCarcass=True
     bFearDistress=True
     bFearAlarm=True
     EnemyTimeout=1.500000
     bCanTurnHead=True
     bCanStrafe=False
     WaterSpeed=80.000000
     AirSpeed=160.000000
     AccelRate=500.000000
     BaseEyeHeight=40.000000
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'DeusExSounds.Player.MalePainSmall'
     HitSound2=Sound'DeusExSounds.Player.MalePainMedium'
     Die=Sound'DeusExSounds.Player.MaleDeath'
     VisibilityThreshold=0.010000
     DrawType=DT_Mesh
     Mass=150.000000
     Buoyancy=155.000000
     BindName="HumanCivilian"
}
