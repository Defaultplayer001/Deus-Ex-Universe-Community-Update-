//=============================================================================
// CarStripped.
//=============================================================================
class CarStripped expands OutdoorThings;

enum ESkinColor
{
	SC_LightBlue,
	SC_DarkBlue,
	SC_Gray,
	SC_Black
};

var() ESkinColor SkinColor;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_LightBlue:	Skin = Texture'CarStrippedTex1'; break;
		case SC_DarkBlue:	Skin = Texture'CarStrippedTex2'; break;
		case SC_Gray:		Skin = Texture'CarStrippedTex3'; break;
		case SC_Black:		Skin = Texture'CarStrippedTex4'; break;
	}
}

defaultproperties
{
     bCanBeBase=True
     Mesh=LodMesh'DeusExDeco.CarStripped'
     CollisionRadius=115.000000
     CollisionHeight=23.860001
     Mass=2000.000000
     Buoyancy=1500.000000
}
