//=============================================================================
// PersonaNavBarWindow
//=============================================================================
class PersonaNavBarWindow expands PersonaNavBarBaseWindow;

var PersonaNavButtonWindow btnInventory;
var PersonaNavButtonWindow btnHealth;
var PersonaNavButtonWindow btnAugs;
var PersonaNavButtonWindow btnSkills;
var PersonaNavButtonWindow btnGoals;
var PersonaNavButtonWindow btnCons;
var PersonaNavButtonWindow btnImages;
var PersonaNavButtonWindow btnLogs;

var localized String InventoryButtonLabel;
var localized String HealthButtonLabel;
var localized String AugsButtonLabel;
var localized String SkillsButtonLabel;
var localized String GoalsButtonLabel;
var localized String ConsButtonLabel;
var localized String ImagesButtonLabel;
var localized String LogsButtonLabel;

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	btnLogs      = CreateNavButton(winNavButtons, LogsButtonLabel);
	btnImages    = CreateNavButton(winNavButtons, ImagesButtonLabel);
	btnCons      = CreateNavButton(winNavButtons, ConsButtonLabel);
	btnGoals     = CreateNavButton(winNavButtons, GoalsButtonLabel);
	btnSkills    = CreateNavButton(winNavButtons, SkillsButtonLabel);
	btnAugs      = CreateNavButton(winNavButtons, AugsButtonLabel);
	btnHealth    = CreateNavButton(winNavButtons, HealthButtonLabel);
	btnInventory = CreateNavButton(winNavButtons, InventoryButtonLabel);

	Super.CreateButtons();
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;
	local Class<PersonaScreenBaseWindow> winClass;

	bHandled = True;

	switch(buttonPressed)
	{
		case btnInventory:
			winClass = Class'PersonaScreenInventory';
			break;

		case btnHealth:
			winClass = Class'PersonaScreenHealth';
			break;

		case btnAugs:
			winClass = Class'PersonaScreenAugmentations';
			break;

		case btnSkills:
			winClass = Class'PersonaScreenSkills';
			break;

		case btnGoals:
			winClass = Class'PersonaScreenGoals';
			break;

		case btnCons:
			winClass = Class'PersonaScreenConversations';
			break;

		case btnImages:
			winClass = Class'PersonaScreenImages';
			break;

		case btnLogs:
			winClass = Class'PersonaScreenLogs';
			break;

		default:
			bHandled = False;
			break;
	}

	if (bHandled)
	{
		PersonaScreenBaseWindow(GetParent()).SaveSettings();
		root.InvokeUIScreen(winClass);
		return bHandled;
	}
	else
	{
		return Super.ButtonActivated(buttonPressed);
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     InventoryButtonLabel="|&Inventory"
     HealthButtonLabel="|&Health"
     AugsButtonLabel="|&Augs"
     SkillsButtonLabel="|&Skills"
     GoalsButtonLabel="|&Goals/Notes"
     ConsButtonLabel="|&Conversations"
     ImagesButtonLabel="I|&mages"
     LogsButtonLabel="|&Logs"
}
