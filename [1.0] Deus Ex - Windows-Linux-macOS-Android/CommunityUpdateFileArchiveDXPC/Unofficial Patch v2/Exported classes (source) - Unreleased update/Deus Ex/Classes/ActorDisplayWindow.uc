//=============================================================================
// ActorDisplayWindow.
//   A quick-and-dirty window used to show actor positions (debugging only)
//=============================================================================
class ActorDisplayWindow expands Window;

var class<Actor> viewClass;
var bool         bShowEyes;
var bool         bShowArea;
var bool         bShowCylinder;
var bool         bShowMesh;
var bool         bShowZone;
var bool         bShowLineOfSight;
var bool         bShowData;
var bool         bShowVisibility;
var bool         bShowState;
var bool         bShowEnemy;
var bool         bShowInstigator;
var bool         bShowBase;
var bool         bShowOwner;
var bool         bShowBindName;
var bool         bShowLightLevel;
var bool         bShowDist;
var bool         bShowPos;
var bool         bShowHealth;
var bool         bShowMass;
var bool         bShowPhysics;
var bool         bShowVelocity;
var bool         bShowAcceleration;
var bool         bShowLastRendered;
var bool         bShowEnemyResponse;

var int          maxPoints;
var float        sinTable[16];

// ----------------------------------------------------------------------
// Local Variables
// ----------------------------------------------------------------------

event InitWindow()
{
	local int i;
	Super.InitWindow();

	maxPoints = 8;
	for (i=0; i<maxPoints*2; i++)
		sinTable[i] = sin(2*3.1415926*(i/float(maxPoints)));
}


function SetViewClass(Class<Actor> newViewClass)
{
	viewClass = newViewClass;
}

function Class<Actor> GetViewClass()
{
	return viewClass;
}

function ShowData(bool bShow)
{
	bShowData = bShow;
}

function ShowEyes(bool bShow)
{
	bShowEyes = bShow;
}

function Bool AreEyesVisible()
{
	return bShowEyes;
}

function ShowArea(bool bShow)
{
	bShowArea = bShow;
}

function Bool IsAreaVisible()
{
	return bShowArea;
}

function ShowCylinder(bool bShow)
{
	bShowCylinder = bShow;
}

function Bool IsCylinderVisible()
{
	return bShowCylinder;
}

function ShowMesh(bool bShow)
{
	bShowMesh = bShow;
}

function Bool IsMeshVisible()
{
	return bShowMesh;
}

function ShowZone(bool bShow)
{
	bShowZone = bShow;
}

function Bool IsZoneVisible()
{
	return bShowZone;
}

function ShowLOS(bool bShow)
{
	bShowLineOfSight = bShow;
}

function Bool IsLOSVisible()
{
	return bShowLineOfSight;
}

function ShowVisibility(bool bShow)
{
	bShowVisibility = bShow;
}

function Bool IsVisibilityVisible()
{
	return bShowVisibility;
}

function ShowState(bool bShow)
{
	bShowState = bShow;
}

function Bool IsStateVisible()
{
	return bShowState;
}

function ShowEnemy(bool bShow)
{
	bShowEnemy = bShow;
}

function Bool IsEnemyVisible()
{
	return bShowEnemy;
}

function ShowInstigator(bool bShow)
{
	bShowInstigator = bShow;
}

function Bool IsInstigatorVisible()
{
	return bShowInstigator;
}

function ShowLight(bool bShow)
{
	bShowLightLevel = bShow;
}

function Bool IsLightVisible()
{
	return bShowLightLevel;
}

function ShowBase(bool bShow)
{
	bShowBase = bShow;
}

function Bool IsBaseVisible()
{
	return bShowBase;
}

function ShowOwner(bool bShow)
{
	bShowOwner = bShow;
}

function Bool IsOwnerVisible()
{
	return bShowOwner;
}

function ShowBindName(bool bShow)
{
	bShowBindName = bShow;
}

function Bool IsBindNameVisible()
{
	return bShowBindName;
}

function ShowLastRendered(bool bShow)
{
	bShowLastRendered = bShow;
}

function Bool IsLastRenderedVisible()
{
	return bShowLastRendered;
}

function ShowDist(bool bShow)
{
	bShowDist = bShow;
}

function Bool IsDistVisible()
{
	return bShowDist;
}

function ShowPos(bool bShow)
{
	bShowPos = bShow;
}

function Bool IsPosVisible()
{
	return bShowPos;
}

function ShowHealth(bool bShow)
{
	bShowHealth = bShow;
}

function Bool IsHealthVisible()
{
	return bShowHealth;
}

function Bool IsMassVisible()
{
	return bShowMass;
}

function ShowMass(bool bShow)
{
	bShowMass = bShow;
}

function ShowPhysics(bool bShow)
{
	bShowPhysics = bShow;
}

function Bool ArePhysicsVisible()
{
	return bShowPhysics;
}

function ShowVelocity(bool bShow)
{
	bShowVelocity = bShow;
}

function Bool IsVelocityVisible()
{
	return bShowVelocity;
}

function ShowAcceleration(bool bShow)
{
	bShowAcceleration = bShow;
}

function Bool IsAccelerationVisible()
{
	return bShowAcceleration;
}

function ShowEnemyResponse(bool bShow)
{
	bShowEnemyResponse = bShow;
}

function Bool IsEnemyResponseVisible()
{
	return bShowEnemyResponse;
}


// These three functions were copied directly from FrobDisplayWindow.uc
function Texture GetGridTexture(Texture tex)
{
	if (tex == None)
		return Texture'BlackMaskTex';
	else if (tex == Texture'BlackMaskTex')
		return Texture'BlackMaskTex';
	else if (tex == Texture'GrayMaskTex')
		return Texture'BlackMaskTex';
	else if (tex == Texture'PinkMaskTex')
		return Texture'BlackMaskTex';
	else if (tex.USize >= 256)
	{
		if (tex.VSize >= 256)
			return Texture'GridTex256x256';
		else
			return Texture'GridTex256x128';
	}
	else if (tex.USize >= 128)
	{
		if (tex.VSize >= 256)
			return Texture'GridTex128x256';
		else if (tex.VSize >= 128)
			return Texture'GridTex128x128';
		else
			return Texture'GridTex128x64';
	}
	else if (tex.USize >= 64)
	{
		if (tex.VSize >= 128)
			return Texture'GridTex64x128';
		else if (tex.VSize >= 64)
			return Texture'GridTex64x64';
		else
			return Texture'GridTex64x32';
	}
	else if (tex.USize >= 32)
	{
		if (tex.VSize >= 64)
			return Texture'GridTex32x64';
		else
			return Texture'GridTex32x32';
	}
	else
		return Texture'GridTex16x16';
}

function SetSkins(Actor actor, out Texture oldSkins[9])
{
	local int     i;
	local texture curSkin;

	for (i=0; i<8; i++)
		oldSkins[i] = actor.MultiSkins[i];
	oldSkins[i] = actor.Skin;

	for (i=0; i<8; i++)
	{
		curSkin = actor.GetMeshTexture(i);
		actor.MultiSkins[i] = GetGridTexture(curSkin);
	}
	actor.Skin = GetGridTexture(oldSkins[i]);
}

function ResetSkins(Actor actor, Texture oldSkins[9])
{
	local int i;

	for (i=0; i<8; i++)
		actor.MultiSkins[i] = oldSkins[i];
	actor.Skin = oldSkins[i];
}


function DrawPoint(GC gc, float xPos, float yPos)
{
	gc.DrawPattern(xPos, yPos, 1, 1, 0, 0, Texture'Solid');
}


function Interpolate(GC gc, float fromX, float fromY, float toX, float toY, int power)
{
	local float xPos, yPos;
	local float deltaX, deltaY;
	local float maxDist;
	local int   points;
	local int   i;

	maxDist = 6;

	points = 1;
	deltaX = (toX-fromX);
	deltaY = (toY-fromY);
	while (power >= 0)
	{
		if ((deltaX >= maxDist) || (deltaX <= -maxDist) || (deltaY >= maxDist) || (deltaY <= -maxDist))
		{
			deltaX *= 0.5;
			deltaY *= 0.5;
			points *= 2;
			power--;
		}
		else
			break;
	}

	xPos = fromX;
	yPos = fromY;
	for (i=0; i<points-1; i++)
	{
		xPos += deltaX;
		yPos += deltaY;
		DrawPoint(gc, xPos, yPos);
	}
}


function DrawLine(GC gc, vector point1, vector point2)
{
	local float fromX, fromY;
	local float toX, toY;

	gc.SetStyle(DSTY_Normal);
	if (ConvertVectorToCoordinates(point1, fromX, fromY) && ConvertVectorToCoordinates(point2, toX, toY))
	{
		gc.SetTileColorRGB(255, 255, 255);
		DrawPoint(gc, fromX, fromY);
		DrawPoint(gc, toX, toY);
		gc.SetTileColorRGB(128, 128, 128);
		Interpolate(gc, fromX, fromY, toX, toY, 8);
	}

}


function DrawCylinder(GC gc, actor trackActor)
{
	local int         i;
	local vector      topCircle[8];
	local vector      bottomCircle[8];
	local float       topSide, bottomSide;
	local int         numPoints;
	local DeusExMover dxMover;
	local vector      center, area;

	dxMover = DeusExMover(trackActor);
	if (dxMover == None)
	{
		topSide = trackActor.Location.Z + trackActor.CollisionHeight;
		bottomSide = trackActor.Location.Z - trackActor.CollisionHeight;
		for (i=0; i<maxPoints; i++)
		{
			topCircle[i] = trackActor.Location;
			topCircle[i].Z = topSide;
			topCircle[i].X += sinTable[i]*trackActor.CollisionRadius;
			topCircle[i].Y += sinTable[i+maxPoints/4]*trackActor.CollisionRadius;
			bottomCircle[i] = topCircle[i];
			bottomCircle[i].Z = bottomSide;
		}
		numPoints = maxPoints;
	}
	else
	{
		dxMover.ComputeMovementArea(center, area);
		topCircle[0] = center+area*vect(1,1,1);
		topCircle[1] = center+area*vect(1,-1,1);
		topCircle[2] = center+area*vect(-1,-1,1);
		topCircle[3] = center+area*vect(-1,1,1);
		bottomCircle[0] = center+area*vect(1,1,-1);
		bottomCircle[1] = center+area*vect(1,-1,-1);
		bottomCircle[2] = center+area*vect(-1,-1,-1);
		bottomCircle[3] = center+area*vect(-1,1,-1);
		numPoints = 4;
	}

	for (i=0; i<numPoints; i++)
		DrawLine(gc, topCircle[i], bottomCircle[i]);
	for (i=0; i<numPoints-1; i++)
	{
		DrawLine(gc, topCircle[i], topCircle[i+1]);
		DrawLine(gc, bottomCircle[i], bottomCircle[i+1]);
	}
	DrawLine(gc, topCircle[i], topCircle[0]);
	DrawLine(gc, bottomCircle[i], bottomCircle[0]);
}


function Extend(float pos, out float left, out float right)
{
	if (left > pos)
		left = pos;
	if (right < pos)
		right = pos;
}


function DrawWindow(GC gc)
{
	local float xPos, yPos;
	local float centerX, centerY;
	local float topY, bottomY;
	local float leftX, rightX;
	local int i, j, k;
	local vector tVect;
	local vector cVect;
	local PlayerPawnExt player;
	local Actor trackActor;
	local ScriptedPawn trackPawn;
	local bool bValid;
	local bool bPointValid;
	local float visibility;
	local float dist;
	local float speed;
	local name stateName;
	local float temp;
	local string str;
	local texture skins[9];
	local color mainColor;
	local byte zoneNum;
	local float oldRenderTime;
	local float barOffset;
	local float barValue;
	local float barWidth;
	local DeusExMover dxMover;

	Super.DrawWindow(gc);

	if (viewClass == None)
		return;

	player  = GetPlayerPawn();

	if (bShowMesh)
		gc.ClearZ();

	foreach player.AllActors(viewClass, trackActor)
	{
		dxMover = DeusExMover(trackActor);
		cVect.X = trackActor.CollisionRadius;
		cVect.Y = trackActor.CollisionRadius;
		cVect.Z = trackActor.CollisionHeight;
		tVect = trackActor.Location;
		if (bShowEyes && (Pawn(trackActor) != None))
			tVect.Z += Pawn(trackActor).BaseEyeHeight;
		if (trackActor == player)
		{
			if (player.bBehindView)
				bPointValid = ConvertVectorToCoordinates(tVect, centerX, centerY);
			else
				bPointValid = FALSE;
		}
		else if (dxMover != None)
		{
			if (!bShowLineOfSight || (player.AICanSee(trackActor, 1, false, true, bShowArea) > 0))  // need a better way to do this
				bPointValid = ConvertVectorToCoordinates(tVect, centerX, centerY);
			else
				bPointValid = FALSE;
		}
		else
		{
			if (!bShowLineOfSight || (player.AICanSee(trackActor, 1, false, true, bShowArea) > 0))
				bPointValid = ConvertVectorToCoordinates(tVect, centerX, centerY);
			else
				bPointValid = FALSE;
		}

		if (bPointValid)
		{
			bValid = FALSE;
			if (bShowArea)
			{
				for (i=-1; i<=1; i+=2)
				{
					for (j=-1; j<=1; j+=2)
					{
						for (k=-1; k<=1; k+=2)
						{
							tVect = cVect;
							tVect.X *= i;
							tVect.Y *= j;
							tVect.Z *= k;
							tVect.X += trackActor.Location.X;
							tVect.Y += trackActor.Location.Y;
							tVect.Z += trackActor.Location.Z;
							if (ConvertVectorToCoordinates(tVect, xPos, yPos))
							{
								if (!bValid)
								{
									leftX = xPos;
									rightX = xPos;
									topY = yPos;
									bottomY = yPos;
									bValid = TRUE;
								}
								else
								{
									Extend(xPos, leftX, rightX);
									Extend(yPos, topY, bottomY);
								}
							}
						}
					}
				}
			}

			if (!bValid)
			{
				leftX = centerX-10;
				rightX = centerX+10;
				topY = centerY-10;
				bottomY = centerY+10;
				bValid = TRUE;
			}

			gc.EnableDrawing(true);
			gc.SetStyle(DSTY_Translucent);
			if (bShowZone)
			{
				zoneNum = trackActor.Region.ZoneNumber;
				if (zoneNum == 0)
				{
					mainColor.R = 255;
					mainColor.G = 255;
					mainColor.B = 255;
				}
				else
				{
					// The following color algorithm was copied from UnRender.cpp...
					mainColor.R = (zoneNum*67)&255;
					mainColor.G = (zoneNum*1371)&255;
					mainColor.B = (zoneNum*1991)&255;
				}
			}
			else
			{
				mainColor.R = 0;
				mainColor.G = 255;
				mainColor.B = 0;
			}
			gc.SetTileColor(mainColor);
			if (bShowMesh)
			{
				SetSkins(trackActor, skins);
				oldRenderTime = trackActor.LastRenderTime;
				gc.DrawActor(trackActor, false, false, true, 1.0, 1.0, None);
				trackActor.LastRenderTime = oldRenderTime;
				ResetSkins(trackActor, skins);
			}
			if (!bShowMesh || bShowArea)
			{
				gc.SetTileColorRGB(mainColor.R/4, mainColor.G/4, mainColor.B/4);
				gc.DrawBox(leftX, topY, 1+rightX-leftX, 1+bottomY-topY, 0, 0, 1, Texture'Solid');
				leftX += 1;
				rightX -= 1;
				topY += 1;
				bottomY -= 1;
				gc.SetTileColorRGB(mainColor.R*3/16, mainColor.G*3/16, mainColor.B*3/16);
				gc.DrawBox(leftX, topY, 1+rightX-leftX, 1+bottomY-topY, 0, 0, 1, Texture'Solid');
				leftX += 1;
				rightX -= 1;
				topY += 1;
				bottomY -= 1;
				gc.SetTileColorRGB(mainColor.R/8, mainColor.G/8, mainColor.B/8);
				gc.DrawBox(leftX, topY, 1+rightX-leftX, 1+bottomY-topY, 0, 0, 1, Texture'Solid');
			}

			gc.SetStyle(DSTY_Normal);

			if (bShowCylinder)
				DrawCylinder(gc, trackActor);

			if (trackActor.InStasis())
			{
				gc.SetTileColorRGB(0, 255, 0);
				gc.DrawPattern(centerX, centerY-2, 1, 5, 0, 0, Texture'Solid');
				gc.DrawPattern(centerX-2, centerY, 5, 1, 0, 0, Texture'Solid');
			}
			else
			{
				gc.SetTileColorRGB(255, 255, 255);
				gc.DrawPattern(centerX, centerY-3, 1, 7, 0, 0, Texture'Solid');
				gc.DrawPattern(centerX-3, centerY, 7, 1, 0, 0, Texture'Solid');
			}

			str = "";
			if (bShowState || bShowData)
			{
				stateName = trackActor.GetStateName();
				str = str $ "|p1'" $ stateName $ "'" $ CR();
			}
			if (bShowPhysics || bShowData)
			{
				str = str $ "|c80ff80P=";
				switch (trackActor.Physics)
				{
					case PHYS_None:
						str = str $ "PHYS_None";
						break;
					case PHYS_Walking:
						str = str $ "PHYS_Walking";
						break;
					case PHYS_Falling:
						str = str $ "PHYS_Falling";
						break;
					case PHYS_Swimming:
						str = str $ "PHYS_Swimming";
						break;
					case PHYS_Flying:
						str = str $ "PHYS_Flying";
						break;
					case PHYS_Rotating:
						str = str $ "PHYS_Rotating";
						break;
					case PHYS_Projectile:
						str = str $ "PHYS_Projectile";
						break;
					case PHYS_Rolling:
						str = str $ "PHYS_Rolling";
						break;
					case PHYS_Interpolating:
						str = str $ "PHYS_Interpolating";
						break;
					case PHYS_MovingBrush:
						str = str $ "PHYS_MovingBrush";
						break;
					case PHYS_Spider:
						str = str $ "PHYS_Spider";
						break;
					case PHYS_Trailer:
						str = str $ "PHYS_Trailer";
						break;
					default:
						str = str $ "Unknown";
						break;
				}
				str = str $ CR();
			}
			if (bShowMass || bShowData)
			{
				str = str $ "|cff80ffM=";
				str = str $ trackActor.Mass $ CR();
			}
			if (bShowEnemy || bShowData)
			{
				str = str $ "|cff8000E=";
				if (Pawn(trackActor) != None)
					str = str $ "'" $ Pawn(trackActor).Enemy $ "'" $ CR();
				else
					str = str $ "n/a" $ CR();
			}
			if (bShowInstigator || bShowData)
			{
				str = str $ "|c0080ffI=";
				str = str $ "'" $ trackActor.Instigator $ "'" $ CR();
			}
			if (bShowOwner || bShowData)
			{
				str = str $ "|c80ffffO=";
				str = str $ "'" $ trackActor.Owner $ "'" $ CR();
			}
			if (bShowBindName || bShowData)
			{
				str = str $ "|c80b0b0N=";
				str = str $ "'" $ trackActor.BindName $ "'" $ CR();
			}
			if (bShowBase || bShowData)
			{
				str = str $ "|c808080B=";
				str = str $ "'" $ trackActor.Base $ "'" $ CR();
			}
			if (bShowLastRendered || bShowData)
			{
				str = str $ "|cffffffR=";
				str = str $ "'" $ trackActor.LastRendered() $ "'" $ CR();
			}
			if (bShowLightLevel || bShowData)
			{
				visibility = trackActor.AIVisibility(false);
				str = str $ "|p4L=" $ visibility*100 $ CR();
			}
			if (bShowVisibility || bShowData)
			{
				visibility = player.AICanSee(trackActor, 1.0, true, true, true);
				str = str $ "|p7V=" $ visibility*100 $ CR();
			}
			if (bShowDist || bShowData)
			{
				// It would be soooo much easier to call
				// (trackActor.Location-player.Location).Size(), but noooooo...
				// that's only supported in the Actor class!

				temp = (trackActor.Location.X - player.Location.X);
				dist = temp*temp;
				temp = (trackActor.Location.Y - player.Location.Y);
				dist += temp*temp;
				temp = (trackActor.Location.Z - player.Location.Z);
				dist += temp*temp;
				dist = sqrt(dist);
				str = str $ "|p3D=" $ dist $ CR();
			}
			if (bShowPos || bShowData)
			{
				str = str $ "|p2";
				str = str $ "X=" $ trackActor.Location.X $ CR() $
				            "Y=" $ trackActor.Location.Y $ CR() $
				            "Z=" $ trackActor.Location.Z $ CR();
			}
			if (bShowVelocity || bShowData)
			{
				speed  = trackActor.Velocity.X*trackActor.Velocity.X;
				speed += trackActor.Velocity.Y*trackActor.Velocity.Y;
				speed += trackActor.Velocity.Z*trackActor.Velocity.Z;
				speed  = sqrt(speed);

				str = str $ "|c8080ff";
				str = str $ "vS=" $ speed $ CR() $
				            "vX=" $ trackActor.Velocity.X $ CR() $
				            "vY=" $ trackActor.Velocity.Y $ CR() $
				            "vZ=" $ trackActor.Velocity.Z $ CR();
			}
			if (bShowAcceleration || bShowData)
			{
				speed  = trackActor.Acceleration.X*trackActor.Acceleration.X;
				speed += trackActor.Acceleration.Y*trackActor.Acceleration.Y;
				speed += trackActor.Acceleration.Z*trackActor.Acceleration.Z;
				speed  = sqrt(speed);

				str = str $ "|cff8080";
				str = str $ "aS=" $ speed $ CR() $
				            "aX=" $ trackActor.Acceleration.X $ CR() $
				            "aY=" $ trackActor.Acceleration.Y $ CR() $
				            "aZ=" $ trackActor.Acceleration.Z $ CR();
			}
			if (bShowHealth || bShowData)
			{
				str = str $ "|p6H=";
				if (Pawn(trackActor) != None)
				{
					str = str $ Pawn(trackActor).Health $ CR();
					str = str $ Pawn(trackActor).HealthHead $ CR();
					str = str $ Pawn(trackActor).HealthArmRight $ "-" $ Pawn(trackActor).HealthTorso $ "-" $ Pawn(trackActor).HealthArmLeft $ CR();
					str = str $ Pawn(trackActor).HealthLegRight $ "-" $ Pawn(trackActor).HealthLegLeft $ CR();

				}
				else if (DeusExDecoration(trackActor) != None)
					str = str $ DeusExDecoration(trackActor).HitPoints $ CR();
				else
					str = str $ "n/a" $ CR();
			}

			barOffset = 0;
			if (bShowEnemyResponse || bShowData)
			{
				trackPawn = ScriptedPawn(trackActor);
				if (trackPawn != None)
				{
					barOffset = 8;
					barWidth  = 50;
					barValue  = int(FClamp(trackPawn.EnemyReadiness*barWidth+0.5, 1, barWidth));
					if (trackPawn.EnemyReadiness <= 0)
						barValue = 0;
					gc.SetStyle(DSTY_Normal);
					gc.SetTileColorRGB(64, 64, 64);
					gc.DrawPattern((leftX+rightX-barWidth)/2, bottomY+5, barWidth, barOffset,
					               0, 0, Texture'Dithered');
					if (trackPawn.EnemyReadiness >= 1.0)
					{
						if (int(GetPlayerPawn().Level.TimeSeconds*4)%2 == 1)
							gc.SetTileColorRGB(255, 0, 0);
						else
							gc.SetTileColorRGB(255, 255, 255);
					}
					else
						gc.SetTileColor(GetColorScaled(1-trackPawn.EnemyReadiness));
					gc.DrawPattern((leftX+rightX-barWidth)/2, bottomY+5, barValue, barOffset,
					               0, 0, Texture'Solid');
					barOffset += 5;
				}
			}

			if (str != "")
			{
				gc.SetAlignments(HALIGN_Center, VALIGN_Top);
				gc.SetFont(Font'TechSmall');
				//gc.SetTextColorRGB(visibility*255, visibility*255, visibility*255);
				gc.SetTextColorRGB(0, 255, 0);
				gc.DrawText(leftX-40, bottomY+barOffset+5, 80+rightX-leftX, 280, str);
			}

			gc.SetTextColor(mainColor);
			gc.SetAlignments(HALIGN_Center, VALIGN_Bottom);
			gc.SetFont(Font'TechSmall');
			gc.DrawText(leftX-40, topY-140, 80+rightX-leftX, 135, GetPlayerPawn().GetItemName(String(trackActor)));
		}
	}
}

defaultproperties
{
     bShowLineOfSight=True
}
