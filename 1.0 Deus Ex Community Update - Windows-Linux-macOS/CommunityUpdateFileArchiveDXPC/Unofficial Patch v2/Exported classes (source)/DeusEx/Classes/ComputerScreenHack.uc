//=============================================================================
// ComputerScreenHack
//=============================================================================
class ComputerScreenHack extends HUDBaseWindow;

var PersonaNormalTextWindow   winDigits;
var PersonaHeaderTextWindow   winHackMessage;
var PersonaActionButtonWindow btnHack;
var ProgressBarWindow         barHackProgress;

var NetworkTerminal           winTerm;
var Float                     detectionTime;
var Float                     saveDetectionTime;
var Float                     hackTime;
var Float                     saveHackTime;
var Float                     blinkTimer;
var Float                     digitUpdateTimer;
var Float                     hackDetectedDelay;
var Bool                      bHacking;
var Bool		              bHacked;
var Bool                      bHackDetected;
var Bool                      bHackDetectedNotified;

var Int    digitWidth;
var String digitStrings[4];
var String digitFillerChars;
var Color  colDigits;
var Color  colRed;

// Defaults
var Texture texBackground;
var Texture texBorder;

// Text
var localized String HackButtonLabel;
var localized String ReturnButtonLabel;
var localized String HackReadyLabel;
var localized String HackInitializingLabel;
var localized String HackSuccessfulLabel;
var localized String HackDetectedLabel;
var localized String MPHackInitializingLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(215, 112);

	CreateControls();	

	SetHackMessage(HackReadyLabel);
}

// ----------------------------------------------------------------------
// DestroyWindow()
//
// Destroys the Window
// ----------------------------------------------------------------------

event DestroyWindow()
{
	if ((bHackDetected) && (!bHackDetectedNotified) && (winTerm != None))
		winTerm.HackDetected(True);

	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	CreateTextDigits();
	CreateHackMessageWindow();
	CreateHackProgressBar();
	CreateHackButton();	
}

// ----------------------------------------------------------------------
// CreateHackMessageWindow()
// ----------------------------------------------------------------------

function CreateHackMessageWindow()
{
	winHackMessage = PersonaHeaderTextWindow(NewChild(Class'PersonaHeaderTextWindow'));
	winHackMessage.SetPos(22, 19);
	winHackMessage.SetSize(168, 47);
	winHackMessage.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winHackMessage.SetBackgroundStyle(DSTY_Modulated);
	winHackMessage.SetBackground(Texture'HackInfoBackground');
}

// ----------------------------------------------------------------------
// CreateTextDigits()
// ----------------------------------------------------------------------

function CreateTextDigits()
{
	winDigits = PersonaNormalTextWindow(NewChild(Class'PersonaNormalTextWindow'));
	winDigits.SetPos(22, 19);
	winDigits.SetSize(168, 47);
	winDigits.SetFont(Font'FontFixedWidthSmall');
	winDigits.SetTextColor(colDigits);
	winDigits.SetTextAlignments(HALIGN_Left, VALIGN_Top);
	winDigits.SetTextMargins(0, 0);
}

// ----------------------------------------------------------------------
// CreateHackProgressBar()
// ----------------------------------------------------------------------

function CreateHackProgressBar()
{
	barHackProgress = ProgressBarWindow(NewChild(Class'ProgressBarWindow'));
	barHackProgress.SetPos(22, 71);
	barHackProgress.SetSize(169, 12);
	barHackProgress.SetValues(0, 100);
	barHackProgress.SetVertical(False);
	barHackProgress.UseScaledColor(True);
	barHackProgress.SetDrawBackground(False);
	barHackProgress.SetCurrentValue(100);
}

// ----------------------------------------------------------------------
// CreateHackButton()
// ----------------------------------------------------------------------

function CreateHackButton()
{
	local PersonaButtonBarWindow winActionButtons;

	winActionButtons = PersonaButtonBarWindow(NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(20, 86);
	winActionButtons.SetWidth(88);
	winActionButtons.FillAllSpace(False);

	btnHack = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnHack.SetButtonText(HackButtonLabel);
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
	gc.SetStyle(backgroundDrawStyle);
	gc.SetTileColor(colBackground);
	gc.DrawTexture(
		backgroundPosX, backgroundPosY, 
		backgroundWidth, backgroundHeight, 
		0, 0, texBackground);
}

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

function DrawBorder(GC gc)
{
	if (bDrawBorder)
	{
		gc.SetStyle(borderDrawStyle);
		gc.SetTileColor(colBorder);
		gc.DrawTexture(0, 0, 221, 112, 0, 0, texBorder);
	}
}

// ----------------------------------------------------------------------
// SetNetworkTerminal()
// ----------------------------------------------------------------------

function SetNetworkTerminal(NetworkTerminal newTerm)
{
	winTerm = newTerm;
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	bHandled = True;

	switch( buttonPressed )
	{
		case btnHack:
			if (winTerm != None)
			{
				if (bHacked)
					winTerm.ComputerHacked();
				else
					StartHack();

				btnHack.SetSensitivity(False);
			}
			break;

		default:
			bHandled = False;
			break;
	}

	if (bHandled)
		return True;
	else
		return Super.ButtonActivated(buttonPressed);
}

// ----------------------------------------------------------------------
// StartHack()
// ----------------------------------------------------------------------

function StartHack()
{
	bHacking     = True;
	bTickEnabled = True;

	// Display hack message
   if (Player.Level.NetMode == NM_Standalone)	
      SetHackMessage(HackInitializingLabel);
   else
      SetHackMessage(MPHackInitializingLabel);
}

// ----------------------------------------------------------------------
// FinishHack()
// ----------------------------------------------------------------------

function FinishHack()
{
	bHacked = True;

	// Display hack message
	SetHackMessage(HackSuccessfulLabel);

	winDigits.SetText("");

	if (winTerm != None)
		winTerm.ComputerHacked();
}

// ----------------------------------------------------------------------
// HackDetected()
// ----------------------------------------------------------------------

function HackDetected()
{
	bHackDetected = True;
	blinkTimer    = Default.blinkTimer;
	detectionTime = hackDetectedDelay;
	bTickEnabled  = True;
	SetHackMessage(HackDetectedLabel);
	winHackMessage.SetTextColor(colRed);
}

// ----------------------------------------------------------------------
// SetHackMessage()
// ----------------------------------------------------------------------

function SetHackMessage(String newHackMessage)
{
	if (newHackMessage == "")
		winHackMessage.Hide();
	else
		winHackMessage.Show();

	winHackMessage.SetText(newHackMessage);
}

// ----------------------------------------------------------------------
// SetDetectionTime()
// ----------------------------------------------------------------------

function SetDetectionTime(Float newDetectionTime, Float newHackTime)
{
	// The detection time is how long it takes before the user is 
	// caught and electrified.  This now includes the Hack time to 
	// give the player the perception that he's being tracked 
	// immediately (a little more tense).  When in reality he has the 
	// same amount of "detection" time (once hacked) as before.

	detectionTime     = newDetectionTime + newHackTime;
	saveDetectionTime = detectionTime;

	// Hack time is also based on skill
	hackTime      = newHackTime;
	saveHackTime  = hackTime;
}

// ----------------------------------------------------------------------
// GetSaveDetectionTime()
// ----------------------------------------------------------------------

function Float GetSaveDetectionTime()
{
	return saveDetectionTime;
}

// ----------------------------------------------------------------------
// UpdateDetectionTime()
// ----------------------------------------------------------------------

function UpdateDetectionTime(Float newDetectionTime)
{
	detectionTime = newDetectionTime;

	// Update the progress bar
	UpdateHackBar();
}

// ----------------------------------------------------------------------
// UpdateDigits()
// ----------------------------------------------------------------------

function UpdateDigits()
{
	local bool bSpace;
	local int stringIndex;

	// First move down the existing strings

	for(stringIndex=arrayCount(digitStrings)-1; stringIndex>0;	stringIndex--)
		digitStrings[stringIndex] = digitStrings[stringIndex-1];
	
	// Now fill the string.  As we get closer to detection time, 
	// will fill with more characters
	
	digitStrings[0] = "";

	for(stringIndex=0; stringIndex<digitWidth; stringIndex++)
	{
		// Calculate chance that this is a space
		bSpace = ((saveHackTime - hackTime) / saveHackTime) > FRand();

		if (bSpace)
			digitStrings[0] = digitStrings[0] $ " ";
		else
			digitStrings[0] = digitStrings[0] $ Mid(digitFillerChars, Rand(Len(digitFillerChars)) + 1, 1);
	}

	winDigits.SetText("");

	for(stringIndex=0; stringIndex<arrayCount(digitStrings); stringIndex++)
	{
		winDigits.AppendText(digitStrings[stringIndex]);
		if (stringIndex - 1 == arrayCount(digitStrings))
			winDigits.AppendText("|n");
	}
}

// ----------------------------------------------------------------------
// UpdateHackBar()
// ----------------------------------------------------------------------

function UpdateHackBar()
{
	local float percentRemaining;

	percentRemaining = (detectionTime / saveDetectionTime) * 100;
	barHackProgress.SetCurrentValue(percentRemaining);
}

// ----------------------------------------------------------------------
// SetHackButtonToReturn()
// ----------------------------------------------------------------------

function SetHackButtonToReturn()
{
	btnHack.SetSensitivity(True);
	btnHack.SetButtonText(ReturnButtonLabel);
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	if (bHacking)	// manage initial hacking
	{
		hackTime         -= deltaTime;
		blinkTimer       -= deltaTime;
		digitUpdateTimer -= deltaTime;

		// Update blinking text
		if (blinkTimer < 0)
		{
			if (winHackMessage.GetText() == "")
			{
				blinkTimer = Default.blinkTimer;
            // Display hack message
            if (Player.Level.NetMode == NM_Standalone)	
               SetHackMessage(HackInitializingLabel);
            else
               SetHackMessage(MPHackInitializingLabel);
			}
			else
			{
				blinkTimer = Default.blinkTimer / 3;
				winHackMessage.SetText("");
			}
		}

		// Update scrolling text
		if (digitUpdateTimer < 0)
		{
			digitUpdateTimer = Default.digitUpdateTimer;
			UpdateDigits();
		}

		if (hackTime < 0)
		{
			bHacking = False;
			FinishHack();
		}	
	}
	
	if (bHackDetected)
	{
		detectionTime -= deltaTime;
		blinkTimer    -= deltaTime;

		// Update blinking text
		if (blinkTimer < 0)
		{
			if (winHackMessage.GetText() == "")
			{
				blinkTimer = Default.blinkTimer;
				winHackMessage.SetText(HackDetectedLabel);
			}
			else
			{
				blinkTimer = Default.blinkTimer / 3;
				winHackMessage.SetText("");
			}
		}

		if (detectionTime < 0)
		{
			if (winTerm != None)
			{
				bHackDetectedNotified = True;
				winTerm.HackDetected();
			}
		}
	}
	else
	{
		// manage detection
		detectionTime -= deltaTime;

		// Update the progress bar
		UpdateHackBar();

		if (detectionTime < 0)
		{
			detectionTime = 0;
			bTickEnabled = False;
			HackDetected();
		}
	}
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bKeyHandled;
	bKeyHandled = True;

	switch( key ) 
	{	
		case IK_Escape:
			winTerm.ForceCloseScreen();	
			break;

		default:
			bKeyHandled = False;
	}

	if (bKeyHandled)
		return True;
	else
		return Super.VirtualKeyPressed(key, bRepeat);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     blinkTimer=1.000000
     digitUpdateTimer=0.050000
     hackDetectedDelay=3.000000
     digitWidth=23
     digitFillerChars="01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()_+-=][}{"
     colDigits=(G=128)
     colRed=(R=255)
     texBackground=Texture'DeusExUI.UserInterface.ComputerHackBackground'
     texBorder=Texture'DeusExUI.UserInterface.ComputerHackBorder'
     HackButtonLabel="|&Hack"
     ReturnButtonLabel="|&Return"
     HackReadyLabel="Ice Breaker Ready..."
     HackInitializingLabel="Initializing ICE Breaker..."
     HackSuccessfulLabel="ICE Breaker Hack Successful..."
     HackDetectedLabel="*** WARNING ***|nINTRUDER DETECTED!"
     MPHackInitializingLabel="Hacking... Hit ESC to Abort"
     backgroundWidth=187
     backgroundHeight=94
     backgroundPosX=14
     backgroundPosY=13
}
