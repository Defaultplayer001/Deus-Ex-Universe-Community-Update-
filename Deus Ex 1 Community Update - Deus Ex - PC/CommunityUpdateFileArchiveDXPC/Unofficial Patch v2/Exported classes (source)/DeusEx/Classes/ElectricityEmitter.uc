//=============================================================================
// ElectricityEmitter.
//=============================================================================
class ElectricityEmitter extends LaserEmitter;

#exec OBJ LOAD FILE=Effects
#exec OBJ LOAD FILE=Ambient

var() float randomAngle;			// random amount to change yaw/pitch
var() int damageAmount;				// how much damage does this do?
var() float damageTime;				// how often does this do damage?
var() texture beamTexture;			// texture for beam
var() bool bInitiallyOn;			// is this initially on?
var() bool bFlicker;				// randomly flicker on and off?
var() float flickerTime;			// how often to check for random flicker?
var() bool bEmitLight;				// should I cast light, also?

var Actor lastHitActor;
var float lastDamageTime;
var float lastFlickerTime;
var bool bAlreadyInitialized;		// has this item been init'ed yet?

function CalcTrace(float deltaTime)
{
	local vector StartTrace, EndTrace, HitLocation, HitNormal, loc;
	local Rotator rot;
	local actor target;
	local int texFlags;
	local name texName, texGroup;

	if (!bHiddenBeam)
	{
		// set up the random beam stuff
		rot.Pitch = Int((0.5 - FRand()) * randomAngle);
		rot.Yaw = Int((0.5 - FRand()) * randomAngle);
		rot.Roll = Int((0.5 - FRand()) * randomAngle);

		StartTrace = Location;
		EndTrace = Location + 5000 * vector(Rotation + rot);
		HitActor = None;

		foreach TraceTexture(class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, EndTrace, StartTrace)
		{
			if ((target.DrawType == DT_None) || target.bHidden)
			{
				// do nothing - keep on tracing
			}
			else if ((target == Level) || target.IsA('Mover'))
			{
				break;
			}
			else
			{
				HitActor = target;
				break;
			}
		}

		lastDamageTime += deltaTime;

		// shock whatever gets in the beam
		if ((HitActor != None) && (lastDamageTime >= damageTime))
		{
			HitActor.TakeDamage(damageAmount, Instigator, HitLocation, vect(0,0,0), 'Shocked');
			lastDamageTime = 0;
		}

		if (LaserIterator(RenderInterface) != None)
			LaserIterator(RenderInterface).AddBeam(0, Location, Rotation + rot, VSize(Location - HitLocation));
	}
}

function TurnOn()
{
	Super.TurnOn();

	if (bEmitLight)
		LightType = LT_Steady;
}

function TurnOff()
{
	Super.TurnOff();

	if (bEmitLight)
		LightType = LT_None;

	if (LaserIterator(RenderInterface) != None)
		LaserIterator(RenderInterface).DeleteBeam(0);
}

function PostPostBeginPlay()
{
	Super.PostPostBeginPlay();

	if (bAlreadyInitialized)
		return;

	if (proxy != None)
		proxy.Skin = beamTexture;

	DrawType = DT_None;

	if (bInitiallyOn)
	{
		bIsOn = False;
		TurnOn();
	}
	else
	{
		bIsOn = True;
		TurnOff();
	}

	bAlreadyInitialized = True;
}

function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	if (bIsOn && !bFrozen && bFlicker)
	{
		lastFlickerTime += deltaTime;

		if (lastFlickerTime >= flickerTime)
		{
			lastFlickerTime = 0;
			if (FRand() < 0.5)
			{
				SetHiddenBeam(True);
				SoundVolume = 0;
				if (bEmitLight)
					LightType = LT_None;
			}
			else
			{
				SetHiddenBeam(False);
				SoundVolume = 128;
				if (bEmitLight)
					LightType = LT_Steady;
			}
		}
	}
}

// if we are triggered, turn us on
function Trigger(Actor Other, Pawn Instigator)
{
	Super.Trigger(Other, Instigator);

	TurnOn();
}

// if we are untriggered, turn us off
function UnTrigger(Actor Other, Pawn Instigator)
{
	Super.UnTrigger(Other, Instigator);

	TurnOff();
}

defaultproperties
{
     randomAngle=8192.000000
     DamageAmount=2
     damageTime=0.200000
     beamTexture=FireTexture'Effects.Electricity.Nano_SFX'
     bInitiallyOn=True
     bFlicker=True
     flickerTime=0.020000
     bEmitLight=True
     bRandomBeam=True
     bDirectional=True
     DrawType=DT_Sprite
     Texture=Texture'Engine.S_Inventory'
     SoundRadius=64
     AmbientSound=Sound'Ambient.Ambient.Electricity4'
     LightBrightness=128
     LightHue=150
     LightSaturation=32
     LightRadius=6
}
