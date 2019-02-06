//=============================================================================
// MenuChoice_TextureColorBits
//=============================================================================

class MenuChoice_TextureColorBits extends MenuUIChoiceEnum;

var bool   bMessageDisplayed;
var String configSetting2;

var Localized String RestartTitle;
var Localized String RestartMessage;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	local int detailChoice;

	detailChoice = int(player.ConsoleCommand("get " $ configSetting));

	if (detailChoice == 16)
		SetValue(0);
	else
		SetValue(1);
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	if (GetValue() == 0)
	{
		player.ConsoleCommand("set " $ configSetting $ " 16");
		player.ConsoleCommand("set " $ configSetting2 $ " 16");
	}
	else
	{
		player.ConsoleCommand("set " $ configSetting $ " 32");
		player.ConsoleCommand("set " $ configSetting2 $ " 32");
	}
}

// ----------------------------------------------------------------------
// CycleNextValue()
// ----------------------------------------------------------------------

function CycleNextValue()
{
	Super.CycleNextValue();

	if (!bMessageDisplayed)
	{
		DeusExRootWindow(GetRootWindow()).MessageBox(RestartTitle, RestartMessage, 1, False, Self);
		bMessageDisplayed = True;
	}
}

// ----------------------------------------------------------------------
// CyclePreviousValue()
// ----------------------------------------------------------------------

function CyclePreviousValue()
{
	Super.CyclePreviousValue();

	if (!bMessageDisplayed)
	{
		DeusExRootWindow(GetRootWindow()).MessageBox(RestartTitle, RestartMessage, 1, False, Self);
		bMessageDisplayed = True;
	}
}

// ----------------------------------------------------------------------
// BoxOptionSelected()
// ----------------------------------------------------------------------

event bool BoxOptionSelected(Window msgBoxWindow, int buttonNumber)
{
	// Destroy the msgbox!  
	DeusExRootWindow(GetRootWindow()).PopWindow();

	return True;
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
	LoadSetting();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     configSetting2="ini:Engine.Engine.ViewportManager WindowedColorBits"
     RestartTitle="Texture Color Depth"
     RestartMessage="This change will not take effect until you restart Deus Ex."
     enumText(0)="16-bit"
     enumText(1)="32-bit"
     defaultInfoWidth=98
     HelpText="Determines the texture color depth.  32-bit textures look better if your hardware supports them."
     actionText="|&Texture Color Depth"
     configSetting="ini:Engine.Engine.ViewportManager FullscreenColorBits"
}
