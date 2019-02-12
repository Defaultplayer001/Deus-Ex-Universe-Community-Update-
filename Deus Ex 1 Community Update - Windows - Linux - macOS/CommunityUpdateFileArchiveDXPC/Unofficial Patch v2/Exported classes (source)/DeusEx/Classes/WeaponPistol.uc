//=============================================================================
// WeaponPistol.
//=============================================================================
class WeaponPistol extends DeusExWeapon;

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
	}
}

defaultproperties
{
     LowAmmoWaterMark=6
     GoverningSkill=Class'DeusEx.SkillWeaponPistol'
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     ShotTime=0.600000
     reloadTime=2.000000
     HitDamage=14
     maxRange=4800
     AccurateRange=2400
     BaseAccuracy=0.700000
     bCanHaveScope=True
     ScopeFOV=25
     bCanHaveLaser=True
     recoilStrength=0.300000
     mpReloadTime=2.000000
     mpHitDamage=20
     mpBaseAccuracy=0.200000
     mpAccurateRange=1200
     mpMaxRange=1200
     mpReloadCount=9
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     AmmoName=Class'DeusEx.Ammo10mm'
     ReloadCount=6
     PickupAmmoCount=6
     bInstantHit=True
     FireOffset=(X=-22.000000,Y=10.000000,Z=14.000000)
     shakemag=50.000000
     FireSound=Sound'DeusExSounds.Weapons.PistolFire'
     CockingSound=Sound'DeusExSounds.Weapons.PistolReload'
     SelectSound=Sound'DeusExSounds.Weapons.PistolSelect'
     InventoryGroup=2
     ItemName="Pistol"
     PlayerViewOffset=(X=22.000000,Y=-10.000000,Z=-14.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Glock'
     PickupViewMesh=LodMesh'DeusExItems.GlockPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.Glock3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconPistol'
     largeIcon=Texture'DeusExUI.Icons.LargeIconPistol'
     largeIconWidth=46
     largeIconHeight=28
     Description="A standard 10mm pistol."
     beltDescription="PISTOL"
     Mesh=LodMesh'DeusExItems.GlockPickup'
     CollisionRadius=7.000000
     CollisionHeight=1.000000
}
