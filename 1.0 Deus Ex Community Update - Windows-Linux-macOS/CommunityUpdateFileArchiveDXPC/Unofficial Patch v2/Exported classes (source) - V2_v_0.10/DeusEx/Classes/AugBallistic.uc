//=============================================================================
// AugBallistic.
//=============================================================================
class AugBallistic extends Augmentation;

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
     mpAugValue=0.600000
     mpEnergyDrain=90.000000
     EnergyRate=60.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconBallistic'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconBallistic_Small'
     AugmentationName="Ballistic Protection"
     Description="Monomolecular plates reinforce the skin's epithelial membrane, reducing the damage an agent receives from projectiles and bladed weapons.|n|nTECH ONE: Damage from projectiles and bladed weapons is reduced slightly.|n|nTECH TWO: Damage from projectiles and bladed weapons is reduced moderately.|n|nTECH THREE: Damage from projectiles and bladed weapons is reduced significantly.|n|nTECH FOUR: An agent is nearly invulnerable to damage from projectiles and bladed weapons."
     MPInfo="When active, damage from projectiles and melee weapons is reduced by 40%.  Energy Drain: High"
     LevelValues(0)=0.800000
     LevelValues(1)=0.650000
     LevelValues(2)=0.500000
     LevelValues(3)=0.350000
     AugmentationLocation=LOC_Subdermal
     MPConflictSlot=4
}
