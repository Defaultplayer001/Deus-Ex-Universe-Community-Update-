//=============================================================================
// AugStealth.
//=============================================================================
class AugStealth extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

state Active
{
Begin:
	Player.RunSilentValue = Player.AugmentationSystem.GetAugLevelValue(class'AugStealth');
	if ( Player.RunSilentValue == -1.0 )
		Player.RunSilentValue = 1.0;
}

function Deactivate()
{
	Player.RunSilentValue = 1.0;
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
     mpEnergyDrain=20.000000
     EnergyRate=40.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconRunSilent'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconRunSilent_Small'
     AugmentationName="Run Silent"
     Description="The necessary muscle movements for complete silence when walking or running are determined continuously with reactive kinematics equations produced by embedded nanocomputers.|n|nTECH ONE: Sound made while moving is reduced slightly.|n|nTECH TWO: Sound made while moving is reduced moderately.|n|nTECH THREE: Sound made while moving is reduced significantly.|n|nTECH FOUR: An agent is completely silent."
     MPInfo="When active, you do not make footstep sounds.  Energy Drain: Low"
     LevelValues(0)=0.750000
     LevelValues(1)=0.500000
     LevelValues(2)=0.250000
     AugmentationLocation=LOC_Leg
     MPConflictSlot=8
}
