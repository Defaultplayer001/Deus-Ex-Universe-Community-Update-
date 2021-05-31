//=============================================================================
// MoverCollider.
//=============================================================================
class MoverCollider expands Keypoint;

// lets us attach this keypoint to a mover
var() name moverTag;

// attach us to the mover that we are tagged to
function BeginPlay()
{
	local Mover M;

	Super.BeginPlay();

	if (moverTag != '')
		foreach AllActors(class'Mover', M, moverTag)
		{
			SetBase(M);
			SetPhysics(PHYS_None);
		}
}

defaultproperties
{
     bStatic=False
     bCollideActors=True
}
