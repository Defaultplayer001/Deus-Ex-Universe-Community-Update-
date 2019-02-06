//=============================================================================
// WeaponSawedOffShotgun.
//=============================================================================
class WeaponSawedOffShotgun extends DeusExWeapon;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		HitDamage = mpHitDamage;
		BaseAccuracy = mpBaseAccuracy;
		ReloadTime = mpReloadTime;
		AccurateRange = mpAccurateRange;
		MaxRange = mpMaxRange;
		ReloadCount = mpReloadCount;
      PickupAmmoCount = 12; //to match assaultshotgun
	}
}

defaultproperties
{
     LowAmmoWaterMark=4
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     ShotTime=0.300000
     reloadTime=3.000000
     HitDamage=5
     maxRange=2400
     AccurateRange=1200
     BaseAccuracy=0.600000
     AmmoNames(0)=Class'DeusEx.AmmoShell'
     AmmoNames(1)=Class'DeusEx.AmmoSabot'
     AreaOfEffect=AOE_Cone
     recoilStrength=0.500000
     mpReloadTime=0.500000
     mpHitDamage=9
     mpBaseAccuracy=0.200000
     mpAccurateRange=1200
     mpMaxRange=1200
     mpReloadCount=6
     mpPickupAmmoCount=12
     bCanHaveModReloadCount=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     AmmoName=Class'DeusEx.AmmoShell'
     ReloadCount=4
     PickupAmmoCount=4
     bInstantHit=True
     FireOffset=(X=-11.000000,Y=4.000000,Z=13.000000)
     shakemag=50.000000
     FireSound=Sound'DeusExSounds.Weapons.SawedOffShotgunFire'
     AltFireSound=Sound'DeusExSounds.Weapons.SawedOffShotgunReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.SawedOffShotgunReload'
     SelectSound=Sound'DeusExSounds.Weapons.SawedOffShotgunSelect'
     InventoryGroup=6
     ItemName="Sawed-off Shotgun"
     PlayerViewOffset=(X=11.000000,Y=-4.000000,Z=-13.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Shotgun'
     PickupViewMesh=LodMesh'DeusExItems.ShotgunPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.Shotgun3rd'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconShotgun'
     largeIcon=Texture'DeusExUI.Icons.LargeIconShotgun'
     largeIconWidth=131
     largeIconHeight=45
     invSlotsX=3
     Description="The sawed-off, pump-action shotgun features a truncated barrel resulting in a wide spread at close range and will accept either buckshot or sabot shells."
     beltDescription="SAWED-OFF"
     Mesh=LodMesh'DeusExItems.ShotgunPickup'
     CollisionRadius=12.000000
     CollisionHeight=0.900000
     Mass=15.000000
}
