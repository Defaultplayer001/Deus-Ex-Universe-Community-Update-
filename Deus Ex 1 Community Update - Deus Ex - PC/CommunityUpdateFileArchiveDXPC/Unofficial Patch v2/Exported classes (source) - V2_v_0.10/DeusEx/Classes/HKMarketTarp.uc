//=============================================================================
// HKMarketTarp.
//=============================================================================
class HKMarketTarp extends HongKongDecoration;

var() bool bRandomize;
var bool bBlowing;

function BeginPlay()
{
	Super.BeginPlay();

	if (!bRandomize)
		LoopAnim('Blowing');
}

function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	if (!bRandomize)
		return;

	if (!bBlowing)
	{
		if (FRand() < 0.001)
		{
			LoopAnim('Blowing');
			bBlowing = True;
		}
	}
	else
	{
		if (FRand() < 0.001)
		{
			TweenAnim('Still', 0.1);
			bBlowing = False;
		}
	}
}

defaultproperties
{
     bRandomize=True
     FragType=Class'DeusEx.PaperFragment'
     ItemName="Canvas Tarp"
     bPushable=False
     Physics=PHYS_None
     Mesh=LodMesh'DeusExDeco.HKMarketTarp'
     CollisionRadius=72.000000
     CollisionHeight=15.000000
     Mass=20.000000
     Buoyancy=5.000000
}
