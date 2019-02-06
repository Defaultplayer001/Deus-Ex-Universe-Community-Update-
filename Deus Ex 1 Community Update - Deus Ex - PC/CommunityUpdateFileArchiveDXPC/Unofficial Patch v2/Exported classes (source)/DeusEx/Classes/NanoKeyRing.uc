//=============================================================================
// NanoKeyRing
//
// NanoKeyRing object.  In order to make things easier
// on the player, when the player picks up a key it's added 
// to the list of keys stored in the keyring
//=============================================================================

class NanoKeyRing extends SkilledTool;

var localized string NoKeys;
var localized string KeysAvailableLabel;

// ----------------------------------------------------------------------
// Networking Replication
// ----------------------------------------------------------------------

replication
{
   //server to client function calls
   reliable if (Role == ROLE_Authority)
      GiveClientKey, RemoveClientKey, ClientRemoveAllKeys;
}

// ----------------------------------------------------------------------
// HasKey()
//
// Checks to see if we have the keyname passed in
// ----------------------------------------------------------------------

simulated function bool HasKey(Name KeyToLookFor)
{
	local NanoKeyInfo aKey;
	local Bool bHasKey;

	bHasKey = False;

	if (GetPlayer() != None)
	{
		aKey = GetPlayer().KeyList;

		// Loop through all the keys and see if one exists
		while(aKey != None)
		{
			if (aKey.KeyID == KeyToLookFor)
			{
				bHasKey = True;
				break;
			}

			aKey = aKey.NextKey;
		}
	}
	return bHasKey;
}

// ----------------------------------------------------------------------
// GiveKey()
//
// Adds a key to our array
// ----------------------------------------------------------------------

simulated function GiveKey(Name newKeyID, String newDescription)
{
	local NanoKeyInfo aKey;

	if (GetPlayer() != None)
	{
		// First check to see if the player already has this key
		if (HasKey(newKeyID))
			return;

		// Spawn a key
		aKey = GetPlayer().CreateNanoKeyInfo();

		// Set the appropriate fields and 
		// add to the beginning of our list
		aKey.KeyID       = newKeyID;
		aKey.Description = newDescription;
		aKey.NextKey     = GetPlayer().KeyList;
		GetPlayer().KeyList   = aKey;

	}
}

// ----------------------------------------------------------------------
// function GiveClientKey()
// ----------------------------------------------------------------------

simulated function GiveClientKey(Name newKeyID, String newDescription)
{
   GiveKey(newKeyID, newDescription);
}

// ----------------------------------------------------------------------
// RemoveKey()
// ----------------------------------------------------------------------

simulated function RemoveKey(Name KeyToRemove)
{
	local NanoKeyInfo aKey;
	local NanoKeyInfo lastKey;

	if (GetPlayer() != None)
	{
		aKey = GetPlayer().KeyList;
			
		// Loop through all the keys and see if one exists
		while(aKey != None)
		{
			if (aKey.KeyID == KeyToRemove)
			{
				if (lastKey != None)
					lastKey.NextKey = aKey.NextKey;

				if (GetPlayer().KeyList == aKey)
					GetPlayer().KeyList = aKey.NextKey;

				CriticalDelete(aKey);
				aKey = None;

				break;
			}
			
			lastKey = aKey;
			aKey    = aKey.NextKey;
		}
	}
}

// ----------------------------------------------------------------------
// function RemoveClientKey()
// ----------------------------------------------------------------------

simulated function RemoveClientKey(Name KeyToRemove)
{
   RemoveKey(KeyToRemove);
}

// ----------------------------------------------------------------------
// RemoveAllKeys()
// ----------------------------------------------------------------------

simulated function RemoveAllKeys()
{
	local NanoKeyInfo aKey;
	local NanoKeyInfo deadKey;
	
	if (GetPlayer() != None)
	{
		aKey = GetPlayer().KeyList;

		// Loop through all the keys and see if one exists
		while(aKey != None)
		{
			deadKey = aKey;

			CriticalDelete(aKey);
			aKey = None;

			aKey = deadKey.NextKey;
		}

		GetPlayer().KeyList = None;
	}
}

// ----------------------------------------------------------------------
// ClientRemoveAllKeys()
// ----------------------------------------------------------------------

simulated function ClientRemoveAllKeys()
{ 
   RemoveAllKeys();
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;
	local NanoKeyInfo keyInfo;
	local int keyCount;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

	winInfo.SetTitle(itemName);
	winInfo.SetText(KeysAvailableLabel);
	winInfo.AddLine();

	if (GetPlayer() != None)
	{
		keyInfo = GetPlayer().KeyList;

		if (keyInfo != None)
		{
			while(keyInfo != None)
			{
				winInfo.SetText("  " $ keyInfo.Description);
				keyInfo = keyInfo.NextKey;
				keyCount++;
			}
		}
	}

	if (keyCount > 0)
	{
		winInfo.AddLine();
		winInfo.SetText(Description);
	}
	else
	{
		winInfo.Clear();
		winInfo.SetTitle(itemName);
		winInfo.SetText(NoKeys);
	}

	return True;
}

// ----------------------------------------------------------------------
// GetPlayer()
// ----------------------------------------------------------------------

simulated function DeusExPlayer GetPlayer()
{
	return DeusExPlayer(Owner);
}

// ----------------------------------------------------------------------
// GetKeyCount()
// ----------------------------------------------------------------------

simulated function int GetKeyCount()
{
	local int keyCount;
	local NanoKeyInfo aKey;

	if (GetPlayer() != None)
	{
		aKey = GetPlayer().KeyList;

		// Loop through all the keys and see if one exists
		while(aKey != None)
		{
			keyCount++;
			aKey = aKey.NextKey;
		}
	}

	return keyCount;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
state UseIt
{
	function PutDown()
	{
		
	}

Begin:
	PlaySound(useSound, SLOT_None);
	PlayAnim('UseBegin',, 0.1);
	FinishAnim();
	LoopAnim('UseLoop',, 0.1);
	GotoState('StopIt');
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
state StopIt
{
	function PutDown()
	{
		
	}

Begin:
	PlayAnim('UseEnd',, 0.1);
	GotoState('Idle', 'DontPlaySelect');
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     NoKeys="No Nano Keys Available!"
     KeysAvailableLabel="Nano Keys Available:"
     UseSound=Sound'DeusExSounds.Generic.KeysRattling'
     bDisplayableInv=False
     ItemName="Nanokey Ring"
     ItemArticle="the"
     PlayerViewOffset=(X=16.000000,Y=15.000000,Z=-16.000000)
     PlayerViewMesh=LodMesh'DeusExItems.NanoKeyRingPOV'
     PickupViewMesh=LodMesh'DeusExItems.NanoKeyRing'
     ThirdPersonMesh=LodMesh'DeusExItems.NanoKeyRing'
     Icon=Texture'DeusExUI.Icons.BeltIconNanoKeyRing'
     largeIcon=Texture'DeusExUI.Icons.LargeIconNanoKeyRing'
     largeIconWidth=47
     largeIconHeight=44
     Description="A nanokey ring can read and store the two-dimensional molecular patterns from different nanokeys, and then recreate those patterns on demand."
     beltDescription="KEY RING"
     bHidden=True
     Mesh=LodMesh'DeusExItems.NanoKeyRing'
     CollisionRadius=5.510000
     CollisionHeight=4.690000
     Mass=10.000000
     Buoyancy=5.000000
}
