//=============================================================================
// AugIFF.
//=============================================================================
class AugIFF extends Augmentation;

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
state Active
{
Begin:
}

// ----------------------------------------------------------------------
// Deactivate()
// ----------------------------------------------------------------------

function Deactivate()
{
	Super.Deactivate();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     EnergyRate=0.000000
     MaxLevel=0
     Icon=Texture'DeusExUI.UserInterface.AugIconIFF'
     bAlwaysActive=True
     AugmentationName="IFF"
     Description="Automatic friend or foe identification uses advanced heuristic algorithms to associate visible objects with known threat categories.|n|nTargeting reticle highlights RED over enemies, and GREEN over allies and neutrals.|n|nNO UPGRADES"
     LevelValues(0)=1.000000
     AugmentationLocation=LOC_Default
}
