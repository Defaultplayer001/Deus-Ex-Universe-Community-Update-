//=============================================================================
// MuzzleFlash.
//=============================================================================
class MuzzleFlash expands Effects;

simulated event PreBeginPlay()
{
   Super.PreBeginPlay();
   if (Level.NetMode != NM_Standalone)
      LightRadius = 6;
}

simulated function PostNetBeginPlay()
{
   Super.PostNetBeginPlay();
   if (Level.NetMode != NM_Standalone)
      LightRadius = 6;
}

defaultproperties
{
     bNetOptional=True
     LifeSpan=0.100000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=28
     LightSaturation=160
     LightRadius=3
}
