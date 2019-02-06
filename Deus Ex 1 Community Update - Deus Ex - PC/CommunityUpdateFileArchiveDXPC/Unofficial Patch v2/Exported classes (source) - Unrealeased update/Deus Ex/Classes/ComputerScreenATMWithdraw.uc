//=============================================================================
// ComputerScreenATMWithdraw
//=============================================================================

class ComputerScreenATMWithdraw expands ComputerUIWindow;

var MenuUILabelWindow        winInstructions;
var MenuUISmallLabelWindow   winInfo;

var MenuUIActionButtonWindow btnWithdraw;
var MenuUIActionButtonWindow btnClose;
var MenuUIEditWindow         editBalance;
var MenuUIEditWindow         editWithdraw;

var ATM atmOwner;				// what ATM owns this window?
var float balanceModifier;
var float disabledDelay;		// Amount of time before ATM disabled when hacking

var localized String ButtonLabelWithdraw;
var localized String ButtonLabelClose;
var localized String BalanceLabel;
var localized String WithdrawAmountLabel;
var localized String InstructionText;
var localized String InvalidAmountLabel;
var localized String InsufficientCreditsLabel;
var localized String CreditsWithdrawnLabel;
var localized String StatusText;
var localized String HackedText;

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	btnWithdraw = winButtonBar.AddButton(ButtonLabelWithdraw, HALIGN_Right);
	btnClose    = winButtonBar.AddButton(ButtonLabelClose,  HALIGN_Right);

	CreateMenuLabel(20, 91, BalanceLabel, winClient);
	CreateMenuLabel(20, 121, WithdrawAmountLabel, winClient);

	editBalance  = CreateMenuEditWindow(231, 89, 143, 10, winClient);
	editBalance.SetSensitivity(False);	// cannot edit balance!!
	editWithdraw = CreateMenuEditWindow(231, 119, 143, 10, winClient);

	CreateInstructionsWindow();
	CreateInfoWindow();

	winTitle.SetTitle(Title);
	winStatus.SetText(StatusText);
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	disabledDelay -= deltaTime;

	if (disabledDelay <= 0.0)
	{
		bTickEnabled = False;

		// Go to the ATM Disabled screen
		CloseScreen("ATMDISABLED");
	}
}

// ----------------------------------------------------------------------
// CreateInstructionsWindow()
// ----------------------------------------------------------------------

function CreateInstructionsWindow()
{
	winInstructions = MenuUILabelWindow(winClient.NewChild(Class'MenuUILabelWindow'));

	winInstructions.SetPos(8, 10);
	winInstructions.SetSize(381, 50);
	winInstructions.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winInstructions.SetTextMargins(0, 0);
}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
	winInfo = MenuUISmallLabelWindow(winClient.NewChild(Class'MenuUISmallLabelWindow'));

	winInfo.SetPos(8, 152);
	winInfo.SetSize(385, 25);
	winInfo.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winInfo.SetTextMargins(0, 0);
}

// ----------------------------------------------------------------------
// SetCompOwner()
// ----------------------------------------------------------------------

function SetCompOwner(ElectronicDevices newCompOwner)
{
	local String test;

	Super.SetCompOwner(newCompOwner);
	atmowner = ATM(compOwner);

	balanceModifier = winTerm.GetSkillLevel() * 0.5;
	UpdateBalance();

	if (winTerm.bHacked)
	{
		// Once hacked, an ATM can't be returned to
		atmOwner.bSuckedDryByHack = True;
		test = Sprintf(InstructionText, HackedText);
	}
	else
	{
		test = Sprintf(InstructionText, atmOwner.GetAccountNumber(winTerm.GetUserIndex()));
	}

	winInstructions.SetText(test);

	EnableButtons();
	SetFocusWindow(editWithdraw);
}

// ----------------------------------------------------------------------
// UpdateBalance()
// ----------------------------------------------------------------------

function UpdateBalance()
{
	if (winTerm.bHacked)
		editBalance.SetText(String(atmOwner.GetBalance(-1, balanceModifier)));
	else
		editBalance.SetText(String(atmOwner.GetBalance(winTerm.GetUserIndex(), balanceModifier)));
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
		case btnWithdraw:
			WithdrawCredits();
			break;

		case btnClose:
			CloseScreen("LOGOUT");
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
// EditActivated()
// ----------------------------------------------------------------------

event bool EditActivated(window edit, bool bModified)
{
	WithdrawCredits();
}

// ----------------------------------------------------------------------
// WithdrawCredits()
// ----------------------------------------------------------------------

function WithdrawCredits()
{
	local int numCredits;
	local int balance;

	numCredits = Int(editWithdraw.GetText());

	// withdrawal
	if (numCredits > 0)
	{
		if (winTerm.bHacked)
			balance = atmOwner.GetBalance(-1, balanceModifier);
		else
			balance = atmOwner.GetBalance(winTerm.GetUserIndex(), balanceModifier);

		if (balance >= numCredits)
		{
			if (winTerm.bHacked)
				atmOwner.ModBalance(-1, numCredits, True);
			else
				atmOwner.ModBalance(winTerm.GetUserIndex(), numCredits, True);

			player.Credits += numCredits;
			winInfo.SetText(String(numCredits) @ CreditsWithdrawnLabel);

			// If the user withdrew *ALL* the money and this ATM machine 
			// was hacked, then set a timer which will cause the 
			// ATM Disabled screen to come up after a few seconds.

			if ((winTerm.bHacked) && (balance - numCredits <= 0))
			{
				bTickEnabled = True;
				atmOwner.bSuckedDryByHack = True;
			}
		}
		else
		{
			winInfo.SetText(InsufficientCreditsLabel);
		}
	}
	else
	{
		winInfo.SetText(InvalidAmountLabel);
	}

	// Blank withdraw box and reset focus to that window
	editWithdraw.SetText("");
	UpdateBalance();
	SetFocusWindow(editWithdraw);
}

// ----------------------------------------------------------------------
// TextChanged() 
// ----------------------------------------------------------------------

event bool TextChanged(window edit, bool bModified)
{
	EnableButtons();

	return False;
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	local float balance;

	// Only allow withdraw if there's money to be withdrawn and the user has typed
	// something into the editWithdraw field

	if (winTerm.bHacked)
		balance = atmOwner.GetBalance(-1, balanceModifier);
	else
		balance = atmOwner.GetBalance(winTerm.GetUserIndex(), balanceModifier);

	btnWithdraw.SetSensitivity((editWithdraw.GetText() != "") && (balance > 0));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     disabledDelay=5.000000
     ButtonLabelWithdraw="|&Withdraw"
     ButtonLabelClose="|&Close"
     BalanceLabel="Current Balance:"
     WithdrawAmountLabel="Amount to Withdraw:"
     InstructionText="Account #: %d|nPlease enter the amount of|ncredits you wish to withdraw."
     InvalidAmountLabel="INVALID AMOUNT ENTERED"
     InsufficientCreditsLabel="INSUFFICIENT CREDITS"
     CreditsWithdrawnLabel="CREDITS WITHDRAWN"
     StatusText="PNGBS//GLOBAL//PUB:3902.9571[wd]"
     HackedText="TERMINAL HACKED"
     escapeAction="LOGOUT"
     Title="PageNet Global Banking System"
     ClientWidth=403
     ClientHeight=211
     verticalOffset=30
     clientTextures(0)=Texture'DeusExUI.UserInterface.ComputerGBSWithdrawBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.ComputerGBSWithdrawBackground_2'
     textureRows=1
     textureCols=2
     bAlwaysCenter=True
     statusPosY=186
     ComputerNodeFunctionLabel="ATMWD"
}
