//=============================================================================
// DeusExMover.
//=============================================================================
class DeusExMover extends Mover;

var() bool 				bOneWay;				// this door can only be opened from one side
var() bool 				bLocked;				// this door is locked
var() bool 				bPickable;				// this lock can be picked
var() float 			lockStrength;			// "toughness" of the lock on this door - 0.0 is easy, 1.0 is hard
var() float          initiallockStrength; // for resetting lock, initial lock strength of door.
var() bool           bInitialLocked;      // for resetting lock
var() bool 				bBreakable;				// this door can be destroyed
var() float				doorStrength;			// "toughness" of this door - 0.0 is weak, 1.0 is strong
var() name				KeyIDNeeded;			// key ID code to open the door
var() bool				bHighlight;				// should this door highlight when focused?
var() bool				bFrobbable;				// this door can be frobbed

var bool				bPicking;				// a lockpick is currently being used
var float				pickValue;				// how much this lockpick is currently picking
var float				pickTime;				// how much time it takes to use a single lockpick
var int					numPicks;				// how many times to reduce hack strength
var float            TicksSinceLastPick; //num ticks done since last pickstrength update(includes partials)
var float            TicksPerPick;       // num ticks needed for a hackstrength update (includes partials)
var float			 LastTickTime;		 // Time at which last tick occurred.

var DeusExPlayer		pickPlayer;				// the player that is picking
var Lockpick			curPick;				// the lockpick that is being used

var() int 				minDamageThreshold;		// damage below this amount doesn't count
var bool				bDestroyed;				// has this mover already been destroyed?

var() int				NumFragments;			// number of fragments to spew on destroy
var() float				FragmentScale;			// scale of fragments
var() int				FragmentSpread;			// distance fragments will be thrown
var() class<Fragment>	FragmentClass;			// which fragment
var() texture			FragmentTexture;		// what texture to use on fragments
var() bool				bFragmentTranslucent;	// are these fragments translucent?
var() bool				bFragmentUnlit;			// are these fragments unlit?
var() sound				ExplodeSound1;			// small explosion sound
var() sound				ExplodeSound2;			// large explosion sound
var() bool				bDrawExplosion;			// should we draw an explosion?
var() bool				bIsDoor;				// is this mover an actual door?

var() float          TimeSinceReset;   // how long since we relocked it
var() float          TimeToReset;      // how long between relocks

var localized string	msgKeyLocked;			// message when key locked door
var localized string	msgKeyUnlocked;			// message when key unlocked door
var localized string	msgLockpickSuccess;		// message when lock is picked
var localized string	msgOneWayFail;			// message when one-way door can't be opened
var localized string	msgLocked;				// message when the door is locked
var localized string	msgPicking;				// message when the door is being picked
var localized string	msgAlreadyUnlocked;		// message when the door is already unlocked
var localized string	msgNoNanoKey;			// message when the player doesn't have the right nanokey

function PostBeginPlay()
{
	Super.PostBeginPlay();

	// keep these within limits
	lockStrength = FClamp(lockStrength, 0.0, 1.0);
	doorStrength = FClamp(doorStrength, 0.0, 1.0);

	if (!bPickable)
		lockStrength = 1.0;
	if (!bBreakable)
		doorStrength = 1.0;

   initiallockStrength = lockStrength;
   TimeSinceReset = 0.0;
   bInitialLocked = bLocked;
}


// -------------------------------------------------------------------------------
// Network Replication
// -------------------------------------------------------------------------------

replication
{
   //Variables server to client
   reliable if (Role == ROLE_Authority)
      bLocked, pickValue, lockStrength, doorStrength;
}

//
// ComputeMovementArea() - Computes a bounding box for the area
//                         in which this mover will move
//
function ComputeMovementArea(out vector center, out vector area)
{
	local int     i, j;
	local float   mult;
	local int     count;
	local vector  box1, box2;
	local vector  minVect;
	local vector  maxVect;
	local vector  newLocation;
	local rotator newRotation;

	if (NumKeys > 0)  // better safe than silly
	{
		// Initialize our bounding box
		GetBoundingBox(box1, box2, false, KeyPos[0]+BasePos, KeyRot[0]+BaseRot);

		// Compute the total area of our bounding box
		for (i=1; i<NumKeys; i++)
		{
			if (KeyRot[i] == KeyRot[i-1])
				count = 1;
			else
				count = 3;
			for (j=0; j<count; j++)
			{
				mult = float(j+1)/count;
				newLocation = BasePos + (KeyPos[i]-KeyPos[i-1])*mult + KeyPos[i-1];
				newRotation = BaseRot + (KeyRot[i]-KeyRot[i-1])*mult + KeyRot[i-1];
				if (GetBoundingBox(minVect, maxVect, false, newLocation, newRotation))
				{
					// Expand the bounding box
					box1.X = FMin(FMin(box1.X, maxVect.X), minVect.X);
					box1.Y = FMin(FMin(box1.Y, maxVect.Y), minVect.Y);
					box1.Z = FMin(FMin(box1.Z, maxVect.Z), minVect.Z);
					box2.X = FMax(FMax(box2.X, maxVect.X), minVect.X);
					box2.Y = FMax(FMax(box2.Y, maxVect.Y), minVect.Y);
					box2.Z = FMax(FMax(box2.Z, maxVect.Z), minVect.Z);
				}
			}
		}
	}

	// Fallback
	else
	{
		box1 = vect(0,0,0);
		box2 = vect(0,0,0);
	}

	// Compute center/area of the bounding box and return
	center = (box1+box2)/2;
	area = box2 - center;

}

//
// FinishNotify() - overridden from Mover; called when mover has finished moving
//
function FinishNotify()
{
	local Pawn   curPawn;
	local vector box1, box2;
	local vector center, area;
	local float  distX, distY, distZ;
	local float  maxX, maxY, maxZ;
	local float  dist;
	local float  maxDist;
	local vector tempVect;
	local bool   bNotify;

	Super.FinishNotify();

	if ((NumKeys > 0) && (MoverEncroachType == ME_IgnoreWhenEncroach))
	{
		GetBoundingBox(box1, box2, false, KeyPos[KeyNum]+BasePos, KeyRot[KeyNum]+BaseRot);
		center  = (box1+box2)/2;
		area    = box2 - center;
		maxDist = VSize(area)+200;
      // XXXDEUS_EX AMSD Slow Pawn Iterator
		//foreach RadiusActors(Class'Pawn', curPawn, maxDist)
      for (CurPawn = Level.PawnList; CurPawn != None; CurPawn = CurPawn.NextPawn)
		{
         if ((CurPawn != None) && (VSize(CurPawn.Location - Location) < (MaxDist + CurPawn.CollisionRadius)))
         {
            bNotify = false;
            distZ = Abs(center.Z - curPawn.Location.Z);
            maxZ  = area.Z + curPawn.CollisionHeight;
            if (distZ < maxZ)
            {
               distX = Abs(center.X - curPawn.Location.X);
               distY = Abs(center.Y - curPawn.Location.Y);
               maxX  = area.X + curPawn.CollisionRadius;
               maxY  = area.Y + curPawn.CollisionRadius;
               if ((distX < maxX) && (distY < maxY))
               {
                  if ((distX >= area.X) && (distY >= area.Y))
                  {
                     tempVect.X = distX-area.X;
                     tempVect.Y = distY-area.Y;
                     tempVect.Z = 0;
                     if (VSize(tempVect) < CollisionRadius)
                        bNotify = true;
                  }
                  else
                     bNotify = true;
               }
            }
            if (bNotify)
               curPawn.EncroachedByMover(self);
         }
		}
	}
}

//
// DropThings() - drops everything that is based on this mover
//
function DropThings()
{
	local actor A;

	// drop everything that is on us
	foreach BasedActors(class'Actor', A)
		A.SetPhysics(PHYS_Falling);
}

//
// "Destroy" the mover
//
function BlowItUp(Pawn instigatedBy)
{
	local int i;
	local Fragment frag;
	local Actor A;
	local DeusExDecal D;
	local Vector spawnLoc;
	local ExplosionLight light;

	// force the mover to stop
	if (Leader != None)
		Leader.MakeGroupStop();

	Instigator = instigatedBy;

	// trigger our event
	if (Event != '')
		foreach AllActors(class'Actor', A, Event)
			if (A != None)
				A.Trigger(Self, instigatedBy);

	// destroy all effects that are on us
	foreach BasedActors(class'DeusExDecal', D)
		D.Destroy();

	DropThings();

	// get the origin of the mover
	spawnLoc = Location - (PrePivot >> Rotation);

	// spawn some fragments and make a sound
	for (i=0; i<NumFragments; i++)
	{
		frag = Spawn(FragmentClass,,, spawnLoc + FragmentSpread * VRand());
		if (frag != None)
		{
			frag.Instigator = instigatedBy;

			// make the last fragment just drop down so we have something to attach the sound to
			if (i == NumFragments - 1)
				frag.Velocity = vect(0,0,0);
			else
				frag.CalcVelocity(VRand(), FragmentSpread);

			frag.DrawScale = FragmentScale;
			if (FragmentTexture != None)
				frag.Skin = FragmentTexture;
			if (bFragmentTranslucent)
				frag.Style = STY_Translucent;
			if (bFragmentUnlit)
				frag.bUnlit = True;
		}
	}

	// should we draw explosion effects?
	if (bDrawExplosion)
	{
		light = Spawn(class'ExplosionLight',,, spawnLoc);
		if (FragmentSpread < 64)
		{
			Spawn(class'ExplosionSmall',,, spawnLoc);
			if (light != None)
				light.size = 2;
		}
		else if (FragmentSpread < 128)
		{
			Spawn(class'ExplosionMedium',,, spawnLoc);
			if (light != None)
				light.size = 4;
		}
		else
		{
			Spawn(class'ExplosionLarge',,, spawnLoc);
			if (light != None)
				light.size = 8;
		}
	}

	// alert NPCs that I'm breaking
	AISendEvent('LoudNoise', EAITYPE_Audio, 2.0, FragmentSpread * 16);

	MakeNoise(2.0);
	if (frag != None)
	{
		if (NumFragments <= 5)
			frag.PlaySound(ExplodeSound1, SLOT_None, 2.0,, FragmentSpread*256);
		else
			frag.PlaySound(ExplodeSound2, SLOT_None, 2.0,, FragmentSpread*256);
	}

   //DEUS_EX AMSD Mover is dead, make it a dumb proxy so location updates
   RemoteRole = ROLE_DumbProxy;
	SetLocation(Location+vect(0,0,20000));		// move it out of the way
	SetCollision(False, False, False);			// and make it non-colliding
	bDestroyed = True;
}

//
// SupportActor()
//
// Called when somebody lands on us (copied from DeusExDecoration)
//

singular function SupportActor(Actor standingActor)
{
	local float  zVelocity;
	local float  baseMass;
	local float  standingMass;

	zVelocity = standingActor.Velocity.Z;
	// We've been stomped!
	if (zVelocity < -500)
	{
		standingMass = FMax(1, standingActor.Mass);
		baseMass     = FMax(1, Mass);
		TakeDamage((1 - standingMass/baseMass * zVelocity/30),
		           standingActor.Instigator, standingActor.Location, 0.2*standingActor.Velocity, 'stomped');
	}

	if (!bDestroyed)
		standingActor.SetBase(self);
	else
		standingActor.SetPhysics(PHYS_Falling);
}


//
// Copied from Engine.Mover
//
function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
{
	if (bDestroyed)
		return;

	if ((damageType == 'TearGas') || (damageType == 'PoisonGas') || (damageType == 'HalonGas'))
		return;

	if ((damageType == 'Stunned') || (damageType == 'Radiation'))
		return;

	if ((DamageType == 'EMP') || (DamageType == 'NanoVirus') || (DamageType == 'Shocked'))
		return;

	if (bBreakable)
	{
		// add up the damage
		if (Damage >= minDamageThreshold)
			doorStrength -= Damage * 0.01;
//		else
//			doorStrength -= Damage * 0.001;		// damage below the threshold does 1/10th the damage

		doorStrength = FClamp(doorStrength, 0.0, 1.0);
		if (doorStrength ~= 0.0)
			BlowItUp(instigatedBy);
	}
}

//
// Called every 0.1 seconds while the pick is actually picking
//
function Timer()
{
	local DeusExMover M;

	if (bPicking)
	{
		curPick.PlayUseAnim();

	  TicksSinceLastPick += (Level.TimeSeconds - LastTickTime) * 10;
	  LastTickTime = Level.TimeSeconds;
      //TicksSinceLastPick = TicksSinceLastPick + 1;
      while (TicksSinceLastPick > TicksPerPick)
      {
         numPicks--;
         lockStrength -= 0.01;
         TicksSinceLastPick = TicksSinceLastPick - TicksPerPick;      
         lockStrength = FClamp(lockStrength, 0.0, 1.0);
      }

		// pick all like-tagged movers at once (for double doors and such)
		if ((Tag != '') && (Tag != 'DeusExMover'))
			foreach AllActors(class'DeusExMover', M, Tag)
				if (M != Self)
					M.lockStrength = lockStrength;

		// did we unlock it?
		if (lockStrength ~= 0.0)
		{
			lockStrength = 0.0;
			bLocked = False;
         TimeSinceReset = 0.0;

			// unlock all like-tagged movers at once (for double doors and such)
			if ((Tag != '') && (Tag != 'DeusExMover'))
				foreach AllActors(class'DeusExMover', M, Tag)
					if (M != Self)
					{
						M.bLocked = False;
						M.TimeSinceReset = 0;
						M.lockStrength = 0.0;
					}

			pickPlayer.ClientMessage(msgLockpickSuccess);
			StopPicking();
		}

		// are we done with this pick?
		else if (numPicks <= 0)
			StopPicking();

		// check to see if we've moved too far away from the door to continue
		else if (pickPlayer.frobTarget != Self)
			StopPicking();

		// check to see if we've put the lockpick away
		else if (pickPlayer.inHand != curPick)
			StopPicking();
	}
}

//
// Called to deal with resetting the device
//
function Tick(float deltaTime)
{
   TimeSinceReset = TimeSinceReset + deltaTime;
   //only reset in multiplayer, if we aren't picking it, and if it has been completely unlocked
   if ((!bPicking) && (Level.NetMode != NM_Standalone) && (lockStrength == 0.0) && !(bLocked))
   {
      if (TimeSinceReset > TimeToReset)
      {
         lockStrength = initiallockStrength;
         TimeSinceReset = 0.0;
         if (lockStrength > 0)
		 {
			 //Force door closed and locked appropriately.
			 DoClose();
			 bLocked = bInitialLocked;
		 }
      }
   }
   // In multi, force it closed if locked.  Keep trying until it closes.
   if ((Level.NetMode != NM_Standalone) && (bLocked) && (KeyNum != 0))
	   DoClose();
   Super.Tick(deltaTime);
}

//
// Stops the current pick-in-progress
//
function StopPicking()
{
	// alert NPCs that I'm not messing with stuff anymore
	AIEndEvent('MegaFutz', EAITYPE_Visual);
	bPicking = False;
	if (curPick != None)
	{
		curPick.StopUseAnim();
		curPick.bBeingUsed = False;
		curPick.UseOnce();
	}
	curPick = None;
	SetTimer(0.1, False);
}

//
// The main logic function for doors
//
function Frob(Actor Frobber, Inventory frobWith)
{
	local Pawn P;
	local DeusExPlayer Player;
	local bool bOpenIt, bDone;
	local string msg;
	local Vector X, Y, Z;
	local float dotp;
	local DeusExMover M;

	// if we shouldn't be frobbed, get out
	if (!bFrobbable)
		return;

	// if we are destroyed, don't do anything
	if (bDestroyed)
		return;

	// make sure we frob our leader if we are a slave
	if (bSlave)
		if (Leader != None)
			Leader.Frob(Frobber, frobWith);

	P = Pawn(Frobber);
	Player = DeusExPlayer(P);
	bOpenIt = False;
	bDone = False;
	msg = msgLocked;

	// make sure someone is trying to open the door
	if (P == None)
		return;

	// ugly hack, so animals can't open doors
	if (P.IsA('Animal'))
		return;

	// Let any non-player pawn open any door for now
	if (Player == None)
	{
		bOpenIt = True;
		msg = "";
		bDone = True;
	}

	// If we are already trying to pick it, print a message
	if (bPicking)
	{
		msg = msgPicking;
		bDone = True;
	}

	// If the door is not closed, it can always be closed no matter what
	if ((KeyNum != 0) || (PrevKeyNum != 0))
	{
		bOpenIt = True;
		msg = "";
		bDone = True;
	}

	// check to see if this is a one-way door
	if (!bDone && bOneWay)
	{
		GetAxes(Rotation, X, Y, Z);
		dotp = (Location - Frobber.Location) dot X;

		// if we're on the wrong side of the door, then don't open
		if (dotp > 0.0)
		{
			bOpenIt = False;
			msg = msgOneWayFail;
			bDone = True;
		}
	}

	//
	// If the door is locked, the player must do one of the following to open it
	// without triggers or explosions:
	// 1. Use the KeyIDNeeded 
	// 2. Use the Lockpick and SkillLockpicking
	//
	if (!bDone)
	{
		// Get what's in the player's hand
		if (frobWith != None)
		{
			// check for the use of lockpicks
			if (bPickable && frobWith.IsA('Lockpick') && (Player.SkillSystem != None))
			{
				if (bLocked)
				{
					// alert NPCs that I'm messing with stuff
					AIStartEvent('MegaFutz', EAITYPE_Visual);

					pickValue = Player.SkillSystem.GetSkillLevelValue(class'SkillLockpicking');
					pickPlayer = Player;
					curPick = LockPick(frobWith);
					curPick.bBeingUsed = True;
					curPick.PlayUseAnim();
					bPicking = True;
               //DEUS_EX AMSD In multiplayer, slow it down further at low skill levels
               numPicks = PickValue * 100;
               if (Level.Netmode != NM_Standalone)
                  pickTime = default.pickTime / (pickValue * pickValue);
               TicksPerPick = (PickTime * 10.0) / numPicks;
			   LastTickTime = Level.TimeSeconds;
               TicksSinceLastPick = 0;
					SetTimer(0.1, True);
					msg = msgPicking;
				}
				else
				{
					msg = msgAlreadyUnlocked;
				}
			}
			else if ((KeyIDNeeded != '') && frobWith.IsA('NanoKeyRing') && (lockStrength > 0.0))
			{
				// check for the correct key use
				NanoKeyRing(frobWith).PlayUseAnim();
				if (NanoKeyRing(frobWith).HasKey(KeyIDNeeded))
				{
					bLocked = !bLocked;		// toggle the lock state
					TimeSinceReset = 0;

					// toggle the lock state for all like-tagged movers at once (for double doors and such)
					if ((Tag != '') && (Tag != 'DeusExMover'))
						foreach AllActors(class'DeusExMover', M, Tag)
							if (M != Self)
							{
								M.bLocked = !M.bLocked;
								M.TimeSinceReset = 0;
							}

					bOpenIt = False;
					if (bLocked)
						msg = msgKeyLocked;
					else
						msg = msgKeyUnlocked;
				}
				else if (bLocked)
				{
					bOpenIt = False;
					msg = msgNoNanoKey;
				}
				else
				{
					msg = msgAlreadyUnlocked;
				}
			}
			else if (!bLocked)
			{
				bOpenIt = True;
				msg = "";
			}
		}
		else if (!bLocked)
		{
			bOpenIt = True;
			msg = "";
		}
	}

	// give the player a message
	if ((Player != None) && (msg != ""))
		Player.ClientMessage(msg);

	// open it!
	if (bOpenIt)
	{
		Super.Frob(Frobber, frobWith);
		Trigger(Frobber, P);

		// trigger all like-tagged movers at once (for double doors and such)
		if ((Tag != '') && (Tag != 'DeusExMover'))
			foreach AllActors(class'DeusExMover', M, Tag)
				if (M != Self)
					M.Trigger(Frobber, P);
	}
}

function DoOpen()
{
	local DeusExMover M;
	if (Level.NetMode != NM_Standalone)
	{
		// In multiplayer, unlock doors that get opened.
		// toggle the lock state for all like-tagged movers at once (for double doors and such)
		bLocked = false;
		TimeSinceReset = 0;
		lockStrength = 0.0;
		if ((Tag != '') && (Tag != 'DeusExMover'))
			foreach AllActors(class'DeusExMover', M, Tag)
			if (M != Self)
			{
				M.bLocked = false;
				M.TimeSinceReset = 0;
				M.lockStrength = 0;
			}
	}
	Super.DoOpen();
}

//
// make sure we can't be triggered after we've been destroyed
//
state() TriggerOpenTimed
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		if (!bDestroyed)
			Super.Trigger(Other, EventInstigator);
	}
}

state() TriggerToggle
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		if (!bDestroyed)
			Super.Trigger(Other, EventInstigator);
	}
}

state() TriggerControl
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		if (!bDestroyed)
			Super.Trigger(Other, EventInstigator);
	}
}

state() TriggerPound
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		if (!bDestroyed)
			Super.Trigger(Other, EventInstigator);
	}
}

defaultproperties
{
     bPickable=True
     lockStrength=0.200000
     doorStrength=0.250000
     bHighlight=True
     bFrobbable=True
     pickTime=4.000000
     minDamageThreshold=10
     NumFragments=16
     FragmentScale=2.000000
     FragmentSpread=32
     FragmentClass=Class'DeusEx.WoodFragment'
     ExplodeSound1=Sound'DeusExSounds.Generic.WoodBreakSmall'
     ExplodeSound2=Sound'DeusExSounds.Generic.WoodBreakLarge'
     TimeToReset=28.000000
     msgKeyLocked="Your NanoKey Ring locked it"
     msgKeyUnlocked="Your NanoKey Ring unlocked it"
     msgLockpickSuccess="You picked the lock"
     msgOneWayFail="It won't open from this side"
     msgLocked="It's locked"
     msgPicking="Picking the lock..."
     msgAlreadyUnlocked="It's already unlocked"
     msgNoNanoKey="Your NanoKey Ring doesn't have the right code"
     MoverEncroachType=ME_StopWhenEncroach
     BumpType=BT_PawnBump
     bBlockSight=True
     InitialState=TriggerToggle
     bDirectional=True
}
