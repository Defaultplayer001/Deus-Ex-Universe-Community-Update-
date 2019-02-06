//=============================================================================
// Toilet.
//=============================================================================
class Toilet extends DeusExDecoration;

enum ESkinColor
{
	SC_Clean,
	SC_Filthy
};

var() ESkinColor SkinColor;
var bool bUsing;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_Clean:	Skin = Texture'ToiletTex1'; break;
		case SC_Filthy:	Skin = Texture'ToiletTex2'; break;
	}
}

function Timer()
{
	bUsing = False;
}

function Frob(actor Frobber, Inventory frobWith)
{
	Super.Frob(Frobber, frobWith);

	if (bUsing)
		return;

	SetTimer(9.0, False);
	bUsing = True;

	PlaySound(sound'FlushToilet',,,, 256);
	PlayAnim('Flush');
}

defaultproperties
{
     bInvincible=True
     ItemName="Toilet"
     bPushable=False
     Physics=PHYS_None
     Mesh=LodMesh'DeusExDeco.Toilet'
     CollisionRadius=28.000000
     CollisionHeight=28.000000
     Mass=100.000000
     Buoyancy=5.000000
}
