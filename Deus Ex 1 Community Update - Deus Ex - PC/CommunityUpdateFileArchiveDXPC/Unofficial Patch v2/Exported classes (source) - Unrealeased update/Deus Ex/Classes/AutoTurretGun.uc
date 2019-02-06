//=============================================================================
// AutoTurretGun.
//=============================================================================
class AutoTurretGun extends HackableDevices;

var int		team;
var String	titleString;
var float	updateTime;

replication
{
	reliable if (Role==ROLE_Authority)
		team, titleString;
}

function Destroyed()
{
	local AutoTurret turret;

	turret = AutoTurret(Owner);
	if (turret != None)
	{
		turret.gun = None;
		turret.Destroy();
		SetOwner(None);
	}
	Super.Destroyed();		
}

function ResetComputerAlignment()
{
	local AutoTurret turret;
	local ComputerSecurity TempComp;
	local int ViewIndex;

	turret = AutoTurret(Owner);

	if (( Level.NetMode != NM_Standalone ) && ( turret != None ))
	{
		//Find the associated computer
		foreach AllActors(class'ComputerSecurity',TempComp)
		{
			for (ViewIndex = 0; ViewIndex < ArrayCount(TempComp.Views); ViewIndex++)
			{
				if (TempComp.Views[ViewIndex].turretTag == turret.Tag)
				{
					TempComp.Team = -1;
				}
			}
		}
	}
}

function HackAction(Actor Hacker, bool bHacked)
{
   local ComputerSecurity CompOwner;
   local ComputerSecurity TempComp;
	local AutoTurret turret;
   local SecurityCamera Camera;
   local name CameraTag;
   local int ViewIndex;

	Super.HackAction(Hacker, bHacked);

	turret = AutoTurret(Owner);
	if (bHacked && (turret != None))
	{
      if (Level.NetMode == NM_Standalone)
      {
         if (!turret.bDisabled)
         {
            turret.UnTrigger(Hacker, Pawn(Hacker));
            turret.bDisabled = True;
         }
         else
         {
            turret.bDisabled = False;
            turret.Trigger(Hacker, Pawn(Hacker));
         }
      }
      else
      {
         //DEUS_EX AMSD Reset the hackstrength afterwards
         if (hackStrength == 0.0)
            hackStrength = 0.6;
         turret.bDisabled = True;
         turret.Trigger(Hacker,Pawn(Hacker));
         //Find the associated computer.
         foreach AllActors(class'ComputerSecurity',TempComp)
         {
            for (ViewIndex = 0; ViewIndex < ArrayCount(TempComp.Views); ViewIndex++)
            {
               if (TempComp.Views[ViewIndex].turretTag == Turret.Tag)
               {
                  CompOwner = TempComp;
                  //find associated turret
                  cameratag = TempComp.Views[ViewIndex].cameratag;
                  if (cameratag != '')
                  {
                     foreach AllActors(class'Securitycamera', camera, cameraTag)
                     {
                        break;
                     }
                  }
               }
            }
         }

         if (CompOwner != None)
         {
            if ( (Hacker.IsA('DeusExPlayer')) && (Camera.bActive))
            {
               Camera.HackStrength = 0.6;
               if (Camera.bActive)
                  Camera.UnTrigger(Hacker, Pawn(Hacker));
            }
         }
      }
	}
}

function Tick(float deltaTime)
{
	local AutoTurret turret;

	Super.Tick(deltaTime);

	// As a client, it was possible for the turret to become irrelevant to you while the gun remained relevant
	if  ((Level.NetMode != NM_Standalone) && (updateTime < Level.Timeseconds))
	{
		updateTime = Level.Timeseconds + 2.0;
		turret = AutoTurret(Owner);
		if ( turret != None )
		{
			if ( team != turret.team )
				team = turret.team;
			if (!( titleString ~= turret.titleString ))
				titleString = turret.titleString;
		}
	}
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
{
	if (( Level.NetMode != NM_Standalone ) && (EventInstigator.IsA('DeusExPlayer')))
		DeusExPlayer(EventInstigator).ServerConditionalNotifyMsg( DeusExPlayer(EventInstigator).MPMSG_TurretInv );

	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
}

function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
	{
		bInvincible = True;
      hackStrength = 0.6;
	}
}

function PostBeginPlay()
{
	local AutoTurret turret;

	Super.PostBeginPlay();

	turret = AutoTurret(Owner);

	if (( Level.NetMode != NM_Standalone ) && ( turret != None ))
	{
		team = turret.team;
		titleString = turret.titleString;
	}
}

defaultproperties
{
     Team=-1
     hackStrength=0.500000
     HitPoints=50
     minDamageThreshold=50
     bInvincible=False
     FragType=Class'DeusEx.MetalFragment'
     ItemName="Autonomous Defense Turret"
     Physics=PHYS_Rotating
     Mesh=LodMesh'DeusExDeco.AutoTurretGun'
     PrePivot=(Z=-8.770000)
     SoundRadius=24
     CollisionRadius=22.500000
     CollisionHeight=9.100000
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=28
     LightSaturation=160
     LightRadius=2
     bRotateToDesired=True
     Mass=50.000000
     Buoyancy=10.000000
     RotationRate=(Pitch=16384,Yaw=16384)
     bVisionImportant=True
}
