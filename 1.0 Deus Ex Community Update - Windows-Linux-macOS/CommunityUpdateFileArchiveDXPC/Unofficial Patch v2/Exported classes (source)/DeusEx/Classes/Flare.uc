//=============================================================================
// Flare.
//=============================================================================
class Flare extends DeusExPickup;

var ParticleGenerator gen;

function ExtinguishFlare()
{
	LightType = LT_None;
	AmbientSound = None;
	if (gen != None)
		gen.DelayedDestroy();
}

auto state Pickup
{
	function ZoneChange(ZoneInfo NewZone)
	{
		if (NewZone.bWaterZone)
			ExtinguishFlare();

		Super.ZoneChange(NewZone);
	}

	function Frob(Actor Frobber, Inventory frobWith)
	{
		// we can't pick it up again if we've already activated it
		if (gen == None)
			Super.Frob(Frobber, frobWith);
		else if (Frobber.IsA('Pawn'))
			Pawn(Frobber).ClientMessage(ExpireMessage);
	}
}

state Activated
{
	function ZoneChange(ZoneInfo NewZone)
	{
		if (NewZone.bWaterZone)
			ExtinguishFlare();

		Super.ZoneChange(NewZone);
	}

	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local Flare flare;

		Super.BeginState();

		// Create a Flare and throw it
		flare = Spawn(class'Flare', Owner);
		flare.LightFlare();

		UseOnce();
	}
Begin:
}

function LightFlare()
{
	local Vector X, Y, Z, dropVect;
	local Pawn P;

	if (gen == None)
	{	
		LifeSpan = 30;
		bUnlit = True;
		LightType = LT_Steady;
		AmbientSound = Sound'Flare';

		P = Pawn(Owner);
		if (P != None)
		{
			GetAxes(P.ViewRotation, X, Y, Z);
			dropVect = P.Location + 0.8 * P.CollisionRadius * X;
			dropVect.Z += P.BaseEyeHeight;
			Velocity = Vector(P.ViewRotation) * 500 + vect(0,0,220);
			bFixedRotationDir = True;
			RotationRate = RotRand(False);
			DropFrom(dropVect);

			// increase our collision height so we light up the ground better
			SetCollisionSize(CollisionRadius, CollisionHeight*2);
		}

		gen = Spawn(class'ParticleGenerator', Self,, Location, rot(16384,0,0));
		if (gen != None)
		{
			gen.attachTag = Name;
			gen.SetBase(Self);
			gen.LifeSpan = 30;
			gen.bRandomEject = True;
			gen.ejectSpeed = 20;
			gen.riseRate = 20;
			gen.checkTime = 0.3;
			gen.particleLifeSpan = 10;
			gen.particleDrawScale = 0.5;
			gen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		}
	}
}

defaultproperties
{
     maxCopies=50
     bCanHaveMultipleCopies=True
     ExpireMessage="It's already been used"
     bActivatable=True
     ItemName="Flare"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Flare'
     PickupViewMesh=LodMesh'DeusExItems.Flare'
     ThirdPersonMesh=LodMesh'DeusExItems.Flare'
     Icon=Texture'DeusExUI.Icons.BeltIconFlare'
     largeIcon=Texture'DeusExUI.Icons.LargeIconFlare'
     largeIconWidth=42
     largeIconHeight=43
     Description="A flare."
     beltDescription="FLARE"
     Mesh=LodMesh'DeusExItems.Flare'
     SoundRadius=16
     SoundVolume=96
     CollisionRadius=6.200000
     CollisionHeight=1.200000
     LightEffect=LE_TorchWaver
     LightBrightness=255
     LightHue=16
     LightSaturation=96
     LightRadius=8
     Mass=2.000000
     Buoyancy=1.000000
}
