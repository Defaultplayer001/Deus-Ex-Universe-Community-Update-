[Public]
Object=(Name=OpenGLDrv.OpenGLRenderDevice,Class=Class,MetaClass=Engine.RenderDevice,Autodetect=)
Preferences=(Caption="Rendu",Parent="Options avanc�es")
Preferences=(Caption="Compatibilit� OpenGL",Parent="Rendu",Class=OpenGLDrv.OpenGLRenderDevice,Immediate=True)

[OpenGLRenderDevice]
ClassCaption="Compatibilit� OpenGL"
AskInstalled=Poss�dez-vous une carte 3D compatible OpenGL ?
AskUse=Voulez-vous que Deus Ex utilise votre carte 3D en OpenGL ?

[Errors]
NoFindGL=Pilote OpenGL %s introuvable
MissingFunc=Fonction OpenGL %s (%i) introuvable
ResFailed=Echec de la r�solution
