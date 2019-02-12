//=============================================================================
// UnTrigger.
//=============================================================================
class UnTrigger extends Trigger;

// Sends an UnTrigger event when touched or triggered
// Set bCollideActors to False to make it triggered

function Trigger(Actor Other, Pawn Instigator)
{
	local Actor A;

	// UnTrigger event
	if(Event != '')
		foreach AllActors(class 'Actor', A, Event)
			A.UnTrigger(Other, Instigator);
}

function Touch(Actor Other)
{
	local Actor A;

	// UnTrigger event
	if (IsRelevant(Other))
		if(Event != '')
			foreach AllActors(class 'Actor', A, Event)
				A.UnTrigger(Other, Pawn(Other));
}

defaultproperties
{
}
