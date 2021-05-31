//
//	InvulnSphere is the effect on the Nintendo Immunity in multiplayer
//
class InvulnSphere extends SphereEffect;

var DeusExPlayer AttachedPlayer;

simulated function Tick(float deltaTime)
{
	local DeusExPlayer myPlayer;

   if (AttachedPlayer == None)
   {
      Destroy();
      return;
   }
   SetLocation(AttachedPlayer.Location);
	DrawScale = size * 1.25;

	myPlayer = DeusExPlayer(GetPlayerPawn());
	if (myPlayer == AttachedPlayer)
		ScaleGlow = FClamp( 0.33 * (LifeSpan / AttachedPlayer.NintendoDelay), 0.0, 0.33);
	else
		ScaleGlow = 2.0 * (LifeSpan / AttachedPlayer.NintendoDelay);
}

defaultproperties
{
     LifeSpan=6.000000
}
