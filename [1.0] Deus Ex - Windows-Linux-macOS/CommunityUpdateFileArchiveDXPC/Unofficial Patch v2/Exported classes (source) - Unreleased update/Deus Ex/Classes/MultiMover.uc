//=============================================================================
// MultiMover.
//=============================================================================
class MultiMover expands Mover;

// Lets you specify four different sequences of up to four keyframes each.
// Each sequence can be triggered independently (like for an elevator or a crane)

var() int SeqKey1[4];
var() int SeqKey2[4];
var() int SeqKey3[4];
var() int SeqKey4[4];
var() float SeqTime1[4];
var() float SeqTime2[4];
var() float SeqTime3[4];
var() float SeqTime4[4];
var() bool bReverseKeyframes;
var bool bIsMoving;
var int LastSeq;
var int CurrentSeq;
var int i;		// why can't I put this in the state?

function int SeqKeys(int seq, int which)
{
	switch (seq)
	{
		case 0: return SeqKey1[which];
		case 1: return SeqKey2[which];
		case 2: return SeqKey3[which];
		case 3: return SeqKey4[which];
	}

	return -1;
}

function float SeqTimes(int seq, int which)
{
	switch (seq)
	{
		case 0: return SeqTime1[which];
		case 1: return SeqTime2[which];
		case 2: return SeqTime3[which];
		case 3: return SeqTime4[which];
	}

	return -1;
}

function BeginPlay()
{
	Super.BeginPlay();
	bIsMoving = False;
	LastSeq = -1;
	CurrentSeq = -1;
}

function SetSeq(int seqnum)
{
	if (bIsMoving)
		return;

	if (CurrentSeq != seqnum)
	{
		LastSeq = CurrentSeq;
		CurrentSeq = seqnum;
		GotoState('MultiMover', 'Close');
	}
}

auto state() MultiMover
{
	// stub out InterpolateEnd so it doesn't use the intermediate keyframes
	function InterpolateEnd(actor Other)
	{
	}

// reverse the previous sequence (if any) before playing the new one
Close:
	bIsMoving = True;
	if ((LastSeq > 0) && (bReverseKeyframes))
	{
		PlaySound(ClosingSound);
		AmbientSound = MoveAmbientSound;
		for (i=3; i>=0; i--)
			if (SeqKeys(LastSeq, i) >= 0)
				if (SeqKeys(LastSeq, i) != KeyNum)
				{
					InterpolateTo(SeqKeys(LastSeq, i), SeqTimes(LastSeq, i));
					FinishInterpolation();
				}

		AmbientSound = None;
		FinishedClosing();
	}

Open:
	PlaySound(OpeningSound);
	AmbientSound = MoveAmbientSound;
	for (i=0; i<4; i++)
		if (SeqKeys(CurrentSeq, i) >= 0)
			if (SeqKeys(CurrentSeq, i) != KeyNum)
			{
				InterpolateTo(SeqKeys(CurrentSeq, i), SeqTimes(CurrentSeq, i));
				FinishInterpolation();
			}

	AmbientSound = None;
	FinishedOpening();
	bIsMoving = False;
	Stop;
}

defaultproperties
{
     SeqKey1(0)=-1
     SeqKey1(1)=-1
     SeqKey1(2)=-1
     SeqKey1(3)=-1
     SeqKey2(0)=-1
     SeqKey2(1)=-1
     SeqKey2(2)=-1
     SeqKey2(3)=-1
     SeqKey3(0)=-1
     SeqKey3(1)=-1
     SeqKey3(2)=-1
     SeqKey3(3)=-1
     SeqKey4(0)=-1
     SeqKey4(1)=-1
     SeqKey4(2)=-1
     SeqKey4(3)=-1
     bReverseKeyframes=True
     LastSeq=-1
     CurrentSeq=-1
     InitialState=MultiMover
}
