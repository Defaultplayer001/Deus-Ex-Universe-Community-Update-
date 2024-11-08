//=============================================================================
// Mission04.
//=============================================================================
class Mission04 expands MissionScript;

// ----------------------------------------------------------------------
// FirstFrame()
// 
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
	local ScriptedPawn pawn;
	local PaulDenton paul;
	local FlagTrigger ftrig;
	local int count;

	if(flags.GetBool('PaulDenton_Dead') && !flags.GetBool('M04RaidTeleportDone')) //== Paul CANNOT die before the raid, period
		flags.SetBool('PaulDenton_Dead',False,, 0);

	if(flags.GetBool('PlayerBailedOutWindow'))
	{
		if(flags.GetBool('M04_Hotel_Cleared'))
			flags.SetBool('PlayerBailedOutWindow', False,, 0);
		else
			flags.SetBool('PaulDenton_Dead', True,, 0);
	}

	Super.FirstFrame();

	if (localURL == "04_NYC_STREET")
	{
		// unhide a bunch of stuff on this flag
		if (flags.GetBool('TalkedToPaulAfterMessage_Played'))
		{
			foreach AllActors(class'ScriptedPawn', pawn)
				if (pawn.IsA('UNATCOTroop') || pawn.IsA('SecurityBot2'))
					pawn.EnterWorld();
		}
	}
	else if (localURL == "04_NYC_FREECLINIC")
	{
		// unhide a bunch of stuff on this flag
		if (flags.GetBool('TalkedToPaulAfterMessage_Played'))
		{
			foreach AllActors(class'ScriptedPawn', pawn)
				if (pawn.IsA('UNATCOTroop'))
					pawn.EnterWorld();
		}
	}
	else if (localURL == "04_NYC_HOTEL")
	{
		// unhide the correct JoJo
		if (flags.GetBool('SandraRenton_Dead') ||
			flags.GetBool('GilbertRenton_Dead'))
		{
			if (!flags.GetBool('JoJoFine_Dead') && !flags.GetBool('MS_JoJoUnhidden'))
			{
				foreach AllActors(class'ScriptedPawn', pawn, 'JoJoInLobby')
					pawn.EnterWorld();

				flags.SetBool('MS_JoJoUnhidden', True,, 5);
			}	
		}

		if(!flags.GetBool('M04RaidTeleportDone'))
		{
			// Lesson the first: Paul should never leave until AFTER the raid
			count = 0;
			foreach AllActors(Class'PaulDenton', paul)
			{
				paul.EnterWorld();
				count++;
			}

			//== Lesson the second: Paul shouldn't be able to die
			if(count == 0)
			{
				log("EPIC FAIL!  Paul is dead, you lose.  Sadness consumes your soul and the air is fraught with the wailings and lamentations of your women.");
				paul = Spawn(class'PaulDenton', None,, vect(-359.133942, -2919.048584, 112.233070));
				paul.Orders = 'Sitting';
			}
		}
		//== Let's get rid of the damn auto-kill flag so we can intelligently track whether or not Paul is dead.
		if(!flags.GetBool('M04_Paul_Check_Fixed'))
		{
			foreach AllActors(Class'FlagTrigger', ftrig)
			{
				if(ftrig.flagName == 'PaulDenton_Dead' && ftrig.flagValue)
				{
					ftrig.bSetFlag = False;
					flags.SetBool('M04_Paul_Check_Fixed', True,, 6);
				}
			}
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
	local int count;
	local MIB mblack;
	local UNATCOTroop troop;
	local PaulDenton paul;

	// If the hotel is clear of hostiles when the player leaves through the window,
	//  remove the "Player Bailed" flag so Paul doesn't wind up dead anyway
	if (localURL == "04_NYC_HOTEL" && flags.GetBool('M04RaidTeleportDone'))
	{
		count = 1;

		foreach AllActors(Class'PaulDenton', paul)
		{
			//== If Paul has left the building, or if he acts like he's safe, he's safe
			if(paul.bHidden || flags.GetBool('M04RaidDone'))
				count = 0;
		}

		if(count > 0)
		{
			count = 0;
			foreach AllActors(Class'UNATCOTroop', troop)
			{
				if(troop.bHidden == False)
					count++;
			}
	
			foreach AllActors(Class'MIB', mblack)
			{
				if(mblack.bHidden == False)
					count += 2;
			}
		}

		if(count <= 0)
		{
			flags.SetBool('M04_Hotel_Cleared', True,, 6);
			flags.SetBool('PlayerBailedOutWindow', False,, 0);
			flags.SetBool('PaulDenton_Dead', False,, 13);
		}
		else
			flags.SetBool('M04_Hotel_Cleared', False,, 6);
	}

	//== For looks, let's remove the items from the player's belt
	//==  before they get sent to MJ12 HQ, rather than after.
	//==  (the items are still in inventory though)
	else if(localURL == "04_NYC_BATTERYPARK")
	{
		for(count=0; count < 10; count++)
		{
			if(DeusExRootWindow(Player.rootWindow).hud.belt.objects[count].GetItem() != None && !DeusExRootWindow(Player.rootWindow).hud.belt.objects[count].GetItem().IsA('NanoKeyRing'))
			{
				DeusExRootWindow(Player.rootWindow).hud.belt.objects[count].GetItem().bInObjectBelt = False;
				DeusExRootWindow(Player.rootWindow).hud.belt.objects[count].GetItem().beltPos = -1;
			}
		}

		DeusExRootWindow(Player.rootWindow).hud.belt.ClearBelt();
	}

	Super.PreTravel();
}

// ----------------------------------------------------------------------
// Timer()
//
// Main state machine for the mission
// ----------------------------------------------------------------------

function Timer()
{
	local ScriptedPawn pawn;
	local SatelliteDish dish;
	local SandraRenton Sandra;
	local GilbertRenton Gilbert;
	local GilbertRentonCarcass GilbertCarc;
	local SandraRentonCarcass SandraCarc;
	local UNATCOTroop troop;
	local Actor A;
	local PaulDenton Paul;
	local FordSchick Ford;
	local int count;

	Super.Timer();

	// do this for every map in this mission
	// if the player is "killed" after a certain flag, he is sent to mission 5
	if (!flags.GetBool('MS_PlayerCaptured'))
	{
		if (flags.GetBool('TalkedToPaulAfterMessage_Played'))
		{
			if (Player.IsInState('Dying'))
			{
				flags.SetBool('MS_PlayerCaptured', True,, 5);

				//== Clear out the object belt now; otherwise the player will see their items being "confiscated" when they wake up in prison
				for(count=0; count < 10; count++)
				{
					if(DeusExRootWindow(Player.rootWindow).hud.belt.objects[count].GetItem() != None && !DeusExRootWindow(Player.rootWindow).hud.belt.objects[count].GetItem().IsA('NanoKeyRing'))
					{
						DeusExRootWindow(Player.rootWindow).hud.belt.objects[count].GetItem().bInObjectBelt = False;
						DeusExRootWindow(Player.rootWindow).hud.belt.objects[count].GetItem().beltPos = -1;
					}
				}
				DeusExRootWindow(Player.rootWindow).hud.belt.ClearBelt();

				Player.GoalCompleted('EscapeToBatteryPark');
				Level.Game.SendPlayer(Player, "05_NYC_UNATCOMJ12Lab");
			}
		}
	}

	if (localURL == "04_NYC_HOTEL")
	{
		// check to see if the player has killed either Sandra or Gilbert
		if (!flags.GetBool('PlayerKilledRenton'))
		{
			count = 0;
			foreach AllActors(class'SandraRenton', Sandra)
				count++;

			foreach AllActors(class'GilbertRenton', Gilbert)
				count++;

			foreach AllActors(class'SandraRentonCarcass', SandraCarc)
				if (SandraCarc.KillerBindName == "JCDenton")
					count = 0;

			foreach AllActors(class'GilbertRentonCarcass', GilbertCarc)
				if (GilbertCarc.KillerBindName == "JCDenton")
					count = 0;

			if (count < 2)
			{
				flags.SetBool('PlayerKilledRenton', True,, 5);
				foreach AllActors(class'Actor', A, 'RentonsHatePlayer')
					A.Trigger(Self, Player);
			}
		}

		if (!flags.GetBool('M04RaidTeleportDone') &&
			flags.GetBool('ApartmentEntered'))
		{
			if (flags.GetBool('NSFSignalSent'))
			{
				foreach AllActors(class'ScriptedPawn', pawn)
				{
					if (pawn.IsA('UNATCOTroop') || pawn.IsA('MIB'))
						pawn.EnterWorld();
					else if (pawn.IsA('SandraRenton') || pawn.IsA('GilbertRenton') || pawn.IsA('HarleyFilben'))
						pawn.LeaveWorld();
				}

				foreach AllActors(class'PaulDenton', Paul)
				{
					Player.StartConversationByName('TalkedToPaulAfterMessage', Paul, False, False);
					break;
				}

				flags.SetBool('M04RaidTeleportDone', True,, 5);
			}
		}

		// make the MIBs mortal
		if (!flags.GetBool('MS_MIBMortal'))
		{
			if (flags.GetBool('TalkedToPaulAfterMessage_Played'))
			{
				foreach AllActors(class'ScriptedPawn', pawn)
					if (pawn.IsA('MIB'))
						pawn.bInvincible = False;

				flags.SetBool('MS_MIBMortal', True,, 5);
			}
		}

		// unhide the correct JoJo
		if (!flags.GetBool('MS_JoJoUnhidden') &&
			(flags.GetBool('SandraWaitingForJoJoBarks_Played') ||
			flags.GetBool('GilbertWaitingForJoJoBarks_Played')))
		{
			if (!flags.GetBool('JoJoFine_Dead'))
			{
				foreach AllActors(class'ScriptedPawn', pawn, 'JoJoUpstairs')
					pawn.EnterWorld();

				flags.SetBool('MS_JoJoUnhidden', True,, 5);
			}
		}

		// unhide the correct JoJo
		if (!flags.GetBool('MS_JoJoUnhidden') &&
			(flags.GetBool('M03OverhearSquabble_Played') &&
			!flags.GetBool('JoJoOverheard_Played') &&
			flags.GetBool('JoJoEntrance')))
		{
			if (!flags.GetBool('JoJoFine_Dead'))
			{
				foreach AllActors(class'ScriptedPawn', pawn, 'JoJoUpstairs')
					pawn.EnterWorld();

				flags.SetBool('MS_JoJoUnhidden', True,, 5);
			}
		}

		// trigger some stuff based on convo flags
		if (flags.GetBool('JoJoOverheard_Played') && !flags.GetBool('MS_JoJo1Triggered'))
		{
			if (flags.GetBool('GaveRentonGun'))
			{
				foreach AllActors(class'Actor', A, 'GilbertAttacksJoJo')
					A.Trigger(Self, Player);
			}
			else
			{
				foreach AllActors(class'Actor', A, 'JoJoAttacksGilbert')
					A.Trigger(Self, Player);
			}

			flags.SetBool('MS_JoJo1Triggered', True,, 5);
		}

		// trigger some stuff based on convo flags
		if (flags.GetBool('JoJoAndSandraOverheard_Played') && !flags.GetBool('MS_JoJo2Triggered'))
		{
			foreach AllActors(class'Actor', A, 'SandraLeaves')
				A.Trigger(Self, Player);

			flags.SetBool('MS_JoJo2Triggered', True,, 5);
		}

		// trigger some stuff based on convo flags
		if (flags.GetBool('JoJoAndGilbertOverheard_Played') && !flags.GetBool('MS_JoJo3Triggered'))
		{
			foreach AllActors(class'Actor', A, 'JoJoAttacksGilbert')
				A.Trigger(Self, Player);

			flags.SetBool('MS_JoJo3Triggered', True,, 5);
		}
	}
	else if (localURL == "04_NYC_NSFHQ")
	{
		// rotate the dish when the computer sets the flag
		if (!flags.GetBool('MS_Dish1Rotated'))
		{
			if (flags.GetBool('Dish1InPosition'))
			{
				foreach AllActors(class'SatelliteDish', dish, 'Dish1')
					dish.DesiredRotation.Yaw = 49152;

				flags.SetBool('MS_Dish1Rotated', True,, 5);
			}
		}

		// rotate the dish when the computer sets the flag
		if (!flags.GetBool('MS_Dish2Rotated'))
		{
			if (flags.GetBool('Dish2InPosition'))
			{
				foreach AllActors(class'SatelliteDish', dish, 'Dish2')
					dish.DesiredRotation.Yaw = 0;

				flags.SetBool('MS_Dish2Rotated', True,, 5);
			}
		}

		// rotate the dish when the computer sets the flag
		if (!flags.GetBool('MS_Dish3Rotated'))
		{
			if (flags.GetBool('Dish3InPosition'))
			{
				foreach AllActors(class'SatelliteDish', dish, 'Dish3')
					dish.DesiredRotation.Yaw = 16384;

				flags.SetBool('MS_Dish3Rotated', True,, 5);
			}
		}

		// set a flag when all dishes are rotated
		if (!flags.GetBool('CanSendSignal'))
		{
			if (flags.GetBool('Dish1InPosition') &&
				flags.GetBool('Dish2InPosition') &&
				flags.GetBool('Dish3InPosition'))
				flags.SetBool('CanSendSignal', True,, 5);
		}

		// count non-living troops
		if (!flags.GetBool('MostWarehouseTroopsDead'))
		{
			count = 0;
			foreach AllActors(class'UNATCOTroop', troop)
				count++;

			// if two or less are still alive
			if (count <= 2)
				flags.SetBool('MostWarehouseTroopsDead', True);
		}
	}
	else if(localURL == "04_NYC_SMUG")
	{
		if(flags.getBool('FordSchickRescued'))
		{
			if(!flags.getBool('M04_FordShick_Appeared'))
			{
				foreach AllActors(class'FordSchick', Ford)
				{
					Ford.EnterWorld();
					flags.SetBool('M04_FordSchick_Appeared', True,, 5);
				}
			}
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
