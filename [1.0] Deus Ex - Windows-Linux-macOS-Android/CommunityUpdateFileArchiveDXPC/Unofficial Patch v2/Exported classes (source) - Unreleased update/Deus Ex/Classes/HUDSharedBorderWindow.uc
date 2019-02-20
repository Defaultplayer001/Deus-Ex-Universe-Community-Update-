//=============================================================================
// HUDSharedBorderWindow
//=============================================================================
class HUDSharedBorderWindow expands HUDBaseWindow;

// ----------------------------------------------------------------------
// Local Variables
// ----------------------------------------------------------------------

var int     minHeight;
var int     topMargin;
var int     bottomMargin;
var Texture texBackgrounds[9];
var Texture texBorders[9];

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
	gc.SetStyle(backgroundDrawStyle);
	gc.SetTileColor(colBackground);
	gc.DrawBorders(0, 0, width, height, 0, 0, 0, 0, texBackgrounds);
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
		gc.DrawBorders(0, 0, width, height, 0, 0, 0, 0, texBorders);
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     MinHeight=40
     TopMargin=13
     BottomMargin=10
     texBackgrounds(0)=Texture'DeusExUI.UserInterface.HUDWindowBackground_TL'
     texBackgrounds(1)=Texture'DeusExUI.UserInterface.HUDWindowBackground_TR'
     texBackgrounds(2)=Texture'DeusExUI.UserInterface.HUDWindowBackground_BL'
     texBackgrounds(3)=Texture'DeusExUI.UserInterface.HUDWindowBackground_BR'
     texBackgrounds(4)=Texture'DeusExUI.UserInterface.HUDWindowBackground_Left'
     texBackgrounds(5)=Texture'DeusExUI.UserInterface.HUDWindowBackground_Right'
     texBackgrounds(6)=Texture'DeusExUI.UserInterface.HUDWindowBackground_Top'
     texBackgrounds(7)=Texture'DeusExUI.UserInterface.HUDWindowBackground_Bottom'
     texBackgrounds(8)=Texture'DeusExUI.UserInterface.HUDWindowBackground_Center'
     texBorders(0)=Texture'DeusExUI.UserInterface.HUDWindowBorder_TL'
     texBorders(1)=Texture'DeusExUI.UserInterface.HUDWindowBorder_TR'
     texBorders(2)=Texture'DeusExUI.UserInterface.HUDWindowBorder_BL'
     texBorders(3)=Texture'DeusExUI.UserInterface.HUDWindowBorder_BR'
     texBorders(4)=Texture'DeusExUI.UserInterface.HUDWindowBorder_Left'
     texBorders(5)=Texture'DeusExUI.UserInterface.HUDWindowBorder_Right'
     texBorders(6)=Texture'DeusExUI.UserInterface.HUDWindowBorder_Top'
     texBorders(7)=Texture'DeusExUI.UserInterface.HUDWindowBorder_Bottom'
     texBorders(8)=Texture'DeusExUI.UserInterface.HUDWindowBorder_Center'
}
