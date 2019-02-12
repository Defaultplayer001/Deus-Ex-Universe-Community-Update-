//=============================================================================
// GoalCompleteTrigger.
//=============================================================================
class GoalCompleteTrigger expands Trigger;

// Sets a goal as completed when touched or triggered
// Set bCollideActors to False to make it triggered

var() name goalName;

function Trigger(Actor Other, Pawn Instigator)
{
	local DeusExGoal goal;
	local DeusExPlayer player;

	Super.Trigger(Other, Instigator);

	player = DeusExPlayer(GetPlayerPawn());

	if (player != None)
	{
		// First check to see if this goal exists
		goal = player.FindGoal(goalName);

		if (goal != None)
			player.GoalCompleted(goalName);
	}
}

function Touch(Actor Other)
{
	local DeusExGoal goal;
	local DeusExPlayer player;

	Super.Touch(Other);

	if (IsRelevant(Other))
	{
		player = DeusExPlayer(GetPlayerPawn());

		if (player != None)
		{
			// First check to see if this goal exists
			goal = player.FindGoal(goalName);

			if (goal != None)
				player.GoalCompleted(goalName);
		}
	}
}

defaultproperties
{
     bTriggerOnceOnly=True
}
