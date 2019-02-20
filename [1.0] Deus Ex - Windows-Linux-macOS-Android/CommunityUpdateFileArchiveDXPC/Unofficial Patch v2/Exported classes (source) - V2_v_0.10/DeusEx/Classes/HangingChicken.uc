//=============================================================================
// HangingChicken.
//=============================================================================
class HangingChicken extends HangingDecoration;

function SpawnBlood(Vector HitLocation, float Damage)
{
	local int i;

	spawn(class'BloodSpurt',,,HitLocation);
	spawn(class'BloodDrop',,,HitLocation);
	for (i=0; i<int(Damage); i+=10)
		spawn(class'BloodDrop',,,HitLocation);
}

auto state Active
{
	function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
	{
		Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
		if ((DamageType == 'Shot') || (DamageType == 'Exploded'))
			SpawnBlood(HitLocation, Damage);
	}
}

defaultproperties
{
     HitPoints=30
     FragType=Class'DeusEx.FleshFragment'
     ItemName="Slaughtered Chicken"
     Mesh=LodMesh'DeusExDeco.HangingChicken'
     PrePivot=(Z=31.680000)
     CollisionRadius=15.000000
     CollisionHeight=31.680000
     Mass=60.000000
     Buoyancy=5.000000
}
