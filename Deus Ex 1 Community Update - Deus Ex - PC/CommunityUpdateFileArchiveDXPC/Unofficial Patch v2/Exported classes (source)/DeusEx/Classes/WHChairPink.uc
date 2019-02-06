//=============================================================================
// WHChairPink.
//=============================================================================
class WHChairPink extends Seat;

enum ESeatColor
{
	SC_Pink,
	SC_Blue,
	SC_Green,
	SC_Red,
	SC_BlueFancy,
	SC_RedFancy
};

enum EBackColor
{
	SC_Blue,
	SC_Green,
	SC_Red,
	SC_Wood,
	SC_WoodBars,
	SC_WoodX
};

var() ESeatColor SeatColor;
var() EBackColor BackColor;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SeatColor)
	{
		case SC_Pink:		MultiSkins[0] = Texture'WHChairPinkBaseTex1'; break;
		case SC_Blue:		MultiSkins[0] = Texture'WHChairPinkBaseTex2'; break;
		case SC_Green:		MultiSkins[0] = Texture'WHChairPinkBaseTex3'; break;
		case SC_Red:		MultiSkins[0] = Texture'WHChairPinkBaseTex4'; break;
		case SC_BlueFancy:	MultiSkins[0] = Texture'WHChairPinkBaseTex5'; break;
		case SC_RedFancy:	MultiSkins[0] = Texture'WHChairPinkBaseTex6'; break;
	}

	switch (BackColor)
	{
		case SC_Blue:		MultiSkins[1] = Texture'WHChairPinkBackTex1'; break;
		case SC_Green:		MultiSkins[1] = Texture'WHChairPinkBackTex2'; break;
		case SC_Red:		MultiSkins[1] = Texture'WHChairPinkBackTex3'; break;
		case SC_Wood:		MultiSkins[1] = Texture'WHChairPinkBackTex4'; break;
		case SC_WoodBars:	MultiSkins[1] = Texture'WHChairPinkBackTex5'; break;
		case SC_WoodX:		MultiSkins[1] = Texture'WHChairPinkBackTex6'; break;
	}
}

defaultproperties
{
     BackColor=SC_WoodBars
     sitPoint(0)=(X=0.000000,Y=0.000000,Z=0.000000)
     ItemName="Chair"
     Mesh=LodMesh'DeusExDeco.WHChairPink'
     CollisionRadius=16.000000
     CollisionHeight=24.000000
     Mass=25.000000
     Buoyancy=5.000000
}
