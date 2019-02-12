//=============================================================================
// BulletHole.
//=============================================================================
class BulletHole extends DeusExDecal;

// overridden to NOT rotate decal
simulated event BeginPlay()
{
	if(!AttachDecal(32, vect(0.1,0.1,0)))
		Destroy();
}

defaultproperties
{
     Texture=Texture'DeusExItems.Skins.FlatFXTex9'
     DrawScale=0.100000
}
