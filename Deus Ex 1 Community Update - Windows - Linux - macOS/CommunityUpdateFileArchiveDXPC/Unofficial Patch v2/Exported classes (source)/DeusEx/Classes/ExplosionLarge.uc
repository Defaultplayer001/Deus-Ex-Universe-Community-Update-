//=============================================================================
// ExplosionLarge.
//=============================================================================
class ExplosionLarge extends AnimatedSprite;

simulated function PostBeginPlay()
{
	local int i;

	Super.PostBeginPlay();

	for (i=0; i<6; i++)
		Spawn(class'FireComet', None);
}

defaultproperties
{
     numFrames=8
     frames(0)=Texture'DeusExItems.Skins.FlatFXTex20'
     frames(1)=Texture'DeusExItems.Skins.FlatFXTex21'
     frames(2)=Texture'DeusExItems.Skins.FlatFXTex22'
     frames(3)=Texture'DeusExItems.Skins.FlatFXTex23'
     frames(4)=Texture'DeusExItems.Skins.FlatFXTex24'
     frames(5)=Texture'DeusExItems.Skins.FlatFXTex25'
     frames(6)=Texture'DeusExItems.Skins.FlatFXTex26'
     frames(7)=Texture'DeusExItems.Skins.FlatFXTex27'
     Texture=Texture'DeusExItems.Skins.FlatFXTex20'
}
