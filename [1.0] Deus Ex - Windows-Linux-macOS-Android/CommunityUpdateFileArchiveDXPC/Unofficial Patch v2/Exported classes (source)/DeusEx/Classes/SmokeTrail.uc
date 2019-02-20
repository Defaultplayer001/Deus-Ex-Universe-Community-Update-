//=============================================================================
// SmokeTrail.
//=============================================================================
class SmokeTrail expands Effects;

var() float RiseRate;
var() bool bGravity;
var float OrigLifeSpan;
var float OrigScale;
var vector OrigVel;
var bool bScale;
var bool bFade;
var bool bFrozen;

// this seems to have to be here to load the damn smokepuff texture
#exec OBJ LOAD FILE=Effects

auto simulated state Flying
{
	simulated function Tick(float deltaTime)
	{
		// if we are frozen, don't update
		if (bFrozen && (Owner != None))
		{
			LifeSpan += deltaTime;
			return;
		}

		Velocity.X = OrigVel.X + 2 - FRand() * 5;
		Velocity.Y = OrigVel.Y + 2 - FRand() * 5;

		if (bGravity)
			Velocity.Z += Region.Zone.ZoneGravity.Z * deltaTime * 0.2;
		else
			Velocity.Z = OrigVel.Z + (RiseRate * (OrigLifeSpan - LifeSpan)) * (FRand() * 0.2 + 0.9);

		if (bScale)
		{
			if ( Level.NetMode != NM_Standalone )
				DrawScale = FClamp(OrigScale * (1.0 + (OrigLifeSpan - LifeSpan)), 0.4, 4.0);
			else
				DrawScale = FClamp(OrigScale * (1.0 + (OrigLifeSpan - LifeSpan)), 0.01, 4.0);
		}
		if (bFade)
			ScaleGlow = LifeSpan / OrigLifeSpan;	// this actually sets the alpha from 1.0 to 0.0
	}
	simulated function BeginState()
	{
		Super.BeginState();

		OrigScale = DrawScale;
		OrigVel = Velocity;
		OrigLifeSpan = LifeSpan;
	}
}

defaultproperties
{
     RiseRate=2.000000
     bScale=True
     bFade=True
     Physics=PHYS_Projectile
     LifeSpan=1.000000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=FireTexture'Effects.Smoke.SmokePuff1'
     DrawScale=0.100000
}
