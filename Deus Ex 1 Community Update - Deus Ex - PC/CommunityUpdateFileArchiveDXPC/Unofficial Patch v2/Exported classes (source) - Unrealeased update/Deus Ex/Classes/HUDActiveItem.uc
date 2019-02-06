//=============================================================================
// HUDActiveItem
//=============================================================================

class HUDActiveItem extends HUDActiveItemBase;

var ProgressBarWindow winEnergy;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	CreateEnergyBar();

	bTickEnabled = TRUE;
}

// ----------------------------------------------------------------------
// Tick()
//
// Used to update the energy bar
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
	local ChargedPickup item;

	item = ChargedPickup(GetClientObject());

   if ((item != None) && (Player.PlayerIsRemoteClient()))
      if (!VerifyItemCarried())
      {
        Player.RemoveChargedDisplay(item);
        item = None;
      }


	if ((item != None) && (winEnergy != None))
	{
		winEnergy.SetCurrentValue(item.GetCurrentCharge());
	}
  
}

// ----------------------------------------------------------------------
// CreateEnergyBar()
// ----------------------------------------------------------------------

function CreateEnergyBar()
{
	winEnergy = ProgressBarWindow(NewChild(Class'ProgressBarWindow'));
	winEnergy.SetSize(32, 2);
	winEnergy.UseScaledColor(True);
	winEnergy.SetPos(1, 30);
	winEnergy.SetValues(0, 100);
	winEnergy.SetCurrentValue(0);
	winEnergy.SetVertical(False);
}

// ----------------------------------------------------------------------
// VerifyItemCarried()
// If the player is no longer carrying this item, we shouldn't be displaying
// anymore.
// ----------------------------------------------------------------------

function bool VerifyItemCarried()
{
   local inventory CurrentItem;
   local bool bFound;

   bFound = false;
   
   for (CurrentItem = player.Inventory; ((CurrentItem != None) && (!bFound)); CurrentItem = CurrentItem.inventory)
   {
      if (CurrentItem == GetClientObject())
         bFound = true;
   }

   return bFound;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     iconDrawStyle=DSTY_Masked
}
