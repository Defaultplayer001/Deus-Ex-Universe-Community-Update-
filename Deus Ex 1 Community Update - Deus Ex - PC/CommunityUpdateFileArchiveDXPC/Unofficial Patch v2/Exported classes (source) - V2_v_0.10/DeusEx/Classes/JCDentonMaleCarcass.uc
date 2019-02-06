//=============================================================================
// JCDentonMaleCarcass.
//=============================================================================
class JCDentonMaleCarcass extends DeusExCarcass;

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
			case 0:	MultiSkins[0] = Texture'JCDentonTex0'; break;
			case 1:	MultiSkins[0] = Texture'JCDentonTex4'; break;
			case 2:	MultiSkins[0] = Texture'JCDentonTex5'; break;
			case 3:	MultiSkins[0] = Texture'JCDentonTex6'; break;
			case 4:	MultiSkins[0] = Texture'JCDentonTex7'; break;
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
     MultiSkins(0)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.JCDentonTex3'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.JCDentonTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.FramesTex4'
     MultiSkins(7)=Texture'DeusExCharacters.Skins.LensesTex5'
     CollisionRadius=40.000000
}
