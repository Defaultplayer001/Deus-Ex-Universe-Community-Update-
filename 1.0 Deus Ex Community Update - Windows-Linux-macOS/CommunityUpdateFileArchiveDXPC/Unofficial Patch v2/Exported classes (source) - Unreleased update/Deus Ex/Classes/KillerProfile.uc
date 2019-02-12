//
//	KillerProfile holds the information of your killer in multiplayer
//
class KillerProfile extends Info;

var String		name;
var String		activeWeapon;
var String		activeSkill;
var int			activeSkillLevel;
var String		activeAugs[9];
var int			numActiveAugs;
var bool			bProximityKilled;
var int			streak;
var int			healthLow;
var int			healthMid;
var int			healthHigh;
var int			remainingBio;
var int			damage;
var String		bodyLoc;
var bool			bTurretKilled;
var bool			bBurnKilled;
var bool			bPoisonKilled;
var bool			bProjKilled;
var Vector		killerLoc;
var String		methodStr;
var String		myActiveAugs[9];
var int			myNumActiveAugs;
var String		myActiveWeapon;
var String		myActiveSkill;
var int			myActiveSkillLevel;

var bool bKilledSelf;
var bool bValid;

replication
{
	reliable if ((Role==ROLE_Authority) && bNetOwner)
		name, activeWeapon, activeSkill, activeSkillLevel, numActiveAugs, bProximityKilled, streak, healthLow, healthMid, healthHigh, remainingBio, damage,
		activeAugs,	bodyLoc, bTurretKilled, bBurnKilled, bPoisonKilled, bProjKilled, killerLoc, methodStr,
		myActiveAugs, myNumActiveAugs, myActiveWeapon, myActiveSkill, myActiveSkillLevel;
}

function Reset()
{
	activeWeapon="None";
	activeSkill="None";
	activeSkillLevel = 0;
	bProximityKilled=False;
	bTurretKilled=False;
	bBurnKilled=False;
	bPoisonKilled=False;
	bProjKilled=False;
	numActiveAugs=0;
	myNumActiveAugs=0;
}

defaultproperties
{
}
