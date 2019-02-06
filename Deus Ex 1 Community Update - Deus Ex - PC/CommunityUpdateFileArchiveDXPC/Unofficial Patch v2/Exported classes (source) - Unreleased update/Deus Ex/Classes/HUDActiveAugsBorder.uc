//=============================================================================
// HUDActiveAugsBorder
//=============================================================================

class HUDActiveAugsBorder extends HUDActiveItemsBorderBase;

var int FirstKeyNum;
var int LastKeyNum;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Create *ALL* the icons, but hide them.
	CreateIcons();
}

// ----------------------------------------------------------------------
// CreateIcons()
// ----------------------------------------------------------------------

function CreateIcons()
{
	local int keyIndex;
	local HUDActiveAug iconWindow;

	for(keyIndex=FirstKeyNum; keyIndex<=LastKeyNum; keyIndex++)
	{
		iconWindow = HUDActiveAug(winIcons.NewChild(Class'HUDActiveAug'));
		iconWindow.SetKeyNum(keyIndex);
		iconWindow.Hide();
	}
}

// ----------------------------------------------------------------------
// ClearAugmentationDisplay()
// ----------------------------------------------------------------------

function ClearAugmentationDisplay()
{
	local Window currentWindow;
	local Window foundWindow;

	// Loop through all our children and check to see if 
	// we have a match.

	currentWindow = winIcons.GetTopChild();
	while(currentWindow != None)
	{
		currentWindow.Hide();
      currentWindow.SetClientObject(None);
		currentWindow = currentWindow.GetLowerSibling();
	}

	iconCount = 0;
}

// ----------------------------------------------------------------------
// AddIcon()
//
// Find the appropriate 
// ----------------------------------------------------------------------

function AddIcon(Texture newIcon, Object saveObject)
{
	local HUDActiveAug augItem;

	augItem = FindAugWindowByKey(Augmentation(saveObject));

	if (augItem != None)
	{
		augItem.SetIcon(newIcon);
		augItem.SetClientObject(saveObject);
		augItem.SetObject(saveObject);
		augItem.Show();

		// Hide if there are no icons visible
		if (++iconCount == 1)
			Show();

		AskParentForReconfigure();
	}
}

// ----------------------------------------------------------------------
// RemoveObject()
// ----------------------------------------------------------------------

function RemoveObject(Object removeObject)
{
	local HUDActiveAug augItemWindow;

	augItemWindow = FindAugWindowByKey(Augmentation(removeObject));

	if (augItemWindow != None)
	{
		augItemWindow.Hide();
      augItemWindow.SetClientObject(None);

		// Hide if there are no icons visible
		if (--iconCount == 0)
			Hide();

		AskParentForReconfigure();
	}
}

// ----------------------------------------------------------------------
// FindAugWindowByKey()
// ----------------------------------------------------------------------

function HUDActiveAug FindAugWindowByKey(Augmentation anAug)
{
	local Window currentWindow;
	local Window foundWindow;

	// Loop through all our children and check to see if 
	// we have a match.

	currentWindow = winIcons.GetTopChild(False);

	while(currentWindow != None)
	{
		if (HUDActiveAug(currentWindow).HotKeyNum == anAug.HotKeyNum)
		{
			foundWindow = currentWindow;
			break;
		}

		currentWindow = currentWindow.GetLowerSibling(False);
	}

	return HUDActiveAug(foundWindow);
}

// ----------------------------------------------------------------------
// UpdateAugIconStatus()
// ----------------------------------------------------------------------

function UpdateAugIconStatus(Augmentation aug)
{
	local HUDActiveAug iconWindow;

	// First make sure this object isn't already in the window
	iconWindow = HUDActiveAug(winIcons.GetTopChild());
	while(iconWindow != None)
	{
		// Abort if this object already exists!!
		if (iconWindow.GetClientObject() == aug)
		{
			iconWindow.UpdateAugIconStatus();
			break;			
		}
		iconWindow = HUDActiveAug(iconWindow.GetLowerSibling());
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     FirstKeyNum=3
     LastKeyNum=12
     texBorderTop=Texture'DeusExUI.UserInterface.HUDAugmentationsBorder_Top'
     texBorderCenter=Texture'DeusExUI.UserInterface.HUDAugmentationsBorder_Center'
     texBorderBottom=Texture'DeusExUI.UserInterface.HUDAugmentationsBorder_Bottom'
     borderTopMargin=13
     borderBottomMargin=9
     borderWidth=62
     topHeight=37
     topOffset=26
     bottomHeight=32
     bottomOffset=28
     tilePosX=20
     tilePosY=13
}
