[Language]
Language=Francais
LangId=12
SubLangId=0

[Public]
Object=(Name=Core.HelloWorldCommandlet,Class=Class,MetaClass=Core.Commandlet)
Preferences=(Caption="Avancées",Parent="Options avancées")
Preferences=(Caption="Système de fichiers",Parent="Avancées",Class=Core.System,Immediate=True)

[Errors]
Unknown=Erreur inconnue
Aborted=Annulé
ExportOpen=Erreur à l'export de %s : ne peut ouvrir le fichier '%s'
ExportWrite=Erreur à l'export de %s : ne peut écrire le fichier '%s'
FileNotFound=Ne peut trouver le fichier '%s'
ObjectNotFound=Ne peut trouver l'objet '%s %s.%s'
PackageNotFound=Ne peut trouver le fichier pour package '%s'
PackageResolveFailed=Ne peut résoudre le nom de package
FilenameToPackage=Ne peut convertir le nom de fichier '%s' en nom de package
Sandbox=Paquet '%s' inaccessible dans ce sandbox
PackageVersion=Erreur de version du package '%s'
FailedLoad=Echec au chargement de '%s': %s
ConfigNotFound=Ne peut trouver '%s' dans le fichier de configuration
LoadClassMismatch=%s n'est pas une sous-classe de %s.%s
NotDll='%s' n'est pas un paquet DLL ; impossible de trouver l'export '%s'
NotInDll=Impossible de trouver '%s' dans '%s.dll'
FailedLoadPackage=Echec de chargement du package: %s
FailedLoadObject=Echec de chargement de '%s %s.%s': %s
TransientImport=Objet transient importé : %s
FailedSavePrivate=Impossible de sauver %s : le graphe est lié est lié à un objet externe privé %s
FailedImportPrivate=Ne peut importer l'objet privé %s %s
FailedCreate=%s %s non trouvé pour création
FailedImport=Ne peut trouver %s dans le fichier '%s'
FailedSaveFile=Erreur de sauvegarde du fichier '%s': %s
SaveWarning=Erreur de sauvegarde de '%s'
NotPackaged=L'objet n'est pas en package : %s %s
NotWithin=Objet %s %s créé en %s au lieu de %s
Abstract=Ne peut créer objet %s : classe %s abstraite
NoReplace=Ne peut remplacer %s par %s
NoFindImport=Ne peut trouver fichier '%s' pour import
ReadFileFailed=Ne peut lire fichier '%s' pour import
SeekFailed=Erreur de recherche de fichier
OpenFailed=Erreur d'ouverture de fichier
WriteFailed=Erreur d'écriture de fichier
ReadEof=Lecture au delà de la fin du fichier
IniReadOnly=Le fichier %s est protégé en écriture ; les réglages ne peuvent être sauvés
UrlFailed=Erreur de lancement d'URL
Warning=Avertissement
Question=Question
OutOfMemory=A cours de mémoire virtuelle. pour éviter ce type de problème, libérez de la place sur le disque dur primaire.
History=Historique
Assert=Erreur d'assertion : %s [File:%s] [Line: %i]
Debug=Erreur d'assertion en debug : %s [File:%s] [Line: %i]
LinkerExists=Liant pour '%s' existe déjà
BinaryFormat=Le fichier '%s' contient des données non identifiables
SerialSize=%s: Erreur de taille série : fait %i, devrait faire %i
ExportIndex=Erreur d'index d'export %i/%i
ImportIndex=Erreur d'index d'import %i/%i
Password=Mot de passe inconnu
Exec=Commande inconnue
BadProperty='%s': propriété fausse ou manquante '%s'
MisingIni=Fichier Missing .ini : %s

[Query]
OldVersion=Le fichier %s a été sauvegardé sous une version antérieure qui n'est pas forcément compatible avec l'actuelle. Sa lecture échouera probablement, et peut causer un blocage. Voulez-vous l'essayer quand même ? 
Name=Nom:
Password=Mot de passe :
PassPrompt=Nom et Mot de passe :
PassDlg=Vérification d'identité
Overwrite=Le fichier '%s' doit être mis à jour. Voulez-vous écraser la version actuelle ?

[Progress]
Saving=Sauvegarder le fichier %s...
Loading=Charger le fichier %s...
Closing=Fermeture

[General]
Product=Unreal
Engine=Unreal Engine
Copyright=Copyright 1999 Epic Games, Inc.
True=Vrai
False=Faux
None=Aucun
Yes=Oui
No=Non
