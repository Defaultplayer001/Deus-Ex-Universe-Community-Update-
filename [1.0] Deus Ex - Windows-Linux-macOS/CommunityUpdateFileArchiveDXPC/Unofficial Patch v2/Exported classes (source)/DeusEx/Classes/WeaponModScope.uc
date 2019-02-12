//=============================================================================
// WeaponModScope
//
// Adds a scope sight to a weapon
//=============================================================================
class WeaponModScope extends WeaponMod;

// ----------------------------------------------------------------------
// ApplyMod()
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeapon weapon)
{
	if (weapon != None)
		weapon.bHasScope = True;
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

simulated function bool CanUpgradeWeapon(DeusExWeapon weapon)
{
	if (weapon != None)
		return (weapon.bCanHaveScope && !weapon.bHasScope);
	else
		return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ItemName="Weapon Modification (Scope)"
     Icon=Texture'DeusExUI.Icons.BeltIconWeaponModScope'
     largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponModScope'
     Description="A telescopic scope attachment provides zoom capability and increases accuracy against distant targets."
     beltDescription="MOD SCOPE"
     Skin=Texture'DeusExItems.Skins.WeaponModTex8'
}
