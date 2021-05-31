//=============================================================================
// AugDrone.
//=============================================================================
class AugDrone extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

var float reconstructTime;
var float lastDroneTime;

state Active
{
Begin:
	if (Level.TimeSeconds - lastDroneTime < reconstructTime)
	{
		Player.ClientMessage("Reconstruction will be complete in" @ Int(reconstructTime - (Level.TimeSeconds - lastDroneTime)) @ "seconds");
		Deactivate();
	}
	else
	{
		Player.bSpyDroneActive = True;
		Player.spyDroneLevel = CurrentLevel;
		Player.spyDroneLevelValue = LevelValues[CurrentLevel];
	}
}

function Deactivate()
{
	Super.Deactivate();

	// record the time if we were just active
	if (Player.bSpyDroneActive)
		lastDroneTime = Level.TimeSeconds;

	Player.bSpyDroneActive = False;
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
	}
}

defaultproperties
{
     mpAugValue=100.000000
     mpEnergyDrain=20.000000
     reconstructTime=30.000000
     lastDroneTime=-30.000000
     EnergyRate=150.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconDrone'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconDrone_Small'
     AugmentationName="Spy Drone"
     Description="Advanced nanofactories can assemble a spy drone upon demand which can then be remotely controlled by the agent until released or destroyed, at which a point a new drone will be assembled. Further upgrades equip the spy drones with better armor and a one-shot EMP attack.|n|nTECH ONE: The drone can take little damage and has a very light EMP attack.|n|nTECH TWO: The drone can take minor damage and has a light EMP attack.|n|nTECH THREE: The drone can take moderate damage and has a medium EMP attack.|n|nTECH FOUR: The drone can take heavy damage and has a strong EMP attack."
     MPInfo="Activation creates a remote-controlled spy drone.  Deactivation disables the drone.  Firing while active detonates the drone in a massive EMP explosion.  Energy Drain: Medium"
     LevelValues(0)=10.000000
     LevelValues(1)=20.000000
     LevelValues(2)=35.000000
     LevelValues(3)=50.000000
     MPConflictSlot=7
}
