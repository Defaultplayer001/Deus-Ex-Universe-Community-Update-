//=============================================================================
// SequenceEvents.
//=============================================================================
class SequenceEvents expands Keypoint;

var() Name Events[8];
var() float Delays[8];
var() float RestartTime;		// time delay before restarting if looping
var() bool bLoop;				// set to loop forever
var() bool bLOSRequired;		// if true, then events only happen when player is looking
var byte num;
var int i;
var Actor A;

auto state Active
{
Begin:
	num = 0;
	for (i=0; i<ArrayCount(Events); i++)
	{
		if (Events[i] == '')
			break;
		num++;
	}

Loop:
	if ((bLOSRequired && PlayerCanSeeMe()) || !bLOSRequired)
	{
		for (i=0; i<num; i++)
		{
			if(Events[i] != '')
				foreach AllActors(class 'Actor', A, Events[i])
					A.Trigger(Self, None);
	
			Sleep(Delays[i]);
		}
	}

	if (bLoop)
	{
		Sleep(RestartTime);
		Goto('Loop');
	}
}

defaultproperties
{
     Delays(0)=1.000000
     Delays(1)=1.000000
     Delays(2)=1.000000
     Delays(3)=1.000000
     Delays(4)=1.000000
     Delays(5)=1.000000
     Delays(6)=1.000000
     Delays(7)=1.000000
     RestartTime=2.000000
     bLoop=True
     bLOSRequired=True
     bStatic=False
}
