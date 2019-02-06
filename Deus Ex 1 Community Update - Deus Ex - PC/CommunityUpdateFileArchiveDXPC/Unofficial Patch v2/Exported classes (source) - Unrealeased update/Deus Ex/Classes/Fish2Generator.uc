//=============================================================================
// Fish2Generator.
//=============================================================================
class Fish2Generator extends PawnGenerator;

function vector GenerateRandomVelocity()
{
	local vector newVector;
	local float  magnitude;

	magnitude = VSize(SumVelocities);
	if (magnitude < 0.01)
		magnitude = 0.01;
	newVector = Vector(Rand(32768)*2*rot(0,1,0))*magnitude*1.1;

	return newVector;
}

function float GenerateCoastPeriod()
{
	return (FRand()*5+3);
}

defaultproperties
{
     PawnClasses(0)=(Count=10,PawnClass=Class'DeusEx.Fish2')
     Alliance=Fish
     PawnHomeExtent=400.000000
     ActiveArea=1200.000000
     Radius=70.000000
     MaxCount=10
     bPawnsTransient=True
     bLOSCheck=False
     Focus=0.600000
}
