//=============================================================================
// MenuChoice_StartingAugs
//=============================================================================

class MenuChoice_StartingAugs extends MenuUIChoiceSlider;

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
     HelpText="Sets the initial number of augmentations a player has."
     actionText="Initial Augmentations"
     configSetting="DeusExMPGame InitialAugs"
}
