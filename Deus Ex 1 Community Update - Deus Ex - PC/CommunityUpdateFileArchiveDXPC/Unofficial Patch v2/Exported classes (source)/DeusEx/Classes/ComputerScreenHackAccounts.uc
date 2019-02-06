//=============================================================================
// ComputerScreenHackAccounts
//=============================================================================
class ComputerScreenHackAccounts extends HUDBaseWindow;

var PersonaActionButtonWindow btnChangeAccount;
var PersonaHeaderTextWindow   winCurrentUser;
var PersonaListWindow         lstAccounts;
var NetworkTerminal           winTerm;
var Computers                 compOwner;		// what computer owns this window?

// Defaults
var Texture texBackground;
var Texture texBorder;

var localized String ChangeAccountButtonLabel;
var localized String AllAccountsHeader;
var localized String CurrentAccountHeader;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(206, 232);

	CreateControls();	
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	CreateChangeAccountButton();
	CreateCurrentUserWindow();
	CreateAccountsList();
	CreateHeaders();
}

// ----------------------------------------------------------------------
// CreateChangeAccountButton()
// ----------------------------------------------------------------------

function CreateChangeAccountButton()
{
	local PersonaButtonBarWindow winActionButtons;

	winActionButtons = PersonaButtonBarWindow(NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(12, 169);
	winActionButtons.SetWidth(174);
	winActionButtons.FillAllSpace(False);

	btnChangeAccount = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnChangeAccount.SetButtonText(ChangeAccountButtonLabel);
}

// ----------------------------------------------------------------------
// CreateCurrentUserWindow()
// ----------------------------------------------------------------------

function CreateCurrentUserWindow()
{
	winCurrentUser = PersonaHeaderTextWindow(NewChild(Class'PersonaHeaderTextWindow'));
	winCurrentUser.SetPos(16, 29);
	winCurrentUser.SetSize(170, 12);
}

// ----------------------------------------------------------------------
// CreateAccountsList()
// ----------------------------------------------------------------------

function CreateAccountsList()
{
	local PersonaScrollAreaWindow winScroll;

	winScroll = PersonaScrollAreaWindow(NewChild(Class'PersonaScrollAreaWindow'));;
	winScroll.SetPos(14, 69);
	winScroll.SetSize(170, 97);

	lstAccounts = PersonaListWindow(winScroll.clipWindow.NewChild(Class'PersonaListWindow'));
	lstAccounts.EnableMultiSelect(False);
	lstAccounts.EnableAutoExpandColumns(False);
	lstAccounts.EnableHotKeys(False);
	lstAccounts.SetNumColumns(1);
	lstAccounts.SetColumnWidth(0, 170);
}

// ----------------------------------------------------------------------
// CreateHeaders()
// ----------------------------------------------------------------------

function CreateHeaders()
{
	local MenuUIHeaderWindow winHeader;

	winHeader = MenuUIHeaderWindow(NewChild(Class'MenuUIHeaderWindow'));
	winHeader.SetPos(12, 12);
	winHeader.SetText(CurrentAccountHeader);

	winHeader = MenuUIHeaderWindow(NewChild(Class'MenuUIHeaderWindow'));
	winHeader.SetPos(12, 53);
	winHeader.SetText(AllAccountsHeader);
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
	gc.SetStyle(backgroundDrawStyle);
	gc.SetTileColor(colBackground);
	gc.DrawTexture(
		backgroundPosX, backgroundPosY, 
		backgroundWidth, backgroundHeight, 
		0, 0, texBackground);
}

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

function DrawBorder(GC gc)
{
	if (bDrawBorder)
	{
		gc.SetStyle(borderDrawStyle);
		gc.SetTileColor(colBorder);
		gc.DrawTexture(0, 0, 206, 232, 0, 0, texBorder);
	}
}

// ----------------------------------------------------------------------
// SetNetworkTerminal()
// ----------------------------------------------------------------------

function SetNetworkTerminal(NetworkTerminal newTerm)
{
	winTerm = newTerm;
	UpdateCurrentUser();
}

// ----------------------------------------------------------------------
// SetCompOwner()
// ----------------------------------------------------------------------

function SetCompOwner(ElectronicDevices newCompOwner)
{
	local int compIndex;
	local int rowId;
	local int userRowIndex;

	compOwner = Computers(newCompOwner);

	// Loop through the names and add them to our listbox
	for (compIndex=0; compIndex<compOwner.NumUsers(); compIndex++)
	{
		lstAccounts.AddRow(Caps(compOwner.GetUserName(compIndex)));

		if (Caps(winTerm.GetUserName()) == Caps(compOwner.GetUserName(compIndex)))
			userRowIndex = compIndex;
	}

	// Select the row that matches the current user
	rowId = lstAccounts.IndexToRowId(userRowIndex);
	lstAccounts.SetRow(rowId, True);
}

// ----------------------------------------------------------------------
// UpdateCurrentUser()
// ----------------------------------------------------------------------

function UpdateCurrentUser()
{
	if (winTerm != None)
		winCurrentUser.SetText(winTerm.GetUserName());
}

// ----------------------------------------------------------------------
// ChangeSelectedAccount()
// ----------------------------------------------------------------------

function ChangeSelectedAccount()
{
	local int userIndex;

	userIndex = lstAccounts.RowIdToIndex(lstAccounts.GetSelectedRow());

	if (winTerm != None)
		winTerm.ChangeAccount(userIndex);
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
		case btnChangeAccount:
			ChangeSelectedAccount();
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
// VirtualKeyPressed()
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bKeyHandled;
	bKeyHandled = True;

	switch( key ) 
	{	
		case IK_Escape:
			winTerm.ForceCloseScreen();	
			break;

		default:
			bKeyHandled = False;
	}

	if (bKeyHandled)
		return True;
	else
		return Super.VirtualKeyPressed(key, bRepeat);
}

// ----------------------------------------------------------------------
// ListRowActivated()
// ----------------------------------------------------------------------

event bool ListRowActivated(window list, int rowId)
{
	ChangeSelectedAccount();
	return TRUE;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texBackground=Texture'DeusExUI.UserInterface.ComputerHackAccountsBackground'
     texBorder=Texture'DeusExUI.UserInterface.ComputerHackAccountsBorder'
     ChangeAccountButtonLabel="|&Change Account"
     AllAccountsHeader="All User Accounts"
     CurrentAccountHeader="Current User"
     backgroundWidth=188
     backgroundHeight=181
     backgroundPosX=6
     backgroundPosY=9
}
