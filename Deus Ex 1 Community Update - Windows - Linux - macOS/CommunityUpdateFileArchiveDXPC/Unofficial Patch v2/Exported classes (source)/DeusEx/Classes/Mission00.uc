//=============================================================================
// Mission00.
//=============================================================================
class Mission00 extends MissionScript;

// ----------------------------------------------------------------------
// FirstFrame()
// 
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
	local UNATCOTroop troop;
	local LAM lam;

	Super.FirstFrame();

	// zero the player's skill points
	Player.SkillPointsTotal = 0;
	Player.SkillPointsAvail = 0;

	if (localURL == "00_TRAINING")
	{
		// knock this guy out
		foreach AllActors(class'UNATCOTroop', troop, 'Test_Subject')
		{
			troop.HealthTorso = 0;
			troop.Health = 0;
			troop.bStunned = True;
			troop.TakeDamage(1, troop, troop.Location, vect(0,0,0), 'KnockedOut');
		}
	}
	else if (localURL == "00_TRAININGCOMBAT")
	{
		// fool a lam into thinking that the player set it
		foreach AllActors(class'LAM', lam, 'Bot1LAM')
			lam.SetOwner(Player);
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
	local int count;
	local Containers crate;
	local BobPage Bob;
	local JaimeReyes Jaime;
	local SecurityBot2 bot;
	local LAM lam;
	local Skill aSkill;

	Super.Timer();

	if (localURL == "00_TRAINING")
	{
		// delete the player's inventory in case he tries to keep it
		if (flags.GetBool('MunitionsTrooperReady'))
			RemoveAllInventory();

		// see if the player has broken all the crates
		if (!flags.GetBool('MS_CratesBroken'))
		{
			count = 0;
			foreach AllActors(class'Containers', crate)
				if ((crate.Tag == 'Cratepick1') || (crate.Tag == 'Cratepick2'))
					count++;

			// if the player breaks one of the crates
			if (count < 2)
			{
				Player.StartDataLinkTransmission("DL_Lockpick");
				flags.SetBool('MS_CratesBroken', True);
			}
		}

		// hide holo-Bob
		if (flags.GetBool('M00MeetPage_Played') &&
			!flags.GetBool('MS_PageHidden'))
		{
			foreach AllActors(class'BobPage', Bob, 'holobob')
				Bob.LeaveWorld();

			flags.SetBool('MS_PageHidden', True);
		}
	}
	else if (localURL == "00_TRAININGCOMBAT")
	{
		// delete the player's inventory in case he tries to keep it
		if (flags.GetBool('MunitionsTrooperReady'))
			RemoveAllInventory();

		// start a datalink when a bot is destroyed
		if (!flags.GetBool('MS_LAMBot1Destroyed'))
		{
			count = 0;
			foreach AllActors(class'SecurityBot2', bot, 'LAMBot1')
				count++;

			if (count == 0)
			{
				Player.StartDataLinkTransmission("DL_ReleaseBot2");
				flags.SetBool('MS_LAMBot1Destroyed', True);
			}
		}

		// start a datalink when a bot is destroyed
		if (!flags.GetBool('MS_LAMBot2Destroyed'))
		{
			count = 0;
			foreach AllActors(class'SecurityBot2', bot, 'LAMBot2')
				count++;

			if (count == 0)
			{
				Player.StartDataLinkTransmission("DL_DemolitionLast");
				flags.SetBool('MS_LAMBot2Destroyed', True);
			}
		}

		// start a datalink when all LAMs are destroyed
		if (!flags.GetBool('MS_LAMsDestroyed'))
		{
			count = 0;
			foreach AllActors(class'LAM', lam, 'DefuseLAM')
				count++;

			if (count == 0)
			{
				Player.StartDataLinkTransmission("DL_DefuseFinish");
				flags.SetBool('MS_LAMsDestroyed', True);
			}
		}

		// increase the player's skill
		if (flags.GetBool('DL_RifleRangeShot1_Played') &&
			!flags.GetBool('MS_SkillIncreased'))
		{
			// max out the rifle skill
			if (Player.SkillSystem != None)
			{
				aSkill = Player.SkillSystem.GetSkillFromClass(class'SkillWeaponRifle');
				if (aSkill != None)
					aSkill.CurrentLevel = 3;
			}

			flags.SetBool('MS_SkillIncreased', True);
		}
	}
	else if (localURL == "00_TRAININGFINAL")
	{
		// unhide holo-Jaime
		if (flags.GetBool('JaimeAppears') &&
			!flags.GetBool('MS_ReyesUnhidden'))
		{
			foreach AllActors(class'JaimeReyes', Jaime, 'holojaime')
				Jaime.EnterWorld();

			flags.SetBool('MS_ReyesUnhidden', True);
		}

		// hide holo-Jaime
		if (flags.GetBool('JaimeBark_Played') &&
			!flags.GetBool('MS_ReyesHidden'))
		{
			foreach AllActors(class'JaimeReyes', Jaime, 'holojaime')
				Jaime.LeaveWorld();

			flags.SetBool('MS_ReyesHidden', True);
		}
	}
}

function RemoveAllInventory()
{
	local Inventory item, nextItem, lastItem;

	if (Player.Inventory != None)
	{
		item = Player.Inventory;
		nextItem = item.Inventory;
		lastItem = item;

		do
		{
			if ((item != None) && item.bDisplayableInv || item.IsA('Ammo'))
			{
				// make sure everything is turned off
				if (item.IsA('DeusExWeapon'))
				{
					DeusExWeapon(item).ScopeOff();
					DeusExWeapon(item).LaserOff();
				}
				if (item.IsA('DeusExPickup'))
				{
					if (DeusExPickup(item).bActive)
						DeusExPickup(item).Activate();
				}

   			if (item.IsA('ChargedPickup'))
					Player.RemoveChargedDisplay(ChargedPickup(item));

				Player.DeleteInventory(item);
				item.Destroy();
				item = Player.Inventory;
			}
			else
				item = nextItem;

			if (item != None)
				nextItem = item.Inventory;
		}
		until ((item == None) || (item == lastItem));
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
