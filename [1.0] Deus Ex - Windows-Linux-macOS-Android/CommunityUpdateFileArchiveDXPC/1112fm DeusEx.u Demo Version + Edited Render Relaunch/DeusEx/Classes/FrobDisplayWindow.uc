//=============================================================================
// FrobDisplayWindow.
//=============================================================================
class FrobDisplayWindow extends Window;

var float margin;
var float barLength;

var DeusExPlayer player;

var localized string msgLocked;
var localized string msgUnlocked;
var localized string msgLockStr;
var localized string msgDoorStr;
var localized string msgHackStr;
var localized string msgInf;
var localized string msgHacked;
var localized string msgPick;
var localized string msgPicks;
var localized string msgTool;
var localized string msgTools;

// Default Colors
var Color colBackground;
var Color colBorder;
var Color colText;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

function InitWindow()
{
	Super.InitWindow();

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	StyleChanged();
}

// ----------------------------------------------------------------------
// FormatString()
// ----------------------------------------------------------------------

function string FormatString(float num)
{
	local string tempstr;

	// round up
	num += 0.5;

	tempstr = Left(String(num), 3);

	if (num < 100.0)
		tempstr = Left(String(num), 2);
	if (num < 10.0)
		tempstr = Left(String(num), 1);

	return tempstr;
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

function DrawWindow(GC gc)
{
	local actor				frobTarget;
	local float				infoX, infoY, infoW, infoH;
	local string			strInfo;
	local DeusExMover		dxMover;
	local Mover				M;
	local HackableDevices	device;
	local Vector			centerLoc, v1, v2;
	local float				boxCX, boxCY, boxTLX, boxTLY, boxBRX, boxBRY, boxW, boxH;
	local float				corner, x, y;
	local int				i, j, k, offset;
	local Color				col;
	local int				numTools;

	if (player != None)
	{
		frobTarget = player.FrobTarget;
		if (frobTarget != None)
			if (!player.IsHighlighted(frobTarget))
				frobTarget = None;

		if (frobTarget != None)
		{
			// move the box in and out based on time
			offset = (24.0 * (frobTarget.Level.TimeSeconds % 0.3));

			// draw a cornered targetting box
			// get the center of the object
			M = Mover(frobTarget);
			if (M != None)
			{
				M.GetBoundingBox(v1, v2, False, M.KeyPos[M.KeyNum]+M.BasePos, M.KeyRot[M.KeyNum]+M.BaseRot);
				centerLoc = v1 + (v2 - v1) * 0.5;
				v1.X = 16;
				v1.Y = 16;
				v1.Z = 16;
			}
			else
			{
				centerLoc = frobTarget.Location;
				v1.X = frobTarget.CollisionRadius;
				v1.Y = frobTarget.CollisionRadius;
				v1.Z = frobTarget.CollisionHeight;
			}

			ConvertVectorToCoordinates(centerLoc, boxCX, boxCY);

			boxTLX = boxCX;
			boxTLY = boxCY;
			boxBRX = boxCX;
			boxBRY = boxCY;

			// get the smallest box to enclose actor
			// modified from Scott's ActorDisplayWindow
			for (i=-1; i<=1; i+=2)
			{
				for (j=-1; j<=1; j+=2)
				{
					for (k=-1; k<=1; k+=2)
					{
						v2 = v1;
						v2.X *= i;
						v2.Y *= j;
						v2.Z *= k;
						v2.X += centerLoc.X;
						v2.Y += centerLoc.Y;
						v2.Z += centerLoc.Z;

						if (ConvertVectorToCoordinates(v2, x, y))
						{
							boxTLX = FMin(boxTLX, x);
							boxTLY = FMin(boxTLY, y);
							boxBRX = FMax(boxBRX, x);
							boxBRY = FMax(boxBRY, y);
						}
					}
				}
			}

			if (!frobTarget.IsA('Mover'))
			{
				boxTLX += frobTarget.CollisionRadius / 4.0;
				boxTLY += frobTarget.CollisionHeight / 4.0;
				boxBRX -= frobTarget.CollisionRadius / 4.0;
				boxBRY -= frobTarget.CollisionHeight / 4.0;
			}

			boxTLX = FClamp(boxTLX, margin, width-margin);
			boxTLY = FClamp(boxTLY, margin, height-margin);
			boxBRX = FClamp(boxBRX, margin, width-margin);
			boxBRY = FClamp(boxBRY, margin, height-margin);

			boxW = boxBRX - boxTLX;
			boxH = boxBRY - boxTLY;

			// scale the corner based on the size of the box
			corner = FClamp((boxW + boxH) * 0.1, 4.0, 40.0);

			// make sure the box doesn't invert itself
			if (boxBRX - boxTLX < corner)
			{
				boxTLX -= (corner+4);
				boxBRX += (corner+4);
			}
			if (boxBRY - boxTLY < corner)
			{
				boxTLY -= (corner+4);
				boxBRY += (corner+4);
			}

			// draw the drop shadow first, then normal
			gc.SetTileColorRGB(0,0,0);
			for (i=1; i>=0; i--)
			{
				gc.DrawBox(boxTLX+i+offset, boxTLY+i+offset, corner, 1, 0, 0, 1, Texture'Solid');
				gc.DrawBox(boxTLX+i+offset, boxTLY+i+offset, 1, corner, 0, 0, 1, Texture'Solid');

				gc.DrawBox(boxBRX+i-corner-offset, boxTLY+i+offset, corner, 1, 0, 0, 1, Texture'Solid');
				gc.DrawBox(boxBRX+i-offset, boxTLY+i+offset, 1, corner, 0, 0, 1, Texture'Solid');

				gc.DrawBox(boxTLX+i+offset, boxBRY+i-offset, corner, 1, 0, 0, 1, Texture'Solid');
				gc.DrawBox(boxTLX+i+offset, boxBRY+i-corner-offset, 1, corner, 0, 0, 1, Texture'Solid');

				gc.DrawBox(boxBRX+i-corner+1-offset, boxBRY+i-offset, corner, 1, 0, 0, 1, Texture'Solid');
				gc.DrawBox(boxBRX+i-offset, boxBRY+i-corner-offset, 1, corner, 0, 0, 1, Texture'Solid');

				gc.SetTileColor(colText);
			}

			// draw object-specific info
			if (frobTarget.IsA('Mover'))
			{
				// get the door's lock and strength info
				dxMover = DeusExMover(frobTarget);
				if ((dxMover != None) && dxMover.bLocked)
				{
					strInfo = msgLocked $ CR() $ msgLockStr;
					if (dxMover.bPickable)
						strInfo = strInfo $ FormatString(dxMover.lockStrength * 100.0) $ "%";
					else
						strInfo = strInfo $ msgInf;

					strInfo = strInfo $ CR() $ msgDoorStr;
					if (dxMover.bBreakable)
						strInfo = strInfo $ FormatString(dxMover.doorStrength * 100.0) $ "%";
					else
						strInfo = strInfo $ msgInf;
				}
				else
				{
					strInfo = msgUnlocked;
				}

				infoX = boxTLX + 10;
				infoY = boxTLY + 10;

				gc.SetFont(Font'FontMenuSmall_DS');
				gc.GetTextExtent(0, infoW, infoH, strInfo);
				infoW += 8;
				if ((dxMover != None) && dxMover.bLocked)
					infoW += barLength + 2;
				infoH += 8;
				infoX = FClamp(infoX, infoW/2+10, width-10-infoW/2);
				infoY = FClamp(infoY, infoH/2+10, height-10-infoH/2);

				// draw a dark background
				gc.SetStyle(DSTY_Modulated);
				gc.SetTileColorRGB(0, 0, 0);
				gc.DrawPattern(infoX, infoY, infoW, infoH, 0, 0, Texture'ConWindowBackground');

				// draw colored bars for each value
				if ((dxMover != None) && dxMover.bLocked)
				{
					gc.SetStyle(DSTY_Translucent);
					col = GetColorScaled(dxMover.lockStrength);
					gc.SetTileColor(col);
					gc.DrawPattern(infoX+(infoW-barLength-4), infoY+4+(infoH-8)/3, barLength*dxMover.lockStrength, ((infoH-8)/3)-2, 0, 0, Texture'ConWindowBackground');
					col = GetColorScaled(dxMover.doorStrength);
					gc.SetTileColor(col);
					gc.DrawPattern(infoX+(infoW-barLength-4), infoY+4+2*(infoH-8)/3, barLength*dxMover.doorStrength, ((infoH-8)/3)-2, 0, 0, Texture'ConWindowBackground');
				}

				// draw the text
				gc.SetTextColor(colText);
				gc.DrawText(infoX+4, infoY+4, infoW-8, infoH-8, strInfo);

				// draw the two highlight boxes
				gc.SetStyle(DSTY_Translucent);
				gc.SetTileColor(colBorder);
				gc.DrawBox(infoX, infoY, infoW, infoH, 0, 0, 1, Texture'Solid');
				gc.SetTileColor(colBackground);
				gc.DrawBox(infoX+1, infoY+1, infoW-2, infoH-2, 0, 0, 1, Texture'Solid');

				// draw the absolute number of lockpicks on top of the colored bar
				if ((dxMover != None) && dxMover.bLocked && dxMover.bPickable)
				{
					numTools = int((dxMover.lockStrength / player.SkillSystem.GetSkillLevelValue(class'SkillLockpicking')) + 0.99);
					if (numTools == 1)
						strInfo = numTools @ msgPick;
					else
						strInfo = numTools @ msgPicks;
					gc.DrawText(infoX+(infoW-barLength-2), infoY+4+(infoH-8)/3, barLength, ((infoH-8)/3)-2, strInfo);
				}
			}
			else if (frobTarget.IsA('HackableDevices'))
			{
				// get the devices hack strength info
				device = HackableDevices(frobTarget);
				strInfo = DeusExDecoration(frobTarget).itemName $ CR() $ msgHackStr;
				if (device.bHackable)
				{
					if (device.hackStrength != 0.0)
						strInfo = strInfo $ FormatString(device.hackStrength * 100.0) $ "%";
					else
						strInfo = DeusExDecoration(frobTarget).itemName $ ": " $ msgHacked;
				}
				else
					strInfo = strInfo $ msgInf;

				infoX = boxTLX + 10;
				infoY = boxTLY + 10;

				gc.SetFont(Font'FontMenuSmall_DS');
				gc.GetTextExtent(0, infoW, infoH, strInfo);
				infoW += 8;
				if (device.hackStrength != 0.0)
					infoW += barLength + 2;
				infoH += 8;
				infoX = FClamp(infoX, infoW/2+10, width-10-infoW/2);
				infoY = FClamp(infoY, infoH/2+10, height-10-infoH/2);

				// draw a dark background
				gc.SetStyle(DSTY_Modulated);
				gc.SetTileColorRGB(0, 0, 0);
				gc.DrawPattern(infoX, infoY, infoW, infoH, 0, 0, Texture'ConWindowBackground');

				// draw a colored bar
				if (device.hackStrength != 0.0)
				{
					gc.SetStyle(DSTY_Translucent);
					col = GetColorScaled(device.hackStrength);
					gc.SetTileColor(col);
					gc.DrawPattern(infoX+(infoW-barLength-4), infoY+infoH/2, barLength*device.hackStrength, infoH/2-6, 0, 0, Texture'ConWindowBackground');
				}

				// draw the text
				gc.SetTextColor(colText);
				gc.DrawText(infoX+4, infoY+4, infoW-8, infoH-8, strInfo);

				// draw the two highlight boxes
				gc.SetStyle(DSTY_Translucent);
				gc.SetTileColor(colBorder);
				gc.DrawBox(infoX, infoY, infoW, infoH, 0, 0, 1, Texture'Solid');
				gc.SetTileColor(colBackground);
				gc.DrawBox(infoX+1, infoY+1, infoW-2, infoH-2, 0, 0, 1, Texture'Solid');

				// draw the absolute number of multitools on top of the colored bar
				if ((device.bHackable) && (device.hackStrength != 0.0))
				{
					numTools = int((device.hackStrength / player.SkillSystem.GetSkillLevelValue(class'SkillTech')) + 0.99);
					if (numTools == 1)
						strInfo = numTools @ msgTool;
					else
						strInfo = numTools @ msgTools;
					gc.DrawText(infoX+(infoW-barLength-2), infoY+infoH/2, barLength, infoH/2-6, strInfo);
				}
			}
			else if (!frobTarget.bStatic && player.bObjectNames)
			{
				// TODO: Check familiar vs. unfamiliar flags
				if (frobTarget.IsA('Pawn'))
					strInfo = player.GetDisplayName(frobTarget);
				else if (frobTarget.IsA('DeusExCarcass'))
					strInfo = DeusExCarcass(frobTarget).itemName;
				else if (frobTarget.IsA('Inventory'))
					strInfo = Inventory(frobTarget).itemName;
				else if (frobTarget.IsA('DeusExDecoration'))
					strInfo = player.GetDisplayName(frobTarget);
				else if (frobTarget.IsA('DeusExProjectile'))
					strInfo = DeusExProjectile(frobTarget).itemName;
				else
					strInfo = "DEFAULT ACTOR NAME - REPORT THIS AS A BUG - " $ frobTarget.GetItemName(String(frobTarget.Class));

				infoX = boxTLX + 10;
				infoY = boxTLY + 10;

				gc.SetFont(Font'FontMenuSmall_DS');
				gc.GetTextExtent(0, infoW, infoH, strInfo);
				infoW += 8;
				infoH += 8;
				infoX = FClamp(infoX, infoW/2+10, width-10-infoW/2);
				infoY = FClamp(infoY, infoH/2+10, height-10-infoH/2);

				// draw a dark background
				gc.SetStyle(DSTY_Modulated);
				gc.SetTileColorRGB(0, 0, 0);
				gc.DrawPattern(infoX, infoY, infoW, infoH, 0, 0, Texture'ConWindowBackground');

				// draw the text
				gc.SetTextColor(colText);
				gc.DrawText(infoX+4, infoY+4, infoW-8, infoH-8, strInfo);

				// draw the two highlight boxes
				gc.SetStyle(DSTY_Translucent);
				gc.SetTileColor(colBorder);
				gc.DrawBox(infoX, infoY, infoW, infoH, 0, 0, 1, Texture'Solid');
				gc.SetTileColor(colBackground);
				gc.DrawBox(infoX+1, infoY+1, infoW-2, infoH-2, 0, 0, 1, Texture'Solid');
			}
		}
	}
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colBackground = theme.GetColorFromName('HUDColor_Background');
	colBorder     = theme.GetColorFromName('HUDColor_Borders');
	colText       = theme.GetColorFromName('HUDColor_HeaderText');
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     margin=70.000000
     barLength=50.000000
     msgLocked="Locked"
     msgUnlocked="Unlocked"
     msgLockStr="Lock Str: "
     msgDoorStr="Door Str: "
     msgHackStr="Bypass Str: "
     msgInf="INF"
     msgHacked="Bypassed"
     msgPick="pick"
     msgPicks="picks"
     msgTool="tool"
     msgTools="tools"
}
