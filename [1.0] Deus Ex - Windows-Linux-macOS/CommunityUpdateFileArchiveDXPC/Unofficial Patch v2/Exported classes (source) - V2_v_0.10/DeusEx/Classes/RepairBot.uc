//=============================================================================
// RepairBot.
//=============================================================================
class RepairBot extends Robot;

var int chargeAmount;
var int chargeRefreshTime;
var int mpChargeRefreshTime;
var int mpChargeAmount;
var Float lastchargeTime;

// ----------------------------------------------------------------------
// Network replication
// ----------------------------------------------------------------------
replication
{
	// MBCODE: Replicate the last time charged to the server
   // DEUS_EX AMSD Changed to replicate to client.
	reliable if ( Role == ROLE_Authority )
		lastchargeTime, chargeRefreshTime;

}

// ----------------------------------------------------------------------
// PostBeginPlay()
// ----------------------------------------------------------------------

function PostBeginPlay()
{
	Super.PostBeginPlay();

   if (Level.NetMode != NM_Standalone)
   {
      chargeRefreshTime = mpChargeRefreshTime;
      chargeAmount = mpChargeAmount;
   }
   
   if (IsImmobile())
      bAlwaysRelevant = True;

   lastChargeTime = -chargeRefreshTime;
}

// ----------------------------------------------------------------------
// StandStill()
// ----------------------------------------------------------------------

function StandStill()
{
	GotoState('Idle', 'Idle');
	Acceleration=Vect(0, 0, 0);
}

// ----------------------------------------------------------------------
// Frob()
//
// Invoke the Augmentation Upgrade 
// ----------------------------------------------------------------------
function Frob(Actor Frobber, Inventory frobWith)
{
	Super.Frob(Frobber, frobWith);

   if (DeusExPlayer(Frobber) == None)
      return;
   
   // DEUS_EX AMSD  In multiplayer, don't pop up the window, just use them
   // In singleplayer, do the old thing.  
   if (Level.NetMode == NM_Standalone)
   {
      ActivateRepairBotScreens(DeusExPlayer(Frobber));
   }
   else
   {
      if (CanCharge())
      {
			PlaySound(sound'PlasmaRifleReload', SLOT_None,,, 256);
         ChargePlayer(DeusExPlayer(Frobber));
         Pawn(Frobber).ClientMessage("Received Recharge");
      }
      else
      {
         Pawn(Frobber).ClientMessage("Repairbot still charging, "$int(chargeRefreshTime - (Level.TimeSeconds - lastChargetime))$" seconds to go.");
      }
   }
}

// ----------------------------------------------------------------------
// ActivateRepairBotScreens()
// ----------------------------------------------------------------------

simulated function ActivateRepairBotScreens(DeusExPlayer PlayerToDisplay)
{
	local DeusExRootWindow root;
	local HUDRechargeWindow winCharge;
			
   root = DeusExRootWindow(PlayerToDisplay.rootWindow);
   if (root != None)
   {
      winCharge = HUDRechargeWindow(root.InvokeUIScreen(Class'HUDRechargeWindow', True));
      root.MaskBackground( True );
      winCharge.SetRepairBot( Self );
   }
}

// ----------------------------------------------------------------------
// ChargePlayer()
// DEUS_EX AMSD Moved back over here 
// ----------------------------------------------------------------------
function int ChargePlayer(DeusExPlayer PlayerToCharge)
{
	local int chargedPoints;

	if ( CanCharge() )
	{
		chargedPoints = PlayerToCharge.ChargePlayer( chargeAmount );
		lastChargeTime = Level.TimeSeconds;
	}
   return chargedPoints;
}

// ----------------------------------------------------------------------
// CanCharge()
// 
// Returns whether or not the bot can charge the player
// ----------------------------------------------------------------------

simulated function bool CanCharge()
{	
	return ( (Level.TimeSeconds - int(lastChargeTime)) > chargeRefreshTime);
}

// ----------------------------------------------------------------------
// GetRefreshTimeRemaining()
// ----------------------------------------------------------------------

simulated function Float GetRefreshTimeRemaining()
{
	return chargeRefreshTime - (Level.TimeSeconds - lastChargeTime);
}

// ----------------------------------------------------------------------
// GetAvailableCharge()
// ----------------------------------------------------------------------

simulated function Int GetAvailableCharge()
{
	if (CanCharge())
		return chargeAmount; 
	else
		return 0;
}

// ----------------------------------------------------------------------

defaultproperties
{
     chargeAmount=75
     chargeRefreshTime=60
     mpChargeRefreshTime=30
     mpChargeAmount=100
     GroundSpeed=100.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=100.000000
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     DrawType=DT_Mesh
     Mesh=LodMesh'DeusExCharacters.RepairBot'
     SoundRadius=16
     SoundVolume=128
     AmbientSound=Sound'DeusExSounds.Robot.RepairBotMove'
     CollisionRadius=34.000000
     CollisionHeight=47.470001
     Mass=150.000000
     Buoyancy=97.000000
     BindName="RepairBot"
     FamiliarName="Repair Bot"
     UnfamiliarName="Repair Bot"
}
