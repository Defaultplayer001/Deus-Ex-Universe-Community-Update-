//=============================================================================
// RocketLAW.
//=============================================================================
class RocketLAW extends Rocket;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if (( Level.NetMode != NM_Standalone ) && (Class == Class'RocketLAW'))
	{
		SoundRadius = 64;
	}
}

defaultproperties
{
     blastRadius=768.000000
     ItemName="LAW Rocket"
     Damage=1000.000000
     MomentumTransfer=40000
     SpawnSound=Sound'DeusExSounds.Robot.RobotFireRocket'
     Mesh=LodMesh'DeusExItems.RocketLAW'
     DrawScale=1.000000
     AmbientSound=Sound'DeusExSounds.Weapons.LAWApproach'
}
