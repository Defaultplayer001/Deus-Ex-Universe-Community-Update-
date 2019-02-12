//=============================================================================
// PaulDentonCarcass.
//=============================================================================
class PaulDentonCarcass extends DeusExCarcass;

// ----------------------------------------------------------------------
// PostPostBeginPlay()
// ----------------------------------------------------------------------

function PostPostBeginPlay()
{
	local DeusExPlayer player;

	Super.PostPostBeginPlay();

	foreach AllActors(class'DeusExPlayer', player)
		break;

	SetSkin(player);
}

// ----------------------------------------------------------------------
// SetSkin()
// ----------------------------------------------------------------------

function SetSkin(DeusExPlayer player)
{
	if (player != None)
	{
		switch(player.PlayerSkin)
		{
			case 0:	MultiSkins[0] = Texture'PaulDentonTex0';
					MultiSkins[3] = Texture'PaulDentonTex0';
					break;
			case 1:	MultiSkins[0] = Texture'PaulDentonTex4';
					MultiSkins[3] = Texture'PaulDentonTex4';
					break;
			case 2:	MultiSkins[0] = Texture'PaulDentonTex5';
					MultiSkins[3] = Texture'PaulDentonTex5';
					break;
			case 3:	MultiSkins[0] = Texture'PaulDentonTex6';
					MultiSkins[3] = Texture'PaulDentonTex6';
					break;
			case 4:	MultiSkins[0] = Texture'PaulDentonTex7';
					MultiSkins[3] = Texture'PaulDentonTex7';
					break;
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     Mesh2=LodMesh'DeusExCharacters.GM_Trench_CarcassB'
     Mesh3=LodMesh'DeusExCharacters.GM_Trench_CarcassC'
     Mesh=LodMesh'DeusExCharacters.GM_Trench_Carcass'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.PaulDentonTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.PaulDentonTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.PantsTex8'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.PaulDentonTex0'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.PaulDentonTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.PaulDentonTex2'
     MultiSkins(6)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=40.000000
}
