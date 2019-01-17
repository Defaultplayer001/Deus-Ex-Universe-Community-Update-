Confix is a mod targeting to fix and optionally expand conversations in Deus Ex. Such fixes include things as big as broken logic preventing access to dialogue and gameplay to the more benign typo fixes. 
Expansions include features that are hinted-at in the lore - for instance, if Louis Pan stole something money from the newsstand, why isn't it added to his inventory and you aren't able to steal it from him when you kill him? 
It may seem very specific, but the intent here is to make the conversations more whole.

If you wish to expand on Confix, you should know that it was made using ConEdit, the conversation editing tool for Deus Ex (uploaded here as well). 
The language it uses resembles assembler - After a line will play it will immediately load the next line, ad infinitum or until reaching an end event.
It can check and do simple ALU functions on a very specific number of variables. The most common tools are flag sets (setting a variable), flag checks (branch), and jumps.
The naming convention of the audio files is very strict, and generally ignores the filenames stated explicitly by ConEdit - rather it's always ActorName_LineNumber.
The pathing is strict as well, but can be figured out by auto-generating the filenames. Compiling the files after they're all in order is done through UCC, and for more knowledge about that you should consult the Deus Ex SDK.

-shortened/edited by Defaultplayer001 from Dalvik/maiden_china's original Confix post : http://www.moddb.com/mods/confix/news/what-is-confix
