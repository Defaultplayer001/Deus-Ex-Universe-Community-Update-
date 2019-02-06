//=============================================================================
// AugDefense.
//=============================================================================
class AugDefense extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;
var bool bDefenseActive;

var float defenseSoundTime;
const defenseSoundDelay = 2;

// ----------------------------------------------------------------------------
// Networking Replication
// ----------------------------------------------------------------------------

replication
{
   //server to client variable propagation.
   reliable if (Role == ROLE_Authority)
      bDefenseActive;

   //server to client function call
   reliable if (Role == ROLE_Authority)
      TriggerDefenseAugHUD, SetDefenseAugStatus;
}

state Active
{
	function Timer()
	{
		local DeusExProjectile minproj;
		local float mindist;

		minproj = None;

		// DEUS_EX AMSD Multiplayer check
		if (Player == None)
		{
		 SetTimer(0.1,False);
		 return;
		}

		// In multiplayer propagate a sound that will let others know their in an aggressive defense field
		// with range slightly greater than the current level value of the aug
		if ( (Level.NetMode != NM_Standalone) && ( Level.Timeseconds > defenseSoundTime ))
		{
			Player.PlaySound(Sound'AugDefenseOn', SLOT_Interact, 1.0, ,(LevelValues[CurrentLevel]*1.33), 0.75);
			defenseSoundTime = Level.Timeseconds + defenseSoundDelay;
		}

		//DEUS_EX AMSD Exported to function call for duplication in multiplayer.
		minproj = FindNearestProjectile();

		// if we have a valid projectile, send it to the aug display window
		if (minproj != None)
		{
			 bDefenseActive = True;
			 mindist = VSize(Player.Location - minproj.Location);
			
			 // DEUS_EX AMSD In multiplayer, let the client turn his HUD on here.
			 // In singleplayer, turn it on normally.
			 if (Level.Netmode != NM_Standalone)
			    TriggerDefenseAugHUD();
			 else
			 {         
			    SetDefenseAugStatus(True,CurrentLevel,minproj);
			 }

			// play a warning sound
			Player.PlaySound(sound'GEPGunLock', SLOT_None,,,, 2.0);

			if (mindist < LevelValues[CurrentLevel])
			{
            			minproj.bAggressiveExploded=True;
				minproj.Explode(minproj.Location, vect(0,0,1));
				Player.PlaySound(sound'ProdFire', SLOT_None,,,, 2.0);
			}
		}
		else
		{
			if ((Level.NetMode == NM_Standalone) || (bDefenseActive))
				SetDefenseAugStatus(False,CurrentLevel,None);
			bDefenseActive = false;
		}
	}

Begin:
	SetTimer(0.1, True);
}

function Deactivate()
{
	Super.Deactivate();

	SetTimer(0.1, False);
   SetDefenseAugStatus(False,CurrentLevel,None);
}

// ------------------------------------------------------------------------------
// FindNearestProjectile()
// DEUS_EX AMSD Exported to a function since it also needs to exist in the client
// TriggerDefenseAugHUD;
// ------------------------------------------------------------------------------

simulated function DeusExProjectile FindNearestProjectile()
{
   local DeusExProjectile proj, minproj;
   local float dist, mindist;
   local bool bValidProj;

   minproj = None;
   mindist = 999999;
   foreach AllActors(class'DeusExProjectile', proj)
   {

	//== Y|y: Don't overcomplicate things.  The bIgnoresNanoDefense variable does a fine and dandy job in singleplayer too
	//==  We also should ignore placed grenades, indicated by the bStuck variable
//      if (Level.NetMode != NM_Standalone)
         bValidProj = !proj.bIgnoresNanoDefense && !proj.bStuck;
//      else
//         bValidProj = (!proj.IsA('Cloud') && !proj.IsA('Tracer') && !proj.IsA('GreaselSpit') && !proj.IsA('GraySpit'));

      if (bValidProj)
      {
         // make sure we don't own it
         if (proj.Owner != Player)
         {
			 // MBCODE : If team game, don't blow up teammates projectiles
			if (!((TeamDMGame(Player.DXGame) != None) && (TeamDMGame(Player.DXGame).ArePlayersAllied(DeusExPlayer(proj.Owner),Player))))
			{
				// make sure it's moving fast enough
				if (VSize(proj.Velocity) > 100)
				{
				   dist = VSize(Player.Location - proj.Location);
				   if (dist < mindist)
				   {
					  mindist = dist;
					  minproj = proj;
				   }
				}
			}
         }
      }
   }

   return minproj;
}

// ------------------------------------------------------------------------------
// TriggerDefenseAugHUD()
// ------------------------------------------------------------------------------

simulated function TriggerDefenseAugHUD()
{
   local DeusExProjectile minproj;
   
   minproj = None;
      
   minproj = FindNearestProjectile();
   
   // if we have a valid projectile, send it to the aug display window
   // That's all we do.
   if (minproj != None)
   {
      SetDefenseAugStatus(True,CurrentLevel,minproj);      
   }
}

simulated function Tick(float DeltaTime)
{
   Super.Tick(DeltaTime);

   // DEUS_EX AMSD Make sure it gets turned off in multiplayer.
   if (Level.NetMode == NM_Client)
   {
      if (!bDefenseActive)
         SetDefenseAugStatus(False,CurrentLevel,None);
   }
}

// ------------------------------------------------------------------------------
// SetDefenseAugStatus()
// ------------------------------------------------------------------------------
simulated function SetDefenseAugStatus(bool bDefenseActive, int defenseLevel, DeusExProjectile defenseTarget)
{
   if (Player == None)
      return;
   if (Player.rootWindow == None)
      return;
   DeusExRootWindow(Player.rootWindow).hud.augDisplay.bDefenseActive = bDefenseActive;
   DeusExRootWindow(Player.rootWindow).hud.augDisplay.defenseLevel = defenseLevel;
   DeusExRootWindow(Player.rootWindow).hud.augDisplay.defenseTarget = defenseTarget;

}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
		defenseSoundTime=0;
	}
}

defaultproperties
{
     mpAugValue=500.000000
     mpEnergyDrain=35.000000
     EnergyRate=10.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconDefense'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconDefense_Small'
     AugmentationName="Aggressive Defense System"
     Description="Aerosol nanoparticles are released upon the detection of objects fitting the electromagnetic threat profile of missiles and grenades; these nanoparticles will prematurely detonate such objects prior to reaching the agent.|n|nTECH ONE: The range at which incoming rockets and grenades are detonated is short.|n|nTECH TWO: The range at which detonation occurs is increased slightly.|n|nTECH THREE: The range at which detonation occurs is increased moderately.|n|nTECH FOUR: Rockets and grenades are detonated almost before they are fired."
     MPInfo="When active, enemy rockets detonate when they get close, doing reduced damage.  Some large rockets may still be close enough to do damage when they explode.  Energy Drain: Low"
     LevelValues(0)=160.000000
     LevelValues(1)=320.000000
     LevelValues(2)=480.000000
     LevelValues(3)=800.000000
     MPConflictSlot=7
}
