//=============================================================================
// ExplosionLight
//=============================================================================
class ExplosionLight extends Light;

var int size;

function Timer()
{
	if (size > 0)
	{
		LightRadius = Clamp(size, 1, 16);
		size = -1;
	}

	LightRadius--;
	if (LightRadius < 1)
		Destroy();
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	SetTimer(0.1, True);
}

defaultproperties
{
     size=1
     bStatic=False
     bNoDelete=False
     bMovable=True
     RemoteRole=ROLE_SimulatedProxy
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=16
     LightSaturation=192
     LightRadius=1
     bVisionImportant=True
}
