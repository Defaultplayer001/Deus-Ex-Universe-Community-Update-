//=============================================================================
// CeilingFan.
//=============================================================================
class CeilingFan extends DeusExDecoration;

enum ESkinColor
{
	SC_WoodBrass,
	SC_DarkWoodIron,
	SC_White,
	SC_WoodBrassFancy,
	SC_WoodPlastic
};

var() ESkinColor SkinColor;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_WoodBrass:		Skin = Texture'CeilingFanTex1'; break;
		case SC_DarkWoodIron:	Skin = Texture'CeilingFanTex2'; break;
		case SC_White:			Skin = Texture'CeilingFanTex3'; break;
		case SC_WoodBrassFancy:	Skin = Texture'CeilingFanTex4'; break;
		case SC_WoodPlastic:	Skin = Texture'CeilingFanTex5'; break;
	}
}

defaultproperties
{
     SkinColor=SC_DarkWoodIron
     FragType=Class'DeusEx.WoodFragment'
     bHighlight=False
     bCanBeBase=True
     ItemName="Ceiling Fan Blades"
     bPushable=False
     Physics=PHYS_Rotating
     RemoteRole=ROLE_SimulatedProxy
     Mesh=LodMesh'DeusExDeco.CeilingFan'
     CollisionRadius=45.750000
     CollisionHeight=3.300000
     bCollideWorld=False
     bFixedRotationDir=True
     Mass=50.000000
     Buoyancy=30.000000
     RotationRate=(Yaw=16384)
}
