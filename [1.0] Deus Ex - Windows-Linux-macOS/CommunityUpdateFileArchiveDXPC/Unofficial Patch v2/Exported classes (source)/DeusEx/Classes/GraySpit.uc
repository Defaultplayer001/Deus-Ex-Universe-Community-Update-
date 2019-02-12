//=============================================================================
// GraySpit.
//=============================================================================
class GraySpit extends DeusExProjectile;

simulated function Tick(float deltaTime)
{
	time += deltaTime;

	// scale it up as it flies
	DrawScale = FClamp(2.5*(time+0.5), 1.0, 6.0);
}

defaultproperties
{
     DamageType=Radiation
     AccurateRange=300
     maxRange=450
     bIgnoresNanoDefense=True
     speed=350.000000
     MaxSpeed=400.000000
     Damage=8.000000
     MomentumTransfer=200
     SpawnSound=Sound'DeusExSounds.Animal.GrayShoot'
     Style=STY_Translucent
     Mesh=LodMesh'DeusExItems.GraySpit'
     ScaleGlow=2.000000
     bFixedRotationDir=True
     RotationRate=(Pitch=0,Yaw=0,Roll=131071)
}
