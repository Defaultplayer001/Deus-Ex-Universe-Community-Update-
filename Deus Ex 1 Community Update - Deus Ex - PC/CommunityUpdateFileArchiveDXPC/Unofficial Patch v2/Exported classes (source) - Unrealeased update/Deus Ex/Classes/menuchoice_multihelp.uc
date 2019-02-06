//=============================================================================
// MenuChoice_MultiHelp
//=============================================================================

class MenuChoice_MultiHelp extends MenuChoice_OnOff;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

   SetActionButtonWidth(153);

   btnAction.SetHelpText(HelpText);
}

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	local String SettingString;
	local int enumIndex;
	local int SettingChoice;

	SettingString = player.ConsoleCommand("get " $ configSetting);
	SettingChoice = 0;

	for (enumIndex=0; enumIndex<arrayCount(FalseTrue); enumIndex++)
	{
		if (FalseTrue[enumIndex] == SettingString)
		{
			SettingChoice = enumIndex;
			break;
		}	
	}

	SetValue(SettingChoice);
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.ConsoleCommand("set " $ configSetting $ " " $ FalseTrue[GetValue()]);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultValue=1
     defaultInfoWidth=153
     defaultInfoPosX=170
     HelpText="Whether or not to display messages during multiplayer games to inform you about gameplay rules."
     actionText="Help Messages"
     configSetting="DeusExPlayer bHelpMessages"
}
