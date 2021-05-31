//=============================================================================
// MetalFragment.
//=============================================================================
class MetalFragment expands DeusExFragment;

defaultproperties
{
     Fragments(0)=LodMesh'DeusExItems.MetalFragment1'
     Fragments(1)=LodMesh'DeusExItems.MetalFragment2'
     Fragments(2)=LodMesh'DeusExItems.MetalFragment3'
     numFragmentTypes=3
     elasticity=0.400000
     ImpactSound=Sound'DeusExSounds.Generic.MetalHit1'
     MiscSound=Sound'DeusExSounds.Generic.MetalHit2'
     Mesh=LodMesh'DeusExItems.GlassFragment1'
     CollisionRadius=6.000000
     CollisionHeight=0.000000
     Mass=5.000000
     Buoyancy=3.000000
}
