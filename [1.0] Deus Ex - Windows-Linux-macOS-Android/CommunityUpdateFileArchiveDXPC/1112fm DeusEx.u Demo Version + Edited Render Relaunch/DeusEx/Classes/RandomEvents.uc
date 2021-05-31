//=============================================================================
// RandomEvents.
//=============================================================================
class RandomEvents expands Keypoint;

//
// This actor will trigger random events
// * frequency is a percentage (between 0.00 and 1.00) of the time that this sound
//   is played - all of these should never add up to more than 1.00
//

var() Name Events[8];
var() float frequency[8];
var() bool bLOSRequired;		// if true, then events only happen when player is looking
var byte num;
var float timer;

//
// check for percentage every second
//
function Tick(float deltaTime)
{
	local int i;
	local float rnd, freq, diff;
	local Actor A;

	Super.Tick(deltaTime);

	if (bLOSRequired && !PlayerCanSeeMe())
		return;

	// test for a new event possibility
	if (timer >= 1.0)
	{
		rnd = FRand();
		freq = 0;
		for (i=0; i<num; i++)
		{
			// make the test percentage cumulative
			freq += frequency[i];

			if (rnd < freq)
			{
				// trigger it!
				if(Events[i] != '')
					foreach AllActors(class 'Actor', A, Events[i])
						A.Trigger(Self, None);

				timer = 0;
				return;
			}
		}

		timer -=1.0;
	}

	timer += deltaTime;
}

function BeginPlay()
{
	local int i;

	Super.BeginPlay();

	num = 0;
	timer = 0;
	for (i=0; i<8; i++)
	{
		if (Events[i] == '')
			break;
		num++;
	}
}

defaultproperties
{
     Frequency(0)=0.125000
     Frequency(1)=0.125000
     Frequency(2)=0.125000
     Frequency(3)=0.125000
     Frequency(4)=0.125000
     Frequency(5)=0.125000
     Frequency(6)=0.125000
     Frequency(7)=0.125000
     bLOSRequired=True
     bStatic=False
}
