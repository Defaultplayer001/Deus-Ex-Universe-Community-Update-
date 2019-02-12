//=============================================================================
// MPPlayerTrack
// Just maintains info about other players in multiplayer.  Useful for doing
// simulated effects on them without making all the code on the other end 
// simulated.
//=============================================================================
class MPPlayerTrack extends Actor;

var DeusExPlayer AttachedPlayer;
var float TimeSinceCloak;

simulated function Tick(float deltaTime)
{
   if (AttachedPlayer == None)
   {
      Destroy();
      return;
   }
	HandleNintendoEffect( AttachedPlayer );
   HandlePlayerCloak(AttachedPlayer, deltaTime);
}

// ----------------------------------------------------------------------
function HandleNintendoEffect( DeusExPlayer OtherPlayer )
{
   local DeusExPlayer MyPlayer;

   MyPlayer = DeusExPlayer(GetPlayerPawn());

   if (OtherPlayer == None)
      return;

   if (MyPlayer == None)
      return;

   if (OtherPlayer == MyPlayer)
      return;

	if ( OtherPlayer.NintendoImmunityTimeLeft > 0.0 )
		OtherPlayer.DrawInvulnShield();
	else
		OtherPlayer.InvulnSph = None;
}

// ----------------------------------------------------------------------
// HandlePlayerCloak
// ----------------------------------------------------------------------
function HandlePlayerCloak(DeusExPlayer OtherPlayer, float DeltaTime)
{
   local float OldGlow;
   local DeusExPlayer MyPlayer;
   local bool bAllied;

   MyPlayer = DeusExPlayer(GetPlayerPawn());

   TimeSinceCloak += DeltaTime;

   if (OtherPlayer == None)
      return;

   if (MyPlayer == None)
      return;

   if (OtherPlayer.Style != STY_Translucent)
   {
      TimeSinceCloak = 0;
      OtherPlayer.CreateShadow();
      if (OtherPlayer.IsA('JCDentonMale'))
      {
         OtherPlayer.MultiSkins[6] = OtherPlayer.Default.MultiSkins[6];
         OtherPlayer.MultiSkins[7] = OtherPlayer.Default.MultiSkins[7];
      }
      return;
   }

   if (OtherPlayer == MyPlayer)
      return;

   if (!(MyPlayer.DXGame.IsA('DeusExMPGame')))
      return;

   if (OtherPlayer.IsA('JCDentonMale'))
   {
      OtherPlayer.MultiSkins[6] = Texture'BlackMaskTex';
      OtherPlayer.MultiSkins[7] = Texture'BlackMaskTex';
   }
   
   bAllied = False;

   if ( (MyPlayer.DXGame.IsA('TeamDMGame')) && ((TeamDMGame(MyPlayer.DXGame).ArePlayersAllied(OtherPlayer,MyPlayer))) )
      bAllied = True;

   OtherPlayer.KillShadow();

   if (!bAllied)
   {
      //DEUS_EX AMSD Do a gradual cloak fade.
      OtherPlayer.ScaleGlow = OtherPlayer.Default.ScaleGlow * (0.01 / TimeSinceCloak);
      if (OtherPlayer.ScaleGlow <= (DeusExMPGame(MyPlayer.DXGame).CloakEffect + 0.02))
         OtherPlayer.ScaleGlow = DeusExMPGame(MyPlayer.DXGame).CloakEffect;
   }
   else
      OtherPlayer.ScaleGlow = 0.25;

   return;
}

defaultproperties
{
     TimeSinceCloak=10.000000
     bHidden=True
     Style=STY_None
     bUnlit=True
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
