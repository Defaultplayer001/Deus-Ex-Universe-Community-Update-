//=============================================================================
// ChairLeather.
//=============================================================================
class ChairLeather extends Seat;

enum ESkinColor
{
	SC_Black,
	SC_Blue,
	SC_Brown,
	SC_LitGray,
	SC_Tan
};

var() ESkinColor SkinColor;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_Black:		Skin = Texture'ChairLeatherTex1'; break;
		case SC_Blue:		Skin = Texture'ChairLeatherTex1'; break;
		case SC_Brown:		Skin = Texture'ChairLeatherTex1'; break;
		case SC_LitGray:	Skin = Texture'ChairLeatherTex1'; break;
		case SC_Tan:		Skin = Texture'ChairLeatherTex1'; break;
	}
}

defaultproperties
{
     sitPoint(0)=(X=0.000000,Y=-8.000000,Z=0.000000)
     ItemName="Comfy Chair"
     Mesh=LodMesh'DeusExDeco.ChairLeather'
     CollisionRadius=33.500000
     CollisionHeight=23.250000
     Mass=100.000000
     Buoyancy=110.000000
}
