//=============================================================================
// ShowerFaucet.
//=============================================================================
class ShowerFaucet extends DeusExDecoration;

#exec OBJ LOAD FILE=Ambient
#exec OBJ LOAD FILE=MoverSFX
#exec OBJ LOAD FILE=Effects

var() bool				bOpen;
var ParticleGenerator	waterGen[4];
var Vector				sprayOffsets[4];

function Destroyed()
{
	local int i;

	for (i=0; i<4; i++)
		if (waterGen[i] != None)
			waterGen[i].DelayedDestroy();

	Super.Destroyed();
}

function Frob(actor Frobber, Inventory frobWith)
{
	local int i;

	Super.Frob(Frobber, frobWith);

	bOpen = !bOpen;
	if (bOpen)
	{
		PlaySound(sound'ValveOpen',,,, 256, 2.0);
		PlayAnim('On');

		for (i=0; i<4; i++)
			if (waterGen[i] != None)
				waterGen[i].Trigger(Frobber, Pawn(Frobber));

		// extinguish the player if he frobbed this
		if (DeusExPlayer(Frobber) != None)
			if (DeusExPlayer(Frobber).bOnFire)
				DeusExPlayer(Frobber).ExtinguishFire();
	}
	else
	{
		PlaySound(sound'ValveClose',,,, 256, 2.0);
		PlayAnim('Off');

		for (i=0; i<4; i++)
			if (waterGen[i] != None)
				waterGen[i].UnTrigger(Frobber, Pawn(Frobber));
	}
}

function PostBeginPlay()
{
	local ShowerHead head, linkedHead;
	local Vector loc;
	local int i;

	Super.PostBeginPlay();

	// find the matching shower head
	linkedHead = None;
	if (Tag != '')
		foreach AllActors(class'ShowerHead', head, Tag)
			linkedHead = head;

	// spawn a particle generator
	if (linkedHead != None)
	{
		for (i=0; i<4; i++)
		{
			// rotate the spray offsets into object coordinate space
			loc = sprayOffsets[i];
			loc.X += linkedHead.CollisionRadius * 0.7;
			loc.Z -= linkedHead.CollisionHeight * 0.85;
			loc = loc >> linkedHead.Rotation;
			loc += linkedHead.Location;

			waterGen[i] = Spawn(class'ParticleGenerator', linkedHead,, loc, linkedHead.Rotation-rot(8192,0,0));
			if (waterGen[i] != None)
			{
				waterGen[i].particleDrawScale = 0.05;
				waterGen[i].checkTime = 0.05;
				waterGen[i].frequency = 1.0;
				waterGen[i].bGravity = True;
				waterGen[i].bScale = False;
				waterGen[i].bFade = True;
				waterGen[i].ejectSpeed = 100.0;
				waterGen[i].particleLifeSpan = 1.5;
				waterGen[i].numPerSpawn = 3;
				waterGen[i].bRandomEject = True;
				waterGen[i].particleTexture = Texture'Effects.Generated.WtrDrpSmall';
				waterGen[i].bTriggered = True;
				waterGen[i].bInitiallyOn = bOpen;
				waterGen[i].SetBase(linkedHead);

				// only have sound on one of them
				if (i == 0)
				{
					waterGen[i].bAmbientSound = True;
					waterGen[i].AmbientSound = Sound'Shower';
					waterGen[i].SoundRadius = 16;
				}
			}
		}
	}

	// play the correct startup animation
	if (bOpen)
		PlayAnim('On', 10.0, 0.001);
	else
		PlayAnim('Off', 10.0, 0.001);
}

defaultproperties
{
     sprayOffsets(0)=(X=2.000000,Z=2.000000)
     sprayOffsets(1)=(Y=-2.000000)
     sprayOffsets(2)=(X=-2.000000,Z=-2.000000)
     sprayOffsets(3)=(Y=2.000000)
     bInvincible=True
     ItemName="Shower Faucet"
     bPushable=False
     Physics=PHYS_None
     Mesh=LodMesh'DeusExDeco.ShowerFaucet'
     CollisionRadius=6.800000
     CollisionHeight=6.410000
     Mass=20.000000
     Buoyancy=10.000000
}
