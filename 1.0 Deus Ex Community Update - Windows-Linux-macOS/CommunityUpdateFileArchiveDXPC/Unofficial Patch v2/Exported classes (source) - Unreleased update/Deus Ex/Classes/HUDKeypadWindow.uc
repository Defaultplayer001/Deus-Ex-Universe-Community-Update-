//=============================================================================
// HUDKeypadWindow
//=============================================================================

class HUDKeypadWindow extends DeusExBaseWindow;

var bool bFirstFrameDone;

var HUDKeypadButton btnKeys[12];
var TextWindow winText;
var string inputCode;

var bool bInstantSuccess;		// we had the skill, so grant access immediately
var bool bWait;

var Keypad keypadOwner;			// what keypad owns this window?

var Texture texBackground;
var Texture texBorder;

// Border and Background Translucency
var bool bBorderTranslucent;
var bool bBackgroundTranslucent;
var bool bDrawBorder;

// Default Colors
var Color colBackground;
var Color colBorder;
var Color colHeaderText;

var localized string msgEnterCode;
var localized string msgAccessDenied;
var localized string msgAccessGranted;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetWindowAlignments(HALIGN_Center, VALIGN_Center);
	SetSize(103, 162);
	SetMouseFocusMode(MFocus_EnterLeave);

	inputCode="";

	// Create the buttons
	CreateKeypadButtons();
	CreateInputTextWindow();

	bTickEnabled = True;

	StyleChanged();
}

// ----------------------------------------------------------------------
// DestroyWindow()
//
// Destroys the Window
// ----------------------------------------------------------------------

event DestroyWindow()
{
	Super.DestroyWindow();

	keypadOwner.keypadwindow = None;
}

// ----------------------------------------------------------------------
// InitData()
// 
// Do the post-InitWindow stuff
// ----------------------------------------------------------------------

function InitData()
{
	GenerateKeypadDisplay();

	winText.SetTextColor(colHeaderText);
	winText.SetText(msgEnterCode);
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	if (!bFirstFrameDone)
	{
		SetCursorPos(width, height);
		bFirstFrameDone = True;

		if (bInstantSuccess)
		{
			inputCode = keypadOwner.validCode;
			ValidateCode();
		}
	}
}

// ----------------------------------------------------------------------
// DrawWindow()
// 
// DrawWindow event (called every frame)
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	// First draw the background then the border
	DrawBackground(gc);
	DrawBorder(gc);

	Super.DrawWindow(gc);
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
	if (bBackgroundTranslucent)
		gc.SetStyle(DSTY_Translucent);
	else
		gc.SetStyle(DSTY_Masked);
	
	gc.SetTileColor(colBackground);

	gc.DrawTexture(0, 0, width, height, 0, 0, texBackground);
}

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

function DrawBorder(GC gc)
{
	if (bDrawBorder)
	{
		if (bBorderTranslucent)
			gc.SetStyle(DSTY_Translucent);
		else
			gc.SetStyle(DSTY_Masked);
		
		gc.SetTileColor(colBorder);

		gc.DrawTexture(0, 0, width, height, 0, 0, texBorder);
	}
}

// ----------------------------------------------------------------------
// CreateKeypadButtons()
// ----------------------------------------------------------------------

function CreateKeypadButtons()
{
	local int i, x, y;

	for (y=0; y<4; y++)
	{
		for (x=0; x<3; x++)
		{
			i = x + y * 3;
			btnKeys[i] = HUDKeypadButton(NewChild(Class'HUDKeypadButton'));
			btnKeys[i].SetPos((x * 26) + 16, (y * 28) + 35);
			btnKeys[i].num = i;
		}
	}
}

// ----------------------------------------------------------------------
// CreateInputTextWindow()
// ----------------------------------------------------------------------

function CreateInputTextWindow()
{
	winText = TextWindow(NewChild(Class'TextWindow'));
	winText.SetPos(17, 21);
	winText.SetSize(75, 11);
	winText.SetTextMargins(0, 0);
	winText.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winText.SetFont(Font'FontMenuSmall');
	winText.SetTextColor(colHeaderText);
	winText.SetText(msgEnterCode);
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;
	local int i;

	bHandled = False;

	for (i=0; i<12; i++)
	{
		if (buttonPressed == btnKeys[i])
		{
			PressButton(i);
			bHandled = True;
			break;
		}
	}

	if (!bHandled)
		bHandled = Super.ButtonActivated(buttonPressed);

	return bHandled;
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

	if (IsKeyDown(IK_Alt) || IsKeyDown(IK_Ctrl))
		return False;

	if (!bRepeat)
	{
		switch(key) 
		{	
			case IK_0:
			case IK_NUMPAD0:	btnKeys[10].PressButton(); break;
			case IK_1:
			case IK_NUMPAD1:	btnKeys[0].PressButton(); break;
			case IK_2:
			case IK_NUMPAD2:	btnKeys[1].PressButton(); break;
			case IK_3:
			case IK_NUMPAD3:	btnKeys[2].PressButton(); break;
			case IK_4:
			case IK_NUMPAD4:	btnKeys[3].PressButton(); break;
			case IK_5:
			case IK_NUMPAD5:	btnKeys[4].PressButton(); break;
			case IK_6:
			case IK_NUMPAD6:	btnKeys[5].PressButton(); break;
			case IK_7:
			case IK_NUMPAD7:	btnKeys[6].PressButton(); break;
			case IK_8:
			case IK_NUMPAD8:	btnKeys[7].PressButton(); break;
			case IK_9:
			case IK_NUMPAD9:	btnKeys[8].PressButton(); break;

			default:
				bKeyHandled = False;
		}
	}

	if (!bKeyHandled)
		return Super.VirtualKeyPressed(key, bRepeat);
	else
		return bKeyHandled;
}

// ----------------------------------------------------------------------
// PressButton()
//
// User pressed a keypad button
// ----------------------------------------------------------------------

function PressButton(int num)
{
	local sound tone;

	if (bWait)
		return;

	if (Len(inputCode) < 16)
	{
		inputCode = inputCode $ IndexToString(num);
		switch (num)
		{
			case 0:		tone = sound'Touchtone1'; break;
			case 1:		tone = sound'Touchtone2'; break;
			case 2:		tone = sound'Touchtone3'; break;
			case 3:		tone = sound'Touchtone4'; break;
			case 4:		tone = sound'Touchtone5'; break;
			case 5:		tone = sound'Touchtone6'; break;
			case 6:		tone = sound'Touchtone7'; break;
			case 7:		tone = sound'Touchtone8'; break;
			case 8:		tone = sound'Touchtone9'; break;
			case 9:		tone = sound'Touchtone10'; break;
			case 10:	tone = sound'Touchtone0'; break;
			case 11:	tone = sound'Touchtone11'; break;
		}

		player.PlaySound(tone, SLOT_None);
	}

	GenerateKeypadDisplay();
	winText.SetTextColor(colHeaderText);
	winText.SetText(msgEnterCode);

	if (Len(inputCode) == Len(keypadOwner.validCode))
		ValidateCode();
}

// ----------------------------------------------------------------------
// ValidateCode()
// 
// Check for correct code entry
// ----------------------------------------------------------------------

function ValidateCode()
{
	local Actor A;
	local int i;

	if (inputCode == keypadOwner.validCode)
	{
		if (keypadOwner.Event != '')
		{
			if (keypadOwner.bToggleLock)
			{
				// Toggle the locked/unlocked state of the DeusExMover
            player.KeypadToggleLocks(keypadOwner);
			}
			else
			{
				// Trigger the successEvent
            player.KeypadRunEvents(keypadOwner, True);
			}
		}

		// UnTrigger event (if used)
      // DEUS_EX AMSD Export to player(and then to keypad), for multiplayer.
      player.KeypadRunUntriggers(keypadOwner);

		player.PlaySound(keypadOwner.successSound, SLOT_None);
		winText.SetTextColor(colGreen);
		winText.SetText(msgAccessGranted);
	}
	else
	{
		//Trigger failure event
      if (keypadOwner.FailEvent != '')      
         player.KeypadRunEvents(keypadOwner, False);

		player.PlaySound(keypadOwner.failureSound, SLOT_None);
		winText.SetTextColor(colRed);
		winText.SetText(msgAccessDenied);
	}

	bWait = True;
	AddTimer(1.0, False, 0, 'KeypadDelay');
}

// ----------------------------------------------------------------------
// KeypadDelay()
//
// timer function to pause after code entry
// ----------------------------------------------------------------------

function KeypadDelay(int timerID, int invocations, int clientData)
{
	bWait = False;

	// if we entered a valid code, get out
	if (inputCode == keypadOwner.validCode)
		root.PopWindow();
	else
	{
		inputCode = "";
		GenerateKeypadDisplay();
		winText.SetTextColor(colHeaderText);
		winText.SetText(msgEnterCode);
	}
}

// ----------------------------------------------------------------------
// IndexToString()
// 
// Convert the numbered button to a character
// ----------------------------------------------------------------------

function string IndexToString(int num)
{
	local string str;

	// buttons 0-8 are ok as is (text 1-9)
	// button 9 is *
	// button 10 is 0
	// button 11 is #
	switch (num)
	{
		case 9:		str = "*"; break;
		case 10:	str = "0"; break;
		case 11:	str = "#"; break;
		default:	str = String(num+1); break;
	}

	return str;
}

// ----------------------------------------------------------------------
// GenerateKeypadDisplay()
//
// Generate the keypad's display
// ----------------------------------------------------------------------

function GenerateKeypadDisplay()
{
	local int i;

	msgEnterCode = "";

	for (i=0; i<Len(keypadOwner.validCode); i++)
	{
		if (i == Len(inputCode))
			msgEnterCode = msgEnterCode $ "|p5";
		msgEnterCode = msgEnterCode $ "~";
	}
}


// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colBackground = theme.GetColorFromName('HUDColor_Background');
	colBorder     = theme.GetColorFromName('HUDColor_Borders');
	colHeaderText = theme.GetColorFromName('HUDColor_HeaderText');

	bBorderTranslucent     = player.GetHUDBorderTranslucency();
	bBackgroundTranslucent = player.GetHUDBackgroundTranslucency();
	bDrawBorder            = player.GetHUDBordersVisible();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texBackground=Texture'DeusExUI.UserInterface.HUDKeypadBackground'
     texBorder=Texture'DeusExUI.UserInterface.HUDKeypadBorder'
     msgAccessDenied="~~DENIED~~"
     msgAccessGranted="~~GRANTED~~"
}
