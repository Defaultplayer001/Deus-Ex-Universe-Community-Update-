//=============================================================================
// Sodacan.
//=============================================================================
class Sodacan extends DeusExPickup;

//== Y|y: Add in support for the unused skins
enum ESkinColor
{
	SC_Random,
	SC_Nuke,
	SC_Zap,
	SC_Burn,
	SC_Blast
};

var() ESkinColor SkinColor;

function PreBeginPlay()
{
	local Sodacan soda;

	//== Y|y: Randomize the skins for any cans not already set with a special skin (and Zodiac's ZAP! soda)
	if(SkinColor == SC_Random && (Skin == Texture'DeusExItems.SodaCanTex1' || Skin == None))
	{
		//== ...but not if we're in a cluster
		foreach RadiusActors(class'Sodacan', soda, 32)
		{
			if((soda.SkinColor == SC_Random || soda.SkinColor == SC_Nuke) && soda != Self)
			{
				SkinColor = SC_Nuke;
				break;
			}
		}

		if(SkinColor == SC_Random)
			Skin = Texture(DynamicLoadObject("DeusExItems.SodaCanTex"$ (Rand(4) + 1), class'Texture', False));
	}
	else
	{
		switch(SkinColor)
		{
			case SC_Nuke:
				Skin = Texture'DeusExItems.SodaCanTex1';
				break;
			case SC_Zap:
				Skin = Texture'DeusExItems.SodaCanTex2';
				break;
			case SC_Burn:
				Skin = Texture'DeusExItems.SodaCanTex3';
				break;
			case SC_Blast:
				Skin = Texture'DeusExItems.SodaCanTex4';
				break;
		}
	}

	Super.PreBeginPlay();
}

function bool HandlePickupQuery(inventory Item)
{
	//== Use the Nuke skin for holding this in inventory
	if(Super.HandlePickupQuery(Item))
	{
		Skin = Texture'DeusExItems.SodaCanTex1';
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

		PlaySound(sound'MaleBurp');
		UseOnce();
	}
Begin:
}

defaultproperties
{
     maxCopies=10
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Soda"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Sodacan'
     PickupViewMesh=LodMesh'DeusExItems.Sodacan'
     ThirdPersonMesh=LodMesh'DeusExItems.Sodacan'
     LandSound=Sound'DeusExSounds.Generic.MetalHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconSodaCan'
     largeIcon=Texture'DeusExUI.Icons.LargeIconSodaCan'
     largeIconWidth=24
     largeIconHeight=45
     Description="The can is blank except for the phrase 'PRODUCT PLACEMENT HERE.' It is unclear whether this is a name or an invitation."
     beltDescription="SODA"
     Mesh=LodMesh'DeusExItems.Sodacan'
     CollisionRadius=3.000000
     CollisionHeight=4.500000
     Mass=5.000000
     Buoyancy=3.000000
}
