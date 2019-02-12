//=============================================================================
// BreakableWall.
//=============================================================================
class BreakableWall expands DeusExMover;

defaultproperties
{
     bPickable=False
     bBreakable=True
     doorStrength=0.400000
     bHighlight=False
     bFrobbable=False
     minDamageThreshold=20
     FragmentScale=3.000000
     FragmentClass=Class'DeusEx.Rockchip'
     ExplodeSound1=Sound'DeusExSounds.Generic.SmallExplosion1'
     ExplodeSound2=Sound'DeusExSounds.Generic.LargeExplosion1'
     bOwned=True
}
