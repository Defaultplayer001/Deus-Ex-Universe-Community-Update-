//=============================================================================
// ComputerScreenSecurity
//=============================================================================

class ComputerScreenSecurity expands ComputerUIWindow;

var MenuUISpecialButtonWindow    btnPanUp;
var MenuUISpecialButtonWindow    btnPanDown;
var MenuUISpecialButtonWindow    btnPanLeft;
var MenuUISpecialButtonWindow    btnPanRight;
var MenuUISpecialButtonWindow    btnZoomIn;
var MenuUISpecialButtonWindow    btnZoomOut;
var MenuUIActionButtonWindow     btnSpecial;
var MenuUIActionButtonWindow     btnLogout;
var MenuUISmallLabelWindow       winInfo;
var ComputerSecuritySliderWindow winPanSlider;
var ComputerSecurityCameraWindow winCameras[3];
var ComputerSecurityCameraWindow selectedCamera;

var Class<ComputerCameraUIChoice> choices[4];
var ComputerCameraUIChoice choiceWindows[4];
var int choiceStartX;
var int choiceStartY;
var int choiceVerticalGap;
var int choiceActionButtonWidth;
var int doorTimerID;
var int networkTimerID;
var const int panSize;
var const float zoomSize;
var const int   numPanTicks;
var const float lowPanValue;
var const float highPanValue;
var Float panMod;

var localized String ActiveWindowOptionsHeader;
var localized String CameraOptionsHeader;
var localized String PanZoomSpeedHeader;
var localized String ClickCameraWindowText;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

function InitWindow()
{
	Super.InitWindow();

	// set up the timer to auto-update the door status
	if (doorTimerID == -1)
		doorTimerID = AddTimer(0.25, True, 0, 'DoorRefreshTimer');

   // setup the timer for refreshing the screen in multiplayer
   if (networkTimerID == -1)
      networkTimerID = AddTimer(0.25, True, 0, 'NetworkRefreshTimer');
}

// ----------------------------------------------------------------------
// DestroyWindow()
//
// Destroys the Window
// ----------------------------------------------------------------------

event DestroyWindow()
{
	Super.DestroyWindow();

	if (doorTimerID != -1)
	{
		RemoveTimer(doorTimerID);
		doorTimerID = -1;
	}

   if (networkTimerID != -1)
   {
      Removetimer(networkTimerID);
      networkTimerID = -1;
   }
}

// -----------------------------------------------------------------------
// NetworkRefreshTimer
// -----------------------------------------------------------------------
function NetworkRefreshTimer(int timerID, int invocations, int clientData)
{
   local int cameraIndex;

   for (cameraIndex = 0; cameraIndex < arrayCount(winCameras); cameraIndex++)
   {
		winCameras[cameraIndex].UpdateCameraStatus();
		winCameras[cameraIndex].UpdateTurretStatus();
		winCameras[cameraIndex].UpdateDoorStatus();
   }
}

// ----------------------------------------------------------------------
// DoorRefreshTimer()
// 
// Timer function to refresh the door status text
// ----------------------------------------------------------------------

function DoorRefreshTimer(int timerID, int invocations, int clientData)
{
	winCameras[0].UpdateDoorStatus();
	winCameras[1].UpdateDoorStatus();
	winCameras[2].UpdateDoorStatus();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	btnLogout = winButtonBar.AddButton(ButtonLabelLogout, HALIGN_Right);

	CreateChoices();
	CreateCameraButtons();
	CreateCameraViewWindows();
	CreateHeaders();
	CreatePanSlider();
	CreateInfoWindow();
}

// ----------------------------------------------------------------------
// CreateCameraButtons()
// ----------------------------------------------------------------------

function CreateCameraButtons()
{
	btnPanUp    = CreateSpecialButton(335, 58, Texture'SecurityButtonPanUp_Normal',    Texture'SecurityButtonPanUp_Pressed');
	btnPanDown  = CreateSpecialButton(335, 98, Texture'SecurityButtonPanDown_Normal',  Texture'SecurityButtonPanDown_Pressed');
	btnPanLeft  = CreateSpecialButton(309, 78, Texture'SecurityButtonPanLeft_Normal',  Texture'SecurityButtonPanLeft_Pressed');
	btnPanRight = CreateSpecialButton(361, 78, Texture'SecurityButtonPanRight_Normal', Texture'SecurityButtonPanRight_Pressed');
	btnZoomIn   = CreateSpecialButton(323, 31, Texture'SecurityButtonZoomIn_Normal',   Texture'SecurityButtonZoomIn_Pressed');
	btnZoomOut  = CreateSpecialButton(349, 31, Texture'SecurityButtonZoomOut_Normal',  Texture'SecurityButtonZoomOut_Pressed');
}

// ----------------------------------------------------------------------
// CreatePanSlider()
// ----------------------------------------------------------------------

function CreatePanSlider()
{
	local MenuUIHeaderWindow winLabel;

	winPanSlider = ComputerSecuritySliderWindow(winClient.NewChild(Class'ComputerSecuritySliderWindow'));
	winPanSlider.SetPos(309, 146);
	winPanSlider.SetTicks(numPanTicks, lowPanValue, highPanValue);

	// Create a label as well

	winLabel = MenuUIHeaderWindow(winClient.NewChild(Class'MenuUIHeaderWindow'));
	winLabel.SetPos(302, 127);
	winLabel.SetWidth(94);
	winLabel.SetTextAlignments(HALIGN_Center, VALIGN_Top);
	winLabel.SetText(PanZoomSpeedHeader);
}

// ----------------------------------------------------------------------
// CreateCameraViewWindows()
// ----------------------------------------------------------------------

function CreateCameraViewWindows()
{
	winCameras[0] = ComputerSecurityCameraWindow(winClient.NewChild(Class'ComputerSecurityCameraWindow'));
	winCameras[0].SetPos(1, 175);
	winCameras[0].SetViewIndex(0);

	winCameras[1] = ComputerSecurityCameraWindow(winClient.NewChild(Class'ComputerSecurityCameraWindow'));
	winCameras[1].SetPos(208, 175);
	winCameras[1].SetViewIndex(1);

	winCameras[2] = ComputerSecurityCameraWindow(winClient.NewChild(Class'ComputerSecurityCameraWindow'));
	winCameras[2].SetPos(415, 175);
	winCameras[2].SetViewIndex(2);
}

// ----------------------------------------------------------------------
// CreateSpecialButton()
// ----------------------------------------------------------------------

function MenuUISpecialButtonWindow CreateSpecialButton(int posX, int posY, Texture texNormal, Texture texPressed)
{
	local MenuUISpecialButtonWindow winButton;

	winButton = MenuUISpecialButtonWindow(winClient.NewChild(Class'MenuUISpecialButtonWindow'));
	winButton.SetPos(posX, posY);
	winButton.SetButtonTextures(texNormal, texPressed, texNormal, texPressed, texNormal, texPressed);
	winButton.EnableAutoRepeat();

	return winButton;
}

// ----------------------------------------------------------------------
// CreateHeaders() 
// ----------------------------------------------------------------------

function CreateHeaders()
{
	local MenuUIHeaderWindow winHeader;

	winHeader = MenuUIHeaderWindow(winClient.NewChild(Class'MenuUIHeaderWindow'));
	winHeader.SetFont(Font'FontMenuTitle');
	winHeader.SetPos(12, 9);
	winHeader.SetText(ActiveWindowOptionsHeader);

	winHeader = MenuUIHeaderWindow(winClient.NewChild(Class'MenuUIHeaderWindow'));
	winHeader.SetFont(Font'FontMenuTitle');
	winHeader.SetPos(298, 9);
	winHeader.SetTextAlignments(HALIGN_Center, VALIGN_Top);
	winHeader.SetText(CameraOptionsHeader);
}

// ----------------------------------------------------------------------
// CreateChoices()
// ----------------------------------------------------------------------

function CreateChoices()
{
	local int choiceIndex;
	local int choiceCount;
	local ComputerCameraUIChoice newChoice;

	// Loop through the Menu Choices and create the appropriate buttons
   if (Player.Level.Netmode != NM_Standalone)
      choices[0]=Class'ComputerSecurityChoice_MPCamera';

	for(choiceIndex=0; choiceIndex<arrayCount(choices); choiceIndex++)
	{
		if (choices[choiceIndex] != None)
		{
			newChoice = ComputerCameraUIChoice(winClient.NewChild(choices[choiceIndex]));
			newChoice.SetPos(choiceStartX, choiceStartY + (choiceCount * choiceVerticalGap) - newChoice.buttonVerticalOffset);
			newChoice.SetActionButtonWidth(choiceActionButtonWidth);

			choiceWindows[choiceIndex] = newChoice;

			choiceCount++;
		}
	}
}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
	winInfo = MenuUISmallLabelWindow(winClient.NewChild(Class'MenuUISmallLabelWindow'));

	winInfo.SetPos(9, 398);
	winInfo.SetSize(600, 25);
	winInfo.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winInfo.SetTextMargins(0, 0);
	winInfo.SetText(ClickCameraWindowText);
}

// ----------------------------------------------------------------------
// InitCameras()
//
// 	Initialize the cameras
// ----------------------------------------------------------------------

function InitCameras()
{
	local int cameraIndex;
	local name tag;
	local SecurityCamera camera;
	local AutoTurret turret;
	local DeusExMover door;

	for (cameraIndex=0; cameraIndex<ArrayCount(winCameras); cameraIndex++)
	{
		winCameras[cameraIndex].compOwner = Computers(compOwner);
		winCameras[cameraIndex].camera = None;

		tag = ComputerSecurity(compOwner).Views[cameraIndex].cameraTag;
		if (tag != '')
		{
			foreach player.AllActors(class'SecurityCamera', camera, tag)
			{
				// force the camera to wake up
				camera.bStasis = False;
				winCameras[cameraIndex].camera = camera;
         }
		}

		winCameras[cameraIndex].turret = None;
		tag = ComputerSecurity(compOwner).Views[cameraIndex].turretTag;
		if (tag != '')
			foreach player.AllActors(class'AutoTurret', turret, tag)
				winCameras[cameraIndex].turret = turret;

		winCameras[cameraIndex].door = None;
		tag = ComputerSecurity(compOwner).Views[cameraIndex].doorTag;
		if (tag != '')
			foreach player.AllActors(class'DeusExMover', door, tag)
				winCameras[cameraIndex].door = door;

		winCameras[cameraIndex].UpdateCameraStatus();
		winCameras[cameraIndex].UpdateTurretStatus();
		winCameras[cameraIndex].UpdateDoorStatus();
		winCameras[cameraIndex].winCamera.Show();
	}

	// Select the first security camera
	SelectFirstCamera();
}

// ----------------------------------------------------------------------
// ToggleCameraState()
// ----------------------------------------------------------------------

function ToggleCameraState(optional bool bCamIsActive, optional bool bCamWasActive)
{
	local SecurityCamera cam;

	if (selectedCamera != None)
	{
		cam = selectedCamera.camera;

		if (cam != None)
		{
         player.ToggleCameraState(cam, compOwner);

			selectedCamera.UpdateCameraStatus();

         //make turret match, yes, I suck.
         if ((SelectedCamera.Turret != None) && (Player.Level.Netmode != NM_Standalone))
         {            
            //if ((selectedCamera.Turret.bActive != cam.bActive) || (selectedCamera.Turret.bDisabled == cam.bActive))
            player.SetTurretState(SelectedCamera.Turret,bCamIsActive,!bCamIsActive);
            selectedCamera.UpdateTurretStatus();
            ComputerSecurityChoice_Turret(choiceWindows[3]).SetMPEnumState();
         }         
		}
	}
}

// ----------------------------------------------------------------------
// AllyCamera()
// ----------------------------------------------------------------------

function AllyCamera()
{
	local SecurityCamera cam;

	if (selectedCamera != None)
	{
		cam = selectedCamera.camera;

		if (cam != None)
		{
         player.MakeCameraAlly(cam);
			selectedCamera.UpdateCameraStatus();
		}
      if ((selectedCamera.turret != None) && (Player.Level.Netmode != NM_Standalone))
      {
         player.SetTurretTrackMode(ComputerSecurity(selectedCamera.compOwner),selectedCamera.turret,false,true);
         selectedCamera.UpdateTurretStatus();
         ComputerSecurityChoice_Turret(choiceWindows[3]).SetMPEnumState();
      }
	}
}

// ----------------------------------------------------------------------
// ToggleDoorLock()
// ----------------------------------------------------------------------

function ToggleDoorLock()
{
	local DeusExMover M;

	if ((selectedCamera != None) && (selectedCamera.door != None))
	{
		// be sure to lock/unlock all matching tagged doors
		foreach player.AllActors(class'DeusExMover', M, selectedCamera.door.Tag)
			M.bLocked = !M.bLocked;

		selectedCamera.UpdateDoorStatus();
	}
}

// ----------------------------------------------------------------------
// TriggerDoor()
// ----------------------------------------------------------------------

function TriggerDoor()
{
	local DeusExMover M;

	if ((selectedCamera != None) && (selectedCamera.door != None))
	{
		// be sure to trigger all matching tagged doors
		foreach player.AllActors(class'DeusExMover', M, selectedCamera.door.Tag)
			M.Trigger(compOwner, player);

		selectedCamera.UpdateDoorStatus();
	}
}

// ----------------------------------------------------------------------
// SetTurretState()
// ----------------------------------------------------------------------

function SetTurretState(bool bActive, bool bDisabled)
{
	if ((selectedCamera != None) && (selectedCamera.turret != None))
	{
      player.SetTurretState(selectedCamera.turret,bActive,bDisabled);
      selectedCamera.UpdateTurretStatus();

      //make camera match
      if ((SelectedCamera.Camera != None) && (Player.Level.Netmode != NM_Standalone))
      {
         if (selectedCamera.camera.bActive != bActive)
            player.ToggleCameraState(selectedCamera.camera, compOwner);
         selectedCamera.UpdateCameraStatus();
         ComputerSecurityChoice_MPCamera(choiceWindows[0]).SetMPEnumState();
      }
	}
}

// ----------------------------------------------------------------------
// SetTurretTrackMode()
// ----------------------------------------------------------------------

function SetTurretTrackMode(bool bTrackPlayers, bool bTrackPawns)
{
	if ((selectedCamera != None) && (selectedCamera.turret != None))
	{
      player.SetTurretTrackMode(ComputerSecurity(selectedCamera.compOwner),selectedCamera.turret,bTrackPlayers,bTrackPawns);
		selectedCamera.UpdateTurretStatus();

      if ((selectedCamera.camera != None) && (Player.Level.Netmode != NM_Standalone))
      {
         player.MakeCameraAlly(selectedCamera.camera);
         selectedCamera.UpdateCameraStatus();
         ComputerSecurityChoice_MPCamera(choiceWindows[0]).SetMPEnumState();
      }
	}
}

// ----------------------------------------------------------------------
// SelectFirstCamera()
// ----------------------------------------------------------------------

function SelectFirstCamera()
{
	local int  cameraIndex;
	local bool bCameraSelected;

/*
	for(cameraIndex=0; cameraIndex<arrayCount(winCameras); cameraIndex++)
	{
		if (winCameras[cameraIndex].camera != None)
		{	
			winCameras[cameraIndex].btnCamera.PressButton(IK_None);
			bCameraSelected = True;
			break;
		}
	}

	if (!bCameraSelected)
		SelectCamera(None);
*/
	// Always want to select the first camera, even if it's static
	// (as doors can still be controlled)

	winCameras[0].btnCamera.PressButton(IK_None);
	bCameraSelected = True;
}

// ----------------------------------------------------------------------
// SetCompOwner()
// ----------------------------------------------------------------------

function SetCompOwner(ElectronicDevices newCompOwner)
{
	Super.SetCompOwner(newCompOwner);

	InitCameras();
}

// ----------------------------------------------------------------------
// SetNetworkTerminal()
// ----------------------------------------------------------------------

function SetNetworkTerminal(NetworkTerminal newTerm)
{
	Super.SetNetworkTerminal(newTerm);

	if (winTerm.AreSpecialOptionsAvailable())
	{
		btnSpecial = winButtonBar.AddButton(ButtonLabelSpecial, HALIGN_Left);
		CreateLeftEdgeWindow();
	}

	// Check the user's skill level and possibly disable the Turret button
	// if the user Hacked into the computer.
	//
	// Turrets are only usable at Advanced or higher 

   // DEUS_EX AMSD in multiplayer, all hackers can affect turrets

   if (Player.Level.NetMode == NM_Standalone)
   {
      if ((winTerm.GetSkillLevel()  < 2) && (winTerm.bHacked))
         choiceWindows[3].DisableChoice();
   }
}

// -----------------------------------------------------------------------
// EnableCameraButtons()
//  ----------------------------------------------------------------------

function EnableCameraButtons(bool bEnable)
{
	if (btnPanUp != None)
	{
		btnPanUp.EnableWindow(bEnable);
		btnPanDown.EnableWindow(bEnable);  
		btnPanLeft.EnableWindow(bEnable);  
		btnPanRight.EnableWindow(bEnable);  
		btnZoomIn.EnableWindow(bEnable);  
		btnZoomOut.EnableWindow(bEnable);  
	}
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	bHandled = True;

	// First check if it's one of our camera buttons
	if (buttonPressed.IsA('ComputerSecurityCameraViewButton'))
	{
		SelectCamera(ComputerSecurityCameraWindow(buttonPressed.GetParent()));
	}
	else
	{
		switch( buttonPressed )
		{
			case btnPanUp:
				PanCamera(IK_Up);
				break;

			case btnPanDown:
				PanCamera(IK_Down);
				break;

			case btnPanLeft:
				PanCamera(IK_Left);
				break;

			case btnPanRight:
				PanCamera(IK_Right);
				break;

			case btnZoomIn:
				PanCamera(IK_GreyPlus);
				break;

			case btnZoomOut: 
				PanCamera(IK_GreyMinus);
				break;

			case btnSpecial:
				CloseScreen("SPECIAL");
				break;

			case btnLogout:
				CloseScreen("LOGOUT");
				break;

			default:
				bHandled = False;
				break;
		}
	}

	if (bHandled)
		return True;
	else
		return Super.ButtonActivated(buttonPressed);
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bKeyHandled;

	bKeyHandled = True;

	switch(key)
	{
		case IK_Left:		
		case IK_Right:		
		case IK_Up:			
		case IK_Down:		
		case IK_GreyPlus:
		case IK_Equals:		
		case IK_GreyMinus:
		case IK_Minus:		
			PanCamera(key);
			break;

		case IK_1:
			winCameras[0].btnCamera.PressButton();
			break;
		case IK_2:
			winCameras[1].btnCamera.PressButton();
			break;
		case IK_3:
			winCameras[2].btnCamera.PressButton();
			break;

		default:
			bKeyHandled = False;
			break;
	}

	if (!bKeyHandled)
		return Super.VirtualKeyPressed(key, bRepeat);
	else
		return bKeyHandled;
}

// ----------------------------------------------------------------------
// ScalePositionChanged() : Called when an ancestor scale window's
//                          position is moved
// ----------------------------------------------------------------------

event bool ScalePositionChanged(Window scale, int newTickPosition,
                                float newValue, bool bFinal)
{
	panMod = newValue;
	return True;
}

// ----------------------------------------------------------------------
// SelectCamera()
// ----------------------------------------------------------------------

function SelectCamera(ComputerSecurityCameraWindow newCamera)
{
	if (newCamera != selectedCamera)
	{
		if (selectedCamera != None)
			selectedCamera.btnCamera.SelectButton(False);
		
		selectedCamera = newCamera;

		if (selectedCamera != None)
			selectedCamera.btnCamera.SelectButton(True);
	}
	UpdateActionButtons();
}

// ----------------------------------------------------------------------
// UpdateActionButtons()
// ----------------------------------------------------------------------

function UpdateActionButtons()
{
	local int choiceIndex;

	for (choiceIndex=0; choiceIndex<arrayCount(choices); choiceIndex++)
	{
		choiceWindows[choiceIndex].SetSecurityWindow(Self);
		choiceWindows[choiceIndex].SetCameraView(selectedCamera);
	}
}

// ----------------------------------------------------------------------
// PanCamera()
// ----------------------------------------------------------------------

function PanCamera(EInputKey key)
{
	local bool bKeyHandled;
	local Rotator rot;
	local float fov;
	local float localPanMod;

	if (selectedCamera == None)
		return;

	localPanMod = panMod;


	if (IsKeyDown(IK_Shift))
		localPanMod = Max(localPanMod * 2, 5.0);

   // DEUS_EX AMSD Use replicated rotation.
	rot = selectedCamera.camera.ReplicatedRotation;
	fov = selectedCamera.winCamera.fov;

	switch(key)
	{
		case IK_Left:		rot.Yaw -= localPanMod * panSize * (fov / 90.0);
							break;

		case IK_Right:		rot.Yaw += localPanMod * panSize * (fov / 90.0);
							break;

		case IK_Up:			rot.Pitch += localPanMod * panSize * (fov / 90.0);
							break;

		case IK_Down:		rot.Pitch -= localPanMod * panSize * (fov / 90.0);
							break;

		case IK_GreyPlus:
		case IK_Equals:		fov -= localPanMod * zoomSize;
							break;

		case IK_GreyMinus:
		case IK_Minus:		fov += localPanMod * zoomSize;
							break;
	}

   player.UpdateCameraRotation(selectedCamera.camera,rot);
	//selectedCamera.camera.DesiredRotation = rot;

	// limit the zoom level
	fov = FClamp(fov, 5, 90);
	selectedCamera.winCamera.SetFOVAngle(fov);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     choices(0)=Class'DeusEx.ComputerSecurityChoice_Camera'
     choices(1)=Class'DeusEx.ComputerSecurityChoice_DoorAccess'
     choices(2)=Class'DeusEx.ComputerSecurityChoice_DoorOpen'
     choices(3)=Class'DeusEx.ComputerSecurityChoice_Turret'
     choiceStartX=13
     choiceStartY=30
     choiceVerticalGap=34
     choiceActionButtonWidth=143
     doorTimerID=-1
     networkTimerID=-1
     panSize=256
     zoomSize=2.000000
     numPanTicks=9
     lowPanValue=1.000000
     highPanValue=5.000000
     ActiveWindowOptionsHeader="Active Window Options"
     CameraOptionsHeader="Camera Options"
     PanZoomSpeedHeader="Pan/Zoom Speed"
     ClickCameraWindowText="Click on a camera view to select that camera."
     escapeAction="LOGOUT"
     Title="Surveillance"
     ClientWidth=622
     ClientHeight=435
     clientTextures(0)=Texture'DeusExUI.UserInterface.ComputerSecurityBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.ComputerSecurityBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.ComputerSecurityBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.ComputerSecurityBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.ComputerSecurityBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.ComputerSecurityBackground_6'
     textureRows=2
     textureCols=3
     bUsesStatusWindow=False
     bAlwaysCenter=True
     ComputerNodeFunctionLabel="Security"
}
