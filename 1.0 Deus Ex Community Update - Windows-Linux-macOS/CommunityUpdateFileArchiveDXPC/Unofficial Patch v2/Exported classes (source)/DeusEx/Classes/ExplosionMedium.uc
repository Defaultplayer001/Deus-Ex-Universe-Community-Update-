//=============================================================================
// ExplosionMedium.
//=============================================================================
class ExplosionMedium extends AnimatedSprite;

simulated function PostBeginPlay()
{
	local int i;

	Super.PostBeginPlay();

	for (i=0; i<3; i++)
		Spawn(class'FireComet', None);
}

defaultproperties
{
     numFrames=6
     frames(0)=Texture'DeusExItems.Skins.FlatFXTex14'
     frames(1)=Texture'DeusExItems.Skins.FlatFXTex15'
     frames(2)=Texture'DeusExItems.Skins.FlatFXTex16'
     frames(3)=Texture'DeusExItems.Skins.FlatFXTex17'
     frames(4)=Texture'DeusExItems.Skins.FlatFXTex18'
     frames(5)=Texture'DeusExItems.Skins.FlatFXTex19'
     Texture=Texture'DeusExItems.Skins.FlatFXTex14'
}
