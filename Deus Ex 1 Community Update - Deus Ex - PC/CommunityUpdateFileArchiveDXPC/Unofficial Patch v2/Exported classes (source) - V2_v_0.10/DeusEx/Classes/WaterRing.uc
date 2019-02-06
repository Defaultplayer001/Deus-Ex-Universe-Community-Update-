//=============================================================================
// WaterRing.
//=============================================================================
class WaterRing extends Effects;

var bool bScaleOnce;
var float extraRingTimer;
var bool bNoExtraRings;

simulated function Tick(float deltaTime)
{
	local WaterRing ring;

	if (!bNoExtraRings)
	{
		extraRingTimer += deltaTime;
		// spawn two more rings
		if (extraRingTimer >= 0.2)
		{
			extraRingTimer = 0;
			ring = Spawn(class'WaterRing');
			if (ring != None)
				ring.bNoExtraRings = True;
		}
	}

	// cut the scale in half the first time we draw
	if (!bScaleOnce)
	{
		DrawScale *= 0.5;
		bScaleOnce = True;
	}

	DrawScale += 2.0 * deltaTime;
	ScaleGlow = LifeSpan / Default.LifeSpan;
}

function PostBeginPlay()
{
	local Rotator rot;

	Super.PostBeginPlay();

	extraRingTimer = 0;
	rot.Pitch = 16384;
	rot.Roll = 0;
	rot.Yaw = Rand(65535);
	SetRotation(rot);
}

defaultproperties
{
     LifeSpan=0.500000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Skin=Texture'DeusExItems.Skins.FlatFXTex46'
     Mesh=LodMesh'DeusExItems.FlatFX'
     bUnlit=True
}
