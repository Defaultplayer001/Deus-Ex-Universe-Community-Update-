//=============================================================================
// RetinalScanner.
//=============================================================================
class RetinalScanner extends HackableDevices;

var() localized String msgUsed;

function HackAction(Actor Hacker, bool bHacked)
{
	local Actor A;

	Super.HackAction(Hacker, bHacked);

	if (bHacked)
		if (Event != '')
		{
			if (Pawn(Hacker) != None)
				Pawn(Hacker).ClientMessage(msgUsed);

			foreach AllActors(class 'Actor', A, Event)
				A.Trigger(Self, Pawn(Hacker));
		}
}

defaultproperties
{
     msgUsed="Clearance granted"
     ItemName="Retinal Scanner"
     Mesh=LodMesh'DeusExDeco.RetinalScanner'
     SoundRadius=8
     SoundVolume=255
     SoundPitch=96
     AmbientSound=Sound'DeusExSounds.Generic.SecurityL'
     CollisionRadius=10.000000
     CollisionHeight=11.430000
     Mass=30.000000
     Buoyancy=40.000000
}
