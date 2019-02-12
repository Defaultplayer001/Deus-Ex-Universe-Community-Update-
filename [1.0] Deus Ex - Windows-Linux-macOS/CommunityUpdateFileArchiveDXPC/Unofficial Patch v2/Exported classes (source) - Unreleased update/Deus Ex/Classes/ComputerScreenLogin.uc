//=============================================================================
// ComputerScreenLogin
//=============================================================================

class ComputerScreenLogin expands ComputerUIWindow;

var MenuUIActionButtonWindow btnLogin;
var MenuUIActionButtonWindow btnCancel;
var MenuUISmallLabelWindow   winLoginInfo;
var MenuUIEditWindow         editUserName;
var MenuUIEditWindow         editPassword;
var Window                   winLogo;

var localized String UserNameLabel;
var localized String PasswordLabel;
var localized String InvalidLoginMessage;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
	EnableButtons();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	btnCancel = winButtonBar.AddButton(ButtonLabelCancel, HALIGN_Right);
	btnLogin  = winButtonBar.AddButton(ButtonLabelLogin,  HALIGN_Right);

	CreateMenuLabel(10, 22, UserNameLabel, winClient);
	CreateMenuLabel(10, 55, PasswordLabel, winClient);

	editUserName = CreateMenuEditWindow(105, 20, 143, 20, winClient);
	editPassword = CreateMenuEditWindow(105, 54, 143, 20, winClient);

	CreateLogo();
	CreateLoginInfoWindow();
}

// ----------------------------------------------------------------------
// CreateLogo()
// ----------------------------------------------------------------------

function CreateLogo()
{
	winLogo = winClient.NewChild(Class'Window');

	winLogo.SetPos(276, 5);
	winLogo.SetSize(61, 61);
	winLogo.SetBackgroundStyle(DSTY_Masked);
}

// ----------------------------------------------------------------------
// CreateLoginInfoWindow()
// ----------------------------------------------------------------------

function CreateLoginInfoWindow()
{
	winLoginInfo = MenuUISmallLabelWindow(winClient.NewChild(Class'MenuUISmallLabelWindow'));

	winLoginInfo.SetPos(10, 97);
	winLoginInfo.SetSize(320, 25);
	winLoginInfo.SetTextAlignments(HALIGN_Left, VALIGN_Center);
	winLoginInfo.SetTextMargins(0, 0);
}

// ----------------------------------------------------------------------
// SetLogo()
// ----------------------------------------------------------------------

function SetLogo(Texture newLogo)
{
	if (winLogo != None)
		winLogo.SetBackground(newLogo);
}

// ----------------------------------------------------------------------
// SetCompOwner()
// ----------------------------------------------------------------------

function SetCompOwner(ElectronicDevices newCompOwner)
{
	Super.SetCompOwner(newCompOwner);

	// Update the title, texture and description
	winTitle.SetTitle(Sprintf(Title, Computers(compOwner).GetNodeName()));
	winLoginInfo.SetText(Computers(compOwner).GetNodeDesc());

	SetFocusWindow(editUserName);

	SetLogo(Computers(compOwner).GetNodeTexture());
}

// ----------------------------------------------------------------------
// SetNetworkTerminal()
// ----------------------------------------------------------------------

function SetNetworkTerminal(NetworkTerminal newTerm)
{
	Super.SetNetworkTerminal(newTerm);

	// If the user already hacked this computer, then set the 
	// "Hack" button to "Return"
	if (winTerm != None)
		winTerm.SetHackButtonToReturn();
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
		case btnLogin:
			ProcessLogin();
			break;

		case btnCancel:
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
// EditActivated()
//
// Allow the user to press [Return] to accept the username/password
// ----------------------------------------------------------------------

event bool EditActivated(window edit, bool bModified)
{
	if (btnLogin.IsSensitive())
	{
		ProcessLogin();
		return True;
	}
	else
	{
		return False;
	}
}

// ----------------------------------------------------------------------
// ProcessLogin()
// ----------------------------------------------------------------------

function ProcessLogin()
{
	local string userName;
	local int userIndex;
	local int compIndex;
	local int userSkillLevel;
	local bool bSuccessfulLogin;

	bSuccessfulLogin = False;
	userIndex        = -1;

	// Verify that this is a valid userid/password combination

	// First check the name
	for (compIndex=0; compIndex<Computers(compOwner).NumUsers(); compIndex++)
	{
		if (Caps(editUsername.GetText()) == Caps(Computers(compOwner).GetUserName(compIndex)))
		{
			userName  = Caps(Computers(compOwner).GetUserName(compIndex));
			userIndex = compIndex;
			break;
		}
	}

	if (userIndex != -1)
	{
		if (Caps(editPassword.GetText()) == Caps(Computers(compOwner).GetPassword(userIndex)))
		{
			bSuccessfulLogin = True;
		}
	}

	if (bSuccessfulLogin)
	{
		winTerm.SetLoginInfo(userName, userIndex);

		// set the user's access level if it's higher than the player's
		userSkillLevel = Computers(compOwner).GetAccessLevel(userIndex);

		if (winTerm.GetSkillLevel() < userSkillLevel)
			winTerm.SetSkillLevel(userSkillLevel);

		CloseScreen("LOGIN");
	}
	else
	{
		// Print a message about invalid login
		winLoginInfo.SetText(InvalidLoginMessage);

		// Clear text fields and reset focus
		editUserName.SetText("");
		editPassword.SetText("");
		SetFocusWindow(editUserName);
	}
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
	// Text must be entered in the two fields for the login button to be
	// enabled

	btnLogin.SetSensitivity((editUsername.GetText() != "") && (editPassword.GetText() != ""));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     UserNameLabel="User Name"
     PasswordLabel="Password"
     InvalidLoginMessage="LOGIN ERROR - ACCESS DENIED"
     Title="Welcome to %s"
     ClientWidth=343
     ClientHeight=151
     clientTextures(0)=Texture'DeusExUI.UserInterface.ComputerLogonBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.ComputerLogonBackground_2'
     textureRows=1
     textureCols=2
     statusPosY=131
     ComputerNodeFunctionLabel="Login"
}
