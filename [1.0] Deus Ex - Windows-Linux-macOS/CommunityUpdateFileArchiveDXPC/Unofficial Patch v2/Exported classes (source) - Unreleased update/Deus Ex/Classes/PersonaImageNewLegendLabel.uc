//=============================================================================
// PersonaImageNewLegendLabel
//=============================================================================

class PersonaImageNewLegendLabel extends TileWindow;

var PersonaHeaderTextWindow winLegend;
var PersonaHeaderTextWindow winIcon;

var localized String NewLegendLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetOrder(ORDER_Right);
	SetChildAlignments(HALIGN_Full, VALIGN_Top);
	SetMargins(0, 0);
	SetMinorSpacing(0);
	MakeWidthsEqual(False);
	MakeHeightsEqual(True);

	CreateControls();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	winIcon = PersonaHeaderTextWindow(NewChild(Class'PersonaHeaderTextWindow'));
	winIcon.SetFont(Font'FontHUDWingDings');
	winIcon.SetText("C");

	winLegend = PersonaHeaderTextWindow(NewChild(Class'PersonaHeaderTextWindow'));
	winLegend.SetText(NewLegendLabel);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     NewLegendLabel=" = New Image"
}
