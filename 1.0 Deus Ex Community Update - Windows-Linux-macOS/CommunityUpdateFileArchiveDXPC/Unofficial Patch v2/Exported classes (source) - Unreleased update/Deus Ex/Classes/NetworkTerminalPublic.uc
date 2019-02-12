//=============================================================================
// NetworkTerminalPublic.
//=============================================================================
class NetworkTerminalPublic extends NetworkTerminal;

// ----------------------------------------------------------------------
// CloseScreen()
// ----------------------------------------------------------------------

function CloseScreen(String action)
{
	Super.CloseScreen(action);

	// Based on the action, proceed!
	if (action == "LOGOUT")
		Super.CloseScreen("EXIT");
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     FirstScreen=Class'DeusEx.ComputerScreenBulletins'
     bUsesHackWindow=False
}
