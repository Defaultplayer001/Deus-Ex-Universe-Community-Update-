//=============================================================================
// LogicTrigger
//=============================================================================
class LogicTrigger expands Trigger;

// Allows boolean relationships between two different events
// To trigger - set the Event of whatever to match the Tag of this trigger
// For input 1 - set the Group of whatever to match inGroup1 of this trigger
// For input 2 - set the Group of whatever to match inGroup2 of this trigger

enum ELogicType
{
	GATE_AND,
	GATE_OR,
	GATE_XOR
};

var() name inGroup1, inGroup2;
var() ELogicType Op;
var() bool Not;
var() bool OneShot;
var bool in1, in2, out, outhit;

function Trigger(Actor Other, Pawn Instigator)
{
	local Actor A;

	if (Other.Group == inGroup1)
		in1 = !in1;
	if (Other.Group == inGroup2)
		in2 = !in2;

	switch(Op)
	{
		case GATE_AND:	out = in1 && in2;
						break;
		case GATE_OR:	out = in1 || in2;
						break;
		case GATE_XOR:	out = bool(int(in1) ^ int(in2));	// why isn't there a boolean XOR?
						break;
	}

	if (Not)
		out = !out;

	// Trigger event on out==true
	if (out && !outhit)
	{
		if (OneShot)
			outhit = True;
		if(Event != '')
			foreach AllActors(class 'Actor', A, Event)
				A.Trigger(Self, Instigator);
	}

	Super.Trigger(Other, Instigator);
}

defaultproperties
{
     CollisionRadius=0.000000
     bCollideActors=False
}
