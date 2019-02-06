//=============================================================================
// SuperBall.
//=============================================================================
class SuperBall expands DeusExFragment;

simulated function HitWall (vector HitNormal, actor HitWall)
{
	Super.HitWall(HitNormal, HitWall);

	Velocity += vect(0.5, 0.5, 0.5) - VRand();
	bRotateToDesired = False;
	bFixedRotationDir = True;
	RotationRate = RotRand(True);
}

auto state Flying
{
	simulated function BeginState()
	{
		local DeusExPlayer P;

		Super.BeginState();

		foreach AllActors(class'DeusExPlayer', P)
			if (P != None)
				break;

		Velocity = Vector(P.ViewRotation) * 300 + vect(0,0,200) + VRand() * 20;
		RotationRate = RotRand(True);
	}
}

defaultproperties
{
     numFragmentTypes=1
     elasticity=1.000000
     LifeSpan=0.000000
     bUnlit=True
     CollisionRadius=1.000000
     CollisionHeight=1.000000
     bCollideActors=True
}
