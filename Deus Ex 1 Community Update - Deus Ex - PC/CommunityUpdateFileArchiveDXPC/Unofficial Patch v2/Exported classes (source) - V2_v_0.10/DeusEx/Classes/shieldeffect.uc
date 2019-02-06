//=============================================================================
// ShieldEffect.
//=============================================================================
class ShieldEffect extends Effects;

// Player shield effect
var float TimeSinceStrong;
var DeusExPlayer AttachedPlayer;

simulated function Tick(float deltaTime)
{
   if (AttachedPlayer == None)
   {
      Destroy();
      return;
   }

   if (AttachedPlayer.ShieldStatus == SS_Strong)
      TimeSinceStrong = 1.0;
   else
      TimeSinceStrong = TimeSinceStrong - deltaTime;

   if (TimeSinceStrong < 0)
      TimeSinceStrong = 0;

   // DEUS_EX AMSD Won't work right on listen server yet, but this will be low bandwidth for
   // the moment for dedicated server.      
   ScaleGlow = 0.5 * (TimeSinceStrong / 1.0);

   SetLocation(AttachedPlayer.Location);
}

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=LodMesh'DeusExItems.EllipseEffect'
     bUnlit=True
}
