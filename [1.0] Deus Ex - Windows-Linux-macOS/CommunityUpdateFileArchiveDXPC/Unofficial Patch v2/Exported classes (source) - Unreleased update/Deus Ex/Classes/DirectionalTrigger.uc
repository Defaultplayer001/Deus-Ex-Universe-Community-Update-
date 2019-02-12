//=============================================================================
// DirectionalTrigger.
//=============================================================================
class DirectionalTrigger extends Trigger;

singular function Touch(Actor Other)
{
	local Vector X, Y, Z;
	local float dotp;
	local bool bDoIt;

	bDoIt = True;

	// should we even pay attention to this actor?
	if (!IsRelevant(Other))
		return;

	if (Other != None)
	{
		GetAxes(Rotation, X, Y, Z);
		dotp = (Location - Other.Location) dot X;

		// if we're on the wrong side of the trigger, then don't trigger it
		if (dotp > 0.0)
			bDoIt = False;
	}

	if (bDoIt)
		Super.Touch(Other);
}

defaultproperties
{
     ReTriggerDelay=1.000000
     bDirectional=True
}
