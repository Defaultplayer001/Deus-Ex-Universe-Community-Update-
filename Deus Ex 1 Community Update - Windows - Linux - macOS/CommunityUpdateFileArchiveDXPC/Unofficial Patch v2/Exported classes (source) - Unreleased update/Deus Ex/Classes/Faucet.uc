//=============================================================================
// Faucet.
//=============================================================================
class Faucet extends DeusExDecoration;

#exec OBJ LOAD FILE=Ambient
#exec OBJ LOAD FILE=MoverSFX
#exec OBJ LOAD FILE=Effects

var() bool				bOpen;
var ParticleGenerator	waterGen;

function Destroyed()
{
	if (waterGen != None)
		waterGen.DelayedDestroy();

	Super.Destroyed();
}

function Frob(actor Frobber, Inventory frobWith)
{
	Super.Frob(Frobber, frobWith);

	bOpen = !bOpen;
	if (bOpen)
	{
		PlaySound(sound'ValveOpen',,,, 256, 2.0);
		PlayAnim('On');

		if (waterGen != None)
			waterGen.Trigger(Frobber, Pawn(Frobber));

		// extinguish the player if he frobbed this
		if (DeusExPlayer(Frobber) != None)
			if (DeusExPlayer(Frobber).bOnFire)
				DeusExPlayer(Frobber).ExtinguishFire();
	}
	else
	{
		PlaySound(sound'ValveClose',,,, 256, 2.0);
		PlayAnim('Off');

		if (waterGen != None)
			waterGen.UnTrigger(Frobber, Pawn(Frobber));
	}
}

function PostBeginPlay()
{
	local Vector loc;

	Super.PostBeginPlay();

	// spawn a particle generator
	// rotate the spray offsets into object coordinate space
	loc = vect(0,0,0);
	loc.X += CollisionRadius * 0.9;
	loc = loc >> Rotation;
	loc += Location;

	waterGen = Spawn(class'ParticleGenerator', Self,, loc, Rotation-rot(12288,0,0));
	if (waterGen != None)
	{
		waterGen.particleDrawScale = 0.05;
		waterGen.checkTime = 0.05;
		waterGen.frequency = 1.0;
		waterGen.bGravity = True;
		waterGen.bScale = False;
		waterGen.bFade = True;
		waterGen.ejectSpeed = 50.0;
		waterGen.particleLifeSpan = 0.5;
		waterGen.numPerSpawn = 5;
		waterGen.bRandomEject = True;
		waterGen.particleTexture = Texture'Effects.Generated.WtrDrpSmall';
		waterGen.bAmbientSound = True;
		waterGen.AmbientSound = Sound'Sink';
		waterGen.SoundRadius = 16;
		waterGen.bTriggered = True;
		waterGen.bInitiallyOn = bOpen;
		waterGen.SetBase(Self);
	}

	// play the correct startup animation
	if (bOpen)
		PlayAnim('On', 10.0, 0.001);
	else
		PlayAnim('Off', 10.0, 0.001);
}

defaultproperties
{
     bInvincible=True
     ItemName="Faucet"
     bPushable=False
     Physics=PHYS_None
     Mesh=LodMesh'DeusExDeco.Faucet'
     CollisionRadius=11.200000
     CollisionHeight=4.800000
     Mass=20.000000
     Buoyancy=10.000000
}
