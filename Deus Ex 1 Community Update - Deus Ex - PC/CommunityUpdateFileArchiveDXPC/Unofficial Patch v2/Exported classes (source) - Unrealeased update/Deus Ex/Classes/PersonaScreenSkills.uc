//=============================================================================
// PersonaScreenSkills
//=============================================================================

class PersonaScreenSkills extends PersonaScreenBaseWindow;

var PersonaActionButtonWindow btnUpgrade;
var TileWindow                winTile;
var Skill			          selectedSkill;
var PersonaSkillButtonWindow  selectedSkillButton;
var PersonaHeaderTextWindow   winSkillPoints;
var PersonaInfoWindow         winInfo;

// Keep track so we can use the arrow keys to navigate
var PersonaSkillButtonWindow  skillButtons[15];

var localized String SkillsTitleText;
var localized String UpgradeButtonLabel;
var localized String PointsNeededHeaderText;
var localized String SkillLevelHeaderText;
var localized String SkillPointsHeaderText;
var localized String SkillUpgradedLevelLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	PersonaNavBarWindow(winNavBar).btnSkills.SetSensitivity(False);

	EnableButtons();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	CreateTitleWindow(9, 5, SkillsTitleText);
	CreateInfoWindow();
	CreateButtons();
	CreateSkillsHeaders();
	CreateSkillsTileWindow();
	CreateSkillsList();
	CreateSkillPointsWindow();
	CreateStatusWindow();
}

// ----------------------------------------------------------------------
// CreateStatusWindow()
// ----------------------------------------------------------------------

function CreateStatusWindow()
{
	winStatus = PersonaStatusLineWindow(winClient.NewChild(Class'PersonaStatusLineWindow'));
	winStatus.SetPos(356, 329);
}

// ----------------------------------------------------------------------
// CreateSkillsTileWindow()
// ----------------------------------------------------------------------

function CreateSkillsTileWindow()
{
	winTile = TileWindow(winClient.NewChild(Class'TileWindow'));

	winTile.SetPos(12, 39);
	winTile.SetSize(302, 297);
	winTile.SetMinorSpacing(0);
	winTile.SetMargins(0, 0);
	winTile.SetOrder(ORDER_Down);
}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
	winInfo = PersonaInfoWindow(winClient.NewChild(Class'PersonaInfoWindow'));
	winInfo.SetPos(356, 22);
	winInfo.SetSize(238, 299);
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	local PersonaButtonBarWindow winActionButtons;

	winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(10, 338);
	winActionButtons.SetWidth(149);
	winActionButtons.FillAllSpace(False);

	btnUpgrade = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnUpgrade.SetButtonText(UpgradeButtonLabel);
}

// ----------------------------------------------------------------------
// CreateSkillsHeaders()
// ----------------------------------------------------------------------

function CreateSkillsHeaders()
{
	local PersonaNormalTextWindow winText;

	winText = PersonaNormalTextWindow(winClient.NewChild(Class'PersonaNormalTextWindow'));
	winText.SetPos(177, 24);
	winText.SetText(SkillLevelHeaderText);

	winText = PersonaNormalTextWindow(winClient.NewChild(Class'PersonaNormalTextWindow'));
	winText.SetPos(247, 24);
	winText.SetText(PointsNeededHeaderText);
}

// ----------------------------------------------------------------------
// CreateSkillsList()
// ----------------------------------------------------------------------

function CreateSkillsList()
{
	local Skill aSkill;
	local int   buttonIndex;
	local PersonaSkillButtonWindow skillButton;
	local PersonaSkillButtonWindow firstButton;

	// Iterate through the skills, adding them to our list
	aSkill = player.SkillSystem.FirstSkill;
	while(aSkill != None)
	{
		if (aSkill.SkillName != "")
		{
			skillButton = PersonaSkillButtonWindow(winTile.NewChild(Class'PersonaSkillButtonWindow'));
			skillButton.SetSkill(aSkill);

			skillButtons[buttonIndex++] = skillButton;

			if (firstButton == None)
				firstButton = skillButton;
		}
		aSkill = aSkill.next;
	}

	// Select the first skill
	SelectSkillButton(skillButton);
}

// ----------------------------------------------------------------------
// CreateSkillPointsWindow()
// ----------------------------------------------------------------------

function CreateSkillPointsWindow()
{
	local PersonaHeaderTextWindow winText;

	winText = PersonaHeaderTextWindow(winClient.NewChild(Class'PersonaHeaderTextWindow'));
	winText.SetPos(180, 341);
	winText.SetHeight(15);
	winText.SetText(SkillPointsHeaderText);

	winSkillPoints = PersonaHeaderTextWindow(winClient.NewChild(Class'PersonaHeaderTextWindow'));
	winSkillPoints.SetPos(250, 341);
	winSkillPoints.SetSize(54, 15);
	winSkillPoints.SetTextAlignments(HALIGN_Right, VALIGN_Center);
	winSkillPoints.SetText(player.SkillPointsAvail);
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	if (Super.ButtonActivated(buttonPressed))
		return True;

	bHandled   = True;

	// Check if this is one of our Skills buttons
	if (buttonPressed.IsA('PersonaSkillButtonWindow'))
	{
		SelectSkillButton(PersonaSkillButtonWindow(buttonPressed));
	}
	else
	{
		switch(buttonPressed)
		{
			case btnUpgrade:
				UpgradeSkill();
				break;

			default:
				bHandled = False;
				break;
		}
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bHandled;

	bHandled = True;

	switch( key ) 
	{
		case IK_Up:
			SelectPreviousSkillButton();
			break;

		case IK_Down:
			SelectNextSkillButton();
			break;

		default:
			bHandled = False;
			break;
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// SelectSkillButton()
// ----------------------------------------------------------------------

function SelectSkillButton(PersonaSkillButtonWindow buttonPressed)
{
	// Don't do extra work.
	if (selectedSkillButton != buttonPressed)
	{
		// Deselect current button
		if (selectedSkillButton != None)
			selectedSkillButton.SelectButton(False);

		selectedSkillButton = buttonPressed;
		selectedSkill       = selectedSkillButton.GetSkill();

		selectedSkill.UpdateInfo(winInfo);
		selectedSkillButton.SelectButton(True);

		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// SelectPreviousSkillButton()
// ----------------------------------------------------------------------

function SelectPreviousSkillButton()
{
	local int skillIndex;

	skillIndex = GetCurrentSkillButtonIndex();

	if (--skillIndex < 0)
		skillIndex = GetSkillButtonCount() - 1;

	skillButtons[skillIndex].ActivateButton(IK_LeftMouse);
}

// ----------------------------------------------------------------------
// SelectNextSkillButton()
// ----------------------------------------------------------------------

function SelectNextSkillButton()
{
	local int skillIndex;

	skillIndex = GetCurrentSkillButtonIndex();

	if (++skillIndex >= GetSkillButtonCount())
		skillIndex = 0;

	skillButtons[skillIndex].ActivateButton(IK_LeftMouse);
}

// ----------------------------------------------------------------------
// GetCurrentSkillButtonIndex()
// ----------------------------------------------------------------------

function int GetCurrentSkillButtonIndex()
{
	local int buttonIndex;
	local int returnIndex;

	returnIndex = -1;

	for(buttonIndex=0; buttonIndex<arrayCount(skillButtons); buttonIndex++)
	{
		if (skillButtons[buttonIndex] == selectedSkillButton)
		{
			returnIndex = buttonIndex;
			break;
		}		
	}

	return returnIndex;
}

// ----------------------------------------------------------------------
// GetSkillButtonCount()
// ----------------------------------------------------------------------

function int GetSkillButtonCount()
{
	local int buttonIndex;

	for(buttonIndex=0; buttonIndex<arrayCount(skillButtons); buttonIndex++)
	{
		if (skillButtons[buttonIndex] == None)
			break;
	}	

	return buttonIndex;
}

// ----------------------------------------------------------------------
// UpgradeSkill()
// ----------------------------------------------------------------------

function UpgradeSkill()
{
	// First make sure we have a skill selected
	if ( selectedSkill == None )
		return;

	selectedSkill.IncLevel();
	selectedSkillButton.RefreshSkillInfo();

	// Send status message
	winStatus.AddText(Sprintf(SkillUpgradedLevelLabel, selectedSkill.SkillName));
	
	winSkillPoints.SetText(player.SkillPointsAvail);
		
	EnableButtons();
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	// Abort if a skill item isn't selected
	if ( selectedSkill == None )
	{
		btnUpgrade.SetSensitivity(False);
	}
	else
	{
		// Upgrade Skill only available if the skill is not at 
		// the maximum -and- the user has enough skill points
		// available to upgrade the skill

		btnUpgrade.EnableWindow(selectedSkill.CanAffordToUpgrade(player.SkillPointsAvail));
	}
}

// ----------------------------------------------------------------------
// RefreshWindow()
// ----------------------------------------------------------------------

function RefreshWindow(float DeltaTime)
{
    if (selectedSkill != None)
    {    
        selectedSkillButton.RefreshSkillInfo();
    }

    winSkillPoints.SetText(player.SkillPointsAvail);
    EnableButtons();
    Super.RefreshWindow(DeltaTime);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     SkillsTitleText="Skills"
     UpgradeButtonLabel="|&Upgrade"
     PointsNeededHeaderText="Points Needed"
     SkillLevelHeaderText="Skill Level"
     SkillPointsHeaderText="Skill Points"
     SkillUpgradedLevelLabel="%s upgraded"
     clientBorderOffsetY=33
     ClientWidth=604
     ClientHeight=361
     clientOffsetX=19
     clientOffsetY=12
     clientTextures(0)=Texture'DeusExUI.UserInterface.SkillsBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.SkillsBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.SkillsBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.SkillsBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.SkillsBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.SkillsBackground_6'
     clientBorderTextures(0)=Texture'DeusExUI.UserInterface.SkillsBorder_1'
     clientBorderTextures(1)=Texture'DeusExUI.UserInterface.SkillsBorder_2'
     clientBorderTextures(2)=Texture'DeusExUI.UserInterface.SkillsBorder_3'
     clientBorderTextures(3)=Texture'DeusExUI.UserInterface.SkillsBorder_4'
     clientBorderTextures(4)=Texture'DeusExUI.UserInterface.SkillsBorder_5'
     clientBorderTextures(5)=Texture'DeusExUI.UserInterface.SkillsBorder_6'
     clientTextureRows=2
     clientTextureCols=3
     clientBorderTextureRows=2
     clientBorderTextureCols=3
}
