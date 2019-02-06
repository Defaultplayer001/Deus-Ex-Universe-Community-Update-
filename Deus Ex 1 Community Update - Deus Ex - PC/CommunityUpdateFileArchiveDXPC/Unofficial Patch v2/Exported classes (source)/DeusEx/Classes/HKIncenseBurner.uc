//=============================================================================
// HKIncenseBurner.
//=============================================================================
class HKIncenseBurner extends HongKongDecoration;

var ParticleGenerator smokeGen;

#exec OBJ LOAD FILE=Effects

function Destroyed()
{
	if (smokeGen != None)
		smokeGen.DelayedDestroy();

	Super.Destroyed();
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	SetBase(Owner);
	smokeGen = Spawn(class'ParticleGenerator', Self,, Location + vect(0,0,1) * CollisionHeight * 0.6, rot(16384,0,0));
	if (smokeGen != None)
	{
		smokeGen.particleDrawScale = 0.2;
		smokeGen.checkTime = 0.25;
		smokeGen.frequency = 0.9;
		smokeGen.riseRate = 0.0;
		smokeGen.ejectSpeed = 10.0;
		smokeGen.particleLifeSpan = 4.0;
		smokeGen.bRandomEject = True;
		smokeGen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		smokeGen.SetBase(Self);
	}
}

defaultproperties
{
     FragType=Class'DeusEx.WoodFragment'
     bHighlight=True
     ItemName="Incense Burner"
     Mesh=LodMesh'DeusExDeco.HKIncenseBurner'
     SoundRadius=8
     SoundVolume=32
     SoundPitch=72
     AmbientSound=Sound'DeusExSounds.Generic.Flare'
     CollisionRadius=13.000000
     CollisionHeight=27.000000
     Mass=20.000000
     Buoyancy=5.000000
}
