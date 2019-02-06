//=============================================================================
// ToolBorderWindow
//=============================================================================
class ToolBorderWindow expands BorderWindow;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetBorders(
		Texture'ToolWindowListBorder_TL', Texture'ToolWindowListBorder_TR', 
		Texture'ToolWindowListBorder_BL', Texture'ToolWindowListBorder_BR',
		Texture'ToolWindowListBorder_L',  Texture'ToolWindowListBorder_R',
		Texture'ToolWindowListBorder_T',  Texture'ToolWindowListBorder_B'); 

	SetBorderStyle(DSTY_Normal);
	BaseMarginsFromBorder(True);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
