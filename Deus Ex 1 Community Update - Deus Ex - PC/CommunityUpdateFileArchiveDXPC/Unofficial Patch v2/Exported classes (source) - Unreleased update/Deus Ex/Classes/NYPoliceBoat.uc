//=============================================================================
// NYPoliceBoat.
//=============================================================================
class NYPoliceBoat extends Vehicles;

defaultproperties
{
     bFloating=True
     ItemName="Police Boat"
     Texture=Texture'DeusExItems.Skins.ReflectionMapTex1'
     Mesh=LodMesh'DeusExDeco.NYPoliceBoat'
     SoundRadius=64
     SoundVolume=192
     AmbientSound=Sound'Ambient.Ambient.BoatLargeIdle'
     CollisionRadius=314.000000
     CollisionHeight=122.000000
     Mass=4000.000000
     Buoyancy=5000.000000
     BindName="BoatPilot"
     UnfamiliarName="UNATCO Boat Pilot"
}
