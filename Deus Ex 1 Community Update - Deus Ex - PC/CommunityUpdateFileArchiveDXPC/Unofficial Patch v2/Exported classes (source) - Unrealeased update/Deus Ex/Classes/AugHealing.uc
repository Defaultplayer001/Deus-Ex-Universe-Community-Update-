//=============================================================================
// AugHealing.
//=============================================================================
class AugHealing extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

state Active
{
Begin:
Loop:
	Sleep(1.0);

	if (Player.Health < 100)
		Player.HealPlayer(Int(LevelValues[CurrentLevel]), False);
	else
		Deactivate();

	Player.ClientFlash(0.5, vect(0, 0, 500));
	Goto('Loop');
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
     mpAugValue=10.000000
     mpEnergyDrain=100.000000
     EnergyRate=120.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconHealing'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconHealing_Small'
     AugmentationName="Regeneration"
     Description="Programmable polymerase automatically directs construction of proteins in injured cells, restoring an agent to full health over time.|n|nTECH ONE: Healing occurs at a normal rate.|n|nTECH TWO: Healing occurs at a slightly faster rate.|n|nTECH THREE: Healing occurs at a moderately faster rate.|n|nTECH FOUR: Healing occurs at a significantly faster rate."
     MPInfo="When active, you heal, but at a rate insufficient for healing in combat.  Energy Drain: High"
     LevelValues(0)=5.000000
     LevelValues(1)=15.000000
     LevelValues(2)=25.000000
     LevelValues(3)=40.000000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=2
}
