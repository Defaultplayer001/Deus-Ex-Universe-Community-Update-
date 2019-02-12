//=============================================================================
// PersonaScreenAugmentations
//=============================================================================

class PersonaScreenAugmentations extends PersonaScreenBaseWindow;

var PersonaActionButtonWindow			btnActivate;
var PersonaActionButtonWindow			btnUpgrade;
var PersonaActionButtonWindow			btnUseCell;
var PersonaInfoWindow					winInfo;
var PersonaAugmentationBodyWindow		winBody;
var PersonaAugmentationOverlaysWindow	winOverlays;
var PersonaItemDetailWindow             winBioCells;
var PersonaItemDetailWindow             winAugCans;
var ProgressBarWindow					winBioEnergy;
var TextWindow                          winBioEnergyText;

// Currently selected button, either a skill or augmentation
var Augmentation      selectedAug;
var PersonaItemButton selectedAugButton;

struct AugLoc_S
{
	var int x;
	var int y;
};

var AugLoc_S augLocs[7];
var PersonaAugmentationItemButton augItems[12];
var Texture                       augHighlightTextures[6];
var Window                        augHighlightWindows[6];

var int augSlotSpacingX;
var int augSlotSpacingY;

var Color colBarBack;

var localized String AugmentationsTitleText;
var localized String UpgradeButtonLabel;
var localized String ActivateButtonLabel;
var localized String DeactivateButtonLabel;
var localized String UseCellButtonLabel;
var localized String AugCanUseText;
var localized String BioCellUseText;

var Localized string AugLocationDefault;
var Localized string AugLocationCranial;
var Localized string AugLocationEyes;
var Localized string AugLocationArms;
var Localized string AugLocationLegs;
var Localized string AugLocationTorso;
var Localized string AugLocationSubdermal;

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

	CreateTitleWindow(9, 5, AugmentationsTitleText);
	CreateInfoWindow();
	CreateButtons();
	CreateAugmentationLabels();
	CreateAugmentationHighlights();
	CreateAugmentationButtons();
	CreateOverlaysWindow();
	CreateBodyWindow();
	CreateBioCellBar();
	CreateAugCanWindow();
	CreateBioCellWindow();
	CreateStatusWindow();

	PersonaNavBarWindow(winNavBar).btnAugs.SetSensitivity(False);
}

// ----------------------------------------------------------------------
// CreateStatusWindow()
// ----------------------------------------------------------------------

function CreateStatusWindow()
{
	winStatus = PersonaStatusLineWindow(winClient.NewChild(Class'PersonaStatusLineWindow'));
	winStatus.SetPos(348, 240);
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	local PersonaButtonBarWindow winActionButtons;

	winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(13, 407);
	winActionButtons.SetWidth(187);
	winActionButtons.FillAllSpace(False);

	btnUpgrade = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnUpgrade.SetButtonText(UpgradeButtonLabel);

	btnActivate = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnActivate.SetButtonText(ActivateButtonLabel);

	winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(346, 387);
	winActionButtons.SetWidth(97);
	winActionButtons.FillAllSpace(False);

	btnUseCell = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnUseCell.SetButtonText(UseCellButtonLabel);
}

// ----------------------------------------------------------------------
// CreateBodyWindow()
// ----------------------------------------------------------------------

function CreateBodyWindow()
{
	winBody = PersonaAugmentationBodyWindow(winClient.NewChild(Class'PersonaAugmentationBodyWindow'));
	winBody.SetPos(72, 28);
	winBody.Lower();
}

// ----------------------------------------------------------------------
// CreateOverlaysWindow()
// ----------------------------------------------------------------------

function CreateOverlaysWindow()
{
	winOverlays = PersonaAugmentationOverlaysWindow(winClient.NewChild(Class'PersonaAugmentationOverlaysWindow'));
	winOverlays.SetPos(72, 28);
	winOverlays.Lower();
}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
	winInfo = PersonaInfoWindow(winClient.NewChild(Class'PersonaInfoWindow'));
	winInfo.SetPos(348, 14);
	winInfo.SetSize(238, 218);
}

// ----------------------------------------------------------------------
// CreateAugmentationLabels()
// ----------------------------------------------------------------------

function CreateAugmentationLabels()
{
	CreateLabel( 57,  27, AugLocationCranial);
	CreateLabel(212,  27, AugLocationEyes);
	CreateLabel( 19, 103, AugLocationArms);
	CreateLabel( 19, 187, AugLocationSubdermal);
	CreateLabel(247, 109, AugLocationTorso);
	CreateLabel( 19, 330, AugLocationDefault);
	CreateLabel(247, 311, AugLocationLegs);
}

// ----------------------------------------------------------------------
// CreateLabel()
// ----------------------------------------------------------------------

function CreateLabel(int posX, int posY, String strLabel)
{
	local PersonaNormalTextWindow winLabel;

	winLabel = PersonaNormalTextWindow(winClient.NewChild(Class'PersonaNormalTextWindow'));
	winLabel.SetPos(posX, posY);
	winLabel.SetSize(52, 11);
	winLabel.SetText(strLabel);
	winLabel.SetTextMargins(2, 1);
}

// ----------------------------------------------------------------------
// CreateAugCanWindow()
// ----------------------------------------------------------------------

function CreateAugCanWindow()
{
	winAugCans = PersonaItemDetailWindow(winClient.NewChild(Class'PersonaItemDetailWindow'));
	winAugCans.SetPos(346, 274);
	winAugCans.SetWidth(242);
	winAugCans.SetIcon(Class'AugmentationUpgradeCannister'.Default.LargeIcon);
	winAugCans.SetIconSize(
		Class'AugmentationUpgradeCannister'.Default.largeIconWidth,
		Class'AugmentationUpgradeCannister'.Default.largeIconHeight);

	UpdateAugCans();
}

// ----------------------------------------------------------------------
// CreateBioCellWindow()
// ----------------------------------------------------------------------

function CreateBioCellWindow()
{
	winBioCells = PersonaItemDetailWindow(winClient.NewChild(Class'PersonaItemDetailWindow'));
	winBioCells.SetPos(346, 332);
	winBioCells.SetWidth(242);
	winBioCells.SetIcon(Class'BioelectricCell'.Default.LargeIcon);
	winBioCells.SetIconSize(
		Class'BioelectricCell'.Default.largeIconWidth,
		Class'BioelectricCell'.Default.largeIconHeight);

	UpdateBioCells();
}

// ----------------------------------------------------------------------
// CreateBioCellBar()
// ----------------------------------------------------------------------

function CreateBioCellBar()
{
	winBioEnergy = ProgressBarWindow(winClient.NewChild(Class'ProgressBarWindow'));

	winBioEnergy.SetPos(446, 389);
	winBioEnergy.SetSize(140, 12);
	winBioEnergy.SetValues(0, 100);
	winBioEnergy.UseScaledColor(True);
	winBioEnergy.SetVertical(False);
	winBioEnergy.SetScaleColorModifier(0.5);
	winBioEnergy.SetDrawBackground(True);
	winBioEnergy.SetBackColor(colBarBack);

	winBioEnergyText = TextWindow(winClient.NewChild(Class'TextWindow'));
	winBioEnergyText.SetPos(446, 391);
	winBioEnergyText.SetSize(140, 12);
	winBioEnergyText.SetTextMargins(0, 0);
	winBioEnergyText.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winBioEnergyText.SetFont(Font'FontMenuSmall_DS');
	winBioEnergyText.SetTextColorRGB(255, 255, 255);

	UpdateBioEnergyBar();
}

// ----------------------------------------------------------------------
// UpdateBioEnergyBar()
// ----------------------------------------------------------------------

function UpdateBioEnergyBar()
{
	local float energyPercent;
		
	energyPercent = 100.0 * (player.Energy / player.EnergyMax);

	winBioEnergy.SetCurrentValue(energyPercent);
	winBioEnergyText.SetText(String(Int(energyPercent)) $ "%");
}

// ----------------------------------------------------------------------
// UpdateAugCans()
// ----------------------------------------------------------------------

function UpdateAugCans()
{
	local Inventory anItem;
	local int augCanCount;

	if (winAugCans != None)
	{
		winAugCans.SetText(AugCanUseText);

		// Loop through the player's inventory and count how many upgrade cans
		// the player has
		anItem = player.Inventory;

		while(anItem != None)
		{
			if (anItem.IsA('AugmentationUpgradeCannister'))
				augCanCount++;

			anItem = anItem.Inventory;
		}	

		winAugCans.SetCount(augCanCount);
	}
}

// ----------------------------------------------------------------------
// UpdateBioCells()
// ----------------------------------------------------------------------

function UpdateBioCells()
{
	local BioelectricCell bioCell;

	if (winBioCells != None)
	{
		winBioCells.SetText(BioCellUseText);

		bioCell = BioelectricCell(player.FindInventoryType(Class'BioelectricCell'));

		if (bioCell != None)
			winBioCells.SetCount(bioCell.NumCopies);
		else
			winBioCells.SetCount(0);	
	}

	UpdateBioEnergyBar();
}

// ----------------------------------------------------------------------
// RefreshWindow()
// ----------------------------------------------------------------------

function RefreshWindow(float DeltaTime)
{
    UpdateAugCans();
    UpdateBioCells();
    UpdateBioEnergyBar();

    if (selectedAugButton != None)			
    {
        PersonaAugmentationItemButton(selectedAugButton).SetLevel(selectedAug.GetCurrentLevel());
        PersonaAugmentationItemButton(selectedAugButton).SetActive(selectedAug.IsActive());
    }


    EnableButtons();

    Super.RefreshWindow(DeltaTime);
}

// ----------------------------------------------------------------------
// CreateAugmentationHighlights()
// ----------------------------------------------------------------------

function CreateAugmentationHighlights()
{
	augHighlightWindows[0] = CreateHighlight(augHighlightTextures[0], 142,  45, 16, 19);
	augHighlightWindows[1] = CreateHighlight(augHighlightTextures[1], 161,  63, 19, 12);
	augHighlightWindows[2] = CreateHighlight(augHighlightTextures[2], 157, 108, 34, 48);
	augHighlightWindows[3] = CreateHighlight(augHighlightTextures[3], 105, 110, 24, 43);
	augHighlightWindows[4] = CreateHighlight(augHighlightTextures[4], 165, 222, 32, 94);
	augHighlightWindows[5] = CreateHighlight(augHighlightTextures[5],  84, 160, 14, 36);
}

// ----------------------------------------------------------------------
// CreateHighlight()
// ----------------------------------------------------------------------

function Window CreateHighlight(
	Texture texHighlight, 
	int posX, int posY, 
	int sizeX, int sizeY)
{
	local Window newHighlight;

	newHighlight = winClient.NewChild(Class'Window');

	newHighlight.SetPos(posX, posY);
	newHighlight.SetSize(sizeX, sizeY);
	newHighlight.SetBackground(texHighlight);
	newHighlight.SetBackgroundStyle(DSTY_Masked);
	newHighlight.Hide();

	return newHighlight;
}

// ----------------------------------------------------------------------
// CreateAugmentationButtons()
//
// Loop through all the Augmentation items and draw them in our Augmentation grid as 
// buttons
// ----------------------------------------------------------------------

function CreateAugmentationButtons()
{
	local Augmentation anAug;
	local int augX, augY;
	local int torsoCount;
	local int skinCount;
	local int defaultCount;
	local int slotIndex;
	local int augCount;

	augCount   = 0;
	torsoCount = 0;
	skinCount  = 0;
	defaultCount = 0;

	// Iterate through the augmentations, creating a unique button for each
	anAug = player.AugmentationSystem.FirstAug;
	while(anAug != None)
	{
		if (( anAug.AugmentationName != "" ) && ( anAug.bHasIt ))
		{
			slotIndex = 0;
			augX = augLocs[int(anAug.AugmentationLocation)].x;
			augY = augLocs[int(anAug.AugmentationLocation)].y;

			// Show the highlight graphic for this augmentation slot as long
			// as it's not the Default slot (for which there is no graphic)

			if (anAug.AugmentationLocation < arrayCount(augHighlightWindows))
				augHighlightWindows[anAug.AugmentationLocation].Show();

			if (int(anAug.AugmentationLocation) == 2)			// Torso
			{
				slotIndex = torsoCount;
				augY += (torsoCount++ * augSlotSpacingY);
			}

			if (int(anAug.AugmentationLocation) == 5)			// Subdermal
			{
				slotIndex = skinCount;
				augY += (skinCount++ * augSlotSpacingY);
			}

			if (int(anAug.AugmentationLocation) == 6)			// Default
				augX += (defaultCount++ * augSlotSpacingX);

			augItems[augCount] = CreateAugButton(anAug, augX, augY, slotIndex);

			// If the augmentation is active, make sure the button draws it 
			// appropriately

			augItems[augCount].SetActive(anAug.IsActive());
				
			augCount++;
		}

		anAug = anAug.next;
	}	
}

// ----------------------------------------------------------------------
// CreateAugButton
// ----------------------------------------------------------------------

function PersonaAugmentationItemButton CreateAugButton(Augmentation anAug, int augX, int augY, int slotIndex)
{
	local PersonaAugmentationItemButton newButton;

	newButton = PersonaAugmentationItemButton(winClient.NewChild(Class'PersonaAugmentationItemButton'));
	newButton.SetPos(augX, augY);
	newButton.SetClientObject(anAug);
	newButton.SetIcon(anAug.icon);

	// set the hotkey number
	if (!anAug.bAlwaysActive)
		newButton.SetHotkeyNumber(anAug.GetHotKey());

	// If the augmentation is currently active, notify the button
	newButton.SetActive(anAug.IsActive());
	newButton.SetLevel(anAug.GetCurrentLevel());

	return newButton;
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated(Window buttonPressed)
{
	local bool bHandled;

	if (Super.ButtonActivated(buttonPressed))
		return True;

	bHandled   = True;

	// Check if this is one of our Augmentation buttons
	if (buttonPressed.IsA('PersonaItemButton'))
	{
		SelectAugmentation(PersonaItemButton(buttonPressed));
	}
	else
	{
		switch(buttonPressed)
		{
			case btnUpgrade:
				UpgradeAugmentation();
				break;

			case btnActivate:
				ActivateAugmentation();
				break;

			case btnUseCell:
				UseCell();
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
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bKeyHandled;
	bKeyHandled = True;

	if (Super.VirtualKeyPressed(key, bRepeat))
		return True;

	switch( key ) 
	{	
		case IK_F3:
			SelectAugByKey(0);
			break;
		case IK_F4:
			SelectAugByKey(1);
			break;
		case IK_F5:
			SelectAugByKey(2);
			break;
		case IK_F6:
			SelectAugByKey(3);
			break;
		case IK_F7:
			SelectAugByKey(4);
			break;
		case IK_F8:
			SelectAugByKey(5);
			break;
		case IK_F9:
			SelectAugByKey(6);
			break;
		case IK_F10:
			SelectAugByKey(7);
			break;
		case IK_F11:
			SelectAugByKey(8);
			break;
		case IK_F12:
			SelectAugByKey(9);
			break;

		// Enter will toggle an aug on/off
		case IK_Enter:
			ActivateAugmentation();
			break;

		default:
			bKeyHandled = False;
			break;
	}

	return bKeyHandled;
}

// ----------------------------------------------------------------------
// SelectAugByKey()
// ----------------------------------------------------------------------

function SelectAugByKey(int keyNum)
{
	local int buttonIndex;
	local Augmentation anAug;

	for(buttonIndex=0; buttonIndex<arrayCount(augItems); buttonIndex++)
	{
		if (augItems[buttonIndex] != None)
		{
			anAug = Augmentation(augItems[buttonIndex].GetClientObject());
		
			if ((anAug != None) && (anAug.HotKeyNum - 3 == keyNum))
			{
				SelectAugmentation(augItems[buttonIndex]);
				ActivateAugmentation();
				break;
			}
		}
	}
}

// ----------------------------------------------------------------------
// SelectAugmentation()
// ----------------------------------------------------------------------

function SelectAugmentation(PersonaItemButton buttonPressed)
{
	// Don't do extra work.
	if (selectedAugButton != buttonPressed)
	{
		// Deselect current button
		if (selectedAugButton != None)
			selectedAugButton.SelectButton(False);

		selectedAugButton = buttonPressed;
		selectedAug       = Augmentation(selectedAugButton.GetClientObject());

		selectedAug.UpdateInfo(winInfo);
		selectedAugButton.SelectButton(True);

		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// UpgradeAugmentation()
// ----------------------------------------------------------------------

function UpgradeAugmentation()
{
	local AugmentationUpgradeCannister augCan;

	// First make sure we have a selected Augmentation
	if (selectedAug == None)
		return;

	// Now check to see if we have an upgrade cannister
	augCan = AugmentationUpgradeCannister(player.FindInventoryType(Class'AugmentationUpgradeCannister'));

	if (augCan != None)
	{
		// Increment the level and remove the aug cannister from
		// the player's inventory

		selectedAug.IncLevel();
		selectedAug.UpdateInfo(winInfo);
 
		augCan.UseOnce();

		// Update the level icons
		if (selectedAugButton != None)
			PersonaAugmentationItemButton(selectedAugButton).SetLevel(selectedAug.GetCurrentLevel());
	}

	UpdateAugCans();
	EnableButtons();
}

// ----------------------------------------------------------------------
// ActivateAugmentation()
// ----------------------------------------------------------------------

function ActivateAugmentation()
{
	if (selectedAug == None)
		return;
	
	if (selectedAug.IsActive())
		selectedAug.Deactivate();
	else
		selectedAug.Activate();

	// If the augmentation activated or deactivated, set the 
	// button appropriately.

	if (selectedAugButton != None)
		PersonaAugmentationItemButton(selectedAugButton).SetActive(selectedAug.IsActive());

	selectedAug.UpdateInfo(winInfo);

	EnableButtons();
}

// ----------------------------------------------------------------------
// UseCell()
// ----------------------------------------------------------------------

function UseCell()
{
	local BioelectricCell bioCell;

	bioCell = BioelectricCell(player.FindInventoryType(Class'BioelectricCell'));

	if (bioCell != None)
		bioCell.Activate();
		
	UpdateBioCells();
	EnableButtons();
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	// Upgrade can only be enabled if the player has an
	// AugmentationUpgradeCannister that allows this augmentation to 
	// be upgraded

	if (selectedAug != None)
		btnUpgrade.EnableWindow(selectedAug.CanBeUpgraded());
	else
		btnUpgrade.EnableWindow(False);

	// Only allow btnActivate to be active if 
	//
	// 1.  We have a selected augmentation 
	// 2.  The player's energy is above 0
	// 3.  This augmentation isn't "AlwaysActive"

	btnActivate.EnableWindow((selectedAug != None) && (player.Energy > 0) && (!selectedAug.IsAlwaysActive()));

	if ( selectedAug != None )
	{
		if ( selectedAug.bIsActive )
			btnActivate.SetButtonText(DeactivateButtonLabel);
		else
			btnActivate.SetButtonText(ActivateButtonLabel);
	}

	// Use Cell button
	//
	// Only active if the player has one or more Energy Cells and 
	// BioElectricEnergy < 100%

	btnUseCell.EnableWindow(
		(player.Energy < player.EnergyMax) && 
		(player.FindInventoryType(Class'BioelectricCell') != None));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     AugLocs(0)=(X=56,Y=38)
     AugLocs(1)=(X=211,Y=38)
     AugLocs(2)=(X=246,Y=120)
     AugLocs(3)=(X=18,Y=114)
     AugLocs(4)=(X=246,Y=322)
     AugLocs(5)=(X=18,Y=198)
     AugLocs(6)=(X=18,Y=341)
     augHighlightTextures(0)=Texture'DeusExUI.UserInterface.AugmentationsLocationCerebral'
     augHighlightTextures(1)=Texture'DeusExUI.UserInterface.AugmentationsLocationEyes'
     augHighlightTextures(2)=Texture'DeusExUI.UserInterface.AugmentationsLocationTorso'
     augHighlightTextures(3)=Texture'DeusExUI.UserInterface.AugmentationsLocationArms'
     augHighlightTextures(4)=Texture'DeusExUI.UserInterface.AugmentationsLocationLegs'
     augHighlightTextures(5)=Texture'DeusExUI.UserInterface.AugmentationsLocationSubdermal'
     augSlotSpacingX=53
     augSlotSpacingY=59
     AugmentationsTitleText="Augmentations"
     UpgradeButtonLabel="|&Upgrade"
     ActivateButtonLabel="Acti|&vate"
     DeactivateButtonLabel="Deac|&tivate"
     UseCellButtonLabel="Us|&e Cell"
     AugCanUseText="To upgrade an Augmentation, click on the Augmentation you wish to upgrade, then on the Upgrade button."
     BioCellUseText="To replenish Bioelectric Energy for your Augmentations, click on the Use Cell button."
     AugLocationDefault="Default"
     AugLocationCranial="Cranial"
     AugLocationEyes="Eyes"
     AugLocationArms="Arms"
     AugLocationLegs="Legs"
     AugLocationTorso="Torso"
     AugLocationSubdermal="Subdermal"
     clientBorderOffsetY=32
     ClientWidth=596
     ClientHeight=427
     clientOffsetX=25
     clientOffsetY=5
     clientTextures(0)=Texture'DeusExUI.UserInterface.AugmentationsBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.AugmentationsBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.AugmentationsBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.AugmentationsBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.AugmentationsBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.AugmentationsBackground_6'
     clientBorderTextures(0)=Texture'DeusExUI.UserInterface.AugmentationsBorder_1'
     clientBorderTextures(1)=Texture'DeusExUI.UserInterface.AugmentationsBorder_2'
     clientBorderTextures(2)=Texture'DeusExUI.UserInterface.AugmentationsBorder_3'
     clientBorderTextures(3)=Texture'DeusExUI.UserInterface.AugmentationsBorder_4'
     clientBorderTextures(4)=Texture'DeusExUI.UserInterface.AugmentationsBorder_5'
     clientBorderTextures(5)=Texture'DeusExUI.UserInterface.AugmentationsBorder_6'
     clientTextureRows=2
     clientTextureCols=3
     clientBorderTextureRows=2
     clientBorderTextureCols=3
}
