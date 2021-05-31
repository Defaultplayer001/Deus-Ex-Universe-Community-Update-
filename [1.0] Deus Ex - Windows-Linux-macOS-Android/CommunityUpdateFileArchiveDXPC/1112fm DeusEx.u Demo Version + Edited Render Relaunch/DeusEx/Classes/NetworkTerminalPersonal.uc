//=============================================================================
// NetworkTerminalPersonal.
//=============================================================================
class NetworkTerminalPersonal extends NetworkTerminal;

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
		// Check to see if there are any "special options" the player
		// has not yet invoked, in which case we want to jump straight
		// to the special options screen (oh boy, "special" cases!)
		if (AreSpecialOptionsAvailable(True))
			ShowScreen(Class'ComputerScreenSpecialOptions');
		else
			ShowScreen(Class'ComputerScreenEmail');
	}
	else if ((action == "EMAIL") || (action == "RETURN"))
	{
		ShowScreen(Class'ComputerScreenEmail');
	}
	else if (action == "SPECIAL")
	{
		ShowScreen(Class'ComputerScreenSpecialOptions');
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     FirstScreen=Class'DeusEx.ComputerScreenLogin'
}
