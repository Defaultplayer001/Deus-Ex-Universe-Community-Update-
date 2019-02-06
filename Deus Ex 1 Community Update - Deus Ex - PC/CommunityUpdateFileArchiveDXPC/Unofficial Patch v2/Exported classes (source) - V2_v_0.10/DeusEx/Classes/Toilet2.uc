//=============================================================================
// Toilet2.
//=============================================================================
class Toilet2 extends DeusExDecoration;

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
		case SC_Clean:	Skin = Texture'Toilet2Tex1'; break;
		case SC_Filthy:	Skin = Texture'Toilet2Tex2'; break;
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

	SetTimer(2.0, False);
	bUsing = True;

	PlaySound(sound'FlushUrinal',,,, 256);
	PlayAnim('Flush');
}

defaultproperties
{
     bInvincible=True
     ItemName="Urinal"
     bPushable=False
     Physics=PHYS_None
     Mesh=LodMesh'DeusExDeco.Toilet2'
     CollisionRadius=18.000000
     CollisionHeight=31.000000
     Mass=100.000000
     Buoyancy=5.000000
}
