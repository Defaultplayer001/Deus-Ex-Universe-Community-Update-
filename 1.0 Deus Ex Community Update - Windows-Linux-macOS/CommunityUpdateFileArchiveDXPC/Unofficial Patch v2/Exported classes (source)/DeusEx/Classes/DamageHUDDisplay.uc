//=============================================================================
// DamageHUDDisplay
//=============================================================================
class DamageHUDDisplay extends Window
	transient;

struct sIconInfo
{
	var name	damageType[3];
	var Texture	icon;
	var bool	bActive;
	var float	initTime;
	var float	hitDir;
	var bool	bHitCenter;
	var Color	color;
};

var DeusExPlayer player;
var int iconWidth, iconHeight, iconMargin;
var int arrowiconWidth, arrowiconHeight;
var float fadeTime;
var float absorptionPercent;
var sIconInfo iconInfo[7];

var localized String msgAbsorbed;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	// couldn't get these to work in the defaultproperties section
	iconInfo[0].damageType[0] = 'Shocked';
	iconInfo[0].icon = Texture'DamageIconElectricity';
	iconInfo[0].color.R = 0;
	iconInfo[0].color.G = 196;
	iconInfo[0].color.B = 255;
	iconInfo[1].damageType[0] = 'EMP';
	iconInfo[1].icon = Texture'DamageIconEMP';
	iconInfo[1].color.R = 0;
	iconInfo[1].color.G = 196;
	iconInfo[1].color.B = 255;
	iconInfo[2].damageType[0] = 'Burned';
	iconInfo[2].damageType[1] = 'Flamed';
	iconInfo[2].damageType[2] = 'Exploded';
	iconInfo[2].icon = Texture'DamageIconFire';
	iconInfo[2].color.R = 255;
	iconInfo[2].color.G = 96;
	iconInfo[2].color.B = 0;
	iconInfo[3].damageType[0] = 'PoisonGas';
	iconInfo[3].damageType[1] = 'TearGas';
	iconInfo[3].icon = Texture'DamageIconGas';
	iconInfo[3].color.R = 0;
	iconInfo[3].color.G = 196;
	iconInfo[3].color.B = 0;
	iconInfo[4].damageType[0] = 'Drowned';
	iconInfo[4].damageType[1] = 'HalonGas';
	iconInfo[4].icon = Texture'DamageIconOxygen';
	iconInfo[4].color.R = 0;
	iconInfo[4].color.G = 128;
	iconInfo[4].color.B = 255;
	iconInfo[5].damageType[0] = 'Radiation';
	iconInfo[5].icon = Texture'DamageIconRadiation';
	iconInfo[5].color.R = 255;
	iconInfo[5].color.G = 255;
	iconInfo[5].color.B = 0;
	iconInfo[6].damageType[0] = 'Shot';
	iconInfo[6].damageType[1] = 'Sabot';
	iconInfo[6].icon = None;
	iconInfo[6].color.R = 255;
	iconInfo[6].color.G = 0;
	iconInfo[6].color.B = 0;

	Hide();
}

// ----------------------------------------------------------------------
// AddIcon()
// ----------------------------------------------------------------------

function AddIcon(name damageType, vector hitOffset)
{
	local int i, j;

	if (damageType != '')
	{
		// save the icon info and startup time
		for (i=0; i<ArrayCount(iconInfo); i++)
		{
			for (j=0; j<ArrayCount(iconInfo[i].damageType); j++)
			{
				if (damageType == iconInfo[i].damageType[j])
				{
					iconInfo[i].bActive = True;
					iconInfo[i].initTime = player.Level.TimeSeconds;
					iconInfo[i].hitDir = Rotator(hitOffset).Yaw;

					// check for special case non-locational damage
					if (hitOffset == vect(0,0,0))
						iconInfo[i].bHitCenter = True;

					// range it from 0 to 65535
					if (iconInfo[i].hitDir < 0)
						iconInfo[i].hitDir += 65536;

					Show();
					break;
				}
			}
		}
	}
}

// ----------------------------------------------------------------------
// SetPercent()
// ----------------------------------------------------------------------

function SetPercent(float percent)
{
	absorptionPercent = percent;
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

function DrawWindow(GC gc)
{
	local int i;
	local float timestamp, alpha, maxalpha;
	local bool bVisible;
	local bool bCenter, bFront, bRear, bLeft, bRight;
	local color col;
	local string strInfo;
	local float strW, strH, strX, strY;

	bVisible = False;
	timestamp = player.Level.TimeSeconds;

	gc.SetStyle(DSTY_Translucent);
	maxalpha = 0;

	// go through all the icons and draw them
	for (i=0; i<ArrayCount(iconInfo); i++)
	{
		if (iconInfo[i].bActive)
		{
			alpha = 1.0 - ((timestamp - iconInfo[i].initTime) / fadeTime);

			if (alpha > maxalpha)
				maxalpha = alpha;

			// if it's faded completely out, delete it
			if (alpha <= 0)
			{
				iconInfo[i].bActive = False;
				iconInfo[i].initTime = 0;
				iconInfo[i].hitDir = 0;
				iconInfo[i].bHitCenter = False;
			}
			else
			{
				// fade the color to black
				col = iconInfo[i].color;
				col.R = int(float(col.R) * alpha);
				col.G = int(float(col.G) * alpha);
				col.B = int(float(col.B) * alpha);
				gc.SetTileColor(col);

				// draw the icon
				if (iconInfo[i].icon != None)
					gc.DrawTexture((width-iconWidth)/2, i*(iconHeight+iconMargin), iconWidth, iconHeight, 0, 0, iconInfo[i].icon);
				bVisible = True;

				// figure out what side we're hit on
				if (iconInfo[i].bHitCenter)
					bCenter = True;
				else
				{
					if ((iconInfo[i].hitDir > 53248) || (iconInfo[i].hitDir < 12288))
						bFront = True;
					if ((iconInfo[i].hitDir > 20480) && (iconInfo[i].hitDir < 45056))
						bRear = True;
					if ((iconInfo[i].hitDir > 4096) && (iconInfo[i].hitDir < 28672))
						bRight = True;
					if ((iconInfo[i].hitDir > 36864) && (iconInfo[i].hitDir < 61440))
						bLeft = True;
				}
			}
		}
	}

	// draw the location arrows
	col = iconInfo[ArrayCount(iconInfo)-1].color;
	col.R = int(float(col.R) * maxalpha);
	col.G = int(float(col.G) * maxalpha);
	col.B = int(float(col.B) * maxalpha);
	gc.SetTileColor(col);

	if (bFront)
		gc.DrawTexture(iconMargin, ArrayCount(iconInfo)*(iconHeight+iconMargin), arrowiconWidth, arrowiconHeight, 0, 0, Texture'DamageIconUp');
	if (bRear)
		gc.DrawTexture(iconMargin, ArrayCount(iconInfo)*(iconHeight+iconMargin), arrowiconWidth, arrowiconHeight, 0, 0, Texture'DamageIconDown');
	if (bLeft)
		gc.DrawTexture(iconMargin, ArrayCount(iconInfo)*(iconHeight+iconMargin), arrowiconWidth, arrowiconHeight, 0, 0, Texture'DamageIconLeft');
	if (bRight)
		gc.DrawTexture(iconMargin, ArrayCount(iconInfo)*(iconHeight+iconMargin), arrowiconWidth, arrowiconHeight, 0, 0, Texture'DamageIconRight');
	if (bCenter)
		gc.DrawTexture(iconMargin, ArrayCount(iconInfo)*(iconHeight+iconMargin), arrowiconWidth, arrowiconHeight, 0, 0, Texture'DamageIconCenter');

	// draw the damage absorption percent
	if (absorptionPercent != 0.0)
	{
		col.R = 0;
		col.G = int(255.0 * maxalpha);
		col.B = 0;
		gc.EnableTranslucentText(True);
		gc.SetTextColor(col);
		gc.SetFont(Font'TechSmall');
		strInfo = Sprintf(msgAbsorbed, Int(absorptionPercent * 100.0));
		gc.GetTextExtent(0, strW, strH, strInfo);
		strX = (width - strW) / 2;
		strY = height - (arrowIconHeight + strH) / 2;
		gc.DrawText(strX, strY, strW, strH, strInfo);
	}

	if (!bVisible)
	{
		bFront = False;
		bRear = False;
		bLeft = False;
		bRight = False;
		absorptionPercent = 0.0;
	}
}

// ----------------------------------------------------------------------
// SetVisibility()
// ----------------------------------------------------------------------

function SetVisibility( bool bNewVisibility )
{
	Show(bNewVisibility);
}

// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

function bool ChildRequestedReconfiguration(window child)
{
	return False;
}

// ----------------------------------------------------------------------
// ParentRequestedPreferredSize()
// ----------------------------------------------------------------------

event ParentRequestedPreferredSize(bool bWidthSpecified, out float preferredWidth,
                                   bool bHeightSpecified, out float preferredHeight)
{
	preferredWidth  = arrowiconWidth + iconMargin;
	preferredHeight = (iconHeight + iconMargin) * ArrayCount(iconInfo) + arrowiconHeight;
}

defaultproperties
{
     IconWidth=24
     IconHeight=24
     iconMargin=2
     arrowiconWidth=64
     arrowiconHeight=64
     fadeTime=2.000000
     msgAbsorbed="%d%% Absorb"
}
