//=============================================================================
// SkillWeaponPistol.
//=============================================================================
class SkillWeaponPistol extends Skill;

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

	if ( Level.NetMode == NM_Standalone )
		CurrentLevel = 1;

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
     mpCost1=2000
     mpCost2=2000
     mpCost3=2000
     mpLevel0=-0.100000
     mpLevel1=-0.250000
     mpLevel2=-0.370000
     mpLevel3=-0.500000
     SkillName="Weapons: Pistol"
     Description="The use of hand-held weapons, including the standard 10mm pistol, its stealth variant, and the mini-crossbow.|n|nUNTRAINED: An agent can use pistols.|n|nTRAINED: Accuracy and damage increases slightly, while reloading is faster.|n|nADVANCED: Accuracy and damage increases moderately, while reloading is even more rapid.|n|nMASTER: An agent is lethally precise with pistols."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponPistol'
     cost(0)=1575
     cost(1)=3150
     cost(2)=5250
     LevelValues(1)=-0.100000
     LevelValues(2)=-0.250000
     LevelValues(3)=-0.500000
}
