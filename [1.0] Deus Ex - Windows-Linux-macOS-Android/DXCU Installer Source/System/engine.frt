[Public]
;Object=(Name=Engine.Console,Class=Class,MetaClass=Engine.Console)
Object=(Name=Engine.ServerCommandlet,Class=Class,MetaClass=Core.Commandlet)
Preferences=(Caption="Avanc�es",Parent="Options avanc�es")
Preferences=(Caption="R�glages moteur",Parent="Avanc�es",Class=Engine.GameEngine,Category=Settings,Immediate=True)
Preferences=(Caption="Alias touches",Parent="Avanc�es",Class=Engine.Input,Immediate=True,Category=Aliases)
Preferences=(Caption="Touches d�faut",Parent="Avanc�es",Class=Engine.Input,Immediate=True,Category=RawKeys)
Preferences=(Caption="Pilotes",Parent="Options avanc�es",Class=Engine.Engine,Immediate=False,Category=Drivers)
Preferences=(Caption="Infos serveur public",Parent="R�seau",Class=Engine.GameReplicationInfo,Immediate=True)
Preferences=(Caption="R�glages jeu",Parent="Options avanc�es",Class=Engine.GameInfo,Immediate=True)

[Errors]
NetOpen=Erreur ouverture de fichier
NetWrite=Erreur �criture de fichier
NetRefused=Serveur refuse d'envoyer '%s'
NetClose=Erreur fermeture de fichier
NetSize=Taille fichier non conforme
NetMove=Erreur d�placement fichier
NetInvalid=Requ�te incorrecte re�ue
NoDownload=Package '%s' non chargeable
DownloadFailed=Echec chargement package '%s': %s
RequestDenied=Demande serveur sur fichier en attente: refus
ConnectionFailed=Echec connexion
ChAllocate=Echec allocation canal
NetAlready=D�j� sur r�seau
NetListen=Echec �coute: aucun linker de contexte disponible
LoadEntry=Ne peut charger entr�e: %s
InvalidUrl=URL incorrecte: %s
InvalidLink=Lien incorrect: %s
FailedBrowse=Impossible d'entrer %s: %s
Listen=Echec �coute: %s
AbortToEntry=Echec; retour � l'entr�e
ServerOpen=Echec serveurs ouverture URLs r�seau
ServerListen=Serveur d�di� ne peut �couter: %s
Pending=Echec connexion � '%s' en attente; %s
LoadPlayerClass=Echec chargement classe joueur
ServerOutdated=Version serveur p�rim�e

[Progress]
CancelledConnect=Tentative connexion annul�e
RunningNet=%s: %s (%i joueurs)
NetReceiving=R�ception '%s': %i/%i
NetReceiveOk=R�ception achev�e '%s'
NetSend=Envoi '%s'
NetSending=Envoi '%s': %i/%i
Connecting=Connexion...
Listening=Recherche de clients...
Loading=Chargement
Saving=Sauvegarde
Paused=Pause par %s
ReceiveFile=R�ception '%s' (F10 annule)
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
Upgrade=Pour rejoindre ce serveur, vous avez besoin de la derni�re mise � jour de Deus Ex, disponible sur le site d'Ion Storm:
UpgradeURL=http://www.deusex.com/upgrade
UpgradeQuestion=Voulez-vous ouvrir votre navigateur Internet � la page des mises � jour?
Version=Version %i

[Menu]
HelpMessage=
MenuList=
LeftString=Gauche
RightString=Droite
CenterString=Centre
EnabledString=Activ�
DisabledString=D�sactiv�
HelpMessage[1]="Ce menu n'est pas encore int�gr�."
YesString=oui
NoString=non

[Inventory]
PickupMessage=Objet accroch�
M_Activated=" activ�"
M_Selected=" s�lectionn�"
M_Deactivated=" d�sactiv�"
ItemArticle=un(e)

[WarpZoneInfo]
OtherSideURL=

[GameInfo]
SwitchLevelMessage=Changement de niveau
DefaultPlayerName=Joueur
LeftMessage=" a quitt� le jeu."
FailedSpawnMessage=Echec de mat�rialisation du personnage
FailedPlaceMessage=Emplacement de d�part introuvable (Niveau n�cessite emplacement 'PlayerStart')
NameChangedMessage=Nom chang� en  
EnteredMessage=" a rejoint la partie."
GameName="Jeu"
MaxedOutMessage=Le serveur a d�j� atteint sa capacit�.
WrongPassword=Ce mot de passe est incorrect.
NeedPassword=Vous devez taper un mot de passe pour rejoindre cette partie.
FailedTeamMessage=Pas d'�quipe pour le joueur

[LevelInfo]
Title=Sans titre

[Weapon]
MessageNoAmmo=" plus de munitions."
PickupMessage=Vous trouvez une arme
DeathMessage=%o s'est fait tuer par %k's %w.
ItemName=Arme
DeathMessage[0]=%o a �t� neutralis� par %k's %w.
DeathMessage[1]=%o s'est fait extraire par %k's %w.
DeathMessage[2]=%o s'est fait retirer par %k's %w.
DeathMessage[3]=%o s'est fait supprimer par %k's %w.

[Counter]
CountMessage=Plus que %i...
CompleteMessage=Termin� !

[Ammo]
PickupMessage=Vous trouvez des munitions.

[Pickup]
ExpireMessage=

[SpecialEvent]
DamageString=

[DamageType]
Name=Supprim�
AltName=Supprim�

[PlayerPawn]
QuickSaveString=Sauvegarde rapide
NoPauseMessage=Pause indisponible
ViewingFrom=Vue depuis  
OwnCamera=Propre cam�ra
FailedView=Echec du changement de vue.
CantChangeNameMsg=Impossible de changer de nom en cours de partie.

[Pawn]
NameArticle=" un(e) "

[Spectator]
MenuName=Spectateur

[ServerCommandlet]
HelpCmd=serveur
HelpOneLiner=Serveur de jeu r�seau
HelpUsage=server map.unr[?game=gametype] [-option...] [parm=value]...
HelpWebLink=http://www.deusex.com
HelpParm[0]=Log
HelpDesc[0]=Sp�cifier le fichier log � g�n�rer
HelpParm[1]=TousAdmin
HelpDesc[1]=Donne � tous les joueurs les droits d'admin
