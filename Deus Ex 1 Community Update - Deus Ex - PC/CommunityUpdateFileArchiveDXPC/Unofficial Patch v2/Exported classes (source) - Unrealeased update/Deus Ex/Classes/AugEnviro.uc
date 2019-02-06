//=============================================================================
// AugEnviro.
//=============================================================================
class AugEnviro extends Augmentation;

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
      AugmentationLocation = LOC_Subdermal;
	}
}

defaultproperties
{
     mpAugValue=0.100000
     mpEnergyDrain=20.000000
     EnergyRate=20.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconEnviro'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconEnviro_Small'
     AugmentationName="Environmental Resistance"
     Description="Induced keratin production strengthens all epithelial tissues and reduces the agent's vulnerability to radiation and other toxins.|n|nTECH ONE: Toxic resistance is increased slightly.|n|nTECH TWO: Toxic resistance is increased moderately.|n|nTECH THREE: Toxic resistance is increased significantly.|n|nTECH FOUR: An agent is nearly invulnerable to damage from toxins."
     MPInfo="When active, you only take 10% damage from poison and gas, and poison and gas will not affect your vision.  Energy Drain: Low"
     LevelValues(0)=0.750000
     LevelValues(1)=0.500000
     LevelValues(2)=0.250000
     LevelValues(3)=0.100000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=3
}
