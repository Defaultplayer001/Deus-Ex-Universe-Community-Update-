//=============================================================================
// ElevatorMover.
//=============================================================================
class ElevatorMover expands Mover;

var() bool bFollowKeyframes;

// Lets you move to a specified keyframe

var bool bIsMoving;

function BeginPlay()
{
	Super.BeginPlay();
	bIsMoving = False;
}

function SetSeq(int seqnum)
{
	if (bIsMoving)
		return;

	if (KeyNum != seqnum)
	{
		KeyNum = seqnum;
		GotoState('ElevatorMover', 'Next');
	}
}

auto state() ElevatorMover
{
	function InterpolateEnd(actor Other)
	{
		if (bFollowKeyframes)
			Super.InterpolateEnd(Other);
	}

Next:
	bIsMoving = True;
	PlaySound(OpeningSound);
	AmbientSound = MoveAmbientSound;
	InterpolateTo(KeyNum, MoveTime);
	FinishInterpolation();
	AmbientSound = None;
	FinishedOpening();
	bIsMoving = False;
	Stop;
}

defaultproperties
{
     InitialState=ElevatorMover
}
