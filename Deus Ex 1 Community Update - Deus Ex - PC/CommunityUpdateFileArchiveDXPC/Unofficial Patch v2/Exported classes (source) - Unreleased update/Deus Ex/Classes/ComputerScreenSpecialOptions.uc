//=============================================================================
// ComputerScreenSpecialOptions
//=============================================================================

class ComputerScreenSpecialOptions expands ComputerUIWindow;

struct S_OptionButtons
{
	var int specialIndex;
	var MenuUIChoiceButton btnSpecial;
};

var S_OptionButtons optionButtons[4];

var MenuUIActionButtonWindow btnReturn;
var MenuUIActionButtonWindow btnLogout;
var MenuUISmallLabelWindow   winSpecialInfo;

var int buttonLeftMargin;
var int firstButtonPosY;
var int specialOffsetY;
var int statusPosYOffset;
var int TopTextureHeight;
var int MiddleTextureHeight;
var int BottomTextureHeight;

var localized String SecurityButtonLabel;
var localized String EmailButtonLabel;

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	btnLogout = winButtonBar.AddButton(ButtonLabelLogout, HALIGN_Right);

	CreateSpecialInfoWindow();
}

// ----------------------------------------------------------------------
// CreateClientWindow()
// ----------------------------------------------------------------------

function CreateClientWindow()
{
	Super.CreateClientWindow();

	if (winClient != None)
		ComputerUIScaleClientWindow(winClient).SetTextureHeights(TopTextureHeight, MiddleTextureHeight, BottomTextureHeight);
}

// ----------------------------------------------------------------------
// CreateSpecialInfoWindow()
// ----------------------------------------------------------------------

function CreateSpecialInfoWindow()
{
	winSpecialInfo = MenuUISmallLabelWindow(winClient.NewChild(Class'MenuUISmallLabelWindow'));

	winSpecialInfo.SetPos(10, 97);
	winSpecialInfo.SetSize(315, 25);
	winSpecialInfo.SetTextAlignments(HALIGN_Left, VALIGN_Center);
	winSpecialInfo.SetTextMargins(0, 0);
}

// ----------------------------------------------------------------------
// SetNetworkTerminal()
// ----------------------------------------------------------------------

function SetNetworkTerminal(NetworkTerminal newTerm)
{
	Super.SetNetworkTerminal(newTerm);

	if (winTerm.IsA('NetworkTerminalPersonal'))
		btnReturn = winButtonBar.AddButton(EmailButtonLabel, HALIGN_Left);
	else if (winTerm.IsA('NetworkTerminalSecurity'))
		btnReturn = winButtonBar.AddButton(SecurityButtonLabel, HALIGN_Left);

	if (btnReturn != None)
		CreateLeftEdgeWindow();
}

// ----------------------------------------------------------------------
// SetCompOwner()
//
// Loop through the special options and create 'em, baby!
// ----------------------------------------------------------------------

function SetCompOwner(ElectronicDevices newCompOwner)
{
	Super.SetCompOwner(newCompOwner);

	CreateOptionButtons();
}

// ----------------------------------------------------------------------
// CreateOptionButtons()
// ----------------------------------------------------------------------

function CreateOptionButtons()
{
	local int specialIndex;
	local int numOptions;
	local MenuUIChoiceButton winButton;

	// Figure out how many special options we have

	numOptions = 0;
	for (specialIndex=0; specialIndex<ArrayCount(Computers(compOwner).specialOptions); specialIndex++)
	{
		if ((Computers(compOwner).specialOptions[specialIndex].userName == "") || (Caps(Computers(compOwner).specialOptions[specialIndex].userName) == winTerm.GetUserName()))
		{
			if (Computers(compOwner).specialOptions[specialIndex].Text != "")
			{
				// Create the button
				winButton = MenuUIChoiceButton(winClient.NewChild(Class'MenuUIChoiceButton'));
				winButton.SetPos(buttonLeftMargin, firstButtonPosY + (numOptions * MiddleTextureHeight));
				winButton.SetButtonText(Computers(compOwner).specialOptions[specialIndex].Text);
				winButton.SetSensitivity(!Computers(compOwner).specialOptions[specialIndex].bAlreadyTriggered);
				winButton.SetWidth(273);

				optionButtons[numOptions].specialIndex = specialIndex;
				optionButtons[numOptions].btnSpecial   = winButton;

				numOptions++;				
			}
		}
	}

	ComputerUIScaleClientWindow(winClient).SetNumMiddleTextures(numOptions);

	// Update the location of the Special Info window and the Status window
	winSpecialInfo.SetPos(10, specialOffsetY + TopTextureHeight + (MiddleTextureHeight * numOptions));
	statusPosY = statusPosYOffset + TopTextureHeight + (MiddleTextureHeight * numOptions);
	AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// UpdateOptionsButtons()
// ----------------------------------------------------------------------

function UpdateOptionsButtons()
{
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	// First check to see if one of our Special Options 
	// buttons was pressed
	if (buttonPressed.IsA('MenuUIChoiceButton'))
	{
		ActivateSpecialOption(MenuUIChoiceButton(buttonPressed));
		bHandled = True;	
	}
	else
	{
		bHandled = True;
		switch( buttonPressed )
		{
			case btnLogout:
				CloseScreen("LOGOUT");
				break;

			case btnReturn:
				CloseScreen("RETURN");
				break;

			default:
				bHandled = False;
				break;
		}
	}

	if (bHandled)
		return True;
	else
		return Super.ButtonActivated(buttonPressed);
}

// ----------------------------------------------------------------------
// ActivateSpecialOption()
// ----------------------------------------------------------------------

function ActivateSpecialOption(MenuUIChoiceButton buttonPressed)
{
	local int buttonIndex;
	local int specialIndex;
	local Actor A;

	specialIndex = -1;

	// Loop through the buttons and find a Match!
	for(buttonIndex=0; buttonIndex<arrayCount(optionButtons); buttonIndex++)
	{
		if (optionButtons[buttonIndex].btnSpecial == buttonPressed)
		{
			specialIndex = optionButtons[buttonIndex].specialIndex;

			// Disable this button so the user can't activate this 
			// choice again
			optionButtons[buttonIndex].btnSpecial.SetSensitivity(False);

			break;
		}
	}

	// If we found the matching button, activate the option!
	if (specialIndex != -1)
	{
		// Make sure this option wasn't already triggered
		if (!Computers(compOwner).specialOptions[specialIndex].bAlreadyTriggered)
		{
			if (Computers(compOwner).specialOptions[specialIndex].TriggerEvent != '')
				foreach player.AllActors(class'Actor', A, Computers(compOwner).specialOptions[specialIndex].TriggerEvent)
					A.Trigger(None, player);
		
			if (Computers(compOwner).specialOptions[specialIndex].UnTriggerEvent != '')
				foreach player.AllActors(class'Actor', A, Computers(compOwner).specialOptions[specialIndex].UnTriggerEvent)
					A.UnTrigger(None, player);
		
			if (Computers(compOwner).specialOptions[specialIndex].bTriggerOnceOnly)
				Computers(compOwner).specialOptions[specialIndex].bAlreadyTriggered = True;

			// Display a message			
			winSpecialInfo.SetText(Computers(compOwner).specialOptions[specialIndex].TriggerText);
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     buttonLeftMargin=25
     firstButtonPosY=17
     specialOffsetY=16
     statusPosYOffset=50
     TopTextureHeight=12
     MiddleTextureHeight=30
     BottomTextureHeight=75
     SecurityButtonLabel="|&Security"
     EmailButtonLabel="|&Email"
     classClient=Class'DeusEx.ComputerUIScaleClientWindow'
     escapeAction="LOGOUT"
     Title="Special Options"
     ClientWidth=331
     clientTextures(0)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundTop_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundTop_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundMiddle_1'
     clientTextures(3)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundMiddle_2'
     clientTextures(4)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundBottom_1'
     clientTextures(5)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundBottom_2'
     textureCols=2
     bAlwaysCenter=True
     ComputerNodeFunctionLabel="SpecialOptions"
}
