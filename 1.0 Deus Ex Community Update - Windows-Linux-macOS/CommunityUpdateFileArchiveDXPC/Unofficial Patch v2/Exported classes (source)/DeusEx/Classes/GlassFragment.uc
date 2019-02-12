//=============================================================================
// GlassFragment.
//=============================================================================
class GlassFragment expands DeusExFragment;

defaultproperties
{
     Fragments(0)=LodMesh'DeusExItems.GlassFragment1'
     Fragments(1)=LodMesh'DeusExItems.GlassFragment2'
     Fragments(2)=LodMesh'DeusExItems.GlassFragment3'
     numFragmentTypes=3
     elasticity=0.300000
     ImpactSound=Sound'DeusExSounds.Generic.GlassHit1'
     MiscSound=Sound'DeusExSounds.Generic.GlassHit2'
     Mesh=LodMesh'DeusExItems.GlassFragment1'
     CollisionRadius=6.000000
     CollisionHeight=0.000000
     Mass=5.000000
     Buoyancy=4.000000
}
