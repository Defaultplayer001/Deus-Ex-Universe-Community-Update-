//=============================================================================
// LAM.
//=============================================================================
class LAM extends ThrownProjectile;

var float	mpBlastRadius;
var float	mpProxRadius;
var float	mpLAMDamage;
var float	mpFuselength;

simulated function Tick(float deltaTime)
{
	local float blinkRate;

	Super.Tick(deltaTime);

	if (bDisabled)
	{
		Skin = Texture'BlackMaskTex';
		return;
	}

	// flash faster as the time expires
	if (fuseLength - time <= 0.75)
		blinkRate = 0.1;
	else if (fuseLength - time <= fuseLength * 0.5)
		blinkRate = 0.3;
	else
		blinkRate = 0.5;

   if ((Level.NetMode == NM_Standalone) || (Role < ROLE_Authority) || (Level.NetMode == NM_ListenServer))
   {
      if (Abs((fuseLength - time)) % blinkRate > blinkRate * 0.5)
         Skin = Texture'BlackMaskTex';
      else
         Skin = Texture'LAM3rdTex1';
   }
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
	{
		blastRadius=mpBlastRadius;
		proxRadius=mpProxRadius;
		Damage=mpLAMDamage;
		fuseLength=mpFuselength;
		bIgnoresNanoDefense=True;
	}
}

defaultproperties
{
     mpBlastRadius=512.000000
     mpProxRadius=128.000000
     mpLAMDamage=500.000000
     mpFuselength=1.500000
     fuseLength=3.000000
     proxRadius=128.000000
     blastRadius=384.000000
     spawnWeaponClass=Class'DeusEx.WeaponLAM'
     ItemName="Lightweight Attack Munition (LAM)"
     speed=1000.000000
     MaxSpeed=1000.000000
     Damage=500.000000
     MomentumTransfer=50000
     ImpactSound=Sound'DeusExSounds.Weapons.LAMExplode'
     ExplosionDecal=Class'DeusEx.ScorchMark'
     LifeSpan=0.000000
     Mesh=LodMesh'DeusExItems.LAMPickup'
     CollisionRadius=4.300000
     CollisionHeight=3.800000
     Mass=5.000000
     Buoyancy=2.000000
}
