//=============================================================================
// MenuChoice_FullScreen
//=============================================================================

class MenuChoice_FullScreen extends MenuUIChoiceAction;

// ----------------------------------------------------------------------
// ButtonActivated()
//
// If the action button was pressed, cycle to the next available
// choice (if any)
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	ToggleFullScreen();
	return True;
}

// ----------------------------------------------------------------------
// ToggleFullScreen()
// ----------------------------------------------------------------------

function ToggleFullScreen()
{
	player.ConsoleCommand("TOGGLEFULLSCREEN");
//	GetScreenResolutions();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     Action=MA_Custom
     HelpText="Toggle between running the game full-screen or in a window"
     actionText="Toggle |&Full-Screen Mode"
}
