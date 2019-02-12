//=============================================================================
// Mission11.
//=============================================================================
class Mission11 expands MissionScript;

// ----------------------------------------------------------------------
// FirstFrame()
// 
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
	local Mechanic mech;

	Super.FirstFrame();

	if (localURL == "11_PARIS_EVERETT")
	{
		if (!flags.GetBool('Ray_Neutral') && !flags.GetBool('Ray_Dead'))
		{
			foreach AllActors(class'Mechanic', mech)
			{
				mech.bLikesNeutral = False;
				flags.SetBool('Ray_Neutral', True);
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
	Super.PreTravel();
}

// ----------------------------------------------------------------------
// Timer()
//
// Main state machine for the mission
// ----------------------------------------------------------------------

function Timer()
{
	local TobyAtanwe toby;
	local GuntherHermann gunther;
	local BlackHelicopter chopper;
	local AlexJacobson alex;
	local WaltonSimons walton;

	Super.Timer();

	if (localURL == "11_PARIS_UNDERGROUND")
	{
		// unhide Toby Atanwe
		if (flags.GetBool('templar_upload') &&
			!flags.GetBool('MS_TobyUnhidden'))
		{
			foreach AllActors(class'TobyAtanwe', toby)
				toby.EnterWorld();

			flags.SetBool('MS_TobyUnhidden', True,, 12);
		}

		// knock out the player and teleport him after this convo
		if (flags.GetBool('MeetTobyAtanwe_Played') &&
			!flags.GetBool('MS_PlayerTeleported'))
		{
			flags.SetBool('MS_PlayerTeleported', True,, 12);
			Level.Game.SendPlayer(Player, "11_PARIS_EVERETT");
		}
	}
	else if (localURL == "11_PARIS_EVERETT")
	{
		// unhide the helicopter
		if (flags.GetBool('MeetEverett_Played') &&
			!flags.GetBool('MS_ChopperUnhidden'))
		{
			foreach AllActors(class'BlackHelicopter', chopper)
				chopper.EnterWorld();

			flags.SetBool('MS_ChopperUnhidden', True,, 12);
		}

		// unhide Alex Jacobson
		if (flags.GetBool('AtanweAtEveretts_Played') &&
			!flags.GetBool('MS_AlexUnhidden'))
		{
			foreach AllActors(class'AlexJacobson', alex)
				alex.EnterWorld();

			flags.SetBool('MS_AlexUnhidden', True,, 12);
		}

		// set a flag
		if (flags.GetBool('Ray_Dead') &&
			!flags.GetBool('MS_RayDead'))
		{
			Player.GoalCompleted('KillMechanic');
			flags.SetBool('MS_RayDead', True,, 12);
		}
	}
	else if (localURL == "11_PARIS_CATHEDRAL")
	{
		// kill Gunther after a convo
		if (flags.GetBool('M11MeetGunther_Played') &&
			flags.GetBool('KillGunther') &&
			!flags.GetBool('MS_GuntherKilled'))
		{
			foreach AllActors(class'GuntherHermann', gunther)
			{
				gunther.bInvincible = False;
				gunther.HealthTorso = 0;
				gunther.Health = 0;
				gunther.GotoState('KillswitchActivated');
				flags.SetBool('GuntherHermann_Dead', True,, 0);
				flags.SetBool('MS_GuntherKilled', True,, 12);
			}
		}

		// unhide Walton Simons
		if (flags.GetBool('templar_upload') &&
			flags.GetBool('M11NearWalt') &&
			!flags.GetBool('MS_M11WaltAppeared'))
		{
			foreach AllActors(class'WaltonSimons', walton)
				walton.EnterWorld();

			flags.SetBool('MS_M11WaltAppeared', True,, 12);
		}

		// hide Walton Simons
		if (flags.GetBool('M11WaltonHolo_Played') &&
			!flags.GetBool('MS_M11WaltRemoved'))
		{
			foreach AllActors(class'WaltonSimons', walton)
				walton.LeaveWorld();

			flags.SetBool('MS_M11WaltRemoved', True,, 12);
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
