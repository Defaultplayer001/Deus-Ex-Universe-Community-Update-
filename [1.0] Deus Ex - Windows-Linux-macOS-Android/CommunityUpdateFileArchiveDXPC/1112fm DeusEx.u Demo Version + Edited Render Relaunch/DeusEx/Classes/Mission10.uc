//=============================================================================
// Mission10.
//=============================================================================
class Mission10 expands MissionScript;

// ----------------------------------------------------------------------
// FirstFrame()
// 
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
	local NicoletteDuClare Nicolette;
	local BlackHelicopter chopper;
	local JaimeReyes Jaime;

	Super.FirstFrame();

	if (localURL == "10_PARIS_METRO")
	{
		if (flags.GetBool('NicoletteLeftClub'))
		{
			foreach AllActors(class'NicoletteDuClare', Nicolette)
				Nicolette.EnterWorld();

			foreach AllActors(class'BlackHelicopter', chopper, 'BlackHelicopter')
				chopper.EnterWorld();
		}

		if (!flags.GetBool('JaimeRecruited'))
		{
			foreach AllActors(class'JaimeReyes', Jaime)
				Jaime.EnterWorld();
		}
	}
	else if (localURL == "10_PARIS_CLUB")
	{
		if (flags.GetBool('NicoletteLeftClub'))
		{
			foreach AllActors(class'NicoletteDuClare', Nicolette)
				Nicolette.Destroy();
		}
	}
	else if (localURL == "10_PARIS_CHATEAU")
	{
		flags.SetBool('ClubComplete', True,, 11);
	}
}

// ----------------------------------------------------------------------
// PreTravel()
// 
// Set flags upon exit of a certain map
// ----------------------------------------------------------------------

function PreTravel()
{
	if (localURL == "10_PARIS_CLUB")
	{
		if (flags.GetBool('MeetNicolette_Played') &&
			!flags.GetBool('NicoletteLeftClub'))
		{
			flags.SetBool('NicoletteLeftClub', True,, 11);
		}
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
	local int count;
	local int notSafeCount, notDeadCount;
	local ScriptedPawn hostage, guard;
	local Greasel greasel;
	local GuntherHermann gunther;
	local MJ12Commando commando;
	local Actor A;

	Super.Timer();

	if (localURL == "10_PARIS_CATACOMBS")
	{
		// see if the greasels are dead
		if (!flags.GetBool('SewerGreaselsDead'))
		{
			count = 0;
			foreach AllActors(class'Greasel', greasel, 'SewerGreasel')
				count++;

			if (count == 0)
				flags.SetBool('SewerGreaselsDead', True,, 11);
		}

		// check for dead guards
		if (!flags.GetBool('defoequestcomplete'))
		{
			count = 0;
			foreach AllActors(class'ScriptedPawn', guard, 'mj12metroguards')
				count++;

			if (count == 0)
				flags.SetBool('defoequestcomplete', True,, 11);
		}
	}
	else if (localURL == "10_PARIS_CATACOMBS_TUNNELS")
	{
		if (!flags.GetBool('SilhouetteRescueComplete'))
		{
			// count how many hostages are NOT safe
			notSafeCount = 0;
			notDeadCount = 0;
			foreach AllActors(class'ScriptedPawn', hostage)
			{
				if (hostage.BindName == "hostage")
				{
					notDeadCount++;
					if (!flags.GetBool('CataMaleSafe'))
						notSafeCount++;
				}
				else if (hostage.BindName == "hostage_female")
				{
					notDeadCount++;
					if (!flags.GetBool('CataFemaleSafe'))
						notSafeCount++;
				}
			}

			if ((notSafeCount == 0) || (notDeadCount == 0))
			{
				flags.SetBool('SilhouetteRescueComplete', True,, 11);
				Player.GoalCompleted('EscortHostages');

				if (notDeadCount == 0)
					flags.SetBool('SilhouetteHostagesDead', True,, 11);
				else if (notDeadCount < 2)
					flags.SetBool('SilhouetteHostagesSomeRescued', True,, 11);
				else
					flags.SetBool('SilhouetteHostagesAllRescued', True,, 11);
			}
		}
	}
	else if (localURL == "10_PARIS_METRO")
	{
		// unhide GuntherHermann
		if (!flags.GetBool('MS_GuntherUnhidden') &&
			flags.GetBool('JockReady_Played'))
		{
			foreach AllActors(class'GuntherHermann', gunther)
				gunther.EnterWorld();

			flags.SetBool('MS_GuntherUnhidden', True,, 11);
		}

		// bark something
		if (flags.GetBool('AlleyCopSeesPlayer_Played') &&
			!flags.GetBool('MS_CopBarked'))
		{
			foreach AllActors(class'Actor', A, 'AlleyCopAttacks')
				A.Trigger(Self, Player);

			flags.SetBool('MS_CopBarked', True,, 11);
		}
	}
	else if (localURL == "10_PARIS_CHATEAU")
	{
		// unhide MJ12Commandos when an infolink is played
		if (!flags.GetBool('MS_CommandosUnhidden') &&
			flags.GetBool('everettsignal'))
		{
			foreach AllActors(class'MJ12Commando', commando)
				commando.EnterWorld();

			flags.SetBool('MS_CommandosUnhidden', True,, 11);
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
