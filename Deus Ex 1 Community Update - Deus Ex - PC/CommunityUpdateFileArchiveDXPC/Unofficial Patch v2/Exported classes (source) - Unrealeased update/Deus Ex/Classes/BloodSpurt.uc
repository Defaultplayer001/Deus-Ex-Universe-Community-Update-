//=============================================================================
// BloodSpurt.
//=============================================================================
class BloodSpurt extends Effects;

auto state Flying
{
	function BeginState()
	{
		Velocity = vect(0,0,0);
		DrawScale -= FRand() * 0.5;
		PlayAnim('Spurt');

		// Gore check
		if (Level.Game.bLowGore || Level.Game.bVeryLowGore)
		{
			Destroy();
			return;
		}
	}
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
	{
		ScaleGlow = 2.0;
		DrawScale *= 1.5;
		LifeSpan *= 2.0;
		bUnlit=True;
	}
}

defaultproperties
{
     LifeSpan=0.500000
     DrawType=DT_Mesh
     Style=STY_Modulated
     Mesh=LodMesh'DeusExItems.BloodSpurt'
     bFixedRotationDir=True
     NetUpdateFrequency=5.000000
}
