//=============================================================================
// Tree.
//=============================================================================
class Tree extends OutdoorThings
	abstract;

var() float soundFreq;		// chance of making a sound every 5 seconds

function Timer()
{
	if (FRand() < soundFreq)
	{
		// play wind sounds at random pitch offsets
		if (FRand() < 0.5)
			PlaySound(sound'WindGust1', SLOT_Misc,,, 2048, 0.7 + 0.6 * FRand());
		else
			PlaySound(sound'WindGust2', SLOT_Misc,,, 2048, 0.7 + 0.6 * FRand());
	}
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(4.0 + 2.0 * FRand(), True);
}

defaultproperties
{
     soundFreq=0.200000
     bStatic=False
     Mass=2000.000000
     Buoyancy=5.000000
}
