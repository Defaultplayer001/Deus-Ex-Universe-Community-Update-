//
//	MPDeathWindow - Is used for the death notification in multiplayer
//

class MultiplayerMessageWin extends DeusExBaseWindow;

var String killerName;
var String killerMethod;
var bool bKilledSelf;
var bool bValidMethod;

var localized String	KilledByString, WereKilledString;
var localized String KilledYourselfString;
var localized String FireToContinueMsg;

var localized String ActiveAugsString;
var localized String WeaponString;
var localized String RelevantSkillString;
var localized String LevelString;
var localized String	FinalBlowString;
var localized String	ToTheString;
var localized String RemHealthString;
var localized String RemHealth2String;
var localized String RemEnergyString;
var localized String RemEnergy2String;
var localized String HealthHeadString;
var localized String HealthMidString;
var localized String HealthLowString;
var localized String StreakString;
var localized String Detail1String;
var localized String Detail2String;
var localized String	KeyNotBoundString;
var localized String	VSString;

var Color	redColor, blueColor, whiteColor, greenColor, BrightRedColor;
var bool		bDestroy;
var bool    bKilled;
var bool    bDisplayProgress;
var float	lockoutTime;

const msgY		= 0.25;
const kpStartY = 0.4;

const kpColumn1X = 0.20;
const kpColumn2X = 0.60;

var String	curDetailKeyName;

//
// InitWindow()
//

event InitWindow()
{
	local int i;
	local String KeyName, Alias;

	Super.InitWindow();
	bDestroy = False;
	SetWindowAlignments(HALIGN_Full, VALIGN_Full);
	Show();
	root.ShowCursor( False );
	lockoutTime = Player.Level.Timeseconds + 3.0;
	Player.bKillerProfile = False;
	curDetailKeyName="";
	for ( i=0; i<255; i++ )
	{
		KeyName = player.ConsoleCommand ( "KEYNAME "$i );
		if ( KeyName != "" )
		{
			Alias = player.ConsoleCommand( "KEYBINDING "$KeyName );
			if ( Alias ~= "KillerProfile" )
			{
				curDetailKeyName = KeyName;
				break;
			}
		}
	}
	if ( curDetailKeyName ~= "" )
		curDetailKeyName=KeyNotBoundString;
}

//
// Destroy Window()
//

event DestroyWindow()
{
	root.ShowCursor( True );
   Player.ProgressTimeout = Player.Level.TimeSeconds;
	Player.bKillerProfile = False;
	lockoutTime = 0.0;
	Super.DestroyWindow();
}

//
// ShowKillerProfile
//
function ShowKillerProfile( GC gc )
{
	local float w, h, x, y, w2, oldy, barLen, by, by2;
	local String str;
	local int i;
	local KillerProfile kp;

	kp = Player.killProfile;

	if ( kp.bValid )
	{
      gc.SetTextColor( whiteColor );
		gc.SetFont(Font'FontMenuSmall_DS');
		y = kpStartY * height;
		str = FinalBlowString $ kp.damage $ ToTheString $ kp.bodyLoc $ ".";
		gc.GetTextExtent(0,w,h,str);
		gc.DrawText( width*0.5 - w*0.5, y, w, h, str );
		y += h;
		str = RemHealthString $ kp.name $ RemHealth2String $ HealthHeadString $ kp.healthHigh $ HealthMidString $ kp.healthMid $ HealthLowString $ kp.healthLow $ RemEnergyString $ kp.remainingBio $ RemEnergy2String;
		gc.GetTextExtent(0,w,h,str);
		gc.DrawText( width*0.5 - w*0.5, y, w, h, str );
		y += h;
		str = kp.name $ StreakString $ kp.streak $ ".";
		gc.GetTextExtent(0,w,h,str);
		gc.DrawText( width*0.5 - w*0.5, y, w, h, str );
		y += (2.0*h);

		// Enemey profile
      gc.SetTextColor( BrightRedColor );
		x = kpColumn1X * width;
		oldy = y;
		str = kp.name;
		gc.GetTextExtent( 0, w, h, str );
		gc.DrawText( x, y, w, h, str );
		y += h;
		barLen = width * 0.2;
		gc.SetTileColor( BrightRedColor );
		gc.DrawBox( x, y, barLen, 1, 0, 0, 1, Texture'Solid');
		y += (0.25*h);
		str = WeaponString $ kp.activeWeapon;
		gc.GetTextExtent(0,w,h,str);
		gc.DrawText( x, y, w, h, str );
		y += h;
		str = RelevantSkillString $ kp.activeSkill;
		gc.GetTextExtent(0,w,h,str);
		gc.DrawText( x, y, w, h, str );
		y += h;
		str = LevelString $ kp.activeSkillLevel;
		gc.GetTextExtent(0,w,h,str);
		gc.DrawText( x, y, w, h, str );
		y += h;
		str = ActiveAugsString $ kp.numActiveAugs;
		gc.GetTextExtent(0,w2,h,str);
		gc.DrawText( x, y, w2, h, str );
		y += h;
		for ( i = 0; i < kp.numActiveAugs; i++ )
		{
			gc.GetTextExtent( 0, w, h, kp.activeAugs[i] );
			gc.DrawText( x+(w2*0.25), y, w, h, kp.activeAugs[i] );
			y += h;
		}
		by = y;
		// Your profile
		y = oldy;
		x = kpColumn2X * width;
		gc.SetTileColor( greenColor );
		gc.SetTextColor( greenColor );
		str = Player.PlayerReplicationInfo.PlayerName;
		gc.GetTextExtent( 0, w, h, str );
		gc.DrawText( x, y, w, h, str );
		y += h;
		barLen = width * 0.2;
		gc.DrawBox( x, y, barLen, 1, 0, 0, 1, Texture'Solid');
		y += (0.25*h);
		str = WeaponString $ kp.myActiveWeapon;
		gc.GetTextExtent(0,w,h,str);
		gc.DrawText( x, y, w, h, str );
		y += h;
		str = RelevantSkillString $ kp.myActiveSkill;
		gc.GetTextExtent(0,w,h,str);
		gc.DrawText( x, y, w, h, str );
		y += h;
		str = LevelString $ kp.myActiveSkillLevel;
		gc.GetTextExtent(0,w,h,str);
		gc.DrawText( x, y, w, h, str );
		y += h;
		str = ActiveAugsString $ kp.myNumActiveAugs;
		gc.GetTextExtent(0,w2,h,str);
		gc.DrawText( x, y, w2, h, str );
		y += h;
		for ( i = 0; i < kp.myNumActiveAugs; i++ )
		{
			gc.GetTextExtent( 0, w, h, kp.myActiveAugs[i] );
			gc.DrawText( x+(w2*0.25), y, w, h, kp.myActiveAugs[i] );
			y += h;
		}
		by2 = y;

		if ( by2 > y )
			y = ((by2 - oldy)*0.4) + oldy;
		else
			y = ((by - oldy)*0.4) + oldy;
		str = VSString;
		gc.SetFont(Font'FontMenuTitle');
		gc.SetTextColor( whiteColor );
		gc.GetTextExtent( 0, w, h, str );
		gc.DrawText( 0.5*width-w*0.5, y, w, h, str );
	}
}

//
// DrawWindow()
//

event DrawWindow(GC gc)
{
	local float w, h, cury, x, y;
	local String str;
	local bool bContinueMsg;

	// Don't show if match has ended
	if (( DeusExMPGame(Player.DXGame) != None ) && DeusExMPGame(Player.DXGame).bClientNewMap )
		return;

   if (bKilled)
   {
      if ( bKilledSelf )
      {
         // Killed self
         gc.SetTextColor( RedColor );
         gc.SetFont(Font'FontMenuExtraLarge');
         str = KilledYourselfString;
         gc.GetTextExtent( 0, w, h, str );
         gc.DrawText( (width*0.5) - (w*0.5), msgY * height, w, h, str );
      }
      else if ( !bValidMethod )
      {
         // Unknown death
         gc.SetTextColor( RedColor );
         gc.SetFont(Font'FontMenuExtraLarge');
         str = WereKilledString;
         gc.GetTextExtent( 0, w, h, str );
         gc.DrawText( (width*0.5) - (w*0.5), msgY * height, w, h, str );
      }
      else
      {
         // Killed by another
         gc.SetTextColor( RedColor );
         gc.SetFont(Font'FontMenuExtraLarge');
         str = KilledByString $ 	killerName;
         gc.GetTextExtent( 0, w, h, str );
         cury = msgY * height;
         gc.DrawText( (width*0.5) - (w*0.5), cury, w, h, str );
         cury += h;
         str = killerMethod;
         gc.GetTextExtent( 0, w, h, str );
         gc.DrawText( (width*0.5) - (w*0.5), cury, w, h, str );
      }
		if ( Player.Level.Timeseconds > lockoutTime )
		{
			gc.SetTextColor( whiteColor );
			gc.SetFont(Font'FontMenuTitle');
			gc.GetTextExtent( 0, w, h, FireToContinueMsg );
			x = (width * 0.5) - (w * 0.5);
			y = height * 0.88;
			gc.DrawText( x, y, w, h, FireToContinueMsg );
			if ( !Player.bKillerProfile && Player.killProfile.bValid && (!Player.killProfile.bKilledSelf))
			{
				y += h;
				str = Detail1String $ curDetailKeyName $ Detail2String;
				gc.GetTextExtent( 0, w, h, str );
				x = (width * 0.5) - (w * 0.5);
				gc.DrawText( x, y, w, h, str );
			}
		}
   }
   else if ((bDisplayProgress))
   {
      gc.SetTextColor( BlueColor );
      gc.SetFont(Font'FontMenuExtraLarge');

      str = Player.ProgressMessage[0];
      gc.GetTextExtent( 0, w, h, str );
      cury = msgY * height;
      gc.DrawText( (width*0.5) - (w*0.5), cury, w, h, str );
      cury += h;

      str = Player.ProgressMessage[1];
      gc.GetTextExtent( 0, w, h, str );
      gc.DrawText( (width*0.5) - (w*0.5), cury, w, h, str );
   }
	if ( Player.bKillerProfile && Player.killProfile.bValid && (!Player.killProfile.bKilledSelf) )
		ShowKillerProfile( gc );

	Super.DrawWindow(gc);
}

//
// MouseButtonReleased()
//

event bool MouseButtonReleased(float pointX, float pointY, EInputKey button, int numClicks)
{
	if ( Player.Level.Timeseconds < lockoutTime )
		return True;

	if ( ( button == IK_LeftMouse ) || ( button == IK_RightMouse ) )
	{
		if ( !bDestroy )
		{
			bDestroy = True;
			player.Fire(0);
			root.PopWindow();
		}
	}
	return True;
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bKeyHandled;
	local String KeyName, Alias;

	bKeyHandled = False;

   if ((key == IK_F10) && (bDisplayProgress))
   {
      Player.ConsoleCommand("CANCEL");
      return True;
   }

	// Let them send chat messages
	KeyName = player.ConsoleCommand("KEYNAME "$key );
	Alias = 	player.ConsoleCommand( "KEYBINDING "$KeyName );

	if ( Alias ~= "Talk" )
		Player.Player.Console.Talk();
	else if ( Alias ~= "TeamTalk" )
		Player.Player.Console.TeamTalk();

	if ( Player.Level.Timeseconds < lockoutTime )
		return True;

	if ( Alias ~= "KillerProfile" )
	{
		Player.bKillerProfile = True;
		return True;
	}
	else
		return Super.VirtualKeyPressed(key, bRepeat);
}

defaultproperties
{
     KilledByString="You have been killed by "
     WereKilledString="You have been killed."
     KilledYourselfString="You killed yourself!"
     FireToContinueMsg="Press <Fire> to restart."
     ActiveAugsString="Active Augs: "
     WeaponString="Current Weapon: "
     RelevantSkillString="Relevant Skill: "
     LevelString="Skill Level: "
     FinalBlowString="The final blow of "
     ToTheString=" points of damage was delivered to your "
     RemHealthString="At the time of your death, "
     RemHealth2String=" had health: "
     RemEnergyString=" and "
     RemEnergy2String=" points of bio-energy left."
     HealthHeadString=" Head: "
     HealthMidString="  Mid-Section: "
     HealthLowString="  Legs: "
     StreakString=" now has a current streak of "
     Detail1String="Press <"
     Detail2String="> for details."
     KeyNotBoundString="Key Not Bound"
     VSString="VS"
     RedColor=(R=128)
     blueColor=(B=255)
     WhiteColor=(R=255,G=255,B=255)
     GreenColor=(G=255)
     BrightRedColor=(R=255)
}
