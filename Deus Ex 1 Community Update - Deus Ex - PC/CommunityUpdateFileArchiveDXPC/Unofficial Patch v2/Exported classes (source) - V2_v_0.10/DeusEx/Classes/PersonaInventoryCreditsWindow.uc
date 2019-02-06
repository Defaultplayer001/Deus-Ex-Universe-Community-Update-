//=============================================================================
// PersonaInventoryCreditsWindow
//=============================================================================

class PersonaInventoryCreditsWindow extends TileWindow;

var PersonaHeaderTextWindow winCredits;

var localized String CreditsLabel;

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
	SetMinorSpacing(5);
	MakeWidthsEqual(False);
	MakeHeightsEqual(True);

	CreateControls();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	local PersonaHeaderTextWindow winLabel;

	winLabel = PersonaHeaderTextWindow(NewChild(Class'PersonaHeaderTextWindow'));
	winLabel.SetHeight(15);
	winLabel.SetText(CreditsLabel);

	winCredits = PersonaHeaderTextWindow(NewChild(Class'PersonaHeaderTextWindow'));
	winCredits.SetSize(63, 15);
	winCredits.SetTextAlignments(HALIGN_Right, VALIGN_Center);
}

// ----------------------------------------------------------------------
// SetCredits()
// ----------------------------------------------------------------------

function SetCredits(int newCredits)
{
	winCredits.SetText(String(newCredits));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     CreditsLabel="Credits"
}
