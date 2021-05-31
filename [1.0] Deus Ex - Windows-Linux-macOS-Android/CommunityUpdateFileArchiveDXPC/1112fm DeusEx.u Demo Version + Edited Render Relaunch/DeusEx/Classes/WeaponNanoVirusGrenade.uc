//=============================================================================
// WeaponNanoVirusGrenade.
//=============================================================================
class WeaponNanoVirusGrenade extends DeusExWeapon;

function Fire(float Value)
{
	// if facing a wall, affix the NanoVirusGrenade to the wall
	if (Pawn(Owner) != None)
	{
		if (bNearWall)
		{
			bReadyToFire = False;
			GotoState('NormalFire');
			bPointing = True;
			PlayAnim('Place',, 0.1);
			return;
		}
	}

	// otherwise, throw as usual
	Super.Fire(Value);
}

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Projectile proj;

	proj = Super.ProjectileFire(ProjClass, ProjSpeed, bWarn);

	if (proj != None)
		proj.PlayAnim('Open');
}

defaultproperties
{
     LowAmmoWaterMark=2
     GoverningSkill=Class'DeusEx.SkillDemolition'
     EnemyEffective=ENMEFF_Robot
     Concealability=CONC_All
     ShotTime=0.300000
     reloadTime=0.100000
     HitDamage=0
     maxRange=4800
     AccurateRange=2400
     BaseAccuracy=1.000000
     bPenetrating=False
     bHasMuzzleFlash=False
     bHandToHand=True
     bUseAsDrawnWeapon=False
     AITimeLimit=3.500000
     AIFireDelay=5.000000
     AmmoName=Class'DeusEx.AmmoNanoVirusGrenade'
     ReloadCount=1
     PickupAmmoCount=1
     FireOffset=(Y=10.000000,Z=20.000000)
     ProjectileClass=Class'DeusEx.NanoVirusGrenade'
     shakemag=50.000000
     SelectSound=Sound'DeusExSounds.Weapons.NanoVirusGrenadeSelect'
     InventoryGroup=23
     ItemName="Scramble Grenade"
     PlayerViewOffset=(X=24.000000,Y=-15.000000,Z=-19.000000)
     PlayerViewMesh=LodMesh'DeusExItems.NanoVirusGrenade'
     PickupViewMesh=LodMesh'DeusExItems.NanoVirusGrenadePickup'
     ThirdPersonMesh=LodMesh'DeusExItems.NanoVirusGrenade3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconWeaponNanoVirus'
     largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponNanoVirus'
     largeIconWidth=24
     largeIconHeight=49
     Description="The detonation of a GUARDIAN scramble grenade broadcasts a short-range, polymorphic broadband assault on the command frequencies used by almost all bots manufactured since 2028. The ensuing electronic storm causes bots within its radius of effect to indiscriminately attack other bots until command control can be re-established. Like a LAM, scramble grenades can be attached to any surface."
     beltDescription="SCRM GREN"
     Mesh=LodMesh'DeusExItems.NanoVirusGrenadePickup'
     CollisionRadius=3.000000
     CollisionHeight=2.430000
     Mass=5.000000
     Buoyancy=2.000000
}
