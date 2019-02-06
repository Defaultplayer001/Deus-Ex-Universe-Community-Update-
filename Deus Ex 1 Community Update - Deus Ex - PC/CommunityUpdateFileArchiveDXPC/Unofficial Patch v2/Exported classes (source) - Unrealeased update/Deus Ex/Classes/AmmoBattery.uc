//=============================================================================
// AmmoBattery.
//=============================================================================
class AmmoBattery extends DeusExAmmo;

defaultproperties
{
     bShowInfo=True
     AmmoAmount=4
     MaxAmmo=40
     ItemName="Prod Charger"
     ItemArticle="a"
     PickupViewMesh=LodMesh'DeusExItems.AmmoProd'
     LandSound=Sound'DeusExSounds.Generic.PlasticHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoProd'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoProd'
     largeIconWidth=17
     largeIconHeight=46
     Description="A portable charging unit for the riot prod."
     beltDescription="CHARGER"
     Mesh=LodMesh'DeusExItems.AmmoProd'
     CollisionRadius=2.100000
     CollisionHeight=5.600000
     bCollideActors=True
}
