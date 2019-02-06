//=============================================================================
// WeaponNPCRanged.
//=============================================================================
class WeaponNPCRanged extends DeusExWeapon
	abstract;

defaultproperties
{
     LowAmmoWaterMark=0
     EnemyEffective=ENMEFF_Organic
     ShotTime=0.300000
     reloadTime=0.000000
     BaseAccuracy=0.300000
     bHasMuzzleFlash=False
     bOwnerWillNotify=True
     bNativeAttack=True
     ReloadCount=159
     shakemag=0.000000
     Misc1Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitFlesh'
     Misc2Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitHard'
     Misc3Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitSoft'
     InventoryGroup=99
     PlayerViewOffset=(X=0.000000,Z=0.000000)
     PlayerViewMesh=LodMesh'DeusExItems.InvisibleWeapon'
     PickupViewMesh=LodMesh'DeusExItems.InvisibleWeapon'
     ThirdPersonMesh=LodMesh'DeusExItems.InvisibleWeapon'
     Icon=None
     largeIconWidth=1
     largeIconHeight=1
     Mesh=LodMesh'DeusExItems.InvisibleWeapon'
     CollisionRadius=1.000000
     CollisionHeight=1.000000
     Mass=5.000000
}
