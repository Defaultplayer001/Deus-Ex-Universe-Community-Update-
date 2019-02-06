//=============================================================================
// AlarmLight.
//=============================================================================
class AlarmLight extends DeusExDecoration;

enum ESkinColor
{
	SC_Red,
	SC_Green,
	SC_Blue,
	SC_Amber
};

var() ESkinColor SkinColor;
var() bool bIsOn;

function SetLightColor(ESkinColor color)
{
	switch (SkinColor)
	{
		case SC_Red:		MultiSkins[1] = Texture'AlarmLightTex2';
							MultiSkins[2] = Texture'AlarmLightTex3';
							Texture = Texture'AlarmLightTex3';
							LightHue = 0;
							break;
		case SC_Green:		MultiSkins[1] = Texture'AlarmLightTex4';
							MultiSkins[2] = Texture'AlarmLightTex5';
							Texture = Texture'AlarmLightTex5';
							LightHue = 64;
							break;
		case SC_Blue:		MultiSkins[1] = Texture'AlarmLightTex6';
							MultiSkins[2] = Texture'AlarmLightTex7';
							Texture = Texture'AlarmLightTex7';
							LightHue = 160;
							break;
		case SC_Amber:		MultiSkins[1] = Texture'AlarmLightTex8';
							MultiSkins[2] = Texture'AlarmLightTex9';
							Texture = Texture'AlarmLightTex9';
							LightHue = 36;
							break;
	}
}

function BeginPlay()
{
	Super.BeginPlay();

	SetLightColor(SkinColor);

	if (!bIsOn)
	{
		MultiSkins[1] = Texture'BlackMaskTex';
		LightType = LT_None;
		bFixedRotationDir = False;
	}
}

// if we are triggered, turn us on
function Trigger(Actor Other, Pawn Instigator)
{
	if (!bIsOn)
	{
		bIsOn = True;
		SetLightColor(SkinColor);
		LightType = LT_Steady;
		bFixedRotationDir = True;
	}

	Super.Trigger(Other, Instigator);
}

// if we are untriggered, turn us off
function UnTrigger(Actor Other, Pawn Instigator)
{
	if (bIsOn)
	{
		bIsOn = False;
		MultiSkins[1] = Texture'BlackMaskTex';
		LightType = LT_None;
		bFixedRotationDir = False;
	}

	Super.UnTrigger(Other, Instigator);
}

defaultproperties
{
     bIsOn=True
     FragType=Class'DeusEx.PlasticFragment'
     ItemName="Alarm Light"
     bPushable=False
     Physics=PHYS_Rotating
     Texture=Texture'DeusExDeco.Skins.AlarmLightTex3'
     Mesh=LodMesh'DeusExDeco.AlarmLight'
     CollisionRadius=4.000000
     CollisionHeight=6.140000
     LightType=LT_Steady
     LightEffect=LE_Spotlight
     LightBrightness=255
     LightRadius=32
     LightCone=32
     bFixedRotationDir=True
     Mass=20.000000
     Buoyancy=15.000000
     RotationRate=(Yaw=98304)
}
