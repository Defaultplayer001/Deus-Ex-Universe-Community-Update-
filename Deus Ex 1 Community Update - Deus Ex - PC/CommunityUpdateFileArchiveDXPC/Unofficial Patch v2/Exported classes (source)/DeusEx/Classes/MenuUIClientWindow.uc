//=============================================================================
// MenuUIClientWindow
//=============================================================================

class MenuUIClientWindow extends Window;

var Texture clientTextures[6];
var int texturePosX[6];
var int texturePosY[6];

var int textureRows;
var int textureCols;
var int textureCount;
var int textureIndex;

var DeusExPlayer player;

// Default colors/translucency
var EDrawStyle backgroundDrawStyle;
var Color colBackground;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
	
	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	StyleChanged();
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	// Draw window background
	gc.SetStyle(backgroundDrawStyle);
	gc.SetTileColor(colBackground);

	for(textureIndex=0; textureIndex<textureCount; textureIndex++)
	{
		gc.DrawIcon(
			texturePosX[textureIndex], 
			texturePosY[textureIndex], 
			clientTextures[textureIndex]);		
	}
}

// ----------------------------------------------------------------------
// SetClientTexture()
// ----------------------------------------------------------------------

function SetClientTexture(int textureIndex, Texture newTexture)
{
	if ((textureIndex >= 0) && (textureIndex < arrayCount(clientTextures)))
		clientTextures[textureIndex] = newTexture;
}

// ----------------------------------------------------------------------
// SetTextureLayout()
// ----------------------------------------------------------------------

function SetTextureLayout(int newTextureCols, int newTextureRows)
{
	textureCols = newTextureCols;
	textureRows = newTextureRows;

	CalculateTexturePositions();
}

// ----------------------------------------------------------------------
// CalculateTexturePositions()
//
// Do this once so we don't have to do it every time in the 
// DrawWindow() event
// ----------------------------------------------------------------------

function CalculateTexturePositions()
{
	local int rowIndex;
	local int colIndex;

	textureCount = 0;

	for(rowIndex=0; rowIndex<textureRows; rowIndex++)
	{
		for(colIndex=0; colIndex<textureCols; colIndex++)
		{
			texturePosX[textureCount] = colIndex * 256;
			texturePosY[textureCount] = rowIndex * 256;
			textureCount++;
		}
	}
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	// Translucency
	if (player.GetMenuTranslucency())
		backgroundDrawStyle = DSTY_Translucent;
	else
		backgroundDrawStyle = DSTY_Masked;

	// Background color
	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	colBackground = theme.GetColorFromName('MenuColor_Background');
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
