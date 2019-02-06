//=============================================================================
// ParticleGenerator.
//=============================================================================
class ParticleGenerator extends Effects;

var() float frequency;			// what's the chance of spewing a particle every checkTime seconds
var() float riseRate;			// how fast do the particles rise
var() float ejectSpeed;			// how fast do the particles get ejected
var() texture particleTexture;	// replacement texture to use (default is smoke)
var() float particleLifeSpan;	// how long each particle lives
var() float particleDrawScale;	// draw scale for each particle
var() bool bParticlesUnlit;		// is each particle unlit?
var() bool bScale;				// scale each particle as it rises?
var() bool bFade;				// fade each particle as it rises?
var() bool bTriggered;			// start by triggering?
var() float spewTime;			// how long do I spew after I am triggered?
var() bool bRandomEject;		// random eject velocity vector
var() float checkTime;			// how often should I spit out particles?
var() bool bTranslucent;		// are these particles translucent?
var() bool bGravity;			// are these particles affected by gravity?
var() sound spawnSound;			// sound to play when spawned
var() bool bAmbientSound;		// play the ambient sound?
var() int numPerSpawn;			// number of particles to spawn per puff
var() name attachTag;			// attach us to this actor
var() bool bInitiallyOn;		// if triggered, start on instead of off
var bool bSpewing;				// am I spewing?
var bool bFrozen;				// are we out of the player's sight?
var float time;
var bool bDying;				// don't spew, but continue to update
var() bool bModulated;			// are these particles modulated?

var vector pLoc;				// Location used for replication, ParticleIterator uses these now
var rotator pRot;				// Rotation used for replication, ParticleIterator uses these now


var ParticleProxy proxy;

replication
{
	reliable if ( ROLE == Role_Authority )
		frequency, riseRate, ejectSpeed, particleTexture, particleLifeSpan, particleDrawScale, bParticlesUnlit,
		bScale, bFade, bTriggered, spewTime, bRandomEject, checkTime, bTranslucent, bGravity, numPerSpawn, attachTag,
		bInitiallyOn, bSpewing, bFrozen, time, bDying, bModulated, proxy, pLoc, pRot; 
}

function Trigger(Actor Other, Pawn EventInstigator)
{
	Super.Trigger(Other, EventInstigator);

	// if we are spewing, turn us off
	if (bSpewing)
	{
		bSpewing = False;
		proxy.bHidden = True;
		if (bAmbientSound && (AmbientSound != None))
			SoundVolume = 0;
	}
	else		// otherwise, turn us on
	{
		bSpewing = True;
		proxy.bHidden = False;
		LifeSpan = spewTime;
		if (bAmbientSound && (AmbientSound != None))
			SoundVolume = 255;
	}
}

function UnTrigger(Actor Other, Pawn EventInstigator)
{
	Super.UnTrigger(Other, EventInstigator);

	// if we are spewing, turn us off
	if (bSpewing)
	{
		bSpewing = False;
		proxy.bHidden = True;
		if (bAmbientSound && (AmbientSound != None))
			SoundVolume = 0;
	}
}

simulated function Tick(float deltaTime)
{
	local int i;

	// Server updates these location and rotation proxies
	if ( Role == ROLE_Authority )
	{
		pLoc = Location;
		pRot = Rotation;
	}

	if (proxy != None)
	{
		// don't freeze if we're dying
		if (bDying)
			bFrozen = False;

		// if we are close, say 20 feet
		else if (proxy.DistanceFromPlayer < 320)
			bFrozen = False;

		// can the player see the generator?
		else if (proxy.LastRendered() <= 2.0)
			bFrozen = False;

		// can the player see our base?
		else if ((Base != None) && (Base != Level) && (Base.LastRendered() <= 2.0))
			bFrozen = False;

		else
			bFrozen = True;
	}
	else
		bFrozen = True;

	// check LifeSpan and see if we need to DelayedDestroy()
	if ((LifeSpan > 0) && (LifeSpan <= 1.0))
	{
		LifeSpan = 0;
		DelayedDestroy();
	}

	// are we frozen
	if (bFrozen)
		return;

	Super.Tick(deltaTime);

	if (proxy != None)
		if (proxy.Texture != particleTexture)
			SetProxyData();

	// tick the iterator since Objects don't Tick()
	if (ParticleIterator(RenderInterface) != None)
			ParticleIterator(RenderInterface).Update(deltaTime);

	// don't spew anymore if we're dying
	if (bDying || !bSpewing)
		return;

	// if the owner that I'm attached to is dead, kill me
	if ((attachTag != '') && (Owner == None))
		Destroy();

	time += deltaTime;

	if (time > checkTime)
	{
		time = 0;

		if (FRand() <= frequency)
		{
			if (spawnSound != None)
				PlaySound(spawnSound, SLOT_Misc,,, 1024);

			for (i=0; i<numPerSpawn; i++)
				if (ParticleIterator(RenderInterface) != None)
					ParticleIterator(RenderInterface).AddParticle();
		}
	}
}

//
// Don't actually destroy the generator until after all of the
// particles have disappeared
//
function DelayedDestroy()
{
	bDying = True;
	SetBase(None);
	SetTimer(1.0, True);
}

function Timer()
{
	if (ParticleIterator(RenderInterface) != None)
	{
		if (ParticleIterator(RenderInterface).IsListEmpty())
			Destroy();
	}
	else // MB - We are most likely the server with no render interface, so kill it.
		Destroy();
}

function Destroyed()
{
	if (proxy != None)
	{
		proxy.Destroy();
		proxy = None;
	}
	Super.Destroyed();
}

simulated function SetProxyData()
{
	if (proxy != None)
	{
		proxy.bUnlit = bParticlesUnlit;

		if (bModulated)
			proxy.Style = STY_Modulated;
		else if (bTranslucent)
			proxy.Style = STY_Translucent;
		else
			proxy.Style = STY_Masked;

		if (particleTexture != None)
			proxy.Texture = particleTexture;
	}
}

function PostBeginPlay()
{
	local Actor A;

	Super.PostBeginPlay();

	DrawType = DT_None;

	// create our proxy particle
	if (proxy == None)
	{
		proxy = Spawn(class'ParticleProxy',,, Location, Rotation);
		SetProxyData();
	}

	if (bTriggered && !bInitiallyOn)
	{
		bSpewing = False;
		proxy.bHidden = True;
		SoundVolume = 0;
	}

	// attach us to the actor that was tagged
	if (attachTag != '')
		foreach AllActors(class'Actor', A, attachTag)
			if (A != None)
			{
				SetOwner(A);
				SetBase(A);
			}

	pLoc = Location;
	pRot = Rotation;
}

defaultproperties
{
     Frequency=1.000000
     RiseRate=10.000000
     ejectSpeed=10.000000
     particleLifeSpan=4.000000
     particleDrawScale=0.100000
     bParticlesUnlit=True
     bScale=True
     bFade=True
     checkTime=0.100000
     bTranslucent=True
     numPerSpawn=1
     bInitiallyOn=True
     bSpewing=True
     bDirectional=True
     DrawType=DT_Sprite
     Texture=Texture'Engine.S_Inventory'
     CollisionRadius=80.000000
     CollisionHeight=80.000000
     RenderIteratorClass=Class'DeusEx.ParticleIterator'
}
