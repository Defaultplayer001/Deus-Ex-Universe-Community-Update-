//=============================================================================
// AugmentationUpgrade.
//  A badly-coded conversation with Ford Schick gives you this item rather than
//  the parent item.  That is the only reason why this item exists.
//=============================================================================
class AugmentationUpgrade expands AugmentationUpgradeCannister;

//== The conversation transfer uses SpawnCopy, so let's override it to instead
//==  give the player the correct item
function inventory SpawnCopy( Pawn Other )
{
	local AugmentationUpgradeCannister AugUpCan;
	local Inventory retinv;

	AugUpCan = spawn(class'AugmentationUpgradeCannister');
	retinv = AugUpCan.SpawnCopy(Other);

	if(retinv != None)
		Destroy();
	else //== Well shit, this didn't go well.  Just use this
		AugUpCan.Destroy();

	return retinv;
}

defaultproperties
{
}
