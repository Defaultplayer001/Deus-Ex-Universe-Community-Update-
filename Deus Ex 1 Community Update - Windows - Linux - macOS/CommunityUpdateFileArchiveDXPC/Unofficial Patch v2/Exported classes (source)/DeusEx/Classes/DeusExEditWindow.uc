//=============================================================================
// DeusExEditWindow
//=============================================================================
class DeusExEditWindow expands EditWindow;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetTextAlignments( HALIGN_Left, VALIGN_Top );
	SetInsertionPointType(INSTYPE_Insert);
	SetEditCursor(Texture'DeusExEditCursor');
}

defaultproperties
{
}
