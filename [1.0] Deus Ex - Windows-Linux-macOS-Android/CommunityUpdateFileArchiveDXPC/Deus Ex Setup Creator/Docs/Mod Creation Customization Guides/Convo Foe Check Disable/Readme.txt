Just set every return is CanConverseWithPlayer in ScriptedPawn to be true


// ----------------------------------------------------------------------
// CanConverseWithPlayer()
// ----------------------------------------------------------------------
// First three set from false to true to disable foe check -dp
function bool CanConverseWithPlayer(DeusExPlayer dxPlayer)
{
	local name alliance1, alliance2, carcname;  // temp vars

	if (GetPawnAllianceType(dxPlayer) == ALLIANCE_Hostile)
		return false;
	else if ((GetStateName() == 'Fleeing') && (Enemy != dxPlayer) && (IsValidEnemy(Enemy, false)))  // hack
		return false;
	else if (GetCarcassData(dxPlayer, alliance1, alliance2, carcname))
		return false;
	else
		return true;
}

To

// ----------------------------------------------------------------------
// CanConverseWithPlayer()
// ----------------------------------------------------------------------
// First three set from false to true to disable foe check -dp
function bool CanConverseWithPlayer(DeusExPlayer dxPlayer)
{
	local name alliance1, alliance2, carcname;  // temp vars

	if (GetPawnAllianceType(dxPlayer) == ALLIANCE_Hostile)
		return true;
	else if ((GetStateName() == 'Fleeing') && (Enemy != dxPlayer) && (IsValidEnemy(Enemy, false)))  // hack
		return true;
	else if (GetCarcassData(dxPlayer, alliance1, alliance2, carcname))
		return true;
	else
		return true;
}


Defaultmom001 — Yesterday at 11:53 PM
fuck me no matter what I do I can't get a hostile npc to wanna talk
there's like an explicit line in DXPlayer.uc that says it checks for alliance but disabling that doesn't seem to help
I just wanna do some stupid shit
Rubber Ducky WCCC — Today at 12:11 AM
ScriptedPawn.CanConverseWithPlayer
the hatred is mutual it would seem

