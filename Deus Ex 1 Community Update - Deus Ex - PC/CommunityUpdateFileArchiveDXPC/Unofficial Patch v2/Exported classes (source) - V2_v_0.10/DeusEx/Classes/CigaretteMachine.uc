//=============================================================================
// CigaretteMachine.
//=============================================================================
class CigaretteMachine extends ElectronicDevices;

#exec OBJ LOAD FILE=Ambient

var localized String msgDispensed;
var localized String msgNoCredits;
var int numUses;
var localized String msgEmpty;

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

		if (player.Credits >= 8)
		{
			PlaySound(sound'VendingCoin', SLOT_None);
			loc = Vector(Rotation) * CollisionRadius * 0.8;
			loc.Z -= CollisionHeight * 0.6; 
			loc += Location;

			product = Spawn(class'Cigarettes', None,, loc);

			if (product != None)
			{
				PlaySound(sound'VendingSmokes', SLOT_None);
				product.Velocity = Vector(Rotation) * 100;
				product.bFixedRotationDir = True;
				product.RotationRate.Pitch = (32768 - Rand(65536)) * 4.0;
				product.RotationRate.Yaw = (32768 - Rand(65536)) * 4.0;
			}

			player.Credits -= 8;
			player.ClientMessage(msgDispensed);
			numUses--;
		}
		else
			player.ClientMessage(msgNoCredits);
	}
}

defaultproperties
{
     msgDispensed="8 credits deducted from your account"
     msgNoCredits="Costs 8 credits..."
     numUses=10
     msgEmpty="It's empty"
     ItemName="Cigarette Machine"
     Physics=PHYS_None
     Mesh=LodMesh'DeusExDeco.CigaretteMachine'
     SoundRadius=8
     SoundVolume=96
     AmbientSound=Sound'Ambient.Ambient.HumLight3'
     CollisionRadius=27.000000
     CollisionHeight=26.320000
     Mass=150.000000
     Buoyancy=100.000000
}
