[Public]
Object=(Name=IpDrv.UpdateServerCommandlet,Class=Class,MetaClass=Core.Commandlet)
Object=(Name=IpDrv.MasterServerCommandlet,Class=Class,MetaClass=Core.Commandlet)
Object=(Name=IpDrv.TcpNetDriver,Class=Class,MetaClass=Engine.NetDriver)
Object=(Name=IpDrv.UdpBeacon,Class=Class,MetaClass=Engine.Actor)
Preferences=(Caption="Réseau",Parent="Options avancées")
Preferences=(Caption="Réseau TCP/IP",Parent="Réseau",Class=IpDrv.TcpNetDriver)
Preferences=(Caption="Serveur dédié",Parent="Réseau",Class=IpDrv.UdpBeacon,Immediate=True)

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
ClassCaption="Réseau TCP/IP"

[UdpBeacon]
ClassCaption="Serveur LAN dédié"

