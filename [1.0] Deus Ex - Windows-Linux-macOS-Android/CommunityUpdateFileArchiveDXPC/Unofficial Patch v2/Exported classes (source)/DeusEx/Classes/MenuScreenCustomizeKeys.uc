//=============================================================================
// MenuScreenCustomizeKeys
//=============================================================================

class MenuScreenCustomizeKeys expands MenuUIScreenWindow;

var MenuUIListHeaderButtonWindow btnHeaderAction;
var MenuUIListHeaderButtonWindow btnHeaderAssigned;
var MenuUIListWindow			 lstKeys;
var MenuUIScrollAreaWindow		 winScroll;

struct S_KeyDisplayItem
{
	var EInputKey inputKey;
	var localized String DisplayName;
};

var localized string	FunctionText[61];
var string				MenuValues1[61];
var string				MenuValues2[61];
var string				AliasNames[61];
var string				PendingCommands[100];
var localized S_KeyDisplayItem    keyDisplayNames[71];
var localized string			  NoneText;
var int					Pending;
var int					selection;		
var Bool				bWaitingForInput;

var localized string strHeaderActionLabel;
var localized string strHeaderAssignedLabel;
var localized string WaitingHelpText;
var localized string InputHelpText;
var localized string ReassignedFromLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	Pending = 0;
	Selection = -1;
	bWaitingForInput = False;
	BuildKeyBindings();

	CreateKeyList();
	CreateHeaderButtons();
	PopulateKeyList();
	ShowHelp(WaitingHelpText);
}

// ----------------------------------------------------------------------
// VirtualKeyPressed() 
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	if ( !bWaitingForInput ) 
	{
		// If the user presses [Delete] or [Backspace], then 
		// clear this setting
		if ((key == IK_Delete) || (key == IK_Backspace))
		{
			ClearFunction();
			return True;
		}
		else
		{
			return Super.VirtualKeyPressed(key, bRepeat);
		}
	}

	// First check to see if we're waiting for the user to select a 
	// keyboard or mouse/joystick button to override. 
	WaitingForInput(False);
                                                                                
	ProcessKeySelection( key, mid(string(GetEnum(enum'EInputKey',key)),3), GetKeyDisplayName(key) );

	return True;
}

// ----------------------------------------------------------------------
// RawMouseButtonPressed()
// ----------------------------------------------------------------------

event bool RawMouseButtonPressed(float pointX, float pointY,
                                 EInputKey button, EInputState iState)
{
	if ( !bWaitingForInput )
		return False;

	if ( iState != IST_Release )
		return True;

	// First check to see if we're waiting for the user to select a 
	// keyboard or mouse/joystick button to override. 
	//
	// Ignore everything but mouse button and wheel presses
	switch( button )
	{
		case IK_MouseWheelUp:
		case IK_MouseWheelDown:
		case IK_LeftMouse:
		case IK_RightMouse:
		case IK_MiddleMouse:
			ProcessKeySelection( button, mid(string(GetEnum(enum'EInputKey',button)),3), GetKeyDisplayName(button ));
			WaitingForInput(False);
			break;
	}

	return True;
}

// ----------------------------------------------------------------------
// ListRowActivated()
//
// User double-clicked on one of the rows, meaning he/she/it wants 
// to redefine one of the functions
// ----------------------------------------------------------------------

event bool ListRowActivated(window list, int rowId)
{
	// Show help
	ShowHelp(InputHelpText);

	selection = lstKeys.RowIdToIndex(rowId);

	WaitingForInput(True);

	return True;
}

// ----------------------------------------------------------------------
// WaitingForInput()
// ----------------------------------------------------------------------

function WaitingForInput(bool bWaiting)
{
 	if ( bWaiting )
	{
		ShowHelp(InputHelpText);
			
		SetSelectability(True);
		SetFocusWindow(Self);
		GrabMouse();

		root.LockMouse(True, False);
		root.ShowCursor(False);
	}
	else
	{
		ShowHelp(WaitingHelpText);

		SetSelectability(False);
		UngrabMouse();

		root.LockMouse(False, False);
		root.ShowCursor(True);

		// Set the focus back to the list
		SetFocusWindow(lstKeys);
	}

	bWaitingForInput = bWaiting;
}

// ----------------------------------------------------------------------
// SaveSettings()
// ----------------------------------------------------------------------

function SaveSettings()
{
	ProcessPending();
}

// ----------------------------------------------------------------------
// ClearFunction()
// ----------------------------------------------------------------------

function ClearFunction()
{
	local int rowID;
	local int rowIndex;

	rowID = lstKeys.GetSelectedRow();

	if (rowID != 0)
	{
		rowIndex = lstKeys.RowIdToIndex(rowID);

		if (MenuValues2[rowIndex] != "")
		{
			if (CanRemapKey(MenuValues2[rowIndex]))
			{
				AddPending("SET InputExt " $ GetKeyFromDisplayName(MenuValues2[rowIndex]));
				MenuValues2[rowIndex] = "";
			}
		}

		if (MenuValues1[rowIndex] != "")
		{
			if (CanRemapKey(MenuValues1[rowIndex]))
			{
				AddPending("SET InputExt " $ GetKeyFromDisplayName(MenuValues1[rowIndex]));
				MenuValues1[rowIndex] = MenuValues2[rowIndex];
				MenuValues2[rowIndex] = "";
			}
		}

		// Update the buttons
		RefreshKeyBindings();
	}
}

// ----------------------------------------------------------------------
// BuildKeyBindings()
// ----------------------------------------------------------------------

function BuildKeyBindings()
{
	local int i, j, pos;
	local string KeyName;
	local string Alias;

	// First, clear all the existing keybinding display 
	// strings in the MenuValues[1|2] arrays
	
	for(i=0; i<arrayCount(MenuValues1); i++)
	{
		MenuValues1[i] = "";
		MenuValues2[i] = "";
	}

	// Now loop through all the keynames and generate
	// human-readable versions of keys that are mapped.

	for ( i=0; i<255; i++ )
	{
		KeyName = player.ConsoleCommand ( "KEYNAME "$i );
		if ( KeyName != "" )
		{
			Alias = player.ConsoleCommand( "KEYBINDING "$KeyName );

			if ( Alias != "" )
			{
				pos = InStr(Alias, " " );
				if ( pos != -1 )
					Alias = Left(Alias, pos);

				for ( j=0; j<arrayCount(AliasNames); j++ )
				{
					if ( AliasNames[j] == Alias )
					{
						if ( MenuValues1[j] == "" )
							MenuValues1[j] = GetKeyDisplayNameFromKeyName(KeyName);
						else if ( MenuValues2[j] == "" )
							MenuValues2[j] = GetKeyDisplayNameFromKeyName(KeyName);
					}
				}
			}
		}
	}
}

// ----------------------------------------------------------------------
// ProcessPending()
// ----------------------------------------------------------------------

function ProcessPending()
{
	local int i;

	for ( i=0; i<Pending; i++ )
		player.ConsoleCommand(PendingCommands[i]);
		
	Pending = 0;
}

// ----------------------------------------------------------------------
// AddPending()
// ----------------------------------------------------------------------

function AddPending(string newCommand)
{
	PendingCommands[Pending] = newCommand;
	Pending++;
	if ( Pending == 100 )
		ProcessPending();
}

// ----------------------------------------------------------------------
// GetKeyFromDisplayName()
// ----------------------------------------------------------------------

function String GetKeyFromDisplayName(String displayName)
{
	local int keyIndex;

	for(keyIndex=0; keyIndex<arrayCount(keyDisplayNames); keyIndex++)
	{
		if (displayName == keyDisplayNames[keyIndex].displayName)
		{
			return mid(String(GetEnum(enum'EInputKey', keyDisplayNames[keyIndex].inputKey)), 3);
			break;
		}
	}

	return displayName;
}

// ----------------------------------------------------------------------
// GetKeyDisplayName()
// ----------------------------------------------------------------------

function String GetKeyDisplayName(EInputKey inputKey)
{
	local int keyIndex;

	for(keyIndex=0; keyIndex<arrayCount(keyDisplayNames); keyIndex++)
	{
		if (inputKey == keyDisplayNames[keyIndex].inputKey)
		{
			return keyDisplayNames[keyIndex].DisplayName;
			break;
		}
	}

	return mid(string(GetEnum(enum'EInputKey',inputKey)),3);
}
	
// ----------------------------------------------------------------------
// GetKeyDisplayNameFromKeyName()
// ----------------------------------------------------------------------

function String GetKeyDisplayNameFromKeyName(string keyName)
{
	local int keyIndex;

	for(keyIndex=0; keyIndex<arrayCount(keyDisplayNames); keyIndex++)
	{
		if (mid(string(GetEnum(enum'EInputKey', keyDisplayNames[keyIndex].inputKey)), 3) == keyName)
		{
			return keyDisplayNames[keyIndex].DisplayName;
			break;
		}
	}

	return keyName;
}

// ----------------------------------------------------------------------
// CanRemapKey()
// ----------------------------------------------------------------------

function bool CanRemapKey(string KeyName)
{
	if ((KeyName == "F1") || (KeyName == "F2"))  // hack - DEUS_EX STM
		return false;
	else
		return true;
}

// ----------------------------------------------------------------------
// ProcessKeySelection()
// ----------------------------------------------------------------------

function ProcessKeySelection(int KeyNo, string KeyName, string keyDisplayName)
{
	local int i;

	// Some keys CANNOT be assigned:
	//
	// 1.  Escape
	// 2.  Function keys (used by Augs)
	// 3.  Number keys (used by Object Belt)
	// 4.  Tilde (used for console)
	// 5.  Pause (used to pause game)
	// 6.  Print Screen (Well, duh)

	// Make sure the user enters a valid key (Escape and function
	// keys can't be assigned)
	if ( (KeyName == "") || (KeyName == "Escape") ||		// Escape
		 ((KeyNo >= 0x70 ) && (KeyNo <= 0x81)) || 			// Function keys
		 ((KeyNo >= 48) && (KeyNo <= 57)) ||				// 0 - 9
		 (KeyName == "Tilde") ||							// Tilde
		 (KeyName == "PrintScrn") ||						// Print Screen
		 (KeyName == "Pause") )                     // Pause
	{
		return;
	}

	// Don't waste our time if this key is already assigned here
	if (( MenuValues1[Selection] == keyDisplayName ) ||
	   ( MenuValues2[Selection] == keyDisplayName ))
	   return;

	// Now check to make sure there are no overlapping 
	// assignments.  

	for ( i=0; i<arrayCount(AliasNames); i++ )
	{
		if ( MenuValues2[i] == keyDisplayName )
		{
			ShowHelp(Sprintf(ReassignedFromLabel, keyDisplayName, FunctionText[i]));
			AddPending("SET InputExt " $ GetKeyFromDisplayName(MenuValues2[i]));
			MenuValues2[i] = "";
		}

		if ( MenuValues1[i] == keyDisplayName )
		{
			ShowHelp(Sprintf(ReassignedFromLabel, keyDisplayName, FunctionText[i]));
			AddPending("SET InputExt " $ GetKeyFromDisplayName(MenuValues1[i]));
			MenuValues1[i] = MenuValues2[i];
			MenuValues2[i] = "";
		}
	}

	// Now assign the key, trying the first space if it's empty,
	// but using the second space if necessary.  If both slots
	// are filled, then move the second entry into the first 
	// and put the new assignment in the second slot.

	if ( MenuValues1[Selection] == "" ) 
	{
		MenuValues1[Selection] = keyDisplayName;
	}
	else if ( MenuValues2[Selection] == "" )
	{
		MenuValues2[Selection] = keyDisplayName;
	}
	else
	{
  		if (CanRemapKey(MenuValues1[Selection]))
		{
			// Undo first key assignment
			AddPending("SET InputExt " $ GetKeyFromDisplayName(MenuValues1[Selection]));

			MenuValues1[Selection] = MenuValues2[Selection];
			MenuValues2[Selection] = keyDisplayName;
		}
		else if (CanRemapKey(MenuValues2[Selection]))
		{
			// Undo second key assignment
			AddPending("SET InputExt " $ GetKeyFromDisplayName(MenuValues2[Selection]));

			MenuValues2[Selection] = keyDisplayName;
		}

	}

	AddPending("SET InputExt "$KeyName$" "$AliasNames[Selection]);

	// Update the buttons
	RefreshKeyBindings();
}

// ----------------------------------------------------------------------
// CreateKeyList()
//
// Creates the listbox containing the key bindings
// ----------------------------------------------------------------------

function CreateKeyList()
{
	winScroll = CreateScrollAreaWindow(winClient);

	winScroll.SetPos(11, 23);
	winScroll.SetSize(369, 268);

	lstKeys = MenuUIListWindow(winScroll.clipWindow.NewChild(Class'MenuUIListWindow'));
	lstKeys.EnableMultiSelect(False);
	lstKeys.EnableAutoExpandColumns(False);
	lstKeys.EnableHotKeys(False);

	lstKeys.SetNumColumns(2);

	lstKeys.SetColumnWidth(0, 164);
	lstKeys.SetColumnType(0, COLTYPE_String);
	lstKeys.SetColumnWidth(1, 205);
	lstKeys.SetColumnType(1, COLTYPE_String);
}

// ----------------------------------------------------------------------
// PopulateKeyList()
// ----------------------------------------------------------------------

function PopulateKeyList()
{
	local int keyIndex;

	// First erase the old list
	lstKeys.DeleteAllRows();

	for(keyIndex=0; keyIndex<arrayCount(AliasNames); keyIndex++ )
		lstKeys.AddRow(FunctionText[keyIndex] $ ";" $ GetInputDisplayText(keyIndex));
}

// ----------------------------------------------------------------------
// CreateHeaderButtons()
// ----------------------------------------------------------------------

function CreateHeaderButtons()
{
	btnHeaderAction   = CreateHeaderButton(10,  3, 162, strHeaderActionLabel,   winClient);
	btnHeaderAssigned = CreateHeaderButton(175, 3, 157, strHeaderAssignedLabel, winClient);

	btnHeaderAction.SetSensitivity(False);
	btnHeaderAssigned.SetSensitivity(False);
}

// ----------------------------------------------------------------------
// GetInputDisplayText()
// ----------------------------------------------------------------------

function String GetInputDisplayText(int keyIndex)
{
	if ( MenuValues1[keyIndex] == "" )
		return NoneText;
	else if ( MenuValues2[keyIndex] != "" )
		return MenuValues1[keyIndex] $ "," @ MenuValues2[keyIndex];
	else
		return MenuValues1[keyIndex];
}

// ----------------------------------------------------------------------
// RefreshKeyBindings()
// ----------------------------------------------------------------------

function RefreshKeyBindings()
{
	local int keyIndex;
	local int rowId;

	for(keyIndex=0; keyIndex<arrayCount(AliasNames); keyIndex++ )
	{
		rowId = lstKeys.IndexToRowId(keyIndex);
		lstKeys.SetField(rowId, 1, GetInputDisplayText(keyIndex));
	}
}

// ----------------------------------------------------------------------
// ResetToDefaults()
// ----------------------------------------------------------------------

function ResetToDefaults()
{
	Pending = 0;
	Selection = -1;
	bWaitingForInput = False;
	BuildKeyBindings();
	PopulateKeyList();
	ShowHelp(WaitingHelpText);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     FunctionText(0)="Fire Weapon/Use object in hand"
     FunctionText(1)="Use object in world"
     FunctionText(2)="Drop/Throw Item"
     FunctionText(3)="Put Away Item"
     FunctionText(4)="Move Forward"
     FunctionText(5)="Move Backward"
     FunctionText(6)="Turn Left"
     FunctionText(7)="Turn Right"
     FunctionText(8)="Strafe Left"
     FunctionText(9)="Strafe Right"
     FunctionText(10)="Lean Left"
     FunctionText(11)="Lean Right"
     FunctionText(12)="Jump"
     FunctionText(13)="Crouch"
     FunctionText(14)="Mouse Look"
     FunctionText(15)="Look Up"
     FunctionText(16)="Look Down"
     FunctionText(17)="Center View"
     FunctionText(18)="Walk/Run"
     FunctionText(19)="Toggle Walk/Run"
     FunctionText(20)="Strafe"
     FunctionText(21)="Select Next Belt Item"
     FunctionText(22)="Select Previous Belt Item"
     FunctionText(23)="Reload Weapon"
     FunctionText(24)="Toggle Scope"
     FunctionText(25)="Toggle Laser Sight"
     FunctionText(26)="Activate All Augmentations"
     FunctionText(27)="Deactivate All Augmentations"
     FunctionText(28)="Change Ammo"
     FunctionText(29)="Take Screenshot"
     FunctionText(30)="Activate Inventory Screen"
     FunctionText(31)="Activate Health Screen"
     FunctionText(32)="Activate Augmentations Screen"
     FunctionText(33)="Activate Skills Screen"
     FunctionText(34)="Activate Goals/Notes Screen"
     FunctionText(35)="Activate Conversations Screen"
     FunctionText(36)="Activate Images Screen"
     FunctionText(37)="Activate Logs Screen"
     FunctionText(38)="Quick Save"
     FunctionText(39)="Quick Load"
     FunctionText(40)="Toggle Crosshairs"
     FunctionText(41)="Toggle Hit Display"
     FunctionText(42)="Toggle Compass"
     FunctionText(43)="Toggle Augmentation Display"
     FunctionText(44)="Toggle Object Belt"
     FunctionText(45)="Toggle Ammo Display"
     FunctionText(46)="F3"
     FunctionText(47)="F4"
     FunctionText(48)="F5"
     FunctionText(49)="F6"
     FunctionText(50)="F7"
     FunctionText(51)="F8"
     FunctionText(52)="F9"
     FunctionText(53)="F10"
     FunctionText(54)="F11"
     FunctionText(55)="F12"
     FunctionText(56)="Show Multiplayer Scores"
     FunctionText(57)="Send Message To Team"
     FunctionText(58)="Send Message To All"
     FunctionText(59)="Activate Multiplayer Skill Menu"
     FunctionText(60)="Show Multiplayer Kill Details"
     AliasNames(0)="ParseLeftClick|Fire"
     AliasNames(1)="ParseRightClick"
     AliasNames(2)="DropItem"
     AliasNames(3)="PutInHand"
     AliasNames(4)="MoveForward"
     AliasNames(5)="MoveBackward"
     AliasNames(6)="TurnLeft"
     AliasNames(7)="TurnRight"
     AliasNames(8)="StrafeLeft"
     AliasNames(9)="StrafeRight"
     AliasNames(10)="LeanLeft"
     AliasNames(11)="LeanRight"
     AliasNames(12)="Jump"
     AliasNames(13)="Duck"
     AliasNames(14)="Look"
     AliasNames(15)="LookUp"
     AliasNames(16)="LookDown"
     AliasNames(17)="CenterView"
     AliasNames(18)="Walking"
     AliasNames(19)="ToggleWalk"
     AliasNames(20)="Strafe"
     AliasNames(21)="NextBeltItem"
     AliasNames(22)="PrevBeltItem"
     AliasNames(23)="ReloadWeapon"
     AliasNames(24)="ToggleScope"
     AliasNames(25)="ToggleLaser"
     AliasNames(26)="ActivateAllAugs"
     AliasNames(27)="DeactivateAllAugs"
     AliasNames(28)="SwitchAmmo"
     AliasNames(29)="Shot"
     AliasNames(30)="ShowInventoryWindow"
     AliasNames(31)="ShowHealthWindow"
     AliasNames(32)="ShowAugmentationsWindow"
     AliasNames(33)="ShowSkillsWindow"
     AliasNames(34)="ShowGoalsWindow"
     AliasNames(35)="ShowConversationsWindow"
     AliasNames(36)="ShowImagesWindow"
     AliasNames(37)="ShowLogsWindow"
     AliasNames(38)="QuickSave"
     AliasNames(39)="QuickLoad"
     AliasNames(40)="ToggleCrosshair"
     AliasNames(41)="ToggleHitDisplay"
     AliasNames(42)="ToggleCompass"
     AliasNames(43)="ToggleAugDisplay"
     AliasNames(44)="ToggleObjectBelt"
     AliasNames(45)="ToggleAmmoDisplay"
     AliasNames(46)="DualMapF3"
     AliasNames(47)="DualMapF4"
     AliasNames(48)="DualMapF5"
     AliasNames(49)="DualMapF6"
     AliasNames(50)="DualMapF7"
     AliasNames(51)="DualMapF8"
     AliasNames(52)="DualMapF9"
     AliasNames(53)="DualMapF10"
     AliasNames(54)="DualMapF11"
     AliasNames(55)="DualMapF12"
     AliasNames(56)="ShowScores"
     AliasNames(57)="TeamTalk"
     AliasNames(58)="Talk"
     AliasNames(59)="BuySkills"
     AliasNames(60)="KillerProfile"
     keyDisplayNames(0)=(inputKey=IK_LeftMouse,displayName="Left Mouse Button")
     keyDisplayNames(1)=(inputKey=IK_RightMouse,displayName="Right Mouse Button")
     keyDisplayNames(2)=(inputKey=IK_MiddleMouse,displayName="Middle Mouse Button")
     keyDisplayNames(3)=(inputKey=IK_CapsLock,displayName="CAPS Lock")
     keyDisplayNames(4)=(inputKey=IK_PageUp,displayName="Page Up")
     keyDisplayNames(5)=(inputKey=IK_PageDown,displayName="Page Down")
     keyDisplayNames(6)=(inputKey=IK_PrintScrn,displayName="Print Screen")
     keyDisplayNames(7)=(inputKey=IK_GreyStar,displayName="NumPad Asterisk")
     keyDisplayNames(8)=(inputKey=IK_GreyPlus,displayName="NumPad Plus")
     keyDisplayNames(9)=(inputKey=IK_GreyMinus,displayName="NumPad Minus")
     keyDisplayNames(10)=(inputKey=IK_GreySlash,displayName="NumPad Slash")
     keyDisplayNames(11)=(inputKey=IK_NumPadPeriod,displayName="NumPad Period")
     keyDisplayNames(12)=(inputKey=IK_NumLock,displayName="Num Lock")
     keyDisplayNames(13)=(inputKey=IK_ScrollLock,displayName="Scroll Lock")
     keyDisplayNames(14)=(inputKey=IK_LShift,displayName="Left Shift")
     keyDisplayNames(15)=(inputKey=IK_RShift,displayName="Right Shift")
     keyDisplayNames(16)=(inputKey=IK_LControl,displayName="Left Control")
     keyDisplayNames(17)=(inputKey=IK_RControl,displayName="Right Control")
     keyDisplayNames(18)=(inputKey=IK_MouseWheelUp,displayName="Mouse Wheel Up")
     keyDisplayNames(19)=(inputKey=IK_MouseWheelDown,displayName="Mouse Wheel Down")
     keyDisplayNames(20)=(inputKey=IK_MouseX,displayName="Mouse X")
     keyDisplayNames(21)=(inputKey=IK_MouseY,displayName="Mouse Y")
     keyDisplayNames(22)=(inputKey=IK_MouseZ,displayName="Mouse Z")
     keyDisplayNames(23)=(inputKey=IK_MouseW,displayName="Mouse W")
     keyDisplayNames(24)=(inputKey=IK_LeftBracket,displayName="Left Bracket")
     keyDisplayNames(25)=(inputKey=IK_RightBracket,displayName="Right Bracket")
     keyDisplayNames(26)=(inputKey=IK_SingleQuote,displayName="Single Quote")
     keyDisplayNames(27)=(inputKey=IK_Joy1,displayName="Joystick Button 1")
     keyDisplayNames(28)=(inputKey=IK_Joy2,displayName="Joystick Button 2")
     keyDisplayNames(29)=(inputKey=IK_Joy3,displayName="Joystick Button 3")
     keyDisplayNames(30)=(inputKey=IK_Joy4,displayName="Joystick Button 4")
     keyDisplayNames(31)=(inputKey=IK_JoyX,displayName="Joystick X")
     keyDisplayNames(32)=(inputKey=IK_JoyY,displayName="Joystick Y")
     keyDisplayNames(33)=(inputKey=IK_JoyZ,displayName="Joystick Z")
     keyDisplayNames(34)=(inputKey=IK_JoyR,displayName="Joystick R")
     keyDisplayNames(35)=(inputKey=IK_JoyU,displayName="Joystick U")
     keyDisplayNames(36)=(inputKey=IK_JoyV,displayName="Joystick V")
     keyDisplayNames(37)=(inputKey=IK_JoyPovUp,displayName="Joystick Pov Up")
     keyDisplayNames(38)=(inputKey=IK_JoyPovDown,displayName="Joystick Pov Down")
     keyDisplayNames(39)=(inputKey=IK_JoyPovLeft,displayName="Joystick Pov Left")
     keyDisplayNames(40)=(inputKey=IK_JoyPovRight,displayName="Joystick Pov Right")
     keyDisplayNames(41)=(inputKey=IK_Ctrl,displayName="Control")
     keyDisplayNames(42)=(inputKey=IK_Left,displayName="Left Arrow")
     keyDisplayNames(43)=(inputKey=IK_Right,displayName="Right Arrow")
     keyDisplayNames(44)=(inputKey=IK_Up,displayName="Up Arrow")
     keyDisplayNames(45)=(inputKey=IK_Down,displayName="Down Arrow")
     keyDisplayNames(46)=(inputKey=IK_Insert,displayName="Insert")
     keyDisplayNames(47)=(inputKey=IK_Home,displayName="Home")
     keyDisplayNames(48)=(inputKey=IK_Delete,displayName="Delete")
     keyDisplayNames(49)=(inputKey=IK_End,displayName="End")
     keyDisplayNames(50)=(inputKey=IK_NumPad0,displayName="NumPad 0")
     keyDisplayNames(51)=(inputKey=IK_NumPad1,displayName="NumPad 1")
     keyDisplayNames(52)=(inputKey=IK_NumPad2,displayName="NumPad 2")
     keyDisplayNames(53)=(inputKey=IK_NumPad3,displayName="NumPad 3")
     keyDisplayNames(54)=(inputKey=IK_NumPad4,displayName="NumPad 4")
     keyDisplayNames(55)=(inputKey=IK_NumPad5,displayName="NumPad 5")
     keyDisplayNames(56)=(inputKey=IK_NumPad6,displayName="NumPad 6")
     keyDisplayNames(57)=(inputKey=IK_NumPad7,displayName="NumPad 7")
     keyDisplayNames(58)=(inputKey=IK_NumPad8,displayName="NumPad 8")
     keyDisplayNames(59)=(inputKey=IK_NumPad9,displayName="NumPad 9")
     keyDisplayNames(60)=(inputKey=IK_Period,displayName="Period")
     keyDisplayNames(61)=(inputKey=IK_Comma,displayName="Comma")
     keyDisplayNames(62)=(inputKey=IK_Backslash,displayName="Backslash")
     keyDisplayNames(63)=(inputKey=IK_Semicolon,displayName="Semicolon")
     keyDisplayNames(64)=(inputKey=IK_Equals,displayName="Equals")
     keyDisplayNames(65)=(inputKey=IK_Slash,displayName="Slash")
     keyDisplayNames(66)=(inputKey=IK_Enter,displayName="Enter")
     keyDisplayNames(67)=(inputKey=IK_Alt,displayName="Alt")
     keyDisplayNames(68)=(inputKey=IK_Backspace,displayName="Backspace")
     keyDisplayNames(69)=(inputKey=IK_Shift,displayName="Shift")
     keyDisplayNames(70)=(inputKey=IK_Space,displayName="Space")
     NoneText="[None]"
     strHeaderActionLabel="Action"
     strHeaderAssignedLabel="Assigned Key/Button"
     WaitingHelpText="Select the function you wish to remap and then press [Enter] or Double-Click.  Press [Delete] to remove key bindings."
     InputHelpText="Please press the key or button you wish to assign to this function.  Press [ESC] to cancel."
     ReassignedFromLabel="'%s' reassigned from '%s'"
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
     Title="Keyboard/Mouse Settings"
     ClientWidth=384
     ClientHeight=366
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuCustomizeKeysBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuCustomizeKeysBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuCustomizeKeysBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuCustomizeKeysBackground_4'
     textureCols=2
     bHelpAlwaysOn=True
     helpPosY=312
}
