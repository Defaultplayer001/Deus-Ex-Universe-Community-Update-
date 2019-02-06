//=============================================================================
// AmbientSoundTriggered.
//=============================================================================
class AmbientSoundTriggered extends AmbientSound;

var Sound savedSound;
var() bool bActive;
var() bool bTriggerOnceOnly;
var bool bAlreadyHit;

function Trigger(Actor Other, Pawn Instigator)
{
	if (bTriggerOnceOnly && bAlreadyHit)
		return;

	Super.Trigger(Other, Instigator);

	bActive = !bActive;
	if (bActive)
		AmbientSound = savedSound;
	else
		AmbientSound = None;

	bAlreadyHit = True;
}

function UnTrigger(Actor Other, Pawn Instigator)
{
	if (bTriggerOnceOnly && bAlreadyHit)
		return;

	Super.UnTrigger(Other, Instigator);

	bActive = False;
	AmbientSound = None;

	bAlreadyHit = True;
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	savedSound = AmbientSound;

	if (!bActive)
		AmbientSound = None;
}

defaultproperties
{
     bActive=True
}
