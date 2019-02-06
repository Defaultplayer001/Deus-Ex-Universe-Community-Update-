//=============================================================================
// HUDMedBotHealthScreen
//=============================================================================

class HUDMedBotHealthScreen extends PersonaScreenHealth;

var MedicalBot medBot;
var ProgressBarWindow winHealthBar;
var TextWindow winHealthBarText;
var PersonaNormalTextWindow winHealthInfoText;
var Bool bSkipAnimation;

var Localized String MedbotInterfaceText;
var Localized String HealthInfoTextLabel;
var Localized String MedBotRechargingLabel;
var Localized String MedBotReadyLabel;
var Localized String MedBotYouAreHealed;
var Localized String SecondsPluralLabel;
var Localized String SecondsSingularLabel;
var Localized String ReadyLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	HUDMedBotNavBarWindow(winNavBar).btnHealth.SetSensitivity(False);

	bTickEnabled = True;

	EnableButtons();
}

// ----------------------------------------------------------------------
// DestroyWindow()
//
// Let the medbot go about its business.
// ----------------------------------------------------------------------

event DestroyWindow()
{
	if (medBot != None)
	{
		if (!bSkipAnimation)
		{
			medBot.PlayAnim('Stop');
			medBot.PlaySound(sound'MedicalBotLowerArm', SLOT_None);
			medBot.FollowOrders();
		}
	}

	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	UpdateMedBotDisplay();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	CreateNavBarWindow();
	CreateClientBorderWindow();
	CreateClientWindow();

	CreateTitleWindow(9, 5, HealthTitleText);
	CreateInfoWindow();
	CreateOverlaysWindow();
	CreateBodyWindow();
	CreateRegionWindows();
	CreateButtons();
	CreatePartButtons();
	CreateRegionWindows();
	CreateMedbotLabel();
	CreateMedBotDisplay();
	CreateStatusWindow();
}

// ----------------------------------------------------------------------
// CreateStatusWindow()
// ----------------------------------------------------------------------

function CreateStatusWindow()
{
	winStatus = PersonaStatusLineWindow(winClient.NewChild(Class'PersonaStatusLineWindow'));
	winStatus.SetPos(15, 410);
	winStatus.SetWidth(291);
}

// ----------------------------------------------------------------------
// CreateNavBarWindow()
// ----------------------------------------------------------------------

function CreateNavBarWindow()
{
	winNavBar = PersonaNavBarBaseWindow(NewChild(Class'HUDMedBotNavBarWindow')); 
	winNavBar.SetPos(0, 0);
}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
	winInfo = PersonaInfoWindow(winClient.NewChild(Class'PersonaInfoWindow'));
	winInfo.SetPos(348, 22);
	winInfo.SetSize(238, 243);
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	local PersonaButtonBarWindow winActionButtons;

	winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(346, 346);
	winActionButtons.SetWidth(97);
	winActionButtons.FillAllSpace(False);

	btnHealAll = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnHealAll.SetButtonText(HealAllButtonLabel);
}

// ----------------------------------------------------------------------
// CreateOverlaysWindow()
// ----------------------------------------------------------------------

function CreateOverlaysWindow()
{
	winOverlays = PersonaOverlaysWindow(winClient.NewChild(Class'HUDMedBotHealthOverlaysWindow'));
	winOverlays.SetPos(24, 36);
	winOverlays.Lower();
}

// ----------------------------------------------------------------------
// CreateMedbotLabel()
// ----------------------------------------------------------------------

function CreateMedbotLabel()
{
	local PersonaHeaderTextWindow txtLabel;

	txtLabel = PersonaHeaderTextWindow(NewChild(Class'PersonaHeaderTextWindow'));
	txtLabel.SetPos(305, 9);
	txtLabel.SetSize(250, 16);
	txtLabel.SetTextAlignments(HALIGN_Right, VALIGN_Center);
	txtLabel.SetText(MedbotInterfaceText);
}

// ----------------------------------------------------------------------
// CreateMedBotDisplay()
// ----------------------------------------------------------------------

function CreateMedBotDisplay()
{
	winHealthBar = ProgressBarWindow(winClient.NewChild(Class'ProgressBarWindow'));

	winHealthBar.SetPos(446, 348);
	winHealthBar.SetSize(140, 12);
	winHealthBar.SetValues(0, 100);
	winHealthBar.UseScaledColor(True);
	winHealthBar.SetVertical(False);
	winHealthBar.SetScaleColorModifier(0.5);
	winHealthBar.SetDrawBackground(False);

	winHealthBarText = TextWindow(winClient.NewChild(Class'TextWindow'));
	winHealthBarText.SetPos(446, 349);
	winHealthBarText.SetSize(140, 12);
	winHealthBarText.SetTextMargins(0, 0);
	winHealthBarText.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winHealthBarText.SetFont(Font'FontMenuSmall_DS');
	winHealthBarText.SetTextColorRGB(255, 255, 255);

	winHealthInfoText = PersonaNormalTextWindow(winClient.NewChild(Class'PersonaNormalTextWindow'));
	winHealthInfoText.SetPos(348, 293);
	winHealthInfoText.SetSize(238, 50);
	winHealthInfoText.SetTextMargins(2, 0);
}

// ----------------------------------------------------------------------
// UpdateMedBotDisplay()
// ----------------------------------------------------------------------

function UpdateMedBotDisplay()
{
	local float barPercent;
	local String infoText;
	local float secondsRemaining;

	if (medBot != None)
	{
		infoText = Sprintf(HealthInfoTextLabel, medBot.healAmount);

		// Update the bar
		if (medBot.CanHeal())
		{		
			winHealthBar.SetCurrentValue(100);
			winHealthBarText.SetText(ReadyLabel);

			if (IsPlayerDamaged())
				infoText = infoText $ MedBotReadyLabel;
			else
				infoText = infoText $ MedBotYouAreHealed;
		}
		else
		{
			secondsRemaining = medBot.GetRefreshTimeRemaining();

			barPercent = 100 * (1.0 - (secondsRemaining / Float(medBot.healRefreshTime)));

			winHealthBar.SetCurrentValue(barPercent);

			if (secondsRemaining == 1)
				winHealthBarText.SetText(Sprintf(SecondsSingularLabel, Int(secondsRemaining)));
			else
				winHealthBarText.SetText(Sprintf(SecondsPluralLabel, Int(secondsRemaining)));

			if (IsPlayerDamaged())
				infoText = infoText $ MedBotRechargingLabel;
			else
				infoText = infoText $ MedBotYouAreHealed;
		}

		winHealthInfoText.SetText(infoText);
	}

	EnableButtons();
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated(Window buttonPressed)
{
	local bool bHandled;

	bHandled = True;

	switch(buttonPressed)
	{
		case btnHealAll:
			MedBotHealPlayer();
			break;

		default:
			bHandled = False;
			break;
	}

	if (bHandled)
		return True;
	else 
		return Super.ButtonActivated(buttonPressed);
}

// ----------------------------------------------------------------------
// MedBotHealPlayer()
// ----------------------------------------------------------------------

function MedBotHealPlayer()
{
	medBot.HealPlayer(player);
	UpdateMedBotDisplay();
	UpdateRegionWindows();
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	if (medBot != None)
		btnHealAll.EnableWindow(medBot.CanHeal() && IsPlayerDamaged());
	else
		btnHealAll.EnableWindow(False);
}

// ----------------------------------------------------------------------
// SetMedicalBot()
// ----------------------------------------------------------------------

function SetMedicalBot(MedicalBot newBot, optional bool bPlayAnim)
{
	medBot = newBot;

	if (medBot != None)
	{
		medBot.StandStill();

		if (bPlayAnim)
		{
			medBot.PlayAnim('Start');
			medBot.PlaySound(sound'MedicalBotRaiseArm', SLOT_None);
		}
	}
}

// ----------------------------------------------------------------------
// SkipAnimation()
// ----------------------------------------------------------------------

function SkipAnimation(bool bNewSkipAnimation)
{
	bSkipAnimation = bNewSkipAnimation;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     MedbotInterfaceText="MEDBOT INTERFACE"
     HealthInfoTextLabel="The MedBot will heal up to %d units, which are distributed evenly among your damaged body regions."
     MedBotRechargingLabel="|nThe MedBot is currently Recharging.  Please Wait."
     MedBotReadyLabel="|nThe MedBot is Ready, you may now be Healed."
     MedBotYouAreHealed="|nYou are currently in Full Health."
     SecondsPluralLabel="Recharging: %d seconds"
     SecondsSingularLabel="Recharging: %d second"
     ReadyLabel="Ready!"
     bShowHealButtons=False
     HealAllButtonLabel="  H|&eal All  "
     clientTextures(0)=Texture'DeusExUI.UserInterface.HUDMedbotHealthBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.HUDMedbotHealthBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.HUDMedbotHealthBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.HUDMedbotHealthBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.HUDMedbotHealthBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.HUDMedbotHealthBackground_6'
     clientBorderTextures(0)=Texture'DeusExUI.UserInterface.HUDMedBotHealthBorder_1'
     clientBorderTextures(1)=Texture'DeusExUI.UserInterface.HUDMedBotHealthBorder_2'
     clientBorderTextures(2)=Texture'DeusExUI.UserInterface.HUDMedBotHealthBorder_3'
     clientBorderTextures(3)=Texture'DeusExUI.UserInterface.HUDMedBotHealthBorder_4'
     clientBorderTextures(4)=Texture'DeusExUI.UserInterface.HUDMedBotHealthBorder_5'
     clientBorderTextures(5)=Texture'DeusExUI.UserInterface.HUDMedBotHealthBorder_6'
}
