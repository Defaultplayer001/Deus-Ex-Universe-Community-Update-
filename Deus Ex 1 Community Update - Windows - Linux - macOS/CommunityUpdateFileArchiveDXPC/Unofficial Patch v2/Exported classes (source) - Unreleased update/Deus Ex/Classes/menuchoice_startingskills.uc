//=============================================================================
// MenuChoice_StartingSkills
//=============================================================================

class MenuChoice_StartingSkills extends MenuUIChoiceSlider;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

   SetActionButtonWidth(179);

   btnSlider.winSlider.SetValueFormat("%1.0f");
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     endValue=10000.000000
     defaultValue=2000.000000
     choiceControlPosX=203
     HelpText="Sets the initial number of skill points a player has."
     actionText="Initial Skill Points"
     configSetting="DeusExMPGame SkillsAvail"
}
