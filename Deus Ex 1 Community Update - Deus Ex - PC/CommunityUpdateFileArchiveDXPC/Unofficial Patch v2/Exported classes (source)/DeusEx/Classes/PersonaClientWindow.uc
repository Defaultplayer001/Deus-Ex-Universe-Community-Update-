//=============================================================================
// PersonaClientWindow
//=============================================================================

class PersonaClientWindow extends PersonaClientBaseWindow;

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

event DrawBackground(GC gc)
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

defaultproperties
{
}
