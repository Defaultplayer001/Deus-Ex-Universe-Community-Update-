//=============================================================================
// ComputerUIWindow
//
// Base class for the Computer windows
//=============================================================================

class ComputerUIWindow extends Window
	abstract;

var DeusExRootWindow root;							// Keep a pointer to the root window handy
var DeusExPlayer player;							// Keep a pointer to the player for easy reference

var NetworkTerminal             winTerm;
var MenuUITitleWindow			winTitle;			// Title bar, outside client
var MenuUIClientWindow			winClient;			// Window that contains all controls
var MenuUIActionButtonBarWindow winButtonBar;		// Button Bar Window
var MenuUILeftEdgeWindow        winLeftEdge;
var MenuUIRightEdgeWindow       winRightEdge;
var MenuUIHelpWindow            winStatus;
var Class<MenuUIClientWindow>   classClient;		// Which client class to use
var ElectronicDevices           compOwner;			// what computer owns this window?
var String                      escapeAction;		// Action to invoke when Escape pressed

// Used to process Email and Bulletins
struct TextFileInfo
{
	var Name   fileName;
	var String fileDescription;
};

struct TextEmailInfo 
{
	var Name   emailName;
	var String emailSubject;
	var String emailFrom;
	var String emailTo;
	var String emailCC;
};

var transient TextFileInfo fileInfo[10];
var transient TextEmailInfo emailInfo[10];
var int fileIndex;
var int emailIndex;

// Dragging stuff
var Bool	bWindowBeingDragged;
var Bool	bAllowWindowDragging;
var Bool    bWindowDragged;

var float	windowStartDragX;
var float	windowStartDragY;

// Defaults
var localized String title;
var int clientWidth;
var int clientHeight;
var int verticalOffset;
var Texture clientTextures[6];
var int textureRows;
var int textureCols;
var bool bActionButtonBarActive;
var bool bRightEdgeActive;
var bool bUsesStatusWindow;
var bool bAlwaysCenter;
var int  statusPosY;
var int  defaultStatusLeftOffset;
var int  defaultStatusHeight;
var int  defaultStatusClientDiffY;

var localized string ButtonLabelLogin;
var localized string ButtonLabelLogout;
var localized string ButtonLabelCancel;
var localized string ButtonLabelSpecial;
var localized string ComputerNodeFunctionLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Get a pointer to the root window
	root = DeusExRootWindow(GetRootWindow());

	// Get a pointer to the player
	player = DeusExPlayer(root.parentPawn);

	CreateControls();	
	StyleChanged();

	// Play Menu Activated Sound
	PlaySound(Sound'Menu_Activate', 0.25); 
}

// ----------------------------------------------------------------------
// DestroyWindow()
//
// Unload texture memory used by background textures
// ----------------------------------------------------------------------

function DestroyWindow()
{
	local int texIndex;

   if (Player != Player.GetPlayerPawn())
   {
      log("==============>Player mismatch!!!!");
   }
   else
   {
      // Play OK Sound
      PlaySound(Sound'Menu_OK', 0.25); 
   }

	for(texIndex=0; texIndex<arrayCount(clientTextures); texIndex++)
		player.UnloadTexture(clientTextures[texIndex]);

	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// CloseScreen()
// ----------------------------------------------------------------------

function CloseScreen(String action)
{
	if (winTerm != None)
		winTerm.CloseScreen(action);
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	CreateTitleWindow();
	CreateClientWindow();
	CreateActionButtonBar();
	CreateRightEdgeWindow();
	CreateStatusWindow();
}

// ----------------------------------------------------------------------
// ParentRequestedPreferredSize()
// ----------------------------------------------------------------------

event ParentRequestedPreferredSize(bool bWidthSpecified, out float preferredWidth,
                                   bool bHeightSpecified, out float preferredHeight)
{
	local float clientWidth, clientHeight;
	local float titleWidth, titleHeight;
	local float buttonBarWidth, buttonBarHeight;
	local float rightEdgeWidth;

	if (winClient != None)
		winClient.QueryPreferredSize(clientWidth, clientHeight);

	if (winTitle != None)
	{
		titleWidth  = winTitle.leftBottomWidth;
		titleHeight = winTitle.titleHeight;
	}

	if (winRightEdge != None)
		rightEdgeWidth = winRightEdge.rightWidth;

	if (winButtonBar != None)
		winButtonBar.QueryPreferredSize(buttonBarWidth, buttonBarHeight);

	preferredWidth  = clientWidth  + titleWidth  + rightEdgeWidth;
	preferredHeight = clientHeight + titleHeight + buttonBarHeight + verticalOffset;
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	local float clientWidth, clientHeight;
	local float titleWidth, titleHeight, titleTopHeight, titleBarWidth;
	local float leftEdgeWidth, leftEdgeHeight;
	local float rightEdgeWidth, rightEdgeHeight;
	local float buttonBarWidth, buttonBarHeight;
	local float rightEdgeX, rightEdgeY;
	local float winLeftEdgeGap;
	local float rightEdgeGap;

	// Client Window
	if (winClient != None)
		winClient.QueryPreferredSize(clientWidth, clientHeight);

	// Title Bar
	if (winTitle != None)
	{
		winTitle.QueryPreferredSize(titleBarWidth, titleHeight);
		titleWidth     = winTitle.leftBottomWidth;
		titleTopHeight = winTitle.titleHeight;
	}

	// Button Bar
	if (winButtonBar != None)
	{
		// If Right edge active, need to make button bar wider
		if (winRightEdge != None)
		{
			winRightEdge.QueryPreferredSize(rightEdgeWidth, rightEdgeHeight);
			rightEdgeWidth = winRightEdge.rightWidth;
			rightEdgeGap   = 2;
		}

		if (winLeftEdge != None)
			winLeftEdgeGap = 1;

		winButtonBar.QueryPreferredSize(buttonBarWidth, buttonBarHeight);
		winButtonBar.ConfigureChild(
			titleWidth + winLeftEdgeGap, titleTopHeight + clientHeight + verticalOffset, 
			clientWidth - 1 - rightEdgeGap, buttonBarHeight);
	}

	// Left Edge
	if (winLeftEdge != None)
	{
		winLeftEdge.QueryPreferredSize(LeftEdgeWidth, LeftEdgeHeight);
		winLeftEdge.ConfigureChild(
			titleWidth - LeftEdgeWidth, titleHeight + verticalOffset, 
			LeftEdgeWidth, clientHeight + buttonBarHeight - (titleHeight - titleTopHeight) - 1);
	}

	// Right Edge
	if (winRightEdge != None)
	{
		winRightEdge.ConfigureChild(
			titleBarWidth + 1, titleTopHeight - 4 + verticalOffset, 
			clientWidth - (titleBarWidth - titleWidth) - 1 + winRightEdge.rightWidth, 
			clientHeight + 4 + 14);
	}

	// Configure Status Window
	if (winStatus != None)
	{
		winStatus.ConfigureChild(
			titleWidth + defaultStatusLeftOffset, titleTopHeight + StatusPosY + verticalOffset,
			clientWidth - defaultStatusClientDiffY, defaultStatusHeight);
	}
}

// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

function bool ChildRequestedReconfiguration(window child)
{
	return False;
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bKeyHandled;
	bKeyHandled = True;

	switch( key ) 
	{	
		case IK_Escape:
			CloseScreen(escapeAction);	
			break;

		default:
			bKeyHandled = False;
	}

	if (bKeyHandled)
		return True;
	else
		return Super.VirtualKeyPressed(key, bRepeat);
}

// ----------------------------------------------------------------------
// MouseMoved()
//
// If we're dragging the window around, move
// ----------------------------------------------------------------------

event MouseMoved(float newX, float newY)
{
	if (bWindowBeingDragged)
	{
		bWindowDragged = True;
		SetPos( x + (newX - windowStartDragX), y + (newY - windowStartDragY) );
	}
}

// ----------------------------------------------------------------------
// MouseButtonPressed() 
//
// If the user presses the mouse button while over the title bar,
// initiate window dragging.
// ----------------------------------------------------------------------

event bool MouseButtonPressed(float pointX, float pointY, EInputKey button,
                              int numClicks)
{
	local float relativeX;
	local float relativeY;

	if ( ( button == IK_LeftMouse ) && ( numClicks == 1 ) && 
		( ( FindWindow(pointX, pointY, relativeX, relativeY) == winTitle ) || ( bAllowWindowDragging )))
	{
		bWindowBeingDragged = True;
		windowStartDragX = pointX;
		windowStartDragY = pointY;

		GrabMouse();
	}
	else
	{
		bWindowBeingDragged = False;
	}

	return bWindowBeingDragged;  
}

// ----------------------------------------------------------------------
// MouseButtonReleased() 
//
// First check to see if we're dragging the window.  If so, then
// end the drag event.
// ----------------------------------------------------------------------

event bool MouseButtonReleased(float pointX, float pointY, EInputKey button,
                               int numClicks)
{
	local float relativeX;
	local float relativeY;

	if ((button == IK_LeftMouse ) && (bWindowBeingDragged))
		bWindowBeingDragged = False;			

	return False;
}

// ----------------------------------------------------------------------
// CreateTitleWindow()
// ----------------------------------------------------------------------

function CreateTitleWindow()
{
	winTitle = MenuUITitleWindow(NewChild(Class'MenuUITitleWindow'));
	winTitle.SetPos(0, verticalOffset);

	SetTitle(title);
}

// ----------------------------------------------------------------------
// SetTitle()
// ----------------------------------------------------------------------

function SetTitle(String newTitle)
{
	winTitle.SetTitle(newTitle);
}

// ----------------------------------------------------------------------
// CreateClientWindow()
// ----------------------------------------------------------------------

function CreateClientWindow()
{
	local int clientIndex;
	local int titleOffsetX, titleOffsetY;

	winClient = MenuUIClientWindow(NewChild(classClient));

	winTitle.GetOffsetWidths(titleOffsetX, titleOffsetY);

	winClient.SetPos(titleOffsetX, titleOffsetY + verticalOffset);
	winClient.SetSize(clientWidth, clientHeight);
	winClient.SetTextureLayout(textureCols, textureRows);

	// Set background textures
	for(clientIndex=0; clientIndex<arrayCount(clientTextures); clientIndex++)
	{
		winClient.SetClientTexture(clientIndex, clientTextures[clientIndex]);
	}
}

// ----------------------------------------------------------------------
// CreateActionButtonBar()
// ----------------------------------------------------------------------

function MenuUIActionButtonBarWindow CreateActionButtonBar()
{
	// Only create if we're supposed to create it
	if (bActionButtonBarActive)
		winButtonBar = MenuUIActionButtonBarWindow(NewChild(Class'MenuUIActionButtonBarWindow'));
}

// ----------------------------------------------------------------------
// CreateLeftEdgeWindow()
// ----------------------------------------------------------------------

function CreateLeftEdgeWindow()
{
	winLeftEdge = MenuUILeftEdgeWindow(NewChild(Class'MenuUILeftEdgeWindow'));
	winLeftEdge.AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// CreateRightEdgeWindow()
// ----------------------------------------------------------------------

function CreateRightEdgeWindow()
{
	if (bRightEdgeActive)
	{
		winRightEdge = MenuUIRightEdgeWindow(NewChild(Class'MenuUIRightEdgeWindow'));
		winRightEdge.Lower();
	}
}

// ----------------------------------------------------------------------
// CreateStatusWindow()
//
// Optionally creates the status window, which is displayed at the 
// bottom of the screen.
// ----------------------------------------------------------------------

function CreateStatusWindow()
{
	if (bUsesStatusWindow)
	{
		winStatus = MenuUIHelpWindow(NewChild(Class'MenuUIHelpWindow'));
		winStatus.SetWordWrap(False);
		winStatus.SetTextMargins(0, 0);
	}
}

// ----------------------------------------------------------------------
// ShowStatus()
// ----------------------------------------------------------------------

function ShowStatus(String statusMessage)
{
	if (winStatus != None)
	{
		winStatus.Show();
		winStatus.SetText(statusMessage);
	}
}

// ----------------------------------------------------------------------
// HideStatus()
// ----------------------------------------------------------------------

function HideStatus()
{
	if (winStatus != None)
		winStatus.Hide();
}

// ----------------------------------------------------------------------
// CreateMenuLabel()
// ----------------------------------------------------------------------

function MenuUILabelWindow CreateMenuLabel(int posX, int posY, String strLabel, Window winParent)
{
	local MenuUILabelWindow newLabel;

	newLabel = MenuUILabelWindow(winParent.NewChild(Class'MenuUILabelWindow'));

	newLabel.SetPos(posX, posY);
	newLabel.SetText(strLabel);

	return newLabel;
}

// ----------------------------------------------------------------------
// CreateSmallMenuLabel()
// ----------------------------------------------------------------------

function MenuUISmallLabelWindow CreateSmallMenuLabel(int posX, int posY, String strLabel, Window winParent)
{
	local MenuUISmallLabelWindow newLabel;

	newLabel = MenuUISmallLabelWindow(winParent.NewChild(Class'MenuUISmallLabelWindow'));

	newLabel.SetPos(posX, posY);
	newLabel.SetText(strLabel);

	return newLabel;
}

// ----------------------------------------------------------------------
// CreateMenuEditWindow()
// ----------------------------------------------------------------------

function MenuUIEditWindow CreateMenuEditWindow(int posX, int posY, int editWidth, int maxChars, Window winParent)
{
	local MenuUIInfoButtonWindow btnInfo;
	local ClipWindow             clipName;
	local MenuUIEditWindow       newEdit;

	// Create an info button behind this sucker
	btnInfo = MenuUIInfoButtonWindow(winParent.NewChild(Class'MenuUIInfoButtonWindow'));
	btnInfo.SetPos(posX, posY);
	btnInfo.SetWidth(editWidth);
	btnInfo.SetSensitivity(False);

	clipName = ClipWindow(winClient.newChild(Class'ClipWindow'));
	clipName.SetWidth(editWidth - 8);
	clipName.ForceChildSize(False, True);
	clipName.SetPos(posX + 4, posY + 4);

	newEdit = MenuUIEditWindow(clipName.NewChild(Class'MenuUIEditWindow'));
	newEdit.SetMaxSize(maxChars);

	return newEdit;
}

// ----------------------------------------------------------------------
// CreateHeaderButton()
// ----------------------------------------------------------------------

function MenuUIListHeaderButtonWindow CreateHeaderButton(
	int posX, 
	int posY, 
	int buttonWidth, 
	String strLabel, 
	Window winParent)
{
	local MenuUIListHeaderButtonWindow newButton;

	newButton = MenuUIListHeaderButtonWindow(winParent.NewChild(Class'MenuUIListHeaderButtonWindow'));

	newButton.SetPos(posX, posY);
	newButton.SetWidth(buttonWidth);
	newButton.SetButtonText(strLabel);

	return newButton;
}

// ----------------------------------------------------------------------
// CreateScrollAreaWindow()
// ----------------------------------------------------------------------

function MenuUIScrollAreaWindow CreateScrollAreaWindow(Window winParent)
{
	return MenuUIScrollAreaWindow(winParent.NewChild(Class'MenuUIScrollAreaWindow'));
}

// ----------------------------------------------------------------------
// SetCompOwner()
// ----------------------------------------------------------------------

function SetCompOwner(ElectronicDevices newCompOwner)
{
	compOwner = newCompOwner;

	if ((winStatus != None) && (compOwner.IsA('Computers')))
		winStatus.SetText("Daedalus:GlobalNode:" $ Computers(compOwner).GetNodeAddress() $ "/" $ ComputerNodeFunctionLabel);
}

// ----------------------------------------------------------------------
// SetNetworkTerminal()
// ----------------------------------------------------------------------

function SetNetworkTerminal(NetworkTerminal newTerm)
{
	winTerm = newTerm;
}

// ----------------------------------------------------------------------
// ProcessDeusExText()
// ----------------------------------------------------------------------

function ProcessDeusExText(Name textName, optional TextWindow winText)
{
	local DeusExTextParser parser;
	local string TextPackage;

	fileIndex  = -1;
	emailIndex = -1;

	// First check to see if we have a name
	if ( textName != '' )
	{
		// Create the text parser
		parser = new(None) Class'DeusExTextParser';
		parser.SetPlayerName(player.TruePlayerName);

		if (CompOwner.IsA('Computers'))
			TextPackage = Computers(CompOwner).TextPackage;
		else
			TextPackage = "DeusExText";

		// Attempt to find the text object
		if ( parser.OpenText(textName, TextPackage) )
		{
			while(parser.ProcessText())
				ProcessDeusExTextTag(parser, winText);

			parser.CloseText();
		}

		CriticalDelete(parser);
	}
}

// ----------------------------------------------------------------------
// ProcessDeusExTextTag()
// ----------------------------------------------------------------------

function ProcessDeusExTextTag(DeusExTextParser parser, optional TextWindow winText)
{
	local String text;
//	local EDeusExTextTags tag;
	local byte tag;
	local Name fontName;
	local String textPart;

	tag  = parser.GetTag();

	switch(tag)
	{
		case 0:				// TT_Text:
		case 9:				// TT_PlayerName:
		case 10:			// TT_PlayerFirstName:
			text = parser.GetText();

			// Add the text
			if (winText != None)
				winText.AppendText(text);

			break;

		case 1:				// TT_File
			ProcessFile(parser);
			break;

		case 2:				// TT_Email
			ProcessEmail(parser);
			break;

		case 18:			// TT_NewParagraph:
			if (winText != None)
				winText.AppendText(CR());
			break;

		case 13:				// TT_LeftJustify:
			break;

		case 14:			// TT_RightJustify:
			break;

		case 12:				// TT_CenterText:
			break;

		case 26:			// TT_Font:
			break;

		case 15:			// TT_DefaultColor:
		case 16:			// TT_TextColor:
		case 17:			// TT_RevertColor:
			break;
	}
}

// ----------------------------------------------------------------------
// ProcessFile()
// ----------------------------------------------------------------------

function ProcessFile(DeusExTextParser parser)
{
	local String fileStringName;

	// Make sure we don't overwrite our array
	if (fileIndex == 9)
		return;

	fileIndex = fileIndex + 1;

	parser.GetFileInfo(
		fileStringName,
		fileInfo[fileIndex].fileDescription);

	fileInfo[fileIndex].fileName = StringToName(fileStringName);
}

// ----------------------------------------------------------------------
// ProcessEmail()
// ----------------------------------------------------------------------

function ProcessEmail(DeusExTextParser parser)
{
	local String emailStringName;

	// Make sure we don't overwrite our array
	if (emailIndex == 9)
		return;

	emailIndex = emailIndex + 1;

	parser.GetEmailInfo(
		emailStringName,
		emailInfo[emailIndex].emailSubject,
		emailInfo[emailIndex].emailFrom,
		emailInfo[emailIndex].emailTo,
		emailInfo[emailIndex].emailCC);
	
	emailInfo[emailIndex].emailName = StringToName(emailStringName);
}

// ----------------------------------------------------------------------
// ChangeAccount()
// ----------------------------------------------------------------------

function ChangeAccount()
{
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;
	local Color colCursor;

	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	colCursor = theme.GetColorFromName('MenuColor_Cursor');

	SetDefaultCursor(Texture'DeusExCursor1', Texture'DeusExCursor1_Shadow', 32, 32, colCursor);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     classClient=Class'DeusEx.MenuUIClientWindow'
     escapeAction="EXIT"
     bActionButtonBarActive=True
     bUsesStatusWindow=True
     defaultStatusLeftOffset=10
     defaultStatusHeight=13
     defaultStatusClientDiffY=21
     ButtonLabelLogin="|&Login"
     ButtonLabelLogout="|&Logout"
     ButtonLabelCancel="|&Cancel"
     ButtonLabelSpecial="|&Special Options"
}
