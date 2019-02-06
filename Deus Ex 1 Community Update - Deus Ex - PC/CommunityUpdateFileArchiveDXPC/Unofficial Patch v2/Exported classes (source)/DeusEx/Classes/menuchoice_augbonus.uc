//=============================================================================
// MenuChoice_AugBonus
//=============================================================================

class MenuChoice_AugBonus extends MenuUIChoiceSlider;

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
     numTicks=10
     endValue=9.000000
     defaultValue=2.000000
     choiceControlPosX=203
     HelpText="Sets the number of additional augs granted to a player for a kill."
     actionText="Augmentations Per Kill"
     configSetting="DeusExMPGame AugsPerKill"
}
