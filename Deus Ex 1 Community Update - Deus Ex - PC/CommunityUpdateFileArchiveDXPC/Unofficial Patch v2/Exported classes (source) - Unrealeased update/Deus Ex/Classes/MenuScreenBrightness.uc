//=============================================================================
// MenuScreenBrightness
//=============================================================================

class MenuScreenBrightness expands MenuUIScreenWindow;

var Color colRed;
var Color colGreen;
var Color colBlue;
var Color colWhite;

var localized string helpMessage;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	ShowHelp(helpMessage);

	// Don't mask this window, we want the user to see the 
	// 3D Scene unmolested to assist when setting the 
	// brightness.
	root.HideSnapshot();
}

// ----------------------------------------------------------------------
// DestroyWindow()
// ----------------------------------------------------------------------

event DestroyWindow()
{
	root.ShowSnapshot(True);

	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	// Create scale textures
	CreateScaleWindow(14, colRed);
	CreateScaleWindow(144, colGreen);
	CreateScaleWindow(274, colBlue);
	CreateScaleWindow(404, colWhite);

	// Create line
//	CreateScaleLine();
}

// ----------------------------------------------------------------------
// CreateScaleLine()
// ----------------------------------------------------------------------

function CreateScaleLine()
{
	local Window winLine;

	winLine = winClient.NewChild(Class'Window');
	winLine.SetPos(14, 178);
	winLine.SetSize(520, 1);
	winLine.SetBackground(Texture'Solid');
	winLine.SetBackgroundStyle(DSTY_Normal);
	winLine.SetTileColor(colWhite);
}

// ----------------------------------------------------------------------
// CreateScaleWindow()
// ----------------------------------------------------------------------

function CreateScaleWindow(int posX, Color colScale)
{
	local Window winScale;

	winScale = winClient.NewChild(Class'Window');
	winScale.SetPos(posX, 67);
	winScale.SetSize(130, 137);
	winScale.SetBackground(Texture'MenuBrightnessGradient');
	winScale.SetTileColor(colScale);
	winScale.SetBackgroundStyle(DSTY_Normal);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colRed=(R=255)
     colGreen=(G=255)
     colBlue=(B=255)
     colWhite=(R=255,G=255,B=255)
     HelpMessage="Adjust the slider so the color bars fade smoothly to pure black at the bottom of the bars."
     choices(0)=Class'DeusEx.MenuChoice_AdjustBrightness'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
     Title="Adjust Brightness"
     ClientWidth=556
     ClientHeight=283
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuBrightnessBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuBrightnessBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuBrightnessBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuBrightnessBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.MenuBrightnessBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.MenuBrightnessBackground_6'
     bHelpAlwaysOn=True
     helpPosY=229
}
