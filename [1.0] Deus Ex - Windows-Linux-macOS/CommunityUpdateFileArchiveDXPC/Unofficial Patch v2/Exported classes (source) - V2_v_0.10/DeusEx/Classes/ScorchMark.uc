//=============================================================================
// ScorchMark.
//=============================================================================
class ScorchMark extends DeusExDecal;

function BeginPlay()
{
	if (FRand() < 0.5)
		Texture = Texture'FlatFXTex39';

	Super.BeginPlay();
}

defaultproperties
{
     Texture=Texture'DeusExItems.Skins.FlatFXTex38'
}
