//=============================================================================
// MenuUIChoiceAction
//=============================================================================

class MenuUIChoiceAction extends MenuUIChoice;

enum EMenuActions
{
	MA_Menu, 
	MA_MenuScreen,
	MA_Previous, 
	MA_Quit, 
	MA_Custom
};

// Defaults
var EMenuActions action;
var class        invoke;

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Let the parent window handle [Return] so we can use it as "OK"
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bHandled;

	if (key == IK_Enter)
	{
		btnAction.PressButton(key);
		return True;
	}
	else
	{
		return Super.VirtualKeyPressed(key, bRepeat);
	}
}

// ----------------------------------------------------------------------
// ButtonActivated()
//
// If the action button was pressed, cycle to the next available
// choice (if any)
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	ProcessMenuAction(action, invoke);
	return True;
}

// ----------------------------------------------------------------------
// ProcessMenuAction()
// ----------------------------------------------------------------------

function ProcessMenuAction(EMenuActions action, Class menuActionClass)
{
	local DeusExRootWindow root;

	root = DeusExRootWindow(GetRootWindow());

	switch(action)
	{
		case MA_Menu:
			root.InvokeMenu(Class<DeusExBaseWindow>(menuActionClass));
			break;

		case MA_MenuScreen:
			root.InvokeMenuScreen(Class<DeusExBaseWindow>(menuActionClass));
			break;

		case MA_Previous:
			root.PopWindow();
			break;
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
