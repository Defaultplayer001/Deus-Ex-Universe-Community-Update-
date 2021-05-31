//=============================================================================
// Mission09.
//=============================================================================
class Mission09 expands MissionScript;

// ----------------------------------------------------------------------
// FirstFrame()
// 
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
	local DeusExMover M;
	local BlackHelicopter chopper;

	Super.FirstFrame();

	if (localURL == "09_NYC_SHIP")
	{
		if (flags.GetBool('ShipBreech'))
		{
			foreach AllActors(class'DeusExMover', M)
			{
				if ((M.Tag == 'SewerGrate') || (M.Tag == 'FrontDoor'))
				{
					// close and lock the door
					if (M.KeyNum != 0)
						M.Trigger(None, None);
					M.bBreakable = False;
					M.bPickable = False;
					M.bFrobbable = False;
					M.bLocked = True;
				}
			}
		}
	}
	else if (localURL == "09_NYC_DOCKYARD")
	{
		if (flags.GetBool('MS_ShipBreeched'))
		{
			foreach AllActors(class'BlackHelicopter', chopper, 'BlackHelicopter')
				chopper.EnterWorld();
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
	local int count;
	local DeusExMover M;
	local BlackHelicopter chopper;
	local MJ12Troop troop;
	local Trigger trig;
	local MJ12Commando commando;
	local WaltonSimons Walton;

	Super.Timer();

	if (localURL == "09_NYC_SHIP")
	{
		// unhide Walton Simons
		if (!flags.GetBool('MS_SimonsAppeared') &&
			flags.GetBool('SummonSimons'))
		{
			foreach AllActors(class'WaltonSimons', Walton)
				Walton.EnterWorld();

			flags.SetBool('MS_SimonsAppeared', True,, 10);
		}

		// hide Walton Simons, and make this convo retriggerable
		if (flags.GetBool('MS_SimonsAppeared') &&
			flags.GetBool('M09SimonsDisappears'))
		{
			foreach AllActors(class'WaltonSimons', Walton)
				Walton.LeaveWorld();

			flags.SetBool('M09SimonsDisappears', False,, 10);
			flags.SetBool('MS_SimonsAppeared', False,, 10);
			flags.SetBool('SummonSimons', False,, 10);
		}

		// randomly play explosions and shake the view
		// if the ship has been breeched
		if (flags.GetBool('MS_ShipBreeched'))
			ShipExplosionEffects(False);
	}
	else if (localURL == "09_NYC_SHIPBELOW")
	{
		// check for blown up ship
		if (!flags.GetBool('MS_ShipBreeched'))
		{
			count = 0;
			foreach AllActors(class'DeusExMover', M, 'ShipBreech')
				if (!M.bDestroyed)
					count++;

			if (count == 0)
			{
				if (flags.GetBool('Bilge'))
				{
					Player.StartDataLinkTransmission("DL_AllDone");
					flags.SetBool('MS_ShipBreeched', True,, 10);
				}
				else if (!flags.GetBool('DL_AllPlaced_Played'))
				{
					Player.StartDataLinkTransmission("DL_AllPlaced");
				}
			}
		}

		// randomly play explosions and shake the view
		// if the ship has been breeched
		if (flags.GetBool('MS_ShipBreeched'))
			ShipExplosionEffects(True);
	}
	else if (localURL == "09_NYC_GRAVEYARD")
	{
		// unhide the helicopter when the "little device" is destroyed
		if (!flags.GetBool('MS_UnhideHelicopter'))
		{
			if (flags.GetBool('deviceDestroyed') &&
				flags.GetBool('M09MeetStantonDowd_Played'))
			{
				foreach AllActors(class'BlackHelicopter', chopper, 'BlackHelicopter')
					chopper.EnterWorld();

				Player.StartDataLinkTransmission("DL_ComingIn");

				foreach AllActors(class'MJ12Troop', troop, 'TroopSupport')
					troop.EnterWorld();

				flags.SetBool('MS_UnhideHelicopter', True,, 10);
			}
		}

		// activate a trigger and unhide some troops
		// once Stanton Dowd has been talked to
		if (!flags.GetBool('MS_TriggerOn') &&
			flags.GetBool('M09MeetStantonDowd_Played'))
		{
			foreach AllActors(class'Trigger', trig, 'TunnelTrigger')
				trig.SetCollision(True);

			foreach AllActors(class'MJ12Troop', troop, 'TroopInsertion')
				troop.EnterWorld();

			flags.SetBool('MS_TriggerOn', True,, 10);
		}

		// spawn some commandos
		if (flags.GetBool('GreenKnowsAboutDowd') &&
			flags.GetBool('suprisePoint') &&
			!flags.GetBool('MS_UnhideCommandos'))
		{
			foreach AllActors(class'MJ12Commando', commando, 'paratroop')
				commando.EnterWorld();

			flags.SetBool('MS_UnhideCommandos', True,, 10);
		}
	}
}

function ShipExplosionEffects(bool bFragments)
{
	local float shakeTime, shakeRoll, shakeVert;
	local float size, explosionFreq;
	local int i;
	local Vector bobble, loc, endloc, HitLocation, HitNormal;
	local Actor HitActor;
	local HangingDecoration deco;
	local Cart cart;
	local MetalFragment frag;

	if (bFragments)
		explosionFreq = 0.33;
	else
		explosionFreq = 0.1;

	if (FRand() < explosionFreq)
	{
		// pick a random explosion size and modify everything accordingly
		size = FRand();
		shakeTime = 0.5 + size;
		shakeRoll = 512.0 + 1024.0 * size;
		shakeVert = 8.0 + 16.0 * size;

		// play a sound
		if (size < 0.2)
			Player.PlaySound(Sound'SmallExplosion1', SLOT_None, 2.0,, 16384);
		else if (size < 0.4)
			Player.PlaySound(Sound'MediumExplosion1', SLOT_None, 2.0,, 16384);
		else if (size < 0.6)
			Player.PlaySound(Sound'MediumExplosion2', SLOT_None, 2.0,, 16384);
		else if (size < 0.8)
			Player.PlaySound(Sound'LargeExplosion1', SLOT_None, 2.0,, 16384);
		else
			Player.PlaySound(Sound'LargeExplosion2', SLOT_None, 2.0,, 16384);

		// shake the view
		Player.ShakeView(shakeTime, shakeRoll, shakeVert);

		// bobble the player around
		bobble = vect(300.0,300.0,200.0) + 500.0 * size * VRand();
		Player.Velocity += bobble;

		// make all the hanging decorations sway randomly
		foreach AllActors(class'HangingDecoration', deco)
		{
			deco.CalculateHit(deco.Location + 10.0 * FRand() * VRand(), 0.5 * bobble);
			deco.bSwaying = True;
		}

		// make all the carts move randomly
		foreach AllActors(class'Cart', cart)
			cart.StartRolling(vect(100.0,100.0,0.0) + 200.0 * size * VRand());

		// have random metal fragments fall from the ceiling
		if (bFragments)
		{
			for (i=0; i<Int(size*20.0); i++)
			{
				loc = Player.Location + 256.0 * VRand();
				loc.Z = Player.Location.Z;
				endloc = loc;
				endloc.Z += 1024.0;
				HitActor = Trace(HitLocation, HitNormal, endloc, loc, False);
				if (HitActor == None)
					HitLocation = endloc;
				frag = Spawn(class'MetalFragment',,, HitLocation);
				if (frag != None)
				{
					frag.CalcVelocity(vect(20000,0,0),256);
					frag.DrawScale = 0.5 + 2.0 * FRand();
					if (FRand() < 0.25)
						frag.bSmoking = True;
				}
			}
		}
	}

	// make sure the player's zone has an alarm ambient sound
	if (Player.HeadRegion.Zone != None)
	{
		Player.HeadRegion.Zone.AmbientSound = sound'Klaxon';
		Player.HeadRegion.Zone.SoundRadius = 255;
		Player.HeadRegion.Zone.SoundVolume = 255;
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
