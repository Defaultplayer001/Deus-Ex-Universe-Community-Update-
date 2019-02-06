//=============================================================================
// PersonaScreenHealth
//=============================================================================

class PersonaScreenHealth extends PersonaScreenBaseWindow;

var PersonaActionButtonWindow   btnHealAll;
var PersonaInfoWindow           winInfo;
var PersonaItemDetailWindow     winMedKits;
var PersonaHealthItemButton     selectedHealthButton;
var PersonaOverlaysWindow       winOverlays;
var PersonaHealthBodyWindow     winBody;

var PersonaHealthItemButton   partButtons[6];
var PersonaHealthRegionWindow regionWindows[6];
var localized String          HealthPartDesc[4];
var Float                     playerHealth[6];

var Bool bShowHealButtons;

var localized String MedKitUseText;
var localized String HealthTitleText;
var localized String HealAllButtonLabel;
var localized String HealthLocationHead;
var localized String HealthLocationTorso;
var localized String HealthLocationRightArm;
var localized String HealthLocationLeftArm;
var localized String HealthLocationRightLeg;
var localized String HealthLocationLeftLeg;
var localized String PointsHealedLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	EnableButtons();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	CreateTitleWindow(9, 5, HealthTitleText);
	CreateInfoWindow();
	CreateOverlaysWindow();
	CreateBodyWindow();
	CreateRegionWindows();
	CreateButtons();
	CreateMedKitWindow();
	CreatePartButtons();
	CreateStatusWindow();

	PersonaNavBarWindow(winNavBar).btnHealth.SetSensitivity(False);
}

// ----------------------------------------------------------------------
// CreateStatusWindow()
// ----------------------------------------------------------------------

function CreateStatusWindow()
{
	winStatus = PersonaStatusLineWindow(winClient.NewChild(Class'PersonaStatusLineWindow'));
	winStatus.SetPos(348, 269);
}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
	winInfo = PersonaInfoWindow(winClient.NewChild(Class'PersonaInfoWindow'));
	winInfo.SetPos(348, 22);
	winInfo.SetSize(238, 239);
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	local PersonaButtonBarWindow winActionButtons;

	winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(13, 407);
	winActionButtons.SetWidth(92);
	winActionButtons.FillAllSpace(False);

	btnHealAll = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnHealAll.SetButtonText(HealAllButtonLabel);
}

// ----------------------------------------------------------------------
// CreateMedKitWindow()
// ----------------------------------------------------------------------

function CreateMedKitWindow()
{
	winMedKits = PersonaItemDetailWindow(winClient.NewChild(Class'PersonaItemDetailWindow'));
	winMedKits.SetPos(346, 307);
	winMedKits.SetWidth(242);
	winMedKits.SetIcon(Class'MedKit'.Default.LargeIcon);
	winMedKits.SetIconSize(
		Class'MedKit'.Default.largeIconWidth,
		Class'MedKit'.Default.largeIconHeight);

	UpdateMedKits();
}

// ----------------------------------------------------------------------
// CreatePartButtons()
// ----------------------------------------------------------------------

function CreatePartButtons()
{
	partButtons[0] = CreatePartButton(0, 141,  42, 40, 54, HealthPartDesc[0], HealthLocationHead);
	partButtons[1] = CreatePartButton(1, 133,  98, 56, 73, HealthPartDesc[1], HealthLocationTorso);
	partButtons[2] = CreatePartButton(2,  90, 131, 28, 65, HealthPartDesc[2], HealthLocationRightArm);
	partButtons[3] = CreatePartButton(3, 204, 131, 28, 65, HealthPartDesc[2], HealthLocationLeftArm);
	partButtons[4] = CreatePartButton(4, 119, 234, 41, 94, HealthPartDesc[3], HealthLocationRightLeg);
	partButtons[5] = CreatePartButton(5, 162, 234, 41, 94, HealthPartDesc[3], HealthLocationLeftLeg);
}

// ----------------------------------------------------------------------
// CreatePartButton()
// ----------------------------------------------------------------------

function PersonaHealthItemButton CreatePartButton(
	int partIndex,
	int posX, int posY, 
	int sizeX, int sizeY, 
	String partDesc, String partTitle)
{
	local PersonaHealthItemButton newPart;

	newPart = PersonaHealthItemButton(winClient.NewChild(Class'PersonaHealthItemButton'));
	newPart.SetPos(posX, posY);
	newPart.SetSize(sizeX, sizeY);
	newPart.SetBorderSize(sizeX, sizeY);
	newPart.SetDesc(partDesc);
	newPart.SetTitle(partTitle);

	return newPart;
}

// ----------------------------------------------------------------------
// CreateRegionWindows()
// ----------------------------------------------------------------------

function CreateRegionWindows()
{
	regionWindows[0] = CreateRegionWindow(0, 218,  29, player.HealthHead,     player.default.HealthHead,     HealthLocationHead);
	regionWindows[1] = CreateRegionWindow(1,  27,  43, player.HealthTorso,    player.default.HealthTorso,    HealthLocationTorso);
	regionWindows[2] = CreateRegionWindow(2,  19, 237, player.HealthArmRight, player.default.HealthArmRight, HealthLocationRightArm);
	regionWindows[3] = CreateRegionWindow(3, 230, 237, player.HealthArmLeft,  player.default.HealthArmLeft,  HealthLocationLeftArm);
	regionWindows[4] = CreateRegionWindow(4,  24, 347, player.HealthLegRight, player.default.HealthLegRight, HealthLocationRightLeg);
	regionWindows[5] = CreateRegionWindow(5, 222, 347, player.HealthLegLeft,  player.default.HealthLegLeft,  HealthLocationLeftLeg);
}

// ----------------------------------------------------------------------
// CreateRegionWindow()
// ----------------------------------------------------------------------

function PersonaHealthRegionWindow CreateRegionWindow(
	int partIndex,
	int posX, int posY, 
	int healthValue, int maxHealthValue, 
	String partTitle)
{
	local PersonaHealthRegionWindow newRegion;

	newRegion = PersonaHealthRegionWindow(winClient.NewChild(Class'PersonaHealthRegionWindow'));
	newRegion.SetPos(posX, posY);
	newRegion.SetMaxHealth(maxHealthValue);
	newRegion.SetHealth(healthValue);
	newRegion.SetPartIndex(partIndex);
	newRegion.SetTitle(partTitle);
	newRegion.ShowHealButton(bShowHealButtons);
	newRegion.Raise();

	return newRegion;
}

// ----------------------------------------------------------------------
// UpdateRegionWindows()
// ----------------------------------------------------------------------

function UpdateRegionWindows()
{
	local int partIndex;

	for(partIndex=0; partIndex<arrayCount(regionWindows); partIndex++)
		regionWindows[partIndex].Destroy();

	CreateRegionWindows();
}

// ----------------------------------------------------------------------
// CreateBodyWindow()
// ----------------------------------------------------------------------

function CreateBodyWindow()
{
	winBody = PersonaHealthBodyWindow(winClient.NewChild(Class'PersonaHealthBodyWindow'));
	winBody.SetPos(24, 36);
	winBody.Lower();
}

// ----------------------------------------------------------------------
// CreateOverlaysWindow()
// ----------------------------------------------------------------------

function CreateOverlaysWindow()
{
	winOverlays = PersonaOverlaysWindow(winClient.NewChild(Class'PersonaHealthOverlaysWindow'));
	winOverlays.SetPos(24, 36);
	winOverlays.Lower();
}

// ----------------------------------------------------------------------
// UpdateMedKits()
// ----------------------------------------------------------------------

function UpdateMedKits()
{
	local MedKit medKit;

	if (winMedKits != None)
	{
		winMedKits.SetText(MedKitUseText);

		medKit = MedKit(player.FindInventoryType(Class'MedKit'));

		if (medKit != None)
			winMedKits.SetCount(medKit.NumCopies);
		else
			winMedKits.SetCount(0);	
	}
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated(Window buttonPressed)
{
	local bool bHandled;
	local int  pointsHealed;

	if (Super.ButtonActivated(buttonPressed))
		return True;

	bHandled   = True;

	// Check if this is one of our Augmentation buttons
	if (buttonPressed.IsA('PersonaHealthItemButton'))
	{
		SelectHealth(PersonaHealthItemButton(buttonPressed));
	}
	else if (buttonPressed.IsA('PersonaHealthActionButtonWindow'))
	{
		PushHealth();
		pointsHealed = HealPart(regionWindows[PersonaHealthActionButtonWindow(buttonPressed).GetPartIndex()]);
		player.PopHealth( playerHealth[0],playerHealth[1],playerHealth[2],playerHealth[3],playerHealth[4],playerHealth[5]);
		winStatus.AddText(Sprintf(PointsHealedLabel, pointsHealed));

		EnableButtons();
	}
	else if (buttonPressed.GetParent().IsA('PersonaHealthRegionWindow'))
	{
		partButtons[PersonaHealthRegionWindow(buttonPressed.GetParent()).GetPartIndex()].PressButton(IK_None);
	}
	else
	{
		switch(buttonPressed)
		{
			case btnHealAll:
				HealAllParts();
				break;

			default:
				bHandled = False;
				break;
		}
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// SelectHealth()
// ----------------------------------------------------------------------

function SelectHealth(PersonaHealthItemButton buttonPressed)
{
	// Don't do extra work.
	if (selectedHealthButton != buttonPressed)
	{
		// Deselect current button
		if (selectedHealthButton != None)
			selectedHealthButton.SelectButton(False);

		selectedHealthButton = buttonPressed;
		selectedHealthButton.SelectButton(True);

		// Update the display
		winInfo.SetTitle(selectedHealthButton.GetTitle());
		winInfo.SetText(selectedHealthButton.GetDesc());

		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// PushHealth()
// ----------------------------------------------------------------------

function PushHealth()
{
	playerHealth[0] = player.HealthHead;
	playerHealth[1] = player.HealthTorso;
	playerHealth[2] = player.HealthArmRight;
	playerHealth[3] = player.HealthArmLeft;
	playerHealth[4] = player.HealthLegRight;
	playerHealth[5] = player.HealthLegLeft;
}

// ----------------------------------------------------------------------
// HealAllParts()
//
// Uses as many medkits as possible to heal as much damage.  Health
// points are distributed evenly among parts
// ----------------------------------------------------------------------

function int HealAllParts()
{
	local MedKit medkit;
	local int    healPointsAvailable;
	local int    healPointsRemaining;
	local int    pointsHealed;
	local int    regionIndex;
	local float  damageAmount;
	local bool   bPartDamaged;

	pointsHealed = 0;
	PushHealth();

	// First determine how many medkits the player has
	healPointsAvailable = GetMedKitHealPoints();
	healPointsRemaining = healPointsAvailable;

	// Now loop through all the parts repeatedly until 
	// we either:
	// 
	// A) Run out of parts to heal or 
	// B) Run out of points to distribute.

	while(healPointsRemaining > 0) 
	{
		bPartDamaged = False;

		// Loop through all the parts
		for(regionIndex=0; regionIndex<arrayCount(regionWindows); regionIndex++)
		{
			damageAmount = regionWindows[regionIndex].maxHealth - regionWindows[regionIndex].currentHealth;

			if ((damageAmount > 0) && (healPointsRemaining > 0))
			{
				// Heal this part
				pointsHealed += HealPart(regionWindows[regionIndex], 1, True);

				healPointsRemaining--;
				bPartDamaged = True;
			}
		}

		if (!bPartDamaged)
			break;
	}
		
	// Now remove any medkits we may have used
	RemoveMedKits(healPointsAvailable - healPointsRemaining);

	player.PopHealth( playerHealth[0],playerHealth[1],playerHealth[2],playerHealth[3],playerHealth[4],playerHealth[5]);

	EnableButtons();

	winStatus.AddText(Sprintf(PointsHealedLabel, pointsHealed));

	return pointsHealed;
}

// ----------------------------------------------------------------------
// GetMedKitHealPoints()
// ----------------------------------------------------------------------

function int GetMedKitHealPoints()
{
	local MedKit medkit;

	medKit = MedKit(player.FindInventoryType(Class'MedKit'));

	if (medKit != None)
		return player.CalculateSkillHealAmount(medKit.NumCopies * medKit.healAmount);
	else
		return 0;
}

// ----------------------------------------------------------------------
// RemoveMedKits
// ----------------------------------------------------------------------

function RemoveMedKits(int healPointsUsed)
{
	local MedKit medkit;
	local int    healPointsRemaining;

	healPointsRemaining = healPointsUsed;
	medKit = MedKit(player.FindInventoryType(Class'MedKit'));

	while((medKit != None) && (healPointsRemaining > 0))
	{
		healPointsRemaining -= player.CalculateSkillHealAmount(medkit.healAmount);
		UseMedKit(medkit);
		medKit = MedKit(player.FindInventoryType(Class'MedKit'));
	}
}

// ----------------------------------------------------------------------
// HealPart()
//
// Returns the amount of damage healed
// ----------------------------------------------------------------------

function int HealPart(PersonaHealthRegionWindow region, optional float pointsToHeal, optional bool bLeaveMedKit)
{
	local float healthAdded;
	local float newHealth;
	local medKit medKit;

	// First make sure the player has a medkit
	medKit = MedKit(player.FindInventoryType(Class'MedKit'));
	
	if ((region == None) || (medKit == None))
		return 0;

	// If a point value was passesd in, use it as the amount of 
	// points to heal for this body part.  Otherwise use the 
	// medkit's default heal amount.

	if (pointsToHeal == 0)
		pointsToHeal = player.CalculateSkillHealAmount(medKit.healAmount);

	// Heal the selected body part by the number of 
	// points available in the part


	// If our player is in a multiplayer game, heal across 3 hit locations
	if ( player.PlayerIsClient() )
	{
		switch(region.GetPartIndex())
		{
			case 0:		// head
				newHealth = FMin(playerHealth[0] + pointsToHeal, player.default.HealthHead);
				healthAdded = newHealth - playerHealth[0];
				playerHealth[0] = newHealth;
				break;

			case 1:		// torso, right arm, left arm
			case 2:
			case 3:
				pointsToHeal *= 0.333;	// Divide heal points among parts
				newHealth = FMin(playerHealth[1] + pointsToHeal, player.default.HealthTorso);
				healthAdded = newHealth - playerHealth[1];
				playerHealth[1] = newHealth;
				regionWindows[1].SetHealth(newHealth);
				newHealth = FMin(playerHealth[2] + pointsToHeal, player.default.HealthArmRight);
				healthAdded = newHealth - playerHealth[2];
				playerHealth[2] = newHealth;
				regionWindows[2].SetHealth(newHealth);
				newHealth = FMin(playerHealth[3] + pointsToHeal, player.default.HealthArmLeft);
				healthAdded = newHealth - playerHealth[3];
				playerHealth[3] = newHealth;
				regionWindows[3].SetHealth(newHealth);
				break;
			case 4:		// right leg, left leg
			case 5:
				pointsToHeal *= 0.5;		// Divide heal points among parts
				newHealth = FMin(playerHealth[4] + pointsToHeal, player.default.HealthLegRight);
				healthAdded = newHealth - playerHealth[4];
				playerHealth[4] = newHealth;
				regionWindows[4].SetHealth(newHealth);
				newHealth = FMin(playerHealth[5] + pointsToHeal, player.default.HealthLegLeft);
				healthAdded = newHealth - playerHealth[5];
				playerHealth[5] = newHealth;
				regionWindows[5].SetHealth(newHealth);
				break;
		}
	}
	else
	{
		switch(region.GetPartIndex())
		{
			case 0:		// head
				newHealth = FMin(playerHealth[0] + pointsToHeal, player.default.HealthHead);
				healthAdded = newHealth - playerHealth[0];
				playerHealth[0] = newHealth;
				break;

			case 1:		// torso
				newHealth = FMin(playerHealth[1] + pointsToHeal, player.default.HealthTorso);
				healthAdded = newHealth - playerHealth[1];
				playerHealth[1] = newHealth;
				break;

			case 2:		// right arm
				newHealth = FMin(playerHealth[2] + pointsToHeal, player.default.HealthArmRight);
				healthAdded = newHealth - playerHealth[2];
				playerHealth[2] = newHealth;
				break;

			case 3:		// left arm
				newHealth = FMin(playerHealth[3] + pointsToHeal, player.default.HealthArmLeft);
				healthAdded = newHealth - playerHealth[3];
				playerHealth[3] = newHealth;
				break;

			case 4:		// right leg
				newHealth = FMin(playerHealth[4] + pointsToHeal, player.default.HealthLegRight);
				healthAdded = newHealth - playerHealth[4];
				playerHealth[4] = newHealth;
				break;

			case 5:		// left leg
				newHealth = FMin(playerHealth[5] + pointsToHeal, player.default.HealthLegLeft);
				healthAdded = newHealth - playerHealth[5];
				playerHealth[5] = newHealth;
				break;
		}
	}

	region.SetHealth(newHealth);

	// Remove the item from the player's invenory and this screen
	if (!bLeaveMedKit)
		UseMedKit(medkit);

	return healthAdded;
}

// ----------------------------------------------------------------------
// UseMedKit()
// ----------------------------------------------------------------------

function UseMedKit(MedKit medkit)
{
	if (medKit != None)
	{
		medKit.UseOnce();
		UpdateMedKits();

		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	local int regionIndex;
	local medKit medKit;

	// First make sure the player has a medkit
	medKit = MedKit(player.FindInventoryType(Class'MedKit'));

	// Heal All button available as long as one or more
	// parts is damaged and the player has at least one
	// kit

	btnHealAll.EnableWindow((medKit != None) && (IsPlayerDamaged()));

	// Loop through the region windows, since they have Heal buttons
	// attached to them
	for (regionIndex=0; regionIndex<arrayCount(regionWindows); regionIndex++)
		regionWindows[regionIndex].EnableButtons();
}

// ----------------------------------------------------------------------
// IsPlayerDamaged()
//
// Looks at all the player's parts to see if he/she/it is damaged
// ----------------------------------------------------------------------

function bool IsPlayerDamaged()
{
	local int regionIndex;
	local bool bDamaged;

	bDamaged = False;

	for(regionIndex=0; regionIndex<arrayCount(regionWindows); regionIndex++)
	{
		if (regionWindows[regionIndex].maxHealth > regionWindows[regionIndex].currentHealth)
		{
			bDamaged = True;
			break;
		}
	}

	return bDamaged;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HealthPartDesc(0)="Head wounds are fatal in the vast majority of threat scenarios; however, in those cases where death is not instantaneous, agents will often find that head injuries impair vision and aim. Care should be taken to heal such injuries as quickly as possible or death may result.|n|nLight Wounds: Slightly decreased accuracy.|nMedium Wounds: Wavering vision.|nHeavy Wounds: Death."
     HealthPartDesc(1)="The torso is by far the portion of the human anatomy able to absorb the most damage, but it is also the easiest to target in close quarters combat. As progressively more damage is inflicted to the torso, agents may find their movements impaired and eventually bleed to death even if a mortal blow to a vital organ is not suffered.|n|nLight Wounds: Slightly impaired movement.|nMedium Wounds: Significantly impaired movement.|nMajor Wounds: Death."
     HealthPartDesc(2)="Obviously damage to the arm is of concern in any combat situation as it has a direct effect on the agent's ability to utilize a variety of weapons. Losing the use of one arm will certainly lower the agent's combat efficiency, while the loss of both arms will render it nearly impossible for an agent to present even a nominal threat to most hostiles.|n|nLight Wounds: Slightly decreased accuracy.|nMedium Wounds: Moderately decreased accuracy.|nMajor Wounds: Significantly decreased accuracy."
     HealthPartDesc(3)="Injuries to the leg will result in drastically diminished mobility. If an agent in hostile territory is unfortunate enough to lose the use of both legs but still remain otherwise viable, they are ordered to execute UNATCO Special Operations Order 99009 (Self-Termination).|n|nLight Wounds: Slightly impaired movement.|nMedium Wounds: Moderately impaired movement.|nHeavy Wounds: Significantly impaired movement."
     bShowHealButtons=True
     MedKitUseText="To heal a specific region of the body, click on the region, then click the Heal button."
     HealthTitleText="Health"
     HealAllButtonLabel="H|&eal All"
     HealthLocationHead="Head"
     HealthLocationTorso="Torso"
     HealthLocationRightArm="Right Arm"
     HealthLocationLeftArm="Left Arm"
     HealthLocationRightLeg="Right Leg"
     HealthLocationLeftLeg="Left Leg"
     PointsHealedLabel="%d points healed"
     clientBorderOffsetY=32
     ClientWidth=596
     ClientHeight=427
     clientOffsetX=25
     clientOffsetY=5
     clientTextures(0)=Texture'DeusExUI.UserInterface.HealthBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.HealthBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.HealthBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.HealthBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.HealthBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.HealthBackground_6'
     clientBorderTextures(0)=Texture'DeusExUI.UserInterface.HealthBorder_1'
     clientBorderTextures(1)=Texture'DeusExUI.UserInterface.HealthBorder_2'
     clientBorderTextures(2)=Texture'DeusExUI.UserInterface.HealthBorder_3'
     clientBorderTextures(3)=Texture'DeusExUI.UserInterface.HealthBorder_4'
     clientBorderTextures(4)=Texture'DeusExUI.UserInterface.HealthBorder_5'
     clientBorderTextures(5)=Texture'DeusExUI.UserInterface.HealthBorder_6'
     clientTextureRows=2
     clientTextureCols=3
     clientBorderTextureRows=2
     clientBorderTextureCols=3
}
