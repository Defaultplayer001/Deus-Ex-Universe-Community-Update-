//=============================================================================
// PersonaScreenInventory
//=============================================================================

class PersonaScreenInventory extends PersonaScreenBaseWindow;

var PersonaActionButtonWindow btnEquip;
var PersonaActionButtonWindow btnUse;
var PersonaActionButtonWindow btnDrop;
var PersonaActionButtonWindow btnChangeAmmo;

var Window                        winItems;
var PersonaInventoryInfoWindow    winInfo;
var PersonaItemButton             selectedItem;			// Currently Selected Inventory item
var PersonaInventoryCreditsWindow winCredits;
var PersonaItemDetailWindow       winNanoKeyRing;
var PersonaItemDetailWindow       winAmmo;

var Bool bUpdatingAmmoDisplay;
var float TimeSinceLastUpdate;

// Inventory object belt
var PersonaInventoryObjectBelt invBelt;
var HUDObjectSlot		       selectedSlot;

var	int invButtonWidth;
var int	invButtonHeight;

var int	smallInvWidth;									// Small Inventory Button Width
var int	smallInvHeight;									// Small Inventory Button Heigth

// Drag and Drop Stuff
var Bool         bDragging;
var ButtonWindow dragButton;							// Button we're dragging around
var ButtonWindow lastDragOverButton;
var Window       lastDragOverWindow;
var Window       destroyWindow;							// Used to defer window destroy

var localized String InventoryTitleText;
var localized String EquipButtonLabel;
var localized String UnequipButtonLabel;
var localized String UseButtonLabel;
var localized String DropButtonLabel;
var localized String ChangeAmmoButtonLabel;
var localized String NanoKeyRingInfoText;
var localized String NanoKeyRingLabel;
var localized String DroppedLabel;
var localized String AmmoLoadedLabel;
var localized String WeaponUpgradedLabel;
var localized String CannotBeDroppedLabel;
var localized String AmmoInfoText;
var localized String AmmoTitleLabel;
var localized String NoAmmoLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	PersonaNavBarWindow(winNavBar).btnInventory.SetSensitivity(False);

	EnableButtons();
    //Force an update
    SignalRefresh();

}

// ---------------------------------------------------------------------
// Tick()
//
// Used to destroy windows that need to be destroyed during 
// MouseButtonReleased calls, which normally causes a CRASH
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	if (destroyWindow != None)
	{
		destroyWindow.Destroy();
		bTickEnabled = False;
	}
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	CreateTitleWindow(9, 5, InventoryTitleText);
	CreateInfoWindow();
	CreateCreditsWindow();
	CreateObjectBelt();
	CreateButtons();
	CreateItemsWindow();
	CreateNanoKeyRingWindow();
	CreateAmmoWindow();
	CreateInventoryButtons();
	CreateStatusWindow();
}

// ----------------------------------------------------------------------
// CreateStatusWindow()
// ----------------------------------------------------------------------

function CreateStatusWindow()
{
	winStatus = PersonaStatusLineWindow(winClient.NewChild(Class'PersonaStatusLineWindow'));
	winStatus.SetPos(337, 243);
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	local PersonaButtonBarWindow winActionButtons;

	winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(9, 339);
	winActionButtons.SetWidth(267);

	btnChangeAmmo = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnChangeAmmo.SetButtonText(ChangeAmmoButtonLabel);

	btnDrop = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnDrop.SetButtonText(DropButtonLabel);

	btnUse = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnUse.SetButtonText(UseButtonLabel);

	btnEquip = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnEquip.SetButtonText(EquipButtonLabel);
}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
	winInfo = PersonaInventoryInfoWindow(winClient.NewChild(Class'PersonaInventoryInfoWindow'));
	winInfo.SetPos(337, 17);
	winInfo.SetSize(238, 218);
}

// ----------------------------------------------------------------------
// CreateObjectBelt()
// ----------------------------------------------------------------------

function CreateObjectBelt()
{
	invBelt = PersonaInventoryObjectBelt(NewChild(Class'PersonaInventoryObjectBelt'));
	invBelt.SetWindowAlignments(HALIGN_Right, VALIGN_Bottom, 0, 0);
	invBelt.SetInventoryWindow(Self);
//	invBelt.AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// CreateCreditsWindow()
// ----------------------------------------------------------------------

function CreateCreditsWindow()
{
	winCredits = PersonaInventoryCreditsWindow(winClient.NewChild(Class'PersonaInventoryCreditsWindow'));
	winCredits.SetPos(165, 3);
	winCredits.SetWidth(108);
	winCredits.SetCredits(Player.Credits);
}

// ----------------------------------------------------------------------
// CreateNanoKeyRingWindow()
// ----------------------------------------------------------------------

function CreateNanoKeyRingWindow()
{
	winNanoKeyRing = PersonaItemDetailWindow(winClient.NewChild(Class'PersonaItemDetailWindow'));
	winNanoKeyRing.SetPos(335, 285);
	winNanoKeyRing.SetWidth(121);
	winNanoKeyRing.SetIcon(Class'NanoKeyRing'.Default.LargeIcon);
	winNanoKeyRing.SetItem(player.KeyRing);
	winNanoKeyRing.SetText(NanoKeyRingInfoText);
	winNanoKeyRing.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winNanoKeyRing.SetCountLabel(NanoKeyRingLabel);
	winNanoKeyRing.SetCount(player.KeyRing.GetKeyCount());
	winNanoKeyRing.SetIconSensitivity(True);
}

// ----------------------------------------------------------------------
// CreateAmmoWindow()
// ----------------------------------------------------------------------

function CreateAmmoWindow()
{
	winAmmo = PersonaItemDetailWindow(winClient.NewChild(Class'PersonaItemDetailWindow'));
	winAmmo.SetPos(456, 285);
	winAmmo.SetWidth(120);
	winAmmo.SetIcon(Class'AmmoShell'.Default.LargeIcon);
	winAmmo.SetIconSize(Class'AmmoShell'.Default.largeIconWidth, Class'AmmoShell'.Default.largeIconHeight);
	winAmmo.SetText(AmmoInfoText);
	winAmmo.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winAmmo.SetIgnoreCount(True);
	winAmmo.SetIconSensitivity(True);
}

// ----------------------------------------------------------------------
// CreateItemsWindow()
// ----------------------------------------------------------------------

function CreateItemsWindow()
{
	winItems = winClient.NewChild(Class'Window');
	winItems.SetPos(9, 19);
	winItems.SetSize(266, 319);
}

// ----------------------------------------------------------------------
// CreateInventoryButtons()
//
// Loop through all the Inventory items and draw them in our Inventory 
// grid as buttons
//
// As we're doing this, we're going to regenerate the inventory grid
// stored in the player, since it sometimes (very rarely) gets corrupted
// and this is a nice hack to make sure it stays clean should that
// occur.  Ooooooooooo did I say "nice hack"?
// ----------------------------------------------------------------------

function CreateInventoryButtons()
{
	local Inventory anItem;
	local PersonaInventoryItemButton newButton;

	// First, clear the player's inventory grid.
    // DEUS_EX AMSD Due to not being able to guarantee order of delivery for functions,
    // do NOT clear inventory in multiplayer, else we risk clearing AFTER a lot of the sets
    // below.
    if (player.Level.NetMode == NM_Standalone)	
        player.ClearInventorySlots();

	// Iterate through the inventory items, creating a unique button for each
	anItem = player.Inventory;

	while(anItem != None)
	{
		if (anItem.bDisplayableInv)
		{
			// Create another button
			newButton = PersonaInventoryItemButton(winItems.NewChild(Class'PersonaInventoryItemButton'));
			newButton.SetClientObject(anItem);
			newButton.SetInventoryWindow(Self);

			// If the item has a large icon, use it.  Otherwise just use the 
			// smaller icon that's also shared by the object belt 

			if ( anItem.largeIcon != None )
			{
				newButton.SetIcon(anItem.largeIcon);
				newButton.SetIconSize(anItem.largeIconWidth, anItem.largeIconHeight);
			}
			else
			{
				newButton.SetIcon(anItem.icon);
				newButton.SetIconSize(smallInvWidth, smallInvHeight);
			}

			newButton.SetSize(
				(invButtonWidth  * anItem.invSlotsX) + 1, 
				(invButtonHeight * anItem.invSlotsY) + 1);

			// Okeydokey, update the player's inventory grid with this item.
			player.SetInvSlots(anItem, 1);

			// If this item is currently equipped, notify the button
			if ( anItem == player.inHand )
				newButton.SetEquipped( True );

			// If this inventory item already has a position, use it.
			if (( anItem.invPosX != -1 ) && ( anItem.invPosY != -1 ))
			{
				SetItemButtonPos(newButton, anItem.invPosX, anItem.invPosY);
			}
			else
			{
				// Find a place for it.
				if (player.FindInventorySlot(anItem))
					SetItemButtonPos(newButton, anItem.invPosX, anItem.invPosY);
				else
					newButton.Destroy();		// Shit!
			}
		}

		anItem = anItem.Inventory;
	}	
}

// ----------------------------------------------------------------------
// SetItemButtonPos()
// ----------------------------------------------------------------------

function SetItemButtonPos(PersonaInventoryItemButton moveButton, int slotX, int slotY)
{
	moveButton.dragPosX = slotX;
	moveButton.dragPosY = slotY;

	moveButton.SetPos(
		moveButton.dragPosX * (invButtonWidth), 
		moveButton.dragPosY * (invButtonHeight)
		);
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;
	local Class<DeusExAmmo> ammoClass;

	bHandled = True;

	// First check to see if this is an Ammo button
	if (buttonPressed.IsA('PersonaAmmoDetailButton'))
	{
		if (DeusExWeapon(selectedItem.GetClientObject()) != None)
		{
			// Before doing anything, check to see if this button is already
			// selected.

			if (!PersonaAmmoDetailButton(buttonPressed).bSelected)
			{
				winInfo.SelectAmmoButton(PersonaAmmoDetailButton(buttonPressed));
				ammoClass = LoadAmmo();
				DeusExWeapon(selectedItem.GetClientObject()).UpdateAmmoInfo(winInfo, ammoClass);
				EnableButtons();
			}
		}
	}
	// Check to see if this is the Ammo button
	else if ((buttonPressed.IsA('PersonaItemDetailButton')) && 
	         (PersonaItemDetailButton(buttonPressed).icon == Class'AmmoShell'.Default.LargeIcon))
	{
		SelectInventory(PersonaItemButton(buttonPressed));
		UpdateAmmoDisplay();
	}
	// Now check to see if it's an Inventory button
	else if (buttonPressed.IsA('PersonaItemButton'))
	{
		winStatus.ClearText();
		SelectInventory(PersonaItemButton(buttonPressed));
	}
	// Otherwise must be one of our action buttons
	else
	{
		switch( buttonPressed )
		{
			case btnChangeAmmo:
				WeaponChangeAmmo();
				break;

			case btnEquip:
				EquipSelectedItem();
				break;

			case btnUse:
				UseSelectedItem();
				break;

			case btnDrop:
				DropSelectedItem();
				break;

			default:
				bHandled = False;
				break;
		}
	}

	if ( !bHandled )
		bHandled = Super.ButtonActivated(buttonPressed);

	return bHandled;
}

// ----------------------------------------------------------------------
// ToggleChanged()
// ----------------------------------------------------------------------

event bool ToggleChanged(Window button, bool bNewToggle)
{
	if (button.IsA('HUDObjectSlot') && (bNewToggle))
	{
		if ((selectedSlot != None) && (selectedSlot != HUDObjectSlot(button)))
			selectedSlot.HighlightSelect(False);

		selectedSlot = HUDObjectSlot(button);

		// Only allow to be highlighted if the slot isn't empty
		if (selectedSlot.item != None)
		{
			selectedSlot.HighlightSelect(bNewToggle);
			SelectInventoryItem(selectedSlot.item);
		}
		else
		{
			selectedSlot = None;
		}
	}
	else if (button.IsA('PersonaCheckboxWindow'))
	{
		player.bShowAmmoDescriptions = bNewToggle;
		player.SaveConfig();
		UpdateAmmoDisplay();
	}

	EnableButtons();

	return True;
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local int keyIndex;
	local bool bKeyHandled;

	bKeyHandled = True;

	if ( IsKeyDown( IK_Alt ) || IsKeyDown( IK_Shift ) || IsKeyDown( IK_Ctrl ))
		return False;

	// If a number key was pressed and we have a selected inventory item,
	// then assign the hotkey
	if (( key >= IK_1 ) && ( key <= IK_9 ) && (selectedItem != None) && (Inventory(selectedItem.GetClientObject()) != None))
	{
		invBelt.AssignObjectBeltByKey(Inventory(selectedItem.GetClientObject()), key);
	}
	else
	{
		switch( key ) 
		{	
			// Allow a selected object to be dropped
			// TODO: Use the actual key(s) assigned to drop

			case IK_Backspace:
				DropSelectedItem();
				break;

			case IK_Delete:
				ClearSelectedSlot();
				break;

			case IK_Enter:
				UseSelectedItem();
				break;

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
// UpdateAmmoDisplay()
//
// Displays a list of ammo inside the info window (when the user clicks
// on the Ammo button)
// ----------------------------------------------------------------------

function UpdateAmmoDisplay()
{
	local Inventory inv;
	local DeusExAmmo ammo;
	local int ammoCount;

	if (!bUpdatingAmmoDisplay)
	{
		bUpdatingAmmoDisplay = True;

		winInfo.Clear();

		winInfo.SetTitle(AmmoTitleLabel);
		winInfo.AddAmmoCheckbox(player.bShowAmmoDescriptions);
		winInfo.AddLine();
		
		inv = Player.Inventory;
		while(inv != None)
		{
			ammo = DeusExAmmo(inv);

			if ((ammo != None) && (ammo.bShowInfo))
			{
				winInfo.AddAmmoInfoWindow(ammo, player.bShowAmmoDescriptions);
				ammoCount++;	
			}

			inv = inv.Inventory;
		}

		if (ammoCount == 0)
		{
			winInfo.Clear();
			winInfo.SetTitle(AmmoTitleLabel);
			winInfo.SetText(NoAmmoLabel);
		}

		bUpdatingAmmoDisplay = False;
	}
}

// ----------------------------------------------------------------------
// SelectInventory()
// ----------------------------------------------------------------------

function SelectInventory(PersonaItemButton buttonPressed)
{
	local Inventory anItem;

	// Don't do extra work.
	if (buttonPressed != None) 
	{
		if (selectedItem != buttonPressed)
		{
			// Deselect current button
			if (selectedItem != None)
				selectedItem.SelectButton(False);

			selectedItem = buttonPressed;

			ClearSpecialHighlights();
			HighlightSpecial(Inventory(selectedItem.GetClientObject()));
			SelectObjectBeltItem(Inventory(selectedItem.GetClientObject()), True);

			selectedItem.SelectButton(True);

			anItem = Inventory(selectedItem.GetClientObject());

			if (anItem != None)
				anItem.UpdateInfo(winInfo);

			EnableButtons();
		}
	}
	else
	{
		if (selectedItem != None)
			PersonaInventoryItemButton(selectedItem).SelectButton(False);

		if (selectedSlot != None)
			selectedSlot.SetToggle(False);

		selectedItem = None;
	}
}

// ----------------------------------------------------------------------
// SelectInventoryItem()
//
// Searches through the inventory items for the item passed in and
// selects it.
// ----------------------------------------------------------------------

function SelectInventoryItem(Inventory item)
{
	local PersonaInventoryItemButton itemButton;
	local Window itemWindow;

	// Special case for NanoKeyRing
	if (item != None)
	{
		if (item.IsA('NanoKeyRing')) 
		{   
			if (winNanoKeyRing != None)
			{
				SelectInventory(winNanoKeyRing.GetItemButton());
			}
		}
		else if (winItems != None)
		{
			// Search through the buttons
			itemWindow = winItems.GetTopChild();
			while(itemWindow != None)
			{
				itemButton = PersonaInventoryItemButton(itemWindow);
				if (itemButton != None)
				{
					if (itemButton.GetClientObject() == item)
					{
						SelectInventory(itemButton);
						break;
					}
				}

				itemWindow = itemWindow.GetLowerSibling();
			}
		}
	}
}

// ----------------------------------------------------------------------
// RefreshInventoryItemButtons()
//
// Refreshes all inventory item buttons.
// ----------------------------------------------------------------------
 
function RefreshInventoryItemButtons()
{
    local Window itemWindow;
    local PersonaInventoryItemButton itemButton;
    local Inventory SelectedInventory;

    if (winItems == None)
        return;

    //record selected item
    if (selectedItem != None)
        SelectedInventory = Inventory(selectedItem.GetClientObject());
    else
        SelectedInventory = None;

    //Delete buttons
    itemWindow = winItems.GetTopChild();

    selecteditem = None;
    while (itemWindow != None)
    {
        itemButton = PersonaInventoryItemButton(itemWindow);
        itemWindow = itemWindow.GetLowerSibling();
        if (itemButton != None)
        {          
            itemButton.Destroy();
        }
    }

    //Create buttons
    CreateInventoryButtons();

    //Select new button version of selected item.
    //We don't use the selectinventoryitem call because the constant
    //item.update(wininfo) calls cause quite a slowdown when any item
    //is selected.  Since we aren't really selecting a different item,
    //we don't need to do that update.
	if (SelectedInventory != None)
	{
        // Search through the buttons
        itemWindow = winItems.GetTopChild();
        while(itemWindow != None)
        {
            itemButton = PersonaInventoryItemButton(itemWindow);
            if (itemButton != None)
            {
                if (itemButton.GetClientObject() == SelectedInventory)
                {
                    selecteditem = itemButton;
                    selectedItem.SelectButton(True);
                    break;
                }
            }
            
            itemWindow = itemWindow.GetLowerSibling();
        }
	}

   // if this does special highlighting, refresh that.
   if (SelectedInventory != None)			   
      HighlightSpecial(SelectedInventory);
}

// ----------------------------------------------------------------------
// SelectObjectBeltItem()
// ----------------------------------------------------------------------

function SelectObjectBeltItem(Inventory item, bool bNewToggle)
{
	invBelt.SelectObject(item, bNewToggle);
}

// ----------------------------------------------------------------------
// UseSelectedItem()
// ----------------------------------------------------------------------

function UseSelectedItem()
{
	local Inventory inv;
	local int numCopies;

	inv = Inventory(selectedItem.GetClientObject());

	if (inv != None)
	{
		// If this item was equipped in the inventory screen, 
		// make sure we set inHandPending to None so it's not
		// drawn when we exit the Inventory screen

		if (player.inHandPending == inv)
			player.SetInHandPending(None);

		// If this is a binoculars, then it needs to be equipped
		// before it can be activated
		if (inv.IsA('Binoculars')) 
			player.PutInHand(inv);

		inv.Activate();

		// Check to see if this is a stackable item, and keep track of 
		// the count
		if ((inv.IsA('DeusExPickup')) && (DeusExPickup(inv).bCanHaveMultipleCopies))
			numCopies = DeusExPickup(inv).NumCopies - 1;
		else
			numCopies = 0;

		// Update the object belt
		invBelt.UpdateBeltText(inv);

		// Refresh the info!
		if (numCopies > 0)
			UpdateWinInfo(inv);
	}
}

// ----------------------------------------------------------------------
// DropSelectedItem()
// ----------------------------------------------------------------------

function DropSelectedItem()
{
	local Inventory anItem;
	local int numCopies;

	if (selectedItem == None)
		return;

	if (Inventory(selectedItem.GetClientObject()) != None)
	{
		// Now drop it, unless this is the NanoKeyRing
		if (!Inventory(selectedItem.GetClientObject()).IsA('NanoKeyRing'))
		{
			anItem = Inventory(selectedItem.GetClientObject());

			// If this is a DeusExPickup, keep track of the number of copies
			if (anItem.IsA('DeusExPickup'))
				numCopies = DeusExPickup(anItem).NumCopies;

			// First make sure the player can drop it!
			if (player.DropItem(anItem, True))
			{
				// Make damn sure there's nothing pending
            if ((player.inHandPending == anItem) || (player.inHand == anItem))
				   player.SetInHandPending(None);

				// Remove the item, but first check to see if it was stackable
				// and there are more than 1 copies available

				if ( (!anItem.IsA('DeusExPickup')) || 
					 (anItem.IsA('DeusExPickup') && (numCopies <= 1)))
				{
					RemoveSelectedItem();
				}

				// Send status message
				winStatus.AddText(Sprintf(DroppedLabel, anItem.itemName));

				// Update the object belt
				invBelt.UpdateBeltText(anItem);

                //Force an update
                SignalRefresh();
			}
			else
			{
                //DEUS_EX AMSD Don't do this in multiplayer, because the way function repl
                //works, we'll ALWAYS end up here.
                if (player.Level.NetMode == NM_Standalone)				
                    winStatus.AddText(Sprintf(CannotBeDroppedLabel, anItem.itemName));
			}
		}
	}
}

// ----------------------------------------------------------------------
// RemoveSelectedItem()
// ----------------------------------------------------------------------

function RemoveSelectedItem()
{
	local Inventory inv;

	if (selectedItem == None)
		return;

	inv = Inventory(selectedItem.GetClientObject());

	if (inv != None)
	{
		// Destroy the button
		selectedItem.Destroy();
		selectedItem = None;

		// Remove it from the object belt
		invBelt.RemoveObject(inv);

		// Remove it from the inventory screen
		UnequipItemInHand();

		ClearSpecialHighlights();

		SelectInventory(None);

		winInfo.Clear();
		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// WeaponChangeAmmo()
// ----------------------------------------------------------------------

function WeaponChangeAmmo()
{
	local DeusExWeapon aWeapon;

	aWeapon = DeusExWeapon(selectedItem.GetClientObject());

	if ( aWeapon != None )
	{
		aWeapon.CycleAmmo();	

		// Send status message and update info window
		winStatus.AddText(Sprintf(AmmoLoadedLabel, aWeapon.ammoType.itemName));
		aWeapon.UpdateAmmoInfo(winInfo, Class<DeusExAmmo>(aWeapon.AmmoName));
		winInfo.SetLoaded(aWeapon.AmmoName);

		// Update the object belt
		invBelt.UpdateBeltText(aWeapon);
	}
}

// ----------------------------------------------------------------------
// LoadAmmo()
// ----------------------------------------------------------------------

function Class<DeusExAmmo> LoadAmmo()
{
	local DeusExWeapon aWeapon;
	local Class<DeusExAmmo> ammo;

	aWeapon = DeusExWeapon(selectedItem.GetClientObject());

	if ( aWeapon != None )
	{	
		ammo = Class<DeusExAmmo>(winInfo.GetSelectedAmmo());

		// Only change if this is a different kind of ammo

		if ((ammo != None) && (ammo != aWeapon.AmmoName))
		{
			aWeapon.LoadAmmoClass(ammo);
			
			// Send status message
			winStatus.AddText(Sprintf(AmmoLoadedLabel, ammo.Default.itemName));

			// Update the object belt
			invBelt.UpdateBeltText(aWeapon);
		}
	}

	return ammo;
}

// ----------------------------------------------------------------------
// EquipSelectedItem()
// ----------------------------------------------------------------------

function EquipSelectedItem()
{
	local Inventory inv;

	// If the object's in-hand, then unequip
	// it.  Otherwise put this object in-hand.

	inv = Inventory(selectedItem.GetClientObject());
	
	if ( inv != None )
	{
		// Make sure the Binoculars aren't activated.
		if ((player.inHand != None) && (player.inHand.IsA('Binoculars')))
			Binoculars(player.inHand).Activate();
		else if ((player.inHandPending != None) && (player.inHandPending.IsA('Binoculars')))
			Binoculars(player.inHandPending).Activate();

		if ((inv == player.inHand) || (inv == player.inHandPending))
		{
			UnequipItemInHand();
		}
		else
		{
			player.PutInHand(inv);
			PersonaInventoryItemButton(selectedItem).SetEquipped(True);
		}

		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// UnequipItemInHand()
// ----------------------------------------------------------------------

function UnequipItemInHand()
{
	if ((PersonaInventoryItemButton(selectedItem) != None) && ((player.inHand != None) || (player.inHandPending != None)))
	{
		player.PutInHand(None);
		player.SetInHandPending(None);

		PersonaInventoryItemButton(selectedItem).SetEquipped(False);
		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// UpdateWinInfo()
// ----------------------------------------------------------------------

function UpdateWinInfo(Inventory inv)
{
	winInfo.Clear();

	if (inv != None)
	{
		winInfo.SetTitle(inv.ItemName);
		winInfo.SetText(inv.Description);
	}
}

// ----------------------------------------------------------------------
// RefreshWindow()
// ----------------------------------------------------------------------

function RefreshWindow(float DeltaTime)
{
    TimeSinceLastUpdate = TimeSinceLastUpdate + DeltaTime;
    if (TimeSinceLastUpdate >= 0.25)
    {
        TimeSinceLastUpdate = 0;
        if (!bDragging)
        {
            RefreshInventoryItemButtons();
            CleanBelt();
        }
    }


    Super.RefreshWindow(DeltaTime);
}
// ----------------------------------------------------------------------
// SignalRefresh()
// ----------------------------------------------------------------------

function SignalRefresh()
{
    //Put it about a quarter of a second back from an update, so that 
    //server has time to propagate.
    TimeSinceLastUpdate = 0;
}

// ----------------------------------------------------------------------
// CleanBelt()
// ----------------------------------------------------------------------

function CleanBelt()
{
    local Inventory CurrentItem;

    invBelt.hudBelt.ClearBelt();
    invBelt.objBelt.ClearBelt();
    invBelt.objBelt.PopulateBelt();
    if (selectedItem != None)    
        SelectObjectBeltItem(Inventory(selectedItem.GetClientObject()), True);
}


// ----------------------------------------------------------------------
// RemoveItem()
//
// Removes this item from the screen.  If this is the selected item, 
// does some additional processing.
// ----------------------------------------------------------------------

function RemoveItem(Inventory item)
{
	local Window itemWindow;

	if (item == None)
		return;

	// Remove it from the object belt
	invBelt.RemoveObject(item);

	if ((selectedItem != None) && (item == selectedItem.GetClientObject()))
	{
		RemoveSelectedItem();
	}
	else
	{	
		// Loop through the PersonaInventoryItemButtons looking for a match
		itemWindow = winItems.GetTopChild();
		while( itemWindow != None )
		{
			if (itemWindow.GetClientObject() == item)
			{
				DeferDestroy(itemWindow);
//				itemWindow.Destroy();
				break;
			}
			
			itemWindow = itemWindow.GetLowerSibling();
		}
	}
}

// ----------------------------------------------------------------------
// DeferDestroy()
// ----------------------------------------------------------------------

function DeferDestroy(Window newDestroyWindow)
{
	destroyWindow = newDestroyWindow;

	if (destroyWindow != None)
		bTickEnabled = True;
}

// ----------------------------------------------------------------------
// InventoryDeleted()
//
// Called when some external force needs to remove an inventory 
// item from the player. For instance, when an item is "used" and it's
// a single-use item, it destroys itself, which will ultimately 
// result in this ItemDeleted() call.
// ----------------------------------------------------------------------

function InventoryDeleted(Inventory item)
{
	if (item != None)
	{
		// Remove the item from the screen
		RemoveItem(item);
	}
}

// ----------------------------------------------------------------------
// ClearSelectedSlot()
// ----------------------------------------------------------------------

function ClearSelectedSlot()
{
	if (selectedSlot == None)
		return;

	// Make sure this isn't the NanoKeyRing
	if ((selectedSlot.item != None) && (!selectedSlot.item.IsA('NanoKeyRing')))
	{
		selectedSlot.SetToggle(False);
		ClearSlotItem(selectedSlot.item);
		selectedSlot = None;

		winInfo.Clear();
		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// ClearSlotItem()
// ----------------------------------------------------------------------

function ClearSlotItem(Inventory item)
{
	invBelt.RemoveObject(item);
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	local Inventory inv;

	// Make sure all the buttons exist!
	if ((btnChangeAmmo == None) || (btnDrop == None) || (btnEquip == None) || (btnUse == None))
		return;

	if ( selectedItem == None )
	{
		btnChangeAmmo.DisableWindow();
		btnDrop.DisableWindow();
		btnEquip.DisableWindow();
		btnUse.DisableWindow();
	}
	else
	{
		btnChangeAmmo.EnableWindow();
		btnEquip.EnableWindow();
		btnUse.EnableWindow();
		btnDrop.EnableWindow();

		inv = Inventory(selectedItem.GetClientObject());

		if (inv != None)
		{
			// Anything can be dropped, except the NanoKeyRing
			btnDrop.EnableWindow();

			if (inv.IsA('WeaponMod'))
			{
				btnChangeAmmo.DisableWindow();
				btnUse.DisableWindow();		
			}
			else if (inv.IsA('NanoKeyRing'))
			{
				btnChangeAmmo.DisableWindow();
				btnDrop.DisableWindow();
				btnEquip.DisableWindow();
				btnUse.DisableWindow();
			}
			// Augmentation Upgrade Cannisters cannot be used
			// on this screen
			else if ( inv.IsA('AugmentationUpgradeCannister') )
			{
				btnUse.DisableWindow();
				btnChangeAmmo.DisableWindow();
			}
			// Ammo can't be used or equipped
			else if ( inv.IsA('Ammo') )
			{
				btnUse.DisableWindow();
				btnEquip.DisableWindow();
			}
			else 
			{
				if ((inv == player.inHand ) || (inv == player.inHandPending))
					btnEquip.SetButtonText(UnequipButtonLabel);
				else
					btnEquip.SetButtonText(EquipButtonLabel);
			}

			// If this is a weapon, check to see if this item has more than 
			// one type of ammo in the player's inventory that can be
			// equipped.  If so, enable the "AMMO" button.
			if ( inv.IsA('DeusExWeapon') )
			{
				btnUse.DisableWindow();

				if ( DeusExWeapon(inv).NumAmmoTypesAvailable() < 2 )
					btnChangeAmmo.DisableWindow();
			}
			else
			{
				btnChangeAmmo.DisableWindow();
			}
		}
		else
		{
			btnChangeAmmo.DisableWindow();
			btnDrop.DisableWindow();
			btnEquip.DisableWindow();
			btnUse.DisableWindow();
		}
	}
}

// ----------------------------------------------------------------------
// UpdateDragMouse()
// ----------------------------------------------------------------------

function UpdateDragMouse(float newX, float newY)
{
	local Window findWin;
	local Float relX, relY;
	local Int slotX, slotY;
	local PersonaInventoryItemButton invButton;
	local HUDObjectSlot objSlot;
	local Bool bValidDrop;
	local Bool bOverrideButtonColor;

	findWin = FindWindow(newX, newY, relX, relY);

	// If we're dragging an inventory button, behave one way, if we're
	// dragging a hotkey button, behave another

	if (dragButton.IsA('PersonaInventoryItemButton'))
	{
		invButton = PersonaInventoryItemButton(dragButton);

		// If we're over the Inventory Items window, check to see 
		// if there's enough space to deposit this item here.

		bValidDrop = False;
		bOverrideButtonColor = False;

		if ((findWin == winItems) || (findWin == dragButton ))
		{
			if ( findWin == dragButton )
				ConvertCoordinates(Self, newX, newY, winItems, relX, relY);

			bValidDrop = CalculateItemPosition(
				Inventory(dragButton.GetClientObject()), 
				relX, relY, 
				slotX, slotY);

			// If the mouse is still in the window, don't actually hide the 
			// button just yet.

			if (bValidDrop && (player.IsEmptyItemSlot(Inventory(invButton.GetClientObject()), slotX, slotY)))
				SetItemButtonPos(invButton, slotX, slotY);
		}

		// Check to see if we're over the Object Belt
		else if (HUDObjectSlot(findWin) != None)
		{
			bValidDrop = True;

			if (HUDObjectSlot(findWin).item != None)
				if (HUDObjectSlot(findWin).item.IsA('NanoKeyRing'))
					bValidDrop = False;

			HUDObjectSlot(findWin).SetDropFill(bValidDrop);
		}

		// Check to see if we're over another inventory item
		else if (PersonaInventoryItemButton(findWin) != None)
		{
			// If we're dragging a weapon mod and we're over a weapon, check to 
			// see if the mod can be dropped here.  
			//
			// Otherwise this is a bad drop location

			PersonaInventoryItemButton(findWin).SetDropFill(False);

			// Check for weapon mods being dragged over weapons
			if ((dragButton.GetClientObject().IsA('WeaponMod')) && (findWin.GetClientObject().IsA('DeusExWeapon')))
			{
				if (WeaponMod(invButton.GetClientObject()).CanUpgradeWeapon(DeusExWeapon(findWin.GetClientObject())))
				{
					bValidDrop = True;
					PersonaInventoryItemButton(findWin).SetDropFill(True);
					invButton.bValidSlot = False;
					invButton.bDimIcon   = False;
					bOverrideButtonColor = True;

					invButton.ResetFill();
				}
			}

			// Check for ammo being dragged over weapons
			else if ((dragButton.GetClientObject().IsA('DeusExAmmo')) && (findWin.GetClientObject().IsA('DeusExWeapon')))
			{
				if (DeusExWeapon(findWin.GetClientObject()).CanLoadAmmoType(DeusExAmmo(dragButton.GetClientObject())))
				{
					bValidDrop = True;
					PersonaInventoryItemButton(findWin).SetDropFill(True);
					invButton.bValidSlot = False;
					invButton.bDimIcon   = False;
					bOverrideButtonColor = True;

					invButton.ResetFill();
				}
			}
		}

		if (!bOverrideButtonColor)
		{
			invButton.SetDropFill(bValidDrop);
			invButton.bDimIcon = !bValidDrop;

			if (HUDObjectSlot(findWin) != None)
				invButton.bValidSlot = False;
			else
				invButton.bValidSlot = bValidDrop;
		}
	}
	else
	{
		// This is an Object Belt item we're dragging

		objSlot = HUDObjectSlot(dragButton);
		bValidDrop = False;

		// Can only be dragged over another object slot
		if (findWin.IsA('HUDObjectSlot'))
		{
			if (HUDObjectSlot(findWin).item != None) 
			{
				if (!HUDObjectSlot(findWin).item.IsA('NanoKeyRing'))
				{
					bValidDrop = True;
				}
			}
			else
			{
				bValidDrop = True;
			}

			HUDObjectSlot(findWin).SetDropFill(bValidDrop);
		}
		
		objSlot.bDimIcon = !bValidDrop;
	}

	// Unhighlight the previous window we were over	
	if ((lastDragOverButton != None) && (lastDragOverButton != findWin))
	{
		if (lastDragOverButton.IsA('HUDObjectSlot'))
		{
			HUDObjectSlot(lastDragOverButton).ResetFill();
		}
		else if (lastDragOverButton.IsA('PersonaInventoryItemButton'))
		{
			PersonaInventoryItemButton(lastDragOverButton).ResetFill();
		}
	}	
		
	// Keep track of the last button window we were over
	lastDragOverButton = ButtonWindow(findWin);	
	lastDragOverWindow = findWin;
}

// ----------------------------------------------------------------------
// CalculateItemPosition()
//
// Calculates exactly where this item belongs in the window based on 
// the position passed in (relative to "winItems") and the inventory 
// item.  
//
// Returns TRUE if this is a valid drop slot (not out of bounds)
// ----------------------------------------------------------------------

function bool CalculateItemPosition(
	Inventory item, 
	float pointX, 
	float pointY, 
	out int slotX, 
	out int slotY)
{
	local int invWidth;
	local int invHeight;
	local int adjustX;
	local int adjustY;
	local bool bResult;

	bResult = True;

	// First get the width and height of the inventory icon
	invWidth  = item.largeIconWidth;
	invHeight = item.largeIconHeight;

	// Calculate the first square that represents where this object is
	adjustX = 0;
	adjustY = 0;

	if (invWidth > invButtonWidth)
		adjustX = ((invWidth/2) - (invButtonWidth / 2));

	if (invWidth > invButtonwidth)
		adjustY = ((invHeight/2) - (invButtonHeight /2));

	// Check to see if we're outside the range of where the 
	// slots are located.
	if ((pointX - adjustX) > (invButtonWidth  * player.maxInvCols))
	{
		slotX = player.maxInvCols - 1;
		if (slotX < 0)
			slotX = 0;

		bResult = False;
	}
	else
	{
		slotX = (pointX - adjustX) / invButtonWidth;

		if (slotX < 0)
			slotX = 0;
	}

	if ((pointY - adjustY) > (invButtonHeight * player.maxInvRows))
	{
		slotY = player.maxInvRows - 1;
		bResult = False;
	}
	else
	{
		slotY = (pointY - adjustY) / invButtonHeight;
	}

	return bResult;
}

// ----------------------------------------------------------------------
// StartButtonDrag()
// ----------------------------------------------------------------------

function StartButtonDrag(ButtonWindow newDragButton)
{
	// Show the object belt
	dragButton = newDragButton;

	ClearSpecialHighlights();

	if (dragButton.IsA('PersonaInventoryItemButton'))
	{
		SelectInventory(None);

		// Clear the space used by this button in the grid so we can
		// still place the button here. 
		player.SetInvSlots(Inventory(dragButton.GetClientObject()), 0);
	}
	else
	{
		// Make sure no hud icon is selected
		if (selectedSlot != None)
			selectedSlot.SetToggle(False);
	}

    SignalRefresh();
	bDragging  = True;
}

// ----------------------------------------------------------------------
// FinishButtonDrag()
// ----------------------------------------------------------------------

function FinishButtonDrag()
{
	local int beltSlot;
	local Inventory dragInv;
	local PersonaInventoryItemButton dragTarget;
	local HUDObjectSlot itemSlot;

	// Take a look at the last window we were over to determine
	// what to do now.  If we were over the Inventory Items window,
	// then move the item to a new slot.  If we were over the Object belt,
	// then assign this item to the appropriate key

	if (dragButton == None)
	{
		EndDragMode();
		return;
	}

	if (dragButton.IsA('PersonaInventoryItemButton'))
	{	
		dragInv    = Inventory(dragButton.GetClientObject());
		dragTarget = PersonaInventoryItemButton(lastDragOverButton);

		// Check if this is a weapon mod and we landed on a weapon
		if ( (dragInv.IsA('WeaponMod')) && (dragTarget != None) && (dragTarget.GetClientObject().IsA('DeusExWeapon')) )
		{
			if (WeaponMod(dragInv).CanUpgradeWeapon(DeusExWeapon(dragTarget.GetClientObject())))
			{
				// 0.  Unhighlight highlighted weapons
				// 1.  Apply the weapon upgrade
				// 2.  Remove from Object Belt
				// 3.  Destroy the upgrade (will cause button to be destroyed)
				// 4.  Highlight the weapon.

				WeaponMod(dragInv).ApplyMod(DeusExWeapon(dragTarget.GetClientObject()));
				
            Player.RemoveObjectFromBelt(dragInv);
            //invBelt.objBelt.RemoveObjectFromBelt(dragInv);

				// Send status message
				winStatus.AddText(Sprintf(WeaponUpgradedLabel, DeusExWeapon(dragTarget.GetClientObject()).itemName));

            //DEUS_EX AMSD done here for multiplayer propagation.
            WeaponMod(draginv).DestroyMod();
				//player.DeleteInventory(dragInv);

				dragButton = None;
				SelectInventory(dragTarget);
			}
			else
			{
				// move back to original spot
				ReturnButton(PersonaInventoryItemButton(dragButton));
			}
		}

		// Check if this is ammo and we landed on a weapon
		else if ((dragInv.IsA('DeusExAmmo')) && (dragTarget != None) && (dragTarget.GetClientObject().IsA('DeusExWeapon')) )
		{
			if (DeusExWeapon(dragTarget.GetClientObject()).CanLoadAmmoType(DeusExAmmo(dragInv)))
			{
				// Load this ammo into the weapon
				DeusExWeapon(dragTarget.GetClientObject()).LoadAmmoType(DeusExAmmo(dragInv));

				// Send status message
				winStatus.AddText(Sprintf(AmmoLoadedLabel, DeusExAmmo(dragInv).itemName));

				// move back to original spot
				ReturnButton(PersonaInventoryItemButton(dragButton));
			}
		}
		else
		{	
			if (dragTarget == dragButton)
			{
				MoveItemButton(PersonaInventoryItemButton(dragButton), PersonaInventoryItemButton(dragButton).dragPosX, PersonaInventoryItemButton(dragButton).dragPosY );
			}
			else if ( HUDObjectSlot(lastDragOverButton) != None )	
			{
				beltSlot = HUDObjectSlot(lastDragOverButton).objectNum;

				// Don't allow to be moved over NanoKeyRing
				if (beltSlot > 0)
				{
					invBelt.AddObject(dragInv, beltSlot);
				}

				// Restore item to original slot
				ReturnButton(PersonaInventoryItemButton(dragButton));
			}
			else if (lastDragOverButton != dragButton)
			{
				// move back to original spot
				ReturnButton(PersonaInventoryItemButton(dragButton));
			}
		}
	}
	else		// 'ObjectSlot'
	{
		// Check to see if this is a valid drop location (which are only 
		// other object slots).
		//
		// Swap the two items and select the one that was dragged
		// but make sure the target isn't the NanoKeyRing

		itemSlot = HUDObjectSlot(lastDragOverButton);

		if (itemSlot != None) 
		{
			if (((itemSlot.Item != None) && (!itemSlot.Item.IsA('NanoKeyRing'))) || (itemSlot.Item == None))
			{
				invBelt.SwapObjects(HUDObjectSlot(dragButton), itemSlot);
				itemSlot.SetToggle(True);
			}
		}
		else
		{
			// If the player drags the item outside the object belt, 
			// then remove it.

			ClearSlotItem(HUDObjectSlot(dragButton).item);
		}
	}

    EndDragMode();
}

// ----------------------------------------------------------------------
// EndDragMode()
// ----------------------------------------------------------------------

function EndDragMode()
{
	// Make sure the last inventory item dragged over isn't still highlighted
	if (lastDragOverButton != None)
	{
		if (lastDragOverButton.IsA('PersonaInventoryItemButton'))
			PersonaInventoryItemButton(lastDragOverButton).ResetFill();
		else
			HUDObjectSlot(lastDragOverButton).ResetFill();

		lastDragOverButton = None;
	}

	bDragging = False;

	// Select the item
	if (dragButton != None)
	{
		if (dragButton.IsA('PersonaInventoryItemButton'))
			SelectInventory(PersonaInventoryItemButton(dragButton));
		else if (dragButton.IsA('ToggleWindow'))
			ToggleWindow(dragButton).SetToggle(True);

		dragButton = None;
	}
    
    SignalRefresh();
}

// ----------------------------------------------------------------------
// MoveItemButton()
// ----------------------------------------------------------------------

function MoveItemButton(PersonaInventoryItemButton anItemButton, int col, int row)
{
	player.SetInvSlots(Inventory(anItemButton.GetClientObject()), 0);
	player.PlaceItemInSlot(Inventory(anItemButton.GetClientObject()), col, row );
	SetItemButtonPos(anItemButton, col, row);
    //Set it to refresh again
    SignalRefresh();
}

// ----------------------------------------------------------------------
// ReturnButton()
// ----------------------------------------------------------------------

function ReturnButton(PersonaInventoryItemButton anItemButton)
{
	local Inventory inv;

	inv = Inventory(anItemButton.GetClientObject());

	player.PlaceItemInSlot(inv, inv.invPosX, inv.invPosY);
	SetItemButtonPos(anItemButton, inv.invPosX, inv.invPosY);
}

// ----------------------------------------------------------------------
// HighlightSpecial()
// ----------------------------------------------------------------------

function HighlightSpecial(Inventory item)
{
	if (item != None)
	{
		if (item.IsA('WeaponMod'))
			HighlightModWeapons(WeaponMod(item));
		else if (item.IsA('DeusExAmmo'))
			HighlightAmmoWeapons(DeusExAmmo(item));
	}
}

// ----------------------------------------------------------------------
// HighlightModWeapons()
// 
// Highlights/Unhighlights any weapons that can be upgraded with the 
// weapon mod passed in
// ----------------------------------------------------------------------

function HighlightModWeapons(WeaponMod weaponMod)
{
	local Window itemWindow;
	local PersonaInventoryItemButton itemButton;
	local Inventory anItem;

	// Loop through all our children and check to see if 
	// we have a match.

	itemWindow = winItems.GetTopChild();
	while( itemWindow != None )
	{
		itemButton = PersonaInventoryItemButton(itemWindow);
		if (itemButton != None)
		{
			anItem = Inventory(itemButton.GetClientObject());
			if ((anItem != None) && (anItem.IsA('DeusExWeapon')))
			{
				if ((weaponMod != None) && (weaponMod.CanUpgradeWeapon(DeusExWeapon(anItem))))
				{
					itemButton.HighlightWeapon(True);
				}
			}
			else
			{
				itemButton.ResetFill();
			}
		}	
		itemWindow = itemWindow.GetLowerSibling();
	}
}

// ----------------------------------------------------------------------
// HighlightAmmoWeapons()
// 
// Highlights/Unhighlights any weapons that can be used with the 
// selected ammo
// ----------------------------------------------------------------------

function HighlightAmmoWeapons(DeusExAmmo ammo)
{
	local Window itemWindow;
	local PersonaInventoryItemButton itemButton;
	local Inventory anItem;

	// Loop through all our children and check to see if 
	// we have a match.

	itemWindow = winItems.GetTopChild();
	while( itemWindow != None )
	{
		itemButton = PersonaInventoryItemButton(itemWindow);
		if (itemButton != None)
		{
			anItem = Inventory(itemButton.GetClientObject());
			if ((anItem != None) && (anItem.IsA('DeusExWeapon')))
			{
				if ((ammo != None) && (DeusExWeapon(anItem).CanLoadAmmoType(ammo)))
				{
					itemButton.HighlightWeapon(True);
				}
			}
			else
			{
				itemButton.ResetFill();
			}
		}	
		itemWindow = itemWindow.GetLowerSibling();
	}
}

// ----------------------------------------------------------------------
// ClearSpecialHighlights()
// ----------------------------------------------------------------------

function ClearSpecialHighlights()
{
	local Window itemWindow;
	local PersonaInventoryItemButton itemButton;
	local Inventory anItem;

	// Loop through all our children and check to see if 
	// we have a match.

	itemWindow = winItems.GetTopChild();
	while( itemWindow != None )
	{
		itemButton = PersonaInventoryItemButton(itemWindow);
		if (itemButton != None)
		{
			itemButton.ResetFill();
		}

		itemWindow = itemWindow.GetLowerSibling();
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     invButtonWidth=53
     invButtonHeight=53
     smallInvWidth=40
     smallInvHeight=35
     InventoryTitleText="Inventory"
     EquipButtonLabel="|&Equip"
     UnequipButtonLabel="Un|&equip"
     UseButtonLabel="|&Use"
     DropButtonLabel="|&Drop"
     ChangeAmmoButtonLabel="Change Amm|&o"
     NanoKeyRingInfoText="Click icon to see a list of Nano Keys."
     NanoKeyRingLabel="Keys: %s"
     DroppedLabel="%s dropped"
     AmmoLoadedLabel="%s loaded"
     WeaponUpgradedLabel="%s upgraded"
     CannotBeDroppedLabel="%s cannot be dropped here"
     AmmoInfoText="Click icon to see a list of Ammo."
     AmmoTitleLabel="Ammunition"
     NoAmmoLabel="No Ammo Available"
     clientBorderOffsetY=33
     ClientWidth=585
     ClientHeight=361
     clientOffsetX=33
     clientOffsetY=10
     clientTextures(0)=Texture'DeusExUI.UserInterface.InventoryBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.InventoryBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.InventoryBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.InventoryBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.InventoryBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.InventoryBackground_6'
     clientBorderTextures(0)=Texture'DeusExUI.UserInterface.InventoryBorder_1'
     clientBorderTextures(1)=Texture'DeusExUI.UserInterface.InventoryBorder_2'
     clientBorderTextures(2)=Texture'DeusExUI.UserInterface.InventoryBorder_3'
     clientBorderTextures(3)=Texture'DeusExUI.UserInterface.InventoryBorder_4'
     clientBorderTextures(4)=Texture'DeusExUI.UserInterface.InventoryBorder_5'
     clientBorderTextures(5)=Texture'DeusExUI.UserInterface.InventoryBorder_6'
     clientTextureRows=2
     clientTextureCols=3
     clientBorderTextureRows=2
     clientBorderTextureCols=3
}
