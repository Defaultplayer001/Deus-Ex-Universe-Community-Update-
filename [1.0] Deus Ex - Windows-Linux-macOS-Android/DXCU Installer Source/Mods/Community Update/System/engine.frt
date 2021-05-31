[Public]
;Object=(Name=Engine.Console,Class=Class,MetaClass=Engine.Console)
Object=(Name=Engine.ServerCommandlet,Class=Class,MetaClass=Core.Commandlet)
Preferences=(Caption="Avancées",Parent="Options avancées")
Preferences=(Caption="Réglages moteur",Parent="Avancées",Class=Engine.GameEngine,Category=Settings,Immediate=True)
Preferences=(Caption="Alias touches",Parent="Avancées",Class=Engine.Input,Immediate=True,Category=Aliases)
Preferences=(Caption="Touches défaut",Parent="Avancées",Class=Engine.Input,Immediate=True,Category=RawKeys)
Preferences=(Caption="Pilotes",Parent="Options avancées",Class=Engine.Engine,Immediate=False,Category=Drivers)
Preferences=(Caption="Infos serveur public",Parent="Réseau",Class=Engine.GameReplicationInfo,Immediate=True)
Preferences=(Caption="Réglages jeu",Parent="Options avancées",Class=Engine.GameInfo,Immediate=True)

[Errors]
NetOpen=Erreur ouverture de fichier
NetWrite=Erreur écriture de fichier
NetRefused=Serveur refuse d'envoyer '%s'
NetClose=Erreur fermeture de fichier
NetSize=Taille fichier non conforme
NetMove=Erreur déplacement fichier
NetInvalid=Requête incorrecte reçue
NoDownload=Package '%s' non chargeable
DownloadFailed=Echec chargement package '%s': %s
RequestDenied=Demande serveur sur fichier en attente: refus
ConnectionFailed=Echec connexion
ChAllocate=Echec allocation canal
NetAlready=Déjà sur réseau
NetListen=Echec écoute: aucun linker de contexte disponible
LoadEntry=Ne peut charger entrée: %s
InvalidUrl=URL incorrecte: %s
InvalidLink=Lien incorrect: %s
FailedBrowse=Impossible d'entrer %s: %s
Listen=Echec écoute: %s
AbortToEntry=Echec; retour à l'entrée
ServerOpen=Echec serveurs ouverture URLs réseau
ServerListen=Serveur dédié ne peut écouter: %s
Pending=Echec connexion à '%s' en attente; %s
LoadPlayerClass=Echec chargement classe joueur
ServerOutdated=Version serveur périmée

[Progress]
CancelledConnect=Tentative connexion annulée
RunningNet=%s: %s (%i joueurs)
NetReceiving=Réception '%s': %i/%i
NetReceiveOk=Réception achevée '%s'
NetSend=Envoi '%s'
NetSending=Envoi '%s': %i/%i
Connecting=Connexion...
Listening=Recherche de clients...
Loading=Chargement
Saving=Sauvegarde
Paused=Pause par %s
ReceiveFile=Réception '%s' (F10 annule)
ReceiveSize=Taille %iK, Total %3.1f%%
ConnectingText=Connexion (F10 annule) :
ConnectingURL=deusex://%s/%s

[Console]
ClassCaption=Console Deus Ex standard
LoadingMessage=CHARGEMENT
SavingMessage=SAUVEGARDE
ConnectingMessage=CONNEXION
PausedMessage=PAUSE
PrecachingMessage=MISE EN PRECACHE
ChatChannel=(BLABLA) 
TeamChannel=(EQUIPE) 

[General]
Upgrade=Pour rejoindre ce serveur, vous avez besoin de la dernière mise à jour de Deus Ex, disponible sur le site d'Ion Storm:
UpgradeURL=http://www.deusex.com/upgrade
UpgradeQuestion=Voulez-vous ouvrir votre navigateur Internet à la page des mises à jour?
Version=Version %i

[Menu]
HelpMessage=
MenuList=
LeftString=Gauche
RightString=Droite
CenterString=Centre
EnabledString=Activé
DisabledString=Désactivé
HelpMessage[1]="Ce menu n'est pas encore intégré."
YesString=oui
NoString=non

[Inventory]
PickupMessage=Objet accroché
M_Activated=" activé"
M_Selected=" sélectionné"
M_Deactivated=" désactivé"
ItemArticle=un(e)

[WarpZoneInfo]
OtherSideURL=

[GameInfo]
SwitchLevelMessage=Changement de niveau
DefaultPlayerName=Joueur
LeftMessage=" a quitté le jeu."
FailedSpawnMessage=Echec de matérialisation du personnage
FailedPlaceMessage=Emplacement de départ introuvable (Niveau nécessite emplacement 'PlayerStart')
NameChangedMessage=Nom changé en  
EnteredMessage=" a rejoint la partie."
GameName="Jeu"
MaxedOutMessage=Le serveur a déjà atteint sa capacité.
WrongPassword=Ce mot de passe est incorrect.
NeedPassword=Vous devez taper un mot de passe pour rejoindre cette partie.
FailedTeamMessage=Pas d'équipe pour le joueur

[LevelInfo]
Title=Sans titre

[Weapon]
MessageNoAmmo=" plus de munitions."
PickupMessage=Vous trouvez une arme
DeathMessage=%o s'est fait tuer par %k's %w.
ItemName=Arme
DeathMessage[0]=%o a été neutralisé par %k's %w.
DeathMessage[1]=%o s'est fait extraire par %k's %w.
DeathMessage[2]=%o s'est fait retirer par %k's %w.
DeathMessage[3]=%o s'est fait supprimer par %k's %w.

[Counter]
CountMessage=Plus que %i...
CompleteMessage=Terminé !

[Ammo]
PickupMessage=Vous trouvez des munitions.

[Pickup]
ExpireMessage=

[SpecialEvent]
DamageString=

[DamageType]
Name=Supprimé
AltName=Supprimé

[PlayerPawn]
QuickSaveString=Sauvegarde rapide
NoPauseMessage=Pause indisponible
ViewingFrom=Vue depuis  
OwnCamera=Propre caméra
FailedView=Echec du changement de vue.
CantChangeNameMsg=Impossible de changer de nom en cours de partie.

[Pawn]
NameArticle=" un(e) "

[Spectator]
MenuName=Spectateur

[ServerCommandlet]
HelpCmd=serveur
HelpOneLiner=Serveur de jeu réseau
HelpUsage=server map.unr[?game=gametype] [-option...] [parm=value]...
HelpWebLink=http://www.deusex.com
HelpParm[0]=Log
HelpDesc[0]=Spécifier le fichier log à générer
HelpParm[1]=TousAdmin
HelpDesc[1]=Donne à tous les joueurs les droits d'admin
