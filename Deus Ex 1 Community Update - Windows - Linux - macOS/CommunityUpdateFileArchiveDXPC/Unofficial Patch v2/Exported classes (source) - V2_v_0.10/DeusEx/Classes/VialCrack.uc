//=============================================================================
// VialCrack.
//=============================================================================
class VialCrack extends DeusExPickup;

state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local DeusExPlayer player;
		
		Super.BeginState();

		player = DeusExPlayer(Owner);
		if (player != None)
		{
			player.drugEffectTimer += 60.0;
			player.HealPlayer(-10, False);
		}

		UseOnce();
	}
Begin:
}

defaultproperties
{
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Zyme Vial"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.VialCrack'
     PickupViewMesh=LodMesh'DeusExItems.VialCrack'
     ThirdPersonMesh=LodMesh'DeusExItems.VialCrack'
     LandSound=Sound'DeusExSounds.Generic.GlassHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconVial_Crack'
     largeIcon=Texture'DeusExUI.Icons.LargeIconVial_Crack'
     largeIconWidth=24
     largeIconHeight=43
     Description="A vial of zyme, brewed up in some basement lab."
     beltDescription="ZYME"
     Mesh=LodMesh'DeusExItems.VialCrack'
     CollisionRadius=0.910000
     CollisionHeight=1.410000
     Mass=2.000000
     Buoyancy=3.000000
}
