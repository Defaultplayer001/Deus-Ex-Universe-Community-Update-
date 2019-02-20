//=============================================================================
// Doberman.
//=============================================================================
class Doberman extends Dog;

function PlayDogBark()
{
	if (FRand() < 0.5)
		PlaySound(sound'DogLargeBark2', SLOT_None);
	else
		PlaySound(sound'DogLargeBark3', SLOT_None);
}

defaultproperties
{
     CarcassType=Class'DeusEx.DobermanCarcass'
     WalkingSpeed=0.200000
     GroundSpeed=250.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     Health=20
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'DeusExSounds.Animal.DogLargeGrowl'
     HitSound2=Sound'DeusExSounds.Animal.DogLargeBark1'
     Die=Sound'DeusExSounds.Animal.DogLargeDie'
     DrawType=DT_Mesh
     Mesh=LodMesh'DeusExCharacters.Doberman'
     CollisionRadius=30.000000
     CollisionHeight=28.000000
     Mass=25.000000
     BindName="Doberman"
     FamiliarName="Doberman"
     UnfamiliarName="Doberman"
}
