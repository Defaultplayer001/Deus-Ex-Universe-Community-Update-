[Language]
Language=Francais
LangId=12
SubLangId=0

[Public]
Object=(Name=Core.HelloWorldCommandlet,Class=Class,MetaClass=Core.Commandlet)
Preferences=(Caption="Avanc�es",Parent="Options avanc�es")
Preferences=(Caption="Syst�me de fichiers",Parent="Avanc�es",Class=Core.System,Immediate=True)

[Errors]
Unknown=Erreur inconnue
Aborted=Annul�
ExportOpen=Erreur � l'export de %s : ne peut ouvrir le fichier '%s'
ExportWrite=Erreur � l'export de %s : ne peut �crire le fichier '%s'
FileNotFound=Ne peut trouver le fichier '%s'
ObjectNotFound=Ne peut trouver l'objet '%s %s.%s'
PackageNotFound=Ne peut trouver le fichier pour package '%s'
PackageResolveFailed=Ne peut r�soudre le nom de package
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
TransientImport=Objet transient import� : %s
FailedSavePrivate=Impossible de sauver %s : le graphe est li� est li� � un objet externe priv� %s
FailedImportPrivate=Ne peut importer l'objet priv� %s %s
FailedCreate=%s %s non trouv� pour cr�ation
FailedImport=Ne peut trouver %s dans le fichier '%s'
FailedSaveFile=Erreur de sauvegarde du fichier '%s': %s
SaveWarning=Erreur de sauvegarde de '%s'
NotPackaged=L'objet n'est pas en package : %s %s
NotWithin=Objet %s %s cr�� en %s au lieu de %s
Abstract=Ne peut cr�er objet %s : classe %s abstraite
NoReplace=Ne peut remplacer %s par %s
NoFindImport=Ne peut trouver fichier '%s' pour import
ReadFileFailed=Ne peut lire fichier '%s' pour import
SeekFailed=Erreur de recherche de fichier
OpenFailed=Erreur d'ouverture de fichier
WriteFailed=Erreur d'�criture de fichier
ReadEof=Lecture au del� de la fin du fichier
IniReadOnly=Le fichier %s est prot�g� en �criture ; les r�glages ne peuvent �tre sauv�s
UrlFailed=Erreur de lancement d'URL
Warning=Avertissement
Question=Question
OutOfMemory=A cours de m�moire virtuelle. pour �viter ce type de probl�me, lib�rez de la place sur le disque dur primaire.
History=Historique
Assert=Erreur d'assertion : %s [File:%s] [Line: %i]
Debug=Erreur d'assertion en debug : %s [File:%s] [Line: %i]
LinkerExists=Liant pour '%s' existe d�j�
BinaryFormat=Le fichier '%s' contient des donn�es non identifiables
SerialSize=%s: Erreur de taille s�rie : fait %i, devrait faire %i
ExportIndex=Erreur d'index d'export %i/%i
ImportIndex=Erreur d'index d'import %i/%i
Password=Mot de passe inconnu
Exec=Commande inconnue
BadProperty='%s': propri�t� fausse ou manquante '%s'
MisingIni=Fichier Missing .ini : %s

[Query]
OldVersion=Le fichier %s a �t� sauvegard� sous une version ant�rieure qui n'est pas forc�ment compatible avec l'actuelle. Sa lecture �chouera probablement, et peut causer un blocage. Voulez-vous l'essayer quand m�me ? 
Name=Nom:
Password=Mot de passe :
PassPrompt=Nom et Mot de passe :
PassDlg=V�rification d'identit�
Overwrite=Le fichier '%s' doit �tre mis � jour. Voulez-vous �craser la version actuelle ?

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
