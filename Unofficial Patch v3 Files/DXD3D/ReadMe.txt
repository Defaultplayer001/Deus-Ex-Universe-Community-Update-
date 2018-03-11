Note: This is a text version of http://www.cwdohnal.com/utglr/

An enhanced OpenGL renderer for Unreal Tournament

Last updated August 1, 2010

I added some enhancements to the OpenGL Renderer for Unreal Tournament. A Win32/x86 binary and the source code are available on this page.

The settings page documents some of the options.

For Unreal Tournament (version 4.36 or compatible):
The latest stable OpenGL renderer is version 3.6: utglr36.zip (110 KB).
OpenGL renderer version 3.5 for UT: utglr35.zip (110 KB).
OpenGL renderer version 3.4 for UT: utglr34.zip (111 KB).
It's just a new OpenGLDrv.dll as noted in the Installation instructions section.

Direct3D9 renderer version 1.3 for UT: utd3d9r13.zip (107 KB).
Direct3D9 renderer version 1.2 for UT: utd3d9r12.zip (102 KB).
It's a couple new files that go in the UnrealTournament\System directory. To use it, change video drivers in UT, select show all devices, and then select Direct3D9 Support. If the OpenGL renderer doesn't work right on your system for whatever reason (video driver problems or some other issue), you can try using this one instead. It has mostly the same feature set as the updated OpenGL renderer. Note that this Direct3D9 renderer doesn't support selection in the editor, so consider it unsupported and not fully functional as far as use with the editor is concerned.

For Deus Ex (works with Deus Ex version 1112fm):
OpenGL renderer version 2.0 for Deus Ex: dxglr20.zip (110 KB).
Direct3D9 renderer version 1.3 for Deus Ex: dxd3d9r13.zip (107 KB).

For Rune (works with Rune version 1.07 or compatible):
OpenGL renderer version 1.4 for Rune: runeglr14.zip (111 KB).
Direct3D9 renderer version 1.3 for Rune: runed3d9r13.zip (109 KB).

For Unreal
Visit Oldunreal.

Latest news
Version 3.7 is released. These binaries were built with a newer compiler and require Windows 2000 or later.

Version 3.7 or UT: utglr37.zip (87 KB).
Version 2.1 for Deus Ex (works with Deus Ex version 1112fm): dxglr21.zip (87 KB).
Version 1.5 for Rune (works with Rune version 1.07 or compatible): runeglr15.zip (88 KB).

Changes in version 3.7:
- Fixed a bug with ShareLists enabled and the editor that could cause crashes.
- Editor selection no longer uses OpenGL API selection support. This avoids problems with OpenGL drivers with bugs or missing support in this area.
- A couple 227 editor related updates that were also general renderer code fixes.
- The SmoothMaskedTextures option will use alpha to coverage if AA is enabled with 4 or more samples.
- Removed support for using vertex programs without fragment programs. The UseFragmentProgram setting controls both of these and the UseVertexProgram setting is gone.
- Removed compiled vertex array support and the UseCVA option.
- Removed the UseTNT option.
- No longer using sstream for internal debug functionality.
- A few other mostly minor changes.

ZRangeHack will be enabled by default for UT if not already present in the ini file, but this one may still need to be watched a little more closely. There are a couple cases I know of where it has minor side effects. However, with most video cards these days only supporting 24-bit but not 32-bit z-buffers, or unless modified other parts of the game engine to draw decals a little further away, it is needed to avoid decal flickering in the distance in many common cases.

3-22-2010
New D3D9 renderer builds with a few new features. Selection in the editor is supported. Lines are buffered for faster line drawing. The SmoothMaskedTextures option will use alpha to coverage if AA is enabled with 4 or more samples, UseFragmentProgram is enabled, and running on an ATI or NVIDIA card that supports this feature in D3D9. These binaries were built with a newer compiler and require Windows 2000 or later.

Version 1.3 for UT: utd3d9r13.zip (107 KB).
Version 1.3 for Deus Ex (works with Deus Ex version 1112fm): dxd3d9r13.zip (107 KB).
Version 1.3 for Rune (works with Rune version 1.07 or compatible): runed3d9r13.zip (109 KB).

The source code package for this version of the D3D9 renderer is utd3d9r13src.zip (65 KB). It contains MSVC9 project files. If using this source code, make sure to apply the UTGLR_NO_APP_MALLOC changes to the copy of UnFile.h that comes with the headers in the Core/Inc directory to avoid problems with certain debug features and sstream class usage.

12-21-2009
Built a new experimental Deus Ex renderer.

11-16-2009
Version 3.6 is released. It's mostly just a number of minor updates in various areas. These binaries were built with a newer compiler and require Windows 2000 or later.

Version 3.6 or UT: utglr36.zip (110 KB).
Version 2.0 for Deus Ex (works with Deus Ex version 1112fm): dxglr20.zip (110 KB).
Version 1.4 for Rune (works with Rune version 1.07 or compatible): runeglr14.zip (111 KB).

Changes in version 3.6:
- NoMaskedS3TC option removed. Always uses RGBA DXT1. This matches the only option for DXT1 in D3D.
- GL_NV_multisample_filter_hint extension support removed. Don't consider this one very useful anymore.
- A few 227 editor related updates that were general renderer code fixes.
- MaxLogUOverV and MaxLogVOverU config settings removed. These are set internally now.
- Larger default maximum allowed texture size in the not using S3TC config case.
- Potential NVIDIA driver bug workaround for the major graphics corruption after windowed / full screen switch issue. Suspect this may be fixed in newer drivers now, but was easy to add.
- RequestHighResolutionZ option removed. Modified code to attempt to get a 32-bit, 24-bit, or 16-bit z-buffer in that order.
- If first mipmap pointer set to NULL in SetTexture(), skip looking at others.
- AutoGenerateMipmaps and AlwaysMipmap options removed.
- UseDetailAlpha option removed and always enabled internally. A number of detail texture rendering paths depend on having this one enabled.
- BufferClippedActorTris option removed and functionality it controlled always enabled internally.
- A few other minor changes.

ZRangeHack will be enabled by default for UT if not already present in the ini file, but this one may still need to be watched a little more closely. There are a couple cases I know of where it has minor side effects. However, with most video cards these days only supporting 24-bit but not 32-bit z-buffers, or unless modified other parts of the game engine to draw decals a little further away, it is needed to avoid decal flickering in the distance in many common cases.

9-8-2009
New D3D9 renderer builds with changes that should fix screenshots from a non-primary monitor, fragment program mode changed to use shader model 3, D3D pixel / texel center related fixes, and various other changes. These binaries were built with a newer compiler and require Windows 2000 or later.

Version 1.2 for UT: utd3d9r12.zip (102 KB).
Version 1.2 for Deus Ex (works with Deus Ex version 1112fm): dxd3d9r12.zip (102 KB).
Version 1.2 for Rune (works with Rune version 1.07 or compatible): runed3d9r12.zip (104 KB).

More detailed list of changes:
- Screenshots just using BitBlt if windowed now. Should fix non-primary monitor screenshots.
- Different way of dealing with D3D9 pixel / texel center issues. Hopefully fixes more minor things than breaks.
- Vertex program only mode is gone. UseFragmentProgram controls new combined vertex and pixel shader 3.0 mode.
- A few minor shader tweaks. Put a dynamic branch in one place in single pass detail texture shaders.
- UseDetailAlpha and BufferClippedActorTris options no longer configurable and enabled internally.
- A few 227 editor related updates that were general renderer code fixes.
- MaxLogUOverV and MaxLogVOverU config settings removed. These are set internally now.
- Larger default maximum allowed texture size in the not using S3TC config case.
- RequestHighResolutionZ option removed. Modified code to attempt to get a 32-bit, 24-bit, or 16-bit z-buffer in that order.
- If first mipmap pointer set to NULL in SetTexture(), skip looking at others.
- A few other minor changes.

The source code package for this version of the D3D9 renderer is utd3d9r12src.zip (60 KB). It contains MSVC9 project files. If using this source code, make sure to apply the UTGLR_NO_APP_MALLOC changes to the copy of UnFile.h that comes with the headers in the Core/Inc directory to avoid problems with certain debug features and sstream class usage.

5-3-2004
I built a new version of SetGamma that fixes various minor problems. It's a simple command line utility program that adjusts the hardware gamma ramp on the primary display adapter. A shortcut that sends it the -reset option can be used to reset the hardware gamma ramp to 1.0 after a crash that prevents it from being restored.

Some of the old news gets moved to the News Archive page.
Notes
- Additional options are documented in the [New options] section.

Installation instructions
Go to your UnrealTournament\System directory. Make a backup of your old OpenGLDrv.dll in case the new one doesn't work. Then put the new OpenGLDrv.dll in your UnrealTournament\System directory. This one contains a number of optimizations that should improve performance over the base UT 4.36 OpenGL renderer. It also contains a number of new options, which are described further down on this page.

OpenGLDrv.dll for Win32/x86: utglr37.zip (87 KB)

OpenGLDrv.dll for Win32/x86: utglr36.zip (110 KB)
OpenGLDrv.dll for Win32/x86: utglr35.zip (110 KB)
OpenGLDrv.dll for Win32/x86: utglr34.zip (111 KB)

Source code: utglr37src.zip (112 KB)

Source code: utglr36src.zip (111 KB)
Source code: utglr35src.zip (111 KB)
Source code: utglr34src.zip (110 KB)

Notes about the source code
The source code has been modified extensively. Although I did not try to break Linux support completely, I did add some Windows specific code. Feel free to email me at smpdev@cwdohnal.com if you need any help getting it to build on Linux. Make sure to add the NO_UNICODE_OS_SUPPORT define when building it on Win32.

The source code package only contains .cpp and .h files from the OpenGL\Src subdirectory, which is where my changes are. You will need to get the 432 headers from Epic to be able to build it. You can download these from the Unreal Technology Downloads page.

For version 1.2 and up, I had to remove the operator new and delete overrides to make the new C++ debug functions work. I included a copy of the modified UnFile.h with the proper ifdefs. I just have it pass things through to malloc and free instead. I believe the problem may be with the overrides not handling 0 byte allocations as malloc and new do.

Feedback
Email: smpdev@cwdohnal.com

New options
This enhanced UT OpenGL renderer supports some new options. They go in the [OpenGLDrv.OpenGLRenderDevice] section of your UnrealTournament.ini file. Most options are documented on the settings page.

Credits
I'd like to thank Epic Games for releasing the source code to the UT OpenGL renderer, which made adding these updates to it possible.

NitroGL for the original TruForm renderer modification. Initial experimental TruForm code is based on these modifications.

Leonhard Gruenschloss for help with implementing and testing additional TruForm related updates and new Deus Ex specific code.
