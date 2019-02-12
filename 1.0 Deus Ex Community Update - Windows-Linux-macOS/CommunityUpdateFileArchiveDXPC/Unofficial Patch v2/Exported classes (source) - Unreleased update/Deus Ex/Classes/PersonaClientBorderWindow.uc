//=============================================================================
// PersonaClientBorderWindow
//=============================================================================

class PersonaClientBorderWindow extends PersonaClientBaseWindow;

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

event DrawBorder(GC gc)
{	
	if (bDrawBorder)
	{
		// Draw window background
		gc.SetStyle(borderDrawStyle);
		gc.SetTileColor(colBorder);

		for(textureIndex=0; textureIndex<textureCount; textureIndex++)
		{
			gc.DrawIcon(
				texturePosX[textureIndex], 
				texturePosY[textureIndex], 
				clientTextures[textureIndex]);		
		}
	}
}

defaultproperties
{
}
