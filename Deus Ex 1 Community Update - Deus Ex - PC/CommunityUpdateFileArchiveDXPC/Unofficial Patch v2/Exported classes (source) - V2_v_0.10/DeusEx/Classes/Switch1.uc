//=============================================================================
// Switch1.
//=============================================================================
class Switch1 extends DeusExDecoration;

var bool bOn;

function Frob(Actor Frobber, Inventory frobWith)
{
	Super.Frob(Frobber, frobWith);

	if (bOn)
	{
		PlaySound(sound'Switch4ClickOff');
		PlayAnim('Off');
	}
	else
	{
		PlaySound(sound'Switch4ClickOn');
		PlayAnim('On');
	}

	bOn = !bOn;
}

defaultproperties
{
     bInvincible=True
     ItemName="Switch"
     bPushable=False
     Physics=PHYS_None
     Mesh=LodMesh'DeusExDeco.Switch1'
     CollisionRadius=2.630000
     CollisionHeight=2.970000
     Mass=10.000000
     Buoyancy=12.000000
}
