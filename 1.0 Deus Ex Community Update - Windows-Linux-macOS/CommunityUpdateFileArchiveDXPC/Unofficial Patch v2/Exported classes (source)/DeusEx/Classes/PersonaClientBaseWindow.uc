//=============================================================================
// PersonaClientBaseWindow
//=============================================================================

class PersonaClientBaseWindow extends PersonaBaseWindow;

var Texture clientTextures[6];
var int texturePosX[6];
var int texturePosY[6];

var int textureRows;
var int textureCols;
var int textureCount;
var int textureIndex;

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
// ----------------------------------------------------------------------

defaultproperties
{
}
