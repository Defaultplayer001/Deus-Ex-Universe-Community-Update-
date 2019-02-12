//=============================================================================
// LiquorBottle.
//=============================================================================
class LiquorBottle extends DeusExPickup;

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
			player.HealPlayer(2, False);
			player.drugEffectTimer += 5.0;
		}

		UseOnce();
	}
Begin:
}

defaultproperties
{
     bBreakable=True
     maxCopies=10
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Liquor"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.LiquorBottle'
     PickupViewMesh=LodMesh'DeusExItems.LiquorBottle'
     ThirdPersonMesh=LodMesh'DeusExItems.LiquorBottle'
     LandSound=Sound'DeusExSounds.Generic.GlassHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconLiquorBottle'
     largeIcon=Texture'DeusExUI.Icons.LargeIconLiquorBottle'
     largeIconWidth=20
     largeIconHeight=48
     Description="The label is torn off, but it looks like some of the good stuff."
     beltDescription="LIQUOR"
     Mesh=LodMesh'DeusExItems.LiquorBottle'
     CollisionRadius=4.620000
     CollisionHeight=12.500000
     Mass=10.000000
     Buoyancy=8.000000
}
