//=============================================================================
// SmokelessFire.
//=============================================================================
class SmokelessFire extends Fire;

//DEUS_EX AMSD SpawnSmokeEffects should only be called client side.
// Smokeless fire doesn't spawn smoke.
simulated function SpawnSmokeEffects()
{
   return;
}

defaultproperties
{
}
