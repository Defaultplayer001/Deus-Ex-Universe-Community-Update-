//=============================================================================
// WeaponProd.
//=============================================================================
class WeaponProd extends DeusExWeapon;

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
     LowAmmoWaterMark=4
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     EnemyEffective=ENMEFF_Organic
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     ShotTime=1.000000
     reloadTime=3.000000
     HitDamage=15
     maxRange=80
     AccurateRange=80
     bPenetrating=False
     StunDuration=10.000000
     bHasMuzzleFlash=False
     mpReloadTime=3.000000
     mpHitDamage=15
     mpBaseAccuracy=0.500000
     mpAccurateRange=80
     mpMaxRange=80
     mpReloadCount=4
     AmmoName=Class'DeusEx.AmmoBattery'
     ReloadCount=4
     PickupAmmoCount=4
     bInstantHit=True
     FireOffset=(X=-21.000000,Y=12.000000,Z=19.000000)
     shakemag=20.000000
     FireSound=Sound'DeusExSounds.Weapons.ProdFire'
     AltFireSound=Sound'DeusExSounds.Weapons.ProdReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.ProdReload'
     SelectSound=Sound'DeusExSounds.Weapons.ProdSelect'
     InventoryGroup=19
     ItemName="Riot Prod"
     PlayerViewOffset=(X=21.000000,Y=-12.000000,Z=-19.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Prod'
     PickupViewMesh=LodMesh'DeusExItems.ProdPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.Prod3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconProd'
     largeIcon=Texture'DeusExUI.Icons.LargeIconProd'
     largeIconWidth=49
     largeIconHeight=48
     Description="The riot prod has been extensively used by security forces who wish to keep what remains of the crumbling peace and have found the prod to be an valuable tool. Its short range tetanizing effect is most effective when applied to the torso or when the subject is taken by surprise."
     beltDescription="PROD"
     Mesh=LodMesh'DeusExItems.ProdPickup'
     CollisionRadius=8.750000
     CollisionHeight=1.350000
}
