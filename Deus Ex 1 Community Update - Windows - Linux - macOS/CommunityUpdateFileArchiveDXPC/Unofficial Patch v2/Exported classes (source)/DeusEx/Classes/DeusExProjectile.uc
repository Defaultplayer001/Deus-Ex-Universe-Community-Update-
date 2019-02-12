//=============================================================================
// DeusExProjectile.
//=============================================================================
class DeusExProjectile extends Projectile
	abstract;

var bool bExplodes;				// does this projectile explode?
var bool bBlood;				// does this projectile cause blood?
var bool bDebris;				// does this projectile cause debris?
var bool bStickToWall;			// does this projectile stick to walls?
var bool bStuck;				// is this projectile stuck to the wall?
var vector initDir;				// initial direction of travel
var float blastRadius;			// radius to explode
var Actor damagee;				// who is being damaged
var name damageType;			// type of damage that this projectile does
var int AccurateRange;			// maximum accurate range in world units (feet * 16)
var int MaxRange;				// maximum range in world units (feet * 16)
var vector initLoc;				// initial location for range tracking
var bool bTracking;				// should this projectile track a target?
var Actor Target;				// what target we are tracking
var float time;					// misc. timer
var float MinDrawScale;
var float MaxDrawScale;

var vector LastSeenLoc;    // Last known location of target
var vector NetworkTargetLoc; // For network propagation (non relevant targets)
var bool bHasNetworkTarget;
var bool bHadLocalTarget;

var int gradualHurtSteps;		// how many separate explosions for the staggered HurtRadius
var int gradualHurtCounter;		// which one are we currently doing

var bool bEmitDanger;
var class<DeusExWeapon>	spawnWeaponClass;	// weapon to give the player if this projectile is disarmed and frobbed
var class<Ammo>			spawnAmmoClass;		// weapon to give the player if this projectile is disarmed and frobbed

var bool bIgnoresNanoDefense; //True if the aggressive defense aug does not blow this up.

var bool bAggressiveExploded; //True if exploded by Aggressive Defense 

var localized string itemName;		// human readable name
var localized string	itemArticle;	// article much like those for weapons

// network replication
replication
{
   //server to client
   reliable if (Role == ROLE_Authority)
      bTracking, Target, bAggressiveExploded, bHasNetworkTarget, NetworkTargetLoc;
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

   if (bEmitDanger)
		AIStartEvent('Projectile', EAITYPE_Visual);
}

//
// Let the player pick up stuck projectiles
//
function Frob(Actor Frobber, Inventory frobWith)
{
	Super.Frob(Frobber, frobWith);

	// if the player frobs it and it's stuck, the player can grab it
	if (bStuck)
		GrabProjectile(DeusExPlayer(Frobber));
}

function GrabProjectile(DeusExPlayer player)
{
	local Inventory item;

	if (player != None)
	{
		if (spawnWeaponClass != None)		// spawn the weapon
		{
			item = Spawn(spawnWeaponClass);
			if (item != None)
			{
				if ( (Level.NetMode != NM_Standalone ) && Self.IsA('Shuriken'))
					DeusExWeapon(item).PickupAmmoCount = DeusExWeapon(item).PickupAmmoCount * 3;
				else
					DeusExWeapon(item).PickupAmmoCount = 1;
			}
		}
		else if (spawnAmmoClass != None)	// or spawn the ammo
		{
			item = Spawn(spawnAmmoClass);
			if (item != None)
			{
				if ( (Level.NetMode != NM_Standalone ) && Self.IsA('Dart'))
					Ammo(item).AmmoAmount = Ammo(item).AmmoAmount * 3;
				else
					Ammo(item).AmmoAmount = 1;
			}
		}
		if (item != None)
		{
			player.FrobTarget = item;

			// check to see if we can pick up the new weapon/ammo
			if (player.HandleItemPickup(item))
			{
				Destroy();				// destroy the projectile on the wall
				if ( Level.NetMode != NM_Standalone )
				{
					if ( item != None )
						item.Destroy();
				}
			}
			else
				item.Destroy();			// destroy the weapon/ammo if it can't be picked up

			player.FrobTarget = None;
		}
	}
}

//
// update our flight path based on our ranges and tracking info
//
simulated function Tick(float deltaTime)
{
	local float dist, size;
	local Rotator dir;
   local vector TargetLocation; 
	local vector vel;
   local vector NormalHeading;
   local vector NormalDesiredHeading;
   local float HeadingDiffDot;
   local vector zerovec;

	if (bStuck)
		return;

	Super.Tick(deltaTime);

   if (VSize(LastSeenLoc) < 1)
   {
      LastSeenLoc = Location + Normal(Vector(Rotation)) * 10000;
   }

   if (Role == ROLE_Authority)
   {
      bHasNetworkTarget = (Target != None);
   }
   else
   {
      bHadLocalTarget = (bHadLocalTarget || (Target != None));
   }

	if (bTracking && ((Target != None) || ((Level.NetMode != NM_Standalone) && (bHasNetworkTarget)) || ((Level.Netmode != NM_Standalone) && (bHadLocalTarget))))
	{
		// check it's range
		dist = Abs(VSize(Target.Location - Location));
		if (dist > MaxRange)
		{
			// if we're out of range, lose the lock and quit tracking
			bTracking = False;
			Target = None;
			return;
		}
		else
		{
			// get the direction to the target
         if (Level.NetMode == NM_Standalone)
            TargetLocation = Target.Location;
         else
            TargetLocation = AcquireMPTargetLocation();
         if (Role == ROLE_Authority)
            NetworkTargetLoc = TargetLocation;
         LastSeenLoc = TargetLocation;
			dir = Rotator(TargetLocation - Location);
			dir.Roll = 0;

         if (Level.Netmode != NM_Standalone)
         {
            NormalHeading = Normal(Vector(Rotation));
            NormalDesiredHeading = Normal(TargetLocation - Location);
            HeadingDiffDot = NormalHeading Dot NormalDesiredHeading;
         }

			// set our new rotation
			bRotateToDesired = True;
			DesiredRotation = dir;

			// move us in the new direction that we are facing
			size = VSize(Velocity);
			vel = Normal(Vector(Rotation));

         if (Level.NetMode != NM_Standalone)
         {
            size = FMax(HeadingDiffDot,0.4) * Speed;
         }
			Velocity = vel * size;
		}
	}
   else
   {
      // make the rotation match the velocity direction
		SetRotation(Rotator(Velocity));
   }

	dist = Abs(VSize(initLoc - Location));

	if (dist > AccurateRange)		// start descent due to "gravity"
		Acceleration = Region.Zone.ZoneGravity / 2;

   if ((Role < ROLE_Authority) && (bAggressiveExploded))
      Explode(Location, vect(0,0,1));
}

function Timer()
{
   if (bStuck)
      Destroy();
}

simulated function vector AcquireMPTargetLocation()
{   	
   local vector StartTrace, EndTrace, HitLocation, HitNormal;
	local Actor hit, retval;

   if (Target == None)
   {
      if (bHasNetworkTarget)
         return NetworkTargetLoc;
      else
         return LastSeenLoc;
   }

	StartTrace = Location;
   EndTrace = Target.Location;

   if (!Target.IsA('Pawn'))
      return Target.Location;

	foreach TraceActors(class'Actor', hit, HitLocation, HitNormal, EndTrace, StartTrace)
   {
		if (hit == Target)
			return Target.Location;
   }
      
   // adjust for eye height
	EndTrace.Z += Pawn(Target).BaseEyeHeight;

	foreach TraceActors(class'Actor', hit, HitLocation, HitNormal, EndTrace, StartTrace)
   {
		if (hit == Target)
			return EndTrace;
   }

	return LastSeenLoc;
}

function SpawnBlood(Vector HitLocation, Vector HitNormal)
{
	local int i;
	
   if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
      return;

   spawn(class'BloodSpurt',,,HitLocation+HitNormal);
	for (i=0; i<Damage/7; i++)
	{
		if (FRand() < 0.5)
			spawn(class'BloodDrop',,,HitLocation+HitNormal*4);
	}
}

simulated function SpawnEffects(Vector HitLocation, Vector HitNormal, Actor Other)
{
	local int i;
	local DeusExDecal mark;
   local Rockchip chip;

   // don't draw damage art on destroyed movers
	if (DeusExMover(Other) != None)
		if (DeusExMover(Other).bDestroyed)
			ExplosionDecal = None;

	// draw the explosion decal here, not in Engine.Projectile
	if (ExplosionDecal != None)
	{
		mark = DeusExDecal(Spawn(ExplosionDecal, Self,, HitLocation, Rotator(HitNormal)));
		if (mark != None)
		{
			mark.DrawScale = FClamp(damage/30, 0.5, 3.0);
			mark.ReattachDecal();
		}

		ExplosionDecal = None;
	}

   //DEUS_EX AMSD Don't spawn these on the server.
   if ((Level.NetMode == NM_DedicatedServer) && (Role == ROLE_Authority))
      return;

   if (bDebris)
	{
		for (i=0; i<Damage/5; i++)
			if (FRand() < 0.8)
         {
				chip = spawn(class'Rockchip',,,HitLocation+HitNormal);
            //DEUS_EX AMSD In multiplayer, don't propagate these to 
            //other players (or from the listen server to clients).
            if (chip != None)            
               chip.RemoteRole = ROLE_None;
         }
	}
}

simulated function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
	local ShockRing ring;
   local SphereEffect sphere;
	local ExplosionLight light;
   local AnimatedSprite expeffect;

	// draw a pretty explosion
	light = Spawn(class'ExplosionLight',,, HitLocation);
   if (light != None)
      light.RemoteRole = ROLE_None;

	if (blastRadius < 128)
	{
		expeffect = Spawn(class'ExplosionSmall',,, HitLocation);
		light.size = 2;
	}
	else if (blastRadius < 256)
	{
		expeffect = Spawn(class'ExplosionMedium',,, HitLocation);
		light.size = 4;
	}
	else
	{
		expeffect = Spawn(class'ExplosionLarge',,, HitLocation);
		light.size = 8;
	}

   if (expeffect != None)
      expeffect.RemoteRole = ROLE_None;

	// draw a pretty shock ring
   // For nano defense we are doing something else.
   if ((!bAggressiveExploded) || (Level.NetMode == NM_Standalone))
   {
      ring = Spawn(class'ShockRing',,, HitLocation, rot(16384,0,0));
      if (ring != None)
      {
         ring.RemoteRole = ROLE_None;
         ring.size = blastRadius / 32.0;
      }
      ring = Spawn(class'ShockRing',,, HitLocation, rot(0,0,0));
      if (ring != None)
      {
         ring.RemoteRole = ROLE_None;
         ring.size = blastRadius / 32.0;
      }
      ring = Spawn(class'ShockRing',,, HitLocation, rot(0,16384,0));
      if (ring != None)
      {
         ring.RemoteRole = ROLE_None;
         ring.size = blastRadius / 32.0;
      }
   }
   else
   {
      sphere = Spawn(class'SphereEffect',,, HitLocation, rot(16384,0,0));
      if (sphere != None)
      {
         sphere.RemoteRole = ROLE_None;
         sphere.size = blastRadius / 32.0;
      }
      sphere = Spawn(class'SphereEffect',,, HitLocation, rot(0,0,0));
      if (sphere != None)
      {
         sphere.RemoteRole = ROLE_None;
         sphere.size = blastRadius / 32.0;
      }
      sphere = Spawn(class'SphereEffect',,, HitLocation, rot(0,16384,0));
      if (sphere != None)
      {
         sphere.RemoteRole = ROLE_None;
         sphere.size = blastRadius / 32.0;
      }
   }
}

//
// Exploding state
//
state Exploding
{
	ignores ProcessTouch, HitWall, Explode;

   function DamageRing()
   {
		local Pawn apawn;
		local float damageRadius;
		local Vector dist;

		if ( Level.NetMode != NM_Standalone )
		{
			damageRadius = (blastRadius / gradualHurtSteps) * gradualHurtCounter;

			for ( apawn = Level.PawnList; apawn != None; apawn = apawn.nextPawn )
			{
				if ( apawn.IsA('DeusExPlayer') )
				{
					dist = apawn.Location - Location;
					if ( VSize(dist) < damageRadius )
					{
						if ( gradualHurtCounter <= 2 )
						{
							if ( apawn.FastTrace( apawn.Location, Location ))
								DeusExPlayer(apawn).myProjKiller = Self;
						}
						else
							DeusExPlayer(apawn).myProjKiller = Self;
					}
				}
			}
		}
      //DEUS_EX AMSD Ignore Line of Sight on the lowest radius check, only in multiplayer
		HurtRadius
		(
			(2 * Damage) / gradualHurtSteps,
			(blastRadius / gradualHurtSteps) * gradualHurtCounter,
			damageType,
			MomentumTransfer / gradualHurtSteps,
			Location,
         ((gradualHurtCounter <= 2) && (Level.NetMode != NM_Standalone))
		);
   }

	function Timer()
	{
		gradualHurtCounter++;
      DamageRing();
		if (gradualHurtCounter >= gradualHurtSteps)
			Destroy();
	}

Begin:
	// stagger the HurtRadius outward using Timer()
	// do five separate blast rings increasing in size
	gradualHurtCounter = 1;
	gradualHurtSteps = 5;
	Velocity = vect(0,0,0);
	bHidden = True;
	LightType = LT_None;
	SetCollision(False, False, False);
   DamageRing();
	SetTimer(0.25/float(gradualHurtSteps), True);
}

function PlayImpactSound()
{
	local float rad;

	if ((Level.NetMode == NM_Standalone) || (Level.NetMode == NM_ListenServer) || (Level.NetMode == NM_DedicatedServer))
	{
		rad = Max(blastRadius*4, 1024);
		PlaySound(ImpactSound, SLOT_None, 2.0,, rad);
	}
}

auto simulated state Flying
{
	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		if (bStuck)
			return;

		if ((Other != instigator) && (DeusExProjectile(Other) == None) &&
			(Other != Owner))
		{
			damagee = Other;
			Explode(HitLocation, Normal(HitLocation-damagee.Location));

         // DEUS_EX AMSD Spawn blood server side only
         if (Role == ROLE_Authority)
			{
            if (damagee.IsA('Pawn') && !damagee.IsA('Robot') && bBlood)
               SpawnBlood(HitLocation, Normal(HitLocation-damagee.Location));
			}
		}
	}
	simulated function HitWall(vector HitNormal, actor Wall)
	{
		if (bStickToWall)
		{
			Velocity = vect(0,0,0);
			Acceleration = vect(0,0,0);
			SetPhysics(PHYS_None);
			bStuck = True;

			// MBCODE: Do this only on server side
			if ( Role == ROLE_Authority )
			{
            if (Level.NetMode != NM_Standalone)
               SetTimer(5.0,False);

				if (Wall.IsA('Mover'))
				{
					SetBase(Wall);
					Wall.TakeDamage(Damage, Pawn(Owner), Wall.Location, MomentumTransfer*Normal(Velocity), damageType);
				}
			}
		}

		if (Wall.IsA('BreakableGlass'))
			bDebris = False;

		SpawnEffects(Location, HitNormal, Wall);

		Super.HitWall(HitNormal, Wall);
	}
	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		local bool bDestroy;
		local float rad;

      // Reduce damage on nano exploded projectiles
      if ((bAggressiveExploded) && (Level.NetMode != NM_Standalone))
         Damage = Damage/6;

		bDestroy = false;

		if (bExplodes)
		{
         //DEUS_EX AMSD Don't draw effects on dedicated server
         if ((Level.NetMode != NM_DedicatedServer) || (Role < ROLE_Authority))			
            DrawExplosionEffects(HitLocation, HitNormal);

			GotoState('Exploding');
		}
		else
		{
			// Server side only
			if ( Role == ROLE_Authority )
			{
				if ((damagee != None) && (Tracer(Self) == None)) // Don't even attempt damage with a tracer
				{
					if ( Level.NetMode != NM_Standalone )
					{
						if ( damagee.IsA('DeusExPlayer') )
							DeusExPlayer(damagee).myProjKiller = Self;
					}
					damagee.TakeDamage(Damage, Pawn(Owner), HitLocation, MomentumTransfer*Normal(Velocity), damageType);
				}
			}
			if (!bStuck)
				bDestroy = true;
		}

		rad = Max(blastRadius*24, 1024);

		// This needs to be outside the simulated call chain
		PlayImpactSound();

      //DEUS_EX AMSD Only do these server side
      if (Role == ROLE_Authority)
      {
         if (ImpactSound != None)
         {
            AISendEvent('LoudNoise', EAITYPE_Audio, 2.0, blastRadius*24);
            if (bExplodes)
               AISendEvent('WeaponFire', EAITYPE_Audio, 2.0, blastRadius*5);
         }
      }
		if (bDestroy)
			Destroy();
	}
	simulated function BeginState()
	{
		local DeusExWeapon W;

		initLoc = Location;
		initDir = vector(Rotation);	
		Velocity = speed*initDir;
		PlaySound(SpawnSound, SLOT_None);
	}
}

defaultproperties
{
     AccurateRange=800
     maxRange=1600
     MinDrawScale=0.050000
     maxDrawScale=2.500000
     bEmitDanger=True
     ItemName="DEFAULT PROJECTILE NAME - REPORT THIS AS A BUG"
     ItemArticle="Error"
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=60.000000
     RotationRate=(Pitch=65536,Yaw=65536)
}
