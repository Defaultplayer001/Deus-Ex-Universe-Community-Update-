//=============================================================================
// AugmentationUpgradeCannister.
//
// Allows the player to upgrade any augmentation
//=============================================================================
class AugmentationUpgradeCannister extends DeusExPickup;

var localized string MustBeUsedOn;

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

	winInfo.Clear();
	winInfo.SetTitle(itemName);
	winInfo.SetText(Description $ winInfo.CR() $ winInfo.CR() $ MustBeUsedOn);

	return True;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     MustBeUsedOn="Must be used on Augmentations Screen."
     ItemName="Augmentation Upgrade Canister"
     ItemArticle="an"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.AugmentationUpgradeCannister'
     PickupViewMesh=LodMesh'DeusExItems.AugmentationUpgradeCannister'
     ThirdPersonMesh=LodMesh'DeusExItems.AugmentationUpgradeCannister'
     LandSound=Sound'DeusExSounds.Generic.PlasticHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconAugmentationUpgrade'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAugmentationUpgrade'
     largeIconWidth=24
     largeIconHeight=41
     Description="An augmentation upgrade canister contains highly specific nanomechanisms that, when combined with a previously programmed module, can increase the efficiency of an installed augmentation. Because no programming is required, upgrade canisters may be used by trained agents in the field with minimal risk."
     beltDescription="AUG UPG"
     Mesh=LodMesh'DeusExItems.AugmentationUpgradeCannister'
     CollisionRadius=3.200000
     CollisionHeight=5.180000
     Mass=10.000000
     Buoyancy=12.000000
}
