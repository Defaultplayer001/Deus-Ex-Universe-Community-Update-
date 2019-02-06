//=============================================================================
// Mission14.
//=============================================================================
class Mission14 expands MissionScript;

// ----------------------------------------------------------------------
// FirstFrame()
// 
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
	Super.FirstFrame();

	if (localURL == "14_OCEANLAB_LAB")
	{
		Player.GoalCompleted('StealSub');
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
	local HowardStrong Howard;
	local BlackHelicopter chopper;
	local MiniSub sub;
	local ScubaDiver diver;
	local GarySavage Gary;
	local WaltonSimons Walton;
	local Actor part;
	local BobPage Bob;

	Super.Timer();

	if (localURL == "14_VANDENBERG_SUB")
	{
		// when the mission is complete, unhide the chopper and Gary Savage,
		// and destroy the minisub and the welding parts
		if (!flags.GetBool('MS_DestroySub'))
		{
			if (flags.GetBool('DL_downloaded_Played'))
			{
				foreach AllActors(class'MiniSub', sub, 'MiniSub2')
					sub.Destroy();

				foreach AllActors(class'Actor', part, 'welding_stuff')
					part.Destroy();

				foreach AllActors(class'BlackHelicopter', chopper, 'BlackHelicopter')
					chopper.EnterWorld();

				foreach AllActors(class'GarySavage', Gary)
					Gary.EnterWorld();

				flags.SetBool('MS_DestroySub', True,, 15);
			}
		}
	}
	else if (localURL == "14_OCEANLAB_LAB")
	{
		// when the mission is complete, unhide the minisub and the diver team
		if (!flags.GetBool('MS_UnhideSub'))
		{
			if (flags.GetBool('DL_downloaded_Played'))
			{
				foreach AllActors(class'WaltonSimons', Walton)
					Walton.EnterWorld();

				foreach AllActors(class'MiniSub', sub, 'MiniSub2')
					sub.EnterWorld();

				foreach AllActors(class'ScubaDiver', diver, 'scubateam')
					diver.EnterWorld();

				flags.SetBool('MS_UnhideSub', True,, 15);
			}
		}
	}
	else if (localURL == "14_OCEANLAB_SILO")
	{
		// when HowardStrong is dead, unhide the helicopter
		if (!flags.GetBool('MS_UnhideHelicopter'))
		{
			count = 0;
			foreach AllActors(class'HowardStrong', Howard)
				count++;

			if (count == 0)
			{
				foreach AllActors(class'BlackHelicopter', chopper, 'BlackHelicopter')
					chopper.EnterWorld();

				Player.StartDataLinkTransmission("DL_Dead");
				flags.SetBool('MS_UnhideHelicopter', True,, 15);
			}
		}
	}
	else if (localURL == "14_OCEANLAB_UC")
	{
		// when a flag is set, unhide Bob Page
		if (!flags.GetBool('MS_UnhideBobPage') &&
			flags.GetBool('schematic_downloaded'))
		{
			foreach AllActors(class'BobPage', Bob)
				Bob.EnterWorld();

			flags.SetBool('MS_UnhideBobPage', True,, 15);
		}

		// when a flag is set, hide Bob Page
		if (!flags.GetBool('MS_HideBobPage') &&
			flags.GetBool('PageTaunt_Played'))
		{
			foreach AllActors(class'BobPage', Bob)
				Bob.LeaveWorld();

			flags.SetBool('MS_HideBobPage', True,, 15);
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
