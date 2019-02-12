//=============================================================================
// ChargedPickup.
//=============================================================================
class ChargedPickup extends DeusExPickup
	abstract;

var() class<Skill> skillNeeded;
var() bool bOneUseOnly;
var() sound ActivateSound;
var() sound DeactivateSound;
var() sound LoopSound;
var Texture ChargedIcon;
var travel bool bIsActive;
var localized String ChargeRemainingLabel;

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;
	local DeusExPlayer player;
	local String outText;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

	player = DeusExPlayer(Owner);

	if (player != None)
	{
		winInfo.SetTitle(itemName);
		winInfo.SetText(Description $ winInfo.CR() $ winInfo.CR());

		outText = ChargeRemainingLabel @ Int(GetCurrentCharge()) $ "%";
		winInfo.AppendText(outText);
	}

	return True;
}

// ----------------------------------------------------------------------
// GetCurrentCharge()
// ----------------------------------------------------------------------

simulated function Float GetCurrentCharge()
{
	return (Float(Charge) / Float(Default.Charge)) * 100.0;
}

// ----------------------------------------------------------------------
// ChargedPickupBegin()
// ----------------------------------------------------------------------

function ChargedPickupBegin(DeusExPlayer Player)
{
	Player.AddChargedDisplay(Self);
	PlaySound(ActivateSound, SLOT_None);
	if (LoopSound != None)
		AmbientSound = LoopSound;

   //DEUS_EX AMSD In multiplayer, remove it from the belt if the belt
   //is the only inventory.
   if ((Level.NetMode != NM_Standalone) && (Player.bBeltIsMPInventory))
   {
      if (DeusExRootWindow(Player.rootWindow) != None)
         DeusExRootWindow(Player.rootWindow).DeleteInventory(self);

      bInObjectBelt=False;
      BeltPos=default.BeltPos;
   }

	bIsActive = True;
}

// ----------------------------------------------------------------------
// ChargedPickupEnd()
// ----------------------------------------------------------------------

function ChargedPickupEnd(DeusExPlayer Player)
{
	Player.RemoveChargedDisplay(Self);
	PlaySound(DeactivateSound, SLOT_None);
	if (LoopSound != None)
		AmbientSound = None;

	// remove it from our inventory if this is a one
	// use item
	if (bOneUseOnly)
		Player.DeleteInventory(Self);

	bIsActive = False;
}

// ----------------------------------------------------------------------
// IsActive()
// ----------------------------------------------------------------------

simulated function bool IsActive()
{
	return bIsActive;
}

// ----------------------------------------------------------------------
// ChargedPickupUpdate()
// ----------------------------------------------------------------------

function ChargedPickupUpdate(DeusExPlayer Player)
{
}

// ----------------------------------------------------------------------
// CalcChargeDrain()
// ----------------------------------------------------------------------

simulated function int CalcChargeDrain(DeusExPlayer Player)
{
	local float skillValue;
	local float drain;

	drain = 4.0;
	skillValue = 1.0;

	if (skillNeeded != None)
		skillValue = Player.SkillSystem.GetSkillLevelValue(skillNeeded);
	drain *= skillValue;

	return Int(drain);
}

// ----------------------------------------------------------------------
// function UsedUp()
//
// copied from Pickup, but modified to keep items from
// automatically switching
// ----------------------------------------------------------------------

function UsedUp()
{
	local DeusExPlayer Player;

	if ( Pawn(Owner) != None )
	{
		bActivatable = false;
		Pawn(Owner).ClientMessage(ExpireMessage);	
	}
	Owner.PlaySound(DeactivateSound);
	Player = DeusExPlayer(Owner);

	if (Player != None)
	{
		if (Player.inHand == Self)
			ChargedPickupEnd(Player);
	}

	Destroy();
}

// ----------------------------------------------------------------------
// state DeActivated
// ----------------------------------------------------------------------

state DeActivated
{
}

// ----------------------------------------------------------------------
// state Activated
// ----------------------------------------------------------------------

state Activated
{
	function Timer()
	{
		local DeusExPlayer Player;

		Player = DeusExPlayer(Owner);
		if (Player != None)
		{
			ChargedPickupUpdate(Player);
			Charge -= CalcChargeDrain(Player);
			if (Charge <= 0)
				UsedUp();
		}
	}

	function BeginState()
	{
		local DeusExPlayer Player;

		Super.BeginState();

		Player = DeusExPlayer(Owner);
		if (Player != None)
		{
			// remove it from our inventory, but save our owner info
			if (bOneUseOnly)
			{
//				Player.DeleteInventory(Self);
				
				// Remove from player's hand
				Player.PutInHand(None);

				SetOwner(Player);
			}

			ChargedPickupBegin(Player);
			SetTimer(0.1, True);
		}
	}

	function EndState()
	{
		local DeusExPlayer Player;

		Super.EndState();

		Player = DeusExPlayer(Owner);
		if (Player != None)
		{
			ChargedPickupEnd(Player);
			SetTimer(0.1, False);
		}
	}

	function Activate()
	{
		// if this is a single-use item, don't allow the player to turn it off
		if (bOneUseOnly)
			return;

		Super.Activate();
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bOneUseOnly=True
     ActivateSound=Sound'DeusExSounds.Pickup.PickupActivate'
     DeActivateSound=Sound'DeusExSounds.Pickup.PickupDeactivate'
     ChargeRemainingLabel="Charge remaining:"
     bActivatable=True
     Charge=2000
}
