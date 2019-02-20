//=============================================================================
// Spark.
//=============================================================================
class Spark expands Effects;

#exec OBJ LOAD FILE=Effects

var Rotator rot;

auto state Flying
{
	function BeginState()
	{
		Velocity = vect(0,0,0);
		rot = Rotation;
		rot.Roll += FRand() * 65535;
		SetRotation(rot);
	}
}

defaultproperties
{
     bNetOptional=True
     LifeSpan=0.250000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Skin=FireTexture'Effects.Fire.SparkFX1'
     Mesh=LodMesh'DeusExItems.FlatFX'
     DrawScale=0.100000
     bUnlit=True
     bCollideWorld=True
     bBounce=True
     bFixedRotationDir=True
}
