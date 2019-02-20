//=============================================================================
// SkillSwimming.
//=============================================================================
class SkillSwimming extends Skill;

var int mpCost1;
var int mpCost2;
var int mpCost3;
var float mpLevel0;
var float mpLevel1;
var float mpLevel2;
var float mpLevel3;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
	{
		cost[0] = mpCost1;
		cost[1] = mpCost2;
		cost[2] = mpCost3;
		LevelValues[0] = mpLevel0;
		LevelValues[1] = mpLevel1;
		LevelValues[2] = mpLevel2;
		LevelValues[3] = mpLevel3;
	}
}

defaultproperties
{
     mpCost1=1000
     mpCost2=1000
     mpCost3=1000
     mpLevel0=1.000000
     mpLevel1=1.250000
     mpLevel2=1.500000
     mpLevel3=2.250000
     SkillName="Swimming"
     Description="Underwater operations require their own unique set of skills that must be developed by an agent with extreme physical dedication.|n|nUNTRAINED: An agent can swim normally.|n|nTRAINED: The swimming speed and lung capacity of an agent increases slightly.|n|nADVANCED:  The swimming speed and lung capacity of an agent increases moderately.|n|nMASTER: An agent moves like a dolphin underwater."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconSwimming'
     bAutomatic=True
     cost(0)=675
     cost(1)=1350
     cost(2)=2250
     LevelValues(0)=1.000000
     LevelValues(1)=1.500000
     LevelValues(2)=2.000000
     LevelValues(3)=2.500000
}
