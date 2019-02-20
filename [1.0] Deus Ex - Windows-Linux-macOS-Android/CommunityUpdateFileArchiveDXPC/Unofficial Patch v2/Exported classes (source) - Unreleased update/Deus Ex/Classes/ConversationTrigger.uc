//=============================================================================
// ConversationTrigger.
//=============================================================================
class ConversationTrigger extends Trigger;

//
// Triggers a conversation when touched
//
// * conversationTag is matched to the conversation file which has all of
//   the conversation events in it.
//

var() name conversationTag;
var() string BindName;
var() name checkFlag;
var() bool bCheckFalse;

singular function Trigger(Actor Other, Pawn Instigator)
{
	local DeusExPlayer player;
	local bool bSuccess;
	local Actor A, conOwner;

	player = DeusExPlayer(Instigator);
	bSuccess = True;

	// only works for DeusExPlayers
	if (player == None)
		return;

	if (checkFlag != '')
	{
		if (!player.flagBase.GetBool(checkFlag))
			bSuccess = bCheckFalse;
		else
			bSuccess = !bCheckFalse;
	}

	if ((BindName != "") && (conversationTag != ''))
	{
		foreach AllActors(class'Actor', A)
			if (A.BindName == BindName)
			{
				conOwner = A;
				break;
			}
			

		if (bSuccess)
			if (player.StartConversationByName(conversationTag, conOwner))
				Super.Trigger(Other, Instigator);
	}
}

singular function Touch(Actor Other)
{
	local DeusExPlayer player;
	local bool bSuccess;
	local Actor A, conOwner;

	player = DeusExPlayer(Other);
	bSuccess = True;

	// only works for DeusExPlayers
	if (player == None)
		return;

	if (checkFlag != '')
	{
		if (!player.flagBase.GetBool(checkFlag))
			bSuccess = bCheckFalse;
		else
			bSuccess = !bCheckFalse;
	}

	if ((BindName != "") && (conversationTag != ''))
	{
		foreach AllActors(class'Actor', A)
			if (A.BindName == BindName)
			{
				conOwner = A;
				break;
			}
			

		if (bSuccess)
			if (player.StartConversationByName(conversationTag, conOwner))
				Super.Touch(Other);
	}
}

defaultproperties
{
     bTriggerOnceOnly=True
     CollisionRadius=96.000000
}
