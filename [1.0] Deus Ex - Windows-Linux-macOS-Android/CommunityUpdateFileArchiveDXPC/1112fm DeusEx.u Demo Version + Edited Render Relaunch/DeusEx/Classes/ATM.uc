//=============================================================================
// ATM.
//=============================================================================
class ATM extends ElectronicDevices;

var ATMWindow atmwindow;

// userlist information
struct sUserInfo
{
	var() string	accountNumber;
	var() string	PIN;
	var() int		balance;
};

var() sUserInfo userList[8];

var bool bLockedOut;				// true if this ATM is locked out
var() float lockoutDelay;			// delay until locked out ATM can be used
var float lockoutTime;				// time when ATM was locked out
var float lastHackTime;				// last time the ATM was hacked
var localized String msgLockedOut;
var bool bSuckedDryByHack;

// ----------------------------------------------------------------------
// Frob()
// ----------------------------------------------------------------------

function Frob(Actor Frobber, Inventory frobWith)
{
	local DeusExPlayer Player;
	local DeusExRootWindow root;
	local float elapsed, delay;

	Super.Frob(Frobber, frobWith);

	// if we're already using this ATM, get out
	if (atmwindow != None)
		return;

	Player = DeusExPlayer(Frobber);

	if (Player != None)
	{
		if (bLockedOut)
		{
			// computer skill shortens the lockout duration
			delay = lockoutDelay / Player.SkillSystem.GetSkillLevelValue(class'SkillComputer');

			elapsed = Level.TimeSeconds - lockoutTime;
			if (elapsed < delay)
				Player.ClientMessage(Sprintf(msgLockedOut, Int(delay - elapsed)));
			else
				bLockedOut = False;
		}
		if (!bLockedOut)
		{
			root = DeusExRootWindow(Player.rootWindow);
			if (root != None)
			{
				atmWindow = ATMWindow(root.InvokeUIScreen(Class'ATMWindow', True));

				if (atmWindow != None)
				{
					atmWindow.SetCompOwner(Self);
					atmWindow.ShowFirstScreen();
				}
			}
		}
	}
}

// ----------------------------------------------------------------------
// NumUsers()
// ----------------------------------------------------------------------

function int NumUsers()
{
	local int i;

	for (i=0; i<ArrayCount(userList); i++)
		if (userList[i].accountNumber == "")
			break;

	return i;
}

// ----------------------------------------------------------------------
// GetBalance()
// ----------------------------------------------------------------------

function int GetBalance(int userIndex, float mod)
{
	local int i, sum;

	sum = 0;

	if ((userIndex >= 0) && (userIndex < ArrayCount(userList)))
		sum = userList[userIndex].balance;
	else if (userIndex == -1)
	{
		// if we've been hacked, sum all the accounts
		for (i=0; i<ArrayCount(userList); i++)
			sum += userList[i].balance;
		sum *= mod;
	}

	return sum;
}

// ----------------------------------------------------------------------
// ModBalance()
// ----------------------------------------------------------------------

function ModBalance(int userIndex, int numCredits, bool bSync)
{
	local ATM atm;
	local int i;

	if ((userIndex >= 0) && (userIndex < ArrayCount(userList)))
		userList[userIndex].balance -= numCredits;
	else if (userIndex == -1)
	{
		// if we've been hacked, zero all the accounts if we have enough to transfer
		for (i=0; i<ArrayCount(userList); i++)
			userList[i].balance = 0;
	}

	// sync the balance with all other ATMs on this map
	if (bSync)
	{
		foreach AllActors(class'ATM', atm)
			for (i=0; i<atm.NumUsers(); i++)
				if (atm != Self)
					if ((Caps(userList[userIndex].accountNumber) == atm.GetAccountNumber(i)) &&
						(Caps(userList[userIndex].PIN) == atm.GetPIN(i)))
					{
						atm.ModBalance(i, numCredits, False);
					}
	}
}

// ----------------------------------------------------------------------
// GetAccountNumber()
// ----------------------------------------------------------------------

function string GetAccountNumber(int userIndex)
{
	if ((userIndex >= 0) && (userIndex < ArrayCount(userList)))
		return Caps(userList[userIndex].accountNumber);
	else if (userIndex == -1)
		return "HACKED";

	return "ERR";
}

// ----------------------------------------------------------------------
// GetPIN()
// ----------------------------------------------------------------------

function string GetPIN(int userIndex)
{
	if ((userIndex >= 0) && (userIndex < ArrayCount(userList)))
		return Caps(userList[userIndex].PIN);
	else if (userIndex == -1)
		return "HACKED";

	return "ERR";
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     lockoutDelay=60.000000
     lastHackTime=-9999.000000
     msgLockedOut="Terminal is locked out for %d more seconds"
     ItemName="Public Banking Terminal"
     Physics=PHYS_None
     Mesh=LodMesh'DeusExDeco.ATM'
     SoundRadius=8
     SoundVolume=255
     AmbientSound=Sound'DeusExSounds.Generic.ElectronicsHum'
     CollisionHeight=40.000000
     bCollideWorld=False
     Mass=400.000000
     Buoyancy=200.000000
}
