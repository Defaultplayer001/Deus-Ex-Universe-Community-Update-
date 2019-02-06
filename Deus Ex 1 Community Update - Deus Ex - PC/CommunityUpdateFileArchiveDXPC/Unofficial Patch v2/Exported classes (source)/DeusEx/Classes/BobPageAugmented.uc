//=============================================================================
// BobPageAugmented.
//=============================================================================
class BobPageAugmented extends DeusExDecoration;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	LoopAnim('Idle');
}

defaultproperties
{
     bInvincible=True
     bHighlight=False
     ItemName="Augmented Bob Page"
     bPushable=False
     BaseEyeHeight=38.000000
     bBlockSight=True
     Physics=PHYS_None
     Mesh=LodMesh'DeusExDeco.BobPageAugmented'
     CollisionRadius=21.600000
     CollisionHeight=54.209999
     Mass=200.000000
     Buoyancy=100.000000
}
