[Public]
Object=(Name=OpenGLDrv.OpenGLRenderDevice,Class=Class,MetaClass=Engine.RenderDevice,Autodetect=)
Preferences=(Caption="Rendu",Parent="Options avancées")
Preferences=(Caption="compatibilité OpenGL",Parent="Rendu",Class=OpenGLDrv.OpenGLRenderDevice,Immediate=True)

[OpenGLRenderDevice]
ClassCaption="Compatibilité OpenGL"
AskInstalled=Possédez-vous une carte 3D compatible OpenGL ?
AskUse=Voulez-vous que Deus Ex utilise votre carte 3D en OpenGL ?

[Errors]
NoFindGL=pilote OpenGL  %s introuvable
MissingFunc=Fonction OpenGL %s (%i) introuvable
ResFailed=Echec de la résolution
