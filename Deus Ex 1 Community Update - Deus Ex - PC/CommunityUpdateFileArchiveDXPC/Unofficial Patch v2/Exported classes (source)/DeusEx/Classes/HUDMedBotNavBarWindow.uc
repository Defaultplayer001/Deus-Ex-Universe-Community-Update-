//=============================================================================
// HUDMedBotNavBarWindow
//=============================================================================
class HUDMedBotNavBarWindow expands PersonaNavBarBaseWindow;

var PersonaNavButtonWindow btnHealth;
var PersonaNavButtonWindow btnAugs;

var localized String HealthButtonLabel;
var localized String AugsButtonLabel;

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	btnAugs      = CreateNavButton(winNavButtons, AugsButtonLabel);
	btnHealth    = CreateNavButton(winNavButtons, HealthButtonLabel);

	Super.CreateButtons();
}

// ----------------------------------------------------------------------
// CreateButtonWindow()
// ----------------------------------------------------------------------

function CreateButtonWindows()
{
	Super.CreateButtonWindows();

	winNavButtons.FillAllSpace(False);
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated(Window buttonPressed)
{
	local bool bHandled;
	local HUDMedBotHealthScreen healthScreen;
	local HUDMedBotAddAugsScreen augScreen;
	local MedicalBot medBot;

	bHandled = True;

	switch(buttonPressed)
	{
		case btnHealth:
			// Need to be sure the MedBot variable is set in the 
			// Health Screen when we bring it up

			augScreen = HUDMedBotAddAugsScreen(GetParent());
			if (augScreen != None)
			{
				augScreen.SkipAnimation(True);
				medBot = augScreen.medBot;
			}

			// Invoke the health screen
			healthScreen = HUDMedBotHealthScreen(root.InvokeUIScreen(Class'HUDMedBotHealthScreen', True));

			// Now set the medBot if it's not none
			if (medBot != None)
				healthScreen.SetMedicalBot(medBot);

			break;

		case btnAugs:
			// Need to be sure the MedBot variable is set in the 
			// Health Screen when we bring it up

			healthScreen = HUDMedBotHealthScreen(GetParent());
			if (healthScreen != None)
			{
				healthScreen.SkipAnimation(True);
				medBot = healthScreen.medBot;
			}

			augScreen = HUDMedBotAddAugsScreen(root.InvokeUIScreen(Class'HUDMedBotAddAugsScreen', True));

			// Now set the medBot if it's not none
			if (medBot != None)
				augScreen.SetMedicalBot(medBot);

			break;

		default:
			bHandled = False;
			break;
	}

	if (bHandled)
		return bHandled;
	else
		return Super.ButtonActivated(buttonPressed);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HealthButtonLabel=" |&Health   "
     AugsButtonLabel="   |&Augmentations   "
}
