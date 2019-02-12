//=============================================================================
// PlasticFragment.
//=============================================================================
class PlasticFragment expands DeusExFragment;

defaultproperties
{
     Fragments(0)=LodMesh'DeusExItems.MetalFragment1'
     Fragments(1)=LodMesh'DeusExItems.MetalFragment2'
     Fragments(2)=LodMesh'DeusExItems.MetalFragment3'
     numFragmentTypes=3
     ImpactSound=Sound'DeusExSounds.Generic.PlasticHit1'
     MiscSound=Sound'DeusExSounds.Generic.PlasticHit2'
     Mesh=LodMesh'DeusExItems.MetalFragment1'
     CollisionRadius=6.000000
     CollisionHeight=0.000000
     Mass=4.000000
     Buoyancy=5.000000
}
