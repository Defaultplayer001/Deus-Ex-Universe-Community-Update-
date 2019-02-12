//=============================================================================
// MapExit.
//=============================================================================
class MapExit expands NavigationPoint;

//
// MapExit transports you to the next map
// change bCollideActors to False to make it triggered instead of touched
//

var() string DestMap;
var() bool bPlayTransition;
var() name cameraPathTag;

var DeusExPlayer Player;

function LoadMap(Actor Other)
{
	// use GetPlayerPawn() because convos trigger by who's having the convo
	Player = DeusExPlayer(GetPlayerPawn());

	if (Player != None)
	{
		// Make sure we destroy all windows before sending the 
		// player on his merry way.
		DeusExRootWindow(Player.rootWindow).ClearWindowStack();

		if (bPlayTransition)
		{
			PlayTransitionPath();
			Player.NextMap = DestMap;
		}
		else
			Level.Game.SendPlayer(Player, DestMap);
	}
}

function Trigger(Actor Other, Pawn Instigator)
{
	Super.Trigger(Other, Instigator);
	LoadMap(Other);
}

function Touch(Actor Other)
{
	Super.Touch(Other);
	LoadMap(Other);
}

function PlayTransitionPath()
{
	local InterpolationPoint I;

	if (Player != None)
	{
		foreach AllActors(class 'InterpolationPoint', I, cameraPathTag)
		{
			if (I.Position == 1)
			{
				Player.SetCollision(False, False, False);
				Player.bCollideWorld = False;
				Player.Target = I;
				Player.SetPhysics(PHYS_Interpolating);
				Player.PhysRate = 1.0;
				Player.PhysAlpha = 0.0;
				Player.bInterpolating = True;
				Player.bStasis = False;
				Player.ShowHud(False);
				Player.PutInHand(None);

				// if we're in a conversation, set the NextState
				// otherwise, goto the correct state
				if (Player.conPlay != None)
					Player.NextState = 'Interpolating';
				else
					Player.GotoState('Interpolating');

				break;
			}
		}
	}
}

defaultproperties
{
     Texture=Texture'Engine.S_Teleport'
     bCollideActors=True
}
