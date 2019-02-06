//=============================================================================
// BloodSplat.
//=============================================================================
class BloodSplat extends DeusExDecal;

function BeginPlay()
{
	local Rotator rot;
	local float rnd;

	// Gore check
	if (Level.Game.bLowGore || Level.Game.bVeryLowGore)
	{
		Destroy();
		return;
	}

	rnd = FRand();
	if (rnd < 0.25)
		Texture = Texture'FlatFXTex3';
	else if (rnd < 0.5)
		Texture = Texture'FlatFXTex5';
	else if (rnd < 0.75)
		Texture = Texture'FlatFXTex6';

	DrawScale += FRand() * 0.2;

	Super.BeginPlay();
}

defaultproperties
{
     Texture=Texture'DeusExItems.Skins.FlatFXTex2'
     DrawScale=0.200000
}
