//=============================================================================
// SpyDrone.
//=============================================================================
class SpyDrone extends ThrownProjectile;

auto state Flying
{
	function ProcessTouch (Actor Other, Vector HitLocation)
	{
		// do nothing
	}
	simulated function HitWall (vector HitNormal, actor HitWall)
	{
		// do nothing
	}
}

function Tick(float deltaTime)
{
	// do nothing
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name damageType)
{
	// fall to the ground if EMP'ed
	if ((DamageType == 'EMP') && !bDisabled)
	{
		SetPhysics(PHYS_Falling);
		bBounce = True;
		LifeSpan = 10.0;
	}

	if ( Level.NetMode != NM_Standalone )
	{
		if ( DeusExPlayer(Owner) != None )
			DeusExPlayer(Owner).ForceDroneOff();
		else
			log("Warning:Drone with no owner?" );
	}
	Super.TakeDamage(Damage, instigatedBy, HitLocation, Momentum, damageType);
}

function BeginPlay()
{
	// do nothing
}

function Destroyed()
{
	if ( DeusExPlayer(Owner) != None )
		DeusExPlayer(Owner).aDrone = None;

	Super.Destroyed();
}

defaultproperties
{
     elasticity=0.200000
     fuseLength=0.000000
     proxRadius=128.000000
     bHighlight=False
     bBlood=False
     bDebris=False
     blastRadius=128.000000
     DamageType=EMP
     bEmitDanger=False
     ItemName="Remote Spy Drone"
     MaxSpeed=0.000000
     Damage=20.000000
     ImpactSound=Sound'DeusExSounds.Generic.SmallExplosion2'
     Physics=PHYS_Projectile
     RemoteRole=ROLE_DumbProxy
     LifeSpan=0.000000
     Mesh=LodMesh'DeusExCharacters.SpyDrone'
     SoundRadius=24
     SoundVolume=192
     AmbientSound=Sound'DeusExSounds.Augmentation.AugDroneLoop'
     CollisionRadius=13.000000
     CollisionHeight=2.760000
     Mass=10.000000
     Buoyancy=2.000000
}
