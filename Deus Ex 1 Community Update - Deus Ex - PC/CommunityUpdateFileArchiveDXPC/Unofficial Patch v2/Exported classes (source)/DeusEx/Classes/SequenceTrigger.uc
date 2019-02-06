//=============================================================================
// SequenceTrigger
//=============================================================================
class SequenceTrigger expands Trigger;

// Triggers a MultiMover to go to a certain set of keyframes
// Also can trigger an ElevatorMover to go to a certain keyframe
// Defaults to being triggered (zero radius)
// Set a radius and bCollideActors to make it touchable

var() int SeqNum;

function CheckMovers()
{
	local Mover M;

	if (Event != '')
		foreach AllActors(class'Mover', M, Event)
		{
			if (MultiMover(M) != None)
				MultiMover(M).SetSeq(SeqNum);
			else if (ElevatorMover(M) != None)
				ElevatorMover(M).SetSeq(SeqNum);
		}
}

function Trigger(Actor Other, Pawn Instigator)
{
	CheckMovers();
	Super.Trigger(Other, Instigator);
}

function Touch(Actor Other)
{
	CheckMovers();
	Super.Touch(Other);
}

defaultproperties
{
     CollisionRadius=0.000000
     bCollideActors=False
}
