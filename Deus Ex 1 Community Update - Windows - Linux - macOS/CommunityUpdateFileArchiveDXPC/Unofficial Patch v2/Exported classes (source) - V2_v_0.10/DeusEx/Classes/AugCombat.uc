//=============================================================================
// AugCombat.
//=============================================================================
class AugCombat extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

state Active
{
Begin:
}

function Deactivate()
{
	Super.Deactivate();
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
	}
}

defaultproperties
{
     mpAugValue=2.000000
     mpEnergyDrain=20.000000
     EnergyRate=20.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconCombat'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconCombat_Small'
     AugmentationName="Combat Strength"
     Description="Sorting rotors accelerate calcium ion concentration in the sarcoplasmic reticulum, increasing an agent's muscle speed several-fold and multiplying the damage they inflict in melee combat.|n|nTECH ONE: The effectiveness of melee weapons is increased slightly.|n|nTECH TWO: The effectiveness of melee weapons is increased moderately.|n|nTECH THREE: The effectiveness of melee weapons is increased significantly.|n|nTECH FOUR: Melee weapons are almost instantly lethal."
     MPInfo="When active, you do double damage with melee weapons.  Energy Drain: Low"
     LevelValues(0)=1.250000
     LevelValues(1)=1.500000
     LevelValues(2)=1.750000
     LevelValues(3)=2.000000
     AugmentationLocation=LOC_Arm
     MPConflictSlot=1
}
