//=============================================================================
// Cart.
//=============================================================================
class Cart extends DeusExDecoration;

var float rollTimer;
var float pushTimer;
var vector pushVel;
var bool bJustPushed;

function StartRolling(vector vel)
{
	// Transfer momentum
	SetPhysics(PHYS_Rolling);
	pushVel = vel;
	pushVel.Z = 0;
	Velocity = pushVel;
	rollTimer = 2;
	bJustPushed = True;
	pushTimer = 0.5;
	AmbientSound = Sound'UtilityCart';
}

//
// give us velocity in the direction of the push
//
function Bump(actor Other)
{
	if (bJustPushed)
		return;

	if ((Other != None) && (Physics != PHYS_Falling))
		if (abs(Location.Z-Other.Location.Z) < (CollisionHeight+Other.CollisionHeight-1))  // no bump if landing on cart
			StartRolling(0.25*Other.Velocity*Other.Mass/Mass);
}

//
// simulate less friction (wheels)
//
function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	if ((Physics == PHYS_Rolling) && (rollTimer > 0))
	{
		rollTimer -= deltaTime;
		Velocity = pushVel;

		if (pushTimer > 0)
			pushTimer -= deltaTime;
		else
			bJustPushed = False;
	}


	// make the sound pitch depend on the velocity
	if (VSize(Velocity) > 1)
	{
		SoundPitch = Clamp(2*VSize(Velocity), 32, 64);
	}
	else
	{
		// turn off the sound when it stops
		AmbientSound = None;
		SoundPitch = Default.SoundPitch;
	}
}

defaultproperties
{
     bCanBeBase=True
     ItemName="Utility Push-Cart"
     Mesh=LodMesh'DeusExDeco.Cart'
     SoundRadius=16
     CollisionRadius=28.000000
     CollisionHeight=26.780001
     Mass=40.000000
     Buoyancy=45.000000
}
