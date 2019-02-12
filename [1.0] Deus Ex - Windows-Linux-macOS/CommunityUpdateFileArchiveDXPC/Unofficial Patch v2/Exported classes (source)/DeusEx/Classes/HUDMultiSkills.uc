//=============================================================================
// HUDMultiSkills - In game skill selection for multiplayer
//=============================================================================

class HUDMultiSkills extends HUDBaseWindow;

const	skillListX	= 0.01;				// Screen multiplier
const skillListY	= 0.38;
const skillMsgY	= 0.7;
const	skillCostX	= 0.25;
const skillLevelX	= 0.19;
const levelBoxSize = 5;

var localized String		ToExitString;
var localized String		SkillsAvailableString;
var localized String		PressString, PressEndString;
var localized String		SkillPointsString;
var localized String		SkillString;
var localized String		CostString;
var localized String		NAString;
var localized String		LevelString;
var localized String		KeyNotBoundString;

var Color	colBlue, colWhite;
var Color	colGreen, colLtGreen;
var Color	colRed, colLtRed;

const TimeDelay	= 10;
var bool				bNotifySkills;
var int				timeToNotify;
var int				curSkillPoints;
var String			curKeyName;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
	SetWindowAlignments( HALIGN_Full, VALIGN_Full );
	bNotifySkills = False;
	RefreshKey();
}

// ----------------------------------------------------------------------
// RefreshKey
// ----------------------------------------------------------------------

function RefreshKey()
{
	local String KeyName, Alias;
	local int i;

	curKeyName = "";
	for ( i=0; i<255; i++ )
	{
		KeyName = player.ConsoleCommand ( "KEYNAME "$i );
		if ( KeyName != "" )
		{
			Alias = player.ConsoleCommand( "KEYBINDING "$KeyName );
			if ( Alias ~= "BuySkills" )
			{
				curKeyName = KeyName;
				break;
			}
		}
	}
	if ( curKeyName ~= "" )
		curKeyName = KeyNotBoundString;
}

// ----------------------------------------------------------------------
// DestroyWindow()
// ----------------------------------------------------------------------

event DestroyWindow()
{
	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
function DrawLevel( GC gc, float x, float y, int level )
{
	local int i;

	if (( level < 0 ) || (level > 3 ))
	{
		log("Warning:Bad skill level:"$level$" " );
		return;
	}
	for ( i = 0; i < level; i++ )
	{
		gc.DrawTexture( x, y+2.0, levelBoxSize, levelBoxSize, 0, 0, Texture'Solid');
		x += (levelBoxSize + levelBoxSize/2);
	}
}

// ----------------------------------------------------------------------
// SkillMessage()
// ----------------------------------------------------------------------
function SkillMessage( GC gc )
{
	local bool bShowMsg, bSkillAvail;
	local Skill askill;
	local float curx, cury, w, h, w2, t, offset;
	local String str;

	if ( curSkillPoints != Player.SkillPointsAvail )
		bNotifySkills = False;
	
	bSkillAvail = False;
	if ( Player.SkillSystem != None )
	{
		askill = Player.SkillSystem.FirstSkill;

		while ( askill != None )
		{
			if ( SkillSwimming(askill) == None )
			{
				if ( askill.CurrentLevel < 3 )
				{
					if ( Player.SkillPointsAvail >= askill.cost[askill.CurrentLevel] )
					{
						bSkillAvail = True;
						break;
					}
				}
			}
			askill = askill.next;
		}
		if ( bSkillAvail )
		{
			if ( !bNotifySkills )
			{
				RefreshKey();
				timeToNotify = Player.Level.Timeseconds + TimeDelay;
				curSkillPoints = Player.SkillPointsAvail;
				Player.BuySkillSound( 3 );
				bNotifySkills = True;
			}
			if ( timeToNotify > Player.Level.Timeseconds )
			{
				// Flash them to draw a little more attention 1.5 on .5 off
				if ( (Player.Level.Timeseconds % 1.5) < 1 )
				{
					offset = 0;
					gc.SetFont(Font'FontMenuSmall_DS');
					cury = height * skillMsgY;
					curx = width * skillListX;
					str = PressString $ curKeyName $ PressEndString;
					gc.GetTextExtent( 0, w, h, SkillsAvailableString );
					gc.GetTextExtent( 0, w2, h, str );
					if ( (curx + ((w-w2)*0.5)) < 0 )
						offset = -(curx + ((w-w2)*0.5));
					gc.SetTextColor( colLtGreen );
					gc.GetTextExtent( 0, w, h, SkillsAvailableString );
					gc.DrawText( curx+offset, cury, w, h, SkillsAvailableString );
					cury +=  h;
					gc.GetTextExtent( 0, w2, h, str );
					curx += ((w-w2)*0.5);
					gc.DrawText( curx+offset, cury, w2, h, str );
				}
			}
		}
	}
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	local Skill askill;
	local float curx, cury, w, h;
	local String str, costStr;
	local int index;
	local bool bHitSwimming;
	local float barLen, costx, levelx;

	bHitSwimming = False;

	if (( Player == None ) || (!Player.PlayerIsClient()) )
		return;

	if ( Player.bBuySkills )
	{
		if (( Player != None ) && ( Player.SkillSystem != None ))
		{
			gc.SetFont(Font'FontMenuSmall_DS');
			index = 1;
			askill = Player.SkillSystem.FirstSkill;
			cury = height * skillListY;
			curx = width * skillListX;
			costx = width * skillCostX;
			levelx = width * skillLevelX;
			gc.GetTextExtent( 0, w, h, CostString );
			barLen = (costx+(w*1.33))-curx;
			gc.DrawBox( curx, cury, barLen, 1, 0, 0, 1, Texture'Solid');
			cury += (h*0.25);
			str = SkillPointsString $ Player.SkillPointsAvail;
			gc.GetTextExtent( 0, w, h, str );
			gc.DrawText( curx, cury, w, h, str );
			cury += h;
			gc.DrawBox( curx, cury, barLen, 1, 0, 0, 1, Texture'Solid');
			cury += (h*0.25);
			str = SkillString;
			gc.GetTextExtent( 0, w, h, str );
			gc.DrawText( curx, cury, w, h, str );
			str = LevelString;
			gc.GetTextExtent( 0, w, h, str );
			gc.DrawText( levelx, cury, w, h, str );
			str = CostString;
			gc.GetTextExtent( 0, w, h, str );
			gc.DrawText( costx, cury, w, h, str );
			cury += h;
			gc.DrawBox( curx, cury, barLen, 1, 0, 0, 1, Texture'Solid');
			cury += (h*0.25);

			while ( askill != None )
			{
				if ( SkillSwimming(askill) == None )
				{
					if ( index == 10 )
						str = "0. " $ askill.SkillName;
					else
						str = index $ ". " $ askill.SkillName;

					gc.GetTextExtent( 0, w, h, str );
					if ( askill.CurrentLevel == 3)
					{
						gc.SetTileColor( colBlue );
						gc.SetTextColor( colBlue );
						costStr = NAString;
					}
					else if ( Player.SkillPointsAvail >= askill.cost[askill.CurrentLevel] )
					{
						if ( askill.CurrentLevel == 2)
						{
							gc.SetTextColor( colLtGreen );
							gc.SetTileColor( colLtGreen );
						}
						else
						{
							gc.SetTextColor( colGreen );
							gc.SetTileColor( colGreen );
						}
						costStr = "" $ askill.cost[askill.CurrentLevel];
					}
					else
					{
						if ( askill.CurrentLevel == 2)
						{
							gc.SetTileColor( colLtRed );
							gc.SetTextColor( colLtRed );
						}
						else
						{
							gc.SetTileColor( colRed );
							gc.SetTextColor( colRed );
						}
						costStr = "" $ askill.cost[askill.CurrentLevel];
					}
					gc.DrawText( curx, cury, w, h, str );
					DrawLevel( gc, levelx, cury, askill.CurrentLevel );
					gc.GetTextExtent(	0, w, h, costStr );
					gc.DrawText( costx, cury, w, h, costStr );
					cury += h;
					index += 1;
				}
				askill = askill.next;
			}
			gc.SetTileColor( colWhite );
			if ( curKeyName ~= KeyNotBoundString )
				RefreshKey();
			str = PressString $ curKeyName $ ToExitString;
			gc.GetTextExtent( 0, w, h, str );
			gc.DrawBox( curx, cury, barLen, 1, 0, 0, 1, Texture'Solid');
			cury += (h*0.25);
			gc.SetTextColor( colWhite );
			gc.DrawText( curx + ((barLen*0.5)-(w*0.5)), cury, w, h, str );
			cury += h;
			gc.DrawBox( curx, cury, barLen, 1, 0, 0, 1, Texture'Solid');
		}
	}
	else 
		SkillMessage( gc );

	Super.DrawWindow(gc);
}

// ----------------------------------------------------------------------
// GetSkillFromIndex()
// ----------------------------------------------------------------------
function Skill GetSkillFromIndex( DeusExPlayer thisPlayer, int index )
{
	local Skill askill;
	local int curIndex;

	// Zero indexed, but min element is 1, 0 is 10
	if ( index == 0 )
		index = 9;
	else
		index -= 1;

	curIndex = 0;
	askill = None;
	if ( thisPlayer != None )
	{
		askill = thisPlayer.SkillSystem.FirstSkill;
		while ( askill != None )
		{
			if ( SkillSwimming(askill) == None )
			{
				if ( curIndex == index )
					return( askill );

				curIndex += 1;
			}
			askill = askill.next;
		}
	}
	return( askill );
}

// ----------------------------------------------------------------------
// AttemptBuySkill()
// ----------------------------------------------------------------------
function bool AttemptBuySkill( DeusExPlayer thisPlayer, Skill askill )
{
	if ( askill != None )
	{
		// Already master
		if ( askill.CurrentLevel == 3 )
		{
			thisPlayer.BuySkillSound( 1 );
			return ( False );
		}
		else if ( thisPlayer.SkillPointsAvail >= askill.cost[askill.CurrentLevel] )
		{
			thisPlayer.BuySkillSound( 0 );
			return( askill.IncLevel() );
		}
		else
		{
			thisPlayer.BuySkillSound( 1 );
			return( False );
		}
	}
}

// ----------------------------------------------------------------------
// OverrideBelt()
// ----------------------------------------------------------------------

function bool OverrideBelt( DeusExPlayer thisPlayer, int objectNum )
{
	local Skill askill;

	if ( !thisPlayer.bBuySkills )
		return False;

	askill = GetSkillFromIndex( thisPlayer, objectNum );
	if ( AttemptBuySkill( thisPlayer, askill ) )
		thisPlayer.bBuySkills = False; 		// Got our skill, exit out of menu

	if ( ( objectNum >= 0 ) && ( objectNum <= 10) )
		return True;
	else
		return False;
}

defaultproperties
{
     ToExitString="> to exit."
     SkillsAvailableString="Skills available!"
     PressString="Press <"
     PressEndString=">"
     SkillPointsString="Skill Points: "
     skillString="Skill"
     CostString="Cost"
     NAString="MAX"
     LevelString="Level"
     KeyNotBoundString="Key Not Bound"
     colBlue=(B=255)
     colWhite=(R=255,G=255,B=255)
     colGreen=(G=128)
     colLtGreen=(G=255)
     colRed=(R=128)
     colLtRed=(R=255)
}
