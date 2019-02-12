//=============================================================================
// WeaponSpiderBot.
//=============================================================================
class WeaponSpiderBot extends WeaponNPCRanged;

var ElectricityEmitter emitter;
var float zapTimer;
var vector lastHitLocation;
var int shockDamage;

// force EMP damage
function name WeaponDamageType()
{
	return 'EMP';
}

// intercept the hit and turn on the emitter
function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	Super.ProcessTraceHit(Other, HitLocation, HitNormal, X, Y, Z);

	zapTimer = 0.5;
	if (emitter != None)
	{
		emitter.SetLocation(Owner.Location);
		emitter.SetRotation(Rotator(HitLocation - emitter.Location));
		emitter.TurnOn();
		emitter.SetBase(Owner);
		lastHitLocation = HitLocation;
	}
}

function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	if (zapTimer > 0)
	{
		zapTimer -= deltaTime;

		// update the rotation of the emitter
		emitter.SetRotation(Rotator(lastHitLocation - emitter.Location));

		// turn off the electricity after the timer has expired
		if (zapTimer < 0)
		{
			zapTimer = 0;
			emitter.TurnOff();
		}
	}
}

function Destroyed()
{
	if (emitter != None)
	{
		emitter.Destroy();
		emitter = None;
	}

	Super.Destroyed();
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	zapTimer = 0;
	emitter = Spawn(class'ElectricityEmitter', Self);
	if (emitter != None)
	{
		emitter.bFlicker = False;
		emitter.randomAngle = 1024;
		emitter.damageAmount = shockDamage;
		emitter.TurnOff();
		emitter.Instigator = Pawn(Owner);
	}
}

defaultproperties
{
     shockDamage=15
     ShotTime=1.500000
     HitDamage=25
     maxRange=1280
     AccurateRange=640
     BaseAccuracy=0.000000
     AmmoName=Class'DeusEx.AmmoBattery'
     PickupAmmoCount=20
     bInstantHit=True
     FireSound=Sound'DeusExSounds.Weapons.ProdFire'
}
