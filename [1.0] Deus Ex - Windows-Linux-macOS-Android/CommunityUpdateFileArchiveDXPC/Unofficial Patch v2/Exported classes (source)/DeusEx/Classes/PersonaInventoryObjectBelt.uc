//=============================================================================
// PersonaInventoryObjectBelt
//=============================================================================
class PersonaInventoryObjectBelt expands Window;

var PersonaScreenInventory winInventory;	// Pointer to inventory window
var HUDObjectBelt objBelt;			// Our local object Belt
var HUDObjectBelt hudBelt;			// HUD Object Belt

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	local DeusExRootWindow root;
	local float hudBeltWidth, hudBeltHeight;

	Super.InitWindow();

	SetSize(631, 69);

	hudBelt = DeusExRootWindow(GetRootWindow()).hud.belt;

	// Create our local object belt, then get a pointer to the HUD belt
	objBelt = HUDObjectBelt(NewChild(Class'HUDObjectBelt'));
	objBelt.SetPos(90, 0);
	objBelt.SetVisibility(True);
	objBelt.SetInteractive(True);

	if ( !hudBelt.IsVisible() )
	{
		hudBelt.Show();
		hudBelt.Hide();
	}

	// Copy the items from HUD belt into our local belt
	CopyObjectBeltInventory();
}

// ----------------------------------------------------------------------
// DestroyWindow()
// ----------------------------------------------------------------------

event DestroyWindow()
{
	hudBelt.AssignWinInv(None);

	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// UpdateBeltText()
// ----------------------------------------------------------------------

function UpdateBeltText(Inventory item)
{
	// Update object belt text
	if (item.bInObjectBelt)
		objBelt.UpdateObjectText(item.beltPos);		
}

// ----------------------------------------------------------------------
// CopyObjectBeltInventory()
//
// Copies the Real object belt inventory into our copy
// ----------------------------------------------------------------------

function CopyObjectBeltInventory()
{
	local int objectIndex;

	// Now copy the items
	for (objectIndex=1;objectIndex<10;objectIndex++)
		objBelt.AddObjectToBelt(hudBelt.GetObjectFromBelt(objectIndex), objectIndex, True);
}

// ----------------------------------------------------------------------
// SetInventoryWindow()
// ----------------------------------------------------------------------

function SetInventoryWindow( PersonaScreenInventory newWinInventory )
{
	winInventory = newWinInventory;

	// Set all the object belt winInv 
	objBelt.AssignWinInv(newWinInventory);
}

// ----------------------------------------------------------------------
// AssignObjectBeltByKey()
// ----------------------------------------------------------------------

function AssignObjectBeltByKey(Inventory invItem, EInputKey key)
{
	local int objectNum;

	if ((key < IK_1) || ( key > IK_9 ))
		return;

	// Typecasting EInputKey to int doesn't seem to work.
	// All I have to say to that is BAH.

	// 0 (Zero) cannot be assigned because that position is used
	// by the NanoKeyRing

	switch( key ) 
	{
		case IK_1:
			objectNum = 1;
			break;
		case IK_2:
			objectNum = 2;
			break;
		case IK_3:
			objectNum = 3;
			break;
		case IK_4:
			objectNum = 4;
			break;
		case IK_5:
			objectNum = 5;
			break;
		case IK_6:
			objectNum = 6;
			break;
		case IK_7:
			objectNum = 7;
			break;
		case IK_8:
			objectNum = 8;
			break;
		case IK_9:
			objectNum = 9;
			break;
	}

	AddObject(invItem, objectNum);
}

// ----------------------------------------------------------------------
// AddObject()
// ----------------------------------------------------------------------

function AddObject(Inventory inv, int objectNum)
{
	// Don't allow this if it's the NanoKeyRing object

	if (( inv != None ) && (objectNum != 0))
	{
      //DEUS_EX AMSD Changed so hudbelt call propagates through player
      DeusExPlayer(GetRootWindow().ParentPawn).RemoveObjectFromBelt(inv);
		//hudBelt.RemoveObjectFromBelt(inv);
      DeusExPlayer(GetRootWindow().ParentPawn).AddObjectToBelt(inv, objectNum, True);
		//hudBelt.objects[objectNum].SetItem(inv);
		objBelt.RemoveObjectFromBelt(inv);
		objBelt.AddObjectToBelt(inv, objectNum, True);
	}
}

// ----------------------------------------------------------------------
// RemoveObject()
// ----------------------------------------------------------------------

function RemoveObject(Inventory inv)
{
	objBelt.RemoveObjectFromBelt(inv);      
   DeusExPlayer(GetRootWindow().ParentPawn).RemoveObjectFromBelt(inv);
	//hudBelt.RemoveObjectFromBelt(inv);
}

// ----------------------------------------------------------------------
// SwapObjects()
// ----------------------------------------------------------------------

function SwapObjects(HUDObjectSlot firstSlot, HUDObjectSlot secondSlot)
{
	local int firstSlotNum;
	local int secondSlotNum;
	local Inventory firstItem;
	local Inventory secondItem;

	firstSlotNum  = firstSlot.ObjectNum;
	secondSlotNum = secondSlot.ObjectNum;

	firstItem  = firstSlot.Item;
	secondItem = secondSlot.Item;

	RemoveObject(firstSlot.item);

	if (secondSlot.Item != None)
		RemoveObject(secondSlot.item);	

	AddObject(firstItem, secondSlotNum);

	if (secondItem != None)
		AddObject(secondItem, firstSlotNum);
}

// ----------------------------------------------------------------------
// SelectObject()
// ----------------------------------------------------------------------

function SelectObject(Inventory item, bool bNewToggle)
{
	local int objectIndex;

	for (objectIndex=0;objectIndex<10;objectIndex++)
	{
		if (objBelt.objects[objectIndex].item == item)
		{
			if (!objBelt.objects[objectIndex].GetToggle())
				objBelt.objects[objectIndex].SetToggle(bNewToggle);
		}
		else
		{
			// Make sure no other objects are toggled.
			objBelt.objects[objectIndex].SetToggle(False);		
			objBelt.objects[objectIndex].HighlightSelect(False);
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
