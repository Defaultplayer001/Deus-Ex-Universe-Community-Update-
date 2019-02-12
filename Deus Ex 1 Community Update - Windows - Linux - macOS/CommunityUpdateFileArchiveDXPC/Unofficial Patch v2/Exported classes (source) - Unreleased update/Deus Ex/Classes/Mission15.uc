//=============================================================================
// Mission15.
//=============================================================================
class Mission15 expands MissionScript;

struct sUCData
{
	var name				spawnTag;
	var class<ScriptedPawn>	spawnClass;
	var name				Tag;
	var name				orderTag;
	var int					count;
	var float				lastKilledTime;
};

var sUCData spawnData[12];
var float jockTimer, pageTimer;
var BobPageAugmented page;

// ----------------------------------------------------------------------
// FirstFrame()
// 
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
	local BlackHelicopter chopper;
	local InterpolateTrigger trig;

	Super.FirstFrame();

	if (localURL == "15_AREA51_BUNKER")
	{
		// unhide a helicopter if a flag is set, and start the countdown
		// to Jock's death
		if (!flags.GetBool('Ray_dead'))
		{
			foreach AllActors(class'BlackHelicopter', chopper)
			{
				if (chopper.Tag == 'heli_sabotaged')
					chopper.EnterWorld();
				else if (chopper.Tag == 'UN_BlackHeli')
					chopper.LeaveWorld();
			}

			// start the new helicopter interpolating
			foreach AllActors(class'InterpolateTrigger', trig, 'InterpolateTrigger')
				trig.Trigger(Self, Player);

			jockTimer = Level.TimeSeconds;
			flags.SetBool('MS_BeginSabotage', True,, 16);
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
	local ZoneInfo zone;
	local Fan1 fan;
	local int count, i, j;
	local Earth earth;
	local MorganEverett Morgan;
	local TracerTong Tracer;
	local ScriptedPawn pawn;
	local SpawnPoint SP;
	local BlackHelicopter chopper;
	local SphereEffect sphere;
	local MetalFragment frag;
	local AnimatedSprite explo;
	local ElectricityEmitter elec;
	local Vector loc;
	local Switch2 sw;
	local MJ12Commando comm;
	local Actor A;
	local DeusExMover M;
	local LifeSupportBase base;
	local BobPageAugmented tempPage;

	Super.Timer();

	if (localURL == "15_AREA51_BUNKER")
	{
		// destroy Jock's heli on takeoff if a flag is set
		if (flags.GetBool('MS_BeginSabotage') && !flags.GetBool('MS_JockDead'))
		{
			// 8 seconds after level start, play a datalink
			if (!flags.GetBool('DL_JockDeath_Played') && (Level.TimeSeconds - jockTimer >= 8.0))
				Player.StartDataLinkTransmission("DL_JockDeath");

			// 11 seconds after level start, start to destroy Jock's helicopter
			// When the datalink is finished, finish destroying Jock's helicopter
			if (flags.GetBool('DL_JockDeath_Played'))
			{
				// spawn the final explosions and lots of debris
				foreach AllActors(class'BlackHelicopter', chopper, 'heli_sabotaged')
				{
					// large explosion sprites
					for (i=0; i<20; i++)
					{
						loc = chopper.Location + VRand() * chopper.CollisionHeight;
						if (FRand() < 0.25)
							explo = Spawn(class'ExplosionMedium',,, loc);
						else
							explo = Spawn(class'ExplosionLarge',,, loc);

						if (explo != None)
							explo.animSpeed += 0.4 * FRand();
					}

					// metal fragments
					for (i=0; i<20; i++)
					{
						loc = chopper.Location + VRand() * chopper.CollisionHeight;
						frag = Spawn(class'MetalFragment',,, loc);
						if (frag != None)
						{
							frag.CalcVelocity(vect(40000,0,0),512);
							frag.DrawScale = 5.0 + 2.0 * FRand();
							frag.Skin = chopper.GetMeshTexture();
							if (FRand() < 0.5)
								frag.bSmoking = True;
						}
					}

					// light sphere
					sphere = Spawn(class'SphereEffect',,, loc);
					if (sphere != None)
						sphere.size = 32.0;

					// sound
					Player.PlaySound(Sound'LargeExplosion2', SLOT_None, 2.0,, 16384);
					Player.ShakeView(1.0, 1024.0, 32.0);
					chopper.Destroy();
					break;
				}

				Player.StartDataLinkTransmission("DL_JockDeathTongComment");
				flags.SetBool('MS_JockDead', True,, 16);
			}
			else if (Level.TimeSeconds - jockTimer >= 11.0)
			{
				// spawn an inital explosion
				foreach AllActors(class'BlackHelicopter', chopper, 'heli_sabotaged')
				{
					// small explosion sprites
					for (i=0; i<6; i++)
					{
						loc = chopper.Location + VRand() * chopper.CollisionHeight;
						if (FRand() < 0.25)
							explo = Spawn(class'ExplosionSmall',,, loc);
						else
							explo = Spawn(class'ExplosionMedium',,, loc);

						if (explo != None)
							explo.animSpeed += 0.3 * FRand();
					}

					// sound
					Player.PlaySound(Sound'MediumExplosion1', SLOT_None, 2.0,, 16384);
					break;
				}
			}
		}

		// turn off pain zone when fan is destroyed
		if (!flags.GetBool('MS_FanDestroyed'))
		{
			count = 0;
			foreach AllActors(class'Fan1', fan, 'Fan_vertical_shaft_1')
				count++;

			if (count == 0)
			{
				foreach AllActors(class'ZoneInfo', zone, 'fan')
					zone.Trigger(Player, Player);

				flags.SetBool('MS_FanDestroyed', True,, 16);
			}
		}
	}
	else if (localURL == "15_AREA51_ENTRANCE")
	{
		// hide the earth and unhide Everett
		if (!flags.GetBool('MS_EverettAppeared') &&
			flags.GetBool('EverettAppears'))
		{
			foreach AllActors(class'Earth', earth)
				earth.bHidden = True;

			foreach AllActors(class'MorganEverett', Morgan)
				Morgan.EnterWorld();

			flags.SetBool('MS_EverettAppeared', True,, 16);
		}

		// unhide the earth and hide Everett
		if (!flags.GetBool('MS_MorganEverettHidden') &&
			flags.GetBool('M15MeetEverett_Played'))
		{
			foreach AllActors(class'Earth', earth)
				earth.bHidden = False;

			foreach AllActors(class'MorganEverett', Morgan)
				Morgan.LeaveWorld();

			flags.SetBool('MS_MorganEverettHidden', True,, 16);
		}
	}
	else if (localURL == "15_AREA51_FINAL")
	{
		// unhide some commandos
		if (flags.GetBool('MeetHelios_Played') &&
			!flags.GetBool('MS_CommandosUnhidden'))
		{
			foreach AllActors(class'MJ12Commando', comm)
				if ((comm.Tag == 'commando1') || (comm.Tag == 'commando2') || (comm.Tag == 'commando3'))
					comm.EnterWorld();

			flags.SetBool('MS_CommandosUnhidden', True,, 16);
		}

		// hide some buttons
		if (!flags.GetBool('MS_ButtonsHidden') && flags.GetBool('coolantcut'))
		{
			foreach AllActors(class'Switch2', sw)
			{
				if ((sw.Tag == 'gen_switch1_off') || (sw.Tag == 'gen_switch2_off'))
					sw.bHidden = True;
				else if ((sw.Tag == 'gen_switch1_on') || (sw.Tag == 'gen_switch2_on'))
					sw.bHidden = False;
			}

			flags.SetBool('MS_ButtonsHidden', True,, 16);
		}

		// hide the earth and unhide Tong
		if (!flags.GetBool('MS_TongAppeared') &&
			flags.GetBool('TongAppears'))
		{
			foreach AllActors(class'Earth', earth)
				earth.bHidden = True;

			foreach AllActors(class'TracerTong', Tracer)
				Tracer.EnterWorld();

			flags.SetBool('MS_TongAppeared', True,, 16);
		}

		// unhide the earth and hide Tong
		if (!flags.GetBool('MS_TracerTongHidden') &&
			flags.GetBool('M15MeetTong_Played'))
		{
			foreach AllActors(class'Earth', earth)
				earth.bHidden = False;

			foreach AllActors(class'TracerTong', Tracer)
				Tracer.LeaveWorld();

			flags.SetBool('MS_TracerTongHidden', True,, 16);
		}

		// unhide Paul or Gary
		if (!flags.GetBool('MS_PaulOrGaryAppeared') &&
			flags.GetBool('PaulAppears'))
		{
			if (flags.GetBool('PaulDenton_Dead'))
			{
				foreach AllActors(class'ScriptedPawn', pawn, 'GarySavage')
					pawn.EnterWorld();
			}
			else
			{
				foreach AllActors(class'ScriptedPawn', pawn, 'PaulDenton')
					pawn.EnterWorld();
			}

			flags.SetBool('MS_PaulOrGaryAppeared', True,, 16);
		}

		// hide Paul or Gary
		if (!flags.GetBool('MS_PaulOrGaryHidden') &&
			(flags.GetBool('M15PaulHolo_Played') ||
			flags.GetBool('M15GaryHolo_Played')))
		{
			foreach AllActors(class'ScriptedPawn', pawn)
				if ((pawn.Tag == 'PaulDenton') || (pawn.Tag == 'GarySavage'))
					pawn.LeaveWorld();

			flags.SetBool('MS_PaulOrGaryHidden', True,, 16);
		}
	}
	else if (localURL == "15_AREA51_PAGE")
	{
		// check for UC respawing
		// count the number of monsters that are still alive
		foreach AllActors(class'ScriptedPawn', pawn)
			for (i=0; i<ArrayCount(spawnData); i++)
				if ((pawn.Class == spawnData[i].spawnClass) && (pawn.Tag == spawnData[i].Tag))
					spawnData[i].count++;

		// check to see when the last one was killed and set the time correctly
		for (i=0; i<ArrayCount(spawnData); i++)
			if ((spawnData[i].count == 0) && (spawnData[i].lastKilledTime == -1))
				spawnData[i].lastKilledTime = Level.TimeSeconds;

		// spawn any monsters which have been missing for 20 seconds
		for (i=0; i<ArrayCount(spawnData); i++)
		{
			if ((spawnData[i].count == 0) && (Level.TimeSeconds - spawnData[i].lastKilledTime > 20))
			{
				SP = GetSpawnPoint(spawnData[i].spawnTag);
				if (SP != None)
				{
					// draw some light effects
					Spawn(class'ExplosionLight',,, SP.Location);
					Spawn(class'EllipseEffect',,, SP.Location);
					sphere = Spawn(class'SphereEffect',,, SP.Location);
					if (sphere != None)
						sphere.size = 4.0;

					// draw some electricity effects
					for (j=0; j<4; j++)
					{
						loc = vect(0,0,0);
						loc.Z = 32.0 + 32.0 * j;
						elec = Spawn(class'ElectricityEmitter',,, SP.Location + loc, rot(16384,0,0));
						if (elec != None)
						{
							elec.LifeSpan = 1.0;
							elec.randomAngle = 32768.0;
						}
					}

					// play a sound
					SP.PlaySound(sound'Spark1', SLOT_None, 2.0,, 2048.0, 2.0);

					// spawn the actual monster
					pawn = Spawn(spawnData[i].spawnClass, None, spawnData[i].Tag, SP.Location, SP.Rotation);
					if (pawn != None)
					{
						pawn.InitializePawn();
						pawn.SetOrders('Patrolling', spawnData[i].orderTag);
						pawn.ChangeAlly('Player', -1, True);
						pawn.ChangeAlly('MJ12', 0, True);
						spawnData[i].lastKilledTime = -1;
					}
				}
			}

			// reset the count for the next pass
			spawnData[i].count = 0;
		}

		// play datalinks when devices are frobbed
		if (!flags.GetBool('MS_DL_Played'))
		{
			count = 0;

			if (flags.GetBool('Node1_Frobbed'))
				count++;
			if (flags.GetBool('Node2_Frobbed'))
				count++;
			if (flags.GetBool('Node3_Frobbed'))
				count++;
			if (flags.GetBool('Node4_Frobbed'))
				count++;

			if ((count == 1) && (!flags.GetBool('DL_Blue1_Played')))
				Player.StartDataLinkTransmission("DL_Blue1");
			else if ((count == 2) && (!flags.GetBool('DL_Blue2_Played')))
				Player.StartDataLinkTransmission("DL_Blue2");
			else if ((count == 3) && (!flags.GetBool('DL_Blue3_Played')))
				Player.StartDataLinkTransmission("DL_Blue3");
			else if ((count == 4) && (!flags.GetBool('DL_Blue4_Played')))
			{
				Player.StartDataLinkTransmission("DL_Blue4");
				flags.SetBool('MS_DL_Played', True,, 16);
			}
		}

		// spawn a bunch of explosions when page is dead
		if (flags.GetBool('killpage') &&
			!flags.GetBool('MS_PageExploding'))
		{
			foreach AllActors(class'BobPageAugmented', tempPage)
				page = tempPage;

			pageTimer = Level.TimeSeconds;
			flags.SetBool('MS_PageExploding', True,, 16);
		}

		if (flags.GetBool('MS_PageExploding'))
		{
			if (Level.TimeSeconds - pageTimer >= 3.0)
				PageExplosionEffects();

			if ((Level.TimeSeconds - pageTimer >= 6.0) && !flags.GetBool('MS_PageDestroyed'))
			{
				foreach AllActors(class'DeusExMover', M, 'platform_pieces')
					M.BlowItUp(Player);
				foreach AllActors(class'LifeSupportBase', base)
					base.Destroy();

				if (page != None)
				{
					page.Destroy();
					page = None;
				}

				flags.SetBool('MS_PageDestroyed', True,, 16);
			}

			if (Level.TimeSeconds - pageTimer >= 9.0)
			{
				foreach AllActors(class'Actor', A, 'start_endgame')
					A.Trigger(Self, None);
			}
		}
	}
}

function PageExplosionEffects()
{
	local float shakeTime, shakeRoll, shakeVert;
	local float size;
	local int i;
	local Vector bobble, loc, endloc, HitLocation, HitNormal;
	local Actor HitActor;
	local MetalFragment frag;

	// pick a random explosion size and modify everything accordingly
	size = 0.5 * FRand() + 0.5;
	shakeTime = 0.5 + size;
	shakeRoll = 512.0 + 1024.0 * size;
	shakeVert = 8.0 + 16.0 * size;

	// play a sound
	if (size < 0.75)
		Player.PlaySound(Sound'MediumExplosion2', SLOT_None, 2.0,, 16384);
	else if (size < 0.85)
		Player.PlaySound(Sound'LargeExplosion1', SLOT_None, 2.0,, 16384);
	else
		Player.PlaySound(Sound'LargeExplosion2', SLOT_None, 2.0,, 16384);

	// shake the view
	Player.ShakeView(shakeTime, shakeRoll, shakeVert);

	// bobble the player around
	bobble = vect(300.0,300.0,200.0) + 500.0 * size * VRand();
	Player.Velocity += bobble;

	// have random metal fragments fall from the ceiling
	for (i=0; i<Int(size*10.0); i++)
	{
		if (page != None)
		{
			loc = page.Location + 64.0 * VRand();
			loc.Z = page.Location.Z;
		}
		else
		{
			loc = Player.Location + 256.0 * VRand();
			loc.Z = Player.Location.Z;
		}
		endloc = loc;
		endloc.Z += 1024.0;
		HitActor = Trace(HitLocation, HitNormal, endloc, loc, False);
		if (HitActor == None)
			HitLocation = endloc;

		// spawn some explosion effects
		if (size < 0.75)
			Spawn(class'ExplosionMedium',,, HitLocation+8*HitNormal);
		else
			Spawn(class'ExplosionLarge',,, HitLocation+8*HitNormal);

		frag = Spawn(class'MetalFragment',,, HitLocation);
		if (frag != None)
		{
			frag.CalcVelocity(vect(20000,0,0),256);
			frag.DrawScale = 0.5 + 2.0 * FRand();
			if (FRand() < 0.5)
				frag.bSmoking = True;
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     spawnData(0)=(SpawnTag=UC_spawn1,SpawnClass=Class'DeusEx.SpiderBot2',Tag=spbot1,OrderTag=spiderbot1_0,lastKilledTime=-1.000000)
     spawnData(1)=(SpawnTag=UC_spawn1,SpawnClass=Class'DeusEx.SpiderBot2',Tag=spbot2,OrderTag=spiderbot2_0,lastKilledTime=-1.000000)
     spawnData(2)=(SpawnTag=UC_spawn2,SpawnClass=Class'DeusEx.Gray',Tag=gray_1,OrderTag=gray1_0,lastKilledTime=-1.000000)
     spawnData(3)=(SpawnTag=UC_spawn2,SpawnClass=Class'DeusEx.Gray',Tag=gray_2,OrderTag=gray2_0,lastKilledTime=-1.000000)
     spawnData(4)=(SpawnTag=UC_spawn2,SpawnClass=Class'DeusEx.Gray',Tag=gray_3,OrderTag=gray3_0,lastKilledTime=-1.000000)
     spawnData(5)=(SpawnTag=UC_spawn3,SpawnClass=Class'DeusEx.Karkian',Tag=karkian_1,OrderTag=karkian1_0,lastKilledTime=-1.000000)
     spawnData(6)=(SpawnTag=UC_spawn3,SpawnClass=Class'DeusEx.Karkian',Tag=karkian_2,OrderTag=karkian2_0,lastKilledTime=-1.000000)
     spawnData(7)=(SpawnTag=UC_spawn3,SpawnClass=Class'DeusEx.Karkian',Tag=karkian_3,OrderTag=karkian3_0,lastKilledTime=-1.000000)
     spawnData(8)=(SpawnTag=UC_spawn3,SpawnClass=Class'DeusEx.Greasel',Tag=greasel_1,OrderTag=greasel1_0,lastKilledTime=-1.000000)
     spawnData(9)=(SpawnTag=UC_spawn3,SpawnClass=Class'DeusEx.Greasel',Tag=greasel_2,OrderTag=greasel2_0,lastKilledTime=-1.000000)
     spawnData(10)=(SpawnTag=UC_spawn3,SpawnClass=Class'DeusEx.Greasel',Tag=greasel_3,OrderTag=greasel3_0,lastKilledTime=-1.000000)
     spawnData(11)=(SpawnTag=UC_spawn3,SpawnClass=Class'DeusEx.Greasel',Tag=greasel_4,OrderTag=greasel4_0,lastKilledTime=-1.000000)
}
