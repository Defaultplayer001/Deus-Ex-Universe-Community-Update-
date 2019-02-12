//=============================================================================
// FadeViewTrigger.
//=============================================================================
class FadeViewTrigger extends Trigger;

var() color fadeColor;
var() float fadeTime;
var() float postFadeTime;
var() bool bFadeDown;
var DeusExPlayer player;
var float time;

function Trigger(Actor Other, Pawn Instigator)
{
	Super.Trigger(Other, Instigator);
	FadeView();
}

singular function Touch(Actor Other)
{
	if (!IsRelevant(Other))
		return;

	Super.Touch(Other);
	FadeView();
}

function FadeView()
{
	player = DeusExPlayer(GetPlayerPawn());
	if (player != None)
	{
		// can't have a negative or zero fadeTime
		if (fadeTime < 0.1)
			fadeTime = 0.1;

		// can't have a negative postFadeTime
		if (postFadeTime < 0.0)
			postFadeTime = 0.0;

		time = fadeTime + postFadeTime;
	}
}

function Tick(float deltaTime)
{
	local float alpha;
	local vector fadeTo;

	Super.Tick(deltaTime);

	if (player != None)
	{
		time -= deltaTime;
		if (time < 0.0)
			time = 0.0;

		alpha = FClamp(1.0 - ((time - postFadeTime) / fadeTime), 0.0, 1.0);
		fadeTo.X = float(fadeColor.R) / 255.0;
		fadeTo.Y = float(fadeColor.G) / 255.0;
		fadeTo.Z = float(fadeColor.B) / 255.0;
		if (bFadeDown)
		{
			alpha = -alpha;
			fadeTo.X = float(255 - fadeColor.R) / 255.0;
			fadeTo.Y = float(255 - fadeColor.G) / 255.0;
			fadeTo.Z = float(255 - fadeColor.B) / 255.0;
		}

		// fade the view to the selected color
		player.InstantFog = alpha * fadeTo;
		player.InstantFlash = alpha;

		// after fade, delay postFadeTime seconds
		if (time <= 0)
			Destroy();
	}
}

defaultproperties
{
     fadeColor=(R=255,G=255,B=255)
     fadeTime=2.000000
     bTriggerOnceOnly=True
     CollisionRadius=96.000000
}
