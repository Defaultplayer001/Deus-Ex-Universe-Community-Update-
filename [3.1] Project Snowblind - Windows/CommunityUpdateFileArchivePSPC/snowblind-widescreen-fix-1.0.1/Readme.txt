Widescreen Patch for Project: Snowblind
---------------------------------------
This patch adds widescreen support to Project: Snowblind. In particular, it
makes it possible to run the game at widescreen resolutions and fixes the aspect
ratio at widescreen resolutions by increasing the horizontal field of view.

Installation
------------
- extract the contents of this archive into the Project: Snowblind installation
  directory
- install the *Microsoft Visual C++ 2013 x86 Redistributable* using the included
  `vcredist_x86.exe` installer

You can adjust various settings in `snowblind-widescreen.ini`, though the
defaults should be fine most of the time.

Known Issues
------------
- The black bars/fade effects during in-game cutscenes don't resize to fit the
  screen.
- The HUD is always confined to the center 4:3 area of the screen
- Increasing or decreasing the vertical FOV from the default introduces various
  visual glitches (mostly UI elements appearing that are normally offscreen and
  the 1st person weapon/arm meshes running out).
- Dynamic character shadows are not where they should be (note that character
  shadows are only rarely visible anyway).

Changelog
---------
* 1.0 (2015-04-13)
  - initial release

Building from Source
--------------------
The source can be found at https://bitbucket.org/fk/snowblind-widescreen-fix.
Visual Studio 2013 Express (or up) is required.

Legal
-----
This library is Copyright (c) 2015 Felix Krull.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

*Microsoft Visual C++ 2013 x86 Redistributable* is a Microsoft product and is
included according to the "Distributable Code" terms of the Microsoft Software
License Terms for Visual Studio 2013.
