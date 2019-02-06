//=============================================================================
// RandomSounds.
//=============================================================================
class RandomSounds expands Keypoint;

//
// This actor will play random sounds (oneshots or ambients)
// * frequency is a percentage (between 0.00 and 1.00) of the time that this sound
//   is played - all of these should never add up to more than 1.00
// * bAmbient means that this sound is a looping ambient sound
// * minDuration is the minimum number of seconds that sound will be played (only for ambients)
// * maxDuration is the maximum number of seconds that sound will be played (only for ambients)
// * Volume is the volume (0-255)
// * Pitch is the pitch (64 is normal)
// * bFade means fade it in and out rather than just cutting it off (only for ambients)
// * bFakeDoppler means fake a doppler effect on the sound (only for ambients)
//
// Note that the bools are really ints because you can't have arrays of bools
//

var() Sound sounds[8];
var() float frequency[8];
var() byte bAmbient[8];
var() float minDuration[8];
var() float maxDuration[8];
var() byte Volume[8];
var() byte Pitch[8];
var() byte bFade[8];
var() byte bFakeDoppler[8];
var byte num;
var byte cur;
var float timer;
var float duration;
var bool bPlaying;

//
// check for percentage every second
//
function Tick(float deltaTime)
{
	local int i;
	local float rnd, freq, diff;

	Super.Tick(deltaTime);

	// if we are playing, check to see when we should stop
	if (bPlaying)
	{
		// only fade or doppler for ambients
		if (bAmbient[cur] > 0)
		{
			diff = duration - timer;

			// fade in until 2 seconds
			// scale from 0.0 to 1.0
			if ((timer < 2.0) && (bFade[cur] > 0))
				SoundVolume = Volume[cur] * (timer / 2.0);

			// fade out at 2 seconds left
			// scale from 1.0 to 0.0
			if ((diff < 2.0) && (bFade[cur] > 0))
				SoundVolume = Volume[cur] * (diff / 2.0);

			// doppler out at 4 seconds left
			// scale from 1.0 to 0.85
			if ((diff < 4.0) && (bFakeDoppler[cur] > 0))
				SoundPitch = Pitch[cur] * (((diff / 4.0) * 0.15) + 0.85);
		}
		if (timer > duration)
		{
			if (bAmbient[cur] > 0)
				AmbientSound = None;
			timer = 0;
			bPlaying = False;
		}
	}
	else if (timer >= 1.0)		// otherwise, test for a new sound
	{
		rnd = FRand();
		freq = 0;
		for (i=0; i<num; i++)
		{
			// make the test percentage cumulative
			freq += frequency[i];

			if (rnd < freq)
			{
				if (bAmbient[i] > 0)
				{
					AmbientSound = sounds[i];
					duration = FRand() * (maxDuration[i] - minDuration[i]) + minDuration[i];
					SoundVolume = Volume[i];
					SoundPitch = Pitch[i];
				}
				else
				{
					PlaySound(sounds[i], SLOT_None);
					duration = 2;		// 2 seconds for one-shot sounds
				}

				cur = i;
				timer = 0;
				bPlaying = True;
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
	cur = 0;
	bPlaying = False;
	AmbientSound = None;
	for (i=0; i<8; i++)
	{
		if (sounds[i] == None)
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
     minDuration(0)=4.000000
     minDuration(1)=4.000000
     minDuration(2)=4.000000
     minDuration(3)=4.000000
     minDuration(4)=4.000000
     minDuration(5)=4.000000
     minDuration(6)=4.000000
     minDuration(7)=4.000000
     maxDuration(0)=8.000000
     maxDuration(1)=8.000000
     maxDuration(2)=8.000000
     maxDuration(3)=8.000000
     maxDuration(4)=8.000000
     maxDuration(5)=8.000000
     maxDuration(6)=8.000000
     maxDuration(7)=8.000000
     Volume(0)=128
     Volume(1)=128
     Volume(2)=128
     Volume(3)=128
     Volume(4)=128
     Volume(5)=128
     Volume(6)=128
     Volume(7)=128
     Pitch(0)=64
     Pitch(1)=64
     Pitch(2)=64
     Pitch(3)=64
     Pitch(4)=64
     Pitch(5)=64
     Pitch(6)=64
     Pitch(7)=64
     bStatic=False
     SoundVolume=128
}
