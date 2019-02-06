//=============================================================================
// WaterPool.
//=============================================================================
class WaterPool extends DeusExDecal;

var float spreadTime;
var float maxDrawScale;
var float time;

simulated function Tick(float deltaTime)
{
	time += deltaTime;
	if (time <= spreadTime)
	{
		DrawScale = maxDrawScale * time / spreadTime;
		ReattachDecal(vect(0.1,0.1,0));
	}
}

defaultproperties
{
     spreadTime=5.000000
     maxDrawScale=1.500000
     Texture=Texture'DeusExItems.Skins.FlatFXTex47'
}
