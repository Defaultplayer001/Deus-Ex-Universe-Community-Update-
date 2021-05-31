//=============================================================================
// SoyFood.
//=============================================================================
class SoyFood extends DeusExPickup;

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
			player.HealPlayer(5, False);
		
		UseOnce();
	}
Begin:
}

defaultproperties
{
     maxCopies=10
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Soy Food"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.SoyFood'
     PickupViewMesh=LodMesh'DeusExItems.SoyFood'
     ThirdPersonMesh=LodMesh'DeusExItems.SoyFood'
     Icon=Texture'DeusExUI.Icons.BeltIconSoyFood'
     largeIcon=Texture'DeusExUI.Icons.LargeIconSoyFood'
     largeIconWidth=42
     largeIconHeight=46
     Description="Fine print: 'Seasoned with nanoscale mechanochemical generators, this TSP (textured soy protein) not only tastes good but also self-heats when its package is opened.'"
     beltDescription="SOY FOOD"
     Mesh=LodMesh'DeusExItems.SoyFood'
     CollisionRadius=8.000000
     CollisionHeight=0.980000
     Mass=3.000000
     Buoyancy=4.000000
}
