//=============================================================================
// WeaponModRange
//
// Increases Accurate Range
//=============================================================================
class WeaponModRange extends WeaponMod;

// ----------------------------------------------------------------------
// ApplyMod()
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeapon weapon)
{
	if (weapon != None)
	{
		weapon.AccurateRange    += (weapon.Default.AccurateRange * WeaponModifier);
		weapon.ModAccurateRange += WeaponModifier;
	}
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

simulated function bool CanUpgradeWeapon(DeusExWeapon weapon)
{
	if (weapon != None)
		return (weapon.bCanHaveModAccurateRange && !weapon.HasMaxRangeMod());
	else
		return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     WeaponModifier=0.100000
     ItemName="Weapon Modification (Range)"
     Icon=Texture'DeusExUI.Icons.BeltIconWeaponModRange'
     largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponModRange'
     Description="By lubricating the firing path with synthetic synovial fluid, the drag on fired projectiles is greatly reduced with a consequent increase in range.|n|n<UNATCO OPS FILE NOTE SC111-BLUE> Coating the primary valve system of a flamethrower or plasma gun in synovial lubricant and then over-pressuring the delivery system will also result in an increase in range. Little trick I learned during field testing. -- Sam Carter <END NOTE>"
     beltDescription="MOD RANGE"
     Skin=Texture'DeusExItems.Skins.WeaponModTex1'
}
