//=============================================================================
// WeaponRobotMachinegun.
//=============================================================================
class WeaponRobotMachinegun extends WeaponNPCRanged;

defaultproperties
{
     ShotTime=0.100000
     reloadTime=1.000000
     HitDamage=6
     BaseAccuracy=0.600000
     bHasMuzzleFlash=True
     AmmoName=Class'DeusEx.Ammo762mm'
     PickupAmmoCount=50
     bInstantHit=True
     FireSound=Sound'DeusExSounds.Robot.RobotFireGun'
     CockingSound=Sound'DeusExSounds.Weapons.AssaultGunReload'
     SelectSound=Sound'DeusExSounds.Weapons.AssaultGunSelect'
}
