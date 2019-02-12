//=============================================================================
// PickupDistributor.
//=============================================================================
class PickupDistributor extends Keypoint;

//
// Distributes NanoKeys at the start of a level, then destroys itself
//

// copied from NanoKey
enum ESkinColor
{
	SC_Level1,
	SC_Level2,
	SC_Level3,
	SC_Level4
};

struct SNanoKeyInitStruct
{
	var() name					ScriptedPawnTag;
	var() name					KeyID;
	var() localized String		Description;
	var() ESkinColor			SkinColor;
};

var() localized SNanoKeyInitStruct NanoKeyData[8];

function PostPostBeginPlay()
{
	local int i;
	local ScriptedPawn P;
	local NanoKey key;

	Super.PostPostBeginPlay();

	for(i=0; i<ArrayCount(NanoKeyData); i++)
	{
		if (NanoKeyData[i].ScriptedPawnTag != '')
		{
			foreach AllActors(class'ScriptedPawn', P, NanoKeyData[i].ScriptedPawnTag)
			{
				key = spawn(class'NanoKey', P);
				if (key != None)
				{
					key.KeyID = NanoKeyData[i].KeyID;
					key.Description = NanoKeyData[i].Description;
//					key.SkinColor = NanoKeyData[i].SkinColor;
					key.InitialState = 'Idle2';
					key.GiveTo(P);
					key.SetBase(P);
				}
			}
		}
	}

	Destroy();
}

defaultproperties
{
     bStatic=False
}
