//=============================================================================
// BallisticArmor.
//=============================================================================
class BallisticArmor extends ChargedPickup;

//
// Reduces ballistic damage
//

defaultproperties
{
     skillNeeded=Class'DeusEx.SkillEnviro'
     LoopSound=Sound'DeusExSounds.Pickup.SuitLoop'
     ChargedIcon=Texture'DeusExUI.Icons.ChargedIconArmorBallistic'
     ExpireMessage="Ballistic Armor power supply used up"
     ItemName="Ballistic Armor"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.BallisticArmor'
     PickupViewMesh=LodMesh'DeusExItems.BallisticArmor'
     ThirdPersonMesh=LodMesh'DeusExItems.BallisticArmor'
     Charge=1000
     LandSound=Sound'DeusExSounds.Generic.PaperHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconArmorBallistic'
     largeIcon=Texture'DeusExUI.Icons.LargeIconArmorBallistic'
     largeIconWidth=34
     largeIconHeight=49
     Description="Ballistic armor is manufactured from electrically sensitive polymer sheets that intrinsically react to the violent impact of a bullet or an explosion by 'stiffening' in response and absorbing the majority of the damage.  These polymer sheets must be charged before use; after the charge has dissipated they lose their reflexive properties and should be discarded."
     beltDescription="BAL ARMOR"
     Mesh=LodMesh'DeusExItems.BallisticArmor'
     CollisionRadius=11.500000
     CollisionHeight=13.810000
     Mass=40.000000
     Buoyancy=30.000000
}
