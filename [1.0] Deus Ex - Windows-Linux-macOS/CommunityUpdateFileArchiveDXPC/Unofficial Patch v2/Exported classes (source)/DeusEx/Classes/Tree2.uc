//=============================================================================
// Tree2.
//=============================================================================
class Tree2 extends Tree;

enum ESkinColor
{
	SC_Tree1,
	SC_Tree2,
	SC_Tree3
};

var() ESkinColor SkinColor;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_Tree1:	Skin = Texture'Tree2Tex1'; break;
		case SC_Tree2:	Skin = Texture'Tree2Tex2'; break;
		case SC_Tree3:	Skin = Texture'Tree2Tex3'; break;
	}
}

defaultproperties
{
     Mesh=LodMesh'DeusExDeco.Tree2'
     CollisionRadius=10.000000
     CollisionHeight=182.369995
}
