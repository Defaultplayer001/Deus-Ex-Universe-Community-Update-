//=============================================================================
// HUDObjectSlot
//=============================================================================
class HUDObjectSlot expands ToggleWindow;

var DeusExPlayer player;

var int			objectNum;
var Inventory	item;
var Color		colObjectNum;
var Color		colObjectDesc;
var Color		colOutline;
var Color		fillColor;
var Color		colDropGood;
var Color		colDropBad;
var Color		colNone;
var Color		colSelected;
var Color       colSelectionBorder;
var int			slotFillWidth;
var int			slotFillHeight;
var int         borderWidth;
var int         borderHeight;

// Stuff to optimize DrawWindow()
var String      itemText;

// Drag/Drop Stuff
var PersonaScreenInventory winInv;		// Pointer back to the inventory window
var Int  clickX;
var Int  clickY;
var bool bDragStart;
var bool bDimIcon;	
var bool bAllowDragging;
var bool bDragging;					// Set to True when we're dragging

enum FillModes
{
	FM_Selected,
	FM_DropGood,
	FM_DropBad,
	FM_None
};

var FillModes fillMode;

// Variables used to draw belt
var Texture		slotTextures;
var int			slotIconX;
var int			slotIconY;
var int			slotNumberX;
var int			slotNumberY;

// Used by DrawWindow()
var int itemTextPosY;

// Defaults
var EDrawStyle backgroundDrawStyle;
var Texture texBackground;
var Texture mpBorderTex; //For drawing borders between item slot sections in mp
var Color colBackground;

var Texture texBorders[9];

var localized String RoundLabel;
var localized String RoundsLabel;
var localized String CountLabel;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	objectNum	= -1;
	item        = None;

	SetSelectability(false);

	SetSize(51, 54);
	SetFont(Font'FontTiny');

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	// Position where we'll be drawing the item-dependent text
	itemTextPosY = slotFillHeight - 8 + slotIconY;

	StyleChanged();
}

// ----------------------------------------------------------------------
// ToggleChanged()
// ----------------------------------------------------------------------

event bool ToggleChanged(Window button, bool bNewToggle)
{
	if ((item == None) && (bNewToggle))
	{
		SetToggle(False);
		return True;
	}
	else
	{
		return False;
	}
}

// ----------------------------------------------------------------------
// SetObjectNumber()
// ----------------------------------------------------------------------

function SetObjectNumber(int newNumber)
{
	objectNum = newNumber;
}

// ----------------------------------------------------------------------
// SetItem()
// ----------------------------------------------------------------------

function SetItem(Inventory newItem)
{
	item = newItem;
	if ( newItem != None )
	{
		newItem.bInObjectBelt = True;
		newItem.beltPos       = objectNum;
	}
	else
	{
		HighlightSelect(False);
		SetToggle(False);
	}

	// Update the text that will be displayed above the icon (if any)
	UpdateItemText();
}

// ----------------------------------------------------------------------
// UpdateItemText()
// ----------------------------------------------------------------------

function UpdateItemText()
{
	local DeusExWeapon weapon;

	itemText = "";

	if (item != None)
	{
		if (item.IsA('DeusExWeapon'))
		{
			// If this is a weapon, show the number of remaining rounds 
			weapon = DeusExWeapon(item);

			// Ammo loaded
			if ((weapon.AmmoName != class'AmmoNone') && (!weapon.bHandToHand) && (weapon.ReloadCount != 0) && (weapon.AmmoType != None))
				itemText = weapon.AmmoType.beltDescription;

			// If this is a grenade
			if (weapon.IsA('WeaponNanoVirusGrenade') || 
				weapon.IsA('WeaponGasGrenade') || 
				weapon.IsA('WeaponEMPGrenade') ||
				weapon.IsA('WeaponLAM'))
			{
				if (weapon.AmmoType.AmmoAmount > 1)
					itemText = CountLabel @ weapon.AmmoType.AmmoAmount;
			}

		}
		else if (item.IsA('DeusExPickup') && (!item.IsA('NanoKeyRing')))
		{
			// If the object is a SkilledTool (but not the NanoKeyRing) then show the 
			// number of uses
			if (DeusExPickup(item).NumCopies > 1)
				itemText = DeusExPickup(item).CountLabel @ String(DeusExPickup(item).NumCopies);
		}
	}
}

// ----------------------------------------------------------------------
// GetItem()
// ----------------------------------------------------------------------

function Inventory GetItem()
{
	return (item);
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	// First draw the background
   DrawHUDBackground(gc);

	// Now fill the area under the icon, which can be different 
	// colors based on the state of the item.
	//
	// Don't waste time drawing the fill if the fillMode is set
	// to None

	if (fillMode != FM_None)
	{
		SetFillColor();
		gc.SetStyle(DSTY_Translucent);
		gc.SetTileColor(fillColor);
		gc.DrawPattern( 
			slotIconX, slotIconY, 
			slotFillWidth, slotFillHeight, 
			0, 0, Texture'Solid' );
	}

	// Don't draw any of this if we're dragging
	if ((item != None) && (item.Icon != None) && (!bDragging))
	{
		// Draw the icon
      DrawHUDIcon(gc);

		// Text defaults
		gc.SetAlignments(HALIGN_Center, VALIGN_Center);
		gc.EnableWordWrap(false);
		gc.SetTextColor(colObjectNum);

		// Draw the item description at the bottom
		gc.DrawText(1, 42, 42, 7, item.BeltDescription);

		// If there's any additional text (say, for an ammo or weapon), draw it
		if (itemText != "")
			gc.DrawText(slotIconX, itemTextPosY, slotFillWidth, 8, itemText);

		// Draw selection border
		if (bButtonPressed)
		{
			gc.SetTileColor(colSelectionBorder);
			gc.SetStyle(DSTY_Masked);
			gc.DrawBorders(slotIconX - 1, slotIconY - 1, borderWidth, borderHeight, 0, 0, 0, 0, texBorders);
		}
	}
   else if ((item == None) && (player != None) && (player.Level.NetMode != NM_Standalone) && (player.bBeltIsMPInventory))
   {
		// Text defaults
		gc.SetAlignments(HALIGN_Center, VALIGN_Center);
		gc.EnableWordWrap(false);
		gc.SetTextColor(colObjectNum);

		if ((objectNum >=1) && (objectNum <=3))
      {
         gc.DrawText(1, 42, 42, 7, "WEAPONS");
      }
      else if ((objectNum >=4) && (objectNum <=6))
      {
         gc.DrawText(1, 42, 42, 7, "GRENADES");
      }
      else if ( ((objectNum >=7) && (objectNum <=9)) || (objectNum == 0) )
      {
         gc.DrawText(1, 42, 42, 7, "TOOLS");
      }
   }
	
	// Draw the Object Slot Number in upper-right corner
	gc.SetAlignments(HALIGN_Right, VALIGN_Center);
	gc.SetTextColor(colObjectNum);
	gc.DrawText(slotNumberX - 1, slotNumberY, 6, 7, objectNum);
}

function DrawHUDIcon(GC gc)
{
		gc.SetStyle(DSTY_Masked);
		gc.SetTileColorRGB(255, 255, 255);
		gc.DrawTexture(slotIconX, slotIconY, slotFillWidth, slotFillHeight, 0, 0, item.Icon);
}

function DrawHUDBackground(GC gc)
{
	local Color newBackground;
			
	gc.SetStyle(backgroundDrawStyle);
	if (( player != None ) && (player.Level.NetMode != NM_Standalone) && (player.bBuySkills))
	{
		newBackground.r = colBackground.r / 2;
		newBackground.g = colBackground.g / 2;
		newBackground.b = colBackground.b / 2;
		gc.SetTileColor(newBackground);
	}
	else
		gc.SetTileColor(colBackground);

   // DEUS_EX AMSD Warning.  This background delineates specific item locations on the belt, which
   // are usually only known to the items themselves.
   if ( (player != None) && (Player.Level.Netmode != NM_Standalone) && (Player.bBeltIsMPInventory) && ((objectNum == 3) || (objectNum == 6)) )
   {
      gc.DrawTexture(0, 0, width, height, 0, 0, mpBorderTex);
   }
   else	
      gc.DrawTexture(0, 0, width, height, 0, 0, texBackground);
}

// ----------------------------------------------------------------------
// SetDropFill()
// ----------------------------------------------------------------------

function SetDropFill(bool bGoodDrop)
{
	if (bGoodDrop)
		fillMode = FM_DropGood;
	else
		fillMode = FM_DropBad;
}

// ----------------------------------------------------------------------
// AllowDragging()
// ----------------------------------------------------------------------

function AllowDragging(bool bNewAllowDragging)
{
	bAllowDragging = bNewAllowDragging;
}

// ----------------------------------------------------------------------
// ResetFill()
// ----------------------------------------------------------------------

function ResetFill()
{
	fillMode = FM_None;
}

// ----------------------------------------------------------------------
// HighlightSelect()
// ----------------------------------------------------------------------

function HighlightSelect(bool bHighlight)
{
	if (bHighlight) 
		fillMode = FM_Selected;
	else
		fillMode = FM_None;
}

// ----------------------------------------------------------------------
// SetFillColor()
// ----------------------------------------------------------------------

function SetFillColor()
{
	switch(fillMode)
	{
		case FM_Selected:
			fillColor = colSelected;
			break;
		case FM_DropBad:
			fillColor = colDropBad;
			break;
		case FM_DropGood:
			fillColor = colDropGood;
			break;
		case FM_None:
			fillColor = colNone;
			break;
	}
}

// ----------------------------------------------------------------------
// MouseButtonPressed()
//
// If the user presses the mouse button, initiate drag mode, 
// but only if this button has an inventory item associated
// with it.
// ----------------------------------------------------------------------

event bool MouseButtonPressed(float pointX, float pointY, EInputKey button,
                              int numClicks)
{
	local Bool bResult;

	bResult = False;

	if ((item != None) && (button == IK_LeftMouse))
	{
		bDragStart = True;
		clickX = pointX;
		clickY = pointY;
		bResult = True;
	}
	return bResult;
}

// ----------------------------------------------------------------------
// MouseButtonReleased()
//
// If we were in drag mode, then release the mouse button.
// If the player is over a new (and valid) inventory location or 
// object belt location, drop the item here.
// ----------------------------------------------------------------------

event bool MouseButtonReleased(float pointX, float pointY, EInputKey button,
                               int numClicks)
{
	if (button == IK_LeftMouse)
	{
		FinishButtonDrag();
		return True;
	}
	else
	{
		return false;  // don't handle
	}
}

// ----------------------------------------------------------------------
// MouseMoved()
// ----------------------------------------------------------------------

event MouseMoved(float newX, float newY)
{
	local Float invX;
	local Float invY;

	if (bAllowDragging)
	{
		if (bDragStart)
		{
			// Only start a drag even if the cursor has moved more than, say,
			// two pixels.  This prevents problems if the user just wants to 
			// click on an item to select it but is a little sloppy.  :)
			if (( Abs(newX - clickX) > 2 ) || ( Abs(newY- clickY) > 2 ))
			{
				StartButtonDrag();
				SetCursorPos(
					slotIconX + slotFillWidth/2, 
					slotIconY + slotFillHeight/2);
			}
		}

		if (bDragging)
		{
			// Call the InventoryWindow::MouseMoved function, with translated
			// coordinates.
			ConvertCoordinates(Self, newX, newY, winInv, invX, invY);
			winInv.UpdateDragMouse(invX, invY);
		}
	}
}

// ----------------------------------------------------------------------
// CursorRequested()
//
// If we're dragging an inventory item, then set the cursor to that 
// icon.  Otherwise return None, meaning use the default cursor icon.
// ----------------------------------------------------------------------

event texture CursorRequested(window win, float pointX, float pointY,
                              out float hotX, out float hotY, out color newColor, 
							  out Texture shadowTexture)
{
    shadowTexture = None;

	hotX = slotFillWidth / 2;
	hotY = slotFillHeight / 2;

	if ((item != None) && (bDragging))
	{
		if (bDimIcon)
		{
			newColor.R = 64;
			newColor.G = 64;
			newColor.B = 64;
		}

		return item.Icon;
	}
	else
	{
		return None;
	}
}

// ----------------------------------------------------------------------
// StartButtonDrag()
// ----------------------------------------------------------------------

function StartButtonDrag()
{
	bDragStart = False;
	bDragging  = True;

	winInv.StartButtonDrag(Self);
}

// ----------------------------------------------------------------------
// FinishButtonDrag()
// ----------------------------------------------------------------------

function FinishButtonDrag()
{
	winInv.FinishButtonDrag();
	
	bDragStart = False;
	bDragging  = False;
}

// ----------------------------------------------------------------------
// AssignWinInv()
// ----------------------------------------------------------------------

function AssignWinInv(PersonaScreenInventory newWinInventory)
{
	winInv = newWinInventory;
}

// ----------------------------------------------------------------------
// GetIconPos()
//
// Returns the location where the icon will be drawn
// ----------------------------------------------------------------------

function GetIconPos(out int iconPosX, out int iconPosY)
{
	iconPosX = slotIconX;
	iconPosY = slotIconY;
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colBackground = theme.GetColorFromName('HUDColor_Background');
	colObjectNum  = theme.GetColorFromName('HUDColor_NormalText');

	colSelected.r = Int(Float(colBackground.r) * 0.50);
	colSelected.g = Int(Float(colBackground.g) * 0.50);
	colSelected.b = Int(Float(colBackground.b) * 0.50);

	if (player.GetHUDBackgroundTranslucency())
		backgroundDrawStyle = DSTY_Translucent;
	else
		backgroundDrawStyle = DSTY_Masked;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colObjectNum=(G=170,B=255)
     colDropGood=(R=32,G=128,B=32)
     colDropBad=(R=128,G=32,B=32)
     colSelected=(R=60,G=60,B=60)
     colSelectionBorder=(R=255,G=255,B=255)
     slotFillWidth=42
     slotFillHeight=37
     borderWidth=44
     borderHeight=50
     bAllowDragging=True
     fillMode=FM_None
     slotIconX=1
     slotIconY=3
     slotNumberX=38
     slotNumberY=3
     texBackground=Texture'DeusExUI.UserInterface.HUDObjectBeltBackground_Cell'
     mpBorderTex=Texture'DeusExUI.UserInterface.HUDObjectBeltBackground_Divider'
     texBorders(0)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_TL'
     texBorders(1)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_TR'
     texBorders(2)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_BL'
     texBorders(3)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_BR'
     texBorders(4)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Left'
     texBorders(5)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Right'
     texBorders(6)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Top'
     texBorders(7)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Bottom'
     texBorders(8)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Center'
     RoundLabel="%d Rd"
     RoundsLabel="%d Rds"
     CountLabel="COUNT:"
}
