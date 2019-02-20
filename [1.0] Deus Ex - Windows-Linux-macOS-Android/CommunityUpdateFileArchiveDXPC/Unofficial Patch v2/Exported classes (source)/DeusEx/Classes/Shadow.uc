//=============================================================================
// Shadow.
//=============================================================================
class Shadow extends Decal;

var vector lastLocation;
var bool   bHasDecal;

// the issue here is that we dont want to detach/attach the decal every frame
// given that often we are off screen and/or irrelevant
// however, the fact that we have 2 objects makes it all somewhat ugly
// i.e. we need to update the shadow whenever it should move
// now, if the owner moves, we have to move the shadow itself

function Tick(float deltaTime)
{
	local vector EndTrace, HitLocation, HitNormal;
	local Actor hit;
	local float dist;
	local ScriptedPawn pawnOwner;
	local bool recentlyDrewShadow, recentlyDrewOwner;
	local bool doDraw;
	
	Super.Tick(deltaTime);

	if (Owner == None)
	{
		Destroy();
		return;
	}

	// don't update if our owner is in stasis or isn't moving
	if (Owner.InStasis() || (VSize(Owner.Location - lastLocation) < 0.1))
		if (bHasDecal)   // we are doing nothing, we have a decal, we are fine
			return;

	// in our dream world, these two would be "last frame" not "recently"
	recentlyDrewShadow = (lastRendered()<1.0);
    recentlyDrewOwner  = (Owner.lastRendered()<1.0);
	doDraw             = recentlyDrewShadow || recentlyDrewOwner;

	if (bHasDecal)
	{
		DetachDecal();
		bHasDecal=False;
	}

	// temp until this works better
	if (Owner.IsA('DeusExPlayer'))
		doDraw = True;

	if (!doDraw)
		return;

	// save our location to check next frame - only if we move the shadow, however
	lastLocation = Owner.Location;

	// trace down about 30 feet
	EndTrace = Owner.Location - vect(0,0,480);
	hit = Trace(HitLocation, HitNormal, EndTrace, Owner.Location, True);

	if (hit != None)
	{
		dist = VSize(HitLocation - Owner.Location);
		DrawScale = (Owner.CollisionRadius / 15.0) - ((dist - Owner.CollisionHeight) / 130.0);
	
		pawnOwner = ScriptedPawn(Owner);
		if (pawnOwner != None)
			DrawScale *= pawnOwner.ShadowScale;

		if (DrawScale < 0)
			DrawScale = 0;
		SetLocation(HitLocation);
		SetRotation(Rotator(HitNormal));
	
		AttachDecal(32,vect(0.1,0.1,0));
		bHasDecal=True;
	}
}

defaultproperties
{
     bHasDecal=True
     Texture=Texture'DeusExItems.Skins.FlatFXTex40'
}
