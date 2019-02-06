//=============================================================================
// FirePlug.
//=============================================================================
class FirePlug expands OutdoorThings;

enum ESkinColor
{
	SC_Red,
	SC_Orange,
	SC_Blue,
	SC_Gray
};

var() ESkinColor SkinColor;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_Red:	Skin = Texture'FirePlugTex1'; break;
		case SC_Orange:	Skin = Texture'FirePlugTex2'; break;
		case SC_Blue:	Skin = Texture'FirePlugTex3'; break;
		case SC_Gray:	Skin = Texture'FirePlugTex4'; break;
	}
}

defaultproperties
{
     Mesh=LodMesh'DeusExDeco.FirePlug'
     CollisionRadius=8.000000
     CollisionHeight=16.500000
     Mass=50.000000
     Buoyancy=30.000000
}
