ConEditExport is a command-line utility (needs Java 1.8 or higher) for exporting and importing text data from DeusEx Conversation files in several various ways unavailable with regular ConEdit.

This is an utility that I primarily wrote for myself as a more detailed version of ConEdit's export-into-text feature, but it eventually grew some more functions.

What it does:

Exports into text (obviously), including all logic fields and operators (check flags, add items, camera movements, etc.) that ConEdit's export omits.
Processes several files or the whole folder contents as a batch.
Allows combined output of two versions of the same conversation file, eg. original and translated.
Exports full conversation data into XML format.
Compiles functional CON files from exported XML data.
For the full list of options, use "java -jar ConEditExport.jar -h" command.