//=============================================================================
// Mission12.
//=============================================================================
class Mission12 expands MissionScript;

// ----------------------------------------------------------------------
// FirstFrame()
// 
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
	local BlackHelicopter chopper;
	local ScriptedPawn pawn;
	local SandraRenton Sandra;

	Super.FirstFrame();

	if (localURL == "12_VANDENBERG_CMD")
	{
		// unhide the black helicopter, Jock, and TracerTong
		if (flags.GetBool('GaryHostageBriefing_Played'))
		{
			foreach AllActors(class'BlackHelicopter', chopper)
				chopper.EnterWorld();

			foreach AllActors(class'ScriptedPawn', pawn)
				if (pawn.IsA('Jock') || pawn.IsA('TracerTong'))
					pawn.EnterWorld();
		}
	}
	else if (localURL == "12_VANDENBERG_GAS")
	{
		flags.SetBool('RescueBegan', True,, 14);

		if (flags.GetBool('SandraWentToCalifornia'))
		{
			foreach AllActors(class'SandraRenton', Sandra)
				Sandra.EnterWorld();
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
	local Robot bot;
	local BlackHelicopter chopper;
	local ScriptedPawn pawn;
	local MJ12Troop troop;
	local Earth earth;
	local BobPage Bob;
	local int count;
	local DeusExMover M;

	Super.Timer();

	if (localURL == "12_VANDENBERG_CMD")
	{
		// play datalinks when robots are destroyed or disabled
		if (!flags.GetBool('MS_DL_Played'))
		{
			count = 0;
			foreach AllActors(class'Robot', bot, 'enemy_bot')
				if (bot.EMPHitPoints > 0)
					count++;

			if (count == 3)
				Player.StartDataLinkTransmission("DL_bots_left_3");
			else if (count == 2)
				Player.StartDataLinkTransmission("DL_bots_left_2");
			else if (count == 1)
				Player.StartDataLinkTransmission("DL_bots_left_1");
			else if (count == 0)
			{
				Player.StartDataLinkTransmission("DL_command_bots_destroyed");
				flags.SetBool('MS_DL_Played', True,, 14);
			}
		}

		// rescue the scientist when the guards are dead
		if (!flags.GetBool('CapturedScientistRescued'))
		{
			count = 0;
			foreach AllActors(class'MJ12Troop', troop)
				if ((troop.Tag == 'MJ12_hazlab_troop1') || (troop.Tag == 'MJ12_hazlab_troop2'))
					count++;

			if (count == 0)
				flags.SetBool('CapturedScientistRescued', True,, 14);
		}
	}
	else if (localURL == "12_VANDENBERG_GAS")
	{
		// unhide the black helicopter and destroy the doors
		if (!flags.GetBool('MS_ChopperGasUnhidden'))
		{
			if (flags.GetBool('MeetTiffanySavage_Played') ||
				flags.GetBool('TiffanySavage_Dead'))
			{
				foreach AllActors(class'BlackHelicopter', chopper)
					chopper.EnterWorld();

				foreach AllActors(Class'DeusExMover', M, 'junkyard_doors')
					M.BlowItUp(None);

				flags.SetBool('TiffanyRescued', True,, 14);
				flags.SetBool('MS_ChopperGasUnhidden', True,, 14);
			}
		}

		if (!flags.GetBool('MS_TiffanyDLPlayed') &&
			flags.GetBool('TiffanySavage_Dead'))
		{
			Player.StartDataLinkTransmission("DL_JockTiffanyDead");
			flags.SetBool('MS_TiffanyDLPlayed', True,, 14);
		}
	}
	else if (localURL == "12_VANDENBERG_COMPUTER")
	{
		// hide the earth and unhide Bob Page
		if (!flags.GetBool('MS_M12PageAppeared') &&
			flags.GetBool('M12PageAppears'))
		{
			foreach AllActors(class'Earth', earth)
				earth.bHidden = True;

			foreach AllActors(class'BobPage', Bob)
				Bob.EnterWorld();

			flags.SetBool('MS_M12PageAppeared', True,, 14);
		}

		// unhide the earth and hide Bob Page
		if (flags.GetBool('MS_M12PageAppeared') &&
			!flags.GetBool('MS_BobPageHidden') &&
			flags.GetBool('PageHostageBriefing_Played'))
		{
			foreach AllActors(class'Earth', earth)
				earth.bHidden = False;

			foreach AllActors(class'BobPage', Bob)
				Bob.LeaveWorld();

			flags.SetBool('MS_BobPageHidden', True,, 14);
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
