//=============================================================================
// SkillRadioBox
//=============================================================================
class SkillRadioBox expands RadioBoxWindow;

var TileWindow skillWindow;

event InitWindow()
{
	Super.InitWindow();

	skillWindow = TileWindow(NewChild(Class'TileWindow'));
}

defaultproperties
{
}
