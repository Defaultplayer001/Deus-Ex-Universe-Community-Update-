//=============================================================================
// TechGoggles.
//=============================================================================
class TechGoggles extends ChargedPickup;

// ----------------------------------------------------------------------
// ChargedPickupBegin()
// ----------------------------------------------------------------------

function ChargedPickupBegin(DeusExPlayer Player)
{
	Super.ChargedPickupBegin(Player);

	DeusExRootWindow(Player.rootWindow).hud.augDisplay.activeCount++;
	UpdateHUDDisplay(Player);
}

// ----------------------------------------------------------------------
// UpdateHUDDisplay()
// ----------------------------------------------------------------------

function UpdateHUDDisplay(DeusExPlayer Player)
{
	if ((DeusExRootWindow(Player.rootWindow).hud.augDisplay.activeCount == 0) && (IsActive()))
		DeusExRootWindow(Player.rootWindow).hud.augDisplay.activeCount++;
	
	DeusExRootWindow(Player.rootWindow).hud.augDisplay.bVisionActive = True;
	DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevel = 0;
	DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevelValue = 0;
}

// ----------------------------------------------------------------------
// ChargedPickupEnd()
// ----------------------------------------------------------------------

function ChargedPickupEnd(DeusExPlayer Player)
{
	Super.ChargedPickupEnd(Player);

	if (--DeusExRootWindow(Player.rootWindow).hud.augDisplay.activeCount == 0)
		DeusExRootWindow(Player.rootWindow).hud.augDisplay.bVisionActive = False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     LoopSound=Sound'DeusExSounds.Pickup.TechGogglesLoop'
     ChargedIcon=Texture'DeusExUI.Icons.ChargedIconGoggles'
     ExpireMessage="TechGoggles power supply used up"
     ItemName="Tech Goggles"
     ItemArticle="some"
     PlayerViewOffset=(X=20.000000,Z=-6.000000)
     PlayerViewMesh=LodMesh'DeusExItems.GogglesIR'
     PickupViewMesh=LodMesh'DeusExItems.GogglesIR'
     ThirdPersonMesh=LodMesh'DeusExItems.GogglesIR'
     Charge=500
     LandSound=Sound'DeusExSounds.Generic.PaperHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconTechGoggles'
     largeIcon=Texture'DeusExUI.Icons.LargeIconTechGoggles'
     largeIconWidth=49
     largeIconHeight=36
     Description="Tech goggles are used by many special ops forces throughout the world under a number of different brand names, but they all provide some form of portable light amplification in a disposable package."
     beltDescription="GOGGLES"
     Mesh=LodMesh'DeusExItems.GogglesIR'
     CollisionRadius=8.000000
     CollisionHeight=2.800000
     Mass=10.000000
     Buoyancy=5.000000
}
