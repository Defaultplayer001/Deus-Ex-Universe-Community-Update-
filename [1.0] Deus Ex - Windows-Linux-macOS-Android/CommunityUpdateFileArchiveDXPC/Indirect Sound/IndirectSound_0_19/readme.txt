[[===========================================================================]]

  IndirectSound

  Copyright (C) 2012-2019 John-Paul Ownby
  All Rights Reserved

  www.indirectsound.com
  indirectsound@gmail.com

[[===========================================================================]]

IndirectSound emulates audio hardware acceleration
which enables older games to have 3D positional audio
(i.e. sound played out of rear and surround speakers)
like they were intended to when they were originally released.

To use IndirectSound:
  * Extract the contents of the IndirectSound zip file to a known location
  * You will have to perform the following steps for each game
    in which you want to emulate audio hardware acceleration:
    * Find the location of the executable file that runs the game
      * The file will be called something like "game.exe",
        and will usually be in the main directory of the game
      * Some games have launcher programs,
        in which case the real game executable may be
        in a subdirectory
    * Copy the file "dsound.dll" to the same directory
      that the game's executable is in
    * Run the game
  * Some games won't work unless you change your system's registry:
      www.indirectsound.com/registryIssues.html
  * You may also need to install Visual Studio 2010 runtime components
    which can currently be downloaded here:
      https://www.microsoft.com/en-us/download/details.aspx?id=5555
  * You may also need to install XAudio2 (part of DirectX)
    which can currently be downloaded here:
      https://www.microsoft.com/en-us/download/details.aspx?id=35

If you set things up correctly and
if the game uses Microsoft's DirectSound API
then it will now believe that
audio hardware acceleration is available.

You can verify that the audio hardware emulation is working
using the following methods:
  * Listen for audio coming from your rear or surround speakers
  * In some games you will have to explicitly enable hardware acceleration.
    If the game has an options/settings menu for audio
    look to see if there is any indication that
    hardware acceleration is available
    and enable it if required.
  * Look for a file called "dsound.log" in the same directory
    where you copied "dsound.dll". This file will be generated
    every time an application loads IndirectSound.
    If you don't see this file after you have run the game
    then one of the following must be true:
    * You didn't copy "dsound.dll" to the correct directory.
    * The game is creating a DirectSound interface
      using an explicit CLSID ("Class ID"),
      and your Windows registry settings are ignoring IndirectSound.
      You can learn how to fix this problem here:
        * www.indirectsound.com/registryIssues.html
    * The game doesn't use Microsoft's DirectSound API
    * IndirectSound may not have permission to create or write to the file
      (e.g. if you are running the game using a non-administrator account)
    * Something went catastrophically wrong with IndirectSound
      (you probably would have seen a crash in this case)

If IndirectSound is being used but you don't hear any
3D positional audio in-game look at the generated "dsound.log" file
to see if any errors are reported.
If you believe that you have discovered a bug in IndirectSound
please report it to:
    indirectsound@gmail.com

IndirectSound can be configured to emulate different kinds of hardware
by using the "dsound.ini" file.
To learn more about what features can be configured and how to do so
open "dsound.ini" in a text editor of your choice and read through it.
In most Windows installations simply double-clicking "dsound.ini"
will open it in notepad.

[[===========================================================================]]

The license to use IndirectSound is the following:

Copyright (c) 2012-2019 John-Paul Ownby

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

[[===========================================================================]]

IndirectSound uses Lua 5.2.1 to easily configure settings.
To learn more about Lua, see:

  www.lua.org

The license to use it is the following:

Copyright (c) 1994–2012 Lua.org, PUC-Rio.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

[[===========================================================================]]

IndirectSound uses Mhook 2.3 to ensure that its own COM interfaces
are used instead of what the Windows registry specifies.
To learn more about Mhook, see:

  http://codefromthe70s.org/mhook23.aspx

The license to use it is the following:

Copyright (c) 2007-2012, Marton Anka
Portions Copyright (c) 2007, Matt Conover

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
