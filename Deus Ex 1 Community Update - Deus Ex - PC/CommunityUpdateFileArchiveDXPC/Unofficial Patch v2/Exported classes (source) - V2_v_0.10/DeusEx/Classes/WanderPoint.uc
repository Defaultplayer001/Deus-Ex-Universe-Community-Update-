//=============================================================================
// WanderPoint.
//=============================================================================
class WanderPoint expands NavigationPoint;

var() name   gazeTag;
var   actor  gazeItem;
var   vector gazeDirection;
var() float  gazeDuration;

function PreBeginPlay()
{
	Super.PreBeginPlay();

	if (gazeTag != 'None')
	{
		foreach AllActors(Class'Actor', gazeItem, gazeTag)
			break;
	}

	gazeDirection = 200 * vector(Rotation);
}

defaultproperties
{
     gazeDuration=6.000000
     bDirectional=True
}
