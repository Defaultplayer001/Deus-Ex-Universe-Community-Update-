//=============================================================================
// ComputerScreenATMDisabled
//=============================================================================
class ComputerScreenATMDisabled extends ComputerUIWindow;

var MenuUILabelWindow        winLoginInfo;
var MenuUIActionButtonWindow btnClose;

var localized String ButtonLabelClose;
var localized String LoginInfoText;
var localized String StatusText;

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	btnClose = winButtonBar.AddButton(ButtonLabelClose, HALIGN_Right);

	CreateLoginInfoWindow();

	winTitle.SetTitle(Title);
	winStatus.SetText(StatusText);
}

// ----------------------------------------------------------------------
// CreateLoginInfoWindow()
// ----------------------------------------------------------------------

function CreateLoginInfoWindow()
{
	winLoginInfo = MenuUILabelWindow(winClient.NewChild(Class'MenuUILabelWindow'));

	winLoginInfo.SetPos(10, 12);
	winLoginInfo.SetSize(377, 122);
	winLoginInfo.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winLoginInfo.SetTextMargins(0, 0);
	winLoginInfo.SetText(LoginInfoText);
}

// ----------------------------------------------------------------------
// SetNetworkTerminal()
// ----------------------------------------------------------------------

function SetNetworkTerminal(NetworkTerminal newTerm)
{
	Super.SetNetworkTerminal(newTerm);

	// Hide the Hack window
	if (winTerm != None)
		winTerm.CloseHackWindow();
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
			CloseScreen("EXIT");
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
// ----------------------------------------------------------------------

defaultproperties
{
     ButtonLabelClose="Close"
     LoginInfoText="Sorry, this terminal is out of service (ERR 06MJ12)|n|nWe apologize for the inconvenience but would gladly service you at any of the other 231,000 PageNet Banking Terminals around the globe."
     StatusText="PNGBS//GLOBAL//PUB:3902.9571[dsbld]"
     Title="PageNet Global Banking System"
     ClientWidth=403
     ClientHeight=211
     verticalOffset=30
     clientTextures(0)=Texture'DeusExUI.UserInterface.ComputerGBSDisabledBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.ComputerGBSDisabledBackground_2'
     textureRows=1
     textureCols=2
     bAlwaysCenter=True
     statusPosY=186
}
