//=============================================================================
// SenseTrigger.
//=============================================================================
class SenseTrigger expands Trigger;

var() class<Inventory> KeyNeeded;
var() Name failedEvent;

singular function Touch(Actor Other)
{
	local bool bDoIt;
	local Pawn P;
	local Inventory inv;
	local Actor A;

	bDoIt = False;

	// should we even pay attention to this actor?
	if (!IsRelevant(Other))
		return;

	P = Pawn(Other);
	if (P == None)
		return;

	for (inv=P.Inventory; inv!=None; inv=inv.Inventory)
		if (KeyNeeded == inv.Class)
			bDoIt = True;

	if (bDoIt)
		Super.Touch(Other);
	else
		if (failedEvent != '')
			foreach AllActors(class'Actor', A, failedEvent)
				A.Trigger(Other, Other.Instigator);
}

defaultproperties
{
     ReTriggerDelay=1.000000
}
