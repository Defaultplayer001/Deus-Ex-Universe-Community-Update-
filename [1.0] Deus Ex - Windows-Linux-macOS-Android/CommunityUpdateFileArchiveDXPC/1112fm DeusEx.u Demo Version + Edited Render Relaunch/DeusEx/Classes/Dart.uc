//=============================================================================
// Dart.
//=============================================================================
class Dart extends DeusExProjectile;

var float mpDamage;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
		Damage = mpDamage;
}

defaultproperties
{
     mpDamage=20.000000
     bBlood=True
     bStickToWall=True
     DamageType=shot
     spawnAmmoClass=Class'DeusEx.AmmoDart'
     bIgnoresNanoDefense=True
     ItemName="Dart"
     ItemArticle="a"
     speed=2000.000000
     MaxSpeed=3000.000000
     Damage=15.000000
     MomentumTransfer=1000
     ImpactSound=Sound'DeusExSounds.Generic.BulletHitFlesh'
     Mesh=LodMesh'DeusExItems.Dart'
     CollisionRadius=3.000000
     CollisionHeight=0.500000
}
