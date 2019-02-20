//=============================================================================
// HangingDecoration.
//=============================================================================
class HangingDecoration extends DeusExDecoration
	abstract;

var() bool bFixedSwaying;
var() Rotator FixedSwayDirection;
var() float FixedSwayPeriod;
var() bool bRandomize;
var() bool bNoPitch;
var() bool bNoRoll;
var float FixedSwayTimer;
var Rotator sway;
var bool bSwaying;
var float swayDamping;
var float swayPeriod;
var float swayTimer;
var Rotator wind;
var Rotator originalWind;
var float windPeriod;
var float windTimer;
var Rotator origRot;

function BeginPlay()
{
	Super.BeginPlay();

	origRot = Rotation;

	if (bRandomize)
		Timer();
}

function Timer()
{
	originalWind.Pitch = 4096 - FRand() * 8192;
	originalWind.Yaw = 4096 - FRand() * 8192;
	originalWind.Roll = 4096 - FRand() * 8192;
	windTimer = 0;
	windPeriod = FRand() * 4 + 2;
	SetTimer(windPeriod, False);
}

function UpdateWind()
{
	if (windTimer < windPeriod/2)
	{
		wind.Pitch = Smerp(windTimer / windPeriod, 0, originalWind.Pitch);
		wind.Yaw = Smerp(windTimer / windPeriod, 0, originalWind.Yaw);
		wind.Roll = Smerp(windTimer / windPeriod, 0, originalWind.Roll);
	}
	else
	{
		wind.Pitch = Smerp(windTimer / windPeriod, originalWind.Pitch, 0);
		wind.Yaw = Smerp(windTimer / windPeriod, originalWind.Yaw, 0);
		wind.Roll = Smerp(windTimer / windPeriod, originalWind.Roll, 0);
	}
}

function Tick(float deltaTime)
{
	local Rotator rot;
	local float ang;

	Super.Tick(deltaTime);

	rot = origRot;

	if (bFixedSwaying || bRandomize)
	{
		UpdateWind();
		windTimer += deltaTime;

		ang = 2 * Pi * FixedSwayTimer / FixedSwayPeriod;
		rot += wind + FixedSwayDirection * Sin(ang);
		FixedSwayTimer += deltaTime;
		if (FixedSwayTimer > FixedSwayPeriod)
			FixedSwayTimer -= FixedSwayPeriod;
	}
	if (bSwaying)
	{
		ang = 2 * Pi * swayTimer / swayPeriod;
		rot += sway * Sin(ang) * swayDamping;
		swayDamping *= 0.995;
		if (swayDamping < 0.001)
		{
			bSwaying = False;
			sway = rot(0,0,0);
		}
		swayTimer += deltaTime;
		if (swayTimer > swayPeriod)
			swayTimer -= swayPeriod;
	}

	SetRotation(rot);
}

function CalculateHit(vector Loc, vector Vel)
{
	local Rotator rot, newsway;
	local float ang;

	rot = Rotator(Loc - Location);
	ang = 2 * Pi * (rot.Yaw / 65536.0);
	newsway.Pitch = -Cos(ang) * VSize(Vel) * 10;
	newsway.Roll = Sin(ang) * VSize(Vel) * 10;
	newsway.Yaw = 0;

	// scale them down to acceptable limits
	while (abs(newsway.Pitch) > 8192)
	{
		newsway.Pitch /= 2;
		newsway.Roll /= 2;
	};
	while (abs(newsway.Roll) > 8192)
	{
		newsway.Pitch /= 2;
		newsway.Roll /= 2;
	};

	// don't use the new values unless they are larger than the old values
	if ((newsway.Pitch > sway.Pitch) && (sway.Pitch >= 0))
		sway.Pitch = newsway.Pitch;
	else if ((newsway.Pitch < sway.Pitch) && (sway.Pitch <= 0))
		sway.Pitch = newsway.Pitch;
	if ((newsway.Roll > sway.Roll) && (sway.Roll >= 0))
		sway.Roll = newsway.Roll;
	else if ((newsway.Roll < sway.Roll) && (sway.Roll <= 0))
		sway.Roll = newsway.Roll;
	swayDamping = 1.0;
	swayPeriod = 2.0;

	if (bNoPitch)
		sway.Pitch = 0;
	if (bNoRoll)
		sway.Roll = 0;
}

function Bump(actor Other)
{
	Super.Bump(Other);

	CalculateHit(Other.Location, Other.Velocity);
	bSwaying = True;
	if (!bSwaying)
		swayTimer = 0;
}

auto state Active
{
	function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
	{
		Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
		if ((DamageType == 'Shot') || (DamageType == 'Exploded'))
		{
			CalculateHit(HitLocation, Momentum);
			bSwaying = True;
		}

		if (!bSwaying)
			swayTimer = 0;
	}
}

defaultproperties
{
     bHighlight=False
     bPushable=False
     Physics=PHYS_Rotating
     bCollideWorld=False
     bFixedRotationDir=True
}
