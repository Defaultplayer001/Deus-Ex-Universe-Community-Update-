//=============================================================================
// MenuScreenNewGame
//=============================================================================

class MenuScreenNewGame expands MenuUIScreenWindow;

var MenuUIInfoButtonWindow   winNameBorder;
var MenuUIEditWindow         editCodeName;
var MenuUIEditWindow         editName;
var MenuUIListWindow         lstSkills;
var MenuUISkillInfoWindow    winSkillInfo;
var MenuUIStaticInfoWindow   winSkillPoints;

var MenuUIActionButtonWindow btnUpgrade;
var MenuUIActionButtonWindow btnDowngrade;
var ButtonWindow             btnLeftArrow;
var ButtonWindow             btnRightArrow;
var ButtonWindow             btnPortrait;

var Texture texPortraits[5];
var int     portraitIndex;
var Skill   selectedSkill;
var int		selectedRowId;
var int     saveSkillPointsAvail;
var int     saveSkillPointsTotal;
var float   combatDifficulty;

var String filterString;

// An array of local skills that we can use to manipulate without
// actually changing the skills in the game.  This is important so the 
// player can back out of this screen and return to the game in progress.

var Skill			localSkills[32];

var localized string ButtonUpgradeLabel;
var localized string ButtonDowngradeLabel;
var localized string HeaderNameLabel;
var localized string HeaderCodeNameLabel;
var localized string HeaderAppearanceLabel;
var localized string HeaderSkillsLabel;
var localized string HeaderSkillPointsLabel;
var localized string HeaderSkillLevelLabel;
var localized string HeaderPointsNeededLabel;
var localized string NameBlankTitle;
var localized string NameBlankPrompt;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SaveSkillPoints();	
	ResetToDefaults();

	// Need to do this because of the edit control used for 
	// saving games.
	SetMouseFocusMode(MFOCUS_Click);

	Show();
	SetFocusWindow(editName);
	editName.SetSelectedArea(0, Len(editName.GetText()));
	combatDifficulty = player.Default.CombatDifficulty;

	StyleChanged();
}

// ----------------------------------------------------------------------
// DestroyWindow()
// ----------------------------------------------------------------------

event DestroyWindow()
{
	DestroyLocalSkills();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	CreatePortraitButton();
	CreateLeftArrowButton();
	CreateRightArrowButton();
	CreateSkillButtons();
	CreateTextHeaders();
	CreateCodeNameEditWindow();
	CreateNameEditWindow();
	CreateSkillsListWindow();
	CreateSkillInfoWindow();
	CreateSkillPointsButton();
}

// ----------------------------------------------------------------------
// CreatePortraitButton()
// ----------------------------------------------------------------------

function CreatePortraitButton()
{
	btnPortrait = ButtonWindow(winClient.NewChild(Class'ButtonWindow'));

	btnPortrait.SetSize(114, 161);
	btnPortrait.SetPos(18, 152);

	btnPortrait.SetBackgroundStyle(DSTY_Masked);
}

// ----------------------------------------------------------------------
// CreateLeftArrowButton()
// ----------------------------------------------------------------------

function CreateLeftArrowButton()
{
	btnLeftArrow = ButtonWindow(winClient.NewChild(Class'ButtonWindow'));

	btnLeftArrow.SetPos(102, 316);
	btnLeftArrow.SetSize(14, 15);

	btnLeftArrow.SetButtonTextures(
		Texture'MenuLeftArrow_Normal', 
		Texture'MenuLeftArrow_Pressed');
}

// ----------------------------------------------------------------------
// CreateRightArrowButton()
// ----------------------------------------------------------------------

function CreateRightArrowButton()
{
	btnRightArrow = ButtonWindow(winClient.NewChild(Class'ButtonWindow'));

	btnRightArrow.SetPos(117, 316);
	btnRightArrow.SetSize(14, 15);

	btnRightArrow.SetButtonTextures(
		Texture'MenuRightArrow_Normal', 
		Texture'MenuRightArrow_Pressed');
}

// ----------------------------------------------------------------------
// CreateSkillButtons()
// ----------------------------------------------------------------------

function CreateSkillButtons()
{
	btnUpgrade = MenuUIActionButtonWindow(winClient.NewChild(Class'MenuUIActionButtonWindow'));
	btnUpgrade.SetButtonText(ButtonUpgradeLabel);
	btnUpgrade.SetPos(164, 341);
	btnUpgrade.SetWidth(74);

	btnDowngrade = MenuUIActionButtonWindow(winClient.NewChild(Class'MenuUIActionButtonWindow'));
	btnDowngrade.SetButtonText(ButtonDowngradeLabel);
	btnDowngrade.SetPos(241, 341);
	btnDowngrade.SetWidth(90);
}

// ----------------------------------------------------------------------
// CreateTextHeaders()
// ----------------------------------------------------------------------

function CreateTextHeaders()
{
	local MenuUILabelWindow winLabel;

	CreateMenuLabel( 21,  17, HeaderCodeNameLabel,     winClient);
	CreateMenuLabel( 21,  73, HeaderNameLabel,         winClient);
	CreateMenuLabel( 21, 133, HeaderAppearanceLabel,   winClient);
	CreateMenuLabel(172,  17, HeaderSkillsLabel,       winClient);
	
	winLabel = CreateMenuLabel(430,  18, HeaderSkillLevelLabel,   winClient);
	winLabel.SetFont(Font'FontMenuSmall');

	winLabel = CreateMenuLabel(505,  18, HeaderPointsNeededLabel, winClient);
	winLabel.SetFont(Font'FontMenuSmall');
	
	CreateMenuLabel(409, 344, HeaderSkillPointsLabel,  winClient); 
}

// ----------------------------------------------------------------------
// CreateCodeNameEditWindow()
// ----------------------------------------------------------------------

function CreateCodeNameEditWindow()
{
	editCodeName = CreateMenuEditWindow(18, 36, 113, 32, winClient);

	editCodeName.SetText(player.FamiliarName);
	editCodeName.SetSensitivity(False);
}

// ----------------------------------------------------------------------
// CreateNameEditWindow()
// ----------------------------------------------------------------------

function CreateNameEditWindow()
{
	editName = CreateMenuEditWindow(18, 92, 113, 32, winClient);

	editName.SetText(player.TruePlayerName);
	editName.MoveInsertionPoint(MOVEINSERT_End);
	editName.SetFilter(filterString);
}

// ----------------------------------------------------------------------
// CreateSkillsListWindow()
// ----------------------------------------------------------------------

function CreateSkillsListWindow()
{
	lstSkills = MenuUIListWindow(winClient.NewChild(Class'MenuUIListWindow'));

	lstSkills.SetSize(397, 150);
	lstSkills.SetPos(172,41);
	lstSkills.EnableMultiSelect(False);
	lstSkills.EnableAutoExpandColumns(False);
	lstSkills.SetNumColumns(3);

	lstSkills.SetColumnWidth(0, 262);
	lstSkills.SetColumnWidth(1,  66);
	lstSkills.SetColumnWidth(2,  60);
	lstSkills.SetColumnAlignment(2, HALIGN_Right);

	lstSkills.SetColumnFont(0, Font'FontMenuHeaders');
	lstSkills.SetSortColumn(0, False);
	lstSkills.EnableAutoSort(True);
}

// ----------------------------------------------------------------------
// CreateSkillInfoWindow()
// ----------------------------------------------------------------------

function CreateSkillInfoWindow()
{
	winSkillInfo = MenuUISkillInfoWindow(winClient.NewChild(Class'MenuUISkillInfoWindow'));
	winSkillInfo.SetPos(165, 208);
}

// ----------------------------------------------------------------------
// CreateSkillPointsButton()
// ----------------------------------------------------------------------

function CreateSkillPointsButton()
{
	winSkillPoints = MenuUIStaticInfoWindow(winClient.NewChild(Class'MenuUIStaticInfoWindow'));

	winSkillPoints.SetPos(487, 341);
	winSkillPoints.SetWidth(83);
	winSkillPoints.SetSensitivity(False);
}

// ----------------------------------------------------------------------
// PopulateSkillsList()
// ----------------------------------------------------------------------

function PopulateSkillsList()
{
	local int skillIndex;
	local int rowIndex;

	lstSkills.DeleteAllRows();
	skillIndex = 0;

	// Iterate through the skills, adding them to our list
	while(localSkills[skillIndex] != None)
	{
		rowIndex = lstSkills.AddRow(BuildSkillString(localSkills[skillIndex]));
		lstSkills.SetRowClientObject(rowIndex, localSkills[skillIndex]);

		skillIndex++;
	}
	lstSkills.Sort();
	lstSkills.SetRow(lstSkills.IndexToRowId(0), False);
}

// ----------------------------------------------------------------------
// BuildSkillsString()
// ----------------------------------------------------------------------

function String BuildSkillString( Skill aSkill )
{
	local String skillString;
	local String levelCost;
	
	if ( aSkill.GetCurrentLevel() == 3 ) 
		levelCost = "--";
	else
		levelCost = String(aSkill.GetCost());

	skillString = aSkill.skillName $ ";" $ 
				  aSkill.GetCurrentLevelString() $ ";" $ 
				  levelCost;

	return skillString;
}

// ----------------------------------------------------------------------
// UpdateSkillPoints()
// ----------------------------------------------------------------------

function UpdateSkillPoints()
{
	winSkillPoints.SetButtonText(String(player.SkillPointsAvail));
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
		case btnUpgrade:
			UpgradeSkill();
			break;

		case btnDowngrade:
			DowngradeSkill();
			break;

		case btnLeftArrow:
			PreviousPortrait();
			break;

		case btnRightArrow:
			NextPortrait();
			break;

		case btnPortrait:
			NextPortrait();
			break;

		default:
			bHandled = False;
			break;
	}

	if ( !bHandled )
		bHandled = Super.ButtonActivated(buttonPressed);

	return bHandled;
}

// ----------------------------------------------------------------------
// ListRowActivated()
// ----------------------------------------------------------------------

event bool ListRowActivated(window list, int rowId)
{
	UpgradeSkill();
	return True;
}

// ----------------------------------------------------------------------
// ListSelectedChanged()
// ----------------------------------------------------------------------

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
	local Skill aSkill;

	selectedSkill = Skill(ListWindow(list).GetRowClientObject(focusRowId));
	selectedRowId = focusRowId;

	winSkillInfo.SetSkill(selectedSkill);

	EnableButtons();

	return True;
}

// ----------------------------------------------------------------------
// TextChanged() 
// ----------------------------------------------------------------------

event bool TextChanged(window edit, bool bModified)
{
	EnableButtons();

	return false;
}

/*
   Took out because people were bitching (Waaaaaaaaaaaaaaah!) about
   how pressing Enter in the name box would start the game.

// ----------------------------------------------------------------------
// EditActivated()
//
// Allow the user to press [Return] to accept the username/password
// ----------------------------------------------------------------------

event bool EditActivated(window edit, bool bModified)
{
	if (IsActionButtonEnabled(AB_Other, "START"))
	{
		ProcessAction("START");
		return True;
	}
	else
	{
		return False;
	}
}
*/

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	// Abort if a skill item isn't selected
	if ( selectedSkill == None )
	{
		btnUpgrade.SetSensitivity( False );
		btnDowngrade.SetSensitivity( False );
	}
	else
	{
		// Upgrade Skill only available if the skill is not at 
		// the maximum -and- the user has enough skill points
		// available to upgrade the skill

		btnUpgrade.EnableWindow(selectedSkill.CanAffordToUpgrade(player.SkillPointsAvail));
		btnDowngrade.EnableWindow(selectedSkill.GetCurrentLevel() > 0);
	}

	// Only enable the OK button if the player has entered a name
	if (editName != None)
	{
		if (editName.GetText() == "")
			EnableActionButton(AB_Other, False, "START");
		else
			EnableActionButton(AB_Other, True, "START");
	}
}

// ----------------------------------------------------------------------
// PreviousPortrait()
// ----------------------------------------------------------------------

function PreviousPortrait()
{
	portraitIndex--;

	if (portraitIndex < 0)
		portraitIndex = arrayCount(texPortraits) - 1;

	btnPortrait.SetBackground(texPortraits[portraitIndex]);
}

// ----------------------------------------------------------------------
// NextPortrait()
// ----------------------------------------------------------------------

function NextPortrait()
{
	portraitIndex++;

	if (portraitIndex == arrayCount(texPortraits))
		portraitIndex = 0;

	btnPortrait.SetBackground(texPortraits[portraitIndex]);
}

// ----------------------------------------------------------------------
// UpgradeSkill()
// ----------------------------------------------------------------------

function UpgradeSkill()
{
	// First make sure we have a skill selected
	if ( selectedSkill == None )
		return;

	selectedSkill.IncLevel(player);
	lstSkills.ModifyRow(selectedRowId, BuildSkillString( selectedSkill ));

	UpdateSkillPoints();
	EnableButtons();
}

// ----------------------------------------------------------------------
// DowngradeSkill()
// ----------------------------------------------------------------------

function DowngradeSkill()
{
	// First make sure we have a skill selected
	if ( selectedSkill == None )
		return;

	selectedSkill.DecLevel(True, Player);
	lstSkills.ModifyRow(selectedRowId, BuildSkillString( selectedSkill ));

	UpdateSkillPoints();
	EnableButtons();
}

// ----------------------------------------------------------------------
// ResetToDefaults()
//
// Meant to be called in derived class
// ----------------------------------------------------------------------

function ResetToDefaults()
{
	editName.SetText(player.TruePlayerName);

	player.SkillPointsAvail = player.Default.SkillPointsAvail;
	player.SkillPointsTotal = player.Default.SkillPointsTotal;

	portraitIndex = 0;
	btnPortrait.SetBackground(texPortraits[portraitIndex]);

	CopySkills();
	PopulateSkillsList();	
	UpdateSkillPoints();
	EnableButtons();
}

// ----------------------------------------------------------------------
// CopySkills()
//
// Makes a local copy of the skills so we can manipulate them without
// actually making changes to the ones attached to the player.
// ----------------------------------------------------------------------

function CopySkills()
{
	local Skill aSkill;
	local int skillIndex;

	skillIndex = 0;

	aSkill = player.SkillSystem.FirstSkill;
	while(aSkill != None)
	{
		localSkills[skillIndex] = player.Spawn(aSkill.Class);
		skillIndex++;
		aSkill = aSkill.next;
	}
}

// ----------------------------------------------------------------------
// ApplySkills()
//
// Apply our local skills to the real skills in the game.
// ----------------------------------------------------------------------

function ApplySkills()
{
	local Skill aSkill;
	local int skillIndex;

	skillIndex = 0;

	while(localSkills[skillIndex] != None)
	{
		aSkill = player.SkillSystem.FirstSkill;
		while(aSkill != None)
		{
			if (aSkill.SkillName == localSkills[skillIndex].SkillName)
			{
				// Copy the skill
				aSkill.CurrentLevel = localSkills[skillIndex].GetCurrentLevel();
				break;
			}
			aSkill = aSkill.next;
		}
		skillIndex++;
	}
}

// ----------------------------------------------------------------------
// DestroyLocalSkills()
// ----------------------------------------------------------------------

function DestroyLocalSkills()
{
	local int skillIndex;

	skillIndex = 0;

	while(localSkills[skillIndex] != None)
	{
		localSkills[skillIndex].Destroy();
		localSkills[skillIndex] = None;
		skillIndex++;
	}
}

// ----------------------------------------------------------------------
// ProcessAction()
// ----------------------------------------------------------------------

function ProcessAction(String actionKey)
{
	local DeusExPlayer		localPlayer;
	local String			localStartMap;
	local String            playerName;

	localPlayer   = player;
//	localStartMap = strStartMap;

	if (actionKey == "START")
	{
		// Make sure the name isn't blank
		playerName = TrimSpaceS(editName.GetText());

		if (playerName == "")
		{
			root.MessageBox(NameBlankTitle, NameBlankPrompt, 1, False, Self);
		}
		else
		{
			SaveSettings();

			// DEUS_EX_DEMO
			//
			// Don't show the intro for the demo since that map is not available
//			localPlayer.ShowIntro(True);
			localPlayer.StartNewGame(localPlayer.strStartMap);
		}
	}
}

// ----------------------------------------------------------------------
// SaveSettings()
// ----------------------------------------------------------------------

function SaveSettings()
{
	ApplySkills();
	player.TruePlayerName   = editName.GetText();
	player.PlayerSkin       = portraitIndex;
	player.CombatDifficulty = combatDifficulty;
}

// ----------------------------------------------------------------------
// CancelScreen()
// ----------------------------------------------------------------------

function CancelScreen()
{
	RestoreSkillPoints();	
	Super.CancelScreen();
}

// ----------------------------------------------------------------------
// SaveSkillPoints()
// ----------------------------------------------------------------------

function SaveSkillPoints()
{
	saveSkillPointsAvail = player.SkillPointsAvail;
	saveSkillPointsTotal = player.SkillPointsAvail;
}

// ----------------------------------------------------------------------
// RestoreSkillPoints()
// ----------------------------------------------------------------------

function RestoreSkillPoints()
{
	player.SkillPointsAvail = saveSkillPointsAvail;
	player.SkillPointsAvail = saveSkillPointsTotal;
}

// ----------------------------------------------------------------------
// TrimSpaces()
// ----------------------------------------------------------------------

function String TrimSpaces(String trimString)
{
	local int trimIndex;
	local int trimLength;

	if ( trimString == "" ) 
		return trimString;

	trimIndex = Len(trimString) - 1;
	while ((trimIndex >= 0) && (Mid(trimString, trimIndex, 1) == " ") )
		trimIndex--;

	if ( trimIndex < 0 )
		return "";

	trimString = Mid(trimString, 0, trimIndex + 1);

	trimIndex = 0;
	while((trimIndex < Len(trimString) - 1) && (Mid(trimString, trimIndex, 1) == " "))
		trimIndex++;

	trimLength = len(trimString) - trimIndex;
	trimString = Right(trimString, trimLength);

	return trimString;
}

// ----------------------------------------------------------------------
// BoxOptionSelected()
// ----------------------------------------------------------------------

event bool BoxOptionSelected(Window msgBoxWindow, int buttonNumber)
{
	// Destroy the msgbox!  
	root.PopWindow();

	editName.SetText(player.TruePlayerName);
	editName.MoveInsertionPoint(MOVEINSERT_End);
	editName.SetSelectedArea(0, Len(editName.GetText()));
	SetFocusWindow(editName);

	return True;
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;
	local Color colButtonFace;

	Super.StyleChanged();

	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	// Title colors
	colButtonFace = theme.GetColorFromName('MenuColor_ButtonFace');

	btnLeftArrow.SetButtonColors(colButtonFace, colButtonFace, colButtonFace,
	                             colButtonFace, colButtonFace, colButtonFace);
	btnRightArrow.SetButtonColors(colButtonFace, colButtonFace, colButtonFace,
	                              colButtonFace, colButtonFace, colButtonFace);
}

// ----------------------------------------------------------------------
// SetDifficulty()
// ----------------------------------------------------------------------

function SetDifficulty(float newDifficulty)
{
	combatDifficulty = newDifficulty;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texPortraits(0)=Texture'DeusExUI.UserInterface.MenuNewGameJCDenton_1'
     texPortraits(1)=Texture'DeusExUI.UserInterface.MenuNewGameJCDenton_2'
     texPortraits(2)=Texture'DeusExUI.UserInterface.MenuNewGameJCDenton_3'
     texPortraits(3)=Texture'DeusExUI.UserInterface.MenuNewGameJCDenton_4'
     texPortraits(4)=Texture'DeusExUI.UserInterface.MenuNewGameJCDenton_5'
     filterString="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890 "
     ButtonUpgradeLabel="Upg|&rade"
     ButtonDowngradeLabel="|&Downgrade"
     HeaderNameLabel="Real Name"
     HeaderCodeNameLabel="Code Name"
     HeaderAppearanceLabel="Appearance"
     HeaderSkillsLabel="Skills"
     HeaderSkillPointsLabel="Skill Points"
     HeaderSkillLevelLabel="Skill Level"
     HeaderPointsNeededLabel="Points Needed"
     NameBlankTitle="Name Blank!"
     NameBlankPrompt="The Real Name cannot be blank, please enter a name."
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_Other,Text="|&Start Game",Key="START")
     actionButtons(2)=(Action=AB_Reset)
     Title="Start New Game"
     ClientWidth=580
     ClientHeight=389
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuNewGameBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuNewGameBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuNewGameBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuNewGameBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.MenuNewGameBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.MenuNewGameBackground_6'
     bUsesHelpWindow=False
     bEscapeSavesSettings=False
}
