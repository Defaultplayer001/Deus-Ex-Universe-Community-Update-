//=============================================================================
// PersonaScreenBaseWindow
//
// Base class for the Persona Screens
//=============================================================================

class PersonaScreenBaseWindow extends DeusExBaseWindow
	abstract;

var PersonaClientWindow			winClient;			// Window that contains all controls
var PersonaNavBarBaseWindow		winNavBar;			// Navigation Button Bar
var PersonaTitleTextWindow		txtTitle;			// Title Bar Text
var PersonaClientBorderWindow   winClientBorder;	// Border around client window
var PersonaStatusLineWindow     winStatus;

// Defaults
var int screenWidth;
var int screenHeight;
var int clientBorderWidth;
var int clientBorderHeight;
var int clientBorderOffsetX;
var int clientBorderOffsetY;
var int clientWidth;
var int clientHeight;
var int clientOffsetX;
var int clientOffsetY;

var Texture clientTextures[6];
var Texture clientBorderTextures[6];
var int clientTextureRows;
var int clientTextureCols;
var int clientBorderTextureRows;
var int clientBorderTextureCols;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetMouseFocusMode(MFOCUS_Click);

	SetSize(screenWidth, screenHeight);

	CreateControls();	

	// Play Menu Activated Sound

	// TODO: Replace Menu sounds with HUD sounds
	PlaySound(Sound'Menu_Activate', 0.25); 

	StyleChanged();
}

// ----------------------------------------------------------------------
// DestroyWindow()
//
// Unload texture memory used by border/background textures
// ----------------------------------------------------------------------

function DestroyWindow()
{
	local int texIndex;

	for(texIndex=0; texIndex<arrayCount(clientTextures); texIndex++)
		player.UnloadTexture(clientTextures[texIndex]);
		
	for(texIndex=0; texIndex<arrayCount(clientBorderTextures); texIndex++)
		player.UnloadTexture(clientBorderTextures[texIndex]);				

	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	CreateNavBarWindow();
	CreateClientBorderWindow();
	CreateClientWindow();
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

	if ( IsKeyDown( IK_Alt ) || IsKeyDown( IK_Shift ) || IsKeyDown( IK_Ctrl ))
		return False;

	switch( key ) 
	{	
		case IK_Escape:
			SaveSettings();
			root.PopWindow();
			break;

		default:
			bKeyHandled = False;
	}

	if (bKeyHandled)
		return bKeyHandled;
	else
		return Super.VirtualKeyPressed(key, bRepeat);
}

// ----------------------------------------------------------------------
// CreateNavBarWindow()
// ----------------------------------------------------------------------

function CreateNavBarWindow()
{
	winNavBar = PersonaNavBarBaseWindow(NewChild(Class'PersonaNavBarWindow'));
	winNavBar.SetPos(0, 0);
}

// ----------------------------------------------------------------------
// CreateTitleWindow()
// ----------------------------------------------------------------------

function PersonaTitleTextWindow CreateTitleWindow(int posX, int posY, String titleText)
{
	local PersonaTitleTextWindow winTitle;

	winTitle = PersonaTitleTextWindow(winClient.NewChild(Class'PersonaTitleTextWindow'));
	winTitle.SetPos(posX, posY);
	winTitle.SetText(titleText);

	return winTitle;
}

// ----------------------------------------------------------------------
// CreateClientWindow()
// ----------------------------------------------------------------------

function CreateClientWindow()
{
	local int clientIndex;

	winClient = PersonaClientWindow(NewChild(class'PersonaClientWindow'));

	winClient.SetPos(clientBorderOffsetX + clientOffsetX, clientBorderOffsetY + clientOffsetY);
	winClient.SetSize(clientWidth, clientHeight);
	winClient.SetTextureLayout(clientTextureCols, clientTextureRows);

	// Set background textures
	for(clientIndex=0; clientIndex<arrayCount(clientTextures); clientIndex++)
	{
		winClient.SetClientTexture(clientIndex, clientTextures[clientIndex]);
	}
}

// ----------------------------------------------------------------------
// CreateClientBorderWindow()
// ----------------------------------------------------------------------

function CreateClientBorderWindow()
{
	local int clientBorderIndex;

	winClientBorder = PersonaClientBorderWindow(NewChild(class'PersonaClientBorderWindow'));

	winClientBorder.SetPos(clientBorderOffsetX, clientBorderOffsetY);
	winClientBorder.SetSize(clientBorderWidth, clientBorderHeight);
	winClientBorder.SetTextureLayout(clientBorderTextureCols, clientBorderTextureRows);

	// Set background textures
	for(clientBorderIndex=0; clientBorderIndex<arrayCount(clientBorderTextures); clientBorderIndex++)
	{
		winClientBorder.SetClientTexture(clientBorderIndex, clientBorderTextures[clientBorderIndex]);
	}
}

// ----------------------------------------------------------------------
// CreatePersonaHeaderText()
// ----------------------------------------------------------------------

function PersonaHeaderTextWindow CreatePersonaHeaderText(int posX, int posY, String strHeader, Window winParent)
{
	local PersonaHeaderTextWindow newHeader;

	newHeader = PersonaHeaderTextWindow(winParent.NewChild(Class'PersonaHeaderTextWindow'));

	newHeader.SetPos(posX, posY);
	newHeader.SetText(strHeader);

	return newHeader;
}

// ----------------------------------------------------------------------
// CreatePersonaButton()
// ----------------------------------------------------------------------

function PersonaActionButtonWindow CreatePersonaButton(
	int posX, 
	int posY, 
	int buttonWidth, 
	String strLabel, 
	Window winParent)
{
	local PersonaActionButtonWindow newButton;

	newButton = PersonaActionButtonWindow(winParent.NewChild(Class'PersonaActionButtonWindow'));

	newButton.SetPos(posX, posY);
	newButton.SetWidth(buttonWidth);
	newButton.SetButtonText(strLabel);

	return newButton;
}

// ----------------------------------------------------------------------
// CreateScrollAreaWindow()
// ----------------------------------------------------------------------

function PersonaScrollAreaWindow CreateScrollAreaWindow(Window winParent)
{
	return PersonaScrollAreaWindow(winParent.NewChild(Class'PersonaScrollAreaWindow'));
}

// ----------------------------------------------------------------------
// CreateScrollTileWindow()
// ----------------------------------------------------------------------

function TileWindow CreateScrollTileWindow(
	int posX, int posY,
	int sizeX, int sizeY)
{
	local TileWindow tileWindow;
	local PersonaScrollAreaWindow winScroll;

	winScroll = PersonaScrollAreaWindow(winClient.NewChild(Class'PersonaScrollAreaWindow'));
	winScroll.SetPos(posX, posY);
	winScroll.SetSize(sizeX, sizeY);

	tileWindow   = CreateTileWindow(winScroll.clipWindow);

	return tileWindow;
}

// ----------------------------------------------------------------------
// CreateTileWindow()
// ----------------------------------------------------------------------

function TileWindow CreateTileWindow(Window parent)
{
	local TileWindow tileWindow;

	// Create Tile Window inside the scroll window
	tileWindow = TileWindow(parent.NewChild(Class'TileWindow'));
	tileWindow.SetFont(Font'FontMenuSmall');
	tileWindow.SetOrder(ORDER_Down);
	tileWindow.SetChildAlignments(HALIGN_Full, VALIGN_Top);
	tileWindow.MakeWidthsEqual(False);
	tileWindow.MakeHeightsEqual(False);

	return tileWindow;
}

// ----------------------------------------------------------------------
// SaveSettings()
// ----------------------------------------------------------------------

function SaveSettings()
{
	// Play OK Sound
	// TODO: Change Menu sounds to HUD sounds
	PlaySound(Sound'Menu_OK', 0.25); 
}

// ----------------------------------------------------------------------
// AddLog()
// ----------------------------------------------------------------------

function AddLog(String logText)
{
	if (winStatus != None)
		winStatus.AddText(logText);
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;
	local Color colCursor;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colCursor = theme.GetColorFromName('HUDColor_Cursor');

	SetDefaultCursor(Texture'DeusExCursor2', Texture'DeusExCursor2_Shadow', 32, 32, colCursor);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     screenWidth=640
     screenHeight=480
     clientBorderWidth=640
     clientBorderHeight=450
     clientBorderOffsetY=30
     ScreenType=ST_Persona
}
