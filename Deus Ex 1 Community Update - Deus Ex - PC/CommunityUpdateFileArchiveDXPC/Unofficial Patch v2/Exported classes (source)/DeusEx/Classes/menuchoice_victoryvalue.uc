//=============================================================================
// MenuChoice_VictoryValue
//=============================================================================

class MenuChoice_VictoryValue extends MenuUIChoiceSlider;

var MenuScreenHostGame hostparent;

var localized string TimeLimitActionText;
var localized string FragLimitActionText;

var localized string TimeLimitHelpText;
var localized string FragLimitHelpText;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

   SetVictoryType(player.ConsoleCommand("get DeusExMPGame VictoryCondition"));

   SetActionButtonWidth(179);

   btnSlider.winSlider.SetValueFormat("%1.0f");
}

// ----------------------------------------------------------------------
// SetVictoryType()
// ----------------------------------------------------------------------

function SetVictoryType(string VictoryType)
{
   local int TickValue;
   local float TickPercent;

   log("Setting victory type");
   TickValue = btnSlider.winSlider.GetTickPosition();
   log("Tick value is "$TickValue);

   TickPercent = float(TickValue)/float(NumTicks);
   log("TickPercent is "$TickPercent);

   if (VictoryType ~= "Frags")
   {
      startvalue = 1;
      numTicks = 40;
      endValue = 40;
      actionText = FragLimitActionText;
      helpText = FragLimitHelpText;
   }
   else if (VictoryType ~= "Time")
   {
      startvalue = 1;
      numTicks = 20;
      endValue= 20;
      actionText=TimeLimitActionText;
      helpText=TimeLimitHelpText;
   }

   btnAction.SetButtonText(actionText);
	btnSlider.SetTicks(numTicks, startValue, endValue);

   TickValue = TickPercent * NumTicks;
   log("new tick value is "$TickValue);
   if (TickValue < 0)
      TickValue = 0;
   if (TickValue == NumTicks)
      TickValue = NumTicks - 1;

   btnSlider.winSlider.SetTickPosition(TickValue);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     TimeLimitActionText="Time Limit(minutes)"
     FragLimitActionText="Kill Limit"
     TimeLimitHelpText="Number of minutes until game ends"
     FragLimitHelpText="Number of kills needed to win"
     numTicks=40
     startValue=1.000000
     endValue=40.000000
     defaultValue=20.000000
     choiceControlPosX=203
     actionText=""
     configSetting="DeusExMPGame ScoreToWin"
}
