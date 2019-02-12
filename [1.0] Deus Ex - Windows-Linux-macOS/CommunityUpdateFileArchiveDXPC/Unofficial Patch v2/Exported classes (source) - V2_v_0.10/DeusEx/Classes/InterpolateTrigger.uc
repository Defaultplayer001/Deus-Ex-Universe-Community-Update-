//=============================================================================
// InterpolateTrigger.
//=============================================================================
class InterpolateTrigger expands Trigger;

// Send an actor on a spline path through the level
// Copied and modified from Engine.SpecialEvent
// Set this trigger's Event to match the Tag of the target actor
// The target actor's Event should match the Tag of the InterpolationPoints

function Trigger(Actor Other, Pawn Instigator)
{
	if (SendActorOnPath())
	{
		Super.Trigger(Other, Instigator);
		if (bTriggerOnceOnly)
			Destroy();
	}
}

singular function Touch(Actor Other)
{
	if (!IsRelevant(Other))
		return;

	if (SendActorOnPath())
		if (bTriggerOnceOnly)
			Destroy();
}

function bool SendActorOnPath()
{
	local InterpolationPoint I;
	local Actor A;

	// find the target actors to start on the path
	foreach AllActors (class'Actor', A, Event)
		if ((A != None) && !A.IsA('InterpolationPoint'))
		{
			foreach AllActors (class'InterpolationPoint', I, A.Event)
			{
				if (I.Position == 1)		// start at 1 instead of 0 - put 0 at the object's initial position
				{
					A.SetCollision(False, False, False);
					A.bCollideWorld = False;
					A.Target = I;
					A.SetPhysics(PHYS_Interpolating);
					A.PhysRate = 1.0;
					A.PhysAlpha = 0.0;
					A.bInterpolating = True;
					A.bStasis = False;
					A.GotoState('Interpolating');
					break;
				}
			}
		}

	return True;
}

defaultproperties
{
     bTriggerOnceOnly=True
     CollisionRadius=96.000000
}
