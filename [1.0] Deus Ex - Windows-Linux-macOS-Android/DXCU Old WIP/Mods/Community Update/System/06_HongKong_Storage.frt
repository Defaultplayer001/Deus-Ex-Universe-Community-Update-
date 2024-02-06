[ComputerSecurity1]
Views[0]="(titleString="Nacelles magn�tiques (4)",cameraTag=podcam,doorTag=OpenThePODs)"
Views[1]="(titleString="Unit� de d�sactivation",cameraTag=PlatformCam,doorTag=PlatformTriggers)"
Views[2]="(titleString="Isolation des toxines",cameraTag=ToxicCamera)"
specialOptions[0]="(Text="Ouvrir les nacelles d'isolation nanotech.",TriggerText="Nacelles magn�tiques ouvertes",TriggerEvent=OpenThePODs,bTriggerOnceOnly=True)"
specialOptions[1]="(Text="Elever la console de d�sactivation",TriggerText="Console �lev�e",TriggerEvent=control_platform)"

[ComputerSecurity0]
Views[0]="(titleString="Point de s�curit� n�1",cameraTag=Level1Cam,doorTag=FloodDoor08)"
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
awardMessage="Bonus : r�ussite"

[DeusExLevelInfo0]
MissionLocation="Hong Kong - Nanoproduction"
startupMessage[0]=" Niveau 2 :"
startupMessage[1]="Complexe d'isolation nanotechnique"
startupMessage[2]="Sous le b�timent de VersaLife"

[SkillAwardTrigger3]
awardMessage="Bonus : exploration"

[NanoKey0]
PickupMessage="Vous avez trouv� la cl� de la porte d'isolation."
Description="Porte d'isolation nanotechnique"

[ComputerPersonal0]
specialOptions[0]="(Text="Charger le sch�ma du virus",TriggerText="Sch�ma du virus charg�",TriggerEvent=VirusUploaded,bTriggerOnceOnly=True)"
specialOptions[1]="(Text="Ouvrir la salle du C.U.",TriggerText="Porte de la salle du C.U. ouverte",TriggerEvent=UC_Chamber_Door)"
