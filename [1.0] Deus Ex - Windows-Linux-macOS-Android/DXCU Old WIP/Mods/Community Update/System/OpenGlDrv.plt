[Public]
Object=(Name=OpenGLDrv.OpenGLRenderDevice,Class=Class,MetaClass=Engine.RenderDevice,Autodetect=)
Preferences=(Caption="Renderowanie",Parent="Opcje zaawansowane")
Preferences=(Caption="Obsługa OpenGL",Parent="Renderowanie",Class=OpenGLDrv.OpenGLRenderDevice,Immediate=True)

[OpenGLRenderDevice]
ClassCaption="OpenGL"
AskInstalled=Czy posiadasz kartę grafiki zgodną z OpenGL?
AskUse=Czy chcesz, aby Deus Ex używał karty zgodnej z OpenGL?

[Errors]
NoFindGL=Brak sterownika OpenGL %s
MissingFunc=Brak funkcji OpenGL %s (%i)
ResFailed=Nie udało się ustawić rozdzielczości
