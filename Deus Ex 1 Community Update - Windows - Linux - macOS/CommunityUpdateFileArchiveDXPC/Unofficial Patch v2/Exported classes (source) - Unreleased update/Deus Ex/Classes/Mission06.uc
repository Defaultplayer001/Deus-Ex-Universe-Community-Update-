//=============================================================================
// Mission06.
//=============================================================================
class Mission06 expands MissionScript;

var float fireTime;

// ----------------------------------------------------------------------
// FirstFrame()
// 
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
	local ScriptedPawn pawn;
	local BlackHelicopter chopper;
	local MJ12Commando commando;
	local DeusExCarcass carc;
	local DeusExDecoration deco;
	local HKMilitary mil;
	local SpiderBot bot;
	local BookOpen book;
	local float rnd;
	local Keypad3 pad;
	local AllianceTrigger altrig;
	local MJ12Troop mjtroop;
	local Mover thecase;
	local FlagTrigger ftrig;

	Super.FirstFrame();

	if (localURL == "06_HONGKONG_VERSALIFE")
	{
		if (flags.GetBool('M07Briefing_Played'))
		{
			foreach AllActors(class'MJ12Commando', commando)
				commando.EnterWorld();
		}
	}
	else if (localURL == "06_HONGKONG_WANCHAI_STREET")
	{
		if(!flags.GetBool('MJ12_Troops_Silent'))
		{
			foreach AllActors(class'MJ12Troop', mjtroop)
			{
				mjtroop.bPlayIdle = False;
			}
			flags.SetBool('MJ12_Troops_Silent', True,, 8);
		}

		if(!flags.GetBool('DisplayCase_Moveable'))
		{
			foreach AllActors(class'Mover', thecase, 'Dispalycase')
			{
				if(VSize(thecase.KeyPos[1] - thecase.KeyPos[0]) <= 4)
				{
					thecase.KeyPos[1].Z = -136.000000;
					flags.SetBool('DisplayCase_WasUnMoveable',True); //== For debug purposes
				}

				flags.SetBool('DisplayCase_Moveable',True);
			}
		}
	}
	else if (localURL == "06_HONGKONG_WANCHAI_CANAL")
	{
		if (!flags.GetBool('Supervisor01_Dead') &&
			flags.GetBool('HaveROM'))
		{
			foreach AllActors(class'DeusExCarcass', carc, 'John_Smith_Body')
				carc.bHidden = False;
		}
	}
	else if (localURL == "06_HONGKONG_MJ12LAB")
	{
		if (flags.GetBool('M07Briefing_Played'))
		{
			foreach AllActors(class'MJ12Commando', commando)
				commando.EnterWorld();
			foreach AllActors(class'SpiderBot', bot)
				bot.EnterWorld();
			foreach AllActors(class'Keypad3', pad)
			{
				if (pad.Tag == 'DummyKeypad_02')
					pad.Destroy();
				else if (pad.Tag == 'RealKeypad_02')
					pad.bHidden = False;
			}
		}
	}
	else if (localURL == "06_HONGKONG_TONGBASE")
	{
		if (flags.GetBool('Versalife_Done'))
		{
			foreach AllActors(class'ScriptedPawn', pawn)
			{
				if (pawn.IsA('PaulDenton'))
					pawn.EnterWorld();
				else if (pawn.IsA('TriadRedArrow') && (pawn.Tag == 'TriadRedArrow'))
					pawn.EnterWorld();
			}
		}

		if (flags.GetBool('JaimeRecruited') &&
			flags.GetBool('Versalife_Done'))
		{
			foreach AllActors(class'ScriptedPawn', pawn)
			{
				if (pawn.IsA('JaimeReyes'))
					pawn.EnterWorld();
			}
		}

		if (flags.GetBool('JacobsonRecruited'))
		{
			foreach AllActors(class'ScriptedPawn', pawn)
			{
				if (pawn.IsA('AlexJacobson'))
					pawn.EnterWorld();
			}
		}
	}
	else if (localURL == "06_HONGKONG_WANCHAI_UNDERWORLD")
	{
		if (flags.GetBool('QuickLetPlayerIn'))
		{
			foreach AllActors(class'MJ12Commando', commando, 'MJ12Commando')
				commando.EnterWorld();
		}

		if (flags.GetBool('TriadCeremony_Played'))
		{
			flags.SetBool('DragonHeadsInLuckyMoney', True,, 8);

			foreach AllActors(class'DeusExCarcass', carc)
				carc.Destroy();
		}

		if (flags.GetBool('DragonHeadsInLuckyMoney') &&
			!flags.GetBool('MS_ChenTeleported'))
		{
			foreach AllActors(class'ScriptedPawn', pawn)
			{
				if (pawn.IsA('GordonQuick'))
					pawn.EnterWorld();
				else if (pawn.IsA('MaxChen'))
					TeleportPawn(pawn, 'ChenAtBar', 'Standing');
			}

			flags.SetBool('MS_ChenTeleported', True,, 8);
		}
	}
	else if (localURL == "06_HONGKONG_WANCHAI_GARAGE")
	{
		if (flags.GetBool('M07Briefing_Played'))
		{
			foreach AllActors(class'HKMilitary', mil, 'RumbleCops')
				mil.Destroy();

			foreach AllActors(class'DeusExCarcass', carc)
			{
				if (carc.IsA('HKMilitaryCarcass'))
					carc.Destroy();
				else if (carc.IsA('TriadLumPathCarcass'))
					carc.Destroy();
				else if (carc.IsA('TriadLumPath2Carcass'))
					carc.Destroy();
			}
			foreach AllActors(class'DeusExDecoration', deco)
			{
				if (deco.IsA('Van') && (deco.Tag == 'Van01'))
					deco.Destroy();
				else if (deco.IsA('CarWrecked'))
					deco.Destroy();
				else if (deco.IsA('RoadBlock'))
					deco.Destroy();
			}
		}
	}
	else if (localURL == "06_HONGKONG_STORAGE")
	{
		if (!flags.GetBool('Keypad_Deactivator_Placed'))
		{
			ftrig = spawn(Class'FlagTrigger', None,, vect(54.944206, 671.900024, -728.685852));
			if(ftrig != None)
			{
				ftrig.SetCollision(false, false, false);
				ftrig.Tag = 'Self_Destruct';
				ftrig.bTrigger = false;
				ftrig.flagName = 'Deactivate_Keypad';
				flags.SetBool('Keypad_Deactivator_Placed', True);
			}
		}
	}
	else if (localURL == "06_HONGKONG_WANCHAI_MARKET")
	{
		// prepare for the ceremony
		if (flags.GetBool('Have_ROM') &&
			flags.GetBool('MeetTracerTong_Played') &&
			!flags.GetBool('TriadCeremony_Played'))
		{
			foreach AllActors(class'ScriptedPawn', pawn)
			{
				if (pawn.IsA('GordonQuick'))
					TeleportPawn(pawn, 'QuickInTemple', 'Standing');
				else if (pawn.IsA('MaxChen'))
					TeleportPawn(pawn, 'ChenInTemple', 'Standing');
				else if (pawn.Tag == 'MarketMonk01')
					pawn.EnterWorld();
				else if (pawn.Tag == 'MarketKid')
					pawn.Destroy();
			}

			flags.SetBool('CeremonyReadyToBegin', True,, 8);
		}

		//== Disable the Alliance triggers once you're a-ok with Gordon Quick
		if(flags.GetBool('QuickLetPlayerIn') && !flags.GetBool('M06_LumTriggersDisabled'))
		{
			foreach AllActors(class'AllianceTrigger', altrig)
			{
				if(altrig.Tag == 'LumpathPissed')
					altrig.Event = '';
			}
			flags.SetBool('M06_LumTriggersDisabled',True,, 8);
		}

		// remove the secretary
		if (flags.GetBool('MarketShopperOverheard_Played'))
		{
			foreach AllActors(class'ScriptedPawn', pawn, 'MarketShopperFlowers')
				pawn.Destroy();
		}

		// set up the catering situation
		if (flags.GetBool('CatererConvo_Played'))
		{
			foreach AllActors(class'ScriptedPawn', pawn, 'TeaHouseRedArrow')
				TeleportPawn(pawn, 'TalkToCaterer', 'Wandering');
		}
		else if (flags.GetBool('TeaHouseDrama_Played'))
		{
			foreach AllActors(class'ScriptedPawn', pawn, 'TeaHouseRedArrow')
				TeleportPawn(pawn, 'TalkToCaterer', 'Standing');

			flags.SetBool('ReadyForCaterer', True,, 8);
		}

		// remove some people after tea house drama has been played
		if (flags.GetBool('TeaHouseDrama_Played'))
		{
			foreach AllActors(class'ScriptedPawn', pawn)
			{
				if (pawn.Tag == 'TeaHouseCustomer')
					pawn.Destroy();
				else if (pawn.Tag == 'TeaHouseWoman')
					pawn.Destroy();
			}
		}

		// move the kid around to the correct spot
		if (flags.GetBool('KidGetsMoney_Played'))
		{
			foreach AllActors(class'ScriptedPawn', pawn, 'MarketKid')
				TeleportPawn(pawn, 'KidAtNewsStand', 'Wandering');
		}
		else if (flags.GetBool('KidSetsFire_Played'))
		{
			foreach AllActors(class'ScriptedPawn', pawn, 'MarketKid')
				TeleportPawn(pawn, 'KidAtNewsStand', 'Standing');

			flags.SetBool('MarketKidReadyForFifth', True,, 8);
		}
		else if (flags.GetBool('M06_Fire_Set'))
		{
			foreach AllActors(class'ScriptedPawn', pawn, 'MarketKid')
				TeleportPawn(pawn, 'KidAtLumPath', 'Standing');

			flags.SetBool('MarketKidReadyForFourth', True,, 8);
		}
		else if (flags.GetBool('KidAsksForHelp_Played'))
		{
			foreach AllActors(class'ScriptedPawn', pawn, 'MarketKid')
				TeleportPawn(pawn, 'KidSettingFire', 'Standing');

			flags.SetBool('MarketKidReadyForThird', True,, 8);
		}
		else if (flags.GetBool('KidAsksForWork_Played'))
		{
			foreach AllActors(class'ScriptedPawn', pawn, 'MarketKid')
				TeleportPawn(pawn, 'KidAtLumPath', 'Standing');

			flags.SetBool('MarketKidReadyForSecond', True,, 8);
		}

		// unhide the helicopter if it's time
		if (flags.GetBool('M08Briefing_Played'))
		{
			foreach AllActors(class'BlackHelicopter', chopper)
				chopper.EnterWorld();
		}

		// unhide a book
		if (flags.GetBool('M07Briefing_Played'))
		{
			foreach AllActors(class'BookOpen', book, 'TempleBook')
				book.bHidden = False;
		}

		// randomly place the goth chick
		foreach AllActors(class'ScriptedPawn', pawn, 'MarketGoth')
		{
			rnd = FRand();

			if (rnd < 0.33)
			{
				TeleportPawn(pawn, 'GothAtFlower', 'Standing');
				flags.SetBool('GothAtFlower', True,, 8);
				flags.SetBool('GothAtButcher', False,, 8);
				flags.SetBool('GothAtVase', False,, 8);
			}
			else if (rnd < 0.66)
			{
				TeleportPawn(pawn, 'GothAtButcher', 'Standing');
				flags.SetBool('GothAtFlower', False,, 8);
				flags.SetBool('GothAtButcher', True,, 8);
				flags.SetBool('GothAtVase', False,, 8);
			}
			else
			{
				TeleportPawn(pawn, 'GothAtVase', 'Standing');
				flags.SetBool('GothAtFlower', False,, 8);
				flags.SetBool('GothAtButcher', False,, 8);
				flags.SetBool('GothAtVase', True,, 8);
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
	//== Another interesting glitch: you can kill Bob Page after he
	//==  talks to Maggie Chow, just as they walk by a microscopic
	//==  crack between the window and the frame
	if(flags.GetBool('BobPage_Dead'))
		flags.SetBool('BobPage_Dead', False,, 8);

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
	local DeusExMover M;
	local AlarmUnit unit;
	local Dispatcher disp;
	local MJ12Commando commando;
	local HKMilitary hkm;
	local TriadRedArrow triadred;
	local TriadLumPath triadlum;
	local WaltonSimons walton;
	local RatGenerator gen;
	local LowerClassFemale fem;
	local Actor A;
	local PatrolPoint PP;
	local Keypad1 pad;

	Super.Timer();

	if (localURL == "06_HONGKONG_WANCHAI_STREET")
	{
		// unhide Walton Simons
		if (flags.GetBool('WaltonAppears') &&
			!flags.GetBool('MS_WaltonUnhidden'))
		{
			foreach AllActors(class'WaltonSimons', walton)
				walton.EnterWorld();

			flags.SetBool('MS_WaltonUnhidden', True,, 8);
		}

		// hide Walton Simons
		if (flags.GetBool('M06WaltonHolo_Played') &&
			!flags.GetBool('MS_WaltonHidden'))
		{
			foreach AllActors(class'WaltonSimons', walton)
				walton.LeaveWorld();

			flags.SetBool('MS_WaltonHidden', True,, 8);
		}
	}
	else if (localURL == "06_HONGKONG_WANCHAI_UNDERWORLD")
	{
		if (flags.GetBool('MaxChenConvinced') &&
			!flags.GetBool('MS_CommandosUnhidden'))
		{
			foreach AllActors(class'MJ12Commando', commando, 'RaidingCommando')
				commando.EnterWorld();

			flags.SetBool('MS_CommandosUnhidden', True,, 8);
		}

		// set a flag to False when all the commandos are dead
		if (flags.GetBool('Raid_Underway'))
		{
			count = 0;
			foreach AllActors(class'MJ12Commando', commando, 'RaidingCommando')
				count++;

			if (count == 0)
			{
				flags.SetBool('Raid_Underway', False,, 8);
				flags.SetBool('M06AmbushDone', True,, 8);
			}
		}

		// set a home base
		if (flags.GetBool('ReadyForMercedes2') &&
			!flags.GetBool('MS_HomeBaseSet'))
		{
			PP = GetPatrolPoint('PartyGirlInClub02');
			if (PP != None)
			{
				foreach AllActors(class'LowerClassFemale', fem, 'ClubTessa')
					fem.SetHomeBase(PP.Location, PP.Rotation);
			}
			flags.SetBool('MS_HomeBaseSet', True,, 8);
		}
	}
	else if (localURL == "06_HONGKONG_WANCHAI_GARAGE")
	{
		// count the number of military guys
		if (!flags.GetBool('RumbleCops_Lost'))
		{
			count = 0;
			foreach AllActors(class'HKMilitary', hkm, 'RumbleCops')
				count++;

			if (count == 0)
				flags.SetBool('RumbleCops_Lost', True,, 8);
		}

		// count the number of triads
		if (!flags.GetBool('RumbleRedArrow_Lost'))
		{
			count = 0;
			foreach AllActors(class'TriadRedArrow', triadred, 'RumbleRedArrow')
				count++;

			if (count == 0)
				flags.SetBool('RumbleRedArrow_Lost', True,, 8);
		}

		// count the number of triads
		if (!flags.GetBool('RumbleLumPath_Lost'))
		{
			count = 0;
			foreach AllActors(class'TriadLumPath', triadlum, 'RumbleLumPath')
				count++;

			if (count == 0)
				flags.SetBool('RumbleLumPath_Lost', True,, 8);
		}
	}
	else if (localURL == "06_HONGKONG_WANCHAI_MARKET")
	{
		// release rats
		if (flags.GetBool('TeaHouseDrama_Played') &&
			!flags.GetBool('MS_RatsReleased'))
		{
			foreach AllActors(class'RatGenerator', gen)
				gen.Trigger(Self, Player);

			flags.SetBool('MS_RatsReleased', True,, 8);
		}

		// trigger something
		if (flags.GetBool('CatererConvo_Played') &&
			!flags.GetBool('MS_ConvoTrigger1'))
		{
			foreach AllActors(class'Actor', A, 'TeaHouseRedArrowWanders')
				A.Trigger(Self, Player);

			flags.SetBool('MS_ConvoTrigger1', True,, 8);
		}

		// trigger something
		if (flags.GetBool('TeaHouseDrama_Played') &&
			!flags.GetBool('MS_ConvoTrigger2'))
		{
			foreach AllActors(class'Actor', A, 'TeaHouseRedArrowPatrol')
				A.Trigger(Self, Player);

			foreach AllActors(class'Actor', A, 'MarketWaiterWanders')
				A.Trigger(Self, Player);

			flags.SetBool('MS_ConvoTrigger2', True,, 8);
		}

		// trigger something
		if (flags.GetBool('FlowerShopperOverheard_Played') &&
			!flags.GetBool('MS_ConvoTrigger3'))
		{
			foreach AllActors(class'Actor', A, 'MarketShopperFlowersWanders')
				A.Trigger(Self, Player);

			flags.SetBool('MS_ConvoTrigger3', True,, 8);
		}

		// move the kid around to the correct spot
		if (flags.GetBool('KidGetsMoney_Played') &&
			!flags.GetBool('MS_ConvoTrigger4'))
		{
			foreach AllActors(class'Actor', A, 'KidWanders')
				A.Trigger(Self, Player);

			flags.SetBool('MS_ConvoTrigger4', True,, 8);
		}
		else if (flags.GetBool('KidSetsFire_Played') &&
			!flags.GetBool('MS_ConvoTrigger5'))
		{
			foreach AllActors(class'Actor', A, 'KidGoesToNewsStand')
				A.Trigger(Self, Player);

			flags.SetBool('MS_ConvoTrigger5', True,, 8);
		}
		else if (flags.GetBool('KidStealsSomething_Played') &&
			!flags.GetBool('MS_ConvoTrigger6'))
		{
			foreach AllActors(class'Actor', A, 'KidGoesToLumPath')
				A.Trigger(Self, Player);

			flags.SetBool('MS_ConvoTrigger6', True,, 8);
		}
		else if (flags.GetBool('KidAsksForHelp_Played') &&
			!flags.GetBool('MS_ConvoTrigger7'))
		{
			foreach AllActors(class'Actor', A, 'KidGoesToNewsStand')
				A.Trigger(Self, Player);

			flags.SetBool('MS_ConvoTrigger7', True,, 8);
		}
		else if (flags.GetBool('KidAsksForWork_Played') &&
			!flags.GetBool('MS_ConvoTrigger8'))
		{
			foreach AllActors(class'Actor', A, 'KidGoesToLumPath')
				A.Trigger(Self, Player);

			flags.SetBool('MS_ConvoTrigger8', True,, 8);
		}

		// hide/unhide some keypads
		if (flags.GetBool('QuickLetPlayerIn') &&
			!flags.GetBool('MS_KeypadsMoved'))
		{
			foreach AllActors(class'Keypad1', pad)
			{
				if (pad.Tag == 'DummyKeypad01')
					pad.Destroy();
				else if (pad.Tag == 'GateKeypad')
					pad.bHidden = False;
				else if (pad.Tag == 'BasementKeypad')
					pad.bHidden = False;
			}

			flags.SetBool('MS_KeypadsMoved', True,, 8);
		}
	}
	else if (localURL == "06_HONGKONG_HELIBASE")
	{
		// start an InfoLink when helicopter is armed
		if (flags.GetBool('helicopter_armed') &&
			!flags.GetBool('MS_JockInfoLink'))
		{
			Player.StartDataLinkTransmission("DL_Jock_02");
			flags.SetBool('MS_JockInfoLink', True,, 8);
		}

		// set the door rubble to be bBreakable
		if (flags.GetBool('MS_DoorsBlown') && !flags.GetBool('MS_RubbleBreakable'))
		{
			// make the rubble breakable
			foreach AllActors(class'DeusExMover', M, 'DoorWreckage')
				M.bBreakable = True;

			flags.SetBool('MS_RubbleBreakable', True,, 8);
		}

		// check to see if the doors are blown
		if (flags.GetBool('MS_HelicopterFired') &&
			!flags.GetBool('MS_DoorsBlown'))
		{
			fireTime += checkTime;
			count = 0;
			foreach AllActors(class'DeusExMover', M, 'Blast_doors')
				if (!M.bDestroyed)
					count++;

			if (count == 0)
			{
				// have Jock bark at the player
				Player.StartDataLinkTransmission("DL_Jock_03");

				// turn on the alarm
				foreach AllActors(class'AlarmUnit', unit, 'AlarmUnit')
					unit.Trigger(None, None);

				// trigger the dispatcher
				foreach AllActors(class'Dispatcher', disp, 'Go')
					disp.Trigger(None, None);

				flags.SetBool('MS_DoorsBlown', True,, 8);
			}
			else
			{
				// keep firing every 3 seconds until the doors are gone
				if (fireTime > 3)
				{
					FireMissilesAt('Blast_doors');
					fireTime = 0;
				}
			}
		}

		// start the helicopter firing sequence when triggered
		if (flags.GetBool('helicopter_fire') &&
			!flags.GetBool('MS_HelicopterFired'))
		{
			// have Jock bark at the player
			Player.StartDataLinkTransmission("DL_Jock_Fired");

			// set the blast doors to be breakable
			foreach AllActors(class'DeusExMover', M, 'Blast_doors')
				M.bBreakable = True;

			fireTime = 0;
			FireMissilesAt('Blast_doors');

			flags.SetBool('MS_HelicopterFired', True,, 8);
		}
	}
	else if (localURL == "06_HONGKONG_STORAGE")
	{
		// make the AUC destroyable
		if (flags.GetBool('ReadyToDestroyAUC') &&
			!flags.GetBool('MS_ReadyAUC'))
		{
			foreach AllActors(class'DeusExMover', M)
				if ((M.Tag == 'Pod01') || (M.Tag == 'Pod02') ||
					(M.Tag == 'Pod03') || (M.Tag == 'Pod04') ||
					(M.Tag == 'AUC'))
					M.bBreakable = True;

			flags.SetBool('MS_ReadyAUC', True,, 8);
		}

		if(flags.GetBool('Deactivate_Keypad'))
		{
			foreach AllActors(class'Keypad1', pad)
			{
				if(pad.Event == 'Self_Destruct')
				{
					pad.Event = '';
					pad.validCode = "XXX";
					pad.bHackable = False;
					pad.hackStrength = 1.0;
					flags.SetBool('Deactivate_Keypad', False);
				}
			}
		}
	}
	else if (localURL == "06_HONGKONG_WANCHAI_CANAL")
	{
		if (flags.GetBool('Overhear_Canal_Thug1_Played') &&
			!flags.GetBool('MS_DrugDealersAttacking'))
		{
			foreach AllActors(class'Actor', A, 'CanalDrugDealersAttack')
				A.Trigger(Self, Player);

			flags.SetBool('MS_DrugDealersAttacking', True,, 8);
		}
	}
}

function FireMissilesAt(name targetTag)
{
	local int i;
	local Vector loc;
	local BlackHelicopter chopper;
	local RocketLAW rocket;
	local Actor A, Target;

	foreach AllActors(class'Actor', A, targetTag)
		Target = A;

	// fire missiles from the helicopter
	foreach AllActors(class'BlackHelicopter', chopper, 'chopper')
	{
		for (i=-1; i<=1; i+=2)
		{
			loc = (i*chopper.CollisionRadius * vect(0,0.15,0)) >> chopper.Rotation;
			loc += chopper.Location;
			rocket = Spawn(class'RocketLAW', chopper,, loc, chopper.Rotation);
			if (rocket != None)
			{
				rocket.bTracking = True;
				rocket.Target = Target;
				rocket.PlaySound(sound'RocketIgnite', SLOT_None, 2.0,, 2048);
			}
		}
	}
}

function TeleportPawn(ScriptedPawn pawn, name patrolTag, name orders, optional bool bRandom)
{
	local PatrolPoint point;

	if (pawn != None)
	{
		point = GetPatrolPoint(patrolTag, bRandom);
		if (point != None)
		{
			pawn.SetLocation(point.Location);
			pawn.SetRotation(point.Rotation);
			pawn.SetOrders(orders,, True);
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
