//=============================================================================
// BarrelFire.
//=============================================================================
class BarrelFire extends Containers;

var float lastDamageTime;

function DamageOther(Actor Other)
{
	if ((Other != None) && !Other.IsA('ScriptedPawn'))
	{
		// only take damage every second
		if (Level.TimeSeconds - lastDamageTime >= 1.0)
		{
			Other.TakeDamage(5, None, Location, vect(0,0,0), 'Burned');
			lastDamageTime = Level.TimeSeconds;
		}
	}
}

singular function SupportActor(Actor Other)
{
	DamageOther(Other);
	Super.SupportActor(Other);
}

singular function Bump(Actor Other)
{
	DamageOther(Other);
	Super.Bump(Other);
}

defaultproperties
{
     HitPoints=40
     bInvincible=True
     bFlammable=False
     ItemName="Burning Barrel"
     bBlockSight=True
     Mesh=LodMesh'DeusExDeco.BarrelFire'
     ScaleGlow=2.000000
     bUnlit=True
     SoundRadius=16
     SoundVolume=255
     AmbientSound=Sound'Ambient.Ambient.FireSmall2'
     CollisionRadius=20.000000
     CollisionHeight=29.000000
     LightType=LT_Steady
     LightEffect=LE_FireWaver
     LightBrightness=128
     LightHue=32
     LightSaturation=64
     LightRadius=6
     Mass=260.000000
     Buoyancy=270.000000
}
