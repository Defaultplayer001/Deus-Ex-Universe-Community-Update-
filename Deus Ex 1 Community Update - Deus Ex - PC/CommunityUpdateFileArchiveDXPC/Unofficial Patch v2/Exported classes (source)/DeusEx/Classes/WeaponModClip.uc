//=============================================================================
// WeaponModClip
//
// Increases Clip Capacity
//=============================================================================
class WeaponModClip extends WeaponMod;

// ----------------------------------------------------------------------
// ApplyMod()
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeapon weapon)
{
	local int diff;

	if (weapon != None)
	{
		diff = Float(weapon.Default.ReloadCount) * WeaponModifier;

		// make sure we add at least one
		if (diff < 1)
			diff = 1;

		weapon.ReloadCount += diff;
		weapon.ModReloadCount += WeaponModifier;
	}
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

simulated function bool CanUpgradeWeapon(DeusExWeapon weapon)
{
	if (weapon != None)
		return (weapon.bCanHaveModReloadCount && !weapon.HasMaxClipMod());
	else
		return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     WeaponModifier=0.100000
     ItemName="Weapon Modification (Clip)"
     Icon=Texture'DeusExUI.Icons.BeltIconWeaponModClip'
     largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponModClip'
     Description="An extended magazine that increases clip capacity beyond the factory default."
     beltDescription="MOD CLIP"
     Skin=Texture'DeusExItems.Skins.WeaponModTex3'
}
