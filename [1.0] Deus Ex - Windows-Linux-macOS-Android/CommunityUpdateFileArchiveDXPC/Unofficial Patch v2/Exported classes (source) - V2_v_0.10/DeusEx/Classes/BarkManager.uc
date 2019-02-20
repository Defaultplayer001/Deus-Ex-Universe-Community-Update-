//=============================================================================
// BarkManager
//=============================================================================
class BarkManager extends Actor;

// A globally unique identifier.
struct BarkInfo
{
	var Scriptedpawn barkPawn;
	var Name         conName;
	var Float        barkDuration;
	var Float        barkTimer;
	var EBarkModes   barkMode;
	var Int          barkPriority;
	var Int          playingSoundId;
};

var BarkInfo currentBarks[8];
var BarkInfo recentBarks[32];

var Float perCharDelay;					
var Float minimumTextPause;
var Float barkModeSpacer;
var Int   maxCurrentBarks;
var Float maxBarkExpirationTimer;
var Int   maxAllowableRadius;
var Int   maxHiddenHeightDifference;
var Int   maxVisibleHeightDifference;

var transient DeusExRootWindow rootWindow;

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	UpdateCurrentBarks(deltaTime);
	UpdateRecentBarks(deltaTime);
}

// ----------------------------------------------------------------------
// StartBark()
// ----------------------------------------------------------------------

function bool StartBark(DeusExRootWindow newRoot, ScriptedPawn newBarkPawn, EBarkModes newBarkMode)
{
	local Name         conName;
	local Conversation con;
	local int          barkIndex;
	local Float        barkDuration;
	local bool         bBarkStarted;
	local ConPlayBark  conPlayBark;
	local String       conSpeechString;
	local ConSpeech    conSpeech;
	local Sound        speechAudio;
	local bool         bHaveSpeechAudio;
	local int          playingSoundID;

	bBarkStarted = False;

	// Store away the root window
	rootWindow = newRoot;

	// Don't even go any further if the actor is too far away 
	// from the player
	if (!CheckRadius(newBarkPawn))
		return False;

	// Now check the height difference
	if (!CheckHeightDifference(newBarkPawn))
		return False;

	// First attempt to find this conversation
	conName = BuildBarkName(newBarkPawn, newBarkMode);

	// Okay, we have the name of the bark, now attempt to find a 
	// conversation based on this name. 
	con = ConListItem(newBarkPawn.conListItems).FindConversationByName(conName);

	if (con != None)
	{
		barkIndex = GetAvailableCurrentBarkSlot(newBarkPawn, newBarkMode);

		// Abort if we don't get a valid barkIndex back
		if (barkIndex == -1)
			return False;

		// Make sure that another NPC isn't already playing this 
		// particular bark.
		if (IsBarkPlaying(conName))
			return False;

		// Now check to see if the same kind of bark has already been
		// played by this NPC within a certain range of time. 
		if (HasBarkTypePlayedRecently(newBarkPawn, newBarkMode))
			return False;

		// Summon a 'ConPlayBark' object, which will process
		// the conversation and play the bark.
		// Found an active conversation, so start it
		conPlayBark = Spawn(class'ConPlayBark');
		conPlayBark.SetConversation(con);
		
		conSpeech = conPlayBark.GetBarkSpeech();

		bHaveSpeechAudio = False;

		// Nuke conPlayBark
		conPlayBark.Destroy();

		// Play the audio (if we have audio)
		if ((conSpeech != None) && (conSpeech.soundID != -1))
		{
			speechAudio = con.GetSpeechAudio(conSpeech.soundID);

			if (speechAudio != None)
			{
				bHaveSpeechAudio = True;
				playingSoundID = newBarkPawn.PlaySound(speechAudio, SLOT_Talk,,,1024.0);
				barkDuration = con.GetSpeechLength(conSpeech.soundID);
			}
		}

		// If we don't have any audio, then calculate the timer based on the 
		// length of the speech text.

		if ((conSpeech != None) && (!bHaveSpeechAudio))
			barkDuration = FMax(Len(conSpeech.speech) * perCharDelay, minimumTextPause);

		// Show the speech if Subtitles are on
		if ((DeusExPlayer(owner) != None) && (DeusExPlayer(owner).bSubtitles) && (conSpeech != None) && (conSpeech.speech != ""))
		{
			rootWindow.hud.barkDisplay.AddBark(conSpeech.speech, barkDuration, newBarkPawn);
		}

		// Keep track fo the bark
		SetBarkInfo(barkIndex, conName, newBarkPawn, newBarkMode, barkDuration, playingSoundID);

		bBarkStarted = True;
	}

	return bBarkStarted;
}

// ----------------------------------------------------------------------
// IsBarkPlaying()
//
// Loops through all the active barks and checks to see if a bark
// with the same name is already playing.
// ----------------------------------------------------------------------

function bool IsBarkPlaying(Name conName)
{
	local int barkIndex;

	for (barkIndex=0; barkIndex < maxCurrentBarks; barkIndex++)
	{
		if (currentBarks[barkIndex].conName == conName)
		{
			return True;
		}
	}

	return False;
}

// ----------------------------------------------------------------------
// HasBarkTypePlayedRecently()
//
// Checks to see if a bark type has been played recently for 
// the given ScriptedPawn passed in.
// ----------------------------------------------------------------------

function bool HasBarkTypePlayedRecently(ScriptedPawn newBarkPawn, EBarkModes newBarkMode)
{
	local int barkIndex;

	for (barkIndex=0; barkIndex < arrayCount(recentBarks); barkIndex++)
	{
		if ((recentBarks[barkIndex].barkPawn == newBarkPawn) && (recentBarks[barkIndex].barkMode == newBarkMode))
		{
			return True;
		}
	}

	return False;
}

// ----------------------------------------------------------------------
// CheckRadius()
//
// Returns True if this conversation can be invoked given the 
// invoking actor and the distance between the actor and the player
// ----------------------------------------------------------------------

function bool CheckRadius(ScriptedPawn invokePawn)
{
	local Int  invokeRadius;
	local Int  dist;

	dist = VSize(DeusExPlayer(owner).Location - invokePawn.Location);

	return (dist <= maxAllowableRadius);
}

// ----------------------------------------------------------------------
// CheckHeightDifference()
// ----------------------------------------------------------------------

function bool CheckHeightDifference(ScriptedPawn invokePawn)
{
	// If the ScriptedPawn can see the player, than allow a taller height difference.
	// Otherwise make it pretty small (this is done especially to prevent the 
	// bark from playing through ceilings).

	if (DeusExPlayer(owner).FastTrace(invokePawn.Location))
		return DeusExPlayer(owner).CheckConversationHeightDifference(invokePawn, maxVisibleHeightDifference);
	else
		return DeusExPlayer(owner).CheckConversationHeightDifference(invokePawn, maxHiddenHeightDifference);

}

// ----------------------------------------------------------------------
// SetBarkInfo()
// ----------------------------------------------------------------------

function SetBarkInfo(
	int barkIndex, 
	Name conName,
	ScriptedPawn newBarkPawn, 
	EBarkModes newBarkMode, 
	Float barkDuration, 
	int playingSoundID)
{
	RemoveCurrentBark(barkIndex);

	currentBarks[barkIndex].conName        = conName;
	currentBarks[barkIndex].barkPawn       = newBarkPawn;
	currentBarks[barkIndex].barkDuration   = barkDuration;
	currentBarks[barkIndex].barkTimer      = 0.0;
	currentBarks[barkIndex].barkMode       = newBarkMode;
	currentBarks[barkIndex].playingSoundID = playingSoundID;

	// Determine the bark priority based on the mode
	currentBarks[barkIndex].barkPriority  = GetBarkPriority(newBarkMode);
}

// ----------------------------------------------------------------------
// GetAvailableCurrentBarkSlot()
//
// Loops through the bark slots and checks to see if any are avaialble
// or if any are in use by this NPC.  
// ----------------------------------------------------------------------

function int GetAvailableCurrentBarkSlot(
	ScriptedPawn newBarkPawn, 
	EBarkModes newBarkMode)
{
	local int barkIndex;
	local int emptyBarkIndex;
	local int barkPriority;

	barkPriority = GetBarkPriority(newBarkMode);

	emptyBarkIndex = -1;

	for (barkIndex=0; barkIndex < maxCurrentBarks; barkIndex++)
	{
		if (currentBarks[barkIndex].barkPawn == None)
		{
			emptyBarkIndex = barkIndex;
		}
		else
		{
			if (currentBarks[barkIndex].barkPawn == newBarkPawn)
			{
				// Only override if the new bark is a higher priority than
				// the previous bark.
				if (currentBarks[barkindex].barkPriority < barkPriority)
				{
					emptyBarkIndex = barkIndex;
					break;
				}
			}
			else if (currentBarks[barkIndex].barkMode == newBarkMode)
			{
				// Check to see if a similar bark has been started very close to
				// this one, in which case we want to not start this bark (so they
				// don't clobber one another)

				if (currentBarks[barkIndex].barkTimer < barkModeSpacer)
				{
					// abort
					break;
				}
			}
		}
	}

	return emptyBarkIndex;
}

// ----------------------------------------------------------------------
// GetAvailableRecentBarkSlot()
// ----------------------------------------------------------------------

function int GetAvailableRecentBarkSlot()
{
	local int barkIndex;
	local int emptyBarkIndex;
	local int oldestBarkIndex;
	local float expireTimer;

	emptyBarkIndex  = -1;
	oldestBarkIndex = -1;
	expireTimer     = maxBarkExpirationTimer;

	for (barkIndex=0; barkIndex < arrayCount(recentBarks); barkIndex++)
	{
		if (recentBarks[barkIndex].barkPawn == None)
		{
			emptyBarkIndex = barkIndex;
			break;
		}
		else if ((recentBarks[barkIndex].barkDuration - recentBarks[barkIndex].barkTimer) < expireTimer)
		{
			expireTimer     = recentBarks[barkIndex].barkDuration - recentBarks[barkIndex].barkTimer;
			oldestBarkIndex = barkIndex;
		}
	}

	// If we found an empty slot, use it.  Otherwise use the bark that will 
	// expire first

	if (emptyBarkIndex == -1)
		emptyBarkIndex = oldestBarkIndex;

	return emptyBarkIndex;
}

// ----------------------------------------------------------------------
// UpdateCurrentBarks()
// ----------------------------------------------------------------------

function UpdateCurrentBarks(Float deltaTime)
{
	local int barkIndex;

   // DEUS_EX AMSD In multiplayer, for now, kill barks.
   if (Level.NetMode != NM_Standalone)
      return;

	for (barkIndex=0; barkIndex < maxCurrentBarks; barkIndex++)
	{
		if (currentBarks[barkIndex].barkPawn != None)
		{
			currentBarks[barkIndex].barkTimer += deltaTime;

			if (currentBarks[barkIndex].barkTimer >= currentBarks[barkIndex].barkDuration)
				RemoveCurrentBark(barkIndex);
		}
	}
}

// ----------------------------------------------------------------------
// UpdateRecentBarks()
// ----------------------------------------------------------------------

function UpdateRecentBarks(Float deltaTime)
{
	local int barkIndex;

   // DEUS_EX AMSD In multiplayer, for now, kill barks.
   if (Level.NetMode != NM_Standalone)
      return;

   for (barkIndex=0; barkIndex < arrayCount(recentBarks); barkIndex++)
	{
		if (recentBarks[barkIndex].barkPawn != None)
		{
			recentBarks[barkIndex].barkTimer += deltaTime;

			if (recentBarks[barkIndex].barkTimer >= recentBarks[barkIndex].barkDuration)
				RemoveRecentBark(barkIndex);
		}
	}
}

// ----------------------------------------------------------------------
// RemoveCurrentBark()
// ----------------------------------------------------------------------

function RemoveCurrentBark(int barkIndex)
{
	// First add to the RecentBarkList
	MoveCurrentBarkToRecent(barkIndex);

	currentBarks[barkIndex].barkPawn       = None;
	currentBarks[barkIndex].conName        = '';
	currentBarks[barkIndex].barkDuration   = 0.0;
	currentBarks[barkIndex].barkTimer      = 0.0;
	currentBarks[barkIndex].barkMode       = BM_Idle;
	currentBarks[barkIndex].barkPriority   = 0;
	currentBarks[barkIndex].playingSoundID = 0;
}

// ----------------------------------------------------------------------
// MoveCurrentBarkToRecent()
// ----------------------------------------------------------------------

function MoveCurrentBarkToRecent(int currentBarkIndex)
{
	local int recentBarkIndex;

	recentBarkIndex = GetAvailableRecentBarkSlot();

	if (recentBarkIndex != -1)
	{
		recentBarks[recentBarkIndex].conName      = currentBarks[currentBarkIndex].conName;
		recentBarks[recentBarkIndex].barkPawn     = currentBarks[currentBarkIndex].barkPawn;
		recentBarks[recentBarkIndex].barkDuration = GetBarkTimeout(currentBarks[currentBarkIndex].barkMode);
		recentBarks[recentBarkIndex].barkTimer    = 0.0;
		recentBarks[recentBarkIndex].barkMode     = currentBarks[currentBarkIndex].barkMode;
		recentBarks[recentBarkIndex].barkPriority = currentBarks[currentBarkIndex].barkPriority;
	}
}

// ----------------------------------------------------------------------
// RemoveRecentBark()
// ----------------------------------------------------------------------

function RemoveRecentBark(int barkIndex)
{
	recentBarks[barkIndex].conName       = '';
	recentBarks[barkIndex].barkPawn      = None;
	recentBarks[barkIndex].barkDuration  = 0.0;
	recentBarks[barkIndex].barkTimer     = 0.0;
	recentBarks[barkIndex].barkMode      = BM_Idle;
	recentBarks[barkIndex].barkPriority  = 0;
}

// ----------------------------------------------------------------------
// GetBarkPriority()
// ----------------------------------------------------------------------

function int GetBarkPriority(EBarkModes barkMode)
{
	local int barkPriority;

	switch(barkMode)
	{
		case BM_Idle:
			barkPriority = 1;
			break;

		case BM_CriticalDamage:
			barkPriority = 5;
			break;

		case BM_AreaSecure:
			barkPriority = 2;
			break;

		case BM_TargetAcquired:
			barkPriority = 3;
			break;

		case BM_TargetLost:
			barkPriority = 2;
			break;

		case BM_GoingForAlarm:
			barkPriority = 4;
			break;

		case BM_OutOfAmmo:
			barkPriority = 2;
			break;

		case BM_Scanning:
			barkPriority = 2;
			break;

		case BM_Futz:
			barkPriority = 3;
			break;

		case BM_OnFire:
			barkPriority = 5;
			break;

		case BM_TearGas:
			barkPriority = 4;
			break;

		case BM_Gore:
			barkPriority = 3;
			break;

		case BM_Surprise:
			barkPriority = 5;
			break;

		case BM_PreAttackSearching:
			barkPriority = 4;
			break;

		case BM_PreAttackSighting:
			barkPriority = 5;
			break;

		case BM_PostAttackSearching:
			barkPriority = 4;
			break;

		case BM_SearchGiveUp:
			barkPriority = 2;
			break;

		case BM_AllianceHostile:
			barkPriority = 3;
			break;

		case BM_AllianceFriendly:
			barkPriority = 2;
			break;
	}

	return barkPriority;
}

// ----------------------------------------------------------------------
// GetBarkTimeout()
// ----------------------------------------------------------------------

function Float GetBarkTimeout(EBarkModes barkMode)
{
	local Float barkTimeout;

	switch(barkMode)
	{
		case BM_Futz:
			barkTimeout = 1.0;
			break;

		default:
			barkTimeout = 10.0;
			break;
	}

	return barkTimeout;
}

// ----------------------------------------------------------------------
// SetRootWindow()
// ----------------------------------------------------------------------

function SetRootWindow()
{
	local DeusExPlayer player;

	if (rootWindow == None)
	{
		player = DeusExPlayer(GetPlayerPawn());
				
		if (player != None)
			rootWindow = DeusExRootWindow(player.RootWindow);
	}
}

// ----------------------------------------------------------------------
// BuildBarkName()
// ----------------------------------------------------------------------

function Name BuildBarkName(ScriptedPawn newBarkPawn, EBarkModes newBarkMode)
{
	local String conStringName;

	SetRootWindow();

	// Use the "BarkBindName" unless it's blank, in which case
	// we'll fall back to the "BindName" used for normal 
	// conversations

	if (newBarkPawn.BarkBindName == "") 
		conStringName = newBarkPawn.BindName $ "_Bark";
	else
		conStringName = newBarkPawn.BarkBindName $ "_Bark";

	switch(newBarkMode)
	{
		case BM_Idle:
			conStringName = conStringName $ "Idle";
			break;

		case BM_CriticalDamage:
			conStringName = conStringName $ "CriticalDamage";
			break;

		case BM_AreaSecure:
			conStringName = conStringName $ "AreaSecure";
			break;

		case BM_TargetAcquired:
			conStringName = conStringName $ "TargetAcquired";
			break;

		case BM_TargetLost:
			conStringName = conStringName $ "TargetLost";
			break;

		case BM_GoingForAlarm:
			conStringName = conStringName $ "GoingForAlarm";
			break;

		case BM_OutOfAmmo:
			conStringName = conStringName $ "OutOfAmmo";
			break;

		case BM_Scanning:
			conStringName = conStringName $ "Scanning";
			break;

		case BM_Futz:
			conStringName = conStringName $ "Futz";
			break;

		case BM_OnFire:
			conStringName = conStringName $ "OnFire";
			break;

		case BM_TearGas:
			conStringName = conStringName $ "TearGas";
			break;

		case BM_Gore:
			conStringName = conStringName $ "Gore";
			break;

		case BM_Surprise:
			conStringName = conStringName $ "Surprise";
			break;

		case BM_PreAttackSearching:
			conStringName = conStringName $ "PreAttackSearching";
			break;

		case BM_PreAttackSighting:
			conStringName = conStringName $ "PreAttackSighting";
			break;

		case BM_PostAttackSearching:
			conStringName = conStringName $ "PostAttackSearching";
			break;

		case BM_SearchGiveUp:
			conStringName = conStringName $ "SearchGiveUp";
			break;

		case BM_AllianceHostile:
			conStringName = conStringName $ "AllianceHostile";
			break;

		case BM_AllianceFriendly:
			conStringName = conStringName $ "AllianceFriendly";
			break;
	}

	// Take the string name and convert it to a name
	return rootWindow.StringToName(conStringName);
}

// ----------------------------------------------------------------------
// ScriptedPawnDied()
// ----------------------------------------------------------------------

function ScriptedPawnDied(ScriptedPawn deadPawn)
{
	local int barkIndex;
	local DeusExPlayer player;

	// Loop through our active barks and see if one of them is 
	// owned by the dead dude.

	for (barkIndex=0; barkIndex < maxCurrentBarks; barkIndex++)
	{
		if (currentBarks[barkIndex].barkPawn == deadPawn)
		{
			player = DeusExPlayer(GetPlayerPawn());

			// Stop the sound and remove the bark
			if (player != None)
			{
				player.StopSound(currentBarks[barkIndex].playingSoundID);
				RemoveCurrentBark(barkIndex);
			}
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     perCharDelay=0.100000
     minimumTextPause=3.000000
     barkModeSpacer=1.000000
     maxCurrentBarks=4
     maxBarkExpirationTimer=30.000000
     maxAllowableRadius=1000
     maxHiddenHeightDifference=100
     maxVisibleHeightDifference=500
     bHidden=True
     bTravel=True
}
