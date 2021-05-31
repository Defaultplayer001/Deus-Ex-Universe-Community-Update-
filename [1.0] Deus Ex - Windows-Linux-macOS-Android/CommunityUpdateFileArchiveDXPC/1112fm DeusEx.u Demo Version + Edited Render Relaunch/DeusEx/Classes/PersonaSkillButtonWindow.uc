//=============================================================================
// PersonaSkillButtonWindow
//=============================================================================

class PersonaSkillButtonWindow extends PersonaBorderButtonWindow;

var Window                  winIcon;
var PersonaSkillTextWindow  winName;
var PersonaSkillTextWindow  winLevel;
var PersonaSkillTextWindow  winPointsNeeded;
var PersonaLevelIconWindow  winLevelIcons;

var Skill skill;
var Bool bSelected;

var Localized String NotAvailableLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetWidth(302);

	CreateControls();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	winIcon = NewChild(Class'Window');
	winIcon.SetBackgroundStyle(DSTY_Masked);
	winIcon.SetPos(1, 1);
	winIcon.SetSize(24, 24);

	winName = PersonaSkillTextWindow(NewChild(Class'PersonaSkillTextWindow'));
	winName.SetPos(28, 0);
	winName.SetSize(138, 27);
	winName.SetFont(Font'FontMenuHeaders');

	winLevel = PersonaSkillTextWindow(NewChild(Class'PersonaSkillTextWindow'));
	winLevel.SetPos(165, 0);
	winLevel.SetSize(54, 27);

	winLevelIcons = PersonaLevelIconWindow(NewChild(Class'PersonaLevelIconWindow'));
	winLevelIcons.SetPos(229, 11);

	winPointsNeeded = PersonaSkillTextWindow(NewChild(Class'PersonaSkillTextWindow'));
	winPointsNeeded.SetPos(264, 0);
	winPointsNeeded.SetSize(30, 27);
	winPointsNeeded.SetTextAlignments(HALIGN_Right, VALIGN_Center);
}

// ----------------------------------------------------------------------
// SelectButton()
// ----------------------------------------------------------------------

function SelectButton(Bool bNewSelected)
{
	bSelected = bNewSelected;

	// Update text colors 
	winName.SetSelected(bSelected);
	winLevel.SetSelected(bSelected);
	winPointsNeeded.SetSelected(bSelected);
	winLevelIcons.SetSelected(bSelected);
}

// ----------------------------------------------------------------------
// SetButtonMetrics()
//
// Calculates which set of textures we're going to use as well as 
// any text offset (used if the button is pressed in)
// ----------------------------------------------------------------------

function SetButtonMetrics()
{
	if (bIsSensitive)
	{
		if (bSelected)				
		{
			textureIndex = 1;
			textColorIndex = 2;
		}
		else
		{
			textureIndex = 0;
			textColorIndex = 0;
		}
	}
	else								// disabled
	{
		textureIndex = 0;
		textColorIndex = 3;
	}
}	

// ----------------------------------------------------------------------
// SetSkill()
// ----------------------------------------------------------------------

function SetSkill(Skill newSkill)
{
	skill = newSkill;

	RefreshSkillInfo();
}

// ----------------------------------------------------------------------
// GetSkill()
// ----------------------------------------------------------------------

function Skill GetSkill()
{
	return skill;
}

// ----------------------------------------------------------------------
// RefreshSkillInfo()
// ----------------------------------------------------------------------

function RefreshSkillInfo()
{
	if (skill != None)
	{
		winIcon.SetBackground(skill.SkillIcon);
		winName.SetText(skill.SkillName);
		winLevel.SetText(skill.GetCurrentLevelString());
		winLevelIcons.SetLevel(skill.GetCurrentLevel());

		if (skill.GetCurrentLevel() == 3)
			winPointsNeeded.SetText(NotAvailableLabel);
		else
			winPointsNeeded.SetText(String(skill.GetCost()));
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     NotAvailableLabel="N/A"
     Left_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.PersonaSkillsButtonNormal_Left',Width=4)
     Left_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.PersonaSkillsButtonFocus_Left',Width=4)
     Right_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.PersonaSkillsButtonNormal_Right',Width=8)
     Right_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.PersonaSkillsButtonFocus_Right',Width=8)
     Center_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.PersonaSkillsButtonNormal_Center',Width=4)
     Center_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.PersonaSkillsButtonFocus_Center',Width=4)
     fontButtonText=Font'DeusExUI.FontMenuTitle'
     buttonHeight=27
     minimumButtonWidth=50
}
