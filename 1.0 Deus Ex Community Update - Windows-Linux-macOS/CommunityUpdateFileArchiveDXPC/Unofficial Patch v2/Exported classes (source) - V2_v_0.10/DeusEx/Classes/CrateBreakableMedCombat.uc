//=============================================================================
// CrateBreakableMedCombat.
//=============================================================================
class CrateBreakableMedCombat extends Containers;

defaultproperties
{
     HitPoints=10
     FragType=Class'DeusEx.WoodFragment'
     ItemName="Combat Supply Crate"
     contents=Class'DeusEx.Ammo10mm'
     bBlockSight=True
     Skin=Texture'DeusExDeco.Skins.CrateBreakableMedTex3'
     Mesh=LodMesh'DeusExDeco.CrateBreakableMed'
     CollisionRadius=34.000000
     CollisionHeight=24.000000
     Mass=50.000000
     Buoyancy=60.000000
}
