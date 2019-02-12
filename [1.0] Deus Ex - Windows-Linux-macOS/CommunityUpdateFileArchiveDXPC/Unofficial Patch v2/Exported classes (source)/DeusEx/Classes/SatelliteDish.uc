//=============================================================================
// SatelliteDish.
//=============================================================================
class SatelliteDish expands OutdoorThings;

#exec OBJ LOAD FILE=MoverSFX

var() bool bRandomRotation;
var float time;
var Rotator origRot;

function Tick(float deltaTime)
{
	local int newYaw;

	time += deltaTime;

	// if we're done rotating, stop the ambient sound
	if (Rotation.Yaw ~= DesiredRotation.Yaw)
		AmbientSound = None;
	else
		AmbientSound = sound'LargeElevMove';

	// check for rotation every 10 seconds
	if (bRandomRotation)
	{
		if (time > 10.0)
		{
			if (FRand() < 0.15)
			{
				// how far should we turn?
				newYaw = 4096 - Rand(8192);
				DesiredRotation.Yaw = origRot.Yaw + newYaw;
				if (DesiredRotation.Yaw < 0)
					DesiredRotation.Yaw += 65536;
				DesiredRotation.Yaw = DesiredRotation.Yaw % 65536;

				// play a cool startup sound
				PlaySound(sound'LargeElevStart', SLOT_Misc,,, 1024);
			}
			time = 0;
		}
	}

	Super.Tick(deltaTime);
}

function BeginPlay()
{
	Super.BeginPlay();

	origRot = Rotation;
	DesiredRotation = Rotation;

	if (Level.Netmode != NM_Standalone)
		bRandomRotation=False;
}

defaultproperties
{
     bRandomRotation=True
     bStatic=False
     Physics=PHYS_Rotating
     Mesh=LodMesh'DeusExDeco.SatelliteDish'
     SoundRadius=16
     SoundVolume=192
     CollisionRadius=84.000000
     CollisionHeight=102.199997
     bRotateToDesired=True
     Mass=5000.000000
     Buoyancy=5.000000
     RotationRate=(Yaw=1024)
}
