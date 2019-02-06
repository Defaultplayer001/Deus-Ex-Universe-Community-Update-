//=============================================================================
// ComputerSecurityChoice_MPCamera
//=============================================================================

class ComputerSecurityChoice_MPCamera extends ComputerCameraUIChoice;

// ----------------------------------------------------------------------
// SetCameraView()
// ----------------------------------------------------------------------

function SetCameraView(ComputerSecurityCameraWindow newCamera)
{
	Super.SetCameraView(newCamera);

	if (winCamera != None)
	{
		if (winCamera.camera != None)
		{      
         if (!winCamera.camera.bActive)
            SetValue(0);
         else if (DeusExPlayer(winCamera.camera.safetarget) == winCamera.player)
            SetValue(1);
         else if ( (winCamera.player.DXGame.IsA('TeamDMGame')) && (winCamera.player.PlayerReplicationInfo.team == winCamera.camera.team) )
            SetValue(1);
         else
            SetValue(2);       
         EnableWindow();
		}
		else
		{
			// Disable!
			DisableWindow();
			btnInfo.SetButtonText("");
		}

		if (securityWindow != None)
			securityWindow.EnableCameraButtons(winCamera.camera != None);
	}
	else
	{
		// Disable!
		DisableWindow();
		btnInfo.SetButtonText("");

		if (securityWindow != None)
			securityWindow.EnableCameraButtons(False);
	}
}

// ----------------------------------------------------------------------
// SetMPEnumState()
// ----------------------------------------------------------------------

function SetMPEnumState()
{
   local int TurretState;
   if ((winCamera != None) && (winCamera.camera != None))
   {
      TurretState = SecurityWindow.choiceWindows[3].GetValue();

      if (TurretState == 0)
         SetValue(0);
      else if (TurretState == 2)
         SetValue(1);
      else
         SetValue(2);
   }
}

// ----------------------------------------------------------------------
// ButtonActivated()
//
// If the action button was pressed, cycle to the next available
// choice (if any)
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
   local bool bWasActive;

   bWasActive = (GetValue() != 0);

   Super.ButtonActivated(buttonPressed);
   SetCameraState(bWasActive);
	//securityWindow.ToggleCameraState();
	return True;
}

// ----------------------------------------------------------------------
// ButtonActivatedRight()
// ----------------------------------------------------------------------

function bool ButtonActivatedRight( Window buttonPressed )
{
   local bool bWasActive;

   bWasActive = (GetValue() != 0);

   Super.ButtonActivated(buttonPressed);
   SetCameraState(bWasActive);
	return True;
}

// ----------------------------------------------------------------------
// SetCameraState()
// ----------------------------------------------------------------------

function SetCameraState(bool bWasActive)
{
   local bool bIsActive;

   if (securitywindow.Player.Level.Netmode != NM_Standalone)
   {
      if (GetValue() == 2)
      {
         SetValue(0);
      }
   }

   bIsActive = (GetValue() != 0);

   if (bWasActive != bIsActive)
   {
      securityWindow.ToggleCameraState(bIsActive,bWasActive);
      securityWindow.AllyCamera();
   }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     enumText(0)="Off"
     enumText(1)="Enemies"
     enumText(2)="Allies"
     actionText="|&Camera Status"
}
