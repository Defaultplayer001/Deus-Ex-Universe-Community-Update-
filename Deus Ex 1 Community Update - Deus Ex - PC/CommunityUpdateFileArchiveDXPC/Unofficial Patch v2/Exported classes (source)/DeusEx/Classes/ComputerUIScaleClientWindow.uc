//=============================================================================
// ComputerUIScaleClientWindow
//=============================================================================

class ComputerUIScaleClientWindow extends MenuUIClientWindow;

var int numMiddleTextures;

var int topHeight;
var int middleHeight;
var int bottomHeight;

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	local int textureIndex;
	local int middlePosY;
	local int colIndex;
	local int middleIndex;
	local int middleTextureIndex;

	// Draw window background
	gc.SetStyle(backgroundDrawStyle);
	gc.SetTileColor(colBackground);

	textureIndex = 0;
	middlePosY   = 0;

	// Draw top textures
	for(colIndex=0; colIndex<textureCols; colIndex++)
		gc.DrawIcon(colIndex * 256, 0, clientTextures[textureIndex++]);

	// Draw middle textures
	for(middleIndex=0; middleIndex<numMiddleTextures; middleIndex++)
	{
		middleTextureIndex = textureIndex;
		for(colIndex=0; colIndex<textureCols; colIndex++)
		{
			gc.DrawIcon(colIndex * 256, topHeight + middlePosY, clientTextures[middleTextureIndex++]);		
		}

		middlePosY += middleHeight;
	}

	textureIndex = middleTextureIndex;

	// Draw bottom textures
	for(colIndex=0; colIndex<textureCols; colIndex++)
		gc.DrawIcon(colIndex * 256, topHeight + middlePosY, clientTextures[textureIndex++]);
}

// ----------------------------------------------------------------------
// SetTextureHeights()
// ----------------------------------------------------------------------

function SetTextureHeights(int newTopHeight, int newMiddleHeight, int newBottomHeight)
{
	topHeight    = newTopHeight;
	middleHeight = newMiddleHeight;
	bottomHeight = newBottomHeight;
}

// ----------------------------------------------------------------------
// SetNumMiddleTextures()
// ----------------------------------------------------------------------

function SetNumMiddleTextures(int newNum)
{
	numMiddleTextures = newNum;

	// Now calculate and set the height of the window
	// (width should already be set at this point)

	SetHeight(topHeight + (middleHeight * numMiddleTextures) + bottomHeight);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     numMiddleTextures=1
}
