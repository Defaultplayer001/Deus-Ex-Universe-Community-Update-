//=============================================================================
// HUDActiveItemsDisplay
//=============================================================================

class HUDActiveItemsDisplay extends HUDBaseWindow;

enum ESchemeTypes
{
	ST_Menu,
	ST_HUD
};

var ESchemeTypes editMode;
var Int          itemAugsOffsetX;
var Int          itemAugsOffsetY;

var HUDActiveAugsBorder  winAugsContainer;
var HUDActiveItemsBorder winItemsContainer;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	CreateContainerWindows();

	Hide();
}

// ----------------------------------------------------------------------
// CreateContainerWindows()
// ----------------------------------------------------------------------

function CreateContainerWindows()
{
	winAugsContainer  = HUDActiveAugsBorder(NewChild(Class'HUDActiveAugsBorder'));
	winItemsContainer = HUDActiveItemsBorder(NewChild(Class'HUDActiveItemsBorder'));
}

// ----------------------------------------------------------------------
// AddIcon()
// ----------------------------------------------------------------------

function AddIcon(Texture newIcon, Object saveObject)
{
	local HUDActiveItem activeItem;

	if (saveObject.IsA('Augmentation'))
		winAugsContainer.AddIcon(newIcon, saveObject);
	else
		winItemsContainer.AddIcon(newIcon, saveObject);

	AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// RemoveIcon()
// ----------------------------------------------------------------------

function RemoveIcon(Object removeObject)
{
	if (removeObject.IsA('Augmentation'))
		winAugsContainer.RemoveObject(removeObject);
	else
		winItemsContainer.RemoveObject(removeObject);

	AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// UpdateAugIconStatus()
// ----------------------------------------------------------------------

function UpdateAugIconStatus(Augmentation aug)
{
	winAugsContainer.UpdateAugIconStatus(aug);
}

// ----------------------------------------------------------------------
// ClearAugmentationDisplay()
// ----------------------------------------------------------------------

function ClearAugmentationDisplay()
{
	winAugsContainer.ClearAugmentationDisplay();
}

// ----------------------------------------------------------------------
// SetVisibility()
//
// Only show if one or more icons is being displayed
// ----------------------------------------------------------------------

function SetVisibility( bool bNewVisibility )
{
	Show(bNewVisibility);

	AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// ParentRequestedPreferredSize()
// ----------------------------------------------------------------------

event ParentRequestedPreferredSize(bool bWidthSpecified, out float preferredWidth,
                                   bool bHeightSpecified, out float preferredHeight)
{
	local float augsWidth, augsHeight;
	local float itemsWidth, itemsHeight;

	winAugsContainer.QueryPreferredSize(augsWidth, augsHeight);
	winItemsContainer.QueryPreferredSize(itemsWidth, itemsHeight);

	preferredWidth  = augsWidth + itemsWidth;
	preferredHeight = augsHeight + itemsHeight;
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	local float augsWidth, augsHeight;
	local float itemsWidth, itemsHeight;
	local float itemPosX;

	if (winItemsContainer != None)
	{
		winItemsContainer.QueryPreferredSize(itemsWidth, itemsHeight);
		itemPosX = 0;
	}

	// Position the two windows
	if ((winAugsContainer != None) && (winAugsContainer.iconCount > 0))
	{
		winAugsContainer.QueryPreferredSize(augsWidth, augsHeight);
		winAugsContainer.ConfigureChild(itemsWidth, 0, augsWidth, augsHeight);

		itemPosX = itemsWidth + itemAugsOffsetX;
	}

	// Now that we know where the Augmentation window is, position
	// the Items window

	if (winItemsContainer != None)
	{
		// First check to see if there's enough room underneat the augs display 
		// to show the active items.

		if ((augsHeight + itemsHeight) > height)
			winItemsContainer.ConfigureChild(itemAugsOffsetX, itemAugsOffsetY, itemsWidth, itemsHeight);
		else
			winItemsContainer.ConfigureChild(itemPosX, augsHeight - 2, itemsWidth, itemsHeight);
	}		
}

// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

event bool ChildRequestedReconfiguration(window childWin)
{
	return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     itemAugsOffsetX=14
     itemAugsOffsetY=6
}
