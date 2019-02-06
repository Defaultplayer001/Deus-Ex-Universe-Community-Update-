//=============================================================================
// Fireball.
//=============================================================================
class Fireball extends DeusExProjectile;

var() float mpDamage;

#exec OBJ LOAD FILE=Effects

simulated function Tick(float deltaTime)
{
	local float value;
	local float sizeMult;

	// don't Super.Tick() becuase we don't want gravity to affect the stream
	time += deltaTime;

	value = 1.0+time;
	if (MinDrawScale > 0)
		sizeMult = MaxDrawScale/MinDrawScale;
	else
		sizeMult = 1;

	DrawScale = (-sizeMult/(value*value) + (sizeMult+1))*MinDrawScale;
	ScaleGlow = Default.ScaleGlow/(value*value*value);
}

function ZoneChange(ZoneInfo NewZone)
{
	Super.ZoneChange(NewZone);

	// If the fireball enters water, extingish it
	if (NewZone.bWaterZone)
		Destroy();
}


simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
		Damage = mpDamage;
}

defaultproperties
{
     mpDamage=5.000000
     blastRadius=1.000000
     DamageType=Flamed
     AccurateRange=320
     maxRange=320
     bIgnoresNanoDefense=True
     ItemName="Fireball"
     ItemArticle="a"
     speed=800.000000
     MaxSpeed=800.000000
     Damage=5.000000
     MomentumTransfer=500
     ExplosionDecal=Class'DeusEx.BurnMark'
     LifeSpan=0.500000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=FireTexture'Effects.Fire.flame_b'
     DrawScale=0.050000
     bUnlit=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=200
     LightHue=16
     LightSaturation=32
     LightRadius=2
}
