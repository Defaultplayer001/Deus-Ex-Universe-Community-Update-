//=============================================================================
// SkillAwardTrigger.
//=============================================================================
class SkillAwardTrigger expands Trigger;

// Gives the player skill points when touched or triggered
// Set bCollideActors to False to make it triggered

var() int skillPointsAdded;
var() localized String awardMessage;

function Trigger(Actor Other, Pawn Instigator)
{
	local DeusExPlayer player;

	Super.Trigger(Other, Instigator);

	player = DeusExPlayer(Instigator);

	if (player != None)
	{
		player.SkillPointsAdd(skillPointsAdded);
		player.ClientMessage(awardMessage);
	}
}

function Touch(Actor Other)
{
	local DeusExPlayer player;

	Super.Touch(Other);

	if (IsRelevant(Other))
	{
		player = DeusExPlayer(Other);

		if (player != None)
		{
			player.SkillPointsAdd(skillPointsAdded);
			player.ClientMessage(awardMessage);
		}
	}
}

defaultproperties
{
     skillPointsAdded=10
     awardMessage="DEFAULT SKILL AWARD MESSAGE - REPORT THIS AS A BUG"
     bTriggerOnceOnly=True
}
