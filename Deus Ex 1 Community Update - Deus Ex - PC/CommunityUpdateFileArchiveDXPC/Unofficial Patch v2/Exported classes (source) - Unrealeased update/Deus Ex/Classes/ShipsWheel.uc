//=============================================================================
// ShipsWheel.
//=============================================================================
class ShipsWheel extends DeusExDecoration;

var bool bSpinning;
var float spinTime, spinDuration;
var int spinDir, spinSpeed;

function Tick(float deltaTime)
{
	local Rotator rot;

	Super.Tick(deltaTime);

	if (bSpinning)
	{
		rot = Rotation;
		rot.Roll += spinDir * spinSpeed * deltaTime * (spinDuration - spinTime) / spinDuration;
		SetRotation(rot);
		spinTime += deltaTime;
		if (spinTime >= spinDuration)
			bSpinning = False;
	}
}

function Frob(actor Frobber, Inventory frobWith)
{
	Super.Frob(Frobber, frobWith);

	// spin the wheel in a random direction for a random amount of time at a random speed
	if (FRand() < 0.5)
		spinDir = -1;
	else
		spinDir = 1;
	spinSpeed = Rand(64) * 1024;
	spinDuration = FRand() * 5 + 2;
	spinTime = 0;
	bSpinning = True;
}

defaultproperties
{
     FragType=Class'DeusEx.WoodFragment'
     ItemName="Ship's Wheel"
     bPushable=False
     Physics=PHYS_None
     Mesh=LodMesh'DeusExDeco.ShipsWheel'
     CollisionRadius=21.000000
     CollisionHeight=21.000000
     Mass=50.000000
     Buoyancy=5.000000
}
