//=============================================================================
// VendingMachine.
//=============================================================================
class VendingMachine extends ElectronicDevices;

#exec OBJ LOAD FILE=Ambient

enum ESkinColor
{
	SC_Drink,
	SC_Snack
};

var() ESkinColor SkinColor;

var localized String msgDispensed;
var localized String msgNoCredits;
var int numUses;
var localized String msgEmpty;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_Drink:	Skin = Texture'VendingMachineTex1'; break;
		case SC_Snack:	Skin = Texture'VendingMachineTex2'; break;
	}
}

function Frob(actor Frobber, Inventory frobWith)
{
	local DeusExPlayer player;
	local Vector loc;
	local Pickup product;

	Super.Frob(Frobber, frobWith);
	
	player = DeusExPlayer(Frobber);

	if (player != None)
	{
		if (numUses <= 0)
		{
			player.ClientMessage(msgEmpty);
			return;
		}

		if (player.Credits >= 2)
		{
			PlaySound(sound'VendingCoin', SLOT_None);
			loc = Vector(Rotation) * CollisionRadius * 0.8;
			loc.Z -= CollisionHeight * 0.7; 
			loc += Location;

			if (SkinColor == SC_Drink)
				product = Spawn(class'Sodacan', None,, loc);
			else
				product = Spawn(class'Candybar', None,, loc);

			if (product != None)
			{
				if (product.IsA('Sodacan'))
					PlaySound(sound'VendingCan', SLOT_None);
				else
					PlaySound(sound'VendingSmokes', SLOT_None);

				product.Velocity = Vector(Rotation) * 100;
				product.bFixedRotationDir = True;
				product.RotationRate.Pitch = (32768 - Rand(65536)) * 4.0;
				product.RotationRate.Yaw = (32768 - Rand(65536)) * 4.0;
			}

			player.Credits -= 2;
			player.ClientMessage(msgDispensed);
			numUses--;
		}
		else
			player.ClientMessage(msgNoCredits);
	}
}

defaultproperties
{
     msgDispensed="2 credits deducted from your account"
     msgNoCredits="Costs 2 credits..."
     numUses=10
     msgEmpty="It's empty"
     bCanBeBase=True
     ItemName="Vending Machine"
     Mesh=LodMesh'DeusExDeco.VendingMachine'
     SoundRadius=8
     SoundVolume=96
     AmbientSound=Sound'Ambient.Ambient.HumLow3'
     CollisionRadius=34.000000
     CollisionHeight=50.000000
     Mass=150.000000
     Buoyancy=100.000000
}
