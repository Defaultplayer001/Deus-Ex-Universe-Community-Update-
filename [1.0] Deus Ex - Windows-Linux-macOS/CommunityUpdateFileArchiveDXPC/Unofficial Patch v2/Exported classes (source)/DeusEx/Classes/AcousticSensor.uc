//=============================================================================
// AcousticSensor.
//=============================================================================
class AcousticSensor extends HackableDevices;

function HackAction(Actor Hacker, bool bHacked)
{
	local Actor A;

	Super.HackAction(Hacker, bHacked);

	if (bHacked)
		AIClearEventCallback('WeaponFire');
}

function NoiseHeard(Name eventName, EAIEventState state, XAIParams params)
{
	local Actor A;

	if (Event != '')
		foreach AllActors(class 'Actor', A, Event)
			A.Trigger(Self, GetPlayerPawn());
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	AISetEventCallback('WeaponFire', 'NoiseHeard');
}

defaultproperties
{
     ItemName="Gunfire Acoustic Sensor"
     Mesh=LodMesh'DeusExDeco.AcousticSensor'
     CollisionRadius=24.400000
     CollisionHeight=23.059999
     Mass=10.000000
     Buoyancy=5.000000
}
