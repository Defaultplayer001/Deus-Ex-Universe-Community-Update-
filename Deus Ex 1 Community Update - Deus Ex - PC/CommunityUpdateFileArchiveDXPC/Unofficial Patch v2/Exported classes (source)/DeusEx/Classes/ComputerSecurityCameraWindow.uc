//=============================================================================
// ComputerSecurityCameraWindow
//=============================================================================

class ComputerSecurityCameraWindow extends Window;

var DeusExRootWindow root;							// Keep a pointer to the root window handy
var DeusExPlayer player;							// Keep a pointer to the player for easy reference
var Computers    compOwner;							// what computer owns this window?

var ComputerSecurityCameraViewButton btnCamera;
var MenuUIHeaderWindow winTitle;
var MenuUIHeaderWindow winCameraStatus;
var MenuUIHeaderWindow winDoorStatus;
var MenuUIHeaderWindow winTurretStatus;
var int                viewIndex;

var ViewportWindow	winCamera;
var SecurityCamera	camera;
var AutoTurret		turret;
var DeusExMover		door;

var localized string CameraLabel;
var localized string CameraStatusLabel;
var localized string DoorStatusLabel;
var localized string TurretStatusLabel;
var localized string OnLabel;
var localized string OffLabel;
var localized string FriendlyLabel;
var localized string HostileLabel;
var localized string DisabledLabel;
var localized string AttackingAlliesLabel;
var localized string AttackingEnemiesLabel;
var localized string AttackingEverythingLabel;
var localized String NoSignalLabel;
var localized String OpenLabel;
var localized String ClosedLabel;
var localized String LockedLabel;
var localized String UnlockedLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Get a pointer to the root window
	root = DeusExRootWindow(GetRootWindow());

	// Get a pointer to the player
	player = DeusExPlayer(root.parentPawn);

	SetSize(202, 213);
	CreateControls();	
}

// ----------------------------------------------------------------------
// DestroyWindow()
//
// Destroys the Window
// ----------------------------------------------------------------------

event DestroyWindow()
{
	if (camera != None)
		camera.bStasis = camera.Default.bStasis;

	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	CreateTitle();
	CreateStatusLabels();	
	CreateCameraButton();
	CreateViewportWindow();
}

// ----------------------------------------------------------------------
// CreateTitle()
// ----------------------------------------------------------------------

function CreateTitle()
{
	winTitle = CreateLabel(2, "");
}

// ----------------------------------------------------------------------
// CreateStatusLabels()
// ----------------------------------------------------------------------

function CreateStatusLabels()
{
	winCameraStatus = CreateLabel(171, CameraStatusLabel);
	winDoorStatus   = CreateLabel(186, DoorStatusLabel);
	winTurretStatus = CreateLabel(201, TurretStatusLabel);
}

// ----------------------------------------------------------------------
// CreateLabel()
// ----------------------------------------------------------------------

function MenuUIHeaderWindow CreateLabel(int posY, string labelText)
{
	local MenuUIHeaderWindow newLabel;

	newLabel = MenuUIHeaderWindow(NewChild(Class'MenuUIHeaderWindow'));
	newLabel.SetPos(6, posY);
	newLabel.SetText(labelText);

	return newLabel;
}

// ----------------------------------------------------------------------
// CreateCameraButton()
// ----------------------------------------------------------------------

function CreateCameraButton()
{
	btnCamera = ComputerSecurityCameraViewButton(NewChild(Class'ComputerSecurityCameraViewButton'));
	btnCamera.SetPos(0, 16);
}

// ----------------------------------------------------------------------
// CreateViewportWindow()
// ----------------------------------------------------------------------

function CreateViewportWindow()
{
	winCamera = ViewportWindow(NewChild(class'ViewportWindow', False));
	winCamera.SetSize(200, 150);
	winCamera.SetPos(1, 17);
}

// ----------------------------------------------------------------------
// SetTitle()
// ----------------------------------------------------------------------

function SetTitle(String newTitle)
{
	winTitle.SetText(newTitle);	
}

// ----------------------------------------------------------------------
// SetViewIndex()
// ----------------------------------------------------------------------

function SetViewIndex(int newViewIndex)
{
	viewIndex = newViewIndex;
}

// ----------------------------------------------------------------------
// HideCameraLabels()
// ----------------------------------------------------------------------

function HideCameraLabels()
{
	winCameraStatus.Hide();
	winDoorStatus.Hide();
	winTurretStatus.Hide();
}

// ----------------------------------------------------------------------
// UpdateCameraStatus()
// ----------------------------------------------------------------------

function UpdateCameraStatus()
{
	if (camera == None)
	{
		winCamera.EnableViewport(False);
		winCamera.Lower();
		btnCamera.SetStatic();
		SetTitle(NoSignalLabel);
		winCameraStatus.Hide();
		HideCameraLabels();
	}
	else
	{
		winCamera.SetViewportActor(camera);
		winCamera.EnableViewport(True);
		winCamera.SetDefaultTexture(None);
		winCamera.Lower();
		SetTitle(CameraLabel @ "|&" $ String(viewIndex + 1) @ ":" @ ComputerSecurity(compOwner).Views[viewIndex].titleString);
		winCameraStatus.Show();
		SetCameraStatus(camera.bActive);
	}
}

// ----------------------------------------------------------------------
// ShowTurretLabel()
// ----------------------------------------------------------------------

function ShowTurretLabel(bool bNewShow)
{
	winTurretStatus.Show(bNewShow);
}

// ----------------------------------------------------------------------
// UpdateTurretStatus()
// ----------------------------------------------------------------------

function UpdateTurretStatus()
{
	local string str;

	if (turret == None)
	{
		ShowTurretLabel(False);
	}
	else if (player.level.netmode == NM_Standalone)
	{
		ShowTurretLabel(True);

		str = TurretStatusLabel;

		if (turret.bDisabled)
			str = str @ DisabledLabel;

		else if (turret.bTrackPlayersOnly)
			str = str @ AttackingAlliesLabel;

		else if (turret.bTrackPawnsOnly)
			str = str @ AttackingEnemiesLabel;

		else
			str = str @ AttackingEverythingLabel;

		winTurretStatus.SetText(str);
	}
   else
   {
      ShowTurretLabel(True);

      str = TurretStatusLabel;

      // if disabled, disabled.
      // if our player is safe, attacking enemies
      // if it is our team, attacking enemies.
      // otherwise, attacking allies.
   
      if (turret.bDisabled)
         str = str @ DisabledLabel;

      else if (DeusExPlayer(turret.safetarget) == player)
         str = str @ AttackingEnemiesLabel;

      else if ( (TeamDMGame(player.DXGame) != None) && (player.PlayerReplicationInfo.team == turret.team) )
         str = str @ AttackingEnemiesLabel;
      
      else
         str = str @ AttackingAlliesLabel;

      winTurretStatus.SetText(str);
   }
}

// ----------------------------------------------------------------------
// SetCameraStatus()
// ----------------------------------------------------------------------

function SetCameraStatus(bool bOn)
{
   if (Player.Level.Netmode == NM_Standalone)
   {
      if (bOn)
         winCameraStatus.SetText(CameraStatusLabel @ OnLabel);
      else
         winCameraStatus.SetText(CameraStatusLabel @ OffLabel);
   }
   else
   {
      if (!bOn)
         winCameraStatus.SetText(CameraStatusLabel @ OffLabel);
      
      else if (DeusExPlayer(camera.safetarget) == player)
         winCameraStatus.SetText(CameraStatusLabel @ FriendlyLabel);

      else if ( (TeamDMGame(player.DXGame) != None) && (player.PlayerReplicationInfo.team == camera.team) )
         winCameraStatus.SetText(CameraStatusLabel @ FriendlyLabel);

      else
         winCameraStatus.SetText(CameraStatusLabel @ HostileLabel);
   }
}

// ----------------------------------------------------------------------
// ShowDoorLabel()
// ----------------------------------------------------------------------

function ShowDoorLabel(bool bNewShow)
{
	winDoorStatus.Show(bNewShow);
}

// ----------------------------------------------------------------------
// UpdateDoorStatus()
// ----------------------------------------------------------------------

function UpdateDoorStatus()
{
	local string str;
	local int i;

	if ((door == None) || (door.bDestroyed))
	{
		ShowDoorLabel(False);		
	}
	else
	{
		ShowDoorLabel(True);		

		str = DoorStatusLabel;

		if (door.KeyNum != 0)
			str = str @ OpenLabel;
		else
			str = str @ ClosedLabel;

		str = str $ ",";

		if (door.bLocked)
			str = str @ LockedLabel;
		else
			str = str @ UnlockedLabel;

		winDoorStatus.SetText(str);
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     CameraLabel="Camera"
     CameraStatusLabel="Camera:"
     DoorStatusLabel="Door:"
     TurretStatusLabel="Turret:"
     OnLabel="On"
     OffLabel="Off"
     FriendlyLabel="Detecting Enemies"
     HostileLabel="Detecting Allies"
     DisabledLabel="Bypassed"
     AttackingAlliesLabel="Attacking Allies"
     AttackingEnemiesLabel="Attacking Enemies"
     AttackingEverythingLabel="Attacking Everything"
     NoSignalLabel="NO SIGNAL"
     OpenLabel="Open"
     ClosedLabel="Closed"
     LockedLabel="Locked"
     UnlockedLabel="Unlocked"
}
