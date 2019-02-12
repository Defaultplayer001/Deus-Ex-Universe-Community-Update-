//=============================================================================
// AmmoPepper.
//=============================================================================
class AmmoPepper extends DeusExAmmo;

defaultproperties
{
     bShowInfo=True
     AmmoAmount=100
     MaxAmmo=400
     ItemName="Pepper Cartridge"
     ItemArticle="a"
     PickupViewMesh=LodMesh'DeusExItems.AmmoPepper'
     LandSound=Sound'DeusExSounds.Generic.GlassHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoPepper'
     largeIconWidth=19
     largeIconHeight=45
     Description="'ANTIGONE pepper spray will incapacitate your attacker in UNDER TWO SECONDS. ANTIGONE -- better BLIND than DEAD. NOTE: Keep away from children under the age of five. Contents under pressure.'"
     beltDescription="PPR CART"
     Mesh=LodMesh'DeusExItems.AmmoPepper'
     CollisionRadius=1.440000
     CollisionHeight=3.260000
     bCollideActors=True
}
