//=============================================================================
// HUDRechargeWindow
//
// Used to allow the user to recharge energy
//=============================================================================

class HUDRechargeWindow extends DeusExBaseWindow;

var DeusExPlayer player;

// Border and Background Translucency
var bool bBorderTranslucent;
var bool bBackgroundTranslucent;
var bool bDrawBorder;

// Default Colors
var Color colBackground;
var Color colBorder;
var Color colHeaderText;
var Color colText;

var Texture texBackground[2];
var Texture texBorder[2];

var PersonaHeaderTextWindow winTitle;
var PersonaNormalTextWindow winInfo;

var PersonaActionButtonWindow btnRecharge;
var PersonaActionButtonWindow btnClose;
var RepairBot repairBot;
var Float lastRefresh;
var Float refreshInterval;

var ProgressBarWindow winBioBar;
var TextWindow winBioBarText;
var PersonaNormalTextWindow winBioInfoText;

var ProgressBarWindow winRepairBotBar;
var TextWindow winRepairBotBarText;
var PersonaNormalTextWindow winRepairBotInfoText;

var localized String RechargeButtonLabel;
var localized String CloseButtonLabel;
var localized String RechargeTitle;
var localized String RepairBotInfoText;
var localized String RepairBotStatusLabel;
var localized String ReadyLabel;
var Localized String SecondsPluralLabel;
var Localized String SecondsSingularLabel;
var Localized String BioStatusLabel;
var Localized String RepairBotRechargingLabel;
var Localized String RepairBotReadyLabel;
var Localized String RepairBotYouAreHealed;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	SetSize(265, 153);

	CreateControls();
	EnableButtons();

	bTickEnabled = TRUE;

	StyleChanged();
}

// ----------------------------------------------------------------------
// DestroyWindow()
//
// Let the RepairBot go about its business.
// ----------------------------------------------------------------------

event DestroyWindow()
{
	if (repairBot != None)
	{
		repairBot.PlayAnim('Stop');
		repairBot.PlaySound(sound'RepairBotLowerArm', SLOT_None);
		repairBot.FollowOrders();
	}

	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	// First draw the background then the border
	DrawBackground(gc);

	// Don't call the DrawBorder routines if 
	// they are disabled
	if (bDrawBorder)
		DrawBorder(gc);
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
	if (bBackgroundTranslucent)
		gc.SetStyle(DSTY_Translucent);
	else
		gc.SetStyle(DSTY_Masked);
	
	gc.SetTileColor(colBackground);

	gc.DrawTexture(0,   0, 256, height, 0, 0, texBackground[0]);
	gc.DrawTexture(256, 0, 9,   height, 0, 0, texBackground[1]);
}

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

function DrawBorder(GC gc)
{
	if (bDrawBorder)
	{
		if (bBorderTranslucent)
			gc.SetStyle(DSTY_Translucent);
		else
			gc.SetStyle(DSTY_Masked);
		
		gc.SetTileColor(colBorder);

		gc.DrawTexture(0,   0, 256, height, 0, 0, texBorder[0]);
		gc.DrawTexture(256, 0, 9,   height, 0, 0, texBorder[1]);
	}
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
	if (lastRefresh >= refreshInterval)
	{
		lastRefresh = 0.0;
		UpdateRepairBotWindows();
		UpdateInfoText();
		EnableButtons();
	}
	else
	{
		lastRefresh += deltaSeconds;
	}
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	CreateTitleWindow();
	CreateInfoWindow();
	CreateBioWindows();
	CreateRepairbotWindows();
	CreateButtons();
}

// ----------------------------------------------------------------------
// CreateTitleWindow()
// ----------------------------------------------------------------------

function CreateTitleWindow()
{
	winTitle = PersonaHeaderTextWindow(NewChild(Class'PersonaHeaderTextWindow'));
	winTitle.SetTextAlignments(HALIGN_Left, VALIGN_Center);
	winTitle.SetText(RechargeTitle);
	winTitle.SetPos(20, 20);
	winTitle.SetSize(233, 14);
}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
	winInfo = PersonaNormalTextWindow(NewChild(Class'PersonaNormalTextWindow'));
	winInfo.SetTextAlignments(HALIGN_Left, VALIGN_Center);
	winInfo.SetPos(20, 39);
	winInfo.SetSize(233, 44);
}

// ----------------------------------------------------------------------
// CreateBioWindows()
// ----------------------------------------------------------------------

function CreateBioWindows()
{
	winBioBar = ProgressBarWindow(NewChild(Class'ProgressBarWindow'));

	winBioBar.SetPos(114, 91);
	winBioBar.SetSize(140, 12);
	winBioBar.SetValues(0, 100);
	winBioBar.UseScaledColor(True);
	winBioBar.SetVertical(False);
	winBioBar.SetScaleColorModifier(0.5);
	winBioBar.SetDrawBackground(False);

	winBioBarText = TextWindow(NewChild(Class'TextWindow'));
	winBioBarText.SetPos(114, 93);
	winBioBarText.SetSize(140, 12);
	winBioBarText.SetTextMargins(0, 0);
	winBioBarText.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winBioBarText.SetFont(Font'FontMenuSmall_DS');
	winBioBarText.SetTextColorRGB(255, 255, 255);

	winBioInfoText = PersonaNormalTextWindow(NewChild(Class'PersonaNormalTextWindow'));
	winBioInfoText.SetPos(20, 92);
	winBioInfoText.SetSize(90, 12);
	winBioInfoText.SetTextMargins(0, 0);

	UpdateBioWindows();
}

// ----------------------------------------------------------------------
// CreateRepairbotWindows()
// ----------------------------------------------------------------------

function CreateRepairbotWindows()
{
	winRepairBotBar = ProgressBarWindow(NewChild(Class'ProgressBarWindow'));

	winRepairBotBar.SetPos(114, 111);
	winRepairBotBar.SetSize(140, 12);
	winRepairBotBar.SetValues(0, 100);
	winRepairBotBar.UseScaledColor(True);
	winRepairBotBar.SetVertical(False);
	winRepairBotBar.SetScaleColorModifier(0.5);
	winRepairBotBar.SetDrawBackground(False);

	winRepairBotBarText = TextWindow(NewChild(Class'TextWindow'));
	winRepairBotBarText.SetPos(114, 113);
	winRepairBotBarText.SetSize(140, 12);
	winRepairBotBarText.SetTextMargins(0, 0);
	winRepairBotBarText.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winRepairBotBarText.SetFont(Font'FontMenuSmall_DS');
	winRepairBotBarText.SetTextColorRGB(255, 255, 255);

	winRepairBotInfoText = PersonaNormalTextWindow(NewChild(Class'PersonaNormalTextWindow'));
	winRepairBotInfoText.SetPos(20, 112);
	winRepairBotInfoText.SetSize(90, 12);
	winRepairBotInfoText.SetTextMargins(0, 0);
}

// ----------------------------------------------------------------------
// UpdateInfoText()
// ----------------------------------------------------------------------

function UpdateInfoText()
{
	local String infoText;

	if (repairBot != None)
	{
		infoText = Sprintf(RepairBotInfoText, repairBot.chargeAmount, repairBot.chargeRefreshTime);

		if (player.Energy >= player.EnergyMax)
			infoText = infoText $ RepairBotYouAreHealed;
		else if (repairBot.CanCharge())
			infoText = infoText $ RepairBotReadyLabel;
		else
			infoText = infoText $ RepairBotRechargingLabel;

		winInfo.SetText(infoText);
	}
}

// ----------------------------------------------------------------------
// UpdateBioWindows()
// ----------------------------------------------------------------------

function UpdateBioWindows()
{
	local float energyPercent;

	energyPercent = 100.0 * (player.Energy / player.EnergyMax);
	winBioBar.SetCurrentValue(energyPercent);

	winBioBarText.SetText(String(Int(energyPercent)) $ "%");

	winBioInfoText.SetText(BioStatusLabel);
}

// ----------------------------------------------------------------------
// UpdateRepairBotWindows()
// ----------------------------------------------------------------------

function UpdateRepairBotWindows()
{
	local float barPercent;
	local String infoText;
	local float secondsRemaining;

	if (repairBot != None)
	{
		// Update the bar
		if (repairBot.CanCharge())
		{		
			winRepairBotBar.SetCurrentValue(100);
			winRepairBotBarText.SetText(ReadyLabel);
		}
		else
		{
			secondsRemaining = repairBot.GetRefreshTimeRemaining();

			barPercent = 100 * (1.0 - (secondsRemaining / Float(repairBot.chargeRefreshTime)));

			winRepairBotBar.SetCurrentValue(barPercent);

			if (secondsRemaining == 1)
				winRepairBotBarText.SetText(Sprintf(SecondsSingularLabel, Int(secondsRemaining)));
			else
				winRepairBotBarText.SetText(Sprintf(SecondsPluralLabel, Int(secondsRemaining)));
		}

		winRepairBotInfoText.SetText(RepairBotStatusLabel);
	}
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	local PersonaButtonBarWindow winActionButtons;

	winActionButtons = PersonaButtonBarWindow(NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(15, 126);
	winActionButtons.SetSize(191, 16);
	winActionButtons.FillAllSpace(False);

	btnClose = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnClose.SetButtonText(CloseButtonLabel);

	btnRecharge = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnRecharge.SetButtonText(RechargeButtonLabel);
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	bHandled = True;

	switch( buttonPressed )
	{
		case btnClose:
			root.PopWindow();
			break;

		case btnRecharge:
			if (repairBot != None)
			{
				repairBot.ChargePlayer(player);	

				// play a cool animation
				repairBot.PlayAnim('Clamp');

				UpdateBioWindows();
				UpdateRepairBotWindows();
				UpdateInfoText();
				EnableButtons();
			}
			break;
	}

	if (!bHandled)
		bHandled = Super.ButtonActivated(buttonPressed);

	return bHandled;
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	if (repairBot != None)
	{
		if (player.Energy >= player.EnergyMax)
			btnRecharge.EnableWindow(False);
		else
			btnRecharge.EnableWindow(repairBot.CanCharge());
	}
}

// ----------------------------------------------------------------------
// SetRepairBot()
// ----------------------------------------------------------------------

function SetRepairBot(RepairBot newBot)
{
	repairBot = newBot;

	if (repairBot != None)
	{
		repairBot.StandStill();
		repairBot.PlayAnim('Start');
		repairBot.PlaySound(sound'RepairBotRaiseArm', SLOT_None);

		UpdateInfoText();
		UpdateRepairBotWindows();
		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colBackground = theme.GetColorFromName('HUDColor_Background');
	colBorder     = theme.GetColorFromName('HUDColor_Borders');
	colText       = theme.GetColorFromName('HUDColor_NormalText');
	colHeaderText = theme.GetColorFromName('HUDColor_HeaderText');

	bBorderTranslucent     = player.GetHUDBorderTranslucency();
	bBackgroundTranslucent = player.GetHUDBackgroundTranslucency();
	bDrawBorder            = player.GetHUDBordersVisible();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texBackground(0)=Texture'DeusExUI.UserInterface.HUDRepairbotBackground_1'
     texBackground(1)=Texture'DeusExUI.UserInterface.HUDRepairbotBackground_2'
     texBorder(0)=Texture'DeusExUI.UserInterface.HUDRepairbotBorder_1'
     texBorder(1)=Texture'DeusExUI.UserInterface.HUDRepairbotBorder_2'
     refreshInterval=0.200000
     RechargeButtonLabel="  |&Recharge  "
     CloseButtonLabel="  |&Close  "
     RechargeTitle="REPAIRBOT INTERFACE"
     RepairBotInfoText="The RepairBot can restore up to %d points of Bio Electric Energy every %d seconds."
     RepairBotStatusLabel="RepairBot Status:"
     ReadyLabel="Ready!"
     SecondsPluralLabel="Recharging: %d seconds"
     SecondsSingularLabel="Recharging: %d second"
     BioStatusLabel="Bio Energy:"
     RepairBotRechargingLabel="|n|nThe RepairBot is currently Recharging.  Please Wait."
     RepairBotReadyLabel="|n|nThe RepairBot is Ready, you may now Recharge."
     RepairBotYouAreHealed="|n|nYour BioElectric Energy is at Maximum."
     ScreenType=ST_Popup
}
