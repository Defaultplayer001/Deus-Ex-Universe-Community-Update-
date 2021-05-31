//=============================================================================
// ShockRing.
//=============================================================================
class ShockRing extends Effects;

var float size;

simulated function Tick(float deltaTime)
{
	DrawScale = size * (Default.LifeSpan - LifeSpan) / Default.LifeSpan;
	ScaleGlow = LifeSpan / Default.LifeSpan;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (size > 5)
		Skin = Texture'FlatFXTex43';
}

defaultproperties
{
     size=5.000000
     LifeSpan=0.500000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Skin=Texture'DeusExItems.Skins.FlatFXTex41'
     Mesh=LodMesh'DeusExItems.FlatFX'
     bUnlit=True
}
