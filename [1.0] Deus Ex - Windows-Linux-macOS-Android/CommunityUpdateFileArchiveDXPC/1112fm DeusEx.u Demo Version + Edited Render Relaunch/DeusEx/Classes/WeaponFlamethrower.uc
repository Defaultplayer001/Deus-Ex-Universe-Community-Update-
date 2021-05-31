//=============================================================================
// WeaponFlamethrower.
//=============================================================================
class WeaponFlamethrower extends DeusExWeapon;

var int BurnTime, BurnDamage;

var int		mpBurnTime;
var int		mpBurnDamage;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
      HitDamage = mpHitDamage;
      BaseAccuracy=mpBaseAccuracy;
      ReloadTime = mpReloadTime;
      AccurateRange = mpAccurateRange;
      MaxRange = mpMaxRange;
      ReloadCount = mpReloadCount;
      BurnTime = mpBurnTime;
      BurnDamage = mpBurnDamage;
      PickupAmmoCount = mpReloadCount;
	}
}

defaultproperties
{
     burnTime=30
     BurnDamage=5
     mpBurnTime=15
     mpBurnDamage=2
     LowAmmoWaterMark=50
     GoverningSkill=Class'DeusEx.SkillWeaponHeavy'
     EnviroEffective=ENVEFF_Air
     bAutomatic=True
     ShotTime=0.100000
     reloadTime=5.500000
     HitDamage=2
     maxRange=320
     AccurateRange=320
     BaseAccuracy=0.900000
     bHasMuzzleFlash=False
     mpReloadTime=0.500000
     mpHitDamage=5
     mpBaseAccuracy=0.900000
     mpAccurateRange=320
     mpMaxRange=320
     mpReloadCount=100
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     AmmoName=Class'DeusEx.AmmoNapalm'
     ReloadCount=100
     PickupAmmoCount=100
     FireOffset=(Y=10.000000,Z=10.000000)
     ProjectileClass=Class'DeusEx.Fireball'
     shakemag=10.000000
     FireSound=Sound'DeusExSounds.Weapons.FlamethrowerFire'
     AltFireSound=Sound'DeusExSounds.Weapons.FlamethrowerReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.FlamethrowerReload'
     SelectSound=Sound'DeusExSounds.Weapons.FlamethrowerSelect'
     InventoryGroup=15
     ItemName="Flamethrower"
     PlayerViewOffset=(X=20.000000,Y=-14.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Flamethrower'
     PickupViewMesh=LodMesh'DeusExItems.FlamethrowerPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.Flamethrower3rd'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconFlamethrower'
     largeIcon=Texture'DeusExUI.Icons.LargeIconFlamethrower'
     largeIconWidth=203
     largeIconHeight=69
     invSlotsX=4
     invSlotsY=2
     Description="A portable flamethrower that discards the old and highly dangerous backpack fuel delivery system in favor of pressurized canisters of napalm. Inexperienced agents will find that a flamethrower can be difficult to maneuver, however."
     beltDescription="FLAMETHWR"
     Mesh=LodMesh'DeusExItems.FlamethrowerPickup'
     CollisionRadius=20.500000
     CollisionHeight=4.400000
     Mass=40.000000
}
