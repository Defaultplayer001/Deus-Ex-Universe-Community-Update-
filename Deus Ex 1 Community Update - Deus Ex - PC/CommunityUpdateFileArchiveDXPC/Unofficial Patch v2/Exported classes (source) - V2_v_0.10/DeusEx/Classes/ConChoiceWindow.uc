//=============================================================================
// ConChoiceWindow
//=============================================================================
class ConChoiceWindow expands ButtonWindow;

var Object userObject;

function InitWindow()
{
	Super.InitWindow();
}

function SetUserObject( object newUserObject )
{
	userObject = newUserObject;
}

function Object GetUserObject()
{
	return userObject;
}

defaultproperties
{
}
