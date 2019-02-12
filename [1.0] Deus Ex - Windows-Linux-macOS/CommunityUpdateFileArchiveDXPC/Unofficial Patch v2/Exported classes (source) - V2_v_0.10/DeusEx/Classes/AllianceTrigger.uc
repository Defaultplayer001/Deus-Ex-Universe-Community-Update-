//=============================================================================
// AllianceTrigger.
//=============================================================================
class AllianceTrigger expands Trigger;

struct InitialAllianceInfo  {
	var() Name  AllianceName;
	var() float AllianceLevel;
	var() bool  bPermanent;
};

var() name Alliance;
var() InitialAllianceInfo Alliances[8];

//
// Set an NPCs alliances
//

function Trigger(Actor Other, Pawn Instigator)
{
	if (SetAlliances())
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

	if (SetAlliances())
		if (bTriggerOnceOnly)
			Destroy();
}

function bool SetAlliances()
{
	local ScriptedPawn P;
	local int i;

	// find the target NPC to set alliances
	if (Event != '')
		foreach AllActors (class'ScriptedPawn', P, Event)
		{
			P.SetAlliance(Alliance);
			for (i=0; i<ArrayCount(Alliances); i++)
				if (Alliances[i].AllianceName != '')
					P.ChangeAlly(Alliances[i].AllianceName, Alliances[i].AllianceLevel, Alliances[i].bPermanent);
		}

	return True;
}

defaultproperties
{
     bTriggerOnceOnly=True
     CollisionRadius=96.000000
}
