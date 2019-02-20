//=============================================================================
// AugLight.
//=============================================================================
class AugLight extends Augmentation;

var Beam b1, b2;

function PreTravel()
{
	// make sure we destroy the light before we travel
	if (b1 != None)
		b1.Destroy();
	if (b2 != None)
		b2.Destroy();
	b1 = None;
	b2 = None;
}

function SetBeamLocation()
{
	local float dist, size, radius, brightness;
	local Vector HitNormal, HitLocation, StartTrace, EndTrace;

	if (b1 != None)
	{
		StartTrace = Player.Location;
		StartTrace.Z += Player.BaseEyeHeight;
		EndTrace = StartTrace + LevelValues[CurrentLevel] * Vector(Player.ViewRotation);

		Trace(HitLocation, HitNormal, EndTrace, StartTrace, True);
		if (HitLocation == vect(0,0,0))
			HitLocation = EndTrace;

		dist       = VSize(HitLocation - StartTrace);
		size       = fclamp(dist/LevelValues[CurrentLevel], 0, 1);
		radius     = size*5.12 + 4.0;
		brightness = fclamp(size-0.5, 0, 1)*2*-192 + 192;
		b1.SetLocation(HitLocation-vector(Player.ViewRotation)*64);
		b1.LightRadius     = byte(radius);
		//b1.LightBrightness = byte(brightness);  // someday we should put this back in again
		b1.LightType       = LT_Steady;
	}
}

function vector SetGlowLocation()
{
	local vector pos;

	if (b2 != None)
	{
		pos = Player.Location + vect(0,0,1)*Player.BaseEyeHeight +
		      vect(1,1,0)*vector(Player.Rotation)*Player.CollisionRadius*1.5;
		b2.SetLocation(pos);
	}
}

state Active
{
	function Tick (float deltaTime)
	{
		SetBeamLocation();
		SetGlowLocation();
	}
	
	function BeginState()
	{
		Super.BeginState();

		b1 = Spawn(class'Beam', Player, '', Player.Location);
		if (b1 != None)
		{
			AIStartEvent('Beam', EAITYPE_Visual);
			b1.LightHue = 32;
			b1.LightRadius = 4;
			b1.LightSaturation = 140;
			b1.LightBrightness = 192;
			SetBeamLocation();
		}
		b2 = Spawn(class'Beam', Player, '', Player.Location);
		if (b2 != None)
		{
			b2.LightHue = 32;
			b2.LightRadius = 4;
			b2.LightSaturation = 140;
			b2.LightBrightness = 220;
			SetGlowLocation();
		}
	}

Begin:
}

function Deactivate()
{
	Super.Deactivate();
	if (b1 != None)
		b1.Destroy();
	if (b2 != None)
		b2.Destroy();
	b1 = None;
	b2 = None;
}

defaultproperties
{
     EnergyRate=10.000000
     MaxLevel=0
     Icon=Texture'DeusExUI.UserInterface.AugIconLight'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconLight_Small'
     AugmentationName="Light"
     Description="Bioluminescent cells within the retina provide coherent illumination of the agent's field of view.|n|nNO UPGRADES"
     LevelValues(0)=1024.000000
     AugmentationLocation=LOC_Default
     MPConflictSlot=10
}
