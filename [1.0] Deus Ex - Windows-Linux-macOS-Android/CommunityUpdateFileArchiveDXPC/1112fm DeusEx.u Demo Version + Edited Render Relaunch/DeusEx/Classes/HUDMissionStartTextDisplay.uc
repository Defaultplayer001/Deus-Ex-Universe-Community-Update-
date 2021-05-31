//=============================================================================
// HUDMissionStartTextDisplay
//=============================================================================
class HUDMissionStartTextDisplay extends Window
	transient;

// ----------------------------------------------------------------------
// Local Variables
// ----------------------------------------------------------------------

var String message;
var int    charIndex;

var Font       fontText;
var TextWindow winText;
var TextWindow winTextShadow;

var Int        shadowDist;
var Bool       bSpewingText;
var Float      perCharDelay;
var Float      displayTime;
var Int        maxTextWidth;

var Color colText;
var Color colBlack;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	winTextShadow = TextWindow(NewChild(Class'TextWindow'));
	winTextShadow.SetFont(fontText);
	winTextShadow.SetTextColor(colBlack);
	winTextShadow.SetTextMargins(0, 0);
	winTextShadow.SetTextAlignments(HALIGN_Left, VALIGN_Top);

	winText = TextWindow(NewChild(Class'TextWindow'));
	winText.SetFont(fontText);
	winText.SetTextColor(colText);
	winText.EnableTranslucentText(True);
	winText.SetTextMargins(0, 0);
	winText.SetTextAlignments(HALIGN_Left, VALIGN_Top);
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	if (bSpewingText)
	{
		PrintNextCharacter();
	}
	else
	{
		displayTime -= deltaTime;

		if (displayTime <= 0)
		{
			bTickEnabled = False;
			HideMessage();
		}
	}
}

// ----------------------------------------------------------------------
// HideMessage()
// ----------------------------------------------------------------------

function HideMessage()
{
	Hide();
}

// ----------------------------------------------------------------------
// ParentRequestedPreferredSize() 
// ----------------------------------------------------------------------

event ParentRequestedPreferredSize(bool bWidthSpecified, out float preferredWidth,
                                   bool bHeightSpecified, out float preferredHeight)
{
	local GC gc;

	gc = GetGC();

	gc.SetFont(fontText);
	gc.GetTextExtent(maxTextWidth, preferredWidth, preferredHeight, ConvertScriptString(message));

	preferredWidth  += shadowDist;
	preferredHeight += shadowDist;

	ReleaseGC(gc);
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
//
// Set the size of stuff and stuff.
// ----------------------------------------------------------------------

function ConfigurationChanged()
{

	winText.ConfigureChild(0, 0, width, height);
	winTextShadow.ConfigureChild(shadowDist, shadowDist, width, height);
}

// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

event bool ChildRequestedReconfiguration(window childWin)
{
	return False;
}

// ----------------------------------------------------------------------
// AddMessage()
// ----------------------------------------------------------------------

function AddMessage(String str)
{
	if (str != "")
	{
		if (message != "")
		{
			message = message $ "|n";
		}
		message = message $ str;
	}
}

// ----------------------------------------------------------------------
// StartMessage()
// ----------------------------------------------------------------------

function StartMessage()
{
	Show();
	AskParentForReconfigure();
	bTickEnabled = True;
	bSpewingText = True;
}

// ----------------------------------------------------------------------
// PrintNextCharacter()
// ----------------------------------------------------------------------

function PrintNextCharacter()
{
	if (charIndex < len(message))
	{
		if ((mid(message, charIndex, 1) == "|") && (mid(message, charIndex, 2) == "|n"))
		{
			winText.AppendText("|n");
			winTextShadow.AppendText("|n");
			charIndex += 2;
		}
		else
		{
			winText.AppendText(mid(message, charIndex, 1));
			winTextShadow.AppendText(mid(message, charIndex, 1));
			charIndex++;
		}
	}
	else
	{
		// Now more characters to print, so pause and then go away
		bSpewingText = False;
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     fontText=Font'DeusExUI.FontLocation'
     shadowDist=2
     perCharDelay=0.100000
     displayTime=5.000000
     maxTextWidth=500
     colText=(R=255,G=255,B=255)
}
