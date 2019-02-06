//=============================================================================
// MenuChoice_SkillBonus
//=============================================================================

class MenuChoice_SkillBonus extends MenuUIChoiceSlider;

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
     numTicks=21
     endValue=10000.000000
     defaultValue=2000.000000
     choiceControlPosX=203
     HelpText="Sets the number of additional skill points granted to a player for a kill."
     actionText="Skill Points Per Kill"
     configSetting="DeusExMPGame SkillsPerKill"
}
