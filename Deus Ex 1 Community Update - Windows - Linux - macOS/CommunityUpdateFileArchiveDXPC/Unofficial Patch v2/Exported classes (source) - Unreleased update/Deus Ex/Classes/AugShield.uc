//=============================================================================
// AugShield.
//=============================================================================
class AugShield extends Augmentation;

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
      AugmentationLocation = LOC_Arm;
	}
}

defaultproperties
{
     mpAugValue=0.500000
     mpEnergyDrain=25.000000
     EnergyRate=40.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconShield'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconShield_Small'
     AugmentationName="Energy Shield"
     Description="Polyanilene capacitors below the skin absorb heat and electricity, reducing the damage received from flame, electrical, and plasma attacks.|n|nTECH ONE: Damage from energy attacks is reduced slightly.|n|nTECH TWO: Damage from energy attacks is reduced moderately.|n|nTECH THREE: Damage from energy attacks is reduced significantly.|n|nTECH FOUR: An agent is nearly invulnerable to damage from energy attacks."
     MPInfo="When active, you only take 50% damage from flame and plasma attacks.  Energy Drain: Low"
     LevelValues(0)=0.800000
     LevelValues(1)=0.600000
     LevelValues(2)=0.400000
     LevelValues(3)=0.200000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=1
}
