//=============================================================================
// Rocket.
//=============================================================================
class Rocket extends DeusExProjectile;

var float mpBlastRadius;

var ParticleGenerator fireGen;
var ParticleGenerator smokeGen;

function PostBeginPlay()
{
	Super.PostBeginPlay();

   if (Level.NetMode == NM_DedicatedServer)
      return;
   
   SpawnRocketEffects();
}

simulated function PostNetBeginPlay()
{
   Super.PostNetBeginPlay();
   
   if (Role != ROLE_Authority)
      SpawnRocketEffects();
}

simulated function SpawnRocketEffects()
{
	fireGen = Spawn(class'ParticleGenerator', Self);
	if (fireGen != None)
	{
      fireGen.RemoteRole = ROLE_None;
		fireGen.particleTexture = Texture'Effects.Fire.Fireball1';
		fireGen.particleDrawScale = 0.1;
		fireGen.checkTime = 0.01;
		fireGen.riseRate = 0.0;
		fireGen.ejectSpeed = 0.0;
		fireGen.particleLifeSpan = 0.1;
		fireGen.bRandomEject = True;
		fireGen.SetBase(Self);
	}
	smokeGen = Spawn(class'ParticleGenerator', Self);
	if (smokeGen != None)
	{
      smokeGen.RemoteRole = ROLE_None;
		smokeGen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		smokeGen.particleDrawScale = 0.3;
		smokeGen.checkTime = 0.02;
		smokeGen.riseRate = 8.0;
		smokeGen.ejectSpeed = 0.0;
		smokeGen.particleLifeSpan = 2.0;
		smokeGen.bRandomEject = True;
		smokeGen.SetBase(Self);
	}
}

simulated function Destroyed()
{
	if (smokeGen != None)
		smokeGen.DelayedDestroy();
	if (fireGen != None)
		fireGen.DelayedDestroy();

	Super.Destroyed();
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( ( Level.NetMode != NM_Standalone ) && (Class == Class'Rocket') )
	{
		blastRadius = mpBlastRadius;
      speed = 2000.0000;
      SetTimer(5,false);
		SoundRadius = 64;
	}
}

simulated function Timer()
{
   if (Level.NetMode != NM_Standalone)
   {   
      Explode(Location, vect(0,0,1));
   }
}

defaultproperties
{
     mpBlastRadius=192.000000
     bExplodes=True
     bBlood=True
     bDebris=True
     blastRadius=192.000000
     DamageType=exploded
     AccurateRange=14400
     maxRange=24000
     bTracking=True
     ItemName="GEP Rocket"
     ItemArticle="a"
     speed=1000.000000
     MaxSpeed=1500.000000
     Damage=300.000000
     MomentumTransfer=10000
     SpawnSound=Sound'DeusExSounds.Weapons.GEPGunFire'
     ImpactSound=Sound'DeusExSounds.Generic.SmallExplosion1'
     ExplosionDecal=Class'DeusEx.ScorchMark'
     Mesh=LodMesh'DeusExItems.Rocket'
     DrawScale=0.250000
     SoundRadius=16
     SoundVolume=224
     AmbientSound=Sound'DeusExSounds.Special.RocketLoop'
     RotationRate=(Pitch=32768,Yaw=32768)
}
