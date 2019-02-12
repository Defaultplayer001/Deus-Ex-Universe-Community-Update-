//=============================================================================
// Mission05.
//=============================================================================
class Mission05 extends MissionScript;

// ----------------------------------------------------------------------
// FirstFrame()
// 
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
	local PaulDentonCarcass carc;
	local PaulDenton Paul;
	local Terrorist T;
	local Inventory item, nextItem;
	local SpawnPoint SP;
	local AnnaNavarre Anna;
	local DataCube dCube;

	Super.FirstFrame();

	if (localURL == "05_NYC_UNATCOMJ12LAB")
	{
		// make sure this goal is completed
		Player.GoalCompleted('EscapeToBatteryPark');

		// delete Paul's carcass if he's still alive
		if (!flags.GetBool('PaulDenton_Dead'))
		{
			foreach AllActors(class'PaulDentonCarcass', carc)
				carc.Destroy();
		}

		// if the player has already talked to Paul, delete him
		if (flags.GetBool('M05PaulDentonDone') ||
			flags.GetBool('PlayerBailedOutWindow'))
		{
			foreach AllActors(class'PaulDenton', Paul)
				Paul.Destroy();
		}

		// if Miguel is not following the player, delete him
		if (flags.GetBool('MeetMiguel_Played') &&
			!flags.GetBool('MiguelFollowing'))
		{
			foreach AllActors(class'Terrorist', T)
				if (T.BindName == "Miguel")
					T.Destroy();
		}

		//== There's a data cube that likes to fall through the level
		//==  let's spawn a new copy, only this time inside the level boundaries
		//==  Worst case scenario is there's a datacube on top of another
		if(!flags.GetBool('M05_Datacube_Replaced'))
		{
			dCube = spawn(class'DataCube', None,, vect(-279.169556,432.570007,-100.000000));
			dCube.textTag = '05_Datacube02';
			dCube.textPackage = "DeusExText";

			flags.SetBool('M05_Datacube_Replaced',True);
		}

		// remove the player's inventory and put it in a room
		// also, heal the player up to 50% of his total health
		if (!flags.GetBool('MS_InventoryRemoved'))
		{
			Player.HealthHead = Max(50, Player.HealthHead);
			Player.HealthTorso =  Max(50, Player.HealthTorso);
			Player.HealthLegLeft =  Max(50, Player.HealthLegLeft);
			Player.HealthLegRight =  Max(50, Player.HealthLegRight);
			Player.HealthArmLeft =  Max(50, Player.HealthArmLeft);
			Player.HealthArmRight =  Max(50, Player.HealthArmRight);
			Player.GenerateTotalHealth();

			//== Y|y: There is an odd glitch with laser sights which can generate a "ghost" laser
			//==  so we need to force the laser off
			if(DeusExWeapon(Player.inHand) != None)
				DeusExWeapon(Player.inHand).LaserOff();

			if (Player.Inventory != None)
			{
				item      = Player.Inventory;
				nextItem  = None;

				foreach AllActors(class'SpawnPoint', SP, 'player_inv')
				{
					// Find the next item we can process.
					while((item != None) && (item.IsA('NanoKeyRing') || (!item.bDisplayableInv)))
						item = item.Inventory;

					if (item != None)
					{
						nextItem = item.Inventory;

						//== Y|y: Turn off any charged pickups we were using and remove the associated HUD.  Per Lork on the OTP forums
						if (item.IsA('ChargedPickup'))
							ChargedPickup(item).ChargedPickupEnd(Player);

						Player.DeleteInventory(item);

						item.DropFrom(SP.Location);

						// restore any ammo amounts for a weapon to default; Y|y: except for grenades
						if (item.IsA('Weapon') && (Weapon(item).AmmoType != None) && !item.IsA('WeaponLAM') && !item.IsA('WeaponGasGrenade') && !item.IsA('WeaponEMPGrenade') && !item.IsA('WeaponNanoVirusGrenade'))
							Weapon(item).PickupAmmoCount = Weapon(item).Default.PickupAmmoCount;
					}
					
					if (nextItem == None)
						break;	
					else
						item = nextItem;
				}
			}
			
			flags.SetBool('MS_InventoryRemoved', True,, 6);
		}
	}
	else if (localURL == "05_NYC_UNATCOHQ")
	{
		// if Miguel is following the player, unhide him
		if (flags.GetBool('MiguelFollowing'))
		{
			foreach AllActors(class'Terrorist', T)
				if (T.BindName == "Miguel")
					T.EnterWorld();
		}

		// make Anna not flee in this mission
		foreach AllActors(class'AnnaNavarre', Anna)
			Anna.MinHealth = 0;
	}
	else if (localURL == "05_NYC_UNATCOISLAND")
	{
		// if Miguel is following the player, unhide him
		if (flags.GetBool('MiguelFollowing'))
		{
			foreach AllActors(class'Terrorist', T)
				if (T.BindName == "Miguel")
					T.EnterWorld();
		}
	}
}

// ----------------------------------------------------------------------
// PreTravel()
// 
// Set flags upon exit of a certain map
// ----------------------------------------------------------------------

function PreTravel()
{
	Super.PreTravel();
}

// ----------------------------------------------------------------------
// Timer()
//
// Main state machine for the mission
// ----------------------------------------------------------------------

function Timer()
{
	local AnnaNavarre Anna;
	local WaltonSimons Walton;
	local DeusExMover M;
	local AllianceTrigger altrig;

	Super.Timer();

	if (localURL == "05_NYC_UNATCOHQ")
	{
		// unlock a door
		if (flags.GetBool('CarterUnlock') &&
			!flags.GetBool('MS_DoorUnlocked'))
		{
			foreach AllActors(class'DeusExMover', M, 'supplydoor')
			{
				M.bLocked = False;
				M.lockStrength = 0.0;
			}

			flags.SetBool('MS_DoorUnlocked', True,, 6);
		}

		// kill Anna when a flag is set
		if (flags.GetBool('annadies') &&
			!flags.GetBool('MS_AnnaKilled'))
		{
			foreach AllActors(class'AnnaNavarre', Anna)
			{
				Anna.HealthTorso = 0;
				Anna.Health = 0;
				Anna.TakeDamage(1, Anna, Anna.Location, vect(0,0,0), 'Shot');
			}

			flags.SetBool('MS_AnnaKilled', True,, 6);
		}

		// make Anna attack the player after a convo is played
		if (flags.GetBool('M05AnnaAtExit_Played') &&
			!flags.GetBool('MS_AnnaAttacking'))
		{
			foreach AllActors(class'AnnaNavarre', Anna)
				Anna.SetOrders('Attacking', '', True);

			flags.SetBool('MS_AnnaAttacking', True,, 6);
		}

		// unhide Walton Simons
		if (flags.GetBool('simonsappears') &&
			!flags.GetBool('MS_SimonsUnhidden'))
		{
			foreach AllActors(class'WaltonSimons', Walton)
				Walton.EnterWorld();

			flags.SetBool('MS_SimonsUnhidden', True,, 6);
		}

		// hide Walton Simons
		if ((flags.GetBool('M05MeetManderley_Played') ||
			flags.GetBool('M05SimonsAlone_Played')) &&
			!flags.GetBool('MS_SimonsHidden'))
		{
			foreach AllActors(class'WaltonSimons', Walton)
				Walton.LeaveWorld();

			flags.SetBool('MS_SimonsHidden', True,, 6);
		}

		// mark a goal as completed
		if (flags.GetBool('KnowsAnnasKillphrase1') &&
			flags.GetBool('KnowsAnnasKillphrase2') &&
			!flags.GetBool('MS_KillphraseGoalCleared'))
		{
			Player.GoalCompleted('FindAnnasKillphrase');
			flags.SetBool('MS_KillphraseGoalCleared', True,, 6);
		}

		// clear a goal when anna is out of commision
		if (flags.GetBool('AnnaNavarre_Dead') &&
			!flags.GetBool('MS_EliminateAnna'))
		{
			Player.GoalCompleted('EliminateAnna');
			flags.SetBool('MS_EliminateAnna', True,, 6);
		}
	}
	else if (localURL == "05_NYC_UNATCOMJ12LAB")
	{
		// After the player talks to Paul, start a datalink
		if (!flags.GetBool('MS_DL_Played') &&
			flags.GetBool('PaulInMedLab_Played'))
		{
			Player.StartDataLinkTransmission("DL_Paul");
			flags.SetBool('MS_DL_Played', True,, 6);
		}

		//== Once we modify the bot we don't want it to suddenly hate us if we break a window
		if(flags.GetBool('botmodified') && !flags.GetBool('M05_BotAlliance_Fixed'))
		{
			foreach AllActors(Class'AllianceTrigger', altrig, 'botorders')
			{
				altrig.Destroy();
				flags.SetBool('M05_BotAlliance_Fixed',True);
			}
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
