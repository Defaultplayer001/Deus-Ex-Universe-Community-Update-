//=============================================================================
// DataLinkTrigger.
//=============================================================================
class DataLinkTrigger extends Trigger;

//
// Triggers a DataLink event when touched
//
// * datalinkTag is matched to the conversation file which has all of
//   the DataLink events in it.
//
// We might possibly need to monitor a flag and trigger a DataLink event
// when that flag changes during the mission.  This could be done in the
// individual mission's script file update loop.
//

var() name datalinkTag;
var() name checkFlag;
var() bool bCheckFalse;

var bool  bStartedViaTrigger;
var bool  bStartedViaTouch;
var bool  bCheckFlagTimer;
var float checkFlagTimer;

var DeusExPlayer player;
var Actor		 triggerOther;
var Pawn         triggerInstigator;

// ----------------------------------------------------------------------
// Timer()
// ----------------------------------------------------------------------

function Timer()
{
	if ((bCheckFlagTimer) && (EvaluateFlag()) && (player != None))
		player.StartDataLinkTransmission(String(datalinkTag), Self);
}

// ----------------------------------------------------------------------
// Trigger()
// ----------------------------------------------------------------------

singular function Trigger(Actor Other, Pawn Instigator)
{
	// Only set the player if the player isn't already set and 
	// the "bCheckFlagTimer" variable is false
	if ((player == None) || ((player != None) && (bCheckFlagTimer == False)))
		player = DeusExPlayer(Instigator);

	// only works for DeusExPlayers
	if (player == None)
		return;

	if (EvaluateFlag())
	{
		if (player.StartDataLinkTransmission(String(datalinkTag), Self) == True)
		{
			bStartedViaTrigger = True;
			triggerOther       = Other;
			triggerInstigator  = Instigator;
		}
	}
	else if (checkFlag != '')
	{
		bStartedViaTrigger = True;
		triggerOther       = Other;
		triggerInstigator  = Instigator;
	}
}

// ----------------------------------------------------------------------
// Touch()
// ----------------------------------------------------------------------

singular function Touch(Actor Other)
{
	// Only set the player if the player isn't already set and 
	// the "bCheckFlagTimer" variable is false
	if ((player == None) || ((player != None) && (bCheckFlagTimer == False)))
		player = DeusExPlayer(Other);

	// only works for DeusExPlayers
	if (player == None)
		return;

	if (EvaluateFlag())
	{
		if (player.StartDataLinkTransmission(String(datalinkTag), Self) == True)
		{
			bStartedViaTouch = True;
			triggerOther     = Other;
		}
	}
	else if (checkFlag != '')
	{
		bStartedViaTouch   = True;
		triggerOther       = Other;
	}
}

// ----------------------------------------------------------------------
// UnTouch()
// 
// Used to monitor the state of the "checkFlag" variable if it's set.
// This is so a player can be sitting inside the radius of a trigger
// and if the "checkFlag" suddenly is valid, the trigger will play.
// ----------------------------------------------------------------------

function UnTouch( actor Other )
{
	bCheckFlagTimer = False;
	Super.UnTouch(Other);
}

// ----------------------------------------------------------------------
// EvaluateFlag()
// ----------------------------------------------------------------------

function bool EvaluateFlag()
{
	local bool bSuccess;

	if (checkFlag != '')
	{
		if ((player != None) && (player.flagBase != None))
		{
			if (!player.flagBase.GetBool(checkFlag))
				bSuccess = bCheckFalse;
			else
				bSuccess = !bCheckFalse;

			// If the flag check fails, then make sure the Tick() event 
			// is active so we can continue to check the flag while 
			// the player is inside the radius of the trigger.

			if (!bSuccess)
			{
				bCheckFlagTimer = True;
				SetTimer(checkFlagTimer, False);
			}
		}
		else
		{
			bSuccess = False;
		}
	}
	else
	{
		bSuccess = True;
	}

	return bSuccess;
}

// ----------------------------------------------------------------------
// DatalinkFinished()
// ----------------------------------------------------------------------

function DatalinkFinished()
{
	if (bStartedViaTrigger)
		Super.Trigger(triggerOther, triggerInstigator);
	else if (bStartedViaTouch)
		Super.Touch(triggerOther);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     checkFlagTimer=1.000000
     bTriggerOnceOnly=True
     CollisionRadius=96.000000
}
