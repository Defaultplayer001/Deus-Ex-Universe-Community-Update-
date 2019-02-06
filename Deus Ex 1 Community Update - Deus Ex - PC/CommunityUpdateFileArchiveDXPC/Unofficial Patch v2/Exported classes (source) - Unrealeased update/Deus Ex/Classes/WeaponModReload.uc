//=============================================================================
// WeaponModReload
//
// Decreases reload time
//=============================================================================
class WeaponModReload extends WeaponMod;

// ----------------------------------------------------------------------
// ApplyMod()
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeapon weapon)
{
	if (weapon != None)
	{
		weapon.ReloadTime    += (weapon.Default.ReloadTime * WeaponModifier);
		if (weapon.ReloadTime < 0.0)
			weapon.ReloadTime = 0.0;
		weapon.ModReloadTime += WeaponModifier;
	}
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

simulated function bool CanUpgradeWeapon(DeusExWeapon weapon)
{
	if (weapon != None)
		return (weapon.bCanHaveModReloadTime && !weapon.HasMaxReloadMod());
	else
		return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     WeaponModifier=-0.100000
     ItemName="Weapon Modification (Reload)"
     Icon=Texture'DeusExUI.Icons.BeltIconWeaponModReload'
     largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponModReload'
     Description="A speed loader greatly decreases the time required to reload a weapon."
     beltDescription="MOD RELOD"
     Skin=Texture'DeusExItems.Skins.WeaponModTex6'
}
