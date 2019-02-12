//=============================================================================
// Dog.
//=============================================================================
class Dog extends Animal
	abstract;

var float time;

function PlayDogBark()
{
	// overridden in subclasses
}

function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	time += deltaTime;

	// check for random noises
	if (time > 1.0)
	{
		time = 0;
		if (FRand() < 0.05)
			PlayDogBark();
	}
}

function PlayTakingHit(EHitLocation hitPos)
{
	// nil
}

function PlayAttack()
{
	PlayAnimPivot('Attack');
}

function TweenToAttack(float tweentime)
{
	TweenAnimPivot('Attack', tweentime);
}

function PlayBarking()
{
	PlayAnimPivot('Bark');
}

defaultproperties
{
     bPlayDying=True
     MinHealth=2.000000
     InitialAlliances(7)=(AllianceName=Cat,AllianceLevel=-1.000000)
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponDogBite')
     BaseEyeHeight=12.500000
     Alliance=Dog
     Buoyancy=97.000000
}
