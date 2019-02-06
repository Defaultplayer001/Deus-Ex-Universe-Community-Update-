//=============================================================================
// WeaponAssaultShotgun.
//=============================================================================
class WeaponAssaultShotgun extends DeusExWeapon;

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
     LowAmmoWaterMark=12
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     EnviroEffective=ENVEFF_Air
     bAutomatic=True
     ShotTime=0.700000
     reloadTime=4.500000
     HitDamage=4
     maxRange=2400
     AccurateRange=1200
     BaseAccuracy=0.800000
     AmmoNames(0)=Class'DeusEx.AmmoShell'
     AmmoNames(1)=Class'DeusEx.AmmoSabot'
     AreaOfEffect=AOE_Cone
     recoilStrength=0.700000
     mpReloadTime=0.500000
     mpHitDamage=5
     mpBaseAccuracy=0.200000
     mpAccurateRange=1800
     mpMaxRange=1800
     mpReloadCount=12
     bCanHaveModReloadCount=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     AmmoName=Class'DeusEx.AmmoShell'
     ReloadCount=12
     PickupAmmoCount=12
     bInstantHit=True
     FireOffset=(X=-30.000000,Y=10.000000,Z=12.000000)
     shakemag=50.000000
     FireSound=Sound'DeusExSounds.Weapons.AssaultShotgunFire'
     AltFireSound=Sound'DeusExSounds.Weapons.AssaultShotgunReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.AssaultShotgunReload'
     SelectSound=Sound'DeusExSounds.Weapons.AssaultShotgunSelect'
     InventoryGroup=7
     ItemName="Assault Shotgun"
     ItemArticle="an"
     PlayerViewOffset=(Y=-10.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.AssaultShotgun'
     PickupViewMesh=LodMesh'DeusExItems.AssaultShotgunPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.AssaultShotgun3rd'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconAssaultShotgun'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAssaultShotgun'
     largeIconWidth=99
     largeIconHeight=55
     invSlotsX=2
     invSlotsY=2
     Description="The assault shotgun (sometimes referred to as a 'street sweeper') combines the best traits of a normal shotgun with a fully automatic feed that can clear an area of hostiles in a matter of seconds. Particularly effective in urban combat, the assault shotgun accepts either buckshot or sabot shells."
     beltDescription="SHOTGUN"
     Mesh=LodMesh'DeusExItems.AssaultShotgunPickup'
     CollisionRadius=15.000000
     CollisionHeight=8.000000
     Mass=30.000000
}
