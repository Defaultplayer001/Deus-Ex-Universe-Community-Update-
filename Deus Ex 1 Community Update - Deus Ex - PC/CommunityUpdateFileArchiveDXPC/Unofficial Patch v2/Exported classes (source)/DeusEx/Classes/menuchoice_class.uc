//=============================================================================
// MenuChoice_Class
//=============================================================================

class MenuChoice_Class extends MenuUIChoiceEnum
	config;

var globalconfig string  ClassClasses[24]; //Actual classes of classes (sigh)
var localized String     ClassNames[24]; //Human readable class names.


//Portrait variables
var ButtonWindow btnPortrait;
var globalconfig Texture texPortraits[24];
var int PortraitIndex;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	PopulateClassChoices();
   CreatePortraitButton();

	Super.InitWindow();

   SetInitialClass();

   SetActionButtonWidth(153);

   btnAction.SetHelpText(HelpText);
   btnInfo.SetPos(0,195);
}

// ----------------------------------------------------------------------
// PopulateClassChoices()
// ----------------------------------------------------------------------

function PopulateClassChoices()
{
	local int typeIndex;

   for (typeIndex = 0; typeIndex < arrayCount(ClassNames); typeIndex++)
   {
      enumText[typeIndex]=ClassNames[typeIndex];
   }
}

// ----------------------------------------------------------------------
// SetInitialClass()
// ----------------------------------------------------------------------

function SetInitialClass()
{
   local string TypeString;
   local int typeIndex;

   
   TypeString = player.GetDefaultURL("Class");
  
   for (typeIndex = 0; typeIndex < arrayCount(ClassNames); typeIndex++)
   {
      if (TypeString==GetModuleName(typeIndex))
         SetValue(typeIndex);
   }
}

// ----------------------------------------------------------------------
// SetValue()
// ----------------------------------------------------------------------

function SetValue(int newValue)
{
   Super.SetValue(newValue);
   UpdatePortrait();
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
   player.UpdateURL("Class", GetModuleName(currentValue), true);
   player.SaveConfig();
}

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
   local string TypeString;
   local int typeIndex;
   
   TypeString = player.GetDefaultURL("Class");

   for (typeIndex = 0; typeIndex < arrayCount(ClassNames); typeIndex++)
   {
      if (TypeString==GetModuleName(typeIndex))
         SetValue(typeIndex);
   }
   UpdatePortrait();
}

// ----------------------------------------------------------------------
// ResetToDefault
// ----------------------------------------------------------------------

function ResetToDefault()
{   
   player.UpdateURL("Class", GetModuleName(defaultValue), true);
   player.SaveConfig();
   LoadSetting();
}

// ----------------------------------------------------------------------
// GetModuleName()
// For command line parsing
// ----------------------------------------------------------------------

function string GetModuleName(int ClassIndex)
{
   return (ClassClasses[ClassIndex]);
}

// ----------------------------------------------------------------------
// CreatePortraitButton()
// ----------------------------------------------------------------------

function CreatePortraitButton()
{
	btnPortrait = ButtonWindow(NewChild(Class'ButtonWindow'));

	btnPortrait.SetSize(116, 163);
	btnPortrait.SetPos(19, 27);

	btnPortrait.SetBackgroundStyle(DSTY_Masked);
}

// ----------------------------------------------------------------------
// UpdatePortrait()
// ----------------------------------------------------------------------

function UpdatePortrait()
{
   btnPortrait.SetBackground(texPortraits[CurrentValue]);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ClassClasses(0)="DeusEx.JCDentonMale"
     ClassClasses(1)="DeusEx.MPNSF"
     ClassClasses(2)="DeusEx.MPUnatco"
     ClassClasses(3)="DeusEx.MPMJ12"
     ClassNames(0)="JC Denton"
     ClassNames(1)="NSF Terrorist"
     ClassNames(2)="UNATCO Trooper"
     ClassNames(3)="Majestic-12 Agent"
     texPortraits(0)=Texture'DeusExUI.UserInterface.menuplayersetupjcdenton'
     texPortraits(1)=Texture'DeusExUI.UserInterface.menuplayersetupnsf'
     texPortraits(2)=Texture'DeusExUI.UserInterface.menuplayersetupunatco'
     texPortraits(3)=Texture'DeusExUI.UserInterface.menuplayersetupmj12'
     defaultInfoWidth=153
     defaultInfoPosX=170
     HelpText="Model for your character in non-team games."
     actionText="Non-Team Model"
}
