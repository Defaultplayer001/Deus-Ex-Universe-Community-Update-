//=============================================================================
// NetworkTerminalATM
//=============================================================================
class NetworkTerminalATM extends NetworkTerminal;

// ----------------------------------------------------------------------
// CloseScreen()
// ----------------------------------------------------------------------

function CloseScreen(String action)
{
	Super.CloseScreen(action);

	// Based on the action, proceed!
	if (action == "LOGOUT")
	{
		// If we're hacked into the computer, then exit completely.
		if (bHacked)
			CloseScreen("EXIT");
		else
			ShowScreen(FirstScreen);
	}
	else if (action == "LOGIN")
	{
		ShowScreen(Class'ComputerScreenATMWithdraw');
	}
	else if (action == "ATMDISABLED")
	{
		ShowScreen(Class'ComputerScreenATMDisabled');
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     FirstScreen=Class'DeusEx.ComputerScreenATM'
}
