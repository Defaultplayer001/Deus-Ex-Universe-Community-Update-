//=============================================================================
// JCDouble.
//=============================================================================
class JCDouble extends HumanMilitary;

//
// JC's cinematic stunt double!
//
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

function ImpartMomentum(Vector momentum, Pawn instigatedBy)
{
	// to ensure JC's understudy doesn't get impact momentum from damage...
}

function AddVelocity( vector NewVelocity)
{
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     WalkingSpeed=0.120000
     bInvincible=True
     BaseAssHeight=-23.000000
     Mesh=LodMesh'DeusExCharacters.GM_Trench'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.JCDentonTex3'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.JCDentonTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.FramesTex4'
     MultiSkins(7)=Texture'DeusExCharacters.Skins.LensesTex5'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
     BindName="JCDouble"
     FamiliarName="JC Denton"
     UnfamiliarName="JC Denton"
}
