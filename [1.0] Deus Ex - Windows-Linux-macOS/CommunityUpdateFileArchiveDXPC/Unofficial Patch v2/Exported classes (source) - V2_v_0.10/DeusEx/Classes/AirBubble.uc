//=============================================================================
// AirBubble.
//=============================================================================
class AirBubble expands Effects;

var() float RiseRate;
var vector OrigVel;

auto state Flying
{
	simulated function Tick(float deltaTime)
	{
		Velocity.X = OrigVel.X + 8 - FRand() * 17;
		Velocity.Y = OrigVel.Y + 8 - FRand() * 17;
		Velocity.Z = RiseRate * (FRand() * 0.2 + 0.9);

		if (!Region.Zone.bWaterZone)
			Destroy();
	}

	simulated function BeginState()
	{
		Super.BeginState();

		OrigVel = Velocity;
		DrawScale += FRand() * 0.1;
	}
}

defaultproperties
{
     RiseRate=50.000000
     Physics=PHYS_Projectile
     LifeSpan=10.000000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'DeusExItems.Skins.FlatFXTex45'
     DrawScale=0.050000
}
