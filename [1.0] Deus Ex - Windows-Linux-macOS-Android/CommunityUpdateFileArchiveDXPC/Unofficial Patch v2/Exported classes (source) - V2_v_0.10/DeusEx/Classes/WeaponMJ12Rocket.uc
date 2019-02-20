//=============================================================================
// WeaponMJ12Rocket.
//=============================================================================
class WeaponMJ12Rocket extends WeaponNPCRanged;

// fire weapons out of alternating sides
function Fire(float Value)
{
	PlayerViewOffset.Y = -PlayerViewOffset.Y;
	Super.Fire(Value);
}

defaultproperties
{
     ShotTime=0.500000
     HitDamage=50
     AIMinRange=500.000000
     AIMaxRange=2000.000000
     AmmoName=Class'DeusEx.AmmoRocketMini'
     PickupAmmoCount=20
     ProjectileClass=Class'DeusEx.RocketMini'
     PlayerViewOffset=(Y=-24.000000,Z=-12.000000)
}
