//=============================================================================
// Lamp.
//=============================================================================
class Lamp extends Furniture
	abstract;

var() bool bOn;

function Frob(Actor Frobber, Inventory frobWith)
{
	Super.Frob(Frobber, frobWith);

	if (!bOn)
	{
		bOn = True;
		LightType = LT_Steady;
		PlaySound(sound'Switch4ClickOn');
		bUnlit = True;
		ScaleGlow = 2.0;
	}
	else
	{
		bOn = False;
		LightType = LT_None;
		PlaySound(sound'Switch4ClickOff');
		bUnlit = False;
		ResetScaleGlow();
	}
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (bOn)
		LightType = LT_Steady;
}

defaultproperties
{
     FragType=Class'DeusEx.GlassFragment'
     bPushable=False
     LightBrightness=255
     LightSaturation=255
     LightRadius=10
}
