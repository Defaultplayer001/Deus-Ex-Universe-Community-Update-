//=============================================================================
// DamageTrigger.
//=============================================================================
class DamageTrigger expands Trigger;

var() float damageAmount;
var() bool bConstantDamage;
var() float damageInterval;
var() name damageType;
var Actor damagee;
var bool bIsOn;

function Timer()
{
	if (!bIsOn)
	{
		SetTimer(0.1, False);
		return;
	}

	if (damagee != None)
		damagee.TakeDamage(damageAmount, None, Location, vect(0,0,0), damageType);
}

function Touch(Actor Other)
{
	if (!bIsOn)
		return;

	// should we even pay attention to this actor?
	if (!IsRelevant(Other))
		return;

	damagee = Other;
	SetTimer(damageInterval, bConstantDamage);

	Super.Touch(Other);
}

function UnTouch(Actor Other)
{
	if (!bIsOn)
		return;

	damagee = None;
	SetTimer(0.1, False);
}

// if we are triggered, turn us on
function Trigger(Actor Other, Pawn Instigator)
{
	if (!bIsOn)
		bIsOn = True;

	Super.Trigger(Other, Instigator);
}

// if we are untriggered, turn us off
function UnTrigger(Actor Other, Pawn Instigator)
{
	if (bIsOn)
		bIsOn = False;

	Super.UnTrigger(Other, Instigator);
}

defaultproperties
{
     DamageAmount=5.000000
     bConstantDamage=True
     damageInterval=0.500000
     DamageType=Burned
     bIsOn=True
}
