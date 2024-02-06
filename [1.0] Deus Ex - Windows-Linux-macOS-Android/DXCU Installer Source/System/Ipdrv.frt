[Public]
Object=(Name=IpDrv.UpdateServerCommandlet,Class=Class,MetaClass=Core.Commandlet)
Object=(Name=IpDrv.MasterServerCommandlet,Class=Class,MetaClass=Core.Commandlet)
Object=(Name=IpDrv.TcpNetDriver,Class=Class,MetaClass=Engine.NetDriver)
Object=(Name=IpDrv.UdpBeacon,Class=Class,MetaClass=Engine.Actor)
Preferences=(Caption="R�seau",Parent="Options avanc�es")
Preferences=(Caption="R�seau TCP/IP",Parent="R�seau",Class=IpDrv.TcpNetDriver)
Preferences=(Caption="Serveur d�di�",Parent="R�seau",Class=IpDrv.UdpBeacon,Immediate=True)

[UpdateServerCommandlet]
HelpCmd=updateserver
HelpOneLiner=Service Unreal Engine auto update request
HelpUsage=updateserver [-option...] [parm=value]
HelpParm[0]=ConfigFile
HelpDesc[0]=Configuration file to use.  Default: UpdateServer.ini

[MasterServerCommandlet]
HelpCmd=masterserver
HelpOneLiner=Maintain master list of servers.
HelpUsage=masterserver [-option...] [parm=value]
HelpParm[0]=ConfigFile
HelpDesc[0]=Configuration file to use.  Default: MasterServer.ini

[TcpNetDriver]
ClassCaption="R�seau TCP/IP"

[UdpBeacon]
ClassCaption="Serveur LAN d�di�"
