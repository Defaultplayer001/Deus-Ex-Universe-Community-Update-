//=============================================================================
// Rockchip.
//=============================================================================
class Rockchip expands DeusExFragment;

auto state Flying
{
	simulated function BeginState()
	{
		Super.BeginState();

		Velocity = VRand() * 100;
		DrawScale = (DrawScale * 0.1) + FRand() * 0.25;
	}
}

defaultproperties
{
     Fragments(0)=LodMesh'DeusExItems.Rockchip1'
     Fragments(1)=LodMesh'DeusExItems.Rockchip2'
     Fragments(2)=LodMesh'DeusExItems.Rockchip3'
     numFragmentTypes=3
     elasticity=0.400000
     ImpactSound=Sound'DeusExSounds.Generic.RockHit1'
     MiscSound=Sound'DeusExSounds.Generic.RockHit2'
     Mesh=LodMesh'DeusExItems.Rockchip1'
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
