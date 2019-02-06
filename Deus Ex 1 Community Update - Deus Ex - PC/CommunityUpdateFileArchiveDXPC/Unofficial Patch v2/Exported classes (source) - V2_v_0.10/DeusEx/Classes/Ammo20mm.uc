//=============================================================================
// Ammo20mm.
//=============================================================================
class Ammo20mm extends DeusExAmmo;

defaultproperties
{
     bShowInfo=True
     AmmoAmount=4
     MaxAmmo=32
     ItemName="20mm HE Ammo"
     ItemArticle="some"
     PickupViewMesh=LodMesh'DeusExItems.Ammo20mm'
     LandSound=Sound'DeusExSounds.Generic.MetalHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconAmmo20mm'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmo20mm'
     largeIconWidth=47
     largeIconHeight=37
     Description="The 20mm high-explosive round complements the standard 7.62x51mm assault rifle by adding the capability to clear small rooms, foxholes, and blind corners using an underhand launcher."
     beltDescription="20MM AMMO"
     Mesh=LodMesh'DeusExItems.Ammo20mm'
     CollisionRadius=9.500000
     CollisionHeight=4.750000
     bCollideActors=True
}
