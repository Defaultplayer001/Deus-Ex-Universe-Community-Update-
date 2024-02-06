[ComputerSecurity1]
Views[0]="(titleString="Nacelles magnétiques (4)",cameraTag=podcam,doorTag=OpenThePODs)"
Views[1]="(titleString="Unité de désactivation",cameraTag=PlatformCam,doorTag=PlatformTriggers)"
Views[2]="(titleString="Isolation des toxines",cameraTag=ToxicCamera)"
specialOptions[0]="(Text="Ouvrir les nacelles d'isolation nanotech.",TriggerText="Nacelles magnétiques ouvertes",TriggerEvent=OpenThePODs,bTriggerOnceOnly=True)"
specialOptions[1]="(Text="Elever la console de désactivation",TriggerText="Console élevée",TriggerEvent=control_platform)"

[ComputerSecurity0]
Views[0]="(titleString="Point de sécurité n°1",cameraTag=Level1Cam,doorTag=FloodDoor08)"
Views[1]="(titleString="Moniteur AUC",cameraTag=Level2Cam)"
Views[2]="(titleString="Salle AUC",cameraTag=Level3Cam)"

[LevelSummary]
Title="Sans titre"

[SkillAwardTrigger6]
awardMessage="Bonus : identification indispensable"

[ScientistFemale0]
FamiliarName="Dr. Harrison"
UnfamiliarName="Chercheur en nanotechnologie"

[SkillAwardTrigger5]
awardMessage="Bonus : progression"

[SkillAwardTrigger4]
awardMessage="Bonus : réussite"

[DeusExLevelInfo0]
MissionLocation="Hong Kong - Nanoproduction"
startupMessage[0]=" Niveau 2 :"
startupMessage[1]="Complexe d'isolation nanotechnique"
startupMessage[2]="Sous le bÂtiment de VersaLife"

[SkillAwardTrigger3]
awardMessage="Bonus : exploration"

[NanoKey0]
PickupMessage="Vous avez trouvé la clé de la porte d'isolation."
Description="Porte d'isolation nanotechnique"

[ComputerPersonal0]
specialOptions[0]="(Text="Charger le schéma du virus",TriggerText="Schéma du virus chargé",TriggerEvent=VirusUploaded,bTriggerOnceOnly=True)"
specialOptions[1]="(Text="Ouvrir la salle du C.U.",TriggerText="Porte de la salle du C.U. ouverte",TriggerEvent=UC_Chamber_Door)"
