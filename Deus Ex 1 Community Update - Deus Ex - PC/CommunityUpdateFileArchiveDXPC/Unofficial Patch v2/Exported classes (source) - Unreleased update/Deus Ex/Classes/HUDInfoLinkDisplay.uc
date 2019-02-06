//=============================================================================
// HUDInfoLinKDisplay
//=============================================================================
class HUDInfoLinKDisplay expands HUDBaseWindow
	transient;

// this seems to have to be here to load the damn DefaultPortrait texture
#exec OBJ LOAD FILE=InfoPortraits

// ----------------------------------------------------------------------
// Local Variables
// ----------------------------------------------------------------------

var Window              winLine;
var Window				winPortrait;
var StaticWindow		winStatic;
var TextWindow			winName;
var TextWindow			winQueued;
var ComputerWindow		winText;

// defaults
var Color colName;
var Color colCursor;
var Color colQueued;
var Color colLine;

var Font  fontName;
var Font  fontText;
var int   fontTextX;
var int   fontTextY;

var Texture speakerPortrait;
var Bool    bPortraitVisible;

var Texture texBackgrounds[2];
var Texture texBorders[2];

var localized string strQueued;
var localized string IncomingTransmission;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Assign border textures
	SetSize(431, 114);

	// Create Controls
	CreateControls();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	// Create window for person speaking
	winPortrait = NewChild(Class'Window');
	winPortrait.SetSize(64, 64);
	winPortrait.SetPos(20, 25);
	winPortrait.SetBackgroundStyle(DSTY_Normal);

	// Window used to display static
	winStatic = StaticWindow(NewChild(Class'StaticWindow'));
	winStatic.SetSize(64, 64);
	winStatic.RandomizeStatic();
	winStatic.SetPos(20, 25);
	winStatic.SetBackgroundStyle(DSTY_Modulated);
	winStatic.Raise();
	winStatic.Hide();

	// Create the name bar
	winName = TextWindow(NewChild(Class'TextWindow'));
	winName.SetTextAlignments(HALIGN_Left, VALIGN_Center);
	winName.SetSize(293, 15);
	winName.SetPos(94, 15);
	winName.SetFont(fontName);
	winName.SetTextColor(colName);
	winName.SetTextMargins(0, 0);
	winName.SetText(IncomingTransmission);

	// Create the queued bar
	winQueued = TextWindow(NewChild(Class'TextWindow'));
	winQueued.SetTextAlignments(HALIGN_Right, VALIGN_Center);
	winQueued.SetSize(200, 15);
	winQueued.SetPos(187, 15);
	winQueued.SetFont(fontName);
	winQueued.SetTextColor(colQueued);
	winQueued.SetTextMargins(0, 0);

	// Create the computer window
	winText = ComputerWindow(NewChild(Class'ComputerWindow'));
	winText.SetPos(94, 36);
	winText.SetTextSize(42, 6);
	winText.SetTextFont(fontText, fontTextX, fontTextY, colText);
	winText.SetTextTiming(0.03);
	winText.SetFadeSpeed(0.75);
	winText.SetCursorColor(colCursor);
	winText.EnableWordWrap(True);

	// Create line between name and scrolling text
	winLine = NewChild(Class'Window');
	winLine.SetSize(293, 1);
	winLine.SetPos(94, 32);
	winLine.SetBackgroundStyle(DSTY_Normal);
	winLine.SetBackground(Texture'Solid');
	winLine.SetTileColor(colLine);
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
	gc.SetStyle(backgroundDrawStyle);
	gc.SetTileColor(colBackground);
	gc.DrawTexture(  0, 0, 256, height, 0, 0, texBackgrounds[0]);
	gc.DrawTexture(256, 0, 175, height, 0, 0, texBackgrounds[1]);
}

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

function DrawBorder(GC gc)
{
	if (bDrawBorder)
	{
		gc.SetStyle(borderDrawStyle);
		gc.SetTileColor(colBorder);
		gc.DrawTexture(  0, 0, 256, height, 0, 0, texBorders[0]);
		gc.DrawTexture(256, 0, 175, height, 0, 0, texBorders[1]);
	}
}

// ----------------------------------------------------------------------
// DisplayText()
// ----------------------------------------------------------------------

function DisplayText(String newText)
{
	winText.Print(newText, False);
}

// ----------------------------------------------------------------------
// AppendText()
// ----------------------------------------------------------------------

function AppendText(String newText)
{
	winText.Print(NewText, False);
}

// ----------------------------------------------------------------------
// SetSpeaker()
//
// Sets the speaker's name in the window and also the portrait 
// displayed in the window
// ----------------------------------------------------------------------

function SetSpeaker(String bindName, String displayName)
{
	local String portraitStringName;
	local DeusExLevelInfo info;

	winName.SetText(displayName);

	// Default portrait name based on bind naem

	portraitStringName = "InfoPortraits." $ Left(bindName, 16);

	// Okay, we have a special case for Paul Denton who, like JC, 
	// has five different portraits based on what the player selected
	// when starting the game.  Therefore we have to pick the right
	// portrait.

	if (bindName == "PaulDenton")
		portraitStringName = portraitStringName $ "_" $ Chr(49 + player.PlayerSkin);

	// Another hack for Bob Page, to use a different portrait on Mission15.
	if (bindName == "BobPage")
	{
		info = player.GetLevelInfo();

		if ((info != None) && (info.MissionNumber == 15))
			portraitStringName = "InfoPortraits.BobPageAug";
	}

	// Get a pointer to the portrait
	speakerPortrait = Texture(DynamicLoadObject(portraitStringName, class'Texture'));
}

// ----------------------------------------------------------------------
// MessageQueued()
// ----------------------------------------------------------------------

function MessageQueued(Bool bQueued)
{
	if ( bQueued )
		winQueued.SetText(strQueued);
	else
		winQueued.SetText("");
}

// ----------------------------------------------------------------------
// ClearScreen()
// ----------------------------------------------------------------------

function ClearScreen()
{
	winText.ClearScreen();
}

// ----------------------------------------------------------------------
// ShowTextCursor()
// ----------------------------------------------------------------------

function ShowTextCursor(Bool bShow)
{
	winText.ShowTextCursor(bShow);
}

// ----------------------------------------------------------------------
// ShowDatalinkIcon()
// ----------------------------------------------------------------------

function ShowDatalinkIcon(bool bShow)
{
	winPortrait.SetBackground(Texture'DataLinkIcon');
	winPortrait.SetBackgroundStyle(DSTY_Masked);
	winPortrait.Show(bShow);

	bPortraitVisible = False;
	bTickEnabled     = False;

	winStatic.Hide();
}

// ----------------------------------------------------------------------
// ShowPortrait()
// ----------------------------------------------------------------------

function ShowPortrait()
{
	winPortrait.SetBackground(speakerPortrait);
	winPortrait.SetBackgroundStyle(DSTY_Normal);
	winPortrait.Show(True);

	bPortraitVisible = True;
	
	winStatic.Show();
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	Super.StyleChanged();

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colName   = theme.GetColorFromName('HUDColor_HeaderText');
	colLine   = theme.GetColorFromName('HUDColor_NormalText');;
	colCursor = colName;
	colQueued = theme.GetColorFromName('HUDColor_NormalText');
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     FontName=Font'DeusExUI.FontMenuHeaders_DS'
     fontText=Font'DeusExUI.FontFixedWidthSmall_DS'
     fontTextX=7
     fontTextY=10
     texBackgrounds(0)=Texture'DeusExUI.UserInterface.HUDInfolinkBackground_1'
     texBackgrounds(1)=Texture'DeusExUI.UserInterface.HUDInfolinkBackground_2'
     texBorders(0)=Texture'DeusExUI.UserInterface.HUDInfolinkBorder_1'
     texBorders(1)=Texture'DeusExUI.UserInterface.HUDInfolinkBorder_2'
     strQueued="message waiting..."
     IncomingTransmission="INCOMING TRANSMISSION..."
}
