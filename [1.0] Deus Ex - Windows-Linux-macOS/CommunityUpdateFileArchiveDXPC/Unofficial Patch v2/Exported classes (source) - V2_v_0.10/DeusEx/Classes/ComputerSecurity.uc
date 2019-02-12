//=============================================================================
// ComputerSecurity.
//=============================================================================
class ComputerSecurity extends Computers;

struct sViewInfo
{
	var() localized string	titleString;
	var() name				cameraTag;
	var() name				turretTag;
	var() name				doorTag;
};

var() localized sViewInfo Views[3];
var int team;

// ----------------------------------------------------------------------------
// network replication
// ----------------------------------------------------------------------------
replication
{
   //server to client
   reliable if (Role == ROLE_Authority)
      Views, team;
}

// -----------------------------------------------------------------------
// SetControlledObjectOwners
// Used to enhance network replication.
// -----------------------------------------------------------------------

function SetControlledObjectOwners(DeusExPlayer PlayerWhoOwns)
{
	local int cameraIndex;
	local name tag;
	local SecurityCamera camera;
   local AutoTurret turret;
   local DeusExMover door;

	for (cameraIndex=0; cameraIndex<ArrayCount(Views); cameraIndex++)
	{
		tag = Views[cameraIndex].cameraTag;
		if (tag != '')
			foreach AllActors(class'SecurityCamera', camera, tag)
				camera.SetOwner(PlayerWhoOwns);

		tag = Views[cameraIndex].turretTag;
		if (tag != '')
			foreach AllActors(class'AutoTurret', turret, tag)
            turret.SetOwner(PlayerWhoOwns);
				
		tag = Views[cameraIndex].doorTag;
		if (tag != '')
			foreach AllActors(class'DeusExMover', door, tag)
				door.SetOwner(PlayerWhoOwns);

	}

}

// ----------------------------------------------------------------------
// AdditionalActivation()
// Called for subclasses to do any additional activation steps.
// ----------------------------------------------------------------------

function AdditionalActivation(DeusExPlayer ActivatingPlayer)
{
   if (Level.NetMode != NM_Standalone)
      SetControlledObjectOwners(ActivatingPlayer);
   
   Super.AdditionalDeactivation(ActivatingPlayer);
}

// ----------------------------------------------------------------------
// AdditionalDeactivation()
// ----------------------------------------------------------------------

function AdditionalDeactivation(DeusExPlayer DeactivatingPlayer)
{
   if (Level.NetMode != NM_Standalone)
      SetControlledObjectOwners(None);
   
   Super.AdditionalDeactivation(DeactivatingPlayer);
}

defaultproperties
{
     Team=-1
     terminalType=Class'DeusEx.NetworkTerminalSecurity'
     lockoutDelay=120.000000
     UserList(0)=(userName="SECURITY",Password="SECURITY")
     ItemName="Security Computer Terminal"
     Physics=PHYS_None
     Mesh=LodMesh'DeusExDeco.ComputerSecurity'
     SoundRadius=8
     SoundVolume=255
     SoundPitch=96
     AmbientSound=Sound'DeusExSounds.Generic.SecurityL'
     CollisionRadius=11.590000
     CollisionHeight=10.100000
     bCollideWorld=False
     BindName="ComputerSecurity"
}
