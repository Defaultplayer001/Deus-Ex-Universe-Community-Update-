//=============================================================================
// FlagAddWindow
//=============================================================================
class FlagAddWindow expands ToolWindow;

// Windows 
var ToolEditWindow			editName;
var ToolEditWindow			editExpiration;
var ToolEditWindow			editValue;
var ToolButtonWindow		btnOK;
var ToolButtonWindow		btnCancel;
var ToolRadioButtonWindow	btnTrue;
var ToolRadioButtonWindow	btnFalse;
var ToolRadioButtonWindow	btnTypeBool;
var ToolRadioButtonWindow	btnTypeByte;
var ToolRadioButtonWindow	btnTypeInt;
var ToolRadioButtonWindow	btnTypeFloat;
var ToolRadioButtonWindow	btnTypeName;
var RadioBoxWindow			radBool;
var RadioBoxWindow			radTypes;
var Window					winBools;
var Window					winTypes;

// Pointer to window that called us so we can notify it when
// we're finished

var FlagEditWindow	 winFlagList;
var EFlagType        flagType;			// Type of flag we're editing
var bool             bAddMode;
var Name             editFlag;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Center this window	
	SetSize(300, 250);
	SetTitle("Edit Flag");

	// Create the controls
	CreateControls();
	EnableButtons();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	CreateToolLabel(16, 33, "Flag Type:");
	CreateTypeRadioButtons();

	CreateToolLabel(16, 93, "Flag Name:");
	editName  = CreateToolEditWindow(16, 108, 180, 32);
	editName.SetFilter(" ~`!@#$%^&*()=+\|[{]};:,<.>/?'" $ Chr(34));

	CreateToolLabel(16, 143, "Mission Expiration (0 = never):");
	editExpiration = CreateToolEditWindow(16, 158, 180, 32);
	editExpiration.SetFilter(" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~`!@#$%^&*()=+\|[{]};:,<.>/?'" $ Chr(34));

	CreateToolLabel(16, 193, "Value:");

	CreateBoolControls();

	btnOK     = CreateToolButton(210, 180, "|&OK");
	btnCancel = CreateToolButton(210, 205, "|&Cancel");
}

// ----------------------------------------------------------------------
// CreateTypeRadioButtons()
// ----------------------------------------------------------------------

function CreateTypeRadioButtons()
{
	// Create a RadioBox window for the boolean radiobuttons
	radBool = RadioBoxWindow(NewChild(Class'RadioBoxWindow'));
	radBool.SetPos(20, 50);
	radBool.SetSize(230, 45);
	winTypes = radBool.NewChild(Class'Window');

	// Create the five different variable type Radio Buttons 
	btnTypeBool = ToolRadioButtonWindow(winTypes.NewChild(Class'ToolRadioButtonWindow'));
	btnTypeBool.SetText("Bool");
	btnTypeBool.SetPos(0, 5);

	btnTypeByte = ToolRadioButtonWindow(winTypes.NewChild(Class'ToolRadioButtonWindow'));
	btnTypeByte.SetText("Byte");
	btnTypeByte.SetPos(70, 5);

	btnTypeInt = ToolRadioButtonWindow(winTypes.NewChild(Class'ToolRadioButtonWindow'));
	btnTypeInt.SetText("Int");
	btnTypeInt.SetPos(140, 5);

	btnTypeFloat = ToolRadioButtonWindow(winTypes.NewChild(Class'ToolRadioButtonWindow'));
	btnTypeFloat.SetText("Float");
	btnTypeFloat.SetPos(0, 25);

	btnTypeName = ToolRadioButtonWindow(winTypes.NewChild(Class'ToolRadioButtonWindow'));
	btnTypeName.SetText("Name");
	btnTypeName.SetPos(70, 25);
}

// ----------------------------------------------------------------------
// CreateBoolControls()
// ----------------------------------------------------------------------

function CreateBoolControls()
{
	// Create a RadioBox window for the boolean radiobuttons
	radBool = RadioBoxWindow(NewChild(Class'RadioBoxWindow'));
	radBool.SetPos(20, 208);
	radBool.SetSize(180, 20);
	winBools = radBool.NewChild(Class'Window');

	// Create the two Radio Buttons
	btnTrue = ToolRadioButtonWindow(winBools.NewChild(Class'ToolRadioButtonWindow'));
	btnTrue.SetText("True");
	btnTrue.SetPos(0, 5);

	btnFalse = ToolRadioButtonWindow(winBools.NewChild(Class'ToolRadioButtonWindow'));
	btnFalse.SetText("False");
	btnFalse.SetPos(80, 5);
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
		case btnOK:
			if (ValidateValue())
				SendModalComplete(True);	
			break;

		case btnCancel:
			SendModalComplete(False);
			break;

		default:
			bHandled = False;
			break;
	}

	if ( !bHandled ) 
		bHandled = Super.ButtonActivated( buttonPressed );

	return bHandled;
}

// ----------------------------------------------------------------------
// ToggleChanged()
//
// If one of the Type radio buttons changed, then updated the other
// fields
// ----------------------------------------------------------------------

event bool ToggleChanged(Window button, bool bNewToggle)
{
	if (bNewToggle == True)     
	{
		if (button == btnTypeBool)
			SetFlagType(FLAG_Bool);
		else if (button == btnTypeByte)
			SetFlagType(FLAG_Byte);
        else if (button == btnTypeInt) 
			SetFlagType(FLAG_Int);
        else if (button == btnTypeFloat)
			SetFlagType(FLAG_Float);
        else if (button == btnTypeName)
			SetFlagType(FLAG_Name);

		return True;
	}
	else
	{
		return False;
	}
}

// ----------------------------------------------------------------------
// TextChanged()
//
// Don't allow the OK button to be enabled if there's no text in 
// the edit box
// ----------------------------------------------------------------------

event bool TextChanged(window edit, bool bModified)
{
	EnableButtons();

	return false;
}

// ----------------------------------------------------------------------
// EditActivated()
//
// Allow the user to press [Return] to accept the name
// ----------------------------------------------------------------------

event bool EditActivated(window edit, bool bModified)
{
	if ( btnOK.IsSensitive() )
		SendModalComplete(True);

	return false;
}

// ----------------------------------------------------------------------
// SendModalComplete()
// ----------------------------------------------------------------------

function SendModalComplete(bool bNotifyFlag)
{
	if ( winFlagList != None )
	{
		winFlagList.ModalComplete(bNotifyFlag, Self);
	}
}

// ----------------------------------------------------------------------
// SetFlagListWindow()
//
// If the flag list is set to a valid window when we exit, then we'll
// notify the list that we've finished.
// ----------------------------------------------------------------------

function SetFlagListWindow(FlagEditWindow newFlagList)
{
	winFlagList = newFlagList;
}

// ----------------------------------------------------------------------
// EnableButtons()
//
// For the OK button to be enabled, the Name has to be valid as well
// as the value
// ----------------------------------------------------------------------

function EnableButtons()
{
	local bool bFieldsValid;

	bFieldsValid = Len(editName.GetText()) > 0;

	if ((bFieldsValid) && (editValue != None))
		bFieldsValid = Len(editValue.GetText()) > 0;

	btnOK.SetSensitivity(bFieldsValid);
}

// ----------------------------------------------------------------------
// SetAddMode()
// ----------------------------------------------------------------------

function SetAddMode()
{
	bAddMode = True;
	SetTitle("Add Flag");
	SetFlagType(FLAG_Bool);
	btnTrue.SetToggle(True);
	editExpiration.SetText("0");
	editFlag = '';

	// Set focus to the Name edit field
	SetFocusWindow(editName);
}

// ----------------------------------------------------------------------
// SetFlagType()
// ----------------------------------------------------------------------

function SetFlagType(EFlagType newFlagType)
{
	flagType = newFlagType;

	switch(flagType)
	{
		case FLAG_Bool:
			radBool.Show(True);
			DestroyValueEditWindow();
			btnTypeBool.SetToggle(True);
			break;

		case FLAG_Byte:
			radBool.Show(False);
			CreateValueEditWindow();
			editValue.Show(True);
			editValue.SetFilter(" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~`!@#$%^&*()=-+\|[{]};:,<.>/?'" $ Chr(34));
			editValue.SetMaxSize(3);
			editValue.SetText("");
			btnTypeByte.SetToggle(True);
			break;

		case FLAG_Int:
			radBool.Show(False);
			CreateValueEditWindow();
			editValue.SetFilter(" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~`!@#$%^&*()=+\|[{]};:,<.>/?'" $ Chr(34));
			editValue.SetMaxSize(10);
			editValue.SetText("");
			btnTypeInt.SetToggle(True);
			break;

		case FLAG_Float:
			radBool.Show(False);
			CreateValueEditWindow();
			editValue.SetFilter(" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~`!@#$%^&*()=+\|[{]};:,<>/?'" $ Chr(34));
			editValue.SetMaxSize(10);
			editValue.SetText("");
			btnTypeFloat.SetToggle(True);
			break;

		case FLAG_Name:
			radBool.Show(False);
			CreateValueEditWindow();
			editValue.SetFilter(" ~`!@#$%^&*()=+\|[{]};:,<.>/?'" $ Chr(34));
			editValue.SetMaxSize(64);
			editValue.SetText("");
			btnTypeName.SetToggle(True);
			break;
	
		default:
			radBool.Show(False);
			DestroyValueEditWindow();
			break;
	}
}

// ----------------------------------------------------------------------
// DestroyValueEditWindow()
// ----------------------------------------------------------------------

function DestroyValueEditWindow()
{
	if (editValue != None)
	{
		editValue.GetParent().GetParent().GetParent().Destroy();
		editValue = None;
	}
}

// ----------------------------------------------------------------------
// CreateValueEditWindow()
// ----------------------------------------------------------------------

function CreateValueEditWindow()
{
	if (editValue == None)
		editValue = CreateToolEditWindow(16, 208, 180, 32);
}

// ----------------------------------------------------------------------
// GetFlagName()
// ----------------------------------------------------------------------

function Name GetFlagName()
{
	local String strFlagName;
	local Name flagName;

	flagName = StringToName(editName.GetText());

	return flagName;
}

// ----------------------------------------------------------------------
// GetValue()
// ----------------------------------------------------------------------

function String GetValue()
{
	if (editValue != None)
		return editValue.GetText();
	else
		return "";
}

// ----------------------------------------------------------------------
// GetFlagType()
// ----------------------------------------------------------------------

function EFlagType GetFlagType()
{
	return flagType;
}

// ----------------------------------------------------------------------
// GetFlagExpiration()
// ----------------------------------------------------------------------

function int GetFlagExpiration()
{
	return int(editExpiration.GetText());
}

// ----------------------------------------------------------------------
// SetEditFlag()
// ----------------------------------------------------------------------

function SetEditFlag(Name newEditFlag, EFlagType editFlagType)
{
	local String flagStringName;

	editFlag = newEditFlag;
	flagType = editFlagType;

	// Set the flag Type
	SetFlagType(flagType);

	// Flag Name
	flagStringName = String(editFlag);

	editName.SetText(flagStringName);
	editName.MoveInsertionPoint(MOVEINSERT_End);
	
	// Mission Expiration
	editExpiration.SetText(player.flagBase.GetExpiration(editFlag, flagType));

	// Flag Value
	switch(editFlagType)
	{
		case FLAG_Bool:
			if (player.flagBase.GetBool(editFlag) == True)
				btnTrue.SetToggle(True);
			else
				btnFalse.SetToggle(True);
			break;

		case FLAG_Byte:
			editValue.SetText(String(player.flagBase.GetByte(editFlag)));
			break;

		case FLAG_Int:
			editValue.SetText(String(player.flagBase.GetInt(editFlag)));
			break;

		case FLAG_Float:
			editValue.SetText(String(player.flagBase.GetFloat(editFlag)));
			break;

		case FLAG_Name:
			editValue.SetText(player.flagBase.GetName(editFlag));
			break;
	}

	// Set focus to the Name edit field
	SetFocusWindow(editName);
	editName.MoveInsertionPoint(MOVEINSERT_End);
}

// ----------------------------------------------------------------------
// ValidateValue()
// ----------------------------------------------------------------------

function bool ValidateValue()
{
	local bool bGoodValue;

	// Flag Value
	switch(flagType)
	{
		case FLAG_Bool:
			bGoodValue = True;
			break;

		case FLAG_Byte:
			if ((Int(editValue.GetText()) >= 0) && (Int(editValue.GetText()) <= 255))
			{
				bGoodValue = True;
			}
			else
			{
				bGoodValue = False;
				root.ToolMessageBox(
					"Bad Byte Value!", 
					"Bytes must range in value from 0 to 255", 
					1, False, Self);
			}

			break;

		case FLAG_Int:
			if ((Int(editValue.GetText()) >= -2147483648) && (Int(editValue.GetText()) <= 2147483647))
			{
				bGoodValue = True;
			}
			else
			{
				bGoodValue = False;
				root.ToolMessageBox(
					"Bad Integer Value!", 
					"Ints must range in value from -2147483648 to 2147483647", 
					1, False, Self);
			}

			break;

		case FLAG_Float:
			bGoodValue = True;
			break;

		case FLAG_Name:
			bGoodValue = True;
			break;
	}

	return bGoodValue;
}

// ----------------------------------------------------------------------
// BoxOptionSelected()
// ----------------------------------------------------------------------

event bool BoxOptionSelected(Window msgBoxWindow, int buttonNumber)
{
	// Nuke the msgbox
	root.PopWindow();

	return true;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
