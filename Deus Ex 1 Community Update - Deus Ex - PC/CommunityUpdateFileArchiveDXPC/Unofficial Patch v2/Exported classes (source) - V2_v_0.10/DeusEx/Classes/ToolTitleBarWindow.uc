//=============================================================================
// ToolTitleBarWindow
//=============================================================================

class ToolTitleBarWindow expands Window;

var ButtonWindow btnClose;
var Window btnAppIcon;
var String titleBarText;

// Defaults
var Color colTitleBarActive;
var Color colTitleBarInactive;
var Color colTitleBarTextActive;
var Color colTitleBarTextInactive;
var Font fontTitleBar;
var Texture textureAppIcon;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetWindowAlignments(HALIGN_Full, VALIGN_Top, 2, 2);
	SetHeight(18);

	// Add a Close Button
	btnClose = ButtonWindow(NewChild(Class'ButtonWindow'));
	btnClose.SetSelectability(False);
	btnClose.SetSize(16, 14);
	btnClose.SetWindowAlignments(HAlign_Right, VAlign_Top, 2, 2);
	btnClose.SetButtonTextures(Texture'ToolWindowButtonClose_Normal', Texture'ToolWindowButtonClose_Pressed',
							   Texture'ToolWindowButtonClose_Normal', Texture'ToolWindowButtonClose_Pressed');

	// Now add the Application Icon (Deus Ex, Baby!)
	btnAppIcon = NewChild(Class'Window');
	btnAppIcon.SetSize(16, 16);
	btnAppIcon.SetWindowAlignments(HAlign_Left, VAlign_Top, 2, 1);
	btnAppIcon.SetBackground(textureAppIcon);
	btnAppIcon.SetSensitivity(True);
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	// We want to use different colors dependent on whether this is 
	// the active modal window.
	
	gc.SetStyle(DSTY_Normal);
	gc.SetFont(fontTitleBar);
	gc.SetHorizontalAlignment(HALIGN_Left);
	gc.SetVerticalAlignment(VALIGN_Center);

	if ( GetModalWindow().IsCurrentModal() )
	{
		gc.SetTextColor(colTitleBarTextActive);
		gc.SetTileColor(colTitleBarActive);
	}
	else
	{
		gc.SetTextColor(colTitleBarTextInactive);
		gc.SetTileColor(colTitleBarInactive);
	}

	// Now draw the background and then the text
	gc.DrawPattern(0, 0, width, height, 0, 0, Texture'Solid');
	gc.DrawText(21, 0, width - 21, height, titleBarText);
}

// ----------------------------------------------------------------------
// SetTitleBarText()
// ----------------------------------------------------------------------

function SetTitleBarText(String newTitleBarText)
{
	titleBarText = newTitleBarText;
}

// ----------------------------------------------------------------------
// SetAppIcon()
// ----------------------------------------------------------------------

function SetAppIcon(Texture newAppIcon)
{
	btnAppIcon.SetBackground(newAppIcon);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colTitleBarActive=(B=128)
     colTitleBarInactive=(R=128,G=128,B=128)
     colTitleBarTextActive=(R=255,G=255,B=255)
     colTitleBarTextInactive=(R=192,G=192,B=192)
     fontTitleBar=Font'DeusExUI.FontSansSerif_8_Bold'
     textureAppIcon=Texture'DeusExUI.UserInterface.DeusExSmallIcon'
}
