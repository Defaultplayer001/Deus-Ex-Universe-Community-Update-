//=============================================================================
// WeaponModSilencer
//
// Adds a Silencer sight to a weapon
//=============================================================================
class WeaponModSilencer extends WeaponMod;

// ----------------------------------------------------------------------
// ApplyMod()
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeapon weapon)
{
	if (weapon != None)
		weapon.bHasSilencer = True;
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

simulated function bool CanUpgradeWeapon(DeusExWeapon weapon)
{
	if (weapon != None)
		return (weapon.bCanHaveSilencer && !weapon.bHasSilencer);
	else
		return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ItemName="Weapon Modification (Silencer)"
     Icon=Texture'DeusExUI.Icons.BeltIconWeaponModSilencer'
     largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponModSilencer'
     Description="A silencer will muffle the muzzle crack caused by rapidly expanding gases left in the wake of a bullet leaving the gun barrel.|n|n<UNATCO OPS FILE NOTE SC108-BLUE> Obviously, a silencer is only effective with firearms. -- Sam Carter <END NOTE>"
     beltDescription="MOD SLNCR"
     Skin=Texture'DeusExItems.Skins.WeaponModTex7'
}
