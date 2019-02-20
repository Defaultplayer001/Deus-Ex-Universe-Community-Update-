//=============================================================================
// ControlPanel.
//=============================================================================
class ControlPanel extends HackableDevices;

function StopHacking()
{
	Super.StopHacking();

	if (hackStrength == 0.0)
		PlayAnim('Open');
}

function HackAction(Actor Hacker, bool bHacked)
{
	local Actor A;

	Super.HackAction(Hacker, bHacked);

	if (bHacked)
	{
		if (Event != '')
			foreach AllActors(class 'Actor', A, Event)
				A.Trigger(Self, Pawn(Hacker));
	}
}

defaultproperties
{
     ItemName="Electronic Control Panel"
     Mesh=LodMesh'DeusExDeco.ControlPanel'
     SoundRadius=8
     SoundVolume=255
     SoundPitch=96
     AmbientSound=Sound'DeusExSounds.Generic.ElectronicsHum'
     CollisionRadius=14.500000
     CollisionHeight=23.230000
     Mass=10.000000
     Buoyancy=5.000000
}
