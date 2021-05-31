//=============================================================================
// SkillTech.
//=============================================================================
class SkillTech extends Skill;

var int mpCost1;
var int mpCost2;
var int mpCost3;
var float mpLevel0;
var float mpLevel1;
var float mpLevel2;
var float mpLevel3;

var localized String MultitoolString;

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
		skillName=MultitoolString;
	}
}

defaultproperties
{
     mpCost1=1000
     mpCost2=1000
     mpCost3=1000
     mpLevel0=0.100000
     mpLevel1=0.400000
     mpLevel2=0.550000
     mpLevel3=0.950000
     MultitoolString="Multitooling"
     SkillName="Electronics"
     Description="By studying electronics and its practical application, agents can more efficiently bypass a number of security systems using multitools.|n|nUNTRAINED: An agent can bypass security systems.|n|nTRAINED: The efficiency with which an agent bypasses security increases slightly.|n|nADVANCED: The efficiency with which an agent bypasses security increases moderately.|n|nMASTER: An agent encounters almost no security systems of any challenge."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconTech'
     cost(0)=1800
     cost(1)=3600
     cost(2)=6000
     LevelValues(0)=0.100000
     LevelValues(1)=0.250000
     LevelValues(2)=0.400000
     LevelValues(3)=0.750000
     itemNeeded=Class'DeusEx.Multitool'
}
