//=============================================================================
// Candybar.
//=============================================================================
class Candybar extends DeusExPickup;

//== Y|y: add full support for the extra texture
enum ESkinColor
{
	SC_Random,
	SC_Honey,
	SC_Monty
};

var() ESkinColor SkinColor;

function PreBeginPlay()
{
	switch(SkinColor)
	{
		//== Randomize the skin if one hasn't been selected already
		case SC_Random:
			if(Rand(2) == 1 && (Skin == Texture'CandybarTex1' || Skin == None))
				Skin = Texture'CandybarTex2';
			break;

		case SC_Honey:
			Skin = Texture'CandybarTex1';
			break;

		case SC_Monty:
			Skin = Texture'CandybarTex2';
			break;
	}
		
}

function bool HandlePickupQuery(inventory Item)
{
	//== Use the Chunk-O-Honey skin for holding this in inventory
	if(Super.HandlePickupQuery(Item))
	{
		Skin = Texture'CandybarTex1';
		return True;
	}

	return False;
}


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
			player.HealPlayer(2, False);
		
		UseOnce();
	}
Begin:
}

defaultproperties
{
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Candy Bar"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Candybar'
     PickupViewMesh=LodMesh'DeusExItems.Candybar'
     ThirdPersonMesh=LodMesh'DeusExItems.Candybar'
     Icon=Texture'DeusExUI.Icons.BeltIconCandyBar'
     largeIcon=Texture'DeusExUI.Icons.LargeIconCandyBar'
     largeIconWidth=46
     largeIconHeight=36
     Description="'CHOC-O-LENT DREAM. IT'S CHOCOLATE! IT'S PEOPLE! IT'S BOTH!(tm) 85% Recycled Material.'"
     beltDescription="CANDY BAR"
     Mesh=LodMesh'DeusExItems.Candybar'
     CollisionRadius=6.250000
     CollisionHeight=0.670000
     Mass=3.000000
     Buoyancy=4.000000
}
