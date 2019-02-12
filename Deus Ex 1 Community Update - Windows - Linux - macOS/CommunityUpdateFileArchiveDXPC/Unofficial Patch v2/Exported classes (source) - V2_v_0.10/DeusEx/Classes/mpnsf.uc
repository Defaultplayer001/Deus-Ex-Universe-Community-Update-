//=============================================================================
// MPNSF
//=============================================================================
class MPNSF extends Human;

// ----------------------------------------------------------------------
// TravelPostAccept()
// ----------------------------------------------------------------------

event TravelPostAccept()
{
	local DeusExLevelInfo info;

	Super.TravelPostAccept();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     CarcassType=Class'DeusEx.TerroristCarcass'
     JumpSound=Sound'DeusExSounds.Player.MaleJump'
     HitSound1=Sound'DeusExSounds.Player.MalePainSmall'
     HitSound2=Sound'DeusExSounds.Player.MalePainMedium'
     Land=Sound'DeusExSounds.Player.MaleLand'
     Die=Sound'DeusExSounds.Player.MaleDeath'
     Texture=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.TerroristTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.TerroristTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.TerroristTex1'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.TerroristTex0'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.TerroristTex0'
     MultiSkins(5)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.GogglesTex1'
     MultiSkins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
}
