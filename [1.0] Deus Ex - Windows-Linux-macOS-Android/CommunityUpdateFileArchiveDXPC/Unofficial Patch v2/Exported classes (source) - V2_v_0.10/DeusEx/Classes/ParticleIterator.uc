//=============================================================================
// ParticleIterator.
//=============================================================================
class ParticleIterator extends RenderIterator
	native;

struct sParticle
{
	var bool	bActive;
	var Vector	initVel;
	var Vector	Velocity;
	var Vector	Location;
	var float	DrawScale;
	var float	ScaleGlow;
	var float	LifeSpan;
};

var sParticle Particles[64];
var int nextFreeParticle;
var Actor proxy;			// used by the C++

// DEUS_EX AMSD A bunch of variables that are copied from the Owner every update, set here to make it 1 set per tick, not 1 per tick per particle,
// and to allow native code.
var bool bOwnerUsesGravity;
var bool bOwnerScales;
var bool bOwnerFades;
var float OwnerZoneGravity; 
var float OwnerRiseRate;
var float OwnerLifeSpan;
var float OwnerDrawScale;

native(3017) final function UpdateParticles(float DeltaTime);

simulated function AddParticle()
{
	local int i, lastFreeParticle;
	local ParticleGenerator Owner;

	Owner = ParticleGenerator(Outer);
	if (Owner != None)
	{
		if (nextFreeParticle != -1)
		{
			Particles[nextFreeParticle].Velocity = Owner.ejectSpeed * vector(Owner.pRot);

			if (Owner.bRandomEject)
				Particles[nextFreeParticle].Velocity += 0.2 * Owner.ejectSpeed * VRand();

			Particles[nextFreeParticle].Location = Owner.pLoc;
			Particles[nextFreeParticle].initVel = Particles[nextFreeParticle].Velocity;
			Particles[nextFreeParticle].DrawScale = Owner.particleDrawScale;
			Particles[nextFreeParticle].LifeSpan = Owner.particleLifeSpan;
			Particles[nextFreeParticle].bActive = True;

			// get the next free particle in the list
			lastFreeParticle = nextFreeParticle;
			i = nextFreeParticle;
			if (++i >= ArrayCount(Particles))
				i = 0;
			while (i != lastFreeParticle)
			{
				if (!Particles[i].bActive)
				{
					nextFreeParticle = i;
					break;
				}

				if (++i >= ArrayCount(Particles))
					i = 0;
			}

			// if we didn't find an empty one, set us to -1
			if (lastFreeParticle == nextFreeParticle)
				nextFreeParticle = -1;
		}
	}
}

simulated function DeleteParticle(int i)
{
	if ((i >= 0) && (i < ArrayCount(Particles)))
		if (Particles[i].bActive)
		{
			Particles[i].bActive = False;
			nextFreeParticle = i;
		}
}

function bool IsListEmpty()
{
	local int i;

	for (i=0; i<ArrayCount(Particles); i++)
		if (Particles[i].bActive)
			return False;

	return True;
}

//
// this must be called by the owner, since object's don't tick()
//
simulated function Update(float deltaTime)
{
	local int i;
	local ParticleGenerator Owner;
	local bool bNoneActive;

	Owner = ParticleGenerator(Outer);
	if (Owner != None)
	{
		bNoneActive = True;

      bOwnerUsesGravity = Owner.bGravity;
      bOwnerScales = Owner.bScale;
      bOwnerFades = Owner.bFade;

      OwnerZoneGravity = Owner.Region.Zone.ZoneGravity.Z;
      OwnerRiseRate = Owner.riseRate;
      OwnerLifeSpan = Owner.particleLifeSpan;
      OwnerDrawScale = Owner.particleDrawScale;

      // DEUS_EX AMSD Moved to a native call to speed up.
      UpdateParticles(deltaTime);
	}
}

function Init(PlayerPawn Camera)
{
	local ParticleGenerator Owner;

	Owner = ParticleGenerator(Outer);
	if (Owner != None)
	{
		proxy = Owner.proxy;
		if (Owner.bFrozen)
			MaxItems = 0;
		else
			MaxItems = 64;
	}
}

defaultproperties
{
     MaxItems=64
}
