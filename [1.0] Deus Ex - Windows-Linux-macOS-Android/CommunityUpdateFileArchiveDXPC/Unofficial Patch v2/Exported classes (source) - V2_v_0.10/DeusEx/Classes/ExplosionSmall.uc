//=============================================================================
// ExplosionSmall.
//=============================================================================
class ExplosionSmall extends AnimatedSprite;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	Spawn(class'FireComet', None);
}

defaultproperties
{
     numFrames=4
     frames(0)=Texture'DeusExItems.Skins.FlatFXTex10'
     frames(1)=Texture'DeusExItems.Skins.FlatFXTex11'
     frames(2)=Texture'DeusExItems.Skins.FlatFXTex12'
     frames(3)=Texture'DeusExItems.Skins.FlatFXTex13'
     Texture=Texture'DeusExItems.Skins.FlatFXTex10'
}
