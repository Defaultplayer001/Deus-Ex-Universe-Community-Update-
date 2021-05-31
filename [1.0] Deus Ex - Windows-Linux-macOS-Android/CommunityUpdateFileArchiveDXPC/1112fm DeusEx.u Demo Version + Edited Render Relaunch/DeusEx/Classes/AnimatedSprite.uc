//=============================================================================
// AnimatedSprite.
//=============================================================================
class AnimatedSprite expands Effects
	abstract;

var float animSpeed;
var int numFrames;
var int nextFrame;
var texture frames[16];
var float time, totalTime, duration;

simulated function Tick(float deltaTime)
{
	time += deltaTime;
	totalTime += deltaTime;

	DrawScale = 0.5 + (3.0 * totalTime / duration);
	ScaleGlow = (duration - totalTime) / duration;

	if (time >= animSpeed)
	{
		Texture = frames[nextFrame++];
		if (nextFrame >= numFrames)
			Destroy();

		time -= animSpeed;
	}
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	// calculate length of animation
	duration = animSpeed * numFrames;
}

defaultproperties
{
     animSpeed=0.075000
     nextFrame=1
     DrawType=DT_Sprite
     Style=STY_Translucent
     bUnlit=True
}
