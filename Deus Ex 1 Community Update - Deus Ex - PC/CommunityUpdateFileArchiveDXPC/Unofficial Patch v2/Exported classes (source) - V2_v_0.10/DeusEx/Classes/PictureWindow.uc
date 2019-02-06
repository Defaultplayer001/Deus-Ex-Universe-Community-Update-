//=============================================================================
// PictureWindow
//=============================================================================
class PictureWindow expands Window;

var Texture PictureTextures[6];
var Int textureIndex;
var Int colIndex, rowIndex;
var Int textureRows;
var Int textureCols;

// ----------------------------------------------------------------------
// SetTextures()
// ----------------------------------------------------------------------

function SetTextures(Texture newPictureTextures[6], int newTextureCols, int newTextureRows)
{
	textureRows = newTextureRows;
	textureCols = newTextureCols;

	for(textureIndex=0; textureIndex<arrayCount(pictureTextures); textureIndex++)
		pictureTextures[textureIndex] = newPictureTextures[textureIndex];
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	// Draw window background
	gc.SetStyle(DSTY_Masked);

	textureIndex = 0;

	for(rowIndex=0; rowIndex<textureRows; rowIndex++)
	{
		for(colIndex=0; colIndex<textureCols; colIndex++)
		{
			gc.DrawIcon(colIndex * 256, rowIndex * 256, pictureTextures[textureIndex]);
			textureIndex++;
		}
	}
}

defaultproperties
{
}
