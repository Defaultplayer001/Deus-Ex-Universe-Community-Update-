//=============================================================================
// MenuUISkillInfoWindow
//=============================================================================

class MenuUISkillInfoWindow expands Window;

var DeusExPlayer player;

var Skill skill;

var Window                 winSkillIcon;
var TextWindow             winSkillName;
var MenuUIScrollAreaWindow winScroll;
var LargeTextWindow        winSkillDescription;

var Color colSkillName;
var Color colSkillDesc;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(405, 130);

	// Create controls
	CreateControls();

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	StyleChanged();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	winSkillIcon = NewChild(Class'Window');
	winSkillIcon.SetPos(3, 20);
	winSkillIcon.SetSize(24, 24);
	winSkillIcon.SetBackgroundStyle(DSTY_Masked);

	winSkillName = TextWindow(NewChild(Class'TextWindow'));
	winSkillName.SetPos(39, 2);
	winSkillName.SetSize(300, 12);
	winSkillName.SetTextMargins(0, 0);
	winSkillName.SetFont(Font'FontMenuHeaders');
	winSkillName.SetTextAlignments(HALIGN_Left, VALIGN_Top);
				
	winScroll = MenuUIScrollAreaWindow(NewChild(Class'MenuUIScrollAreaWindow'));
	winScroll.SetPos(39, 20);
	winScroll.SetSize(362, 104);

	winSkillDescription = LargeTextWindow(winScroll.clipWindow.NewChild(Class'LargeTextWindow'));
	winSkillDescription.SetTextMargins(0, 0);
	winSkillDescription.SetFont(Font'FontMenuSmall');
	winSkillDescription.SetTextAlignments(HALIGN_Left, VALIGN_Top);
}

// ----------------------------------------------------------------------
// SetSkill()
// ----------------------------------------------------------------------

function SetSkill(skill newSkill)
{
	skill = newSkill;
	
	winSkillIcon.SetBackground(skill.SkillIcon);
	winSkillName.SetText(skill.SkillName);
	winSkillDescription.SetText(skill.Description);	
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	// Title colors
	colSkillName = theme.GetColorFromName('MenuColor_ButtonFace');
	colSkillDesc = theme.GetColorFromName('MenuColor_ButtonFace');

	winSkillName.SetTextColor(colSkillName);
	winSkillDescription.SetTextColor(colSkillDesc);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colSkillName=(R=255,G=255,B=255)
     colSkillDesc=(R=200,G=200,B=200)
}
