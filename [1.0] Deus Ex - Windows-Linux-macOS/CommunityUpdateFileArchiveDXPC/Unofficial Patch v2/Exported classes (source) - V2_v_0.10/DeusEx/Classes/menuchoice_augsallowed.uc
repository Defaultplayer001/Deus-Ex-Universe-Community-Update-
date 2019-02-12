//=============================================================================
// MenuChoice_AugsAllowed
//=============================================================================

class MenuChoice_AugsAllowed extends MenuChoice_OnOff;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

   SetActionButtonWidth(179);
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
     defaultInfoWidth=178
     defaultInfoPosX=204
     HelpText="Sets whether players receive starting augmentations and augmentations for kills."
     actionText="Augmentations"
     configSetting="DeusExMPGame bAugsAllowed"
}
