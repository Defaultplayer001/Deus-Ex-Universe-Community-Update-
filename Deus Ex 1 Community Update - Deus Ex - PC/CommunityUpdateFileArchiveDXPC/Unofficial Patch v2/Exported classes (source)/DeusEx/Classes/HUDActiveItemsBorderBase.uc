//=============================================================================
// HUDActiveItemsBorderBase
//=============================================================================

class HUDActiveItemsBorderBase extends HUDBaseWindow
	abstract;

var TileWindow winIcons;
var int        iconCount;

var Texture texBorderTop;
var Texture texBorderCenter;
var Texture texBorderBottom;

var int borderTopMargin;
var int borderBottomMargin;
var int borderWidth;
var int topHeight;
var int topOffset;
var int bottomHeight;
var int bottomOffset;
var int tilePosX;
var int tilePosY;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	CreateTileWindow();

	Hide();
}

// ----------------------------------------------------------------------
// CreateTileWindow()
// ----------------------------------------------------------------------

function CreateTileWindow()
{
	winIcons = TileWindow(NewChild(Class'TileWindow'));
	winIcons.SetMargins(0, 0);
	winIcons.SetMinorSpacing(2);
	winIcons.SetOrder(ORDER_Down);
	winIcons.SetPos(tilePosX, tilePosY);
}

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

function DrawBorder(GC gc)
{
	if ((bDrawBorder) && (iconCount > 0))
	{
		gc.SetStyle(borderDrawStyle);
		gc.SetTileColor(colBorder);

		// Border is drawn as three pieces
		gc.DrawTexture(0, 0, width, topHeight, 0, 0, texBorderTop);
		gc.DrawPattern(0, topOffset, width, height - topOffset - bottomOffset, 0, 0, texBorderCenter);
		gc.DrawTexture(0, height - bottomHeight, width, bottomHeight, 0, 0, texBorderBottom);
	}
}

// ----------------------------------------------------------------------
// AddIcon()
// ----------------------------------------------------------------------

function AddIcon(Texture newIcon, Object saveObject)
{
	local HUDActiveItemBase activeItem;
	local HUDActiveItemBase iconWindow;

	// First make sure this object isn't already in the window
	iconWindow = HUDActiveItemBase(winIcons.GetTopChild());
	while(iconWindow != None)
	{
		// Abort if this object already exists!!
		if (iconWindow.GetClientObject() == saveObject)
			return;

		iconWindow = HUDActiveItemBase(iconWindow.GetLowerSibling());
	}

	// Hide if there are no icons visible
	if (++iconCount == 1)
		Show();

	if (saveObject.IsA('Augmentation'))
		activeItem = HUDActiveItemBase(winIcons.NewChild(Class'HUDActiveAug'));
	else
		activeItem = HUDActiveItemBase(winIcons.NewChild(Class'HUDActiveItem'));

	activeItem.SetIcon(newIcon);
	activeItem.SetClientObject(saveObject);
	activeItem.SetObject(saveObject);

	AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// RemoveObject()
// ----------------------------------------------------------------------

function RemoveObject(Object removeObject)
{
	local Window currentWindow;
	local Window nextWindow;

	// Loop through all our children and check to see if 
	// we have a match.

	currentWindow = winIcons.GetTopChild();
	while(currentWindow != None)
	{
		nextWindow = currentWindow.GetLowerSibling();

		if (currentWindow.GetClientObject() == removeObject)
		{
			currentWindow.Destroy();

			// Hide if there are no icons visible
			if (--iconCount == 0)
				Hide();

			break;
		}

		currentWindow = nextWindow;
	}

	AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// RemoveAllIcons()
// ----------------------------------------------------------------------

function RemoveAllIcons()
{
	winIcons.DestroyAllChildren();
	iconCount = 0;
}

// ----------------------------------------------------------------------
// ParentRequestedPreferredSize()
// ----------------------------------------------------------------------

event ParentRequestedPreferredSize(bool bWidthSpecified, out float preferredWidth,
                                   bool bHeightSpecified, out float preferredHeight)
{
	winIcons.QueryPreferredSize(preferredWidth, preferredHeight);

	preferredWidth  = borderWidth;
	preferredHeight = preferredHeight + borderTopMargin + borderBottomMargin;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
