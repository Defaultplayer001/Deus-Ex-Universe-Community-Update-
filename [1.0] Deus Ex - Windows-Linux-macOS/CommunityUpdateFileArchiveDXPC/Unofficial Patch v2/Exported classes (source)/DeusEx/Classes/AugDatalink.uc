//=============================================================================
// AugDatalink.
//=============================================================================
class AugDatalink extends Augmentation;

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
     Icon=Texture'DeusExUI.UserInterface.AugIconDatalink'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconDatalink_Small'
     bAlwaysActive=True
     AugmentationName="Infolink"
     Description="One-way micro-transceiver array allows agents in the field to receive messages from Control, and to store and later retrieve relevant maps, conversations, and notes.|n|n<UNATCO OPS FILE NOTE JR133-VIOLET> This is top of the line all the way, so don't expect any upgrades. -- Jaime Reyes <END NOTE>|n|nNO UPGRADES"
     LevelValues(0)=1.000000
     LevelValues(1)=1.000000
     LevelValues(2)=1.000000
     LevelValues(3)=1.000000
     AugmentationLocation=LOC_Default
}
