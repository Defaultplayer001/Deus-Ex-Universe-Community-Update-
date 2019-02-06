//=============================================================================
// EllipseEffect.
//=============================================================================
class EllipseEffect extends Effects;

simulated function Tick(float deltaTime)
{
	ScaleGlow = 2.0 * (LifeSpan / Default.LifeSpan);
}

defaultproperties
{
     LifeSpan=1.000000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=LodMesh'DeusExItems.EllipseEffect'
     bUnlit=True
}
