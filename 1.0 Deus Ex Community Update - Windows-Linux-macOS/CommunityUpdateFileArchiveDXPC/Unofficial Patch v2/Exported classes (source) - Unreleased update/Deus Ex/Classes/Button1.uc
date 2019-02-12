//=============================================================================
// Button1.
//=============================================================================
class Button1 extends DeusExDecoration;

enum EButtonType
{
	BT_Up,
	BT_Down,
	BT_1,
	BT_2,
	BT_3,
	BT_4,
	BT_5,
	BT_6,
	BT_7,
	BT_8,
	BT_9,
	BT_Blank
};

var() EButtonType ButtonType;
var() float buttonLitTime;
var() sound buttonSound1;
var() sound buttonSound2;
var() bool bLit;
var() bool bWaitForEvent;
var bool isPressed;

var Vector	lastLoc, rpcLocation;
var bool		bIsMoving;

replication 
{
	reliable if ( Role == ROLE_Authority )
		rpcLocation;
}

// WOW! What a mess.  I wish you could convert strings to names!
function SetSkin(EButtonType type, bool lit)
{
	switch (type)
	{
		case BT_Up:			if (lit)
							{
								Skin = Texture'Button1Tex2';
								ScaleGlow = 3.0;
							}
							else
							{
								Skin = Texture'Button1Tex1';
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_Down:		if (lit)
							{
								Skin = Texture'Button1Tex4';
								ScaleGlow = 3.0;
							}
							else
							{
								Skin = Texture'Button1Tex3';
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_1:			if (lit)
							{
								Skin = Texture'Button1Tex6';
								ScaleGlow = 3.0;
							}
							else
							{
								Skin = Texture'Button1Tex5';
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_2:			if (lit)
							{
								Skin = Texture'Button1Tex8';
								ScaleGlow = 3.0;
							}
							else
							{
								Skin = Texture'Button1Tex7';
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_3:			if (lit)
							{
								Skin = Texture'Button1Tex10';
								ScaleGlow = 3.0;
							}
							else
							{
								Skin = Texture'Button1Tex9';
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_4:			if (lit)
							{
								Skin = Texture'Button1Tex12';
								ScaleGlow = 3.0;
							}
							else
							{
								Skin = Texture'Button1Tex11';
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_5:			if (lit)
							{
								Skin = Texture'Button1Tex14';
								ScaleGlow = 3.0;
							}
							else
							{
								Skin = Texture'Button1Tex13';
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_6:			if (lit)
							{
								Skin = Texture'Button1Tex16';
								ScaleGlow = 3.0;
							}
							else
							{
								Skin = Texture'Button1Tex15';
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_7:			if (lit)
							{
								Skin = Texture'Button1Tex18';
								ScaleGlow = 3.0;
							}
							else
							{
								Skin = Texture'Button1Tex17';
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_8:			if (lit)
							{
								Skin = Texture'Button1Tex20';
								ScaleGlow = 3.0;
							}
							else
							{
								Skin = Texture'Button1Tex19';
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_9:			if (lit)
							{
								Skin = Texture'Button1Tex22';
								ScaleGlow = 3.0;
							}
							else
							{
								Skin = Texture'Button1Tex21';
								ScaleGlow = Default.ScaleGlow;
							}
							break;
		case BT_Blank:		if (lit)
							{
								Skin = Texture'Button1Tex24';
								ScaleGlow = 3.0;
							}
							else
							{
								Skin = Texture'Button1Tex23';
								ScaleGlow = Default.ScaleGlow;
							}
							break;
	}
}

function BeginPlay()
{
	Super.BeginPlay();

	SetSkin(ButtonType, bLit);

	if ( Level.NetMode != NM_Standalone )
		rpcLocation = Location;
}

function Trigger(Actor Other, Pawn Instigator)
{
	if (bWaitForEvent)
		Timer();
}

function Timer()
{
	PlaySound(buttonSound2, SLOT_None);
	SetSkin(ButtonType, bLit);
	isPressed = False;
	bUnlit = False;
}

function Frob(Actor Frobber, Inventory frobWith)
{
	if (!isPressed)
	{
		isPressed = True;
		PlaySound(buttonSound1, SLOT_None);
		SetSkin(ButtonType, !bLit);
		bUnlit = True;
		if (!bWaitForEvent)
			SetTimer(buttonLitTime, False);

		Super.Frob(Frobber, frobWith);
	}
}

singular function SupportActor(Actor standingActor)
{
	// do nothing
}

function Bump(actor Other)
{
	// do nothing
}

simulated function Tick( float deltaTime )
{						  	
	if ( Level.NetMode != NM_Standalone )
	{
		if ( Role == ROLE_Authority )
		{
			// Was moving, now at rest
			if ( bIsMoving && ( Location == lastLoc ))
				rpcLocation = Location;

			bIsMoving = ( Location != lastLoc );
			lastLoc = Location;
		}
		else
		{
			// Our replicated location changed which means the button has come to rest
			if ( lastLoc != rpcLocation )
			{
				SetLocation( rpcLocation );
				lastLoc = rpcLocation;
			}
		}
	}
	Super.Tick( deltaTime );
}

defaultproperties
{
     ButtonType=BT_Blank
     buttonLitTime=0.500000
     buttonSound1=Sound'DeusExSounds.Generic.Beep1'
     bInvincible=True
     ItemName="Button"
     bPushable=False
     Physics=PHYS_None
     RemoteRole=ROLE_SimulatedProxy
     Mesh=LodMesh'DeusExDeco.Button1'
     CollisionRadius=2.000000
     CollisionHeight=2.000000
     bCollideWorld=False
     bBlockActors=False
     Mass=5.000000
     Buoyancy=2.000000
}
