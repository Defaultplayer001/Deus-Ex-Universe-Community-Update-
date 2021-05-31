//=============================================================================
// ShakeTrigger.
//=============================================================================
class ShakeTrigger extends Trigger;

// Shakes the screen when touched or triggered
// Set bCollideActors to False to make it triggered

var() float shakeTime;
var() float shakeRollMagnitude;
var() float shakeVertMagnitude;

function Trigger(Actor Other, Pawn Instigator)
{
	Instigator.ShakeView(shakeTime, shakeRollMagnitude, shakeVertMagnitude);

	Super.Trigger(Other, Instigator);
}

function Touch(Actor Other)
{
	local DeusExPlayer player;

	if (IsRelevant(Other))
	{
		player = DeusExPlayer(Other);
		if (player != None)
			player.ShakeView(shakeTime, shakeRollMagnitude, shakeVertMagnitude);

		Super.Touch(Other);
	}
}

defaultproperties
{
     shaketime=1.000000
     shakeRollMagnitude=1024.000000
     shakeVertMagnitude=16.000000
}
