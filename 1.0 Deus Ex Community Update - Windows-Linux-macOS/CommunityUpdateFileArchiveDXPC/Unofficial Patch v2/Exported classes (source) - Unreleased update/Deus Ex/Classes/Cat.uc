//=============================================================================
// Cat.
//=============================================================================
class Cat extends Animal;

var float time;

function bool ShouldBeStartled(Pawn startler)
{
	local float speed;
	local float time;
	local float dist;
	local float dist2;
	local bool  bPh33r;

	bPh33r = false;
	if (startler != None)
	{
		speed = VSize(startler.Velocity);
		if (speed >= 20)
		{
			dist = VSize(Location - startler.Location);
			time = dist/speed;
			if (time <= 3.0)
			{
				dist2 = VSize(Location - (startler.Location+startler.Velocity*time));
				if (dist2 < speed*1.5)
					bPh33r = true;
			}
		}
	}

	return bPh33r;
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
			PlaySound(sound'CatPurr', SLOT_None,,, 128);
	}
}

state Attacking
{
	function Tick(float deltaSeconds)
	{
		Super.Tick(deltaSeconds);
		if (Enemy != None)
			GotoState('Fleeing');
	}
}

defaultproperties
{
     bPlayDying=True
     bFleeBigPawns=True
     MinHealth=0.000000
     CarcassType=Class'DeusEx.CatCarcass'
     WalkingSpeed=0.111111
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponCatScratch')
     GroundSpeed=180.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     MaxStepHeight=14.000000
     BaseEyeHeight=6.000000
     Health=30
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'DeusExSounds.Animal.CatHiss'
     HitSound2=Sound'DeusExSounds.Animal.CatHiss'
     Die=Sound'DeusExSounds.Animal.CatDie'
     Alliance=Cat
     DrawType=DT_Mesh
     Mesh=LodMesh'DeusExCharacters.Cat'
     CollisionRadius=17.000000
     CollisionHeight=11.300000
     bBlockActors=False
     Mass=10.000000
     Buoyancy=97.000000
     RotationRate=(Yaw=100000)
     BindName="Cat"
     FamiliarName="Cat"
     UnfamiliarName="Cat"
}
