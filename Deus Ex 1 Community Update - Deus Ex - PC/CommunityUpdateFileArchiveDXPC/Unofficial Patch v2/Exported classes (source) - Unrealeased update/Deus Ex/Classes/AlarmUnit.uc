//=============================================================================
// AlarmUnit.
//=============================================================================
class AlarmUnit extends HackableDevices;

#exec OBJ LOAD FILE=Ambient

var() int alarmTimeout;
var localized string msgActivated;
var localized string msgDeactivated;
var bool bActive;
var float curTime;
var Pawn alarmInstigator;
var Vector alarmLocation;
var() name Alliance;
var Pawn associatedPawn;
var bool bDisabled;
var bool bConfused;				// used when hit by EMP
var float confusionTimer;		// how long until unit resumes normal operation
var float confusionDuration;	// how long does EMP hit last?

function UpdateAIEvents()
{
	if (bActive)
	{
		// Make noise and light
		AIStartEvent('Alarm', EAITYPE_Audio, SoundVolume/255.0, 25*(SoundRadius+1));
	}
	else
	{
		// Stop making noise and light
		AIEndEvent('Alarm', EAITYPE_Audio);
	}
}

function UpdateGroup(Actor Other, Pawn Instigator, bool bActivated)
{
	local AlarmUnit unit;

	// Only do this if we have a group tag set
	if (Tag != '')
	{
		// Trigger (or untrigger) every alarm with the same tag
		foreach AllActors(Class'AlarmUnit', unit, Tag)
		{
			if (bActivated)
				unit.Trigger(Other, Instigator);
			else
				unit.UnTrigger(Other, Instigator);
		}
	}
}

function HackAction(Actor Hacker, bool bHacked)
{
	Super.HackAction(Hacker, bHacked);

	if (bHacked)
	{
		if (bActive)
		{
			UnTrigger(Hacker, Pawn(Hacker));
			bDisabled = True;
			LightType = LT_None;
			MultiSkins[1] = Texture'BlackMaskTex';
		}
/*		else		// don't actually ever set off the alarm
		{
			Trigger(Hacker, Pawn(Hacker));
			bDisabled = False;
			LightType = LT_None;
			MultiSkins[1] = Texture'PinkMaskTex';
		}*/
	}
}

function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	if (bDisabled)
		return;

	// if we've been EMP'ed, act confused
	if (bConfused)
	{
		confusionTimer += deltaTime;

		// randomly flash the light
		if (FRand() > 0.95)
			MultiSkins[1] = Texture'AlarmUnitTex2';
		else
			MultiSkins[1] = Texture'PinkMaskTex';

		if (confusionTimer > confusionDuration)
		{
			bConfused = False;
			confusionTimer = 0;
			MultiSkins[1] = Texture'AlarmUnitTex2';
		}

		return;
	}

	if (bActive)
	{
		curTime += deltaTime;
		if (curTime >= alarmTimeout)
		{
			UnTrigger(Self, None);
			return;
		}

		// flash the light and texture
		if ((Level.TimeSeconds % 0.5) > 0.25)
		{
			LightType = LT_Steady;
			MultiSkins[1] = Texture'AlarmUnitTex2';
		}
		else
		{
			LightType = LT_None;
			MultiSkins[1] = Texture'PinkMaskTex';
		}
	}
}

function Trigger(Actor Other, Pawn Instigator)
{
	local Actor A;

	if (bConfused || bDisabled)
		return;

	Super.Trigger(Other, Instigator);

	if (!bActive)
	{
		if (Instigator != None)
			Instigator.ClientMessage(msgActivated);
		bActive = True;
		AmbientSound = Sound'Klaxon2';
		SoundRadius = 64;
		SoundVolume = 128;
		curTime = 0;
		LightType = LT_Steady;
		MultiSkins[1] = Texture'AlarmUnitTex2';
		alarmInstigator = Instigator;
/* taken out for now...
		if (Instigator != None)
			alarmLocation = Instigator.Location-vect(0,0,1)*(Instigator.CollisionHeight-1);
		else
*/
			alarmLocation = Location;
		UpdateAIEvents();
		UpdateGroup(Other, Instigator, true);

		// trigger the event
		if (Event != '')
			foreach AllActors(class'Actor', A, Event)
				A.Trigger(Self, Instigator);

		// make sure we can't go into stasis while we're alarming
		bStasis = False;
	}
}

function UnTrigger(Actor Other, Pawn Instigator)
{
	if (bConfused || bDisabled)
		return;

	Super.UnTrigger(Other, Instigator);

	if (bActive)
	{
		if (Instigator != None)
			Instigator.ClientMessage(msgDeactivated);
		bActive = False;
		AmbientSound = Default.AmbientSound;
		SoundRadius = 16;
		SoundVolume = 192;
		curTime = 0;
		LightType = LT_None;
		MultiSkins[1] = Texture'PinkMaskTex';
		UpdateAIEvents();
		UpdateGroup(Other, Instigator, false);

		// reset our stasis info
		bStasis = Default.bStasis;
	}
}

auto state Active
{
	function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
	{
		if (DamageType == 'EMP')
		{
			confusionTimer = 0;
			if (!bConfused)
			{
				curTime = alarmTimeout;
				bConfused = True;
				PlaySound(sound'EMPZap', SLOT_None,,, 1280);
				UnTrigger(Self, None);
			}
			return;
		}

		Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
	}
}

defaultproperties
{
     alarmTimeout=30
     msgActivated="Alarm activated"
     msgDeactivated="Alarm deactivated"
     confusionDuration=10.000000
     HitPoints=50
     minDamageThreshold=50
     bInvincible=False
     ItemName="Alarm Sounder Panel"
     Mesh=LodMesh'DeusExDeco.AlarmUnit'
     MultiSkins(1)=Texture'DeusExItems.Skins.PinkMaskTex'
     SoundRadius=16
     SoundVolume=192
     AmbientSound=Sound'DeusExSounds.Generic.AlarmUnitHum'
     CollisionRadius=9.720000
     CollisionHeight=9.720000
     LightBrightness=255
     LightRadius=1
     Mass=10.000000
     Buoyancy=5.000000
}
