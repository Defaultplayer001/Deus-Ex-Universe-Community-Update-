*********************************************************************
Hex-editor XVI32 2.55
Copyright (c) 1998-2012 Christian Maas - All Rights Reserved
                        chmaas@handshake.de
                        http://www.chmaas.handshake.de
*********************************************************************
XVI32 is freeware. However, if you like XVI32, want to
appreciate my work, and/or support the development, I would be
pleased to receive a donation from you via PayPal. Go to:
http://www.chmaas.handshake.de/delphi/freeware/xvi32/xvi32donate.htm
*********************************************************************


CONTENTS
========
I.   Summary
II.  Requirements
III. Installation
IV.  Uninstall XVI32
V.   License agreement and Copyright


I. SUMMARY
==========

XVI32 is a free hex-editor with the following main features:

- portable application, i.e. no setup program is needed
- XVI32 doesn't write any data to registry
- Data inspector to view decoded numbers
- Built-in script interpreter - refer to online help for details
- Easily works with huge files. Try to open a 300 MB sized text
  file with some other hex editor (not to speak about Wordpad),
  then use XVI32...
- XVI32 allows to edit files up to 2 GB (enough virtual memory
  provided, of course)
- For your convenience, XVI32 stores settings and last used
  search strings etc. in XVI32.INI file
- Progress indication in percent for most operations
- You can abort nearly all operations (reading/writing files,
  search, replace, print...)
- Simplified search for Unicode Latin (UTF-16) strings
- Computing of CRC16 (standard) and CRC32 (PKZIP compatible)
  for complete file and selected block (only if block is currently
  selected)
- Display of both text (ASCII/ANSI) and hexadecimal
  representation
- Two synchronous cursors in text and hex area
- Fully resizeable window (change number of rows and columns)
- Font and font size adjustable
- Overwrite or insert characters
- Insert text or hex string n times
- Switch byte offset (address) of first byte between 0 or 1 to
  examine also record structure of plain text files
- Search text or hex string, e.g. find "this text" or
  find "0D 0A"
- Search optionally with joker char, e.g. find "A.C" or
  "00 2E 2E 00" where "." = "2E" (user-defined) stands for
  any character
- Fast searching algorithm (Quicksearch) for both search
  directions (down/up)
- Count occurences of text or hex string
- Replace text or hex string, e.g. replace "0D 0A" by "0A"
  or replace "0D 0A" by text "EOL"
- Extremely fast "replace all" mode (if needed, additional
  memory is allocated beforehead, not at every single
  replacing operation)
- Auto-fill feature to copy bytes from current address into
  input field for hex string using right arrow key
- Character conversion using self-defined character table
- Easy converting of text to hex string in dialogs
  (e.g. "abc" -> "61 62 63")
- Decoding and encoding of 1, 2, 4, and 8 byte integers
  or 4/8 byte floats in 2 possible byte orders
- Bit manipulation (view or set bits)
- Open file in Read Only mode (e.g. if opened by another application or to avoid
  unintentional modifications)
- Insert file contents into file
- Write block to file
- Copy, move or delete block
- Clipboard support
- Goto address (absolute or relative up/down)
- Up to 9 named bookmarks
- Enter jump width and jump up/down
  (useful for files with fixed record length)
- Shredder data (overwrite all bytes with binary zeroes)
- Printing with preview or print to file
- Easily access most recently used files
- And last, but not least: XVI32 is free!


II. REQUIREMENTS
================

XVI32 is a 32 bit application and requires Windows 9x/NT/2000/XP/Vista/7.


III. INSTALLATION
=================

No special installation procedure is required. Just unzip the file XVI32.ZIP
which contains the following files:

XVI32.EXE	executable
XVI32U.CHM	help file
XVI32U.HLP	help file (old help format)
XVI32U.CNT	help contents file (old help format)
*.XCT           6 character conversion tables (XCT files),
                e.g. to convert DOS codepage 850 to Windows
                codepage 1252 (refer to online help for details)
README.TXT	this file

Create a directory for XVI32, e.g. C:\XVI32 or C:\PortableApps\XVI32.
Note for Windows Vista and above: Don't create a directory below the
C:\Program Files directory like C:\Program Files\XVI32, because in
this case, the program would have no access to its INI file (which
is located in the program directory).

Copy the above mentioned files into the directory. No data will be written
into the registry, no DLLs are copied to your hard disk. The user defined
settings are stored in a file XVI32.INI which is located in the same directory
as the executable. If you want to open any file with XVI32 from Windows Explorer,
you can create a link as described in online help.


IV. UNINSTALL XVI32
===================
To uninstall XVI32 completely, proceed as follows:

1. If you have created a shortcut link in the SendTo folder, start
XVI32, go to the options dialog (Tools | Options... | Shortcut link)
and click on the remove button. Under Windows NT and above, every user
must log in and perform this task. It is also possible to remove
the link(s) manually (under Win 9x C:\Windows\SendTo, under NT
C:\WINNT\Profiles\<USER>\SendTo).

2. Exit XVI32 and delete the complete folder where XVI32 was
installed.


V. LICENSE AGREEMENT AND COPYRIGHT
==================================

IMPORTANT - READ CAREFULLY
This license and disclaimer statement constitutes a legal agreement
("License Agreement") between you (either as an individual or a single entity)
and Christian Maas (the "Author"), for this software product ("Software"),
including any software, media, and accompanying on-line or printed
documentation.

BY DOWNLOADING, INSTALLING, COPYING, OR OTHERWISE USING THE SOFTWARE, YOU 
AGREE TO BE BOUND BY ALL OF THE TERMS AND CONDITIONS OF THIS LICENSE AND 
DISCLAIMER AGREEMENT.

This software is freeware. You can use this software royalty-free for private
and commercial purposes.

You can freely distribute copies of the main archive as long as no alterations
are made to the contents and no charge is raised except a reasonable fee for
distributing costs.

You may not modify, reverse engineer, decompile, or disassemble the object code
portions of this software.

This Software is owned by Christian Maas and is protected by copyright law
and international copyright treaty. Therefore, you must treat this Software
like any other copyrighted material (e.g., a book).

This software is provided "as is" and without any warranties expressed or
implied, including, but not limited to, implied warranties of fitness for
a particular purpose.

In no event shall the author be liable for any damages whatsoever (including,
without limitation, damages for loss of business profits, business interruption,
loss of business information, or other pecuniary loss) arising out of the use
of or inability to use this software or documentation, even if the author has
been advised of the possibility of such damages.

Any feedback given to the author will be treated as non-confidential.
The author may use any feedback free of charge without limitation.