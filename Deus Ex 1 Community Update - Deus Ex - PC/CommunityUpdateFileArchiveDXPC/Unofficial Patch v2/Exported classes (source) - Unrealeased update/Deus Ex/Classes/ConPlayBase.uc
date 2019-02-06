//=============================================================================
// ConPlayBase
//=============================================================================
class ConPlayBase expands Actor;

var enum EPlayModes
{
	PM_Passive,
	PM_Active
} playMode;

var enum EDisplayMode
{
	DM_FirstPerson,
	DM_ThirdPerson, 
	DM_Bark
} displayMode;

// Possible Event Actions
// (from ConObject.uc)

enum EEventAction
{
    EA_NextEvent,
	EA_JumpToLabel,
	EA_JumpToConversation,
	EA_WaitForInput,
	EA_WaitForSpeech,
	EA_WaitForText,
	EA_PlayAnim,
	EA_ConTurnActors,
	EA_End
};

// Various and sundry Event Types
enum EEventType
{
	ET_Speech,					// 0
	ET_Choice,					// 1
	ET_SetFlag,					// 2
	ET_CheckFlag,				// 3
	ET_CheckObject,				// 4
	ET_TransferObject,			// 5
	ET_MoveCamera,				// 6	
	ET_Animation,				// 7
	ET_Trade,					// 8
	ET_Jump,					// 9
	ET_Random,					// 10
	ET_Trigger,					// 11
	ET_AddGoal,					// 12
	ET_AddNote,					// 13
	ET_AddSkillPoints,			// 14
	ET_AddCredits,				// 15
	ET_CheckPersona,			// 16
	ET_Comment,					// 17
	ET_End						// 18
};

enum ESpeechFonts
{
	SF_Normal,
	SF_Computer
};

// ----------------------------------------------------------------------
// EFlagType - Flag types

enum EFlagType
{
	FLAG_Bool,
	FLAG_Byte,
	FLAG_Int,
	FLAG_Float,
	FLAG_Name,
	FLAG_Vector,
	FLAG_Rotator,
};

enum EConditions
{
	EC_Less,
	EC_LessEqual,
	EC_Equal,
	EC_GreaterEqual,
	EC_Greater
};

// Event Persona types
enum EPersonaTypes
{
	EP_Credits,
	EP_Health,
	EP_SkillPoints
};

var transient DeusExRootWindow rootWindow;		// Scott is that black stuff in the oven
var Conversation con;					// Conversation we're working with
var Conversation startCon;				// Conversation that was -initially- started
var DeusExPlayer player;				// Player Pawn
var Actor invokeActor;					// Actor who invoked conversation
var ConEvent	 currentEvent;
var ConEvent     lastEvent;				// Last event
var Actor        lastActor;				// Last Speaking Actor
var Int          playingSoundId;		// Currently playing speech
var Int			 lastSpeechTextLength;
var Int          missionNumber;
var String		 missionLocation;
var ConHistory	 history;				// Saved History for this convo
var Actor        startActor;			// Actor who triggered convo
var int          saveRadiusDistance;
var int          initialRadius;
var bool         bConversationStarted;
var bool         bForcePlay;

var transient ConWindowActive conWinThird;		// First-Person Conversation Window

// Used to keep track of Actors involved in this conversation
var Actor ConActors[10];

// Used to keep track of Actors that were bound to this conversation,
// in the event an actor is destroyed before the conversation is over,
// we abort the conversation to prevent references to destroyed objects
var Actor ConActorsBound[10];

var int conActorCount;

// ----------------------------------------------------------------------
// SetStartActor()
// ----------------------------------------------------------------------

function SetStartActor(Actor newStartActor)
{
	startActor = newStartActor;
}

// ----------------------------------------------------------------------
// SetConversation()
//
// Sets the conversation to be played.
// ----------------------------------------------------------------------

function bool SetConversation( Conversation newCon )
{
	startCon = newCon;
	con      = newCon;

	saveRadiusDistance = con.radiusDistance;

	return True;
}

// ----------------------------------------------------------------------
// SetInitialRadius()
// ----------------------------------------------------------------------

function SetInitialRadius(int newInitialRadius)
{
	initialRadius = newInitialRadius;
}

// ----------------------------------------------------------------------
// StartConversation()
//
// Starts a conversation.  
//
// 1.  Initializes the Windowing system
// 2.  Gets a pointer to the first Event
// 3.  Jumps into the 'PlayEvent' state
// ----------------------------------------------------------------------

function Bool StartConversation(DeusExPlayer newPlayer, optional Actor newInvokeActor, optional bool bForcePlay)
{
	local DeusExLevelInfo aDeusExLevelInfo;

	// Make sure we have a conversation and a valid Player
	if (( con == None ) || ( newPlayer == None ))
		return False;

	// Make sure the player isn't, uhhrr, you know, DEAD!
	if (newPlayer.IsInState('Dying'))
		return False;

	// Keep a pointer to the player and invoking actor
	player      = newPlayer;

	if (newInvokeActor != None) 
		invokeActor = newInvokeActor;
	else
		invokeActor = startActor;

	// Bind the conversation events
	con.BindEvents(ConActorsBound, invokeActor);

	// Check to see if the conversation has multiple owners, in which case we 
	// want to rebind all the events with this owner.  This allows conversations
	// to be shared by more than one owner.
	if ((con.ownerRefCount > 1) && (invokeActor != None))
		con.BindActorEvents(invokeActor);

	// Check to see if all the actors are on the level.
	// Don't check this for InfoLink conversations, since oftentimes
	// the person speaking via InfoLink *won't* be on the map.
	//
	// If a person speaking on the conversation can't be found 
	// (say, they were ruthlessly MURDERED!) then abort.
	//
	// Hi Ken!

	if ((!bForcePlay) && (!con.bDataLinkCon) && (!con.CheckActors()))
		return False;

	// Now check to make sure that all the actors are a reasonable distance
	// from one another (excluding the player)
	if ((!bForcePlay) && (!con.CheckActorDistances(player)))
		return False;

	// Save the mission number and location
	foreach AllActors(class'DeusExLevelInfo', aDeusExLevelInfo)
	{
		if (aDeusExLevelInfo != None)
		{
			missionNumber   = aDeusExLevelInfo.missionNumber;
			missionLocation = aDeusExLevelInfo.MissionLocation;
			break;
		}
	}

	// Save the conversation radius
	saveRadiusDistance = con.radiusDistance;

	// Initialize Windowing System
	rootWindow = DeusExRootWindow(player.rootWindow);

	bConversationStarted = True;

	return True;
}

// ----------------------------------------------------------------------
// TerminateConversation()
// ----------------------------------------------------------------------

function TerminateConversation(optional bool bContinueSpeech, optional bool bNoPlayedFlag)
{
	// Make sure there's no audio playing
	if (!bContinueSpeech)
		player.StopSound(playingSoundID);

	// Set the played flag
	if (!bNoPlayedFlag)
		SetPlayedFlag();

	// Clear the bound event actors
	con.ClearBindEvents();

	// Reset the conversation radious
	con.radiusDistance = saveRadiusDistance;

	// Notify the conversation participants to go about their
	// business.
	EndConActorStates();

	con          = None;
	currentEvent = None;
	lastEvent    = None;
}

// ----------------------------------------------------------------------
// ConversationStarted()
// ----------------------------------------------------------------------

function bool ConversationStarted()
{
	return bConversationStarted;
}

// ----------------------------------------------------------------------
// SetOriginalRadius()
// ----------------------------------------------------------------------

function SetOriginalRadius(int newOriginalDistance)
{
	saveRadiusDistance = newOriginalDistance;
}

// ----------------------------------------------------------------------
// CanInterrupt()
// ----------------------------------------------------------------------

function bool CanInterrupt()
{
	if (con != None)
		return !con.bCannotBeInterrupted;
	else
		return False;
}

// ----------------------------------------------------------------------
// InterruptConversation()
// ----------------------------------------------------------------------

function InterruptConversation()
{
	SetInterruptedFlag();	
}

// ----------------------------------------------------------------------
// SetPlayedFlag()
// ----------------------------------------------------------------------

function SetPlayedFlag()
{
	local Name flagName;

	if (con != None)
	{
		// Make a note of when this conversation ended
		con.lastPlayedTime = player.Level.TimeSeconds;

		flagName = player.rootWindow.StringToName( con.conName $ "_Played" );

		// Only set the Played flag if it doesn't already exist 
		// (some conversations set this intentionally with a longer expiration
		// date so they can be relied up on in future missions)

		if (!player.flagBase.GetBool(flagName))
		{
			// Add a flag noting that we've finished this conversation.  
			player.flagBase.SetBool(flagName, True);
		}

		// If this was a third-person convo, keep track of when the conversation
		// ended and who it was with (this is used to prevent radius convos
		// from playing immediately after letterbox convos).
		//
		// If this was a first-person convo, keep track of the owner and 
		// play time so we can prevent multiple radius-induced conversations
		// from playing without a pause (we don't want them to run into 
		// each other).

		if (con.bFirstPerson)
		{
			player.lastFirstPersonConvoActor = invokeActor;
			player.lastFirstPersonConvoTime  = con.lastPlayedTime;
		}
		else
		{
			player.lastThirdPersonConvoActor = invokeActor;
			player.lastThirdPersonConvoTime  = con.lastPlayedTime;
		}

	}
}

// ----------------------------------------------------------------------
// SetInterruptedFlag()
// ----------------------------------------------------------------------

function SetInterruptedFlag()
{
	local Name flagName;

	if (con != None)
	{
		flagName = player.rootWindow.StringToName( con.conName $ "_Interrupted" );

		// Add a flag noting that we've finished this conversation.  

		player.flagBase.SetBool(flagName, True);
	}
}

// ----------------------------------------------------------------------
// StopSpeech()
// ----------------------------------------------------------------------

function StopSpeech()
{
	player.StopSound(playingSoundID);
}

// ----------------------------------------------------------------------
// ConvertSpaces()
// ----------------------------------------------------------------------

function String ConvertSpaces(coerce String inString)
{
	local int index;
	local String outString;

	outString = "";

	for(index=0; index<Len(inString); index++)
	{
		if (Mid(inString, index, 1) == " ")
			outString = outString $ "_";
		else
			outString = outString $ Mid(inString, index, 1); 
	}

	return outString;
}

// ----------------------------------------------------------------------
// GetNextEvent()
//
// Returns the next event
// ----------------------------------------------------------------------

function ConEvent GetNextEvent()
{
	return currentEvent.nextEvent;
}

// ----------------------------------------------------------------------
// SetupEventSetFlag()
// ----------------------------------------------------------------------

function EEventAction SetupEventSetFlag( ConEventSetFlag event, out String nextLabel )
{
	local ConFlagRef currentRef;

	// Just follow the chain of flag references and set the flags to
	// the proper value!

	currentRef = event.flagRef;

	while( currentRef != None )
	{
		player.flagBase.SetBool(currentRef.flagName, currentRef.value);
		player.flagBase.SetExpiration(currentRef.flagName, FLAG_Bool, currentRef.expiration); 

		currentRef = currentRef.nextFlagRef;

	}

	nextLabel = "";
	return EA_NextEvent;
}

// ----------------------------------------------------------------------
// SetupEventCheckFlag()
// ----------------------------------------------------------------------

function EEventAction SetupEventCheckFlag( ConEventCheckFlag event, out String nextLabel )
{
	local ConFlagRef currentRef;
	local EEventAction action;

	// Default values if we actually make it all the way 
	// through the while loop below.

	nextLabel = event.setLabel;
	action = EA_JumpToLabel;
	
	// Loop through our list of FlagRef's, checking the value of each.
	// If we hit a bad match, then we'll stop right away since there's
	// no point of continuing.

	currentRef = event.flagRef;

	while( currentRef != None )
	{
		if ( player.flagBase.GetBool(currentRef.flagName) != currentRef.value )
		{
			nextLabel = "";
			action = EA_NextEvent;
			break;
		}
		currentRef = currentRef.nextFlagRef;
	}
	
	return action;
}

// ----------------------------------------------------------------------
// SetupEventTrade()
// ----------------------------------------------------------------------

function EEventAction SetupEventTrade( ConEventTrade event, out String nextLabel )
{
	nextLabel = "";
	return EA_NextEvent;
}

// ----------------------------------------------------------------------
// SetupEventCheckObject()
//
// Checks to see if the player has the given object.  If so, then we'll
// just fall through and continue running code.  Otherwise we'll jump
// to the supplied label.
// ----------------------------------------------------------------------

function EEventAction SetupEventCheckObject( ConEventCheckObject event, out String nextLabel )
{
	local EEventAction nextAction;
	local Name keyName;
	local bool bHasObject;
	local class<Inventory> checkthing;
	local string seekname;

	// Okay this is some HackyHack stuff here.  We want the ability to 
	// check if the player has a particular nanokey.  Sooooooo.
	
	if ((event.checkObject == None) && (Left(event.objectName, 3) == "NK_"))
	{
		// Look for key
		keyName    = player.rootWindow.StringToName(Right(event.ObjectName, Len(event.ObjectName) - 3));
		bHasObject = ((player.KeyRing != None) && (player.KeyRing.HasKey(keyName)));
	}
	else //== Y|y: Add suppport for custom transfers from non-DeusEx classes.  Code copy-pasted courtesy of DDL
	{
		//look for a fullstop, if not there, add deusex. to the beginning
		if(instr(event.objectname, ".") == -1)
			Seekname = "DeusEx." $ event.objectname;
		else
			Seekname = event.objectname;

		checkthing = class<inventory>(DynamicLoadObject(seekname, class'Class')); //grabs a class incidence from the name

		bHasObject = (player.FindInventoryType(checkthing) != None);
	}

	// Now branch appropriately

	if (bHasObject)
	{
		nextAction = EA_NextEvent;
		nextLabel  = "";
	}
	else
	{
		nextAction = EA_JumpToLabel;
		nextLabel  = event.failLabel;
	}

	return nextAction;
}

// ----------------------------------------------------------------------
// SetupEventTransferObject()
//
// Gives a Pawn the specified object.  The object will be created out of
// thin air (spawned) if there's no "fromActor", otherwise it's 
// transfered from one pawn to another.
//
// We now allow this to work without the From actor, which can happen
// in InfoLinks, since the FromActor may not even be on the map.
// This is useful for tranferring DataVaultImages.
// ----------------------------------------------------------------------

function EEventAction SetupEventTransferObject( ConEventTransferObject event, out String nextLabel )
{
	local EEventAction nextAction;
	local Inventory invItemFrom;
	local Inventory invItemTo;
	local ammo AmmoType;
	local bool bSpawnedItem;
	local bool bSplitItem;
	local int itemsTransferred;
	local class<Inventory> checkthing;
	local string seekname;

/*
log("SetupEventTransferObject()------------------------------------------");
log("  event = " $ event);
log("  event.giveObject = " $ event.giveObject);
log("  event.fromActor  = " $ event.fromActor );
log("  event.toActor    = " $ event.toActor );
*/
	itemsTransferred = 1;

	if ( event.failLabel != "" )
	{
		nextAction = EA_JumpToLabel;
		nextLabel  = event.failLabel;
	}
	else
	{
		nextAction = EA_NextEvent;
		nextLabel = "";
	}

	// First verify that the receiver exists!
	if (event.toActor == None)
	{
		log("SetupEventTransferObject:  WARNING!  toActor does not exist!");
		log("  Conversation = " $ con.conName);
		return nextAction;
	}

	//== Y|y: More support for custom transfers from non-DeusEx classes.  Code mostly by DDL

	//look for a fullstop, if not there, add deusex. to the beginning
	if(instr(event.objectname, ".") == -1)
		seekname = "DeusEx." $ event.objectname;
	else
		seekname = event.objectname;

	checkthing = class<inventory>(DynamicLoadObject(seekname, class'Class')); //grabs a class incidence from the name

	if(checkthing == None) //oh noes!
	{
		log("SetupEventTransferObject(): Well that worked like crap.  Whatever " $ seekname $ " is, I can't load it up.");

		//== Y|y: At this point we have nothing to lose, might as well try
		checkthing = class<inventory>(DynamicLoadObject(event.objectname, class'Class', True));

		if(checkthing == None)
		{
//			return nextAction; //assume fail, essentially
			//== Y|y: Rather than giving up, let's just assume the old giveObject was the right choice
			checkthing = event.giveObject;
		}
		else
			log("SetupEventTransferObject(): Trying to load up " $ event.objectname $ " works though.  Consider recoding your conversation.");
	}

	// First, check to see if the giver actually has the object.  If not, then we'll
	// fabricate it out of thin air.  (this is useful when we want to allow
	// repeat visits to the same NPC so the player can restock on items in some
	// scenarios).
	//
	// Also check to see if the item already exists in the recipient's inventory

	if (event.fromActor != None)
		invItemFrom = Pawn(event.fromActor).FindInventoryType(checkthing);

	invItemTo   = Pawn(event.toActor).FindInventoryType(checkthing);

//log("  invItemFrom = " $ invItemFrom);
//log("  invItemTo   = " $ invItemTo);

	// If the player is doing the giving, make sure we remove it from 
	// the object belt.

	// If the giver doesn't have the item then we must spawn a copy of it
	if (invItemFrom == None)
	{
		invItemFrom = Spawn(checkthing); //== Y|y: Use the new variable
		bSpawnedItem = True;
	}

	// If we're giving this item to the player and he does NOT yet have it,
	// then make sure there's enough room in his inventory for the 
	// object!

	if ((invItemTo == None) &&
		(DeusExPlayer(event.toActor) != None) && 
	    (DeusExPlayer(event.toActor).FindInventorySlot(invItemFrom, True) == False))
	{
		// First destroy the object if we previously Spawned it
		if (bSpawnedItem)
			invItemFrom.Destroy();
				
		return nextAction;
	}

	// Okay, there's enough room in the player's inventory or we're not 
	// transferring to the player in which case it doesn't matter.
	//
	// Now check if the recipient already has the item.  If so, we are just
	// going to give it to him, with a few special cases.  Otherwise we
	// need to spawn a new object.

	if (invItemTo != None)
	{
		// Check if this item was in the player's hand, and if so, remove it
		RemoveItemFromPlayer(invItemFrom);

		// If this is ammo, then we want to just increment the ammo count
		// instead of adding another ammo to the inventory

		if (invItemTo.IsA('Ammo'))
		{
			// If this is Ammo and the player already has it, make sure the player isn't
			// already full of this ammo type! (UGH!)

			//== Y|y: And now some trickery, for math purposes...
			itemsTransferred = Ammo(invItemTo).AmmoAmount;
			if (!Ammo(invItemTo).AddAmmo(Ammo(invItemFrom).AmmoAmount))
			{
				invItemFrom.Destroy();
				return nextAction;
			}

			itemsTransferred = Ammo(invItemTo).AmmoAmount - itemsTransferred; //== Y|y: Subtract what we had from what we have and we will get the correct amount transferred

			if(itemsTransferred <= 0) itemsTransferred = Ammo(invItemFrom).AmmoAmount; //== Y|y: ...but just in case....

			// Destroy our From item
			invItemFrom.Destroy();		
		}

		// Pawn cannot have multiple weapons, but we do want to give the 
		// player any ammo from the weapon
		else if ((invItemTo.IsA('Weapon')) && (DeusExPlayer(event.ToActor) != None))
		{

			AmmoType = Ammo(DeusExPlayer(event.ToActor).FindInventoryType(Weapon(invItemTo).AmmoName));

			if ( AmmoType != None )
			{
				// Special case for Grenades and LAMs.  Blah.
				if ((AmmoType.IsA('AmmoEMPGrenade')) || 
				    (AmmoType.IsA('AmmoGasGrenade')) || 
					(AmmoType.IsA('AmmoNanoVirusGrenade')) ||
					(AmmoType.IsA('AmmoLAM')))
				{
					if (!AmmoType.AddAmmo(event.TransferCount))
					{
						invItemFrom.Destroy();
						return nextAction;
					}

					//== Y|y: Display the amount of ammo transferred properly
					itemsTransferred = event.TransferCount;
				}
				else
				{
					if (!AmmoType.AddAmmo(Weapon(invItemTo).PickUpAmmoCount))
					{
						invItemFrom.Destroy();
						return nextAction;
					}

					event.TransferCount = Weapon(invItemTo).PickUpAmmoCount;
					itemsTransferred = event.TransferCount;
				}

				if (event.ToActor.IsA('DeusExPlayer'))
					DeusExPlayer(event.ToActor).UpdateAmmoBeltText(AmmoType);

				// Tell the player he just received some ammo!
				invItemTo = AmmoType;
			}
			else
			{
				// Don't want to show this as being received in a convo
				invItemTo = None;
			}

			// Destroy our From item
			invItemFrom.Destroy();
			invItemFrom = None;
		}

		// Otherwise check to see if we need to transfer more than 
		// one of the given item
		else
		{
			itemsTransferred = AddTransferCount(invItemFrom, invItemTo, event, Pawn(event.toActor), False);

			// If no items were transferred, then the player's inventory is full or 
			// no more of these items can be stacked, so abort.
			if (itemsTransferred == 0)
				return nextAction;

			// Now destroy the originating object (which we either spawned
			// or is sitting in the giver's inventory), but check to see if this 
			// item still has any copies left first

			if (((invItemFrom.IsA('DeusExPickup')) && (DeusExPickup(invItemFrom).bCanHaveMultipleCopies) && (DeusExPickup(invItemFrom).NumCopies <= 0)) ||
			   ((invItemFrom.IsA('DeusExPickup')) && (!DeusExPickup(invItemFrom).bCanHaveMultipleCopies)) ||
			   (!invItemFrom.IsA('DeusExPickup')))
			{
				invItemFrom.Destroy();
				invItemFrom = None;
			}
		}
	}

	// Okay, recipient does *NOT* have the item, so it must be give
	// to that pawn and the original destroyed
	else
	{
		// If the item being given is a stackable item and the 
		// recipient isn't receiving *ALL* the copies, then we 
		// need to spawn a *NEW* copy and give that to the recipient.
		// Otherwise just do a "SpawnCopy", which transfers ownership
		// of the object to the new owner.

		if ((invItemFrom.IsA('DeusExPickup')) && (DeusExPickup(invItemFrom).bCanHaveMultipleCopies) && 
		    (DeusExPickup(invItemFrom).NumCopies > event.transferCount))
		{
			itemsTransferred = event.TransferCount;
			invItemTo = Spawn(checkthing); //== Y|y: Compatibility for custom transfers
			invItemTo.GiveTo(Pawn(event.toActor));
			DeusExPickup(invItemFrom).NumCopies -= event.transferCount;
			bSplitItem   = True;
			bSpawnedItem = True;
		}
		else
		{
			invItemTo = invItemFrom.SpawnCopy(Pawn(event.toActor));
		}

//log("  invItemFrom = "$  invItemFrom);
//log("  invItemTo   = " $ invItemTo);

		if (DeusExPlayer(event.toActor) != None)
			DeusExPlayer(event.toActor).FindInventorySlot(invItemTo);

		// Check if this item was in the player's hand *AND* that the player is 
		// giving the item to someone else.
		if ((DeusExPlayer(event.fromActor) != None) && (!bSplitItem))
			RemoveItemFromPlayer(invItemFrom);

		// If this was a DataVaultImage, then the image needs to be 
		// properly added to the datavault
		if ((invItemTo.IsA('DataVaultImage')) && (event.toActor.IsA('DeusExPlayer')))
		{
			DeusExPlayer(event.toActor).AddImage(DataVaultImage(invItemTo));
				
			if (conWinThird != None)
				conWinThird.ShowReceivedItem(invItemTo, 1);
			else
				DeusExRootWindow(player.rootWindow).hud.receivedItems.AddItem(invItemTo, 1);

			invItemFrom = None;
			invItemTo   = None;
		}

		// Special case for Credit Chits also
		else if ((invItemTo.IsA('Credits')) && (event.toActor.IsA('DeusExPlayer')))
		{
			if (conWinThird != None)
				conWinThird.ShowReceivedItem(invItemTo, Credits(invItemTo).numCredits);
			else
				DeusExRootWindow(player.rootWindow).hud.receivedItems.AddItem(invItemTo, Credits(invItemTo).numCredits);

			player.Credits += Credits(invItemTo).numCredits;
			
			invItemTo.Destroy();

			invItemFrom = None;
			invItemTo   = None;
		}

		// Now check to see if the transfer event specified transferring
		// more than one copy of the object
		else
		{
			itemsTransferred = AddTransferCount(invItemFrom, invItemTo, event, Pawn(event.toActor), True);

			// If no items were transferred, then the player's inventory is full or 
			// no more of these items can be stacked, so abort.
			if (itemsTransferred == 0)
			{
				invItemTo.Destroy();
				return nextAction;
			}

			// Update the belt text
			if (invItemTo.IsA('Ammo'))
				player.UpdateAmmoBeltText(Ammo(invItemTo));
			else
				player.UpdateBeltText(invItemTo);
		}
	}

	// Show the player that he/she/it just received something!
	if ((DeusExPlayer(event.toActor) != None) && (conWinThird != None) && (invItemTo != None))
	{
		if (conWinThird != None)
			conWinThird.ShowReceivedItem(invItemTo, itemsTransferred);
		else
			DeusExRootWindow(player.rootWindow).hud.receivedItems.AddItem(invItemTo, itemsTransferred);
	}

	nextAction = EA_NextEvent;
	nextLabel = "";

	return nextAction;
}

// ---------------------------------------------------------------------
// AddTransferCount()
// ----------------------------------------------------------------------

function int AddTransferCount(
	Inventory invItemFrom, 
	Inventory invItemTo, 
	ConEventTransferObject event, 
	pawn transferTo, 
	bool bSpawned)
{
	local ammo AmmoType;
	local int itemsTransferred;
	local DeusExPickup giveItem;

	itemsTransferred = 1;
/*
log("AddTransferCount()-------------------------------");
log("  invItemFrom = " $ invItemFrom);
log("  invItemTo   = " $ invItemTo);
log("  transferTo  = " $ transferTo);
log("  bSpawned    = " $ bSpawned);
log("  event.transferCount = " $ event.transferCount);
*/
	if (invItemTo == None)
		return 0;

	// If this is a Weapon, then we need to just add additional 
	// ammo.
	if (invItemTo.IsA('Weapon'))
	{
		if (event.transferCount > 1)
		{
			AmmoType = Ammo(transferTo.FindInventoryType(Weapon(invItemTo).AmmoName));

			if ( AmmoType != None )
			{
				itemsTransferred = Weapon(invItemTo).PickUpAmmoCount * (event.transferCount - 1);
				AmmoType.AddAmmo(itemsTransferred);

				// For count displayed
				itemsTransferred++;
			}
		}
	}

	// If this is a DeusExPickup and he already has it, just 
	// increment the count
	else if ((invItemTo.IsA('DeusExPickup')) && (DeusExPickup(invItemTo).bCanHaveMultipleCopies))
	{
		// If the item was spawned, then it will already have a copy count of 1, so we
		// only want to add to that if it was specified to transfer > 1 items.

		if (bSpawned)
		{
			itemsTransferred = event.transferCount;
			if (event.transferCount > 1)
			{
				DeusExPickup(invItemTo).NumCopies += event.transferCount - 1;

				if (DeusExPickup(invItemTo).NumCopies > DeusExPickup(invItemTo).maxCopies)
				{
					itemsTransferred = DeusExPickup(invItemTo).maxCopies;
					DeusExPickup(invItemTo).NumCopies = DeusExPickup(invItemTo).maxCopies;
				}
			}
		}

		// Wasn't spawned, so add the appropriate amount (if transferCount
		// isn't specified, just add one).

		else
		{
			if (event.transferCount > 0)
				itemsTransferred = event.transferCount;
			else
				itemsTransferred = 1;

			if ((DeusExPickup(invItemTo).NumCopies + itemsTransferred) > DeusExPickup(invItemTo).MaxCopies)
				itemsTransferred = DeusExPickup(invItemTo).MaxCopies - DeusExPickup(invItemTo).NumCopies;

			DeusExPickup(invItemTo).NumCopies += itemsTransferred;

			if ((DeusExPickup(invItemFrom) != None) && (invItemFrom != InvItemTo))
				DeusExPickup(invItemFrom).NumCopies -= itemsTransferred;
		}

		// Update the belt text
		DeusExPickup(invItemTo).UpdateBeltText();
	}
	else if ((invItemTo.IsA('DeusExPickup')) && (!bSpawned))
	{
		giveItem = DeusExPickup(Spawn(invItemTo.Class));
		giveItem.GiveTo(transferTo);
 
		// Just give the player another one of these fucking things
		if ((DeusExPlayer(transferTo) != None) && (DeusExPlayer(transferTo).FindInventorySlot(giveItem)))
			itemsTransferred = 1;
		else
			itemsTransferred = 0;
	}
	//== Y|y: Track ammo counts correctly
	else if(invItemTo.IsA('DeusExAmmo'))
	{
		itemsTransferred = Ammo(invItemTo).AmmoAmount;
	}

//log("  return itemsTransferred = " $ itemsTransferred);

	return itemsTransferred;
}

// ----------------------------------------------------------------------
// RemoveItemFromPlayer()
//
// Check if this item was in the player's hand
// ----------------------------------------------------------------------

function RemoveItemFromPlayer(Inventory item)
{
	if ((player != None) && (item != None))
		player.RemoveItemDuringConversation(item);
}

// ----------------------------------------------------------------------
// SetupEventJump()
// ----------------------------------------------------------------------

function EEventAction SetupEventJump( ConEventJump event, out String nextLabel )
{
	local EEventAction nextAction;

	// Check to see if the jump label is empty.  If so, then we just want
	// to fall through to the next event.  This can happen when jump
	// events get inserted during the import process.  ConEdit will not
	// allow the user to create events like this. 

	if ( event.jumpLabel == "" ) 
	{
		nextAction = EA_NextEvent;
		nextLabel = "";
	}
	else
	{
		// Jump to a specific label.  We can also jump into another conversation
		nextLabel = event.jumpLabel;

		if ( event.jumpCon != None )
			nextAction = EA_JumpToConversation;
		else
			nextAction = EA_JumpToLabel;
	}

	return nextAction;
}

// ----------------------------------------------------------------------
// SetupEventAnimation
// ----------------------------------------------------------------------

function EEventAction SetupEventAnimation( ConEventAnimation event, out String nextLabel )
{
	nextLabel = "";
	return EA_PlayAnim;
}

// ----------------------------------------------------------------------
// SetupEventRandomLabel()
// ----------------------------------------------------------------------

function EEventAction SetupEventRandomLabel( ConEventRandomLabel event, out String nextLabel )
{
	// Pick a random label
	nextLabel = event.GetRandomLabel();
	return EA_JumpToLabel;
}

// ----------------------------------------------------------------------
// SetupEventTrigger()
// ----------------------------------------------------------------------

function EEventAction SetupEventTrigger( ConEventTrigger event, out String nextLabel )
{
	local Actor anActor;

	// Loop through all the actors, firing a trigger for each
	foreach AllActors(class'Actor', anActor, event.triggerTag)
		anActor.Trigger(lastActor, Pawn(lastActor));

	return EA_NextEvent;
}

// ----------------------------------------------------------------------
// SetupEventAddGoal()
//
// TODO: Add support for goals longer than 255 characters.  
// ----------------------------------------------------------------------

function EEventAction SetupEventAddGoal( ConEventAddGoal event, out String nextLabel )
{
	local DeusExGoal goal;

	// First check to see if this goal exists
	goal = player.FindGoal( event.goalName );

	if (( goal == None ) && ( !event.bGoalCompleted ))
	{
		// Add this goal to the player's goals
		goal = player.AddGoal(event.goalName, event.bPrimaryGoal);
		goal.SetText(event.goalText);
	}
	// Check if we're just marking this goal as complete
	else if (( goal != None ) && ( event.bGoalCompleted ))
	{
		player.GoalCompleted(event.goalName);
	}

	return EA_NextEvent;
}

// ----------------------------------------------------------------------
// SetupEventAddNote()
//
// TODO: Add support for notes longer than 255 characters.  
// ----------------------------------------------------------------------

function EEventAction SetupEventAddNote( ConEventAddNote event, out String nextLabel )
{
	// Only add the note if it hasn't been added already (in case the 
	// PC has the same conversation more than once)

	if ( !event.bNoteAdded )
	{
		// Add the note to the player's list of notes
		player.AddNote(event.noteText, False, True);

		event.bNoteAdded = True;
	}

	return EA_NextEvent;
}

// ----------------------------------------------------------------------
// SetupEventAddSkillPoints()
// ----------------------------------------------------------------------

function EEventAction SetupEventAddSkillPoints( ConEventAddSkillPoints event, out String nextLabel )
{
	player.SkillPointsAdd(event.pointsToAdd);

	nextLabel = "";
	return EA_NextEvent;
}

// ----------------------------------------------------------------------
// SetupEventAddCredits()
//
// Adds the specified number of credits to the player.  If the 
// 'creditsToTransfer' variable is negative, this will cause
// the credits to get deducted from the player's credits total.
// ----------------------------------------------------------------------

function EEventAction SetupEventAddCredits( ConEventAddCredits event, out String nextLabel )
{
	player.credits += event.creditsToAdd;

	// Make sure we haven't gone into the negative
	player.credits = Max(player.credits, 0);

	nextLabel = "";
	return EA_NextEvent;
}

// ----------------------------------------------------------------------
// SetupEventCheckPersona()
// ----------------------------------------------------------------------

function EEventAction SetupEventCheckPersona( ConEventCheckPersona event, out String nextLabel )
{
	local EEventAction action;
	local int personaValue;
	local bool bPass;

	// First determine which persona item we're checking
	switch(event.personaType)
	{
		case EP_Credits:
			personaValue = player.Credits;
			break;

		case EP_Health:
			player.GenerateTotalHealth();
			personaValue = player.Health;
			break;

		case EP_SkillPoints:
			personaValue = player.SkillPointsAvail;
			break;
	}

	// Now decide what to do baby!
	switch(event.condition)
	{
		case EC_Less:
			bPass = (personaValue < event.value);
			break;

		case EC_LessEqual:
			bPass = (personaValue <= event.value);
			break;

		case EC_Equal:
			bPass = (personaValue == event.Value);
			break;

		case EC_GreaterEqual:
			bPass = (personaValue >= event.Value);
			break;

		case EC_Greater:
			bPass = (personaValue > event.Value);
			break;
	}

	if (bPass)
	{
		nextLabel = event.jumpLabel;
		action = EA_JumpToLabel;
	}
	else
	{
		nextLabel = "";
		action = EA_NextEvent;
	}

	return action;
}

// ----------------------------------------------------------------------
// SetupEventEnd()
// ----------------------------------------------------------------------

function EEventAction SetupEventEnd( ConEventEnd event, out String nextLabel )
{
	nextLabel = "";
	return EA_End;
}

// ----------------------------------------------------------------------
// SetupHistory()
// ----------------------------------------------------------------------

function SetupHistory(String ownerName, optional Bool bInfoLink)
{
	local Name flagName;
	local bool bBarkConvo;

	// If this conversation has already been played, we don't want
	// to record it again
	//
	// Also ignore Bark conversations.

	bBarkConvo = (Left(con.conName, Len(con.conOwnerName) + 5) == (con.conOwnerName $ "_Bark"));
	flagName   = rootWindow.StringToName(con.conName $ "_Played");		

	if ((player.flagBase.GetBool(flagName) == False) && (!bBarkConvo))
	{
		history = player.CreateHistoryObject();

		history.conOwnerName    = ownerName;
		history.strLocation		= MissionLocation;
		history.strDescription	= con.Description;
		history.bInfoLink       = bInfoLink;
		history.firstEvent		= None;
		history.lastEvent		= None;
		history.next			= None;
	}
	else
	{
		history = None;
	}
}

// -------------------------------------------------------------------------
// AddHistoryEvent()
// -------------------------------------------------------------------------

function AddHistoryEvent( String eventSpeaker, ConSpeech eventSpeech )
{
	local ConHistoryEvent newEvent;

	if (history != None)
	{
		// First, create a new event
		newEvent = player.CreateHistoryEvent(); 

		// Assign variables
		newEvent.conSpeaker = eventSpeaker;

		newEvent.speech  = eventSpeech.speech;
		newEvent.soundID = eventSpeech.soundID;

		newEvent.next = None;

		history.AddEvent(newEvent);
	}
}

// ----------------------------------------------------------------------
// TurnSpeakingActors()
//
// Attempts to turn the speaking actor to the person being spoken to.
// If the speaking actor is not a scriptedpawn, then abort.
// ----------------------------------------------------------------------

function TurnSpeakingActors(Actor speaker, Actor speakingTo)
{
	if (!bForcePlay)
	{
		TurnActor(speaker,    speakingTo);
		TurnActor(speakingTo, speaker);
	}
	else
	{
		if ((speaker != None) && (speaker.IsA('ScriptedPawn')))
			ScriptedPawn(speaker).EnterConversationState(con.bFirstPerson);
		if ((speakingTo != None) && (speakingTo.IsA('ScriptedPawn')))
			ScriptedPawn(speakingTo).EnterConversationState(con.bFirstPerson);
	}
}

// ----------------------------------------------------------------------
// TurnActor()
// ----------------------------------------------------------------------

function TurnActor(Actor turnActor, Actor turnTowards)
{
	// Check to see if each Actor is already in the conversation
	// state.  If not, they need to be in that state.  Just don't 
	// add the player

	if (DeusExPlayer(turnActor) == None)
	{
		AddConActor(turnActor, con.bFirstPerson);

		if ((turnActor != None) && (turnActor.IsA('ScriptedPawn')))
			ScriptedPawn(turnActor).ConversationActor = turnTowards;
	}
	else
		DeusExPlayer(turnActor).ConversationActor = turnTowards;
}

// ----------------------------------------------------------------------
// AddConActor()
//
// Adds this pawn to the list of actors speaking in this conversation,
// and sets the pawn's conversation state
// ----------------------------------------------------------------------

function AddConActor(Actor newConActor, bool bFirstPerson)
{	
	if ((!bForcePlay) && (newConActor != None))
	{
		// Only do if we have space and this pawn isn't already speaking
		if ((!IsConActorInList(newConActor)) && (conActorCount < 9))
		{
			ConActors[conActorCount++] = newConActor;

			if (newConActor.IsA('ScriptedPawn'))
				ScriptedPawn(newConActor).EnterConversationState(bFirstPerson);
			else if (newConActor.IsA('DeusExDecoration'))
				DeusExDecoration(newConActor).EnterConversationState(bFirstPerson);
		}
	}
}

// ----------------------------------------------------------------------
// IsConActorInList()
// ----------------------------------------------------------------------

function bool IsConActorInList(Actor conActor, optional bool bRemoveActor)
{
	local int conActorIndex;
	local bool bFound;

	for(conActorIndex=0; conActorIndex<conActorCount; conActorIndex++)
	{
		if (ConActors[conActorIndex] == conActor)
		{
			if (bRemoveActor)
				ConActors[conActorIndex] = None;

			bFound = True;
			break;
		}
	}

	return bFound;
}

// ----------------------------------------------------------------------
// EndConActorStates()
//
// Loops through the ConActors[] array and kicks 'em out of
// conversation mode
// ----------------------------------------------------------------------

function EndConActorStates()
{
	local int conActorIndex;

	if (!bForcePlay)
	{
		for(conActorIndex=conActorCount-1; conActorIndex>=0; conActorIndex--)
		{
			if (ConActors[conActorIndex] != None)
			{
				ConActors[conActorIndex].EndConversation();
				ConActors[conActorIndex] = None;
				conActorCount--;
			}
		}

		// Make sure the invoking actor, if a DeusExDecoration or ScriptedPawn,
		// is not stuck in the conversation state
		if (ScriptedPawn(invokeActor) != None )
			ScriptedPawn(invokeActor).EndConversation();
		else if (DeusExDecoration(invokeActor) != None )
			DeusExDecoration(invokeActor).EndConversation();
	}
}

// ----------------------------------------------------------------------
// ActorDestroyed()
//
// Called when an actor gets destroyed via some external process.
// Check our list of ConActors, if the destroyed actors is in this list,
// then:
//
// 1) Remove the actor from the ConActors array
// 2) Immediately abort the conversation (this is done to prevent a 
//    crash by referencing a destroyed object)
// ----------------------------------------------------------------------

function ActorDestroyed(Actor destroyedActor)
{
	local int conActorIndex;

	for(conActorIndex=0; conActorIndex<ArrayCount(ConActorsBound); conActorIndex++)
	{
		if (ConActorsBound[conActorIndex] == destroyedActor)
		{
			// First check to see if it's in the ConActors list, in 
			// which case it needs to be removed before we abort
			// (so it doesn't try to do anything with that variable)
			IsConActorInList(destroyedActor, True);

			// Abort the conversation!!!
			TerminateConversation();
			break;
		}
	}
}

// ----------------------------------------------------------------------
// SetForcePlay()
// ----------------------------------------------------------------------

function SetForcePlay(bool bNewForcePlay)
{
	bForcePlay = bNewForcePlay;
}

// ----------------------------------------------------------------------
// GetForcePlay()
// ----------------------------------------------------------------------

function bool GetForcePlay()
{
	return bForcePlay;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
