//=============================================================================
// NetworkTerminal.
//=============================================================================
class NetworkTerminal extends DeusExBaseWindow
	abstract;

var ComputerUIWindow           winComputer;		// Currently active computer screen
var ComputerScreenHack         winHack;			// Ice Breaker Hack Window
var ShadowWindow               winHackShadow;
var ComputerScreenHackAccounts winHackAccounts; // Hack Accounts Window, used for email
var ShadowWindow               winHackAccountsShadow;
var ElectronicDevices          compOwner;		// what computer owns this window?

var Class<ComputerUIWindow> FirstScreen;	// First screen to push

// Hacking related variables
var float loginTime;			// time that the user logged in
var float detectionTime;		// total time a user may be logged on
var int   kickTimerID;			// timer ID for kicking the user off
var int   skillLevel;			// player's computer skill level (0-3)
var bool  bHacked;				// this computer has been hacked
var bool  bNoHack;				// this computer has been purposely not hacked
var bool  bUsesHackWindow;		// True if Hack Window created by default.

// Login related variables
var string userName;
var int    userIndex;

// Shadow stuff
var int shadowOffsetX;
var int shadowOffsetY;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetWindowAlignments(HALIGN_Full, VALIGN_Full);

	// Draw a black background for now
	SetBackgroundStyle(DSTY_Normal);
	SetBackground(Texture'Solid');
	SetTileColorRGB(0, 0, 0);

	SetMouseFocusMode(MFOCUS_Click);

	root.ShowHUD(False);

	CreateHackWindow();

	bTickEnabled = True;
}

// ----------------------------------------------------------------------
// DestroyWindow()
//
// Destroys the Window
// ----------------------------------------------------------------------

event DestroyWindow()
{
	if ((compOwner.IsA('Computers')) && (compOwner != None))
	{
      if (Player != Player.GetPlayerPawn())
      {
         log("==============>Player mismatch!!!!");
      }
		// Keep track of the last time this computer was hacked
      else if (player.ActiveComputer == CompOwner)
      {
         if (bHacked)
            player.SetComputerHackTime(Computers(compOwner),player.level.TimeSeconds, player.level.TimeSeconds);
         player.CloseComputerScreen(Computers(compOwner));
         player.ActiveComputer = None;
      }

		Computers(compOwner).termWindow = None;
	}
	else if (compOwner.IsA('ATM'))
	{
		// Keep track of the last time this computer was hacked
		if (bHacked)
			ATM(compOwner).lastHackTime = player.Level.TimeSeconds;

		ATM(compOwner).atmWindow = None;
	}

	// Show the HUD again
	root.ShowHUD(True);

	// Now finish destroy us.
	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// Tick()
//
// Checks to see if the player has died, and if so, gets us the 
// hell out of this screen!!
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	if ((player != None) && (player.IsInState('Dying')))
	{
		bTickEnabled = False;
		CloseScreen("EXIT");	
   }
   else
   {
      // DEUS_EX AMSD Put this in an else.  Don't do this if you are dead and have
      // closed the screen!
      // Update the hack bar detection time
      UpdateHackDetectionTime();
   }
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
//
// Used to Manually place the computer screen if the Hack window 
// is visible and the computer screen's position would overlap
// the hack window.
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	local float hackWidth, hackHeight;
	local float hackAccountsWidth, hackAccountsHeight;
	local float compWidth, compHeight;
	local float compX;

	// First look for the hack window.  If it's not visible, then
	// our work here is done!

	if (winHack != None)
	{
		winHack.QueryPreferredSize(hackWidth, hackHeight);

		// Shove in upper-right hand corner
		winHack.ConfigureChild(
			width - hackWidth, 0, 
			hackWidth, hackHeight);

		// Place shadow
		winHackShadow.ConfigureChild(
			width - hackWidth + winHack.backgroundPosX - shadowOffsetX, 
			winHack.backgroundPosY - shadowOffsetY, 
			winHack.backgroundWidth + (shadowOffsetX * 2), 
			winHack.backgroundHeight + (shadowOffsetY * 2));
	}

	// Check for the Hack Accounts window, which is displayed
	// underneath the Hack window.  Position under the Hack Window

	if (winHackAccounts != None)
	{
		winHackAccounts.QueryPreferredSize(hackAccountsWidth, hackAccountsHeight);
		winHackAccounts.ConfigureChild(
			width - hackAccountsWidth, hackHeight + 20, 
			hackAccountsWidth, hackAccountsHeight);

		// Place shadow
		winHackAccountsShadow.ConfigureChild(
			width - hackAccountsWidth + winHackAccounts.backgroundPosX - shadowOffsetX, 
			hackHeight + 20 + winHackAccounts.backgroundPosY - shadowOffsetY, 
			winHackAccounts.backgroundWidth + (shadowOffsetX * 2), 
			winHackAccounts.backgroundHeight + (shadowOffsetY * 2));
	}

	// Now check to see if we have a computer screen.  If so,
	// center it in relation to the hack window.  Don't force
	// position if the window has been dragged somewhere else
	// by the user.

	if ((winComputer != None) && (!winComputer.bWindowDragged))
	{
		winComputer.QueryPreferredSize(compWidth, compHeight);

		// Center the window, but move it left if the height of the 
		// hack window would infringe on the window (unless the 
		// "bAlwaysCenter" flag is set)

		if (((hackHeight + hackAccountsHeight + 20) > ((height / 2) - (compHeight / 2))) &&
		    (!winComputer.bAlwaysCenter))
		{
			compX = (width - hackWidth) / 2 - (compWidth / 2);
		}
		else
		{
			compX = (width / 2) - (compWidth / 2);
		}

		winComputer.ConfigureChild(
			compX, (height / 2) - (compHeight / 2), 
			compWidth, compHeight);
	}
}

// ----------------------------------------------------------------------------------
// VirtualKeyPressed
// ----------------------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local String KeyName, Alias;
	local bool bKeyHandled;

	bKeyHandled = False;

	if ( Player.Level.NetMode != NM_Standalone )
	{
		// Let them send chat messages while hacking
		KeyName = player.ConsoleCommand("KEYNAME "$key );
		Alias = 	player.ConsoleCommand( "KEYBINDING "$KeyName );

		if ( Alias ~= "Talk" )
		{
			log("===>trying to talk..." );
			Player.Player.Console.Talk();
			bKeyHandled = True;
		}
		else if ( Alias ~= "TeamTalk" )
		{
			log("===>trying to teamtalk..." );
			Player.Player.Console.TeamTalk();
			bKeyHandled = True;
		}
	}

	if ( bKeyHandled )
		return True;
	else
		return Super.VirtualKeyPressed(key, bRepeat);
}


// ----------------------------------------------------------------------
// ShowFirstScreen()
// ----------------------------------------------------------------------

function ShowFirstScreen()
{
	ShowScreen(FirstScreen);
}

// ----------------------------------------------------------------------
// ShowScreen()
// ----------------------------------------------------------------------

function ShowScreen(Class<ComputerUIWindow> newScreen)
{
	// First close any existing screen
	if (winComputer != None)
	{
		winComputer.Destroy();
		winComputer = None;
	}

	// Now invoke the new screen
	if (newScreen != None)
	{
		winComputer = ComputerUIWindow(NewChild(newScreen));
		winComputer.SetWindowAlignments(HALIGN_Center, VALIGN_Center);
		winComputer.SetNetworkTerminal(Self);	
		winComputer.SetCompOwner(compOwner);
		winComputer.Lower();
	}
}

// ----------------------------------------------------------------------
// CloseScreen()
// ----------------------------------------------------------------------

function CloseScreen(String action)
{
	// First destroy the current screen
	if (winComputer != None)
	{
		winComputer.Destroy();
		winComputer = None;
	}

	// Based on the action, proceed!
	
	if (action == "EXIT")
	{
		if (Computers(compOwner) != None)   
			player.CloseComputerScreen(Computers(compOwner));
		root.PopWindow();
		return;
	}

	// If the user is logging in and bypassing the Hack screen,
	// then destroy the Hack window

	if ((action == "LOGIN") && (winHack != None) && (!bHacked))
	{
		CloseHackWindow();
		bNoHack = True;
	}
}

// ----------------------------------------------------------------------
// CloseHackWindow()
// ----------------------------------------------------------------------

function CloseHackWindow()
{
	if (winHack != None)
	{
		winHack.Destroy();
		winHack = None;

		winHackShadow.Destroy();
		winHackShadow = None;
	}
}

// ----------------------------------------------------------------------
// ForceCloseScreen()
// ----------------------------------------------------------------------

function ForceCloseScreen()
{
	// If a screen is active, tell it to exit
	if (winComputer != None)
		winComputer.CloseScreen(winComputer.escapeAction);
}

// ----------------------------------------------------------------------
// CreateHackWindow()
// ----------------------------------------------------------------------

function CreateHackWindow()
{
	local Float hackTime;
	local Float skillLevelValue;

	skillLevelValue = player.SkillSystem.GetSkillLevelValue(class'SkillComputer');
	skillLevel      = player.SkillSystem.GetSkillLevel(class'SkillComputer');

	// Check to see if the player is skilled in Hacking before 
	// creating the window
	if ((skillLevel > 0) && (bUsesHackWindow))
	{
		// Base the detection and hack time on the skill level
		hackTime       = detectionTime / (skillLevelValue * 1.5);
		detectionTime *= skillLevelValue;

		// First create the shadow window
		winHackShadow = ShadowWindow(NewChild(Class'ShadowWindow'));

		winHack = ComputerScreenHack(NewChild(Class'ComputerScreenHack'));
		winHack.SetNetworkTerminal(Self);
		winHack.SetDetectionTime(detectionTime, hackTime);
	}
}

// ----------------------------------------------------------------------
// CreateHackAccountsWindow()
//
// Create the window used to hack email accounts, but only create it if
// the player hacked into the computer *and* there's more than one 
// account to display
// ----------------------------------------------------------------------

function CreateHackAccountsWindow()
{
	if ((bHacked) && (winHackAccounts == None) && (Computers(compOwner).NumUsers() > 1))
	{
		// First create the shadow window
		winHackAccountsShadow = ShadowWindow(NewChild(Class'ShadowWindow'));

		winHackAccounts = ComputerScreenHackAccounts(NewChild(Class'ComputerScreenHackAccounts'));
		winHackAccounts.SetNetworkTerminal(Self);
		winHackAccounts.SetCompOwner(compOwner);
		winHackAccounts.AskParentForReconfigure();
	}
}

// ----------------------------------------------------------------------
// CloseHackAccountsWindow()
// ----------------------------------------------------------------------

function CloseHackAccountsWindow()
{
	if (winHackAccounts != None)
	{
		winHackAccounts.Destroy();
		winHackAccounts = None;

		winHackAccountsShadow.Destroy();
		winHackAccountsShadow = None;
	}
}

// ----------------------------------------------------------------------
// SetHackButtonToReturn()
// ----------------------------------------------------------------------

function SetHackButtonToReturn()
{
	if ((bHacked) && (winHack != None))
		winHack.SetHackButtonToReturn();
}

// ----------------------------------------------------------------------
// SetCompOwner()
// ----------------------------------------------------------------------

function SetCompOwner(ElectronicDevices newCompOwner)
{
	compOwner = newCompOwner;

	if (winComputer != None)
		winComputer.SetCompOwner(compOwner);

	// Update the hack bar detection time
	UpdateHackDetectionTime();
}

// ----------------------------------------------------------------------
// UpdateHackDetectionTime()
// ----------------------------------------------------------------------

function UpdateHackDetectionTime()
{
	local Float diff;
	local Float detectionTime;

	// If the hack window is active, then we need to update 
	// the detection time
	if ((winHack != None) && (!winhack.bHacking) && (compOwner != None) && (!bHacked))
	{
		detectionTime = winHack.GetSaveDetectionTime();

		if (compOwner.IsA('Computers')) 
      {
			diff = player.Level.TimeSeconds - Computers(compOwner).lastHackTime;
      }
		else
			diff = player.Level.TimeSeconds - ATM(compOwner).lastHackTime;

		if (diff < detectionTime)
			winHack.UpdateDetectionTime(diff + 0.5);
	}
}

// ----------------------------------------------------------------------
// SetLoginInfo()
// ----------------------------------------------------------------------

function SetLoginInfo(String newUserName, Int newUserIndex)
{
	userName  = newUserName;
	userIndex = newUserIndex;
}

// ----------------------------------------------------------------------
// ChangeAccount()
// ----------------------------------------------------------------------

function ChangeAccount(int newUserIndex)
{
	userIndex = newUserIndex;

	if (compOwner != None)
		userName  = Computers(compOwner).GetUserName(userIndex);

	// Notify the computer window
	if (winComputer != None)
		winComputer.ChangeAccount();
}

// ----------------------------------------------------------------------
// GetUserName()
// ----------------------------------------------------------------------

function String GetUserName()
{
	return userName;
}

// ----------------------------------------------------------------------
// GetUserIndex()
// ----------------------------------------------------------------------

function int GetUserIndex()
{
	return userIndex;
}

// ----------------------------------------------------------------------
// SetSkillLevel()
// ----------------------------------------------------------------------

function SetSkillLevel(int newSkillLevel)
{
	skillLevel = newSkillLevel;
}

// ----------------------------------------------------------------------
// GetSkillLevel()
// ----------------------------------------------------------------------

function int GetSkillLevel()
{
	return skillLevel;
}

// ----------------------------------------------------------------------
// ComputerHacked()
//
// Computer was hacked, allow user to login
// ----------------------------------------------------------------------

function ComputerHacked()
{
	bHacked = True;

	// Use the first login
	userIndex = 0;
	
	if (compOwner.IsA('Computers'))
		userName  = Computers(compOwner).GetUserName(userIndex);
	
	CloseScreen("LOGIN");
}

// ----------------------------------------------------------------------
// HackDetected()
// ----------------------------------------------------------------------

function HackDetected(optional bool bDamageOnly)
{
	if (compOwner.IsA('Computers'))
	{
		Computers(compOwner).bLockedOut = True;
		Computers(compOwner).lockoutTime = player.Level.TimeSeconds;
	}
	else
	{
		ATM(compOwner).bLockedOut = True;
		ATM(compOwner).lockoutTime = player.Level.TimeSeconds;
	}

	// Shock the crap out of the player (drain BE and play a sound)
	// Highly skilled players take less damage
   // DEUS_EX AMSD In multiplayer, don't damage.  
   if (Player.Level.NetMode == NM_Standalone)
   {
      player.TakeDamage(200 - 50 * skillLevel, None, vect(0,0,0), vect(0,0,0), 'EMP');	
      PlaySound(sound'ProdFire');
   }
   else
   {
      player.PunishDetection(200 - 50 * skillLevel);
      PlaySound(sound'ProdFire');
   }

	if (!bDamageOnly)
		CloseScreen("EXIT");
}

// ----------------------------------------------------------------------
// AreSpecialOptionsAvailable()
// ----------------------------------------------------------------------

function bool AreSpecialOptionsAvailable(optional bool bCheckActivated)
{
	local int i;
	local bool bOK;

	bOK = False;
	for (i=0; i<ArrayCount(Computers(compOwner).specialOptions); i++)
	{
		if (Computers(compOwner).specialOptions[i].Text != "")
		{
			if ((Computers(compOwner).specialOptions[i].userName == "") || (Caps(Computers(compOwner).specialOptions[i].userName) == userName))
			{
				// Also check if the "bCheckActivated" bool is set, in which case we also 
				// want to make sure the item hasn't already been triggered.

				if (!((bCheckActivated) && (Computers(compOwner).specialOptions[i].bAlreadyTriggered)))
				{
					bOK = True;
					break;
				}
			}
		}
	}

	return bOK;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     detectionTime=15.000000
     kickTimerID=-1
     bUsesHackWindow=True
     shadowOffsetX=15
     shadowOffsetY=15
     ScreenType=ST_Computer
}
