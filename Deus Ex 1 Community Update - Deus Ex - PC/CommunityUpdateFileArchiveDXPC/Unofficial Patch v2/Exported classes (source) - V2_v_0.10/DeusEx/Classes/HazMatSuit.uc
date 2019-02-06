//=============================================================================
// HazMatSuit.
//=============================================================================
class HazMatSuit extends ChargedPickup;

//
// Reduces poison gas, tear gas, and radiation damage
//

defaultproperties
{
     skillNeeded=Class'DeusEx.SkillEnviro'
     LoopSound=Sound'DeusExSounds.Pickup.SuitLoop'
     ChargedIcon=Texture'DeusExUI.Icons.ChargedIconHazMatSuit'
     ExpireMessage="HazMatSuit power supply used up"
     ItemName="Hazmat Suit"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.HazMatSuit'
     PickupViewMesh=LodMesh'DeusExItems.HazMatSuit'
     ThirdPersonMesh=LodMesh'DeusExItems.HazMatSuit'
     LandSound=Sound'DeusExSounds.Generic.PaperHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconHazMatSuit'
     largeIcon=Texture'DeusExUI.Icons.LargeIconHazMatSuit'
     largeIconWidth=46
     largeIconHeight=45
     Description="A standard hazardous materials suit that protects against a full range of environmental hazards including radiation, fire, biochemical toxins, electricity, and EMP. Hazmat suits contain an integrated bacterial oxygen scrubber that degrades over time and thus should not be reused."
     beltDescription="HAZMAT"
     Texture=Texture'DeusExItems.Skins.ReflectionMapTex1'
     Mesh=LodMesh'DeusExItems.HazMatSuit'
     CollisionRadius=17.000000
     CollisionHeight=11.520000
     Mass=20.000000
     Buoyancy=12.000000
}
