//=============================================================================
// NanoVirusGrenade.
//=============================================================================
class NanoVirusGrenade extends ThrownProjectile;

simulated function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
	local ExplosionLight light;
	local int i;
	local Rotator rot;
	local SphereEffect sphere;
   local ExplosionSmall expeffect;

	// draw a pretty explosion
	light = Spawn(class'ExplosionLight',,, HitLocation);
	if (light != None)
	{
      if (!bDamaged)
         light.RemoteRole = ROLE_None;
		light.size = 8;
		light.LightHue = 128;
		light.LightSaturation = 96;
		light.LightEffect = LE_Shell;
	}

	expeffect = Spawn(class'ExplosionSmall',,, HitLocation);
   if ((expeffect != None) && (!bDamaged))
      expeffect.RemoteRole = ROLE_None;

	// draw a cool light sphere
	sphere = Spawn(class'SphereEffect',,, HitLocation);
	if (sphere != None)
   {
      if (!bDamaged)
         sphere.RemoteRole = ROLE_None;
		sphere.size = blastRadius / 32.0;
   }
}

defaultproperties
{
     fuseLength=3.000000
     proxRadius=128.000000
     AISoundLevel=0.100000
     bBlood=False
     bDebris=False
     DamageType=NanoVirus
     spawnWeaponClass=Class'DeusEx.WeaponNanoVirusGrenade'
     ItemName="Scramble Grenade"
     speed=1000.000000
     MaxSpeed=1000.000000
     Damage=100.000000
     MomentumTransfer=50000
     ImpactSound=Sound'DeusExSounds.Weapons.NanoVirusGrenadeExplode'
     LifeSpan=0.000000
     Mesh=LodMesh'DeusExItems.NanoVirusGrenadePickup'
     CollisionRadius=2.630000
     CollisionHeight=4.410000
     Mass=5.000000
     Buoyancy=2.000000
}
