//=============================================================================
// FlyGenerator.
//=============================================================================
class FlyGenerator extends PawnGenerator;

function ZoneChange(ZoneInfo NewZone)
{
	Super.ZoneChange(NewZone);

	if (NewZone.bWaterZone)
		StopGenerator();
}

defaultproperties
{
     PawnClasses(0)=(Count=8,PawnClass=Class'DeusEx.Fly')
     Alliance=Fly
     bGeneratorIsHome=True
     ActiveArea=700.000000
     Radius=50.000000
     MaxCount=3
     bPawnsTransient=True
     bLOSCheck=False
}
