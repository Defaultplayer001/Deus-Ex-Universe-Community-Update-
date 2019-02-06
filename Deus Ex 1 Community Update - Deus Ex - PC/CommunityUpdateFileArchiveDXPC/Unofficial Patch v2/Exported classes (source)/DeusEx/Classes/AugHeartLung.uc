//=============================================================================
// AugHeartLung.
//=============================================================================
class AugHeartLung extends Augmentation;

state Active
{
Begin:
	// make sure if the player turns on any other augs while
	// this one is on, it gets affected also.
Loop:
	Player.AugmentationSystem.BoostAugs(True, Self);
	Sleep(1.0);
	Goto('Loop');
}

function Deactivate()
{
	Super.Deactivate();

	Player.AugmentationSystem.BoostAugs(False, Self);
	Player.AugmentationSystem.DeactivateAll();
}

defaultproperties
{
     EnergyRate=100.000000
     MaxLevel=0
     Icon=Texture'DeusExUI.UserInterface.AugIconHeartLung'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconHeartLung_Small'
     AugmentationName="Synthetic Heart"
     Description="This synthetic heart circulates not only blood but a steady concentration of mechanochemical power cells, smart phagocytes, and liposomes containing prefab diamondoid machine parts, resulting in upgraded performance for all installed augmentations.|n|n<UNATCO OPS FILE NOTE JR133-VIOLET> However, this will not enhance any augmentation past its maximum upgrade level. -- Jaime Reyes <END NOTE>|n|nNO UPGRADES"
     LevelValues(0)=1.000000
     AugmentationLocation=LOC_Torso
}
