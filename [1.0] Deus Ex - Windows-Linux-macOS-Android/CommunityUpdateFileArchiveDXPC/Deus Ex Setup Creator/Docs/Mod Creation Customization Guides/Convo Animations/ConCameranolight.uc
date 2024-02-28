//=============================================================================
// ConCamera
//=============================================================================
class ConCamera extends ConObject
	noexport;

var() name checkFlag;
var Actor            cameraActor;			// Actor who owns this event
var ECameraPositions cameraPosition;		// Predefined camera position
var ECameraTypes     cameraType;			// Camera Type
var ECameraTypes     cameraMode;
var ConLight         conLightSpeaker;		// Used to light actor's faces
var ConLight         conLightSpeakingTo;	// Used to light actor's faces

var Vector cameraOffset;
var Rotator rotation;
var Float   cosAngle;
var Int     firstActorRotation;
var Int     setActorCount;
var bool    bCameraLocationSaved;

// Camera Fallback Positions (for when camera view obstructed)
var ECameraPositions cameraFallbackPositions[9];
var ECameraPositions cameraHeightPositions[9];

var int   currentFallback;
var bool  bUsingFallback;

// Used for CT_Speakers mode
var float heightModifier;
var float centerModifier;
var float distanceMultiplier;		
var float heightFallbackTrigger;

// Actors associated with camera placement
var Actor firstActor;
var Actor secondActor;

// These variable are used to prevent camera angle changes when the 
// actors change.
var Actor lastFirstActor;
var Actor lastSecondActor;
var Bool  ignoreSetActors;

// Used for Camera debugging
var Bool  bDebug;
var Vector LastLocation;
var Rotator LastRotation;
var Bool  bInteractiveCamera;

// ----------------------------------------------------------------------
// SetupCameraFromEvent()
//
// Sets up the ConCamera structure that will be used to place the 
// camera in the PlayerCalcView() function of the DeusExPlayer class.
// ----------------------------------------------------------------------

function SetupCameraFromEvent( ConEventMoveCamera event )
{
	ignoreSetActors = False;

	cameraType = event.cameraType;

	// Reset our fallback camera
	ResetFallbackPosition();
	
	// Setup the camera!
	switch( cameraType )
	{
		// Predefined camera locations
		case CT_Predefined:
			cameraPosition = event.cameraPosition;
			SetCameraValues();
			break;

		// Speakers camera variables
		case CT_Speakers:
			SetupSpeakersCamera( event );
			break;

		// Actor camera variables
		case CT_Actor:
			SetupActorCamera( event );
			break;

		// Randomly choose from one of the predefined camera locations
		case CT_Random:
			SetupRandomCameraPosition();
			break;
	}
}

// ----------------------------------------------------------------------
// SetupRandomCameraPosition()
//
// Picks from one of the various predefined camera positions.  There is
// logic in this routine to track how often we're changing the camera.
// We don't want to move the camera each time the actors change, 
// especially if the camera view (such as a side view) shows both 
// actors.  
// ----------------------------------------------------------------------

function SetupRandomCameraPosition()
{
	local Int randomPosition;

	// 60% chance that the camera position won't change if the same 
	// actors are speaking.

	if ( Frand() < 0.60 )
	{
		// Check to make sure the same two actors are speaking

		if ((( firstActor == lastFirstActor ) || ( firstActor == lastSecondActor )) &&
		    (( secondActor == lastSecondActor ) || ( secondActor == lastFirstActor )))
		{
			// If we're presently using a side view, then force the camera
			// to remain focused on the current actor (so we don't switch
			// 180 degrees, which is kind of annoying)
		
			switch( cameraPosition )
			{
				case CP_SideTight:
				case CP_SideMid:
				case CP_SideAbove:
				case CP_SideAbove45:
					firstActor  = lastFirstActor;
					secondActor = lastSecondActor;
					ignoreSetActors = True;
					break;
			}
			return;
		}
	}

	// If we got here, then we're setting up a new random camera angle.  We want 
	// to save the current actors so we can extend this camera angle over 
	// several lines of dialogue.

	lastFirstActor  = firstActor;
	lastSecondActor = secondActor;

	randomPosition = Rand(10);

	// Hmmm, this sucks, you can't seem to typecast an int as an enumerated
	// type.  bah humbug

	switch ( randomPosition )
	{
		case 0:
			cameraPosition = CP_SideTight;
			break;
		case 1:
			cameraPosition = CP_SideMid;
			break;
		case 2:
			cameraPosition = CP_SideAbove;
			break;
		case 3:
			cameraPosition = CP_SideAbove45;
			break;
		case 4:
			cameraPosition = CP_ShoulderLeft;
			break;
		case 5:
			cameraPosition = CP_ShoulderRight;
			break;
		case 6:
			cameraPosition = CP_HeadShotTight;
			break;
		case 7:
			cameraPosition = CP_HeadShotMid;
			break;
		case 8:
			cameraPosition = CP_HeadShotLeft;
			break;
		case 9:
			cameraPosition = CP_HeadShotRight;
			break;
	}

	SetCameraValues();
}

// ----------------------------------------------------------------------
// SetupSpeakersCamera()
//
// Sets up the camera with info contained in the event structure
// ----------------------------------------------------------------------

function SetupSpeakersCamera( ConEventMoveCamera event )
{
	rotation			= event.rotation;
	heightModifier		= event.heightModifier;
	centerModifier		= event.centerModifier;
	distanceMultiplier	= event.distanceMultiplier;
}

// ----------------------------------------------------------------------
// SetupActorCamera()
//
// Sets up the camera with info contained in the event structure
// ----------------------------------------------------------------------

function SetupActorCamera( ConEventMoveCamera event )
{
	cameraOffset		= event.cameraOffset;
	rotation			= event.rotation;
}

// ----------------------------------------------------------------------
// SetActors()
// 
// Sets the actors to be used for placing the camera
// ----------------------------------------------------------------------

function SetActors( Actor newFirstActor, Actor newSecondActor )
{
	if ( ignoreSetActors )
		return;

	firstActor  = newFirstActor;
	secondActor = newSecondActor;

	setActorCount++;

	// hack for now
//	cameraOffset = newFirstActor.location;
}

// ----------------------------------------------------------------------
// SetCameraValues()
//
// Sets up the camera values for each different camera position
// ----------------------------------------------------------------------

function SetCameraValues()
{
	switch( cameraPosition )
	{
		case CP_SideTight:
			cameraMode     = CT_Speakers;
			rotation       = rot(0, 16788, 0);
			heightModifier = 10.8;
			centerModifier = 0.0;
			distanceMultiplier = 0.90;
			break;

		case CP_SideMid:
			cameraMode     = CT_Speakers;
			rotation       = rot(0, 16788, 0);
			heightModifier = 10.8;
			centerModifier = 0.0;
			distanceMultiplier = 2.20;
			break;

		case CP_SideAbove:
			cameraMode     = CT_Speakers;
			rotation       = rot(59636, 17824, 0);
			heightModifier = 10.5;
			centerModifier = 0.0;
			distanceMultiplier = 1.0;
			break;

		case CP_SideAbove45:
			cameraMode     = CT_Speakers;
			rotation       = rot(57136, 40868, 0);
			heightModifier = -19.0;
			centerModifier = 0.0;
			distanceMultiplier = 1.80;
			break;

		case CP_ShoulderLeft:
			cameraMode     = CT_Speakers;
			rotation       = rot(0, 39056, 0);
			heightModifier = 10.5;
			centerModifier = 0.20;
			distanceMultiplier = 1.0;
			break;

		case CP_ShoulderRight:
			cameraMode     = CT_Speakers;
			rotation       = rot(0, 26456, 0);
			heightModifier = 10.5;
			centerModifier = 0.20;;
			distanceMultiplier = 1.0;
			break;

		case CP_HeadShotTight:
			cameraMode   = CT_Actor;
			rotation	 = rot(0, 32400, 0);
			cameraOffset = vect(-23, 0, 0);
			break;

		case CP_HeadShotMid:
			cameraMode   = CT_Actor;
			rotation	 = rot(0, 32400, 0);
			cameraOffset = vect(-30, 0, 0);
			break;

		case CP_HeadShotLeft:
			cameraMode   = CT_Actor;
//			rotation     = rot(0, 42100, 0);
			rotation     = rot(0, 45100, 0);
			cameraOffset = vect(-16, 17, 0);
			break;

		case CP_HeadShotRight:
			cameraMode   = CT_Actor;
//			rotation     = rot(0, 23500, 0);
			rotation     = rot(0, 20500, 0);
			cameraOffset = vect(-16, -17, 0);
			break;

		case CP_HeadShotSlightRight:
			cameraMode   = CT_Actor;
			rotation	 = rot(300, 33600, 0);
			cameraOffset = vect(-27.4, 2.1, 0);
			break;

		case CP_HeadShotSlightLeft:
			cameraMode   = CT_Actor;
			rotation	 = rot(300, 29800, 0);
			cameraOffset = vect(-27.4, -5.60, 0);
			break;

		case CP_StraightAboveLookingDown:
			cameraMode     = CT_Speakers;
			rotation       = rot(60000, 16588, 0);
			heightModifier = 22.22;
			centerModifier = 0.0;
			distanceMultiplier = 0.90;
			break;

		case CP_StraightBelowLookingUp:
			cameraMode     = CT_Speakers;
			rotation       = rot(8500, 16588, 0);
			heightModifier = 11.4;
			centerModifier = 0.0;
			distanceMultiplier = 0.90;
			break;

		case CP_BelowLookingUp:
			cameraMode     = CT_Speakers;
			rotation       = rot(16564, 16224, 0);
			heightModifier = 3.3;
			centerModifier = -0.3;
			distanceMultiplier = 0.90;
			break;
	}
}

// ----------------------------------------------------------------------
// InitializeCameraValues()
//
// Sets up the camera with default values
// ----------------------------------------------------------------------

function InitializeCameraValues(Actor cameraOwner, Actor Other, Actor Instigator)
{
	cameraPosition = CP_SideTight;
	SetCameraValues();
	//Nulled out so character's don't glow and mess up my shots anymore -Default
	//CreateHighlights(cameraOwner);

}

// ----------------------------------------------------------------------
// SwitchCameraMode()
//
// Switches camera modes between CT_Speakers and CT_Actor
// ----------------------------------------------------------------------

function SwitchCameraMode()
{
	if ( cameraMode == CT_Speakers ) 
		cameraMode = CT_Actor;
	else
		cameraMode = CT_Speakers;
}

// ----------------------------------------------------------------------
// IncCameraMode()
//
// There must be a better way to do enum math 
// ----------------------------------------------------------------------

function IncCameraMode()
{
	switch( cameraPosition )
	{
		case CP_SideTight:
			cameraPosition = CP_SideMid;
			break;

		case CP_SideMid:
			cameraPosition = CP_SideAbove;
			break;

		case CP_SideAbove:
			cameraPosition = CP_SideAbove45;
			break;

		case CP_SideAbove45:
			cameraPosition = CP_ShoulderLeft;
			break;

		case CP_ShoulderLeft:
			cameraPosition = CP_ShoulderRight;
			break;

		case CP_ShoulderRight:
			cameraPosition = CP_HeadShotTight;
			break;

		case CP_HeadShotTight:
			cameraPosition = CP_HeadShotMid;
			break;

		case CP_HeadShotMid:
			cameraPosition = CP_HeadShotLeft;
			break;

		case CP_HeadShotLeft:
			cameraPosition = CP_HeadShotRight;
			break;

		case CP_HeadShotRight:
			cameraPosition = CP_HeadShotSlightRight;
			break;

		case CP_HeadShotSlightRight:
			cameraPosition = CP_HeadShotSlightLeft;
			break;

		case CP_HeadShotSlightLeft:
			cameraPosition = CP_StraightAboveLookingDown;
			break;

		case CP_StraightAboveLookingDown:
			cameraPosition = CP_StraightBelowLookingUp;
			break;

		case CP_StraightBelowLookingUp:
			cameraPosition = CP_BelowLookingUp;
			break;

		case CP_BelowLookingUp:
			cameraPosition = CP_SideTight;
			break;
	}

	SetCameraValues();
}

// ----------------------------------------------------------------------
// DecCameraMode()
//
// There must be a better way to do enum math 
// ----------------------------------------------------------------------

function DecCameraMode()
{
	switch( cameraPosition )
	{
		case CP_SideTight:
			cameraPosition = CP_BelowLookingUp;
			break;

		case CP_SideMid:
			cameraPosition = CP_SideTight;
			break;

		case CP_SideAbove:
			cameraPosition = CP_SideMid;
			break;

		case CP_SideAbove45:
			cameraPosition = CP_SideAbove;
			break;

		case CP_ShoulderLeft:
			cameraPosition = CP_SideAbove45;
			break;

		case CP_ShoulderRight:
			cameraPosition = CP_ShoulderLeft;
			break;

		case CP_HeadShotTight:
			cameraPosition = CP_ShoulderRight;
			break;

		case CP_HeadShotMid:
			cameraPosition = CP_HeadShotTight;
			break;

		case CP_HeadShotLeft:
			cameraPosition = CP_HeadShotMid;
			break;

		case CP_HeadShotRight:
			cameraPosition = CP_HeadShotLeft;
			break;

		case CP_HeadShotSlightRight:
			cameraPosition = CP_HeadShotRight;
			break;

		case CP_HeadShotSlightLeft:
			cameraPosition = CP_HeadShotSlightRight;
			break;

		case CP_StraightAboveLookingDown:
			cameraPosition = CP_HeadShotSlightLeft;
			break;

		case CP_StraightBelowLookingUp:
			cameraPosition = CP_StraightAboveLookingDown;
			break;

		case CP_BelowLookingUp:
			cameraPosition = CP_StraightBelowLookingUp;
			break;
	}

	SetCameraValues();
}

// ----------------------------------------------------------------------
// SetDebugMode()
// ----------------------------------------------------------------------

function SetDebugMode(bool bNewDebug)
{
	bDebug = bNewDebug;
}

// ----------------------------------------------------------------------
// CreateHighlight()
// 
// Creates a highlight above the actor or actors talking.  This is done
// since sometimes it's difficult to see the actors' faces.
// ----------------------------------------------------------------------

function CreateHighlights(Actor cameraOwner)
{
	conLightSpeaker    = cameraOwner.Spawn(class'ConLight');
	conLightSpeakingTo = cameraOwner.Spawn(class'ConLight');
}

// ----------------------------------------------------------------------
// DestroyHighlights()
// ----------------------------------------------------------------------

function DestroyHighlights()
{
	if (conLightSpeaker != None)
	{
		conLightSpeaker.Destroy();
		conLightSpeaker = None;
	}

	if (conLightSpeakingTo != None)
	{
		conLightSpeakingTo.Destroy();
		conLightSpeakingTo = None;
	}
}

// ----------------------------------------------------------------------
// CalculateCameraPosition()
//
// Calculates the camera location and rotation.  Returns True if 
// the camera position was calculated, False if we must defer to the 
// default PlayerCalcView() function
// ----------------------------------------------------------------------

function bool CalculateCameraPosition(
	out actor ViewActor, 
	out vector CameraLocation, 
	out rotator CameraRotation)
{
	local Vector  centerPoint, distVector;
	local Vector  center1, center2;
	local vector  View;
	local Float   distance;
	local bool    bTraceSecondActor;
	local Int     workYaw;

	// Used to make sure the camera isn't behind something.
	local float   ViewDist;

	// If either of the actors is missing, abort!!!
	if ((firstActor == None) || (secondActor == None))
		return False;

	if (bDebug)	Log("ConCamera::CalculateCameraPosition()------------------------------");

	// Check to see which cameraMode we're in.  If we're in Speakers mode, then
	// the camera is based on the position of the two speakers.  Otherwise,
	// the camera is based on an actor.

	if ( cameraMode == CT_Speakers )
	{	
		// Check to see if both actors are the same.  If so, we want
		// to default to an actor-based camera, since CT_Speakers mode
		// requires two actors to work properly
		if (firstActor == secondActor)
		{
			SetupSameActorFallbackCamera();
			return CalculateCameraPosition(ViewActor, CameraLocation, CameraRotation);
		}
		else
		{
			// Used to determine if we need to trace the second actor
			// (we always trace the first)	
			bTraceSecondActor = True;

			// Set the first center point, based on the first actor's location
			center1 = firstActor.Location;

			if (Pawn(firstActor) != None)
				center1.Z += (Pawn(firstActor).BaseEyeHeight / 1.5) + heightModifier;
			else if (Decoration(firstActor) != None)
				center1.Z += (Decoration(firstActor).BaseEyeHeight / 1.5) + heightModifier;

			center2    = secondActor.Location;

			if (Pawn(secondActor) != None)
				center2.Z += Pawn(secondActor).BaseEyeHeight;
			else if (Decoration(secondActor) != None)
				center2.Z += Decoration(secondActor).BaseEyeHeight;

			if (bDebug)	log("  center1 = " $ center1);
			if (bDebug)	log("  center2 = " $ center2);

			centerPoint    = (center1 + center2) / 2.0;
			distance       = VSize(center2 - center1) * distanceMultiplier;

			if (bDebug) log("  VSize(center2 - center1) = " $ VSize(center2 - center1));
			if (bDebug)	log("  distanceMultiplier = " $ distanceMultiplier);
			if (bDebug)	log("  distance           = " $ distance);
			if (bDebug)	log("  centerModifier     = " $ centerModifier);
			if (bDebug)	log("  centerPoint = " $ centerPoint);
			if (bDebug)	log("  distVector  = " $ distVector);

			// Update the Camera Rotation.  If the first actor is 
			// the PlayerPawn, then use ViewRotation.  Otherwise we need to 
			// use the Rotation instead (for ScriptedPawns and Decorations, 
			// which are both derived from Actor).

 			CameraRotation = Rotator(secondActor.Location - firstActor.Location) + rotation;

			// This beautiful chunk of code below performs some hideous magic to make
			// sure the camera stays in the same 180 degrees throughout the conversation
			// (this of course only applies to camera events that are based on multiple
			// actors.  Events baesd on individual actors will override this, of course).
			//
			// First pass through, calculate the base angle we'll be using for future
			// reference.  Every pass after that we'll check to make sure the camera falls

			// within a 180 degree range.  If the camera falls outside that range, we'll 
			// move the camera to the other side of the actor, while still facing that
			// actor (basically mirroring the camera's position).

			if (setActorCount == 1)
			{
				// Use this as the baseline
				firstActorRotation = Rotator(secondActor.Location - firstActor.Location).Yaw % 65536;

				if (firstActorRotation < 0)
					firstActorRotation += 65535;

				workYaw = CameraRotation.Yaw % 65536;
				if (workYaw < 0)
					workYaw += 65536;

				if ((!((workYaw >= firstActorRotation) && (workYaw <= (firstActorRotation + 32768)))) && (rotation.Yaw < 32768))
				{
					firstActorRotation = (CameraRotation.Yaw - rotation.Yaw) % 65536;

					if (firstActorRotation < 0)
						firstActorRotation += 65535;
				}
				else if (rotation.Yaw >= 32768)
				{
					firstActorRotation += 32768;
					firstActorRotation = firstActorRotation % 65536;
				}
			}
			else if (setActorCount > 1)
			{
				workYaw = CameraRotation.Yaw % 65536;
				if (workYaw < 0)
					workYaw += 65536;

				if ((!((workYaw >= firstActorRotation) && (workYaw <= (firstActorRotation + 32768)))) && 
				    (!((workYaw >= (firstActorRotation-65536)) && (workYaw <= ((firstActorRotation + 32768)-65536)))))				 
				{
					CameraRotation = Rotator(secondActor.Location - firstActor.Location) - rotation;			
				}
			}

			CameraLocation = centerPoint + Vector(CameraRotation) * (distance * -1);

			// Check to see if the camera location is nearly identical to the last 
			// location.  If so, resort to the previous location and rotation.  This is done 
			// to prevent"jitter" of the camera that can sometimes occur with the above algorithm.

			if ((bCameraLocationSaved) && (VSize(lastLocation - CameraLocation) < 20)) 
			{
				CameraLocation = lastLocation;
				CameraRotation = lastRotation;
			}

			if (bDebug)	log("  CameraLocation = " $ CameraLocation);
			if (bDebug)	log("  CameraRotation = " $ CameraRotation);

			ViewDist = VSize(centerPoint - CameraLocation);

			if (bDebug)	log("  ViewDist = "$  viewdist);
		}
	}
	else
	{
		ViewActor = firstActor;

		CameraLocation = ViewActor.Location;
		CameraRotation = ViewActor.DesiredRotation;

		View = vect(1,0,0) >> CameraRotation;
		CameraLocation -= (CameraOffset.X * View);

		View = vect(0,1,0) >> CameraRotation;
		CameraLocation -= (CameraOffset.Y * View);

		View = vect(0,0,1) >> CameraRotation;

		if (ViewActor.IsA('Pawn'))
			CameraLocation.Z = ViewActor.Location.Z + (Pawn(ViewActor).BaseEyeHeight * 0.95);
//			CameraLocation.Z = ViewActor.Location.Z + (ViewActor.CollisionHeight * 0.92);
		else if (ViewActor.IsA('Decoration'))
			CameraLocation.Z = ViewActor.Location.Z + (Decoration(ViewActor).BaseEyeHeight);

//			CameraLocation -= (CameraOffset.Z * View);

		CameraRotation -= rotation;

		ViewDist = VSize(ViewActor.Location - CameraLocation);
	}

	if (ActorObstructed(firstActor, secondActor, CameraLocation, CameraRotation, ViewDist))
	{
		SetupFallbackCamera();
		CalculateCameraPosition(ViewActor, CameraLocation, CameraRotation);
	}
	else if ((bTraceSecondActor) && (ActorObstructed(secondActor, firstActor, CameraLocation, CameraRotation, ViewDist)))
	{
		SetupFallbackCamera();
		CalculateCameraPosition(ViewActor, CameraLocation, CameraRotation);
	}
	else if (cameraMode == CT_Speakers)
	{
		// Check if there is a significant Z difference between the two actors. 
		// If so, then we want to use fallback cameras that don't look so bad.
		// Usually this happens if the player starts a conversation with 
		// someone on stairs.

		if (Abs(firstActor.Location.Z - secondActor.Location.Z) > heightFallbackTrigger)
		{
			if (SetupHeightFallbackCamera())
				CalculateCameraPosition(ViewActor, CameraLocation, CameraRotation);
		}
	}

	// Update the light positions
	conLightSpeaker.UpdateLocation(firstActor);

	// If no second actor, then turn that light off
	if (secondActor != None)
		conLightSpeakingTo.UpdateLocation(secondActor);
	else
		conLightSpeakingTo.TurnOff();
			
	// Save the location and rotation so we can display it
	LastLocation = CameraLocation;
	LastRotation = CameraRotation;
	bCameraLocationSaved = True;
				
	if (bDebug)	Log("------------------------------ConCamera::CalculateCameraPosition()");

	bDebug = False;

	return True;
}

// ----------------------------------------------------------------------
// ActorObstructed()
//
// Performs a trace from the actor's location to the camera position
// to make sure it's not obstructed by anything.  If so, then we try
// to move the camera in a bit closer.  If that still fails, then 
// punt and return True and let the caller deal with the problem.
// ----------------------------------------------------------------------

function bool ActorObstructed(
	Actor actorToTrace,
	Actor ignoreActor,
	out   vector  CameraLocation, 
	out   rotator CameraRotation,
	float   ViewDist)
{
	local bool    bActorObstructed;
	local vector  HitLocation, HitNormal;
	local Actor   HitActor;

	// Used for texture trace
	local vector  EndTrace, StartTrace;
	local actor   target;
	local int     texFlags;
	local name    texName, texGroup;
	local bool    bInvisibleWall;

	// Used to test angle between speakers and camera
	// to make sure both actors onscreen
	local Vector  vector1, vector2;
	local Float   allowableCosAngle;
	local Float   dp;

	bActorObstructed = True;

	if (actorToTrace == None)
		return bActorObstructed;

	HitActor = actorToTrace.Trace(
		HitLocation, HitNormal, 
		actorToTrace.Location,	CameraLocation, False);

	if ((HitActor != None) && (bDebug)) 
		log("  HitActor = " $ HitActor);

	// Only do this if we don't have the interactive camera on

	// Perform a trace from the camera location to the actors speaking and 
	// (optionally) being spoken to.  If something other than the actors
	// is hit, then first attempt to pull the camera in a little closer.
	// If that doesn't work, then punt and use a default camera view.
		
	if ((HitActor != None) && (HitActor != actorToTrace) && ((ignoreActor != None) && (HitActor != ignoreActor)))
	{
		// Pull the camera in a little closer, but only within 25% of the original
		// desired location
		if (bDebug) log("  VSize(CameraLocation - HitLocation) = " $ VSize(CameraLocation - HitLocation));
		if (bDebug) log("  ViewDist = " $ ViewDist);

		if (VSize(CameraLocation - HitLocation) < (ViewDist / 3))
		{
			if (bDebug) log("  CameraLocation = " $ CameraRotation);
			if (bDebug) log("  HitLocation    = " $ HitLocation);
			if (bDebug) log("  CameraRotation = " $ CameraRotation);

			ViewDist = ViewDist - (VSize(CameraLocation - HitLocation)) - 25;
			CameraLocation = (HitLocation + (vector(CameraRotation) * 25));

			HitActor = actorToTrace.Trace( 
				HitLocation, HitNormal, 
				actorToTrace.Location, CameraLocation, False);

			if (bDebug) log("  CameraLocation = " $ CameraRotation);
			if (bDebug) log("  HitLocation    = " $ HitLocation);
			if (bDebug) log("  CameraRotation = " $ CameraRotation);
			if (bDebug) log("  ViewDist = " $ ViewDist);
			if (bDebug) log("  HitActor = " $ HitActor);
		}
	}

	// If HitActor is still not None then check to see if we're behind an 
	// invisble wall.  If so, then return False, as the invisible wall
	// won't be drawn and we should be safe with this camera shot.

	if ((HitActor != None) && (HitActor != actorToTrace) && ((ignoreActor != None) && (HitActor != ignoreActor)) && (!AllFallbackPositionsExhausted()))
	{
		bInvisibleWall = True;

		foreach HitActor.TraceTexture(class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, actorToTrace.Location, CameraLocation)
		{
			if ((texFlags & 1) !=0)		// 1 = PF_Invisible
			{
				bActorObstructed = False;
				break;
			}
		}
	}
	else
	{
		bActorObstructed = False;
	}

	// If this is a Side camera shot, then check to see if both actors are 
	// visible in the scene
	
	if (!bActorObstructed)
	{
		allowableCosAngle = 0.50;

		switch(cameraPosition)
		{
			case CP_SideTight:
			case CP_SideMid:
			case CP_SideAbove:
			case CP_SideAbove45:
				vector1 = actorToTrace.Location - CameraLocation;
				vector2 = ignoreActor.Location - CameraLocation;
				
				dp = vector1 dot vector2;
				cosangle = dp / (VSize(vector1) * VSize(vector2));

				if (cosangle < allowableCosAngle)
					bActorObstructed = True;

				break;
		}
	}
	return bActorObstructed;
}

// ----------------------------------------------------------------------
// SetupSameActorFallbackCamera()
// ----------------------------------------------------------------------

function SetupSameActorFallbackCamera()
{
	// Just hardcode it, this isn't something that should ever 
	// happen (and when it does it's a bug)

	cameraPosition = CP_HeadShotSlightRight;
	SetCameraValues();

	// Log this, since we shouldn't be here
	log("==============================================");
	log("WARNING - Conversation Actor speaking to self!");
	log("  Speaker = " $ firstActor.bindName);
	log("==============================================");
}

// ----------------------------------------------------------------------
// SetupFallbackCamera()
//
// Fallback camera, used in case the selected camera position fails
// because it is obstructed by terrain or another actor
// ----------------------------------------------------------------------

function SetupFallbackCamera()
{
	bUsingFallback = True;
	cameraPosition = GetNextFallbackPosition();
	SetCameraValues();
}

// ----------------------------------------------------------------------
// SetupHeightFallbackCamera()
//
// Sets a suitable fallback camera to be used when there is a signficant
// height difference between two acors
// ----------------------------------------------------------------------

function bool SetupHeightFallbackCamera()
{
	local int cameraIndex;
	local ECameraPositions newCameraPosition;

	bUsingFallback = True;

	// First check to see if the current camera position is one 
	// of the allowable ones for this type of shot.  If so, 
	// then just pass back False.
	for(cameraIndex=0; cameraIndex<arrayCount(cameraHeightPositions); cameraIndex++)
	{
		if (cameraPosition == cameraHeightPositions[cameraIndex])
			return False;
	}

	// Okay, now just pick one randomly.  :)  If it's the same one we had
	// previoiusly, return False (no sense in doing extra work)

	newCameraPosition = cameraHeightPositions[rand(arrayCount(cameraHeightPositions))];

	if (newCameraPosition != cameraPosition)
	{
		cameraPosition = newCameraPosition;
		SetCameraValues();
		return True;
	}
	else
	{
		return False;
	}
}

// ----------------------------------------------------------------------
// GetNextFallbackPosition()
// ----------------------------------------------------------------------

function ECameraPositions GetNextFallbackPosition()
{
	local ECameraPositions cameraFallback;

	if (currentFallback == arrayCount(cameraFallbackPositions))
		cameraFallback = cameraFallbackPositions[currentFallback-1];
	else
		cameraFallback = cameraFallbackPositions[currentFallback++];

	return cameraFallback;
}

// ----------------------------------------------------------------------
// ResetFallbackPosition()
// ----------------------------------------------------------------------

function ResetFallbackPosition()
{
	currentFallback = 0;
	bUsingFallback  = False;
}

// ----------------------------------------------------------------------
// AllFallbackPositionsExhausted()
// ----------------------------------------------------------------------

function bool AllFallbackPositionsExhausted()
{
	return (currentFallback == arrayCount(cameraFallbackPositions));
}

// ----------------------------------------------------------------------
// SetInteractiveCamera()
// ----------------------------------------------------------------------

function SetInteractiveCamera(bool bNewInteractiveCamera)
{
	bInteractiveCamera = bNewInteractiveCamera;
}

// ----------------------------------------------------------------------
// UsingFallbackCamera()
//
// Returns True if we're presently using a fallback camera shot
// ----------------------------------------------------------------------

function bool UsingFallbackCamera()
{
	return bUsingFallback;
}

// ----------------------------------------------------------------------
// UsingHeadshot()
//
// Returns True if we're presently using a camera trained on a
// single actor
// ----------------------------------------------------------------------

function bool UsingHeadshot()
{
	local bool bUsingHeadshot;

	bUsingHeadshot = False;

	if (cameraType == CT_Predefined)
	{
		switch(cameraPosition)
		{
			// Intentional Fallthrough
			case CP_ShoulderLeft:
			case CP_ShoulderRight:
			case CP_HeadShotTight:
			case CP_HeadShotMid:
			case CP_HeadShotLeft:
			case CP_HeadShotRight:
			case CP_HeadShotSlightRight:
			case CP_HeadShotSlightLeft:
				bUsingHeadshot = True;
				break;
		}
	}

	return bUsingHeadshot;
}

// ----------------------------------------------------------------------
// LogCameraInfo()
//
// Writes current camera info to the log
// ----------------------------------------------------------------------

function LogCameraInfo()
{
	bDebug = True;

	log("");
	log("ConCamera --------------------------------------------------------");
	log("  cameraPosition     = " $ cameraPosition);
	log("  cameraMode         = " $ cameraMode);
	log("  rotation           = " $ rotation);
	log("");
	log("  LastLocation       = " $ LastLocation);
	log("  LastRotation       = " $ LastRotation);
	log("");

	if ( cameraMode == CT_Speakers )
	{
		log("  firstActor         = " $ firstActor);
		log("     Location        = " $ firstActor.Location);
		log("     Rotation        = " $ firstActor.Rotation);

		if (Pawn(firstActor) != None)
			log("     baseEyeHeight   = " $ Pawn(firstActor).baseEyeHeight);

		log("");	
		log("  secondActor        = " $ secondActor);
		log("     Location        = " $ secondActor.Location);
		log("     Rotation        = " $ secondActor.Rotation);

		if (Pawn(secondActor) != None)
			log("     baseEyeHeight   = " $ Pawn(secondActor).baseEyeHeight);

		log("");
		log("  heightModifier     = " $ heightModifier);
		log("  centerModifier     = " $ centerModifier);
		log("  distanceMultiplier = " $ distanceMultiplier);
	}
	else
	{
		log("  actor rotation     = " $ firstActor.rotation);
		log("  cameraOffset       = " $ cameraOffset);
		log("  actor              = " $ firstActor);
	}

	log("-------------------------------------------------------- ConCamera");
	log("");
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     CheckFlag='
     cameraFallbackPositions(1)=CP_ShoulderLeft
     cameraFallbackPositions(2)=CP_ShoulderRight
     cameraFallbackPositions(3)=CP_HeadShotSlightRight
     cameraFallbackPositions(4)=CP_HeadShotSlightLeft
     cameraFallbackPositions(5)=CP_HeadShotLeft
     cameraFallbackPositions(6)=CP_HeadShotRight
     cameraFallbackPositions(7)=CP_HeadShotMid
     cameraFallbackPositions(8)=CP_HeadShotTight
     cameraHeightPositions(0)=CP_SideAbove
     cameraHeightPositions(1)=CP_SideAbove45
     cameraHeightPositions(2)=CP_StraightAboveLookingDown
     cameraHeightPositions(3)=CP_StraightBelowLookingUp
     cameraHeightPositions(4)=CP_HeadShotLeft
     cameraHeightPositions(5)=CP_HeadShotRight
     cameraHeightPositions(6)=CP_HeadShotSlightRight
     cameraHeightPositions(7)=CP_HeadShotSlightLeft
     cameraHeightPositions(8)=CP_HeadShotMid
     heightFallbackTrigger=30.000000
}
