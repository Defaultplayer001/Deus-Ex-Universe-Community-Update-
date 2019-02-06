//=============================================================================
// Mission03.
//=============================================================================
class Mission03 expands MissionScript;

// ----------------------------------------------------------------------
// FirstFrame()
// 
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
	local Terrorist T;
	local BlackHelicopter chopper;
	local SecurityBot3 bot;
	local PaulDenton Paul;
	local SecurityCamera cam;
	local AutoTurret turret;
	local GuntherHermann Gunther;
	local UNATCOTroop troop;

	Super.FirstFrame();

	if (localURL == "03_NYC_AIRFIELDHELIBASE")
	{
		// delete terrorists and unhide reinforcements
		if (flags.GetBool('MeetLebedev_Played') ||
			flags.GetBool('JuanLebedev_Dead'))
		{
			foreach AllActors(class'Terrorist', T)
				T.Destroy();

			foreach AllActors(class'SecurityBot3', bot)
				bot.Destroy();

			foreach AllActors(class'UNATCOTroop', troop, 'UNATCOTroop')
				troop.EnterWorld();
		}
	}
	else if (localURL == "03_NYC_AIRFIELD")
	{
		// delete terrorists and unhide reinforcements and unhide the helicopter
		// also, turn off all security cameras
		if (flags.GetBool('MeetLebedev_Played') ||
			flags.GetBool('JuanLebedev_Dead'))
		{
			foreach AllActors(class'Terrorist', T)
				T.Destroy();

			foreach AllActors(class'SecurityBot3', bot)
				bot.Destroy();

			foreach AllActors(class'UNATCOTroop', troop, 'UNATCOTroop')
				troop.EnterWorld();

			foreach AllActors(class'BlackHelicopter', chopper)
				chopper.EnterWorld();

			foreach AllActors(class'SecurityCamera', cam)
				cam.UnTrigger(None, None);

			foreach AllActors(class'AutoTurret', turret)
				turret.UnTrigger(None, None);

			foreach AllActors(class'GuntherHermann', Gunther)
				Gunther.EnterWorld();
		}
	}
	else if (localURL == "03_NYC_HANGAR")
	{
		// delete terrorists and unhide reinforcements
		if (flags.GetBool('MeetLebedev_Played') ||
			flags.GetBool('JuanLebedev_Dead'))
		{
			foreach AllActors(class'Terrorist', T)
				T.Destroy();

			foreach AllActors(class'SecurityBot3', bot)
				bot.Destroy();

			foreach AllActors(class'PaulDenton', Paul)
				Paul.Destroy();

			foreach AllActors(class'UNATCOTroop', troop, 'UNATCOTroop')
				troop.EnterWorld();
		}
	}
	else if (localURL == "03_NYC_747")
	{
		// delete terrorists
		if (flags.GetBool('MeetLebedev_Played') ||
			flags.GetBool('JuanLebedev_Dead'))
		{
			foreach AllActors(class'Terrorist', T)
				T.Destroy();

			foreach AllActors(class'SecurityBot3', bot)
				bot.Destroy();
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
	local WaltonSimons Walton;
	local AnnaNavarre Anna;
	local GuntherHermann Gunther;
	local JuanLebedev Juan;
	local JuanLebedevCarcass carc;
	local ThugMale Thug;
	local ThugMale2 Thug2;
	local ScriptedPawn pawn;
	local Terrorist T;
	local int count;
	local DeusExMover M;
	local bool bCarcFound, bJuanFound;

	Super.Timer();

	if (localURL == "03_NYC_UNATCOHQ")
	{
		// make Walton Simons walk to the cell
		if (!flags.GetBool('MS_SimonsWalking'))
		{
			if (flags.GetBool('SimonsOverheard_Played'))
			{
				foreach AllActors(class'WaltonSimons', Walton)
					Walton.SetOrders('GoingTo', 'SimonsInterrogating', True);

				flags.SetBool('MS_SimonsWalking', True,, 4);
			}
		}

		// set a flag when Walton Simons gets to his point
		if (!flags.GetBool('SimonsInterrogating'))
		{
			if (flags.GetBool('MS_SimonsWalking'))
			{
				foreach AllActors(class'WaltonSimons', Walton)
					if (Walton.IsInState('Standing'))
						flags.SetBool('SimonsInterrogating', True,, 4);
			}
		}

		// unlock a door when a flag is set
		if (!flags.GetBool('MS_MoverUnlocked') && flags.GetBool('UnlockDoor'))
		{
			foreach AllActors(class'DeusExMover', M, 'Manderley_Office')
			{
				M.bLocked = False;
				M.lockStrength = 0.0;
			}

			flags.SetBool('MS_MoverUnlocked', True,, 4);
		}

		if (flags.GetBool('AnnaAtDesk') &&
			!flags.GetBool('MS_AnnaDeskHome'))
		{
			foreach AllActors(class'AnnaNavarre', Anna)
				Anna.SetHomeBase(Anna.Location, Anna.Rotation);
			flags.SetBool('MS_AnnaDeskHome', True,, 4);
		}

		if (flags.GetBool('AnnaInOffice') &&
			!flags.GetBool('MS_AnnaOfficeHome'))
		{
			foreach AllActors(class'AnnaNavarre', Anna)
				Anna.SetHomeBase(Anna.Location, Anna.Rotation);
			flags.SetBool('MS_AnnaOfficeHome', True,, 4);
		}
	}
	else if (localURL == "03_NYC_AIRFIELDHELIBASE")
	{
		// check for Ambrosia Barrels being tagged
		if (!flags.GetBool('Barrel1Checked'))
		{
			if (flags.GetBool('HelicopterBaseAmbrosia'))
			{
				count = 1;
				if (flags.GetBool('BoatDocksAmbrosia'))
					count++;
				if (flags.GetBool('747Ambrosia'))
					count++;

				if (count == 1)
					Player.StartDataLinkTransmission("DL_TaggedOne");
				else if (count == 2)
					Player.StartDataLinkTransmission("DL_TaggedTwo");
				else if (count == 3)
					Player.StartDataLinkTransmission("DL_TaggedThree");
					
				flags.SetBool('Barrel1Checked', True,, 4);
			}
		}
	}
	else if (localURL == "03_NYC_AIRFIELD")
	{
		// check for Ambrosia Barrels being tagged
		if (!flags.GetBool('Barrel2Checked'))
		{
			if (flags.GetBool('BoatDocksAmbrosia'))
			{
				count = 1;
				if (flags.GetBool('HelicopterBaseAmbrosia'))
					count++;
				if (flags.GetBool('747Ambrosia'))
					count++;

				if (count == 1)
					Player.StartDataLinkTransmission("DL_TaggedOne");
				else if (count == 2)
					Player.StartDataLinkTransmission("DL_TaggedTwo");
				else if (count == 3)
					Player.StartDataLinkTransmission("DL_TaggedThree");
					
				flags.SetBool('Barrel2Checked', True,, 4);
			}
		}

		// unhide Gunther
		if (!flags.GetBool('MS_GuntherUnhidden'))
		{
			if (flags.GetBool('MeetLebedev_Played') ||
				flags.GetBool('JuanLebedev_Dead'))
			{
				foreach AllActors(class'GuntherHermann', Gunther)
					Gunther.EnterWorld();
				flags.SetBool('MS_GuntherUnhidden', True,, 4);
			}
		}
	}
	else if (localURL == "03_NYC_747")
	{
		// check for Lebedev's death
		if (flags.GetBool('JuanLebedev_Dead') &&
			!flags.GetBool('MS_Anna747Unhidden'))
		{
			foreach AllActors(class'AnnaNavarre', Anna)
				Anna.EnterWorld();

			flags.SetBool('MS_Anna747Unhidden', True,, 4);
		}

		// check for Ambrosia Barrels being tagged
		if (!flags.GetBool('Barrel3Checked'))
		{
			if (flags.GetBool('747Ambrosia'))
			{
				count = 1;
				if (flags.GetBool('HelicopterBaseAmbrosia'))
					count++;
				if (flags.GetBool('BoatDocksAmbrosia'))
					count++;

				if (count == 1)
					Player.StartDataLinkTransmission("DL_TaggedOne");
				else if (count == 2)
					Player.StartDataLinkTransmission("DL_TaggedTwo");
				else if (count == 3)
					Player.StartDataLinkTransmission("DL_TaggedThree");
					
				flags.SetBool('Barrel3Checked', True,, 4);
			}
		}

		// unhide Anna
		if (!flags.GetBool('MS_AnnaUnhidden'))
		{
			if (flags.GetBool('MeetLebedev_Played') ||
				flags.GetBool('JuanLebedev_Dead'))
			{
				foreach AllActors(class'AnnaNavarre', Anna)
					Anna.EnterWorld();
				flags.SetBool('MS_AnnaUnhidden', True,, 4);
			}
		}

		// check to see if the player has killed Lebedev
		if (!flags.GetBool('PlayerKilledLebedev') &&
			!flags.GetBool('AnnaKilledLebedev'))
		{
			bCarcFound = False;
			foreach AllActors(class'JuanLebedevCarcass', carc)
			{
				bCarcFound = True;

				if ((carc.KillerBindName == "JCDenton") || (carc.KillerBindName == ""))
				{
					Player.GoalCompleted('AssassinateLebedev');
					flags.SetBool('PlayerKilledLebedev', True,, 6);
				}
				else if (carc.KillerBindName == "AnnaNavarre")
					flags.SetBool('AnnaKilledLebedev', True,, 6);
				else
					flags.SetBool('JuanLebedev_Dead', True,, 0);
			}

			bJuanFound = False;
			foreach AllActors(class'JuanLebedev', Juan)
				bJuanFound = True;

			if (!bCarcFound && !bJuanFound && flags.GetBool('JuanLebedev_Dead'))
				flags.SetBool('PlayerKilledLebedev', True,, 6);
		}
	}
	else if (localURL == "03_NYC_MOLEPEOPLE")
	{
		// set a flag when there are less than 4 mole people alive
		if (!flags.GetBool('MolePeopleSlaughtered'))
		{
			count = 0;
			foreach AllActors(class'ScriptedPawn', pawn, 'MolePeople')
				count++;

			if (count < 4)
				flags.SetBool('MolePeopleSlaughtered', True,, 4);
		}

		// set a flag when there are less than 3 terrorists alive
		if (!flags.GetBool('MoleTerroristsDefeated'))
		{
			count = 0;
			foreach AllActors(class'Terrorist', T, 'MoleTerrorist')
				count++;

			if (count < 3)
				flags.SetBool('MoleTerroristsDefeated', True,, 4);
		}
	}
	else if (localURL == "03_NYC_BROOKLYNBRIDGESTATION")
	{
		// set a flag when the gang's all dead
		if (!flags.GetBool('JugHeadGangDefeated'))
		{
			count = 0;
			foreach AllActors(class'ThugMale2', Thug2, 'ThugMale2')
				 count++;

			 if (count == 0)
				flags.SetBool('JugHeadGangDefeated', True,, 4);
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
